Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168551;
	b=1A6e/1zRT6c+nSeQD+Xw7FUBkJW/AOJBZglrBwxKJSrZKBPpOL1ijenKtivhxwZRWHkG
	 B5WmBuSzLUgxn0SiKCZAz/a5kScdIF1TNVFHO/4mbVAlrj+eo9W3+PClFBozC9/iB5+gO
	 HSw5IhuLXl5iEMWLTxv2VFcnW0VT4u8Up+E7ku9keH4/kjL0G86aGWufOZrj+A+ootl9e
	 szoKlTxw99qJizoZOuv89xrAIJ3MjqghAsYyhYIY0zrQ/3jFK9/kO/qu56AP3sWTRJG60
	 fZrLKMRjbbtfbjSlbGd2T/3pQ0/1YDZDzZX7T44rWiUXqKPAUeSQq0mqdIEiT9OxqBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168551;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qyrgnqyAtWqlxuswsMQE0t4cgrkAkoCIR2wECYGDFYE=;
	b=li6U8S1NLATVZM1ovYIcgfX/BnXQb4M4fTqbzjjFfcWZQmOSziBzmVvrwcBYnKc0hP8l
	 evEo5q12opBA/3sLxWsGKQsJzhviVX6jk/+76HJcy0rxFJ7UdPZn0hAC1IoRFBjkrETzY
	 MS6wj2M/VH33Nkn3v6cWuVPiP81pY1rRjxCnJAuBW7onkE2Qvw0RPxmeZOEQvRB382nuw
	 YrZ2rWphhK2YjO1vk3X1EE4xtH/SqKhBjovSpp7snmOSpPvtdBNYDmb3eeoo0iy1fuEUG
	 Woz/ekvGAHXJusevuyiNVa1ZMaSRo/rD/ioOSWF+u9gw+eKzsaBbH2iM1XO5NWvsoIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GP0u4gdA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482D60A260B;
	Fri, 20 Nov 2026 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GP0u4gdA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E9F1F000C4;
	Fri, 20 Nov 2026 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168550;
	bh=qyrgnqyAtWqlxuswsMQE0t4cgrkAkoCIR2wECYGDFYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GP0u4gdAojIMgPsbZyvPNMOhmUxd/MzlJD8JRl9D77ESr9JnULCKtvoWeSgrMzj5e
	 BM4BXyoib7MJcqQH8cMnqHclQIjzDlbR35ErJtS9NDuSSAxyxnktr3EzRENR1LD7wB
	 kZYJe4gaZY7uQSw/SqL/Ml/+78Uog0rd4NblK7ZlADqxwvR/D4RcSoVmrV8+CwuiOP
	 bJ39TDLj1Fl5fdgpN7RRBsTDMP4RTTWhgV71BHM29aCcOjpJanTD/ymlXCmfBVGA8o
	 LF0JjU29TF1fr57T/VklvVc7mSKTCIAIu8y43985XxKsyq/QG98YmBlJJ0XvzdhHzg
	 8Vj11qV+C2oGg==
Date: Fri, 20 Nov 2026 10:55:40 +0100
From: Christian Brauner <brauner@kernel.org>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>, 
	Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj1072538@gmail.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	Sumit Semwal <sumit.semwal@linaro.org>, christian.koenig@amd.com, Philipp Stanner <phasta@kernel.org>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, asml.silence@gmail.com, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>, 
	Mengmeng Zhao <zhaomengmeng@kylinos.cn>
Subject: Re: [RFC PATCH v2 6/8] fs: add FMODE_CAN_DMABUF_IO and require it
 for dma-buf I/O contexts
Message-ID: <20261120-faust-bohnenkraut-reduzieren-a30811186a15@brauner>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-7-mengmeng.zhao@linux.dev>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261113070621.273953-7-mengmeng.zhao@linux.dev>

