Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F616D00
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 17:35:44 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A1286113E;
	Mon, 19 Jul 2021 17:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1626716144;
	bh=ZghwYSjgYvCm6XwkQ3nFC/zAMdMRI/NSmSKvpNwNsSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qk+Wgbz9Gf4L8i+Omnpvv6j3D138WkcPi3wZUMTa+v5510cqwAdQR+OqZ/NG4uABZ
	 E97x38Mbtn1OH7BAw+cTaK2Vv8vlUO790H+TQqHxvfeDTl8onvlPQ2eEKMS8kNboSd
	 KD5ncqfNVwkv/ydE9fAHbrb5wlfJUEaq/VTQJPvadr3619jYQcjRoedz9YR5IQlqFu
	 Xxt+rC+NXxcA93Ntbp9q872yGrSvs/L/cR+GwOh1qrl86rD0v4lV3rlHLzr2T0XYTt
	 HY2RsyrAtxDiipFdNNMQBYj44DgJfxFVBr6BIzmqVgZXYw3DfNtv0Ku6dqHDUOSm0w
	 WtB4m0WcLNzIA==
Date: Mon, 19 Jul 2021 10:35:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 06/27] iomap: mark the iomap argument to
 iomap_read_inline_data const
Message-ID: <20210719173543.GF22357@magnolia>
References: <20210719103520.495450-1-hch@lst.de>
 <20210719103520.495450-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719103520.495450-7-hch@lst.de>

On Mon, Jul 19, 2021 at 12:34:59PM +0200, Christoph Hellwig wrote:
> iomap_read_inline_data never modifies the passed in iomap, so mark
> it const.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 75310f6fcf8401..e47380259cf7e1 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -207,7 +207,7 @@ struct iomap_readpage_ctx {
>  
>  static void
>  iomap_read_inline_data(struct inode *inode, struct page *page,
> -		struct iomap *iomap)
> +		const struct iomap *iomap)
>  {
>  	size_t size = i_size_read(inode);
>  	void *addr;
> -- 
> 2.30.2
> 
