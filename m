Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20236525B
	for <nvdimm@lists.linux.dev>; Fri, 28 Apr 2023 16:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682697802; x=1714233802;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5vD0AqLC+TpTZhHugvzywpXUvdh22xCumWOUQdkJ8EY=;
  b=SF0SG+FzFrawdNXn9jA6gyOcX+tv+sG7e1XSD1mWDymkiW1R3InMXHzl
   CVH8HWxWvqweDb3wPZ8XIpNxBcJ/WcnSTVhaFfd0YO7mmx7reG6k/NG+6
   YBzJ4ESl99R338LNBeChIBKsYsslKuBjg8Kd1r6ooV2CuPApDKcnWV0qO
   m4whhRUxXWbv80nSViot4MOccMrILWjDQTbhH5SMIhK5qvZOfP+aijc9S
   h/RwJUJHKIERtzSDlA/ZiNUFsNmRV4YOuYIsOsw3TPhkFlPMWJRG1Flyu
   hWv4tDhCopNs9BbMVsJE2kQrjXYjSU0gxO0klvj77Ik+PgbJHOlbqxmxw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="350696115"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="350696115"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:03:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="672236020"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="672236020"
Received: from egliskay-mobl.amr.corp.intel.com (HELO [10.212.108.170]) ([10.212.108.170])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 09:03:21 -0700
Message-ID: <2c24fc6b-383f-73aa-6ae5-4faade5d1269@intel.com>
Date: Fri, 28 Apr 2023 09:03:20 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 2/4] cxl/list: Filter root decoders by region
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
 <168236638318.1027628.17234728660914767074.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168236638318.1027628.17234728660914767074.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/23 12:59 PM, Dan Williams wrote:
> Arrange for util_cxl_decoder_filter_by_region() to consider that root
> decoders host multiple regions, unlike switch and endpoint decoders that
> have a 1:1 relationship.
> 
> Before: (list the root decoders hosting region4 and region9)
>      # cxl list -Du -d root -r 4,9
>        Warning: no matching devices found
> 
>      [
>      ]
> 
> After:
>      # cxl list -Du -d root -r 4,9
>      [
>        {
>          "decoder":"decoder3.0",
>          "resource":"0xf010000000",
>          "size":"1024.00 MiB (1073.74 MB)",
>          "interleave_ways":1,
>          "max_available_extent":"512.00 MiB (536.87 MB)",
>          "volatile_capable":true,
>          "nr_targets":1
>        },
>        {
>          "decoder":"decoder3.5",
>          "resource":"0xf1d0000000",
>          "size":"256.00 MiB (268.44 MB)",
>          "interleave_ways":1,
>          "accelmem_capable":true,
>          "nr_targets":1
>        }
>      ]
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/filter.c |    6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 90b13be79d9c..6e8d42165205 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -661,6 +661,12 @@ util_cxl_decoder_filter_by_region(struct cxl_decoder *decoder,
>   	if (!__ident)
>   		return decoder;
>   
> +	/* root decoders filter by children */
> +	cxl_region_foreach(decoder, region)
> +		if (util_cxl_region_filter(region, __ident))
> +			return decoder;
> +
> +	/* switch and endpoint decoders have a 1:1 association with a region */
>   	region = cxl_decoder_get_region(decoder);
>   	if (!region)
>   		return NULL;
> 
> 
