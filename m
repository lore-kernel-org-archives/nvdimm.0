Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06777F
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 00:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661299409; x=1692835409;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=USYtyS9txue+9Z8Mvp2ve/yVO/VLpsG+Ts8bt/IDfBw=;
  b=jZCXaVvykzaxhSCTkkz4hZU27ceUkZkJtL12ov5/jr4nVJaJ4g2mz7kT
   l69CK4iHmx4n4aSBYgxNiBTqFzqc3f8YiZyadFXYnvzSrO/qDJ0wXxzzI
   hUbnHKYjp7+TAo1+yNcxmqXTHRVULljp1tMh6Xqwdw3TVHNs1sN46aOlD
   SNltbpzY08yKaSaA0ilnZ/iRGQPCwcbIfWBCOUOdi/or75wOgHiUR16JW
   KF60v9uc5ThtqEYXHm79CR9f2MRgZ2S+zZOtdb/sQxnqO+enEBZRVggF8
   Rj5R461tb9M3TLMTV/vgHRw5JH1CrLiDl5kG3A15TWyQo/xVKulNOGHWW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="357799760"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="357799760"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:03:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="612592886"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.86.80]) ([10.212.86.80])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:03:28 -0700
Message-ID: <effb66ee-ef89-07f7-af6d-f2d32931ac91@intel.com>
Date: Tue, 23 Aug 2022 17:03:28 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [ndctl PATCH v2 1/3] cxl/region: fix a dereferecnce after NULL
 check
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
 <20220823074527.404435-2-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220823074527.404435-2-vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/23/2022 12:45 AM, Vishal Verma wrote:
> A NULL check in region_action() implies that 'decoder' might be NULL, but
> later we dereference it during cxl_decoder_foreach(). The NULL check is
> valid because it was the filter result being checked, however, while
> doing this, the original 'decoder' variable was being clobbered.
>
> Check the filter results independently of the original decoder variable.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   cxl/region.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/cxl/region.c b/cxl/region.c
> index a30313c..334fcc2 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -686,9 +686,8 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
>   			continue;
>   
>   		cxl_decoder_foreach (port, decoder) {
> -			decoder = util_cxl_decoder_filter(decoder,
> -							  param.root_decoder);
> -			if (!decoder)
> +			if (!util_cxl_decoder_filter(decoder,
> +						     param.root_decoder))
>   				continue;
>   			rc = decoder_region_action(p, decoder, action, count);
>   			if (rc)
