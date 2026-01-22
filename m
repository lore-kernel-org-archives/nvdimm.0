Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CF7301718;
	Thu, 22 Jan 2026 00:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769042692; cv=none; b=Rl2KoQlpM9pnK00msYQhdJ5IaP5NiNf0MlmvNOdwXvIrtpBrm2an8HxlE3NzGD+N8FjfWXccRCz4bVqWKjffyPi6E7wqLrbYwVyDma5W6qFUVstulACBSDdAEz6stFhjhEw+FL9e+ZNgO6M4DjHEs0liTjPgoWxYnXJMNbZZWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769042692; c=relaxed/simple;
	bh=0KhU76loRu3yDQ17lJEST2XjJDp55fYUgGPpvnMuEJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3ple22nqfgypDugTe8mcUVkXhEz2ePlTZmrOtMrsTeDAS1kGsVBC9lTg2Ujnf/DhheeYiZ4vBo8Fp2hb0sutY9R5fdUxO1p8WSc9H4e/mDawmLIQbAnDPrbQJI0+cZ0qYLyMyj8+sZ9qFIIUJ29+bzOFNbQeMFAsZFCL12EEog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOWDtl5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOWDtl5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFF6C4CEF1;
	Thu, 22 Jan 2026 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769042692;
	bh=0KhU76loRu3yDQ17lJEST2XjJDp55fYUgGPpvnMuEJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TOWDtl5QSGNmPY9SgTwaw1pfFj3gZHsUHGXLebewxz8azv3EZo2sjckB2G2Tpy669
	 wE9TBim+UaVDhuWykXyTX7T1muuG8EDgNNPMie2wkpy7qu07pjTnxE1HnP0hbinICa
	 pBtYM4HfhOAmPi+ONZPeGlCj7QBDx5fWNHaIZjedIPLEDIeoTkYyPSaKqO0uu3PmZ2
	 bS/6LyDvunPH5ORVa/Objt7AB0jsd5sZK+KB4W+3esaE6poHNdEFKtB83k3BRVp6LK
	 WWHR1+83O7zqSYUQa+sjC5Pbd2dNks/FdweQ+kuJsU/xdyCZE3IrWsFJxT7QtpKts7
	 HTtvPSQn5ijGw==
Date: Wed, 21 Jan 2026 16:44:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH 10/15] iomap: only call into ->submit_read when there is
 a read_ctx
Message-ID: <20260122004451.GN5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064339.206019-11-hch@lst.de>

On Wed, Jan 21, 2026 at 07:43:18AM +0100, Christoph Hellwig wrote:
> Move the NULL check into the callers to simplify the callees.  Not sure
> how fuse worked before, given that it was missing the NULL check.

Let's cc Joanne to find out then...? [done]

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/bio.c         | 5 +----
>  fs/iomap/buffered-io.c | 4 ++--
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index cb60d1facb5a..80bbd328bd3c 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -21,10 +21,7 @@ static void iomap_read_end_io(struct bio *bio)
>  static void iomap_bio_submit_read(const struct iomap_iter *iter,
>  		struct iomap_read_folio_ctx *ctx)
>  {
> -	struct bio *bio = ctx->read_ctx;
> -
> -	if (bio)
> -		submit_bio(bio);
> +	submit_bio(ctx->read_ctx);
>  }
>  
>  static void iomap_read_alloc_bio(const struct iomap_iter *iter,
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 4a15c6c153c4..6367f7f38f0c 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -572,7 +572,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
>  		iter.status = iomap_read_folio_iter(&iter, ctx,
>  				&bytes_submitted);
>  
> -	if (ctx->ops->submit_read)
> +	if (ctx->read_ctx && ctx->ops->submit_read)
>  		ctx->ops->submit_read(&iter, ctx);
>  
>  	iomap_read_end(folio, bytes_submitted);
> @@ -636,7 +636,7 @@ void iomap_readahead(const struct iomap_ops *ops,
>  		iter.status = iomap_readahead_iter(&iter, ctx,
>  					&cur_bytes_submitted);
>  
> -	if (ctx->ops->submit_read)
> +	if (ctx->read_ctx && ctx->ops->submit_read)
>  		ctx->ops->submit_read(&iter, ctx);
>  
>  	if (ctx->cur_folio)
> -- 
> 2.47.3
> 
> 
