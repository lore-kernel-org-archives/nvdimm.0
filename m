Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7833016FB;
	Thu, 22 Jan 2026 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769042606; cv=none; b=iw3k0aG2ZJxH55o95Y+G2ZzIRhJD2J/GX4oPH6zMmmy/7J131pdgsI+ZsSQAv7d1bD/RH+WcrshryKHQzxiKytE7Z2Btzo44hNXB3E7PkhhNA8WjfAU2odrZOTluT0A1Hk53jw8kuxYRPaqMClPlYXQFakkFcHZkmrd3uUfcn24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769042606; c=relaxed/simple;
	bh=KbJ1yGsy0ntvhvAk7W5KUIRqpIXW2ZbmAs0VFBYc41g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lbw4xWFcKmaGKe1UbWrnlh5yLBUnLlnSBxbg6ynjclwuh0r2DFiqH1WEP8+02sSwJz0UQUrAlMQHzSi/mX4pnFTtG03dGpTwe2NUXk/qlL1ChxU6UCisQHA+BkbtoAEDYCgmyiv96OIfA29OWVQtDURLMY9uU3gPdvLE8do9Wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdjGH09e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdjGH09e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DB2C4CEF1;
	Thu, 22 Jan 2026 00:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769042605;
	bh=KbJ1yGsy0ntvhvAk7W5KUIRqpIXW2ZbmAs0VFBYc41g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KdjGH09e0b1/cXmiFklauSskVDq57z0At2bSBE3AXz4W9nlyLZFZJxCYoV4rmeuMB
	 X41/ox2jDEOrdPnCMz3/WAbgFGc+xPh46kxpD2EA1yMnXQo+LVAcRFkG/UlL5JGJuy
	 pFMn678I77uSe6ZGcVhcFVDv0ngAhMoThg8PHbPzp+kmLLHQ2Y006OwwMGC/zyljGT
	 s+q3tQEsym4HLeVbCXnanNGb+kSfrAw2sYxiJpAlahE/2Wge3VQ7DeLtqxwJObvQhc
	 HWnoI2Ty38NfkXD5FJvsMsFN2BJo96T9QSzy3RMaT7M9fcXxEHqzCPwqyIXEfrcdRa
	 Ep0c7lVQEdSxQ==
Date: Wed, 21 Jan 2026 16:43:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] iomap: pass the iomap_iter to ->submit_read
Message-ID: <20260122004324.GM5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064339.206019-10-hch@lst.de>

On Wed, Jan 21, 2026 at 07:43:17AM +0100, Christoph Hellwig wrote:
> This provides additional context for file systems.
> 
> Rename the fuse instance to match the method name while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine, will probably have more comments when we start accessing the
iter...

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/fuse/file.c         | 5 +++--
>  fs/iomap/bio.c         | 3 ++-
>  fs/iomap/buffered-io.c | 4 ++--
>  include/linux/iomap.h  | 3 ++-
>  4 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..99b79dc876ea 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -947,7 +947,8 @@ static int fuse_iomap_read_folio_range_async(const struct iomap_iter *iter,
>  	return ret;
>  }
>  
> -static void fuse_iomap_read_submit(struct iomap_read_folio_ctx *ctx)
> +static void fuse_iomap_submit_read(const struct iomap_iter *iter,
> +		struct iomap_read_folio_ctx *ctx)
>  {
>  	struct fuse_fill_read_data *data = ctx->read_ctx;
>  
> @@ -958,7 +959,7 @@ static void fuse_iomap_read_submit(struct iomap_read_folio_ctx *ctx)
>  
>  static const struct iomap_read_ops fuse_iomap_read_ops = {
>  	.read_folio_range = fuse_iomap_read_folio_range_async,
> -	.submit_read = fuse_iomap_read_submit,
> +	.submit_read = fuse_iomap_submit_read,
>  };
>  
>  static int fuse_read_folio(struct file *file, struct folio *folio)
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 578b1202e037..cb60d1facb5a 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -18,7 +18,8 @@ static void iomap_read_end_io(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> -static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
> +static void iomap_bio_submit_read(const struct iomap_iter *iter,
> +		struct iomap_read_folio_ctx *ctx)
>  {
>  	struct bio *bio = ctx->read_ctx;
>  
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 6beb876658c0..4a15c6c153c4 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -573,7 +573,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
>  				&bytes_submitted);
>  
>  	if (ctx->ops->submit_read)
> -		ctx->ops->submit_read(ctx);
> +		ctx->ops->submit_read(&iter, ctx);
>  
>  	iomap_read_end(folio, bytes_submitted);
>  }
> @@ -637,7 +637,7 @@ void iomap_readahead(const struct iomap_ops *ops,
>  					&cur_bytes_submitted);
>  
>  	if (ctx->ops->submit_read)
> -		ctx->ops->submit_read(ctx);
> +		ctx->ops->submit_read(&iter, ctx);
>  
>  	if (ctx->cur_folio)
>  		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index ea79ca9c2d6b..bf6280fc51af 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -512,7 +512,8 @@ struct iomap_read_ops {
>  	 *
>  	 * This is optional.
>  	 */
> -	void (*submit_read)(struct iomap_read_folio_ctx *ctx);
> +	void (*submit_read)(const struct iomap_iter *iter,
> +			struct iomap_read_folio_ctx *ctx);
>  };
>  
>  /*
> -- 
> 2.47.3
> 
> 
