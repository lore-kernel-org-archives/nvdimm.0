Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AE01B941
	for <nvdimm@lists.linux.dev>; Tue,  6 Feb 2024 21:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707253545; cv=none; b=mOCQlh/UtlCELW1gdXwmRAak65/jJkpdaBnLbq86paCaPY6hPcx1cA065K01zE3o+2qsDtZfOMCfI8dTy4U69ar8ZX21n+VogpxgkY75qB2/4FfEI3EZKnbkOBSN+OXjwjCKc7ezmQXJHJr//E1gFQxQrEpgQA5U3JXsRAU570Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707253545; c=relaxed/simple;
	bh=z7yaU5EAJsRRD3PcSR9Pup3ZIVkJHyXwPXh5lw3SIos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BO375UtAO3SEhCgmTlgXhU68G/4zuluJSaYohArrECzakB5AqUnPf7b4X1YUlLZHt0WlahNCtqLxImwHNnQ9Yy5MtumkZGYn7yk23xU9L5wRNDPhDEK4gWjQ7CZGkDjoqLIbbeuM1zAyJ5nzOO7d4CotU4Oc5FfIw2o5mKpxoyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hoND6uOd; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hoND6uOd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707253543; x=1738789543;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z7yaU5EAJsRRD3PcSR9Pup3ZIVkJHyXwPXh5lw3SIos=;
  b=hoND6uOd4EnvH2mRMDkSQ5vwJ+fh1k5rrtuv28yJcRiSA5JIzWOY4Psh
   bfUAz5sxKfwJU7qPeoGoRAhjNNgkxce942xfBVYueqRXjvch5ijZp4WLT
   nuBfNQzB3IoJPZssCkenal0atePco47kcwuRqayc2/KGMTFkEb+Lq8nsW
   xFMsCd3g2Eg3+XaGYNnKlI3FuWMo0Mk59yqjarxMeqpv26xJmXHzII0gF
   pQEs+awz6ww330LXlc9n98e8ScYHKcOK0Czxbgv8DgCJ4jIPfwIXHiLQ7
   c6cNWBmqxf+FDEhjnC7jCsTNW1Cdxwby24z0xc42ryPu26F2hQH7JKN4o
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11579432"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11579432"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:05:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1359719"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.99]) ([10.246.113.99])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:05:18 -0800
Message-ID: <061991e0-d236-4031-8aaa-1b6946d17545@intel.com>
Date: Tue, 6 Feb 2024 14:05:17 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v5 3/4] ndctl: cxl: add QoS class check for CXL
 region creation
Content-Language: en-US
To: wj28.lee@samsung.com,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 KyungSan Kim <ks0204.kim@samsung.com>, Hojin Nam <hj96.nam@samsung.com>
References: <20240201230646.1328211-4-dave.jiang@intel.com>
 <20240201230646.1328211-1-dave.jiang@intel.com>
 <CGME20240201230708epcas2p4d6ec80b002940637fa0d97e78d43442f@epcms2p4>
 <20240206060027epcms2p4291072d19a247b4b2c3944b5e6e8ed24@epcms2p4>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240206060027epcms2p4291072d19a247b4b2c3944b5e6e8ed24@epcms2p4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/5/24 11:00 PM, Wonjae Lee wrote:
