Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFF0581D97
 for <linux-nvdimm@lists.01.org>; Wed, 30 Nov 2016 00:23:21 -0800 (PST)
Date: Wed, 30 Nov 2016 09:23:18 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] dax: Avoid page invalidation races and unnecessary
 radix tree traversals
Message-ID: <20161130082318.GE16667@quack2.suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
 <1479980796-26161-4-git-send-email-jack@suse.cz>
 <20161129223138.GB16608@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161129223138.GB16608@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 29-11-16 15:31:38, Ross Zwisler wrote:
> On Thu, Nov 24, 2016 at 10:46:33AM +0100, Jan Kara wrote:
> > Currently each filesystem (possibly through generic_file_direct_write()
> > or iomap_dax_rw()) takes care of invalidating page tables and evicting
> 
> Just some nits about the commit message: the DAX I/O path function is now
> called dax_iomap_rw(), and no filesystems still use
> generic_file_direct_write() for DAX so you can probably remove it from the
> changelog - up to you.

Yeah, good spotting. Many things have changed through rebases. I've fixed
up the changelog to reflect current state.

> Aside from that:
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks.

								Honza

> 
> > hole pages from the radix tree when write(2) to the file happens. This
> > invalidation is only necessary when there is some block allocation
> > resulting from write(2). Furthermore in current place the invalidation
> > is racy wrt page fault instantiating a hole page just after we have
> > invalidated it.
> > 
> > So perform the page invalidation inside dax_do_io() where we can do it
> > only when really necessary and after blocks have been allocated so
> > nobody will be instantiating new hole pages anymore.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c | 28 +++++++++++-----------------
> >  1 file changed, 11 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 4534f0e232e9..ddf77ef2ca18 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -984,6 +984,17 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> >  	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
> >  		return -EIO;
> >  
> > +	/*
> > +	 * Write can allocate block for an area which has a hole page mapped
> > +	 * into page tables. We have to tear down these mappings so that data
> > +	 * written by write(2) is visible in mmap.
> > +	 */
> > +	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
> > +		invalidate_inode_pages2_range(inode->i_mapping,
> > +					      pos >> PAGE_SHIFT,
> > +					      (end - 1) >> PAGE_SHIFT);
> > +	}
> > +
> >  	while (pos < end) {
> >  		unsigned offset = pos & (PAGE_SIZE - 1);
> >  		struct blk_dax_ctl dax = { 0 };
> > @@ -1042,23 +1053,6 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  	if (iov_iter_rw(iter) == WRITE)
> >  		flags |= IOMAP_WRITE;
> >  
> > -	/*
> > -	 * Yes, even DAX files can have page cache attached to them:  A zeroed
> > -	 * page is inserted into the pagecache when we have to serve a write
> > -	 * fault on a hole.  It should never be dirtied and can simply be
> > -	 * dropped from the pagecache once we get real data for the page.
> > -	 *
> > -	 * XXX: This is racy against mmap, and there's nothing we can do about
> > -	 * it. We'll eventually need to shift this down even further so that
> > -	 * we can check if we allocated blocks over a hole first.
> > -	 */
> > -	if (mapping->nrpages) {
> > -		ret = invalidate_inode_pages2_range(mapping,
> > -				pos >> PAGE_SHIFT,
> > -				(pos + iov_iter_count(iter) - 1) >> PAGE_SHIFT);
> > -		WARN_ON_ONCE(ret);
> > -	}
> > -
> >  	while (iov_iter_count(iter)) {
> >  		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
> >  				iter, dax_iomap_actor);
> > -- 
> > 2.6.6
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
