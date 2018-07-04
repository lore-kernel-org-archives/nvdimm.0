Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1616202E5446
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 05:27:27 -0700 (PDT)
Date: Wed, 4 Jul 2018 14:27:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/2] ext4: handle layout changes to pinned DAX mappings
Message-ID: <20180704122723.lup2wovzb6u6ta6v@quack2.suse.cz>
References: <20180627212252.31032-3-ross.zwisler@linux.intel.com>
 <20180702172912.329-1-ross.zwisler@linux.intel.com>
 <20180704004923.GT19934@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180704004923.GT19934@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 04-07-18 10:49:23, Dave Chinner wrote:
> On Mon, Jul 02, 2018 at 11:29:12AM -0600, Ross Zwisler wrote:
> > Follow the lead of xfs_break_dax_layouts() and add synchronization between
> > operations in ext4 which remove blocks from an inode (hole punch, truncate
> > down, etc.) and pages which are pinned due to DAX DMA operations.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > 
> > Changes since v2:
> >  * Added a comment to ext4_insert_range() explaining why we don't call
> >    ext4_break_layouts(). (Jan)
> 
> Which I think is wrong and will cause data corruption.
> 
> > @@ -5651,6 +5663,11 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
> >  			LLONG_MAX);
> >  	if (ret)
> >  		goto out_mmap;
> > +	/*
> > +	 * We don't need to call ext4_break_layouts() because we aren't
> > +	 * removing any blocks from the inode.  We are just changing their
> > +	 * offset by inserting a hole.
> > +	 */
> 
> The entire point of these leases is so that a thrid party can
> directly access the blocks underlying the file. That means they are
> keeping their own file offset<->disk block mapping internally, and
> they are assuming that it is valid for as long as they hold the
> lease. If the filesystem modifies the extent map - even something
> like a shift here which changes the offset<->disk block mapping -
> the userspace app now has a stale mapping and so the lease *must be
> broken* to tell it that it's mappings are now stale and it needs to
> refetch them.

Well, ext4 has no real concept of leases and no pNFS support. And DAX
requirements wrt consistency are much weaker than those of pNFS. This is
mostly caused by the fact that calls like invalidate_mapping_pages() will
flush offset<->pfn mappings DAX maintains in the radix tree automatically
(similarly as it happens when page cache is used).

What Ross did just keeps ext4 + DAX behave similarly as ext4 + page cache
does - i.e., if you use mmaped file as a buffer e.g. for direct IO and mix
your direct IO with extent manipulations on that buffer file, you will get
inconsistent results. With page cache, pages you use as buffers will get
detached from the inode during extent manipulations and discarded once you
drop your page references. With DAX, changes will land at a different
offset of the file than you might have thought. But that is the same as if
we just waited for the IO to complete (which is what ext4_break_layouts()
effectively does) and then shifted those blocks.

So the biggest problem I can see here is that ext4_break_layouts() is a
misnomer as it promises more than the function actually does (wait for page
references to be dropped). If we called it like ext4_dax_unmap_pages(),
things would be clearer I guess. Ross?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
