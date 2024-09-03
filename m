Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864F918786D
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 15:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725378471; cv=none; b=t8C+KT/pMMBeu5gLNMWBbutl+1m0RmXs9GYHyTU7zhGKllQzRkPH+mU3MQhK9gQ91zr9WcL+KeSZtaGz/eGoCjjWpdlUm9isQu++2uLr/oQjY+N65GIlJSZM3JqzBbMshpp23g/wPCtMUN0Y/hztZhJQGtB3yxZJWK2IkeMOqyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725378471; c=relaxed/simple;
	bh=5b5+4ZvlfS76WJAfoz8GXYo80fEeKIddB8cgkbxXhRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRNPXzqqpvY7JcNL3APdsSjz6ZB4yB0yi53Xhr0g+arg6sNu2wXzJV2VSTLodiyxMO/uZQd+x23oDl67QVZpCRxwR4lbWhqQ3XeQxSPM/APpwf0RTYtKErRjR1NFzlEC8VDxV1YBp00D0KBp/vqtxAtR9bWIqUl+As/0LwQvlt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MoWhxYIY; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MoWhxYIY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725378470; x=1756914470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5b5+4ZvlfS76WJAfoz8GXYo80fEeKIddB8cgkbxXhRI=;
  b=MoWhxYIYRxSxpzIgfb1qmPYzHVHj+mrrnnXO3Px9MD+TAfiWlyf5YXxT
   QRqXQY+se5rMG8bEBCzDcg5No4F7l1Qnhs59HFuv/lpLEebituCGOuSTp
   KEoRelL33LpBkU1jC3TQgTGx7oSv5inSb63/KRR/mKiZqZkhU1upAome6
   ehLDjRUyoXtV91XOYuzEdhGkjbFfcd0SDX1oX8Vv4pGArL9XFrvNZXIda
   bfJO5z6/CJLIjAL5rNnQDZgAcsyvYPYNeaijJTR0gZsKrx8nnEYMXCjQ5
   KD+ExsX6rWoCRhlF4km2r1e5X8edPjt4uIH12B8PdsXp2TFjbQSmvj0QA
   A==;
X-CSE-ConnectionGUID: tAwBGvYYRkykuQ3u+7g9Jw==
X-CSE-MsgGUID: XdKHRFpWSBqhNcGte3veAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="34596966"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="34596966"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 08:47:50 -0700
X-CSE-ConnectionGUID: gRXETiJIQXWhA9yahEnL3Q==
X-CSE-MsgGUID: Iiz9KAvWR4yM3vzYZq7b9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="69102987"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO [10.125.109.10]) ([10.125.109.10])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 08:47:49 -0700
Message-ID: <588f9c7c-3c67-474f-a364-927d57bec130@intel.com>
Date: Tue, 3 Sep 2024 08:47:48 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btt: fix block integrity
To: Keith Busch <kbusch@meta.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, nvdimm@lists.linux.dev
Cc: Keith Busch <kbusch@kernel.org>
References: <20240830204255.4130362-1-kbusch@meta.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240830204255.4130362-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/30/24 1:42 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> bip is NULL before bio_integrity_prep().
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/btt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 423dcd1909061..13594fb712186 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1435,8 +1435,8 @@ static int btt_do_bvec(struct btt *btt, struct bio_integrity_payload *bip,
>  
>  static void btt_submit_bio(struct bio *bio)
>  {
> -	struct bio_integrity_payload *bip = bio_integrity(bio);
>  	struct btt *btt = bio->bi_bdev->bd_disk->private_data;
> +	struct bio_integrity_payload *bip;
>  	struct bvec_iter iter;
>  	unsigned long start;
>  	struct bio_vec bvec;
> @@ -1445,6 +1445,7 @@ static void btt_submit_bio(struct bio *bio)
>  
>  	if (!bio_integrity_prep(bio))
>  		return;
> +	bip = bio_integrity(bio);
>  
>  	do_acct = blk_queue_io_stat(bio->bi_bdev->bd_disk->queue);
>  	if (do_acct)