On Fri, Nov 13, 2026 at 03:06:19PM +0800, Mengmeng Zhao wrote:
> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> 
> Add a file mode bit for files that can be the target of dma-buf I/O and
> require it when a buffer is registered.  Block device files set it when
> the backing disk supports dma-buf I/O, and filesystems can set it for
> inodes whose data can be reached without the page cache.  The bit is
> coarse: a driver that installs ->init_dma_buf_io_ctx for every
> namespace, like nvme, still decides per device at registration.
> 
> dma_buf_io_ctx_create() is the only caller of ->init_dma_buf_io_ctx, so
> the capability and the O_DIRECT requirement are checked there for every
> file type rather than in each helper; O_DIRECT belongs at registration
> because F_SETFL can change it afterwards.  Add bdev_can_dmabuf_io() so
> the open-time and registration checks share one predicate.
> 
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>
> ---
>  block/bdev.c                 |  8 ++++----
>  block/fops.c                 |  2 +-
>  drivers/dma-buf/dma-buf-io.c | 13 +++++++++----
>  include/linux/blkdev.h       |  7 ++++++-
>  include/linux/fs.h           |  8 +++++++-
>  5 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index 88e3f552f5d4..4e7a7f7e1e8b 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -61,14 +61,12 @@ struct block_device *file_bdev(struct file *bdev_file)
>  }
>  EXPORT_SYMBOL(file_bdev);
>  
> -int bdev_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
> +int bdev_init_dma_buf_io_ctx(struct block_device *bdev,
>  			     struct dma_buf_io_ctx *ctx)
>  {
> -	if (!(file->f_flags & O_DIRECT))
> -		return -EINVAL;
>  	if (ctx->dmabuf->size > UINT_MAX)
>  		return -EINVAL;
> -	if (!bdev->bd_disk->fops->init_dma_buf_io_ctx)
> +	if (!bdev_can_dmabuf_io(bdev))
>  		return -EOPNOTSUPP;
>  	return bdev->bd_disk->fops->init_dma_buf_io_ctx(bdev, ctx);
>  }
> @@ -1041,6 +1039,8 @@ int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
>  
>  	bdev_file->f_flags |= O_LARGEFILE;
>  	bdev_file->f_mode |= FMODE_CAN_ODIRECT;
> +	if (bdev_can_dmabuf_io(bdev))
> +		bdev_file->f_mode |= FMODE_CAN_DMABUF_IO;
>  	if (bdev_nowait(bdev))
>  		bdev_file->f_mode |= FMODE_NOWAIT;
>  	if (mode & BLK_OPEN_RESTRICT_WRITES)
> diff --git a/block/fops.c b/block/fops.c
> index 86bf1f298b79..7e5702e047a2 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -1008,7 +1008,7 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
>  static int blkdev_init_dma_buf_io_ctx(struct file *file,
>  				      struct dma_buf_io_ctx *ctx)
>  {
> -	return bdev_init_dma_buf_io_ctx(file, file_bdev(file), ctx);
> +	return bdev_init_dma_buf_io_ctx(file_bdev(file), ctx);
>  }
>  
>  const struct file_operations def_blk_fops = {
> diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
> index 8440151de860..9575b7d65ec5 100644
> --- a/drivers/dma-buf/dma-buf-io.c
> +++ b/drivers/dma-buf/dma-buf-io.c
> @@ -152,9 +152,11 @@ static void dma_buf_io_ctx_shutdown(struct dma_buf_io_ctx *ctx)
>   * @out_ctx:	[out]	resulting ctx
>   *
>   * Create a new I/O context from the given DMA buffer for the given file.
> - * It only works with files implementing ->init_dma_buf_io_ctx and fails
> - * with -EOPNOTSUPP otherwise. Once created, the user can create a map
> - * and use it to issue I/O, such as read/write requests, to @file.
> + * It only works with files implementing ->init_dma_buf_io_ctx,
> + * advertising FMODE_CAN_DMABUF_IO and currently opened for direct I/O,
> + * and fails with -EOPNOTSUPP or -EINVAL otherwise. Once created, the
> + * user can create a map and use it to issue I/O, such as read/write
> + * requests, to @file.
>   */
>  int dma_buf_io_ctx_create(struct file *file,
>  			   struct dma_buf *dmabuf,
> @@ -164,8 +166,11 @@ int dma_buf_io_ctx_create(struct file *file,
>  	struct dma_buf_io_ctx *ctx;
>  	int ret;
>  
> -	if (!file->f_op->init_dma_buf_io_ctx)
> +	if (!file->f_op->init_dma_buf_io_ctx ||
> +	    !(file->f_mode & FMODE_CAN_DMABUF_IO))
>  		return -EOPNOTSUPP;
> +	if (!(file->f_flags & O_DIRECT))
> +		return -EINVAL;
>  
>  	ctx = kzalloc_obj(*ctx);
>  	if (!ctx)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b98f43478cc0..0cfb6fb6b4e2 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1610,9 +1610,14 @@ struct block_device_operations {
>  	int (*alternative_gpt_sector)(struct gendisk *disk, sector_t *sector);
>  };
>  
> -int bdev_init_dma_buf_io_ctx(struct file *file, struct block_device *bdev,
> +int bdev_init_dma_buf_io_ctx(struct block_device *bdev,
>  			     struct dma_buf_io_ctx *ctx);
>  
> +static inline bool bdev_can_dmabuf_io(struct block_device *bdev)
> +{
> +	return !!bdev->bd_disk->fops->init_dma_buf_io_ctx;
> +}
> +
>  #ifdef CONFIG_COMPAT
>  extern int blkdev_compat_ptr_ioctl(struct block_device *, blk_mode_t,
>  				      unsigned int, unsigned long);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..f5524fc770d4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -121,7 +121,13 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  /* File supports atomic writes */
>  #define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)(1 << 7))
>  
> -/* FMODE_* bit 8 */
> +/*
> + * File can be the target of dma-buf I/O.  Set it for files whose data can be
> + * reached with direct I/O without the page cache: a dma-buf iterator has no
> + * pages to copy, so a buffered path cannot serve it.  The bit is coarse; both
> + * the device behind it and O_DIRECT are checked when a buffer is registered.
> + */
> +#define FMODE_CAN_DMABUF_IO	((__force fmode_t)(1 << 8))

This is stealing yet another FMODE_* bit for special-purpose stuff.
We're really really short of them. Did Christoph suggest this?
