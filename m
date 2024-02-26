Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A72131727
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708984731; cv=none; b=Msi10sWDoOhefDiGJpz3JSniVLsgUefj8cUQCsqaQIcOtszrwe3ZkXVNYqezaP/2WVrOtccd593TV6QUY9haW/BTzfLXkWOdpN+sjh4oig1VK8ROWHnGHWhlrFZtvFmbeTtZtwsOOaRjy5U7xgRT65K990RCgDgvSCQ44YqDNJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708984731; c=relaxed/simple;
	bh=Pex3Wc0DuHp4AwZi+ct2KjNQo8G+7yQCqPffoCp2HyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bPJMIgorj4jC240uCLJCz9Ktf6HR0ZP2MaVtnXuqCYtm53J5foBjvF/7iO2MKf4FxsDJfEnGBYCFCffP7sypkidsgbYgsV/8HALUoqYc4M2y7/kAcJ9pkxjkAyFHVGIMsVAYB7poG2mwqQNki4CoatjTaCHkSJxUNsfABgIu1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a57QiAP8; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a57QiAP8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708984729; x=1740520729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pex3Wc0DuHp4AwZi+ct2KjNQo8G+7yQCqPffoCp2HyI=;
  b=a57QiAP82qSWCCvX9UNwUTb00uvxKEsQRc/jxGrCjKzPQ7OcjRG5aGSv
   DAMvDZgsEuwnoVdaQi596u9TqZ0s35RvyCeWSpFABjI2mvVwccgM98o1I
   XyWpIJk/8Oy9k1hpv0lB+Le2J7rARvSupfAZKGP2ZeGzM1IdJuuK5r9jx
   J8dXUcMgDdH6ywP8P/nbLCsMBd6CGH92wGDzw1YJ8R5dHsqy9i4WFVNU/
   zBGKQQgwOqYYG2huJ0Rz07mc2ibS1rxIgAjZoh0OpNYMZ87vYPGdmc7Z4
   WOw7S6I0MNRufLscwnSeERaZBUHhGa4P4BbBjY17WYfAycC1Bmp6DtCKV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3148808"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3148808"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 13:58:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11484576"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.4]) ([10.246.112.4])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 13:58:47 -0800
Message-ID: <adecc9e8-b0b6-475c-8194-cf9522002df1@intel.com>
Date: Mon, 26 Feb 2024 14:58:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v7 3/4] ndctl: cxl: add QoS class check for CXL
 region creation
Content-Language: en-US
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "Schofield, Alison" <alison.schofield@intel.com>
References: <20240208201435.2081583-1-dave.jiang@intel.com>
 <20240208201435.2081583-4-dave.jiang@intel.com>
 <681afb7ff4a05fa07b0f449b825c8dd04915c6fa.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <681afb7ff4a05fa07b0f449b825c8dd04915c6fa.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/23/24 3:48 PM, Verma, Vishal L wrote:
