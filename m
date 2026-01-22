Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12CA28935A;
	Thu, 22 Jan 2026 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769042974; cv=none; b=GkISRLZ7qMMz4HaNHmh/rO/hGMxOAYKUixqti4dZ8XVbFnc7/RIluL84Q4hoN/Vug2ygs6P7o3mnvF7fwiA5IcC/r+kLEx7qBMN7ovt/1rgdU15S9zVikCwapwoxq0SAMwqJsl6j87NeqycmD886OcmB31PUPFXxkUmM2ksbpyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769042974; c=relaxed/simple;
	bh=Oe/a/y7zPsCHv5d4FMUGXcSXbAFZsOXzwsiw4OLY1pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fv6FmRhfCWBzwJAtBOPmSVL9fO8R3EP/7WT4aMOG2NMPnF1HjXx4Hy5uPIP9rArfjwssVncryNZ+T1uR6Fwy8nkMUdGMHFpc/D2I3+bqXjRAhuGc3bnBlHopc8G3smuf166MUcxEbkS+SAspfvq8pqlgVNMk7amXALJgQxzryvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sRGlq13K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sRGlq13K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10006C4CEF1;
	Thu, 22 Jan 2026 00:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769042974;
	bh=Oe/a/y7zPsCHv5d4FMUGXcSXbAFZsOXzwsiw4OLY1pw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sRGlq13KC7NM8cn1a9qqeSLU7bTVQJwcu5TQiKpB8Ve+BiWZb973MeL2QjwXJtGXj
	 4g8q2KP+jjVRbr/SjVZ8eB8RwyabpgR8PBo/2wnZ8gCJzprJ0EcbQ34w1NiBTjXP89
	 uft0f609V6aiX1Qu6cNzla/3jbS3tbf8I1IX2Rp7L17WXxZ5HqdJluLLdnNKm3Wq6n
	 M963+oiYnA5UXEbMG1gOtSx9aNwULSU+OLkciB9JJSm4C+hn6UR+8abRN18pz6uk+D
	 bkeny7tyrehInBbI4KiIbaJ4Teatp9Co0DDx9sq39Cl7BCasQsoAoG7IeZoxb1Vmf6
	 1vNDXwBO+uSlg==
Date: Wed, 21 Jan 2026 16:49:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/15] iomap: allow file systems to hook into buffered
 read bio submission
Message-ID: <20260122004933.GO5945@frogsfrogsfrogs>
References: <20260121064339.206019-1-hch@lst.de>
 <20260121064339.206019-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064339.206019-12-hch@lst.de>

On Wed, Jan 21, 2026 at 07:43:19AM +0100, Christoph Hellwig wrote:
> Files ystems such as btrfs have additional operations with bios such as

  Filesystems

> verifying data checksums.  Allow file systems to hook into submission
> of the bio to allow for this processing by replacing the direct
> submit_bio call in iomap_read_alloc_bio with a call into ->submit_read
> and exporting iomap_read_alloc_bio.  Also add a new field to
> struct iomap_read_folio_ctx to track the file logic offset of the current
> read context.

Basically you're enabling filesystems to know what's the offset of a
read bio that iomap is about to start?  I guess that enables btrfs to
stash that info somewhere so that when the bio completes, it can go look
up the checksum or something, and compare?

Or for PI the filesystem can do the PI validation itself and if that
fails, decide if it's going to do something evil like ask another
replica to try reading the information?

(Not that iomap handles overlapping redundant mappings at all...)

--D

> Based on a patch from Goldwyn Rodrigues <rgoldwyn@suse.com>.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/bio.c        | 15 +++++++++------
>  include/linux/iomap.h |  4 ++++
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 80bbd328bd3c..903cb9fe759e 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -32,10 +32,11 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
>  	struct folio *folio = ctx->cur_folio;
>  	gfp_t gfp = mapping_gfp_constraint(folio->mapping, GFP_KERNEL);
>  	gfp_t orig_gfp = gfp;
> -	struct bio *bio = ctx->read_ctx;
> +	struct bio *bio;
>  
> -	if (bio)
> -		submit_bio(bio);
> +	/* Submit the existing range if there was one. */
> +	if (ctx->read_ctx)
> +		ctx->ops->submit_read(iter, ctx);
>  
>  	/* Same as readahead_gfp_mask: */
>  	if (ctx->rac)
> @@ -56,9 +57,10 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
>  	bio_add_folio_nofail(bio, folio, plen,
>  			offset_in_folio(folio, iter->pos));
>  	ctx->read_ctx = bio;
> +	ctx->read_ctx_file_offset = iter->pos;
>  }
>  
> -static int iomap_bio_read_folio_range(const struct iomap_iter *iter,
> +int iomap_bio_read_folio_range(const struct iomap_iter *iter,
>  		struct iomap_read_folio_ctx *ctx, size_t plen)
>  {
>  	struct folio *folio = ctx->cur_folio;
> @@ -70,10 +72,11 @@ static int iomap_bio_read_folio_range(const struct iomap_iter *iter,
>  		iomap_read_alloc_bio(iter, ctx, plen);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(iomap_bio_read_folio_range);
>  
>  const struct iomap_read_ops iomap_bio_read_ops = {
> -	.read_folio_range = iomap_bio_read_folio_range,
> -	.submit_read = iomap_bio_submit_read,
> +	.read_folio_range	= iomap_bio_read_folio_range,
> +	.submit_read		= iomap_bio_submit_read,
>  };
>  EXPORT_SYMBOL_GPL(iomap_bio_read_ops);
>  
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index bf6280fc51af..b3f545d41720 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -493,6 +493,7 @@ struct iomap_read_folio_ctx {
>  	struct folio		*cur_folio;
>  	struct readahead_control *rac;
>  	void			*read_ctx;
> +	loff_t			read_ctx_file_offset;
>  };
>  
>  struct iomap_read_ops {
> @@ -599,6 +600,9 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
>  extern struct bio_set iomap_ioend_bioset;
>  
>  #ifdef CONFIG_BLOCK
> +int iomap_bio_read_folio_range(const struct iomap_iter *iter,
> +		struct iomap_read_folio_ctx *ctx, size_t plen);
> +
>  extern const struct iomap_read_ops iomap_bio_read_ops;
>  
>  static inline void iomap_bio_read_folio(struct folio *folio,
> -- 
> 2.47.3
> 
> 
