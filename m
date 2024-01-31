Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D424FC19
	for <nvdimm@lists.linux.dev>; Wed, 31 Jan 2024 03:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706670612; cv=none; b=dhwe4cdVd5p3Y/hXHgz6vxQB6lENPziNHt9VoZJfR5kEuPGDks6jX+6LAUdDj5hCc9k2Cc8daUZh3fgSMwzXoYivb361ubXzqNPAPFJ1SeevCYw95LLW2kKk6jkI6ikgMjblkP3jzropVeUp+docZGOeaGn+fVDTvCOhX+QW730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706670612; c=relaxed/simple;
	bh=AGsjZKHPxUzHkeJcKlmNB2WAiLv7/SQgRpmAwacIlHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGEmwUjJMo59kfx4dER1RuAyVm7CsKnOIBYCY2oxCP0F0CRCq+c9yw44VuufQmQ4CAEevrdgn4wGW/xKKN0IUDkLCpTDI8Zrri2doAdOzXRke0mRJm/vuXMjJHJmaWw3fRiCGsgMmz8BpE4w0GPqHRgIWXBuT48M/2Pk47PyJ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WSdk2ftZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WSdk2ftZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706670610; x=1738206610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AGsjZKHPxUzHkeJcKlmNB2WAiLv7/SQgRpmAwacIlHY=;
  b=WSdk2ftZLJsYQhr3KAnHKhOoGnqTnSGjbIfop+979OfClvhvAQd7Bk7t
   a5iTYp3Fxo/FHO5NDWeLqI0cMFhJKM7oKdQg9/6wlquuCyHQTKsVSd0L5
   z9PXpnKVWri4V4jcpXrPdsKGI70LwPFFrkqTAu6cNhfsRvCIsKMD/2x/B
   7RX/fq7x8XxVDhRyGV6HE/98dfj7T/qSb2LYM/cDuUDqq7kufCSTwgKOo
   qt+M5pdmy8KRxCNwn+yrGLd9rEm0ocrsWch/DUCl3vH4c6nYc/NgAkdHk
   ek2atfvPiRND4eaXTPpLxbnK3X2uNGa52dhepKF9OQXxSU06MLTA5PZmL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="17001295"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="17001295"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 19:10:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="858669878"
X-IronPort-AV: E=Sophos;i="6.05,231,1701158400"; 
   d="scan'208";a="858669878"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.40.203])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 19:10:08 -0800
Date: Tue, 30 Jan 2024 19:10:07 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v4 3/4] ndctl: cxl: add QoS class check for CXL
 region creation
Message-ID: <Zbm6Dwa93iO0O83Z@aschofie-mobl2>
References: <20240130233526.1031801-1-dave.jiang@intel.com>
 <20240130233526.1031801-4-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130233526.1031801-4-dave.jiang@intel.com>

On Tue, Jan 30, 2024 at 04:32:43PM -0700, Dave Jiang wrote:
> The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
> represents the CFMWS. A qos_class attribute is exported via sysfs for the root
> decoder.
> 
> One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
> device for a CXL memory device. The input for the _DSM is the read and write
> latency and bandwidth for the path between the device and the CPU. The
> numbers are constructed by the kernel driver for the _DSM input. When a
> device is probed, QoS class tokens  are retrieved. This is useful for a
> hot-plugged CXL memory device that does not have regions created.
> 
> Add a QoS check during region creation. Emit a warning if the qos_class
> token from the root decoder is different than the mem device qos_class
> token. User parameter options are provided to fail instead of just
> warning.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> ---
> v4:
> - Deal with single memdev qos_class due to kernel change
> - Clarify commit log verbiage (Alison)
> ---
>  Documentation/cxl/cxl-create-region.txt |  9 ++++
>  cxl/region.c                            | 56 ++++++++++++++++++++++++-
>  2 files changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index f11a412bddfe..d5e34cf38236 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -105,6 +105,15 @@ include::bus-option.txt[]
>  	supplied, the first cross-host bridge (if available), decoder that
>  	supports the largest interleave will be chosen.
>  
> +-e::
> +--strict::
> +	Enforce strict execution where any potential error will force failure.
> +	For example, if qos_class mismatches region creation will fail.
> +
> +-q::
> +--no-enforce-qos::
> +	Parameter to bypass qos_class mismatch failure. Will only emit warning.
> +
>  include::human-option.txt[]
>  
>  include::debug-option.txt[]
> diff --git a/cxl/region.c b/cxl/region.c
> index 3a762db4800e..f9033fa0afbf 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -32,6 +32,8 @@ static struct region_params {
>  	bool force;
>  	bool human;
>  	bool debug;
> +	bool strict;
> +	bool no_qos;
>  } param = {
>  	.ways = INT_MAX,
>  	.granularity = INT_MAX,
> @@ -49,6 +51,8 @@ struct parsed_params {
>  	const char **argv;
>  	struct cxl_decoder *root_decoder;
>  	enum cxl_decoder_mode mode;
> +	bool strict;
> +	bool no_qos;
>  };
>  
>  enum region_actions {
> @@ -81,7 +85,9 @@ OPT_STRING('U', "uuid", &param.uuid, \
>  	   "region uuid", "uuid for the new region (default: autogenerate)"), \
>  OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
>  	    "non-option arguments are memdevs"), \
> -OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
> +OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
> +OPT_BOOLEAN('e', "strict", &param.strict, "strict execution enforcement"), \
> +OPT_BOOLEAN('q', "no-enforce-qos", &param.no_qos, "no enforce of qos_class")
>  
>  static const struct option create_options[] = {
>  	BASE_OPTIONS(),
> @@ -360,6 +366,9 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  		}
>  	}
>  
> +	p->strict = param.strict;
> +	p->no_qos = param.no_qos;
> +
>  	return 0;
>  
>  err:
> @@ -467,6 +476,49 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
>  		p->mode = CXL_DECODER_MODE_PMEM;
>  }
>  
> +static int create_region_validate_qos_class(struct cxl_ctx *ctx,
> +					    struct parsed_params *p)
> +{
> +	int root_qos_class;
> +	int qos_class;
> +	int i;
> +
> +	root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
> +	if (root_qos_class == CXL_QOS_CLASS_NONE)
> +		return 0;
> +
> +	for (i = 0; i < p->ways; i++) {
> +		struct json_object *jobj =
> +			json_object_array_get_idx(p->memdevs, i);
> +		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
> +
> +		if (p->mode == CXL_DECODER_MODE_RAM)
> +			qos_class = cxl_memdev_get_ram_qos_class(memdev);
> +		else
> +			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
> +
> +		/* No qos_class entries. Possibly no kernel support */
> +		if (qos_class == CXL_QOS_CLASS_NONE)
> +			break;
> +
> +		if (qos_class != root_qos_class) {
> +			if (p->strict && !p->no_qos) {
> +				log_err(&rl, "%s QoS Class mismatches %s\n",
> +					cxl_decoder_get_devname(p->root_decoder),
> +					cxl_memdev_get_devname(memdev));
> +
> +				return -ENXIO;
> +			}
> +
> +			log_notice(&rl, "%s QoS Class mismatches %s\n",
> +				   cxl_decoder_get_devname(p->root_decoder),
> +				   cxl_memdev_get_devname(memdev));
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int create_region_validate_config(struct cxl_ctx *ctx,
>  					 struct parsed_params *p)
>  {
> @@ -507,6 +559,8 @@ found:
>  		return rc;
>  
>  	collect_minsize(ctx, p);
> +	create_region_validate_qos_class(ctx, p);
> +
>  	return 0;
>  }
>  
> -- 
> 2.43.0
> 
> 
