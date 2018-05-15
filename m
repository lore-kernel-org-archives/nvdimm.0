Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from SMTP.EU.CITRIX.COM (smtp.ctxuk.citrix.com [185.25.65.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68A1C2034862F
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 03:06:07 -0700 (PDT)
Date: Tue, 15 May 2018 11:05:57 +0100
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Subject: Re: Draft NVDIMM proposal
Message-ID: <20180515100557.ea2airy4isbn2yzq@MacBook-Pro-de-Roger.local>
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Cooper <Andrew.Cooper3@citrix.com>, George Dunlap <george.dunlap@citrix.com>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, Jan Beulich <JBeulich@suse.com>, Yi Zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Just some replies/questions to some of the points raised below.

On Fri, May 11, 2018 at 09:33:10AM -0700, Dan Williams wrote:
> [ adding linux-nvdimm ]
> 
> Great write up! Some comments below...
> 
> On Wed, May 9, 2018 at 10:35 AM, George Dunlap <george.dunlap@citrix.com> wrote:
> >> To use a namespace, an operating system needs at a minimum two pieces
> >> of information: The UUID and/or Name of the namespace, and the SPA
> >> range where that namespace is mapped; and ideally also the Type and
> >> Abstraction Type to know how to interpret the data inside.
> 
> Not necessarily, no. Linux supports "label-less" mode where it exposes
> the raw capacity of a region in 1:1 mapped namespace without a label.
> This is how Linux supports "legacy" NVDIMMs that do not support
> labels.

In that case, how does Linux know which area of the NVDIMM it should
use to store the page structures?

> >> `fsdax` and `devdax` mode are both designed to make it possible for
> >> user processes to have direct mapping of NVRAM.  As such, both are
> >> only suitable for PMEM namespaces (?).  Both also need to have kernel
> >> page structures allocated for each page of NVRAM; this amounts to 64
> >> bytes for every 4k of NVRAM.  Memory for these page structures can
> >> either be allocated out of normal "system" memory, or inside the PMEM
> >> namespace itself.
> >>
> >> In both cases, an "info block", very similar to the BTT info block, is
> >> written to the beginning of the namespace when created.  This info
> >> block specifies whether the page structures come from system memory or
> >> from the namespace itself.  If from the namespace itself, it contains
> >> information about what parts of the namespace have been set aside for
> >> Linux to use for this purpose.
> >>
> >> Linux has also defined "Type GUIDs" for these two types of namespace
> >> to be stored in the namespace label, although these are not yet in the
> >> ACPI spec.
> 
> They never will be. One of the motivations for GUIDs is that an OS can
> define private ones without needing to go back and standardize them.
> Only GUIDs that are needed to inter-OS / pre-OS compatibility would
> need to be defined in ACPI, and there is no expectation that other
> OSes understand Linux's format for reserving page structure space.

Maybe it would be helpful to somehow mark those areas as
"non-persistent" storage, so that other OSes know they can use this
space for temporary data that doesn't need to survive across reboots?

> >> # Proposed design / roadmap
> >>
> >> Initially, dom0 accesses the NVRAM as normal, using static ACPI tables
> >> and the DSM methods; mappings are treated by Xen during this phase as
> >> MMIO.
> >>
> >> Once dom0 is ready to pass parts of a namespace through to a guest, it
> >> makes a hypercall to tell Xen about the namespace.  It includes any
> >> regions of the namespace which Xen may use for 'scratch'; it also
> >> includes a flag to indicate whether this 'scratch' space may be used
> >> for frame tables from other namespaces.
> >>
> >> Frame tables are then created for this SPA range.  They will be
> >> allocated from, in this order: 1) designated 'scratch' range from
> >> within this namespace 2) designated 'scratch' range from other
> >> namespaces which has been marked as sharable 3) system RAM.
> >>
> >> Xen will either verify that dom0 has no existing mappings, or promote
> >> the mappings to full pages (taking appropriate reference counts for
> >> mappings).  Dom0 must ensure that this namespace is not unmapped,
> >> modified, or relocated until it asks Xen to unmap it.
> >>
> >> For Xen frame tables, to begin with, set aside a partition inside a
> >> namespace to be used by Xen.  Pass this in to Xen when activating the
> >> namespace; this could be either 2a or 3a from "Page structure
> >> allocation".  After that, we could decide which of the two more
> >> streamlined approaches (2b or 3b) to pursue.
> >>
> >> At this point, dom0 can pass parts of the mapped namespace into
> >> guests.  Unfortunately, passing files on a fsdax filesystem is
> >> probably not safe; but we can pass in full dev-dax or fsdax
> >> partitions.
> >>
> >> From a guest perspective, I propose we provide static NFIT only, no
> >> access to labels to begin with.  This can be generated in hvmloader
> >> and/or the toolstack acpi code.
> 
> I'm ignorant of Xen internals, but can you not reuse the existing QEMU
> emulation for labels and NFIT?

We only use QEMU for HVM guests, which would still leave PVH guests
without NVDIMM support. Ideally we would like to use the same solution
for both HVM and PVH, which means QEMU cannot be part of that
solution.

Thanks, Roger.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
