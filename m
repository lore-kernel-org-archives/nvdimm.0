Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D62DF211CCD64
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 15:47:24 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 7/7] libnvdimm/pfn: Fix 'start_pad' implementation
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 21 Feb 2019 18:47:22 -0500
In-Reply-To: <155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Tue, 12 Feb 2019 13:25:17 -0800")
Message-ID: <x49ftsgsnzp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dan,

Thanks for the comprehensive write-up.  Comments below.

Dan Williams <dan.j.williams@intel.com> writes:

> In the beginning the pmem driver simply passed the persistent memory
> resource range to memremap and was done. With the introduction of
> devm_memremap_pages() and vmem_altmap the implementation needed to
> contend with metadata at the start of the resource to indicate whether
> the vmemmap is located in System RAM or Persistent Memory, and reserve
> vmemmap capacity in pmem for the latter case.
>
> The indication of metadata space was communicated in the
> nd_pfn->data_offset property and it was defined to be identical to the
> pmem_device->data_offset property, i.e. relative to the raw resource
> base of the namespace. Up until this point in the driver's development
> pmem_device->phys_addr == __pa(pmem_device->virt_addr). This
> implementation was fine up until the discovery of platforms with
> physical address layouts that mapped Persistent Memory and System RAM to
> the same Linux memory hotplug section (128MB span).
>
> The nd_pfn->start_pad and nd_pfn->end_trunc properties were introduced
> to pad and truncate the capacity to fit within an exclusive Linux
> memory hotplug section span, and it was at this point where the
> ->start_pad definition did not comprehend the pmem_device->phys_addr to
> pmem_device->virt_addr relationship. Platforms in the wild typically
> only collided 'System RAM' at the end of the Persistent Memory range so
> ->start_pad was often zero.
>
> Lately Linux has encountered platforms that collide Persistent Memory
> regions between each other, specifically cases where ->start_pad needed
> to be non-zero. This lead to commit ae86cbfef381 "libnvdimm, pfn: Pad
> pfn namespaces relative to other regions". That commit allowed
> namespaces to be mapped with devm_memremap_pages(). However dax
> operations on those configurations currently fail if attempted within the
> ->start_pad range because pmem_device->data_offset was still relative to
> raw resource base not relative to the section aligned resource range
> mapped by devm_memremap_pages().
>
> Luckily __bdev_dax_supported() caught these failures and simply disabled
> dax.

Let me make sure I understand the current state of things.  Assume a
machine with two persistent memory ranges overlapping the same hotplug
memory section.  Let's take the example from the ndctl github issue[1]:

187c000000-967bffffff : Persistent Memory

/sys/bus/nd/devices/region0/resource: 0x187c000000
/sys/bus/nd/devices/region1/resource: 0x577c000000

Create a namespace in region1.  That namespace will have a start_pad of
64MiB.  The problem is that, while the correct offset was specified when
laying out the struct pages (via arch_add_memory), the data_offset for
the pmem block device itself does not take the start_pad into account
(despite the comment in the nd_pfn_sb data structure!).  As a result,
the block device starts at the beginning of the address range, but
struct pages only exist for the address space starting 64MiB into the
range.  __bdev_dax_supported fails, because it tries to perform a
direct_access call on sector 0, and there's no pgmap for the address
corresponding to that sector.

So, we can't simply make the code correct (by adding the start_pad to
pmem->data_offset) without bumping the superblock version, because that
would change the size of the block device, and the location of data on
that block device would all be off by 64MiB (and you'd lose the first
64MiB).  Mass hysteria.

> However, to fix this situation a non-backwards compatible change
> needs to be made to the interpretation of the nd_pfn info-block.
> ->start_pad needs to be accounted in ->map.map_offset (formerly
> ->data_offset), and ->map.map_base (formerly ->phys_addr) needs to be
> adjusted to the section aligned resource base used to establish
> ->map.map formerly (formerly ->virt_addr).
>
> The guiding principles of the info-block compatibility fixup is to
> maintain the interpretation of ->data_offset for implementations like
> the EFI driver that only care about data_access not dax, but cause older
> Linux implementations that care about the mode and dax to fail to parse
> the new info-block.

What if the core mm grew support for hotplug on sub-section boundaries?
Would't that fix this problem (and others)?

-Jeff

[1] https://github.com/pmem/ndctl/issues/76
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
