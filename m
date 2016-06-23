From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH 8/8] xfs: fix locking for DAX writes
Date: Thu, 23 Jun 2016 17:22:40 +0300
Message-ID: <576BF0B0.5080904@plexistor.com>
References: <1466609236-23801-1-git-send-email-hch@lst.de> <1466609236-23801-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1466609236-23801-9-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On 06/22/2016 06:27 PM, Christoph Hellwig wrote:
> So far DAX writes inherited the locking from direct I/O writes, but the direct
> I/O model of using shared locks for writes is actually wrong for DAX.  For
> direct I/O we're out of any standards and don't have to provide the Posix
> required exclusion between writers, but for DAX which gets transparently
> enable on applications without any knowledge of it we can't simply drop the
> requirement.  Even worse this only happens for aligned writes and thus
> doesn't show up for many typical use cases.
> 

Hi Sir Christoph

You raise a very interesting point and I would please like to ask questions.
Is this a theoretical standards problem or a real applications problem that
you know of?

You say above: " Posix required exclusion between writers"

As I understand, what it means is that if two threads/processes A & B write to the
same offset-length, in parallel. then a consistent full version will hold
of either A or B, which ever comes last. But never a torn version of both.

Is this really POSIX. I mean I knew POSIX is silly but so much so?
What about NFS CEPH Luster and all these network shared stuff. Does POSIX
say "On a single Node?". (Trond been yelling about file locks for *any* kind
of synchronization for years.)

And even with the write-lock to serialize writers (Or i_mute in case of ext4)
I do not see how this serialization works, because in a cached environment a
write_back can start and crash while the second thread above starts his memcopy
and on disk we still get a torn version of the record that was half from
A half from B. (Or maybe I do not understand what your automicity means)

Is not a rant I would really like to know what application uses this
"single-writer" facility and how does it actually works for them? I honestly
don't see how it works. (And do they really check that they are only working
on a local file system?)
Sorry for my slowness please explain?

BTW: I think that all the patches except this one makes a lot of sense
because of all the hidden quirks of direct_IO code paths. Just for example the
difference between "aligned and none align writes" as you mentioned above.

My $0.017:
Who In the real world would actually break without this patch, which
is not already broken?
And why sacrifice the vast majority of good applications for the sake
of an already broken (theoretical?) applications.

Thank you
Boaz

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0e74325..413c9e0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -714,24 +714,11 @@ xfs_file_dax_write(
>  	struct address_space	*mapping = iocb->ki_filp->f_mapping;
>  	struct inode		*inode = mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
>  	ssize_t			ret = 0;
> -	int			unaligned_io = 0;
> -	int			iolock;
> +	int			iolock = XFS_IOLOCK_EXCL;
>  	struct iov_iter		data;
>  
> -	/* "unaligned" here means not aligned to a filesystem block */
> -	if ((iocb->ki_pos & mp->m_blockmask) ||
> -	    ((iocb->ki_pos + iov_iter_count(from)) & mp->m_blockmask)) {
> -		unaligned_io = 1;
> -		iolock = XFS_IOLOCK_EXCL;
> -	} else if (mapping->nrpages) {
> -		iolock = XFS_IOLOCK_EXCL;
> -	} else {
> -		iolock = XFS_IOLOCK_SHARED;
> -	}
>  	xfs_rw_ilock(ip, iolock);
> -
>  	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
>  	if (ret)
>  		goto out;
> @@ -747,11 +734,6 @@ xfs_file_dax_write(
>  		WARN_ON_ONCE(ret);
>  	}
>  
> -	if (iolock == XFS_IOLOCK_EXCL && !unaligned_io) {
> -		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
> -		iolock = XFS_IOLOCK_SHARED;
> -	}
> -
>  	trace_xfs_file_dax_write(ip, iov_iter_count(from), iocb->ki_pos);
>  
>  	data = *from;
> 

