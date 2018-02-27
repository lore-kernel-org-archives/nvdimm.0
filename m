Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 890EB22352288
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 08:55:33 -0800 (PST)
Date: Tue, 27 Feb 2018 18:01:38 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 05/12] ext4, dax: define ext4_dax_*() infrastructure
 in all cases
Message-ID: <20180227170138.3tdjcf7w6duc2ggb@quack2.suse.cz>
References: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151970522183.26729.1211859822335015752.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151970522183.26729.1211859822335015752.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 26-02-18 20:20:21, Dan Williams wrote:
> In preparation for fixing S_DAX to be defined in the CONFIG_FS_DAX=n +
> CONFIG_DEV_DAX=y case, move the definition of these routines outside of
> the "#ifdef CONFIG_FS_DAX" guard. This is also a coding-style fix to
> move all ifdef handling to header files rather than in the source. The
> compiler will still be able to determine that all the related code can
> be discarded in the CONFIG_FS_DAX=n case.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: <stable@vger.kernel.org>
> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index fb6f023622fe..51854e7608f0 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -34,7 +34,6 @@
>  #include "xattr.h"
>  #include "acl.h"
>  
> -#ifdef CONFIG_FS_DAX
>  static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  {
>  	struct inode *inode = file_inode(iocb->ki_filp);
> @@ -60,7 +59,6 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	file_accessed(iocb->ki_filp);
>  	return ret;
>  }
> -#endif
>  
>  static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  {
> @@ -70,10 +68,8 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	if (!iov_iter_count(to))
>  		return 0; /* skip atime */
>  
> -#ifdef CONFIG_FS_DAX
>  	if (IS_DAX(file_inode(iocb->ki_filp)))
>  		return ext4_dax_read_iter(iocb, to);
> -#endif
>  	return generic_file_read_iter(iocb, to);
>  }
>  
> @@ -179,7 +175,6 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	return iov_iter_count(from);
>  }
>  
> -#ifdef CONFIG_FS_DAX
>  static ssize_t
>  ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  {
> @@ -208,7 +203,6 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		ret = generic_write_sync(iocb, ret);
>  	return ret;
>  }
> -#endif
>  
>  static ssize_t
>  ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