> On Thu, 2024-02-08 at 13:11 -0700, Dave Jiang wrote:
>> The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
>> represents the CFMWS. A qos_class attribute is exported via sysfs for the root
>> decoder.
>>
>> One or more qos_class tokens are retrieved via QTG ID _DSM from the ACPI0017
>> device for a CXL memory device. The input for the _DSM is the read and write
>> latency and bandwidth for the path between the device and the CPU. The
>> numbers are constructed by the kernel driver for the _DSM input. When a
>> device is probed, QoS class tokens  are retrieved. This is useful for a
>> hot-plugged CXL memory device that does not have regions created.
>>
>> Add a QoS check during region creation. If --enforce-qos/-Q is set and
>> the qos_class mismatches, the region creation will fail.
>>
>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> v7:
>> - Add qos_class_mismatched to region for cxl list (Vishal)
>> - Add create_region -Q check (Vishal)
>> ---
>>  Documentation/cxl/cxl-create-region.txt |  6 +++
>>  cxl/json.c                              |  6 +++
>>  cxl/lib/libcxl.c                        | 11 +++++
>>  cxl/lib/libcxl.sym                      |  2 +
>>  cxl/lib/private.h                       |  1 +
>>  cxl/libcxl.h                            |  2 +
>>  cxl/region.c                            | 56 ++++++++++++++++++++++++-
>>  7 files changed, 83 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
>> index f11a412bddfe..b244af60b8a6 100644
>> --- a/Documentation/cxl/cxl-create-region.txt
>> +++ b/Documentation/cxl/cxl-create-region.txt
>> @@ -105,6 +105,12 @@ include::bus-option.txt[]
>>  	supplied, the first cross-host bridge (if available), decoder that
>>  	supports the largest interleave will be chosen.
>>  
>> +-Q::
>> +--enforce-qos::
>> +	Parameter to enforce qos_class mismatch failure. Region create operation
>> +	will fail of the qos_class of the root decoder and one of the memdev that
>> +	backs the region mismatches.
>> +
>>  include::human-option.txt[]
>>  
>>  include::debug-option.txt[]
>> diff --git a/cxl/json.c b/cxl/json.c
>> index c8bd8c27447a..27cbacc84f3a 100644
>> --- a/cxl/json.c
>> +++ b/cxl/json.c
>> @@ -1238,6 +1238,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
>>  		}
>>  	}
>>  
>> +	if (cxl_region_qos_class_mismatched(region)) {
>> +		jobj = json_object_new_boolean(true);
>> +		if (jobj)
>> +			json_object_object_add(jregion, "qos_class_mismatched", jobj);
>> +	}
>> +
>>  	json_object_set_userdata(jregion, region, NULL);
>>  
>>  
>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>> index 6c293f1dfc91..3461c4de2097 100644
>> --- a/cxl/lib/libcxl.c
>> +++ b/cxl/lib/libcxl.c
>> @@ -414,6 +414,17 @@ CXL_EXPORT int cxl_region_is_enabled(struct cxl_region *region)
>>  	return is_enabled(path);
>>  }
>>  
>> +CXL_EXPORT void cxl_region_qos_class_mismatched_set(struct cxl_region *region,
>> +						  bool mismatched)
>> +{
>> +	region->qos_mismatched = mismatched;
>> +}
> 
> This should be called cxl_region_set_qos_class_mismatched() at a
> minimum, but..
> 
>> +
>> +CXL_EXPORT bool cxl_region_qos_class_mismatched(struct cxl_region *region)
>> +{
>> +	return region->qos_mismatched;
>> +}
> 
> .. I think libcxl always perform its own qos mismatch checking when
> this is called and return appropriately, instead of relying on a user-
> set flag.

Ok. I'll add internal compare for libcxl instead and remove the flag.

> 
> Actually I don't see this interface getting called anywhere. Was there
> a patch to cxl_region_to_json() that got dropped?

It's the first code chunk above.

