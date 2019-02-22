Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09F79211CD60A
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 19:59:03 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id e7so711395oia.8
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 19:59:03 -0800 (PST)
MIME-Version: 1.0
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49ftsgsnzp.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ftsgsnzp.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Feb 2019 19:58:51 -0800
Message-ID: <CAPcyv4h9s1jYROGqkMfKk0MNBUedP=vQ1nJObLRwFiTB405nOg@mail.gmail.com>
Subject: Re: [PATCH 7/7] libnvdimm/pfn: Fix 'start_pad' implementation
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

[ add linux-mm ]


On Thu, Feb 21, 2019 at 3:47 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Hi, Dan,
>
> Thanks for the comprehensive write-up.  Comments below.
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > In the beginning the pmem driver simply passed the persistent memory
> > resource range to memremap and was done. With the introduction of
> > devm_memremap_pages() and vmem_altmap the implementation needed to
> > contend with metadata at the start of the resource to indicate whether
> > the vmemmap is located in System RAM or Persistent Memory, and reserve
> > vmemmap capacity in pmem for the latter case.
> >
> > The indication of metadata space was communicated in the
> > nd_pfn->data_offset property and it was defined to be identical to the
> > pmem_device->data_offset property, i.e. relative to the raw resource
> > base of the namespace. Up until this point in the driver's development
> > pmem_device->phys_addr == __pa(pmem_device->virt_addr). This
> > implementation was fine up until the discovery of platforms with
> > physical address layouts that mapped Persistent Memory and System RAM to
> > the same Linux memory hotplug section (128MB span).
> >
> > The nd_pfn->start_pad and nd_pfn->end_trunc properties were introduced
> > to pad and truncate the capacity to fit within an exclusive Linux
> > memory hotplug section span, and it was at this point where the
> > ->start_pad definition did not comprehend the pmem_device->phys_addr to
> > pmem_device->virt_addr relationship. Platforms in the wild typically
> > only collided 'System RAM' at the end of the Persistent Memory range so
> > ->start_pad was often zero.
> >
> > Lately Linux has encountered platforms that collide Persistent Memory
> > regions between each other, specifically cases where ->start_pad needed
> > to be non-zero. This lead to commit ae86cbfef381 "libnvdimm, pfn: Pad
> > pfn namespaces relative to other regions". That commit allowed
> > namespaces to be mapped with devm_memremap_pages(). However dax
> > operations on those configurations currently fail if attempted within the
> > ->start_pad range because pmem_device->data_offset was still relative to
> > raw resource base not relative to the section aligned resource range
> > mapped by devm_memremap_pages().
> >
> > Luckily __bdev_dax_supported() caught these failures and simply disabled
> > dax.
>
> Let me make sure I understand the current state of things.  Assume a
> machine with two persistent memory ranges overlapping the same hotplug
> memory section.  Let's take the example from the ndctl github issue[1]:
>
> 187c000000-967bffffff : Persistent Memory
>
> /sys/bus/nd/devices/region0/resource: 0x187c000000
> /sys/bus/nd/devices/region1/resource: 0x577c000000
>
> Create a namespace in region1.  That namespace will have a start_pad of
> 64MiB.  The problem is that, while the correct offset was specified when
> laying out the struct pages (via arch_add_memory), the data_offset for
> the pmem block device itself does not take the start_pad into account
> (despite the comment in the nd_pfn_sb data structure!).

Unfortunately, yes.

> As a result,
> the block device starts at the beginning of the address range, but
> struct pages only exist for the address space starting 64MiB into the
> range.  __bdev_dax_supported fails, because it tries to perform a
> direct_access call on sector 0, and there's no pgmap for the address
> corresponding to that sector.
>
> So, we can't simply make the code correct (by adding the start_pad to
> pmem->data_offset) without bumping the superblock version, because that
> would change the size of the block device, and the location of data on
> that block device would all be off by 64MiB (and you'd lose the first
> 64MiB).  Mass hysteria.

Correct. Systems with this bug are working fine without DAX because
everything is aligned in that case. We can't change the interpretation
of the fields to make DAX work without losing access to existing data
at the proper offsets through the non-DAX path.

> > However, to fix this situation a non-backwards compatible change
> > needs to be made to the interpretation of the nd_pfn info-block.
> > ->start_pad needs to be accounted in ->map.map_offset (formerly
> > ->data_offset), and ->map.map_base (formerly ->phys_addr) needs to be
> > adjusted to the section aligned resource base used to establish
> > ->map.map formerly (formerly ->virt_addr).
> >
> > The guiding principles of the info-block compatibility fixup is to
> > maintain the interpretation of ->data_offset for implementations like
> > the EFI driver that only care about data_access not dax, but cause older
> > Linux implementations that care about the mode and dax to fail to parse
> > the new info-block.
>
> What if the core mm grew support for hotplug on sub-section boundaries?
> Would't that fix this problem (and others)?

Yes, I think it would, and I had patches along these lines [2]. Last
time I looked at this I was asked by core-mm folks to await some
general refactoring of hotplug [3], and I wasn't proud about some of
the hacks I used to make it work. In general I'm less confident about
being able to get sub-section-hotplug over the goal line (core-mm
resistance to hotplug complexity) vs the local hacks in nvdimm to deal
with this breakage.

Local hacks are always a sad choice, but I think leaving these
configurations stranded for another kernel cycle is not tenable. It
wasn't until the github issue did I realize that the problem was
happening in the wild on NVDIMM-N platforms.

[2]: https://lore.kernel.org/lkml/148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com/
[3]: https://lore.kernel.org/lkml/20170319163531.GA25835@dhcp22.suse.cz/

>
> -Jeff
>
> [1] https://github.com/pmem/ndctl/issues/76
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
