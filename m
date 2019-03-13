Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58394211DBE72
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 02:58:36 -0700 (PDT)
Date: Wed, 13 Mar 2019 10:58:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] fs/dax: deposit pagetable even when installing zero
 page
Message-ID: <20190313095834.GF32521@quack2.suse.cz>
References: <20190309120721.21416-1-aneesh.kumar@linux.ibm.com>
 <8736nrnzxm.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8736nrnzxm.fsf@linux.ibm.com>
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 13-03-19 10:17:17, Aneesh Kumar K.V wrote:
> 
> Hi Dan/Andrew/Jan,
> 
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> 
> > Architectures like ppc64 use the deposited page table to store hardware
> > page table slot information. Make sure we deposit a page table when
> > using zero page at the pmd level for hash.
> >
> > Without this we hit
> >
> > Unable to handle kernel paging request for data at address 0x00000000
> > Faulting instruction address: 0xc000000000082a74
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > ....
> >
> > NIP [c000000000082a74] __hash_page_thp+0x224/0x5b0
> > LR [c0000000000829a4] __hash_page_thp+0x154/0x5b0
> > Call Trace:
> >  hash_page_mm+0x43c/0x740
> >  do_hash_page+0x2c/0x3c
> >  copy_from_iter_flushcache+0xa4/0x4a0
> >  pmem_copy_from_iter+0x2c/0x50 [nd_pmem]
> >  dax_copy_from_iter+0x40/0x70
> >  dax_iomap_actor+0x134/0x360
> >  iomap_apply+0xfc/0x1b0
> >  dax_iomap_rw+0xac/0x130
> >  ext4_file_write_iter+0x254/0x460 [ext4]
> >  __vfs_write+0x120/0x1e0
> >  vfs_write+0xd8/0x220
> >  SyS_write+0x6c/0x110
> >  system_call+0x3c/0x130
> >
> > Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> 
> Any suggestion on which tree this patch should got to? Also since this
> fix a kernel crash, we may want to get this to 5.1?

I think this should go through Dan's tree...

								Honza

> > ---
> > Changes from v1:
> > * Add reviewed-by:
> > * Add Fixes:
> >
> >  fs/dax.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 6959837cc465..01bfb2ac34f9 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/sizes.h>
> >  #include <linux/mmu_notifier.h>
> >  #include <linux/iomap.h>
> > +#include <asm/pgalloc.h>
> >  #include "internal.h"
> >  
> >  #define CREATE_TRACE_POINTS
> > @@ -1410,7 +1411,9 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> >  {
> >  	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> >  	unsigned long pmd_addr = vmf->address & PMD_MASK;
> > +	struct vm_area_struct *vma = vmf->vma;
> >  	struct inode *inode = mapping->host;
> > +	pgtable_t pgtable = NULL;
> >  	struct page *zero_page;
> >  	spinlock_t *ptl;
> >  	pmd_t pmd_entry;
> > @@ -1425,12 +1428,22 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> >  	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
> >  			DAX_PMD | DAX_ZERO_PAGE, false);
> >  
> > +	if (arch_needs_pgtable_deposit()) {
> > +		pgtable = pte_alloc_one(vma->vm_mm);
> > +		if (!pgtable)
> > +			return VM_FAULT_OOM;
> > +	}
> > +
> >  	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
> >  	if (!pmd_none(*(vmf->pmd))) {
> >  		spin_unlock(ptl);
> >  		goto fallback;
> >  	}
> >  
> > +	if (pgtable) {
> > +		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
> > +		mm_inc_nr_ptes(vma->vm_mm);
> > +	}
> >  	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
> >  	pmd_entry = pmd_mkhuge(pmd_entry);
> >  	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
> > @@ -1439,6 +1452,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
> >  	return VM_FAULT_NOPAGE;
> >  
> >  fallback:
> > +	if (pgtable)
> > +		pte_free(vma->vm_mm, pgtable);
> >  	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, *entry);
> >  	return VM_FAULT_FALLBACK;
> >  }
> > -- 
> > 2.20.1
> 
> -aneesh
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
