Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018945CAD
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 13:03:48 +0000 (UTC)
Received: from frapeml500004.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NC35k6Wwcz67mLH;
	Wed, 16 Nov 2022 20:59:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml500004.china.huawei.com (7.182.85.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 14:03:46 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 16 Nov
 2022 13:03:45 +0000
Date: Wed, 16 Nov 2022 13:03:45 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <alison.schofield@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 4/5] cxl/list: add --media-errors option to cxl
 list
Message-ID: <20221116130345.000007a8@Huawei.com>
In-Reply-To: <762edeab529125d3048cf13721360b1a07260531.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
	<762edeab529125d3048cf13721360b1a07260531.1668133294.git.alison.schofield@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 10 Nov 2022 19:20:07 -0800
alison.schofield@intel.com wrote:

> From: Alison Schofield <alison.schofield@intel.com>
> 
> The --media-errors option to 'cxl list' retrieves poison lists
> from memory devices (supporting the capability) and displays
> the returned media-error records in the cxl list json. This
> option can apply to memdevs or regions.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt | 64 ++++++++++++++++++++++++++++++++++
>  cxl/filter.c                   |  2 ++
>  cxl/filter.h                   |  1 +
>  cxl/list.c                     |  2 ++
>  4 files changed, 69 insertions(+)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 14a2b4bb5c2a..24a0cf97cef2 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -344,6 +344,70 @@ OPTIONS
>  --region::
>  	Specify CXL region device name(s), or device id(s), to filter the listing.
>  
> +-a::
> +--media-errors::
> +	Include media-error information. The poison list is retrieved
> +	from the device(s) and media error records are added to the
> +	listing. This option applies to memdevs and regions where
> +	devices support the poison list capability.

I'm not sure media errors is a good name.  The poison doesn't have to originate
in the device.  Given we are logging poison with "external" as the source
those definitely don't come from the device and may have nothing to do
with 'media' as such.

Why not just call it poison?

> +
> +----
> +# cxl list -m mem11 --media-errors
> +[
> +  {
> +    "memdev":"mem11",
> +    "pmem_size":268435456,
> +    "ram_size":0,
> +    "serial":0,
> +    "host":"0000:37:00.0",
> +    "media_errors":{
> +      "nr_media_errors":1,
> +      "media_error_records":[
> +        {
> +          "dpa":0,
> +          "length":64,
> +          "source":"Internal",
> +          "flags":"",
> +          "overflow_time":0
> +        }
> +      ]
> +    }
> +  }
> +]
> +# cxl list -r region5 --media-errors
> +[
> +  {
> +    "region":"region5",
> +    "resource":1035623989248,
> +    "size":2147483648,
> +    "interleave_ways":2,
> +    "interleave_granularity":4096,
> +    "decode_state":"commit",
> +    "media_errors":{
> +      "nr_media_errors":2,
> +      "media_error_records":[
> +        {
> +          "memdev":"mem2",
> +          "dpa":0,
> +          "length":64,
> +          "source":"Internal",
> +          "flags":"",
> +          "overflow_time":0
> +        },
> +        {
> +          "memdev":"mem5",
> +          "dpa":0,
> +          "length":512,
> +          "source":"Vendor",
> +          "flags":"",
> +          "overflow_time":0
> +        }
> +      ]
> +    }
> +  }
> +]
> +----
> +
>  -v::
>  --verbose::
>  	Increase verbosity of the output. This can be specified
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 56c659965891..fe6c29148fb4 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -686,6 +686,8 @@ static unsigned long params_to_flags(struct cxl_filter_params *param)
>  		flags |= UTIL_JSON_TARGETS;
>  	if (param->partition)
>  		flags |= UTIL_JSON_PARTITION;
> +	if (param->media_errors)
> +		flags |= UTIL_JSON_MEDIA_ERRORS;
>  	return flags;
>  }
>  
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 256df49c3d0c..a92295fe2511 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -26,6 +26,7 @@ struct cxl_filter_params {
>  	bool human;
>  	bool health;
>  	bool partition;
> +	bool media_errors;
>  	int verbose;
>  	struct log_ctx ctx;
>  };
> diff --git a/cxl/list.c b/cxl/list.c
> index 8c48fbbaaec3..df2ae5a3fec0 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -52,6 +52,8 @@ static const struct option options[] = {
>  		    "include memory device health information"),
>  	OPT_BOOLEAN('I', "partition", &param.partition,
>  		    "include memory device partition information"),
> +	OPT_BOOLEAN('a', "media-errors", &param.media_errors,
> +		    "include media error information "),
>  	OPT_INCR('v', "verbose", &param.verbose,
>  		 "increase output detail"),
>  #ifdef ENABLE_DEBUG

