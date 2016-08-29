From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 2/9] ext2: tell DAX the size of allocation holes
Date: Mon, 29 Aug 2016 00:41:16 -0700
Message-ID: <20160829074116.GA16491@infradead.org>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-3-ross.zwisler@linux.intel.com>
 <20160825075728.GA11235@infradead.org>
 <20160826212934.GA11265@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160826212934.GA11265-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Aug 26, 2016 at 03:29:34PM -0600, Ross Zwisler wrote:
> These changes don't remove the things in XFS needed by the old I/O and fault
> paths (e.g.  xfs_get_blocks_direct() is still there an unchanged).  Is the
> correct way forward to get buy-in from ext2/ext4 so that they also move to
> supporting an iomap based I/O path (xfs_file_iomap_begin(),
> xfs_iomap_write_direct(), etc?).  That would allow us to have parallel I/O and
> fault paths for a while, then remove the old buffer_head based versions when
> the three supported filesystems have moved to iomap.
> 
> If ext2 and ext4 don't choose to move to iomap, though, I don't think we want
> to have a separate I/O & fault path for iomap/XFS.  That seems too painful,
> and the old buffer_head version should continue to work, ugly as it may be.

We're going to move forward killing buffer_heads in XFS.  I think ext4
would dramatically benefit from this a well, as would ext2 (although I
think all that DAX work in ext2 is a horrible idea to start with).

If I don't get buy-in for the iomap DAX work in the dax code we'll just
have to keep it separate.  That buffer_head mess just isn't maintainable
the long run.

> 1) In your mail above you say "It also gets rid of the other warts of the DAX
>    path due to pretending to be like direct I/O".  I assume by this you mean
>    the code in dax_do_io() around DIO_LOCKING, inode_dio_begin(), etc?

Yes.

>    Perhaps there are other things as well in XFS, but this is what I see in
>    the DAX code.  If so, yep, this seems like a win.  I don't understand how
>    DIO_LOCKING is relevant to the DAX I/O path, as we never mix buffered and
>    direct access.

It's related to doing stupid copy and paste from direct I/O in the DAX
code.

>    The comment in dax_do_io() for the inode_dio_begin() call says that it
>    prevents the I/O from races with truncate.  Am I correct that we now get
>    this protection via the xfs_rw_ilock()/xfs_rw_iunlock() calls in
>    xfs_file_dax_write()?

Yes, XFS always has a lock over reads that serializes with truncate.
Currenrly it's the XFS i_iolock, but I'll remove that soon and use the
VFS i_rwsem instead.  For ext2/4 we could go straight to i_rwsem in
shared mode.

> 2) Just a nit, I noticed that you used "~(PAGE_SIZE - 1)" in several places in
>    iomap_dax_actor() and iomap_dax_fault() instead of PAGE_MASK.  Was this
>    intentional?

Mostly because that's how I think.  I'm fine using PAGE_MASK, though.

> 3) It's kind of weird having iomap_dax_fault() in fs/dax.c but having
>    iomap_dax_actor() and iomap_dax_rw() in fs/iomap.c?  I'm guessing the
>    latter is placed where it is because it uses iomap_apply(), which is local
>    to fs/iomap.c?  Anyway, it would be nice if we could keep them together, if
>    possible.

It's still work in progress and could use a few cleanups.

> 
> 4) In iomap_dax_actor() you do this check:
> 
> 	WARN_ON_ONCE(iomap->type != IOMAP_MAPPED);
> 
>    If we hit this we should bail with -EIO, yea?  Otherwise we could write to
>    unmapped space or something horrible.

Fine with me.

> 5) In iomap_dax_fault, I think the "I/O beyond the end of the file" check
>    might have been broken.  Take for example an I/O to the second page of a
>    file, where the file has size one page.  So:

sure, I can fix this up.

> 6) Regarding the "we don't even have the size hole problem" comment in your
>    mail, the current PMD logic requires us to know the size of the hole.

And a big part of the iomap interface is proper reporting of holes.