> On Thu, Feb 01, 2024 at 04:05:06PM -0700, Dave Jiang wrote:
>> The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
>> represents the CFMWS. A qos_class attribute is exported via sysfs for the root
>> decoder.
>>
>> One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
>> device for a CXL memory device. The input for the _DSM is the read and write
>> latency and bandwidth for the path between the device and the CPU. The
>> numbers are constructed by the kernel driver for the _DSM input. When a
>> device is probed, QoS class tokens  are retrieved. This is useful for a
>> hot-plugged CXL memory device that does not have regions created.
>>
>> Add a QoS check during region creation. Emit a warning if the qos_class
>> token from the root decoder is different than the mem device qos_class
>> token. User parameter options are provided to fail instead of just
>> warning.
>>
>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  Documentation/cxl/cxl-create-region.txt |  9 ++++
>>  cxl/region.c                            | 56 ++++++++++++++++++++++++-
>>  2 files changed, 64 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
>> index f11a412bddfe..d5e34cf38236 100644
>> --- a/Documentation/cxl/cxl-create-region.txt
>> +++ b/Documentation/cxl/cxl-create-region.txt
>> @@ -105,6 +105,15 @@ include::bus-option.txt[]
>>   supplied, the first cross-host bridge (if available), decoder that
>>   supports the largest interleave will be chosen.
>>
>> +-e::
>> +--strict::
>> + Enforce strict execution where any potential error will force failure.
>> + For example, if qos_class mismatches region creation will fail.
>> +
>> +-q::
>> +--no-enforce-qos::
>> + Parameter to bypass qos_class mismatch failure. Will only emit warning.
>> +
>>  include::human-option.txt[]
>>
>>  include::debug-option.txt[]
>> diff --git a/cxl/region.c b/cxl/region.c
>> index 3a762db4800e..f9033fa0afbf 100644
>> --- a/cxl/region.c
>> +++ b/cxl/region.c
>> @@ -32,6 +32,8 @@ static struct region_params {
>>   bool force;
>>   bool human;
>>   bool debug;
>> + bool strict;
>> + bool no_qos;
>>  } param = {
>>   .ways = INT_MAX,
>>   .granularity = INT_MAX,
>> @@ -49,6 +51,8 @@ struct parsed_params {
>>   const char **argv;
>>   struct cxl_decoder *root_decoder;
>>   enum cxl_decoder_mode mode;
>> + bool strict;
>> + bool no_qos;
>>  };
>>
>>  enum region_actions {
>> @@ -81,7 +85,9 @@ OPT_STRING('U', "uuid", &param.uuid, \
>>      "region uuid", "uuid for the new region (default: autogenerate)"), \
>>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
>>       "non-option arguments are memdevs"), \
>> -OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
>> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
>> +OPT_BOOLEAN('e', "strict", &param.strict, "strict execution enforcement"), \
>> +OPT_BOOLEAN('q', "no-enforce-qos", &param.no_qos, "no enforce of qos_class")
>>
>>  static const struct option create_options[] = {
>>   BASE_OPTIONS(),
>> @@ -360,6 +366,9 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>>       }
>>   }
>>
>> + p->strict = param.strict;
>> + p->no_qos = param.no_qos;
>> +
>>   return 0;
>>
>>  err:
>> @@ -467,6 +476,49 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
>>       p->mode = CXL_DECODER_MODE_PMEM;
>>  }
>>
>> +static int create_region_validate_qos_class(struct cxl_ctx *ctx,
>> +                     struct parsed_params *p)
>> +{
>> + int root_qos_class;
>> + int qos_class;
>> + int i;
>> +
>> + root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
>> + if (root_qos_class == CXL_QOS_CLASS_NONE)
>> +     return 0;
>> +
>> + for (i = 0; i < p->ways; i++) {
>> +     struct json_object *jobj =
>> +         json_object_array_get_idx(p->memdevs, i);
>> +     struct cxl_memdev *memdev = json_object_get_userdata(jobj);
>> +
>> +     if (p->mode == CXL_DECODER_MODE_RAM)
>> +         qos_class = cxl_memdev_get_ram_qos_class(memdev);
>> +     else
>> +         qos_class = cxl_memdev_get_pmem_qos_class(memdev);
>> +
>> +     /* No qos_class entries. Possibly no kernel support */
>> +     if (qos_class == CXL_QOS_CLASS_NONE)
>> +         break;
>> +
>> +     if (qos_class != root_qos_class) {
>> +         if (p->strict && !p->no_qos) {
>> +             log_err(&rl, "%s QoS Class mismatches %s\n",
>> +                 cxl_decoder_get_devname(p->root_decoder),
>> +                 cxl_memdev_get_devname(memdev));
>> +
>> +             return -ENXIO;
>> +         }
>> +
>> +         log_notice(&rl, "%s QoS Class mismatches %s\n",
>> +                cxl_decoder_get_devname(p->root_decoder),
>> +                cxl_memdev_get_devname(memdev));
>> +     }
>> + }
>> +
>> + return 0;
>> +}
>> +
>>  static int create_region_validate_config(struct cxl_ctx *ctx,
>>                    struct parsed_params *p)
>>  {
>> @@ -507,6 +559,8 @@ found:
>>       return rc;
>>
>>   collect_minsize(ctx, p);
>> + create_region_validate_qos_class(ctx, p);
> 
> Hello,
> 
> IIUC, if the strict option is given and a qos class mismatch occurs,
> the region creation should fail. To do that, shouldn't the return
> value of create_region_validate_qos_class() be handled like below?

You are correct. I'll fix.

> 
> diff --git a/cxl/region.c b/cxl/region.c
> index f9033fa..0468f5f 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -559,7 +559,9 @@ found:
>                 return rc;
> 
>         collect_minsize(ctx, p);
> -       create_region_validate_qos_class(ctx, p);
> +       rc = create_region_validate_qos_class(ctx, p);
> +       if (rc)
> +               return rc;
> 
>         return 0;
>  }
> 
> Thanks,
> Wonjae
