Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D95CA20958BDA
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 00:26:38 -0700 (PDT)
Date: Wed, 6 Sep 2017 09:29:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/9] ext4: remove duplicate extended attributes defs
Message-ID: <20170906072924.GA27916@quack2.suse.cz>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
 <20170905223541.20594-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170905223541.20594-2-ross.zwisler@linux.intel.com>
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
Cc: Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>, Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 05-09-17 16:35:33, Ross Zwisler wrote:
> The following commit:
> 
> commit 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
> interface support")
> 
> added several defines related to extended attributes to ext4.h.  They were
> added within an #ifndef FS_IOC_FSGETXATTR block with the comment:
> 
> /* Until the uapi changes get merged for project quota... */
> 
> Those uapi changes were merged by this commit:
> 
> commit 334e580a6f97 ("fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR
> promotion")
> 
> so all the definitions needed by ext4 are available in
> include/uapi/linux/fs.h.  Remove the duplicates from ext4.h.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Li Xi <lixi@ddn.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <dchinner@redhat.com>

Yeah, good cleanup. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 37 -------------------------------------
>  1 file changed, 37 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index a2bb7d2..c950278 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -644,43 +644,6 @@ enum {
>  #define EXT4_IOC_GET_ENCRYPTION_PWSALT	FS_IOC_GET_ENCRYPTION_PWSALT
>  #define EXT4_IOC_GET_ENCRYPTION_POLICY	FS_IOC_GET_ENCRYPTION_POLICY
>  
> -#ifndef FS_IOC_FSGETXATTR
> -/* Until the uapi changes get merged for project quota... */
> -
> -#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
> -#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
> -
> -/*
> - * Structure for FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR.
> - */
> -struct fsxattr {
> -	__u32		fsx_xflags;	/* xflags field value (get/set) */
> -	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> -	__u32		fsx_nextents;	/* nextents field value (get)	*/
> -	__u32		fsx_projid;	/* project identifier (get/set) */
> -	unsigned char	fsx_pad[12];
> -};
> -
> -/*
> - * Flags for the fsx_xflags field
> - */
> -#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
> -#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
> -#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
> -#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
> -#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
> -#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
> -#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
> -#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
> -#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
> -#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
> -#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
> -#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
> -#define FS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
> -#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
> -#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this */
> -#endif /* !defined(FS_IOC_FSGETXATTR) */
> -
>  #define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
>  #define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
>  
> -- 
> 2.9.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
