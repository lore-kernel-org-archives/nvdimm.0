Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B738343D64;
	Fri, 21 Nov 2025 10:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763721081; cv=none; b=Gp1pyw8qAWvkwTkhT3rjQQ8/vcmhSHeJKoCZQtr38TBBhggMJRpEKPRdpbceWoJqiO1USG45m584zdqm2IvENfvT+ReBLC0ok0kQ+og2D9LB62NM6BfcOhlg9X/dzKBMKToNqFOBhCK1UHJkd2tK0U/vrY5YS8N83MqA5NJVLvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763721081; c=relaxed/simple;
	bh=fYliNSz38g9K7v8gdpPSbjBWhdWYh58ggiwo0jQ4ZSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvftSsuDJpHIE8+mBTQpJMwxwRu+F8AT7RfkfRHRBp0kQzBT0rOXjgojnVz+c9iC4Us4dDGVAnT3L0kcoK9UweQOqYupdCMQ3T+SDPkXTnqvg5nLghUWHRSp0lR83uGXNTrCFi8LnaspjJMw4kXwmHmJt7zrauilWhwqNn2MBgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LR3hC0FL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LR3hC0FL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JJyVRNZOtQqKe7tfE+8bLRPSTjQYbFyCIpb/8HJmjgw=; b=LR3hC0FLOmjplHywsW2dGP6ou/
	n+kTTf5mhgb075B0glYmtxFsKLg+6XQaYIPWywqeHlGjJricYWEnEkFO+5kQ2hms1Od+YFEH1D+7u
	ImxQpS408l9ucxC6owBxgPIlNnFpkJIkri4y1aiEi1rUx3oM8yth2t2nnMrAAGkeGc6GE0lMbyjLd
	CdWq1mJSNAYfdRA9iYtaxCpeJTXij/vwqUeDki3mSme9QfrOJa3iivA1Rj4wNXBAsaPy4bKBTspfO
	CKXq4otDGhFQM2lNtckUnjxEcBYeCedseTKna73IzzdJv00/Do5VTheDVnQPJDATt4w1ivooZDPyo
	dwLbOPUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMOQ9-00000008End-0Odg;
	Fri, 21 Nov 2025 10:31:17 +0000
Date: Fri, 21 Nov 2025 02:31:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure
 problems during append write
Message-ID: <aSA_dTktkC85K39o@infradead.org>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121081748.1443507-2-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 21, 2025 at 04:17:40PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index b3a79285c27..55c2c1a0020 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>  
>  static void bio_chain_endio(struct bio *bio)
>  {
> -	bio_endio(__bio_chain_endio(bio));
> +	bio_endio(bio);

I don't see how this can work.  bio_chain_endio is called literally
as the result of calling bio_endio, so you recurse into that.

Also please put your analysis of the problem into this patch as
said by Johannes.  And please wrap it at 73 characters as the wall of
text in the cover letter is quite unreadable.

