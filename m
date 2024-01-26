Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9765120303
	for <nvdimm@lists.linux.dev>; Fri, 26 Jan 2024 17:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706291123; cv=none; b=TBaG7pYio85RKxPW/1CjBST4nbJX/AU1uOMF78JHWMrmA1LcNpfu8EQRSN1B26KR9O/EME/08wbcFBrFhYpw3uc4upB3GzjRcQTg/bqff0FpD8EsZpNt0qDwcfx3H1gPLzenWjmdf5R3Kn5ysQpWU1JEz8tZJqd1g3EG55Vcj60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706291123; c=relaxed/simple;
	bh=SosOKF9QaTK7Zj6jh7dYEAVgcm1jhW3bp+v+xnhtzbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcQy0xBSFY6NwTrzLECB13SHDUjoG2iqWKQCtiWqgTH+IX8MvCxFoLTA4r4ZYjf1LQ/t5RRUMUp8YQsaLfIZgt3dvW7iyxiBG+7yXPtKlSh7ffEwxjyAAYPGxWJtE1HjMaYPcDRtDmYkkl4u3v32SQs0OS3eTozGaDaO27uJG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NIOLtY1d; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NIOLtY1d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706291121; x=1737827121;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SosOKF9QaTK7Zj6jh7dYEAVgcm1jhW3bp+v+xnhtzbc=;
  b=NIOLtY1dDW61Da13iSBE9NBLa167GB8Ou4W9G4vo2RjHM17VnyD11KfU
   3ZznCqCMHeq4pC7l11FvqzifiGhqegFzAmCK232zldsihBoOEi/mDesj5
   YpYZTCzg/a3+kojzd7z0lCL5+Y91u3UZE0Wwf9fl0lvo2pN5djKF6UzXD
   6VjbURZyYE7eym5KTMtmUb2OuGoQhlT24t3ZijQo4ZoNQlUu+C2beNFKv
   R+mveo5x3bB1bLjZT+TB/1N7wgFZnQhsANJ8n6EY1qIVArwA0rGy0rV71
   b3Kqsn4J2fcbQUAgUBYOoOjFGtxst04bzE6K1ggMM5YLttudIrWmSiJGO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="15888115"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="15888115"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 09:45:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2685498"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.37.71])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 09:45:20 -0800
Date: Fri, 26 Jan 2024 09:45:18 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v3 1/3] ndctl: cxl: Add QoS class retrieval for the
 root decoder
Message-ID: <ZbPvrpTbZf1CGrpe@aschofie-mobl2>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <170612968166.2745924.10491030984129768174.stgit@djiang5-mobl3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170612968166.2745924.10491030984129768174.stgit@djiang5-mobl3>

