From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/12] xfs: use iomap to implement DAX
Date: Thu, 15 Sep 2016 08:43:20 +0200
Message-ID: <20160915064320.GA7665@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
 <1473847291-18913-11-git-send-email-hch@lst.de>
 <20160915052933.GH9314@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915052933.GH9314-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 14, 2016 at 10:29:33PM -0700, Darrick J. Wong wrote:
> I'm a little confused about xfs_file_iomap_begin() and IOMAP_WRITE --
> prior to this patchset, it was only called via page_mkwrite and what
> used to be write_begin, and all it did was create a delalloc reservation
> to back the write (or actually allocate blocks if extsize was set).

No, it was called from write itself in addition, of course.

> Thinking ahead to integrating reflink with DAX (and presumably
> directio) in both cases _file_iomap_begin has to return a real extent.
> If the range we're writing is shared, then that means that I'd have to
> ensure the range is reserved in the COW fork (the reflink patches already do
> this).  Next, if the caller requires a firm mapping (i.e. dax or dio)
> I'd have to allocate the range in the COW fork and have that mapping
> returned to the caller.

Yes.  No different than the existing buffered write case with an
extent size hint, really.

> So I guess it would look something like this:
> 
> /* reserve reflink cow range like the reflink patches already do */
> if (flags & (IOMAP_WRITE | IOMAP_ZERO) && xfs_is_reflink_inode(ip))
> 	xfs_reflink_reserve_cow_range(ip, offset, length);

For zeroing we don't need to reserve anything IFF we are finding a hole,
so this is too early.

> /* do the cow thing if need be */
> if ((flags & IOMAP_WRITE) &&
>     xfs_is_reflink_inode(ip) &&
>     (IS_DAX(inode) || (flags & IOMAP_DIO)) {
> 	xfs_reflink_allocate_cow_range(ip, offset, length);
> 
> 	if (xfs_reflink_is_cow_pending(ip, offset))
> 		xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
> 	else
> 		xfs_bmapi_read(offset, &imap)
> } else
> 	xfs_bmapi_read(offset, &imap) /* non-cow io */


We really have three write block allocation variants, of which the first
two look basically the same except for I/O completion handling:

 1) For DAX we need to allocate real extents and zero them before use.
 2) For buffered I/O with an extent size hint or direct I/O we need to
    allocate unwritten extents (and convert after the I/O succeeded for
    the range that succeeded)
 3) for buffered I/O without and extent size hint we need to created
    a delayed allocation

That logic exists both in the old __xfs_get_blocks and and the new
iomap code (although we don't check for the dio case yet).

So I don't think we should need to change anything in terms of COW
in relation to DAX or direct I/O here.  I do however need to fully
audit the usage of the reflink calls for the cases 1 and 2.  For one
it doesn't really seem nessecary to split the reserve/allocate case
ehre, and I hope that a lot of the bmap btree looks could be saved,
similar to my rewrite of the delalloc case.
    

> Does that look plausible?  If _iomap_begin will have one type of caller
> that only needs a delalloc reservation and another type that actually
> needs a firm mapping, should we make a new IOMAP flag to indicate that
> the caller really needs a firm mapping?  IS_DAX is fine for detecting
> the DAX case as this patchset shows, but what about directio?
> 
> (At this point Dave suggests on IRC that we just make a dio specific
> iomap_begin.  That eliminates the flag, though it'd be a fairly similar
> function.)

As explained above, DIO is exaxtly the same as buffered I/O with
an extent size hint.  We already handle it fine.  DAX is almost
the same, keyed off a DAX check in lower level code to convert unwritten
extents and zero the blocks.
