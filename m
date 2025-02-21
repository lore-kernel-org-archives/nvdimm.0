Received: from mail94.out.titan.email (mail94.out.titan.email [54.235.81.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE9820469D
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 10:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.235.81.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740132658; cv=none; b=MLreRMrpfPaSdSegVhiw6uwOFxMOXGSj1AzvW7NjJdPttzaPA+bV9GehC86VPLKLqcJmwr4/woMFfQ+Qe44tNdr8MFo7URPO1SEEs6Hm7VhR7ZE541Sn7DfrmnyZ2Fesr8ELMvGMUrbG13+zVNahGRCwvyarPexsFGnVzqgLOhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740132658; c=relaxed/simple;
	bh=CJTatHUiCB2mk5gZnHEF1n8uf5CwCMiUtV7AVquwh3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJ9CCGmavOI3m6Hq6GBAsRaNed1xVWLCUNe9169EnBim0EDqQNcJEDRNOzrKkfmmuqUAQmHi8ONa3Wq3n8oVLfgFi7Ddnz96wuJpZ1qqske1PdvsP8l9HGBhUjiHoHQ2pj9UKhM0a4KDWRhsf0nv2zhSY784aLFza86s2JugLAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=jgQQxOtC; arc=none smtp.client-ip=54.235.81.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="jgQQxOtC"
DKIM-Signature: a=rsa-sha256; bh=E8xDhYB5dTniEqejMlnuKVP8JOLWSCvk34/8j7lmisk=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=date:from:message-id:mime-version:to:subject:cc:references:in-reply-to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1740132293; v=1;
	b=jgQQxOtCY/0wbEmtd452iAI/1AkGJ2n42KQSSoyC/8ArS25nfVgud6/J1r2sVMXlJchTb7td
	596KAbkAgVAQ+J+PpMNJPnhGNDeVjqZjMnj28Y76VZKgNpFv1UhS6/TFwDqN+C0qUJmbcrsB294
	MH5MvSypHdv3YRjXqZ0UdEtw=
Received: from studio.local (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 7F3FC100280;
	Fri, 21 Feb 2025 10:04:45 +0000 (UTC)
Date: Fri, 21 Feb 2025 18:04:43 +0800
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
Subject: Re: [PATCH 02/12] badblocks: factor out a helper try_adjacent_combine
Message-ID: <i5vkxswklce2wtn3aolrd6qrtlib3obtlzgmdix22afcurp7lz@jkxbieqcitx4>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-3-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221081109.734170-3-zhengqixing@huaweicloud.com>
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1740132293142604270.29396.4416553515934908601@prod-use1-smtp-out1002.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=bq22BFai c=1 sm=1 tr=0 ts=67b84fc5
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=i0EeH86SAAAA:8
	a=xfoHWtfPNc-Uf5GpDPwA:9 a=QEXdDO2ut3YA:10 a=HMmSsUQzf63YMr8qf_ya:22

On Fri, Feb 21, 2025 at 04:10:59PM +0800, Zheng Qixing wrote:
> From: Li Nan <linan122@huawei.com>
> 
> Factor out try_adjacent_combine(), and it will be used in the later patch.
>

Which patch is try_adjacent_combine() used in? I don't see that at a quick glance.

Thanks.

Coly Li

 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  block/badblocks.c | 40 ++++++++++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/block/badblocks.c b/block/badblocks.c
> index bcee057efc47..f069c93e986d 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -855,6 +855,31 @@ static void badblocks_update_acked(struct badblocks *bb)
>  		bb->unacked_exist = 0;
>  }
>  
> +/*
> + * Return 'true' if the range indicated by 'bad' is exactly backward
> + * overlapped with the bad range (from bad table) indexed by 'behind'.
> + */
> +static bool try_adjacent_combine(struct badblocks *bb, int prev)
> +{
> +	u64 *p = bb->page;
> +
> +	if (prev >= 0 && (prev + 1) < bb->count &&
> +	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
> +	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
> +	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
> +		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> +				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
> +				  BB_ACK(p[prev]));
> +
> +		if ((prev + 2) < bb->count)
> +			memmove(p + prev + 1, p + prev + 2,
> +				(bb->count -  (prev + 2)) * 8);
> +		bb->count--;
> +		return true;
> +	}
> +	return false;
> +}
> +
>  /* Do exact work to set bad block range into the bad block table */
>  static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  			  int acknowledged)
> @@ -1022,20 +1047,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
>  	 * merged. (prev < 0) condition is not handled here,
>  	 * because it's already complicated enough.
>  	 */
> -	if (prev >= 0 &&
> -	    (prev + 1) < bb->count &&
> -	    BB_END(p[prev]) == BB_OFFSET(p[prev + 1]) &&
> -	    (BB_LEN(p[prev]) + BB_LEN(p[prev + 1])) <= BB_MAX_LEN &&
> -	    BB_ACK(p[prev]) == BB_ACK(p[prev + 1])) {
> -		p[prev] = BB_MAKE(BB_OFFSET(p[prev]),
> -				  BB_LEN(p[prev]) + BB_LEN(p[prev + 1]),
> -				  BB_ACK(p[prev]));
> -
> -		if ((prev + 2) < bb->count)
> -			memmove(p + prev + 1, p + prev + 2,
> -				(bb->count -  (prev + 2)) * 8);
> -		bb->count--;
> -	}
> +	try_adjacent_combine(bb, prev);
>  
>  	if (space_desired && !badblocks_full(bb)) {
>  		s = orig_start;
> -- 
> 2.39.2
> 

-- 
Coly Li
