Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C10A2FB9
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 17:35:54 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280546113B;
	Mon, 19 Jul 2021 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1626716154;
	bh=NYmQ6IRkN/PxglP3djDkvgqrAEknbuBJU+iUM2YO1rE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ucVjyOviSaBpuw/7M2fEKs6WI3F51ULm8H1wvTSYV76JEBmCCABhLVsIoBXDU2QlM
	 y2/nVH7CcofyuZif5/RyR1fLanVEcd8uG9WSh5b1v8Kvzwn/nhWWKBPG0iLwbsr91p
	 n5kCHszSrLmhQS2cRCAwhGR2aoGQcQF9sP1zdX7thQMhVzj4ussWwZuJ/jqMQTjXpL
	 ICCJGBYWd1YMHjAkw+O0MVGnSaRwR1EG++WvwypX0klpg5XTBAB810uNnYbqqLvXpD
	 EGxz9RRgmZCQgDyVGxfFJPvRlUTQ21STN3t+VXOmZ0uwcLf4BLq6Lmj4rCkbHe+I8F
	 yvnSVdnmo6FXw==
Date: Mon, 19 Jul 2021 10:35:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 07/27] iomap: mark the iomap argument to
 iomap_read_page_sync const
Message-ID: <20210719173553.GG22357@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-8-hch@lst.de>

On Mon, Jul 19, 2021 at 12:35:00PM +0200, Christoph Hellwig wrote:
> iomap_read_page_sync never modifies the passed in iomap, so mark
> it const.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index e47380259cf7e1..8c26cf7cbd72b0 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -535,7 +535,7 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  
>  static int
>  iomap_read_page_sync(loff_t block_start, struct page *page, unsigned poff,
> -		unsigned plen, struct iomap *iomap)
> +		unsigned plen, const struct iomap *iomap)
>  {
>  	struct bio_vec bvec;
>  	struct bio bio;
> -- 
> 2.30.2
> 
