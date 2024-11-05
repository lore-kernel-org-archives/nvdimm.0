Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A111E13AD39
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821545; cv=none; b=QGq9zweq6z1gx67lYRt3EfbKQON0QhULFfD3aXEkTChWullACtld9UbM8wjYt9gTpHrtVOMzUqS5uZPt+kwZ27Fh+4s49qDAb1RWuTkw8Mxfe10aJd4hH6gnWFj9YlVRzPo2ciWDg9mGAzRu/bDREHj0WiI4jwp3NYPiaRyuX/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821545; c=relaxed/simple;
	bh=8Ka6tBAdUFNelH6Are1e0Y+WlpH7yLwqjstb2Zyebvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vGefbblegBusrR6ZiT40M/nF68cuhOlWynqKIFLWgtNC5Urhg+QSzB+1AaDZ7lg9zimIDAnX74VLtf3q8CVaFY8IQ0QJNNt5ygtBExWarA2ndUkGnYRD31fyvf3Hb1bJ2b6IXyQXcB/04CxYHYhw2hSaMq5gEk5A3XBf2F4dk+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XnkgztgH; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XnkgztgH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730821543; x=1762357543;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8Ka6tBAdUFNelH6Are1e0Y+WlpH7yLwqjstb2Zyebvs=;
  b=XnkgztgHH7gRjtDQWH3Yj6731nF0HOA8zeXb9tLKbPq/gfNLdY3jLdeS
   Oeq9wxFmdNNIFxXUNtjDAXYOb96iQNMfObS09R1/BsokGBYp9wbCMnJPJ
   dXXtGD+MQPYkfLyhUZGYc7WCqzkv//twisEtm7/x9dJ2NkDWs3kMvFGtL
   gE7kywQZM0v0HAcH1rYm7o3UP7JvDOko7f4a34wKHUREJ/BgAXy2UGwxw
   Y0aZmTFjXUmiyDc6CbahckVJqezKm4oAttkKze4Vf7r08+f5inD8XJ0c3
   a6EqPnHMDAOTUZcdvlxiG3UtHJt+j47AZ6IEYuiWQdHtoA30SCf8vowt/
   Q==;
X-CSE-ConnectionGUID: VoITLs6LTcGg0C7xOidK2A==
X-CSE-MsgGUID: tUvxZ7t7RxG2cs2SQBXyPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48038100"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48038100"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 07:45:43 -0800
X-CSE-ConnectionGUID: eYuUo53hR8OQMW+CTE26pA==
X-CSE-MsgGUID: iuyQrAz9QJ+VM3uEV5Qa9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84459844"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.109.253]) ([10.125.109.253])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 07:45:42 -0800
Message-ID: <432ff3ea-e851-4665-bbe0-c0e0b78a1fd4@intel.com>
Date: Tue, 5 Nov 2024 08:45:42 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 2/6] ndctl/cxl/region: Report max size for region
 creation
To: Ira Weiny <ira.weiny@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>,
 Navneet Singh <navneet.singh@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/24 7:10 PM, Ira Weiny wrote:
> When creating a region if the size exceeds the max an error is printed.
> However, the max available space is not reported which makes it harder
> to determine what is wrong.
> 
> Add the max size available to the output error.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/region.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 96aa5931d2281c7577679b7f6165218964fa0425..207cf2d003148992255c715f286bc0f38de2ca84 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -677,8 +677,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  	}
>  	if (!default_size && size > max_extent) {
>  		log_err(&rl,
> -			"%s: region size %#lx exceeds max available space\n",
> -			cxl_decoder_get_devname(p->root_decoder), size);
> +			"%s: region size %#lx exceeds max available space (%#lx)\n",
> +			cxl_decoder_get_devname(p->root_decoder), size, max_extent);
>  		return -ENOSPC;
>  	}
>  
> 

