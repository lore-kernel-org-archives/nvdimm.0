Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B5FD1A1E80
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 03:01:24 -0700 (PDT)
Date: Mon, 14 Mar 2016 11:01:28 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/12] dax: Remove synchronization using i_mmap_lock
Message-ID: <20160314100128.GB6801@quack.suse.cz>
References: <1457637535-21633-1-git-send-email-jack@suse.cz>
 <1457637535-21633-6-git-send-email-jack@suse.cz>
 <100D68C7BA14664A8938383216E40DE0422079E9@FMSMSX114.amr.corp.intel.com>
 <20160310200501.GA23203@quack.suse.cz>
 <100D68C7BA14664A8938383216E40DE042207AA9@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE042207AA9@FMSMSX114.amr.corp.intel.com>
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
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, NeilBrown <neilb@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 10-03-16 20:10:09, Wilcox, Matthew R wrote:
> Here's the race:
> 
> CPU 0				CPU 1
> do_cow_fault()
> __do_fault()
> takes sem
> dax_fault()
> releases sem
> 				truncate()
> 				unmap_mapping_range()
> 				i_mmap_lock_write()
> 				unmap_mapping_range_tree()
> 				i_mmap_unlock_write()
> do_set_pte()
> 
> Holding i_mmap_lock_read() from inside __do_fault() prevents the truncate
> from proceeding until the page is inseted with do_set_pte().

Ah, right. Thanks for reminding me. I was hoping to get rid of this
i_mmap_lock abuse in DAX code but obviously it needs more work :).

								Honza

> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz] 
> Sent: Thursday, March 10, 2016 12:05 PM
> To: Wilcox, Matthew R
> Cc: Jan Kara; linux-fsdevel@vger.kernel.org; Ross Zwisler; Williams, Dan J; linux-nvdimm@lists.01.org; NeilBrown
> Subject: Re: [PATCH 05/12] dax: Remove synchronization using i_mmap_lock
> 
> On Thu 10-03-16 19:55:21, Wilcox, Matthew R wrote:
> > This locking's still necessary.  i_mmap_sem has already been released by
> > the time we're back in do_cow_fault(), so it doesn't protect that page,
> > and truncate can have whizzed past and thinks there's nothing to unmap.
> > So a task can have a MAP_PRIVATE page still in its address space after
> > it's supposed to have been unmapped.
> 
> I don't think this is possible. Filesystem holds its inode->i_mmap_sem for
> reading when handling the fault. That synchronizes against truncate...
> 
> 								Honza
> 
> > -----Original Message-----
> > From: Jan Kara [mailto:jack@suse.cz] 
> > Sent: Thursday, March 10, 2016 11:19 AM
> > To: linux-fsdevel@vger.kernel.org
> > Cc: Wilcox, Matthew R; Ross Zwisler; Williams, Dan J; linux-nvdimm@lists.01.org; NeilBrown; Jan Kara
> > Subject: [PATCH 05/12] dax: Remove synchronization using i_mmap_lock
> > 
> > At one point DAX used i_mmap_lock so synchronize page faults with page
> > table invalidation during truncate. However these days DAX uses
> > filesystem specific RW semaphores to protect against these races
> > (i_mmap_sem in ext2 & ext4 cases, XFS_MMAPLOCK in xfs case). So remove
> > the unnecessary locking.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c    | 19 -------------------
> >  mm/memory.c | 14 --------------
> >  2 files changed, 33 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 9c4d697fb6fc..e409e8fc13b7 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -563,8 +563,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> >  	pgoff_t size;
> >  	int error;
> >  
> > -	i_mmap_lock_read(mapping);
> > -
> >  	/*
> >  	 * Check truncate didn't happen while we were allocating a block.
> >  	 * If it did, this block may or may not be still allocated to the
> > @@ -597,8 +595,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> >  	error = vm_insert_mixed(vma, vaddr, dax.pfn);
> >  
> >   out:
> > -	i_mmap_unlock_read(mapping);
> > -
> >  	return error;
> >  }
> >  
> > @@ -695,17 +691,6 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> >  		if (error)
> >  			goto unlock_page;
> >  		vmf->page = page;
> > -		if (!page) {
> > -			i_mmap_lock_read(mapping);
> > -			/* Check we didn't race with truncate */
> > -			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
> > -								PAGE_SHIFT;
> > -			if (vmf->pgoff >= size) {
> > -				i_mmap_unlock_read(mapping);
> > -				error = -EIO;
> > -				goto out;
> > -			}
> > -		}
> >  		return VM_FAULT_LOCKED;
> >  	}
> >  
> > @@ -895,8 +880,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  		truncate_pagecache_range(inode, lstart, lend);
> >  	}
> >  
> > -	i_mmap_lock_read(mapping);
> > -
> >  	/*
> >  	 * If a truncate happened while we were allocating blocks, we may
> >  	 * leave blocks allocated to the file that are beyond EOF.  We can't
> > @@ -1013,8 +996,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  	}
> >  
> >   out:
> > -	i_mmap_unlock_read(mapping);
> > -
> >  	if (buffer_unwritten(&bh))
> >  		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
> >  
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 8132787ae4d5..13f76eb08f33 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2430,8 +2430,6 @@ void unmap_mapping_range(struct address_space *mapping,
> >  	if (details.last_index < details.first_index)
> >  		details.last_index = ULONG_MAX;
> >  
> > -
> > -	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
> >  	i_mmap_lock_write(mapping);
> >  	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
> >  		unmap_mapping_range_tree(&mapping->i_mmap, &details);
> > @@ -3019,12 +3017,6 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> >  		if (fault_page) {
> >  			unlock_page(fault_page);
> >  			page_cache_release(fault_page);
> > -		} else {
> > -			/*
> > -			 * The fault handler has no page to lock, so it holds
> > -			 * i_mmap_lock for read to protect against truncate.
> > -			 */
> > -			i_mmap_unlock_read(vma->vm_file->f_mapping);
> >  		}
> >  		goto uncharge_out;
> >  	}
> > @@ -3035,12 +3027,6 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> >  	if (fault_page) {
> >  		unlock_page(fault_page);
> >  		page_cache_release(fault_page);
> > -	} else {
> > -		/*
> > -		 * The fault handler has no page to lock, so it holds
> > -		 * i_mmap_lock for read to protect against truncate.
> > -		 */
> > -		i_mmap_unlock_read(vma->vm_file->f_mapping);
> >  	}
> >  	return ret;
> >  uncharge_out:
> > -- 
> > 2.6.2
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
