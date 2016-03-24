Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD6FA1A1E6F
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 05:56:45 -0700 (PDT)
Date: Thu, 24 Mar 2016 13:56:48 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/10] dax: Disable huge page handling
Message-ID: <20160324125648.GI4025@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-8-git-send-email-jack@suse.cz>
 <20160323205000.GE5544@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323205000.GE5544@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-03-16 14:50:00, Ross Zwisler wrote:
> On Mon, Mar 21, 2016 at 02:22:52PM +0100, Jan Kara wrote:
> > Currently the handling of huge pages for DAX is racy. For example the
> > following can happen:
> > 
> > CPU0 (THP write fault)			CPU1 (normal read fault)
> > 
> > __dax_pmd_fault()			__dax_fault()
> >   get_block(inode, block, &bh, 0) -> not mapped
> > 					get_block(inode, block, &bh, 0)
> > 					  -> not mapped
> >   if (!buffer_mapped(&bh) && write)
> >     get_block(inode, block, &bh, 1) -> allocates blocks
> >   truncate_pagecache_range(inode, lstart, lend);
> > 					dax_load_hole();
> > 
> > This results in data corruption since process on CPU1 won't see changes
> > into the file done by CPU0.
> > 
> > The race can happen even if two normal faults race however with THP the
> > situation is even worse because the two faults don't operate on the same
> > entries in the radix tree and we want to use these entries for
> > serialization. So disable THP support in DAX code for now.
> 
> Yep, I agree that we should disable PMD faults until we get the multi-order
> radix tree work finished and integrated with this locking.
> 
> I do agree with Dan though that it would be preferable to disable PMD faults
> by having CONFIG_FS_DAX_PMD depend on BROKEN.  That seems smaller and easier
> to switch PMD faults back on for testing.

I did it this way because I wasn't sure PMD fault code even compiles and I
didn't want to break CONFIG_BROKEN builds. But OK, I'll make the code at
least compile and do what you say.

								Honza

> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c            | 2 +-
> >  include/linux/dax.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 0329ec0bee2e..444e9dd079ca 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -719,7 +719,7 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> >  }
> >  EXPORT_SYMBOL_GPL(dax_fault);
> >  
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +#if 0
> >  /*
> >   * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
> >   * more often than one might expect in the below function.
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index 4b63923e1f8d..fd28d824254b 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -29,7 +29,7 @@ static inline struct page *read_dax_sector(struct block_device *bdev,
> >  }
> >  #endif
> >  
> > -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +#if 0
> >  int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
> >  				unsigned int flags, get_block_t);
> >  int __dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
> > -- 
> > 2.6.2
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