> 
>> +
>>  CXL_EXPORT int cxl_region_disable(struct cxl_region *region)
>>  {
>>  	const char *devname = cxl_region_get_devname(region);
>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>> index 465c78dc6c70..47a9c3cafc71 100644
>> --- a/cxl/lib/libcxl.sym
>> +++ b/cxl/lib/libcxl.sym
>> @@ -285,4 +285,6 @@ global:
>>  	cxl_root_decoder_get_qos_class;
>>  	cxl_memdev_get_pmem_qos_class;
>>  	cxl_memdev_get_ram_qos_class;
>> +	cxl_region_qos_class_mismatched_set;
>> +	cxl_region_qos_class_mismatched;
>>  } LIBCXL_7;
>> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
>> index 07dc8c784f1d..88448d82d53f 100644
>> --- a/cxl/lib/private.h
>> +++ b/cxl/lib/private.h
>> @@ -174,6 +174,7 @@ struct cxl_region {
>>  	struct daxctl_region *dax_region;
>>  	struct kmod_module *module;
>>  	struct list_head mappings;
>> +	bool qos_mismatched;
>>  };
>>  
>>  struct cxl_memdev_mapping {
>> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
>> index a180f01cb05e..7795496cdbbd 100644
>> --- a/cxl/libcxl.h
>> +++ b/cxl/libcxl.h
>> @@ -335,6 +335,8 @@ int cxl_region_clear_target(struct cxl_region *region, int position);
>>  int cxl_region_clear_all_targets(struct cxl_region *region);
>>  int cxl_region_decode_commit(struct cxl_region *region);
>>  int cxl_region_decode_reset(struct cxl_region *region);
>> +void cxl_region_qos_class_mismatched_set(struct cxl_region *region, bool mismatched);
>> +bool cxl_region_qos_class_mismatched(struct cxl_region *region);
>>  
>>  #define cxl_region_foreach(decoder, region)                                    \
>>  	for (region = cxl_region_get_first(decoder); region != NULL;           \
>> diff --git a/cxl/region.c b/cxl/region.c
>> index 3a762db4800e..76df177ef246 100644
>> --- a/cxl/region.c
>> +++ b/cxl/region.c
>> @@ -32,6 +32,7 @@ static struct region_params {
>>  	bool force;
>>  	bool human;
>>  	bool debug;
>> +	bool qos_enforce;
>>  } param = {
>>  	.ways = INT_MAX,
>>  	.granularity = INT_MAX,
>> @@ -49,6 +50,8 @@ struct parsed_params {
>>  	const char **argv;
>>  	struct cxl_decoder *root_decoder;
>>  	enum cxl_decoder_mode mode;
>> +	bool qos_enforce;
>> +	bool qos_mismatched;
>>  };
>>  
>>  enum region_actions {
>> @@ -81,7 +84,8 @@ OPT_STRING('U', "uuid", &param.uuid, \
>>  	   "region uuid", "uuid for the new region (default: autogenerate)"), \
>>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
>>  	    "non-option arguments are memdevs"), \
>> -OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
>> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
>> +OPT_BOOLEAN('Q', "enforce-qos", &param.qos_enforce, "enforce of qos_class matching")
>>  
>>  static const struct option create_options[] = {
>>  	BASE_OPTIONS(),
>> @@ -360,6 +364,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>>  		}
>>  	}
>>  
>> +	p->qos_enforce = param.qos_enforce;
>> +
>>  	return 0;
>>  
>>  err:
>> @@ -467,6 +473,49 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
>>  		p->mode = CXL_DECODER_MODE_PMEM;
>>  }
>>  
>> +static int create_region_validate_qos_class(struct cxl_ctx *ctx,
> 
> ctx is never used, can be removed.

ok

> 
>> +					    struct parsed_params *p)
>> +{
>> +	int root_qos_class;
>> +	int qos_class;
>> +	int i;
>> +
>> +	if (!p->qos_enforce)
>> +		return 0;
>> +
>> +	root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
>> +	if (root_qos_class == CXL_QOS_CLASS_NONE)
>> +		return 0;
>> +
>> +	for (i = 0; i < p->ways; i++) {
>> +		struct json_object *jobj =
>> +			json_object_array_get_idx(p->memdevs, i);
>> +		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
>> +
>> +		if (p->mode == CXL_DECODER_MODE_RAM)
>> +			qos_class = cxl_memdev_get_ram_qos_class(memdev);
>> +		else
>> +			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
>> +
>> +		/* No qos_class entries. Possibly no kernel support */
>> +		if (qos_class == CXL_QOS_CLASS_NONE)
>> +			break;
>> +
>> +		if (qos_class != root_qos_class) {
>> +			p->qos_mismatched = true;
>> +			if (p->qos_enforce) {
>> +				log_err(&rl, "%s QoS Class mismatches %s\n",
>> +					cxl_decoder_get_devname(p->root_decoder),
>> +					cxl_memdev_get_devname(memdev));
>> +
>> +				return -ENXIO;
>> +			}
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int create_region_validate_config(struct cxl_ctx *ctx,
>>  					 struct parsed_params *p)
>>  {
>> @@ -507,6 +556,10 @@ found:
>>  		return rc;
>>  
>>  	collect_minsize(ctx, p);
>> +	rc = create_region_validate_qos_class(ctx, p);
>> +	if (rc)
>> +		return rc;
>> +
> 
> Maybe this call can be moved into the existing validate_decoder() check
> since?

ok

> 
>>  	return 0;
>>  }
>>  
>> @@ -654,6 +707,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>>  		return -EOPNOTSUPP;
>>  	}
>>  
>> +	cxl_region_qos_class_mismatched_set(region, p->qos_mismatched);
>>  	devname = cxl_region_get_devname(region);
>>  
>>  	rc = cxl_region_determine_granularity(region, p);
> 
> I think as a future enhancement, it might be nice to add
> cxl_filter_walk() smarts to allow it to filter memdevs based on
> qos_class.  That way, when cxl create-region is called without any
> memdev arguments (i.e. it is free to select memdevs), collect_memdevs()
> can ask for memdevs that match the qos_class, and see if those can
> satisfy the interleave requirements if --enforce-qos is used.
