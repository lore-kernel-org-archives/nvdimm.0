Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA8B3AE6F7
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512413; cv=none; b=u3fhs57zfTB2CoI+aVjZJTSGbeKw3WjYTceam+RViz2pUesiWyQ+3nUC1CiWzfkxIk5+teTJ1hJf8R4C2ihR/kOfDfrm9dHHKoOmH74ruUn0eNMuRjKNQiwavrh2PDCgl6KPKLXFMOE6hrxm03Hi1jRMWAzmsj20/WCzJcBfBqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512413; c=relaxed/simple;
	bh=u7xGXzty/YcNZsyc25yOmoAPz3Olza/IMAxnqySiUA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QIlSO2UFtionR36SFKuu9GR3644d9rlUbPevT5gCIclxrF89c0THNkSQpHMJsVz+n0Jl81TBglgs9W497d5QMRB6/CYs6aq9HiYLLt9KFXTmuz1QAbFW+0FKKFJ6Tbys/LknyRNfm9KH2WmQf6BL/TrFQr6C/FivsOnHKDXbcao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7Hg9ESg; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7Hg9ESg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785512411; x=1817048411;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u7xGXzty/YcNZsyc25yOmoAPz3Olza/IMAxnqySiUA4=;
  b=B7Hg9ESgaUtRsjHV1V4+30xQoIqkdKsR/ksomryOXn0FwP8qmwYsB1u4
   1CdNF0Ia+cWhg7SwLmtmbAEaLUk7hKBzNOj9BmACcn2DbazRDkgXyC7kB
   joWRNbOvtBSE1zZr0KNlmGp1QOXNqTGq8Meoe4PKvzhnHzlD6M+6/CG2F
   7u98SCmR9Nv0k1cggv2ArUPD3zebc16r29w9vD6NqCivKxN4YdV7qA7lA
   PeQ9y4ew8WTY2nZUAPPhfU7tA7Yh7hjXTlcEDJwUSTX14z7XzOvm/cxKn
   tMdib6vMdRCN+wwY3Vzxl+84Hh8TtDs/OL21eYDSY+1Lkk6RrhZQ1kopr
   Q==;
X-CSE-ConnectionGUID: uCCOBnCWTn2lOv9eeYn3gg==
X-CSE-MsgGUID: 9KZdYNraQRGM6fJKH6VCxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="103679001"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="103679001"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 08:40:10 -0700
X-CSE-ConnectionGUID: TvXWB5T3QoCI+QeJOC3ztw==
X-CSE-MsgGUID: aGWcIMuSTueiZyejibgrAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="256700297"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.108.75]) ([10.125.108.75])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 08:40:10 -0700
Message-ID: <e08b5930-df89-48e6-8288-f0e3e1bd752a@intel.com>
Date: Fri, 31 Jul 2026 08:40:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/2] cxl/list: emit decoder locked status
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 Richard Cheng <icheng@nvidia.com>
Cc: linux-cxl@vger.kernel.org
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/26 6:55 PM, Alison Schofield wrote:
> A committed zero-sized HDM decoder reports size 0, so 'cxl list'
> renders it identically to an ordinary unconfigured decoder ("state":
> "disabled"). The locked attribute that distinguishes firmware-committed
> decoders is not included in the JSON output.
> 
> The library already reads the decoder's locked attribute and exports
> cxl_decoder_is_locked(); it was simply never emitted. Add a "locked"
> field to the decoder JSON, following the emit-only-when-true idiom used
> by the capability flags so existing output is unchanged for the common
> unlocked case.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/json.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index a92548828582..2214f7027d91 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -870,6 +870,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  			json_object_object_add(jdecoder, "state", jobj);
>  	}
>  
> +	if (cxl_decoder_is_locked(decoder)) {
> +		jobj = json_object_new_boolean(true);
> +		if (jobj)
> +			json_object_object_add(jdecoder, "locked", jobj);
> +	}
> +
>  	if (cxl_port_is_endpoint(port)) {
>  		enum cxl_decoder_mode mode = cxl_decoder_get_mode(decoder);
>  

