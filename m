Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02387E
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 00:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661299443; x=1692835443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FRXqxmC17NmeTrQ+Who5RZtvf5ZbXvugrZGhm695dO0=;
  b=VFqOWzWjJwltXma6XjEXl9vhbBvTgxbvfeW9BXYqgPDRdIlzu2EpLUEQ
   9hoxy+1VzD+UCMV4YE17i4nJP4SCej0VV8eCc7OwtIFdEAudh3t8rALu4
   QN0pUyfvBV/UimRsuhNdH2BPOVHDC7QC1TLBaS6zpdZxgSsmyYVA+gJJt
   Rc+KASrN9bl1RJk0iwohqeic7gaY/uOoj3jEIA4J4q1NqZVxJ6H95/eTl
   eDk/k3Mz3FvjOahrbWXvmj/LtIX0VgBK4iQ6ARE6skEv9WJTnKgz75nMf
   uvjJqF+lehqsyGiIEUeyUdxe2eDIUbswGB81R8+euIcR956AiCMdqSJG0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="295108200"
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="295108200"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:04:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,259,1654585200"; 
   d="scan'208";a="612593069"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.86.80]) ([10.212.86.80])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:04:02 -0700
Message-ID: <3ce09f4d-7e77-24e4-cb66-26ce1d5a4518@intel.com>
Date: Tue, 23 Aug 2022 17:04:02 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [ndctl PATCH v2 2/3] libcxl: fox a resource leak and a forward
 NULL check
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
 <20220823074527.404435-3-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220823074527.404435-3-vishal.l.verma@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/23/2022 12:45 AM, Vishal Verma wrote:
> Static analysis reports a couple of issues in add_cxl_region(). Firstly,
> 'path' wasn't freed in the success case, only in the error case.
> Secondly, the error handling after 'calloc()'ing the region object
> erroneously jumped to the error path which tried to free the region object.
>
> Add anew error label to just free 'path' and return for this exit case.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   cxl/lib/libcxl.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 021d59f..e8c5d44 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -482,7 +482,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>   
>   	region = calloc(1, sizeof(*region));
>   	if (!region)
> -		goto err;
> +		goto err_path;
>   
>   	region->id = id;
>   	region->ctx = ctx;
> @@ -551,11 +551,13 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
>   
>   	list_add_sorted(&decoder->regions, region, list, region_start_cmp);
>   
> +	free(path);
>   	return region;
>   err:
>   	free(region->dev_path);
>   	free(region->dev_buf);
>   	free(region);
> +err_path:
>   	free(path);
>   	return NULL;
>   }
