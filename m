Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D24BF223522A3
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 09:00:24 -0800 (PST)
Date: Tue, 27 Feb 2018 18:06:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 10/12] fs, dax: kill IS_DAX()
Message-ID: <20180227170629.t54gjterrprylp3w@quack2.suse.cz>
References: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151970524837.26729.14336810163194275690.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151970524837.26729.14336810163194275690.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 26-02-18 20:20:48, Dan Williams wrote:
> In preparation for fixing the broken definition of S_DAX in the
> CONFIG_FS_DAX=n + CONFIG_DEV_DAX=y case, convert all the remaining
> IS_DAX() usages to use explicit tests for FSDAX.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap.c          |    2 +-
>  include/linux/dax.h |    2 +-
>  include/linux/fs.h  |    3 +--
>  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index afd163586aa0..fe379d8949fd 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -377,7 +377,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
>  		offset = pos & (PAGE_SIZE - 1); /* Within page */
>  		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
>  
> -		if (IS_DAX(inode))
> +		if (IS_FSDAX(inode))
>  			status = iomap_dax_zero(pos, offset, bytes, iomap);
>  		else
>  			status = iomap_zero(inode, pos, offset, bytes, iomap);
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 47edbce4fc52..ce520e932adc 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -124,7 +124,7 @@ static inline ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  
>  static inline bool dax_mapping(struct address_space *mapping)
>  {
> -	return mapping->host && IS_DAX(mapping->host);
> +	return mapping->host && IS_FSDAX(mapping->host);
>  }
>  
>  struct writeback_control;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4a5aa8761011..8021f10068d3 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1903,7 +1903,6 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
>  #define IS_IMA(inode)		((inode)->i_flags & S_IMA)
>  #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
>  #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
> -#define IS_DAX(inode)		((inode)->i_flags & S_DAX)
>  #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
>  
>  #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
> @@ -3203,7 +3202,7 @@ extern int file_update_time(struct file *file);
>  
>  static inline bool io_is_direct(struct file *filp)
>  {
> -	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
> +	return (filp->f_flags & O_DIRECT) || IS_FSDAX(filp->f_mapping->host);
>  }
>  
>  static inline bool vma_is_dax(struct vm_area_struct *vma)
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
