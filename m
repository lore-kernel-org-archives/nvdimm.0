Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23A12208AE98F
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 09:12:49 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id z19so2492574otm.2
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 09:12:49 -0800 (PST)
MIME-Version: 1.0
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49ftsgsnzp.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4h9s1jYROGqkMfKk0MNBUedP=vQ1nJObLRwFiTB405nOg@mail.gmail.com>
 <x49imxbx22d.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49imxbx22d.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Feb 2019 09:12:37 -0800
Message-ID: <CAPcyv4jweuVTm6D2OTaAMGvUXfxqZMDPfaASJ=QL9=8SdGUZqg@mail.gmail.com>
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

On Fri, Feb 22, 2019 at 7:42 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> >> > However, to fix this situation a non-backwards compatible change
> >> > needs to be made to the interpretation of the nd_pfn info-block.
> >> > ->start_pad needs to be accounted in ->map.map_offset (formerly
> >> > ->data_offset), and ->map.map_base (formerly ->phys_addr) needs to be
> >> > adjusted to the section aligned resource base used to establish
> >> > ->map.map formerly (formerly ->virt_addr).
> >> >
> >> > The guiding principles of the info-block compatibility fixup is to
> >> > maintain the interpretation of ->data_offset for implementations like
> >> > the EFI driver that only care about data_access not dax, but cause older
> >> > Linux implementations that care about the mode and dax to fail to parse
> >> > the new info-block.
> >>
> >> What if the core mm grew support for hotplug on sub-section boundaries?
> >> Would't that fix this problem (and others)?
> >
> > Yes, I think it would, and I had patches along these lines [2]. Last
> > time I looked at this I was asked by core-mm folks to await some
> > general refactoring of hotplug [3], and I wasn't proud about some of
> > the hacks I used to make it work. In general I'm less confident about
> > being able to get sub-section-hotplug over the goal line (core-mm
> > resistance to hotplug complexity) vs the local hacks in nvdimm to deal
> > with this breakage.
>
> You first posted that patch series in December of 2016.  How long do we
> wait for this refactoring to happen?
>
> Meanwhile, we've been kicking this can down the road for far too long.
> Simple namespace creation fails to work.  For example:
>
> # ndctl create-namespace -m fsdax -s 128m
>   Error: '--size=' must align to interleave-width: 6 and alignment: 2097152
>   did you intend --size=132M?
>
> failed to create namespace: Invalid argument
>
> ok, I can't actually create a small, section-aligned namespace.  Let's
> bump it up:
>
> # ndctl create-namespace -m fsdax -s 132m
> {
>   "dev":"namespace1.0",
>   "mode":"fsdax",
>   "map":"dev",
>   "size":"126.00 MiB (132.12 MB)",
>   "uuid":"2a5f8fe0-69e2-46bf-98bc-0f5667cd810a",
>   "raw_uuid":"f7324317-5cd2-491e-8cd1-ad03770593f2",
>   "sector_size":512,
>   "blockdev":"pmem1",
>   "numa_node":1
> }
>
> Great!  Now let's create another one.
>
> # ndctl create-namespace -m fsdax -s 132m
> libndctl: ndctl_pfn_enable: pfn1.1: failed to enable
>   Error: namespace1.2: failed to enable
>
> failed to create namespace: No such device or address
>
> (along with a kernel warning spew)

I assume you're seeing this on the libnvdimm-pending branch?

> And at this point, all further ndctl create-namespace commands fail.
> Lovely.  This is a wart that was acceptable only because a fix was
> coming.  2+ years later, and we're still adding hacks to work around it
> (and there have been *several* hacks).

True.

>
> > Local hacks are always a sad choice, but I think leaving these
> > configurations stranded for another kernel cycle is not tenable. It
> > wasn't until the github issue did I realize that the problem was
> > happening in the wild on NVDIMM-N platforms.
>
> I understand the desire for expediency.  At some point, though, we have
> to address the root of the problem.

Well, you've defibrillated me back to reality. We've suffered the
incomplete broken hacks for 2 years, what's another 10 weeks? I'll
dust off the sub-section patches and take another run at it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
