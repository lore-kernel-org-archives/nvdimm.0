Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B248B1A1E1D
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 03:42:12 -0700 (PDT)
Date: Thu, 24 Mar 2016 11:42:14 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/10] dax: Allow DAX code to replace exceptional entries
Message-ID: <20160324104214.GA4025@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-6-git-send-email-jack@suse.cz>
 <20160323175258.GD5544@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323175258.GD5544@linux.intel.com>
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

On Wed 23-03-16 11:52:58, Ross Zwisler wrote:
> On Mon, Mar 21, 2016 at 02:22:50PM +0100, Jan Kara wrote:
> > Currently we forbid page_cache_tree_insert() to replace exceptional radix
> > tree entries for DAX inodes. However to make DAX faults race free we will
> > lock radix tree entries and when hole is created, we need to replace
> > such locked radix tree entry with a hole page. So modify
> > page_cache_tree_insert() to allow that.
> 
> Perhaps this is addressed later in the series, but at first glance this seems
> unsafe to me - what happens of we had tasks waiting on the locked entry?  Are
> they woken up when we replace the locked entry with a page cache entry?
> 
> If they are woken up, will they be alright with the fact that they were
> sleeping on a lock for an exceptional entry, and now that lock no longer
> exists?  The radix tree entry will now be filled with a zero page hole, and so
> they can't acquire the lock they were sleeping for - instead if they wanted to
> lock that page they'd need to lock the zero page page lock, right?

Correct. What you describes can happen and the DAX entry locking code
counts with that. I guess I could comment on that in the changelog.

								Honza
> 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  include/linux/dax.h |  6 ++++++
> >  mm/filemap.c        | 18 +++++++++++-------
> >  2 files changed, 17 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index 7c45ac7ea1d1..4b63923e1f8d 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -3,8 +3,14 @@
> >  
> >  #include <linux/fs.h>
> >  #include <linux/mm.h>
> > +#include <linux/radix-tree.h>
> >  #include <asm/pgtable.h>
> >  
> > +/*
> > + * Since exceptional entries do not use indirect bit, we reuse it as a lock bit
> > + */
> > +#define DAX_ENTRY_LOCK RADIX_TREE_INDIRECT_PTR
> > +
> >  ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
> >  		  get_block_t, dio_iodone_t, int flags);
> >  int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 7c00f105845e..fbebedaf719e 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -597,14 +597,18 @@ static int page_cache_tree_insert(struct address_space *mapping,
> >  		if (!radix_tree_exceptional_entry(p))
> >  			return -EEXIST;
> >  
> > -		if (WARN_ON(dax_mapping(mapping)))
> > -			return -EINVAL;
> > -
> > -		if (shadowp)
> > -			*shadowp = p;
> >  		mapping->nrexceptional--;
> > -		if (node)
> > -			workingset_node_shadows_dec(node);
> > +		if (!dax_mapping(mapping)) {
> > +			if (shadowp)
> > +				*shadowp = p;
> > +			if (node)
> > +				workingset_node_shadows_dec(node);
> > +		} else {
> > +			/* DAX can replace empty locked entry with a hole */
> > +			WARN_ON_ONCE(p !=
> > +				(void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
> > +					 DAX_ENTRY_LOCK));
> > +		}
> >  	}
> >  	radix_tree_replace_slot(slot, page);
> >  	mapping->nrpages++;
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
