Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793977887;
	b=WXExYZzT5YBHeBT1/c5fv0g9qz5Bq5VLRUZaaOBtpcIIVBGZFhqJOynHlM7lZbxXe4on
	 GdLS7oBxZa0S+kzCCP4NM3mxwa/m1ZuH1TuT6twGuULMa0HB5xToYz275+YNqYF1RiE8z
	 XwP9s81hUV1mOS1EHCgOFGJfh6H99RtIyzBQ5VQ+lpbLlaiD2fwLBR0t4etMiBNO4A/xL
	 9s6Sbmf8DjeobFRnl9M7C7WaiG3pWRz+1WlhzR4cOD3nECwnp8o1yOm32ZyJZcOfQpNHd
	 QT70lNayr6iu1boaJvOTCkUQIwWyV29gq//1fE/XW35f1wTP5c5+/xsXbVG8+3Xfzgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793977887;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=U4xVGXprMnW3i54v90xsuLeyobFPxkIe1HM3oG8qUlk=;
	b=Wh1CFFOMge3skRyaixsKwDfxlqXpOynmJIrJR6Kqy0tuh2AFy6Ipl3EfHDfygoSZNVrE
	 ZEikNB8CUfWKqidI3ZACvYPrJqs6EYKzz2A8mcfPG9HsqsbRpKXPdOaS5G9VNs9abTDxv
	 34ZTSOmvLdaKP4K64LClm0HygooHy/qCpq2zp8kTLrHEzeVGUxfmk+nYhIehMyHxxMYoa
	 E80jDullmTtopWTG21rfe8ftZxXquc/H+kzETWm175SllmYKEicdptRBnotMAq2RE5f3/
	 0ubVhpKQoAiBJ5iisPBHewSzvzrK1Fyes0XkWdpNOJdq7nE+R1ydX2/F7rObO2YOz0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QOqgxW8k;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAB5606A326
	for <nvdimm@lists.linux.dev>; Fri,  6 Nov 2026 15:11:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAAB5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QOqgxW8k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793977886; x=1825513886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GfIPoaJToF9X3UO5y6vtPnqKJkU7LOYSMYmRt3Jt9sM=;
  b=QOqgxW8kRrszMSey3lIo25aBnHnHlXLz62ZRSx+4kjgezcezCbJw2Jfe
   HH5LmlMAi0w2z4W9kBwF0VsOagSuZnulKuM5ua4fWE/TPQmYaodpqm8o8
   /C4NWHYyWCCDLlVkPLEJF8rOAy3xZWffqJs/FNoRvtYn5ChaqZywQrW2m
   +JSJkQJ8aF10Vtx80uVmpdw2vDqMN6oPVhGGhHx3J1w7/JVQx2PGsd0+p
   zoRZsV44InFgRRv8OLUEQRZPxB6BNfuvi+/gM7ckuRlGf/xY4aA/uoeB2
   biZ7g+k8oHuMULXYLJh79TTyx4ysiZXFL14o7pahb6RaMNbSF7Bk/7OvZ
   g==;
X-CSE-ConnectionGUID: qoTkoMrTQfa0V8aVbFf/Tg==
X-CSE-MsgGUID: NFTVRtvtSG2XQtOgJw3adw==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2670465"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2670465"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 07:11:25 -0800
X-CSE-ConnectionGUID: qpkF86v7RxqP+KZ3/oFl6Q==
X-CSE-MsgGUID: K0RveVkFR3eCjsXen2suZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7135259"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.110.174]) ([10.125.110.174])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 07:11:25 -0800
Message-ID: <97dd4948-efb2-43e2-bd9b-d6b61cff8787@intel.com>
Date: Fri, 6 Nov 2026 08:11:24 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/cxl-destroy-region.sh: create RAM regions
 explicitly
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
References: <20261106014848.938714-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261106014848.938714-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/5/26 6:48 PM, Alison Schofield wrote:
> The test creates regions it expects to be RAM without passing a type.
> create-region defaults to pmem when the root decoder supports both RAM
> and PMEM, so the test fails when it picks such a decoder.
> 
> cxl_test has one such decoder. Whether the test picks it depends on the
> memdev order, which changes when other CXL devices, such as QEMU-emulated
> ones, are present.
> 
> Use the '-t ram' option so both checks create RAM regions regardless of
> which decoder is selected.
> 
> This issue appeared while the CXL kernel patch[1] was being tested. It
> changes the cxl_test created x1 volatile window to one that support both
> RAM and PMEM.
> 
> [1] https://lore.kernel.org/linux-cxl/89e8d2cfde4f1054f37a4f48f2b206a7f05108f7.1793850480.git.alison.schofield@intel.com/
> 
> 
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/cxl-destroy-region.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
> index 5c3395e530b0..b07589fbbe39 100644
> --- a/test/cxl-destroy-region.sh
> +++ b/test/cxl-destroy-region.sh
> @@ -60,7 +60,7 @@ check_destroy_ram()
>  	mem=$1
>  	decoder=$2
>  
> -	region="$("$CXL" create-region -d "$decoder" -m "$mem" | jq -r ".region")"
> +	region="$("$CXL" create-region -t ram -d "$decoder" -m "$mem" | jq -r ".region")"
>  	if [[ ! $region ]]; then
>  		err "$LINENO"
>  	fi
> @@ -76,7 +76,7 @@ check_destroy_devdax()
>  	mem=$1
>  	decoder=$2
>  
> -	region="$("$CXL" create-region -d "$decoder" -m "$mem" | jq -r ".region")"
> +	region="$("$CXL" create-region -t ram -d "$decoder" -m "$mem" | jq -r ".region")"
>  	if [[ ! $region ]]; then
>  		err "$LINENO"
>  	fi