On Wed, Jan 24, 2024 at 01:54:41PM -0700, Dave Jiang wrote:
> Add libcxl API to retrieve the QoS class for the root decoder. Also add
> support to display the QoS class for the root decoder through the 'cxl
> list' command. The qos_class is displayed behind -vvv verbose level.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> ---
> v3:
> - Rebase to latest pending branch
> ---
>  cxl/filter.h       |    4 ++++
>  cxl/json.c         |   10 ++++++++++
>  cxl/lib/libcxl.c   |   14 ++++++++++++++
>  cxl/lib/libcxl.sym |    1 +
>  cxl/lib/private.h  |    1 +
>  cxl/libcxl.h       |    3 +++
>  cxl/list.c         |    1 +
>  util/json.h        |    1 +
>  8 files changed, 35 insertions(+)
> 
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 1241f72ccf62..3c5f9e8a0452 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -31,6 +31,7 @@ struct cxl_filter_params {
>  	bool alert_config;
>  	bool dax;
>  	bool poison;
> +	bool qos;
>  	int verbose;
>  	struct log_ctx ctx;
>  };
> @@ -91,6 +92,9 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
>  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
>  	if (param->poison)
>  		flags |= UTIL_JSON_MEDIA_ERRORS;
> +	if (param->qos)
> +		flags |= UTIL_JSON_QOS_CLASS;
> +
>  	return flags;
>  }
>  
> diff --git a/cxl/json.c b/cxl/json.c
> index 6fb17582a1cb..48a43ddf14b0 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -1062,6 +1062,16 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
>  					       jobj);
>  	}
>  
> +	if ((flags & UTIL_JSON_QOS_CLASS) && cxl_port_is_root(port)) {
> +		int qos_class = cxl_root_decoder_get_qos_class(decoder);
> +
> +		if (qos_class != CXL_QOS_CLASS_NONE) {
> +			jobj = json_object_new_int(qos_class);
> +			if (jobj)
> +				json_object_object_add(jdecoder, "qos_class", jobj);
> +		}
> +	}
> +
>  	json_object_set_userdata(jdecoder, decoder, NULL);
>  	return jdecoder;
>  }
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 1537a33d370e..9a1ac7001803 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -2229,6 +2229,12 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  	else
>  		decoder->interleave_ways = strtoul(buf, NULL, 0);
>  
> +	sprintf(path, "%s/qos_class", cxldecoder_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		decoder->qos_class = CXL_QOS_CLASS_NONE;
> +	else
> +		decoder->qos_class = atoi(buf);
> +
>  	switch (port->type) {
>  	case CXL_PORT_ENDPOINT:
>  		sprintf(path, "%s/dpa_resource", cxldecoder_base);
> @@ -2423,6 +2429,14 @@ CXL_EXPORT unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder)
>  	return decoder->size;
>  }
>  
> +CXL_EXPORT int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder)
> +{
> +	if (!cxl_port_is_root(decoder->port))
> +		return -EINVAL;
> +
> +	return decoder->qos_class;
> +}
> +
>  CXL_EXPORT unsigned long long
>  cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder)
>  {
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 2149f84d764e..384fea2c25e3 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -282,4 +282,5 @@ global:
>  LIBCXL_8 {
>  global:
>  	cxl_memdev_wait_sanitize;
> +	cxl_root_decoder_get_qos_class;
>  } LIBCXL_7;
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index b26a8629e047..4847ff448f71 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -144,6 +144,7 @@ struct cxl_decoder {
>  	struct list_head targets;
>  	struct list_head regions;
>  	struct list_head stale_regions;
> +	int qos_class;
>  };
>  
>  enum cxl_decode_state {
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 352b3a866f63..e5c08da77f77 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -173,6 +173,8 @@ struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
>  	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
>  	     dport = cxl_dport_get_next(dport))
>  
> +#define CXL_QOS_CLASS_NONE		-1
> +
>  struct cxl_decoder;
>  struct cxl_decoder *cxl_decoder_get_first(struct cxl_port *port);
>  struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder);
> @@ -184,6 +186,7 @@ unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
>  unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
>  unsigned long long
>  cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
> +int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
>  
>  enum cxl_decoder_mode {
>  	CXL_DECODER_MODE_NONE,
> diff --git a/cxl/list.c b/cxl/list.c
> index 13fef8569340..f6446f98c2bd 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -123,6 +123,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.fw = true;
>  		param.alert_config = true;
>  		param.dax = true;
> +		param.qos = true;
>  		/* fallthrough */
>  	case 2:
>  		param.idle = true;
> diff --git a/util/json.h b/util/json.h
> index ea370df4d1b7..b07055005084 100644
> --- a/util/json.h
> +++ b/util/json.h
> @@ -21,6 +21,7 @@ enum util_json_flags {
>  	UTIL_JSON_TARGETS	= (1 << 11),
>  	UTIL_JSON_PARTITION	= (1 << 12),
>  	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
> +	UTIL_JSON_QOS_CLASS	= (1 << 14),
>  };
>  
>  void util_display_json_array(FILE *f_out, struct json_object *jarray,
> 
> 
> 
