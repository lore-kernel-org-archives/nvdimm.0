Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9461E2858
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769451140; cv=none; b=R0juyTo7zJssxMyk+R8qIh6hUiD30nmc9TTLEn8sdobnpxrcLyRgfs7MeTTxA53KpipT0vqu/4htD0yf8Qe/4uoAgpLUy+c4OC8g/Wg5REPhGca1UXOyHbZELg266oib3Mk+8Z80N7Al7El22+vUl595wJYCft1dvHl1wfpKRdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769451140; c=relaxed/simple;
	bh=dUDJklRUyBCtwVBXqiZuTlf4ktJxUuHhz0YhaaM3L5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=CpaNeAKLTErKFqC1I0edlLQ2KcGoeJtqEwgO6InatYy4jCvByzhVfRHWXdeVDYt37MKbV8idbzDUQ/pWDcbBy/nyY1K7wYS3xLPMYpqTjyvjrkZ8CkF3RLaLI/ZSowiTyn5qkBnAAt4tC3fvZETkT4iIBdM2CZc0h0v/0mFYApU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ePaB18WJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ePaB18WJ"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260126181216epoutp046ca0939347d8b35ccf05a6e8e441b1b1~OWm7wjMEH1387913879epoutp04r
	for <nvdimm@lists.linux.dev>; Mon, 26 Jan 2026 18:12:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260126181216epoutp046ca0939347d8b35ccf05a6e8e441b1b1~OWm7wjMEH1387913879epoutp04r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769451136;
	bh=HI9T2RA7VOtVuTSzybt8pORWuVyrZSQXeAtg/v4Fa4k=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ePaB18WJeimp9QkKHAuBSTpvFWwc4tyhJuDaGMKvAKsEyHR0yeFzBiJLniLNi/Ci9
	 lU8QHbCheF+Ba9H3wos4Ssh7d0eaRSkU8dzm9pBURQD9rxOeqfsSFs1wBw7+q/+jZA
	 dF40Y10FQnFeeFXc7dObeQOOGWbGboMMomEcgTjs=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260126181215epcas5p191ed832304a212ec72f7dc6d7dca698c~OWm7NZo-j0315803158epcas5p1P;
	Mon, 26 Jan 2026 18:12:15 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.92]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f0GpQ4J00z6B9m4; Mon, 26 Jan
	2026 18:12:14 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260126181213epcas5p4af751bc99b8580fa9ce35639c29dabdc~OWm5HONnU2857928579epcas5p4B;
	Mon, 26 Jan 2026 18:12:13 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260126181211epsmtip27bf74f74dd344e89aa167a9d696f9bc8~OWm3pJ0TC1200712007epsmtip2r;
	Mon, 26 Jan 2026 18:12:11 +0000 (GMT)
Message-ID: <95af59e3-fe94-4d62-8931-5b8a9c7f8429@samsung.com>
Date: Mon, 26 Jan 2026 23:42:10 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/15] block: add fs_bio_integrity helpers
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260121064339.206019-7-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260126181213epcas5p4af751bc99b8580fa9ce35639c29dabdc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260121064416epcas5p3aa66a19640d8d7411016e34a1fee0592
References: <20260121064339.206019-1-hch@lst.de>
	<CGME20260121064416epcas5p3aa66a19640d8d7411016e34a1fee0592@epcas5p3.samsung.com>
	<20260121064339.206019-7-hch@lst.de>

On 1/21/2026 12:13 PM, Christoph Hellwig wrote:
> +void fs_bio_integrity_alloc(struct bio *bio)
> +{
> +	struct fs_bio_integrity_buf *iib;
> +	unsigned int action;
> +
> +	action = bio_integrity_action(bio);
> +	if (!action)
> +		return;

So this may return from here, but <below>

> +
> +	iib = mempool_alloc(&fs_bio_integrity_pool, GFP_NOIO);
> +	bio_integrity_init(bio, &iib->bip, &iib->bvec, 1);
> +
> +	bio_integrity_alloc_buf(bio, action & BI_ACT_ZERO);
> +	if (action & BI_ACT_CHECK)
> +		bio_integrity_setup_default(bio);
> +}
> +
> +void fs_bio_integrity_free(struct bio *bio)
> +{
> +	struct bio_integrity_payload *bip = bio_integrity(bio);
> +
> +	bio_integrity_free_buf(bip);
> +	mempool_free(container_of(bip, struct fs_bio_integrity_buf, bip),
> +			&fs_bio_integrity_pool);
> +
> +	bio->bi_integrity = NULL;
> +	bio->bi_opf &= ~REQ_INTEGRITY;
> +}
> +
> +void fs_bio_integrity_generate(struct bio *bio)
> +{
> +	fs_bio_integrity_alloc(bio);

no check here. A potential null pointer deference in the next line as 
bio has no bip?
> +	bio_integrity_generate(bio);
> +}

