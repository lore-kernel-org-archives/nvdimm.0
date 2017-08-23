Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8AABB21E47D64
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 08:26:11 -0700 (PDT)
Date: Wed, 23 Aug 2017 09:28:39 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 1/2] dax: fix deadlock due to misaligned PMD faults
Message-ID: <20170823152839.GA25999@linux.intel.com>
References: <20170822220926.13799-1-ross.zwisler@linux.intel.com>
 <20170822222436.18926-1-ross.zwisler@linux.intel.com>
 <20170823095733.GA2100@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170823095733.GA2100@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Slusarz,
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 23, 2017 at 11:57:33AM +0200, Jan Kara wrote:
> On Tue 22-08-17 16:24:35, Ross Zwisler wrote:
> > In DAX there are two separate places where the 2MiB range of a PMD is
> > defined.
> > 
> > The first is in the page tables, where a PMD mapping inserted for a given
> > address spans from (vmf->address & PMD_MASK) to
> > ((vmf->address & PMD_MASK) + PMD_SIZE - 1).  That is, from the 2MiB
> > boundary below the address to the 2MiB boundary above the address.
> > 
> > So, for example, a fault at address 3MiB (0x30 0000) falls within the PMD
> > that ranges from 2MiB (0x20 0000) to 4MiB (0x40 0000).
> > 
> > The second PMD range is in the mapping->page_tree, where a given file
> > offset is covered by a radix tree entry that spans from one 2MiB aligned
> > file offset to another 2MiB aligned file offset.
> > 
> > So, for example, the file offset for 3MiB (pgoff 768) falls within the PMD
> > range for the order 9 radix tree entry that ranges from 2MiB (pgoff 512) to
> > 4MiB (pgoff 1024).
> > 
> > This system works so long as the addresses and file offsets for a given
> > mapping both have the same offsets relative to the start of each PMD.
> > 
> > Consider the case where the starting address for a given file isn't 2MiB
> > aligned - say our faulting address is 3 MiB (0x30 0000), but that
> > corresponds to the beginning of our file (pgoff 0).  Now all the PMDs in
> > the mapping are misaligned so that the 2MiB range defined in the page
> > tables never matches up with the 2MiB range defined in the radix tree.
> > 
> > The current code notices this case for DAX faults to storage with the
> > following test in dax_pmd_insert_mapping():
> > 
> > 	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
> > 		goto unlock_fallback;
> > 
> > This test makes sure that the pfn we get from the driver is 2MiB aligned,
> > and relies on the assumption that the 2MiB alignment of the pfn we get back
> > from the driver matches the 2MiB alignment of the faulting address.
> > 
> > However, faults to holes were not checked and we could hit the problem
> > described above.
> > 
> > This was reported in response to the NVML nvml/src/test/pmempool_sync
> > TEST5:
> > 
> > 	$ cd nvml/src/test/pmempool_sync
> > 	$ make TEST5
> > 
> > You can grab NVML here:
> > 
> > 	https://github.com/pmem/nvml/
> > 
> > The dmesg warning you see when you hit this error is:
> > 
> > WARNING: CPU: 13 PID: 2900 at fs/dax.c:641 dax_insert_mapping_entry+0x2df/0x310
> > 
> > Where we notice in dax_insert_mapping_entry() that the radix tree entry we
> > are about to replace doesn't match the locked entry that we had previously
> > inserted into the tree.  This happens because the initial insertion was
> > done in grab_mapping_entry() using a pgoff calculated from the faulting
> > address (vmf->address), and the replacement in
> > dax_pmd_load_hole() => dax_insert_mapping_entry() is done using vmf->pgoff.
> > 
> > In our failure case those two page offsets (one calculated from
> > vmf->address, one using vmf->pgoff) point to different order 9 radix tree
> > entries.
> > 
> > This failure case can result in a deadlock because the radix tree unlock
> > also happens on the pgoff calculated from vmf->address.  This means that
> > the locked radix tree entry that we swapped in to the tree in
> > dax_insert_mapping_entry() using vmf->pgoff is never unlocked, so all
> > future faults to that 2MiB range will block forever.
> > 
> > Fix this by validating that the faulting address's PMD offset matches the
> > PMD offset from the start of the file.  This check is done at the very
> > beginning of the fault and covers faults that would have mapped to storage
> > as well as faults to holes.  I left the COLOUR check in
> > dax_pmd_insert_mapping() in place in case we ever hit the insanity
> > condition where the alignment of the pfn we get from the driver doesn't
> > match the alignment of the userspace address.
> 
> Hum, I'm confused with all these offsets and their alignment requirements.
> So let me try to get this straight. We have three different things here:
> 
> 1) virtual address A where we fault
> 2) file offset FA corresponding to the virtual address - computed as
>    linear_page_index(vma, A) = (A - vma->start) >> PAGE_SHIFT + vma->pgoff
>    - and stored in vmf->pgoff
> 3) physical address (or sector in filesystem terminology) the file offset
>    maps to.
> 
> and then we have the aligned virtual address B = (A & PMD_MASK) and
> corresponding file offset FB we've got from linear_page_index(vma, B). Now
> if I've correctly understood what you've written above, the problem is that
> although B is aligned, FB doesn't have to be. That can happen either when
> vma->start is not aligned (which is the example you give above?) or when
> vma->pgoff is non aligned. And as a result FA >> 9 != FB >> 9 leading to
> issues.
> 
> OK, makes sense. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Yep, your understanding matches mine.  What was happening in one specific
failure in the NVML test was:

vmf->vm_pgoff = 0x1  	/* the vma's page offset from the start of the file */
file offset FA = vmf->pgoff = 0x1200
address A = 0x7f7a8edff000

So, as you say the 0x1200 pgoff is calculated via
vmf->pgoff = (A - vma->start) >> PAGE_SHIFT + vma->vm_pgoff
0x1200 = (0x7f7a8edff000 - 0x7f7a8dc00000) >> PAGE_SHIFT + 1

So, when we get the aligned virtual address B = (A & PMD_MASK) in
dax_iomap_pmd_fault() and use that to get the aligned page offset:

aligned pgoff FB = (B - vma->start) >> PAGE_SHIFT + vma->vm_pgoff
0x1001 = (0x7f7a8ec00000 - 0x7f7a8dc00000) >> PAGE_SHIFT + 1

The aligned pgoff FB of 0x1001 is a different PMD in the radix tree than we
get when we use the vmf->pgoff FA of 0x1200.

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
