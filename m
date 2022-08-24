Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF2E7E
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 00:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661299467; x=1692835467;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mxd+7YmgTj1JAjvIY/neHCAi/vcL4X0sAIVDfYHJegw=;
  b=gnLOG+MVr90H1vUMgrmjKbSk4VdFzCaCKphSrVubvVrmgIG0tMaoCICM
   vE3ME9iaBhxXTdTi7/8Oh99z9vbMYGtpmjL3GTaBxmbfGQ9cLxtKPrWf9
   AcFPoBoqEIa+uhF2OBDSq6t5skOgdqS6qlFZ/E8pv1R9AZj8goT7vl56l
   ldwnu4ukovrabA1V0Q21C13jwWi1om1JaGOsJUqge0kW6or6GfrAXP6WA
   0We47Jt5Sz858TIkdMzU9QHXeq3LCiAF9/4KZ7aK3CVe0k5C9MBoiajWO
   KSrPq0dVa9Msuu6r2RUCUsG3iugJREuf8KAN2xnZ9AFvr1CbzfaE8l7yK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="293825979"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="293825979"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:04:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="612593142"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.86.80]) ([10.212.86.80])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:04:16 -0700
Message-ID: <fab208dd-e6c5-417a-53e8-5eb2d91bd587@intel.com>
Date: Tue, 23 Aug 2022 17:04:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [ndctl PATCH v2 3/3] cxl/filter: Fix an uninitialized pointer
 dereference
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
 <20220823074527.404435-4-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220823074527.404435-4-vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/23/2022 12:45 AM, Vishal Verma wrote:
> Static analysis points out that there was a chance that 'jdecoder' could
> be used while uninitialized in walk_decoders(). Initialize it to NULL to
> avoid this.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   cxl/filter.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 9a3de8c..56c6599 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -796,7 +796,7 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
>   	cxl_decoder_foreach(port, decoder) {
>   		const char *devname = cxl_decoder_get_devname(decoder);
>   		struct json_object *jchildregions = NULL;
> -		struct json_object *jdecoder;
> +		struct json_object *jdecoder = NULL;
>   
>   		if (!p->decoders)
>   			goto walk_children;
