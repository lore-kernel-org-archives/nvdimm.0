Received: from mail72.out.titan.email (mail72.out.titan.email [209.209.25.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEF620469D
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740133349; cv=none; b=WxXBhhdGL9CGZZICqT4544qMR9IX4VzT5zNAC9a8EdD6NdJY6Ls53/iaiTi1ySZs7A/+jQQNXYhDqN0xhEsZvW3U5xWcRPfR7RnRLIViCTYhGrzHeOjBqP6P4Q0XGPGKkry/sUv+SUYZMrYUoqWSUbZp1MY0atzy3Ay6Z9Kd4bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740133349; c=relaxed/simple;
	bh=ttghBKtfmBaf6W/eC6gBjd1xmqSctrMbOIo9Izajkz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raHLkvY8y7sD766abyDAHUkna+SB4fJ6M1o4pXYD29jELswCi0YGUfaTxsmhoP9bNeR0V1sCdfotr6ConWnOAk7SAtcewFSLBoLRyVJE3X3R8uB/Yvf4iqeTXWqF2F8Qx7GGlnA4ai3o/250SkNTegkcRgQBnjouwKzuBKq3WzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=T+pOjcbK; arc=none smtp.client-ip=209.209.25.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="T+pOjcbK"
DKIM-Signature: a=rsa-sha256; bh=wANmo5Vtnc/jU4ejAERcYTCS0of3r3IMDpNVJqe6D8w=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:date:from:cc:message-id:references:to:subject:in-reply-to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1740133345; v=1;
	b=T+pOjcbKVifJTuhaF8ueGstAl/qLiBu9Y+6DBYPMa+wr7KUK3M4N7BZmatBz3NL7m9dU6cAS
	pAk3V4mnZxqx3TfwlwI0k2mZdyV/ZmrTrP2GYNMouiiNz49R/ktsbgnR4HJNIJl9X6IJMWtcjmY
	TAKRUyzXrQuNxsqB+ffyXq0E=
Received: from studio.local (tk2-248-33924.vs.sakura.ne.jp [160.16.213.178])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 2B4C5100253;
	Fri, 21 Feb 2025 10:22:18 +0000 (UTC)
Date: Fri, 21 Feb 2025 18:22:01 +0800
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
Subject: Re: [PATCH 06/12] badblocks: fix the using of MAX_BADBLOCKS
Message-ID: <ehghja4fxqxvc2s7popqz363bitvxvbu6sdtovetfvx6neiate@5qe4ivr7zyzs>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-7-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-7-zhengqixing@huaweicloud.com>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1740133345741267071.29396.2836886487781970934@prod-use1-smtp-out1002.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=bq22BFai c=1 sm=1 tr=0 ts=67b853e1
	a=0OgjFgg9iTm4RD4XR/h7Lw==:117 a=0OgjFgg9iTm4RD4XR/h7Lw==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8
	a=ZuRJGKQMYiGAcWkIlfYA:9 a=QEXdDO2ut3YA:10

On Fri, Feb 21, 2025 at 04:11:03PM +0800, Zheng Qixing wrote:
> From: Li Nan <linan122@huawei.com>
> 
> The number of badblocks cannot exceed MAX_BADBLOCKS, but it should be
> allowed to equal MAX_BADBLOCKS.
> 
> Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
> Signed-off-by: Li Nan <linan122@huawei.com>

Looks good to me.

Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
>  block/badblocks.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index a953d2e9417f..87267bae6836 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -700,7 +700,7 @@ static bool can_front_overwrite(struct badblocks *bb, int prev,
>  			*extra = 2;
>  	}
>  
> -	if ((bb->count + (*extra)) >= MAX_BADBLOCKS)
> +	if ((bb->count + (*extra)) > MAX_BADBLOCKS)
>  		return false;
>  
>  	return true;
> @@ -1135,7 +1135,7 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
>  		if ((BB_OFFSET(p[prev]) < bad.start) &&
>  		    (BB_END(p[prev]) > (bad.start + bad.len))) {
>  			/* Splitting */
> -			if ((bb->count + 1) < MAX_BADBLOCKS) {
> +			if ((bb->count + 1) <= MAX_BADBLOCKS) {
>  				len = front_splitting_clear(bb, prev, &bad);
>  				bb->count += 1;
>  				cleared++;
> -- 
> 2.39.2
> 

-- 
Coly Li
