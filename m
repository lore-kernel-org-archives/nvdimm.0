Received: from mail87.out.titan.email (mail87.out.titan.email [209.209.25.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A672046A4
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 10:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134287; cv=none; b=ne3/GcIRD7fOaqPLqrTg01B+R9loCui0g/0POfVjPdjvaY97Gxf3axJSUVKSHBOsTrH/1xnc2ow5b01xd2g9GS2GY8e6dq27doY5j5tlLFUkDjNdMi1j2bb3nQc3dmFW87i7CoM80wbg1iMxlyU0YgxSnNM5rhGVsGdlVmC9bsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134287; c=relaxed/simple;
	bh=ST+REIAvtLM2EfHTQdejogwwPWs0d5CZXLFqhlK+QKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLPJgf4upUibD8SJWbKvhSM1SJmevvs1eHIzhf6VxncriadLaTgwOhsJgMnhqpHNKS7MoDbyXuJ+MRPk+tHYCCC6blvD2dqvTMcmBU7r5kf0yRYUlH0NjhT6a/T0CRvz6ZbdapF3XD3I/F9fL1jCaxW0C2YP0IxJZWIj9UR0WyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=BvQOp7m4; arc=none smtp.client-ip=209.209.25.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="BvQOp7m4"
DKIM-Signature: a=rsa-sha256; bh=HJViwRYJWG0zNvDaTVc4+RRFIFm3biUDQdBU/Kmd2zQ=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=from:message-id:in-reply-to:to:cc:mime-version:date:subject:references:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1740133684; v=1;
	b=BvQOp7m46YRQYV50svyQ6koecodDG/5NMZ1UF38ZuolCivbcflH9CYqfws8I3uuV0QqBQ9Tt
	ne/tv2u/zpF7pqJjplOvpOMEfJc25LVrgVcSnYuTYDElRO0wMIQ1u4AHTiy90cBq3YAccdrTLdX
	EQ+Fg+8qEfkLJxQeH/Z55vho=
Received: from studio.local (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id AC874E04DF;
	Fri, 21 Feb 2025 10:27:55 +0000 (UTC)
Date: Fri, 21 Feb 2025 18:27:52 +0800
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, colyli@kernel.org, 
	yukuai3@huawei.com, dan.j.williams@intel.com, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, ira.weiny@intel.com, dlemoal@kernel.org, yanjun.zhu@linux.dev, 
	kch@nvidia.com, hare@suse.de, zhengqixing@huawei.com, john.g.garry@oracle.com, 
	geliang@kernel.org, xni@redhat.com, colyli@suse.de, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 09/12] badblocks: fix missing bad blocks on retry in
 _badblocks_check()
Message-ID: <e6iwuml7p5hql4zo4jzkxpr2wgcbqne75xpqva6onteqcxve43@kcr2qzes35ix>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-10-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-10-zhengqixing@huaweicloud.com>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1740133684737100912.19601.5384099801505103637@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=bq22BFai c=1 sm=1 tr=0 ts=67b85534
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
	a=MOos5VJAO8cRspPxsMUA:9 a=QEXdDO2ut3YA:10

On Fri, Feb 21, 2025 at 04:11:06PM +0800, Zheng Qixing wrote:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> The bad blocks check would miss bad blocks when retrying under contention,
> as checking parameters are not reset. These stale values from the previous
> attempt could lead to incorrect scanning in the subsequent retry.
> 
> Move seqlock to outer function and reinitialize checking state for each
> retry. This ensures a clean state for each check attempt, preventing any
> missed bad blocks.
> 
> Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>

Looks good to me.

Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
>  block/badblocks.c | 50 +++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 381f9db423d6..79d91be468c4 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -1191,31 +1191,12 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  			    sector_t *first_bad, int *bad_sectors)
>  {
> -	int unacked_badblocks, acked_badblocks;
>  	int prev = -1, hint = -1, set = 0;
>  	struct badblocks_context bad;
> -	unsigned int seq;
> +	int unacked_badblocks = 0;
> +	int acked_badblocks = 0;
> +	u64 *p = bb->page;
>  	int len, rv;
> -	u64 *p;
> -
> -	WARN_ON(bb->shift < 0 || sectors == 0);
> -
> -	if (bb->shift > 0) {
> -		sector_t target;
> -
> -		/* round the start down, and the end up */
> -		target = s + sectors;
> -		rounddown(s, 1 << bb->shift);
> -		roundup(target, 1 << bb->shift);
> -		sectors = target - s;
> -	}
> -
> -retry:
> -	seq = read_seqbegin(&bb->lock);
> -
> -	p = bb->page;
> -	unacked_badblocks = 0;
> -	acked_badblocks = 0;
>  
>  re_check:
>  	bad.start = s;
> @@ -1281,9 +1262,6 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  	else
>  		rv = 0;
>  
> -	if (read_seqretry(&bb->lock, seq))
> -		goto retry;
> -
>  	return rv;
>  }
>  
> @@ -1324,7 +1302,27 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  int badblocks_check(struct badblocks *bb, sector_t s, int sectors,
>  			sector_t *first_bad, int *bad_sectors)
>  {
> -	return _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
> +	unsigned int seq;
> +	int rv;
> +
> +	WARN_ON(bb->shift < 0 || sectors == 0);
> +
> +	if (bb->shift > 0) {
> +		/* round the start down, and the end up */
> +		sector_t target = s + sectors;
> +
> +		rounddown(s, 1 << bb->shift);
> +		roundup(target, 1 << bb->shift);
> +		sectors = target - s;
> +	}
> +
> +retry:
> +	seq = read_seqbegin(&bb->lock);
> +	rv = _badblocks_check(bb, s, sectors, first_bad, bad_sectors);
> +	if (read_seqretry(&bb->lock, seq))
> +		goto retry;
> +
> +	return rv;
>  }
>  EXPORT_SYMBOL_GPL(badblocks_check);
>  
> -- 
> 2.39.2
> 

-- 
Coly Li
