Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AA063C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606866; x=1702142866;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FnuAVsYSxEyNj8L4TwYmJsY5SuDAiW/QW2cmBdDx/ik=;
  b=lRqp9G5TJ5pJBXqSx4gfTLjlS4eXigzz56Wc8UqY5n9GrJbvTD3taZ31
   AAr8P2eX+DgilT0vKa5HN9v1Uq+/qAV1801cLoIpAGfhAmOaWnx8UiM6r
   VNqV+e2HeqbtqbfcGbEpgp1rh15CPU7iEIN7edPDOyeh93yzi0Fmhzusz
   QPkc8IqeL+WbX6RNmfvVF/dciHBAoB6RvC2ukRTfAm4WH0+D2iDEDEbNV
   n4Tm6dXpGoi4azNrDZpinI6JVykknGS1b25zZYRQtErqmW9M0JKIlFG7X
   mqd61jDkeN1lWWtQXo0q+j1tGDt9guZ0OJ1EgK0VFDxZRzeSvRCJKum6q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="317534180"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="317534180"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:27:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="597792011"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="597792011"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:27:38 -0800
Date: Fri, 9 Dec 2022 09:27:37 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 09/18] cxl/filter: Return json-c topology
Message-ID: <Y5NwCXV0EelCKV7i@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053493095.582963.5155962994216061570.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053493095.582963.5155962994216061570.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:28:50PM -0800, Dan Williams wrote:
> In preparation for cxl_filter_walk() to be used to collect and publish cxl
> objects for other utilities, return the resulting json_object directly.
> Move the responsibility of freeing and optionally printing the object to
> the caller.

Tested-by: Alison Schofield <alison.schofield@intel.com>

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/filter.c |   30 ++++++------------------------
>  cxl/filter.h |   22 +++++++++++++++++++++-
>  cxl/list.c   |    7 ++++++-
>  3 files changed, 33 insertions(+), 26 deletions(-)
> 
> diff --git a/cxl/filter.c b/cxl/filter.c
> index 040e7deefb3e..8499450ded01 100644
> --- a/cxl/filter.c
> +++ b/cxl/filter.c
> @@ -672,23 +672,6 @@ util_cxl_decoder_filter_by_region(struct cxl_decoder *decoder,
>  	return decoder;
>  }
>  
> -static unsigned long params_to_flags(struct cxl_filter_params *param)
> -{
> -	unsigned long flags = 0;
> -
> -	if (param->idle)
> -		flags |= UTIL_JSON_IDLE;
> -	if (param->human)
> -		flags |= UTIL_JSON_HUMAN;
> -	if (param->health)
> -		flags |= UTIL_JSON_HEALTH;
> -	if (param->targets)
> -		flags |= UTIL_JSON_TARGETS;
> -	if (param->partition)
> -		flags |= UTIL_JSON_PARTITION;
> -	return flags;
> -}
> -
>  static void splice_array(struct cxl_filter_params *p, struct json_object *jobjs,
>  			 struct json_object *platform,
>  			 const char *container_name, bool do_container)
> @@ -1027,11 +1010,12 @@ walk_children:
>  	}
>  }
>  
> -int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
> +struct json_object *cxl_filter_walk(struct cxl_ctx *ctx,
> +				    struct cxl_filter_params *p)
>  {
>  	struct json_object *jdevs = NULL, *jbuses = NULL, *jports = NULL;
>  	struct json_object *jplatform = json_object_new_array();
> -	unsigned long flags = params_to_flags(p);
> +	unsigned long flags = cxl_filter_to_flags(p);
>  	struct json_object *jportdecoders = NULL;
>  	struct json_object *jbusdecoders = NULL;
>  	struct json_object *jepdecoders = NULL;
> @@ -1044,7 +1028,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
>  
>  	if (!jplatform) {
>  		dbg(p, "platform object allocation failure\n");
> -		return -ENOMEM;
> +		return NULL;
>  	}
>  
>  	janondevs = json_object_new_array();
> @@ -1232,9 +1216,7 @@ walk_children:
>  		     top_level_objs > 1);
>  	splice_array(p, jregions, jplatform, "regions", top_level_objs > 1);
>  
> -	util_display_json_array(stdout, jplatform, flags);
> -
> -	return 0;
> +	return jplatform;
>  err:
>  	json_object_put(janondevs);
>  	json_object_put(jbuses);
> @@ -1246,5 +1228,5 @@ err:
>  	json_object_put(jepdecoders);
>  	json_object_put(jregions);
>  	json_object_put(jplatform);
> -	return -ENOMEM;
> +	return NULL;
>  }
> diff --git a/cxl/filter.h b/cxl/filter.h
> index 256df49c3d0c..2bda6ddd77ca 100644
> --- a/cxl/filter.h
> +++ b/cxl/filter.h
> @@ -5,6 +5,7 @@
>  
>  #include <stdbool.h>
>  #include <util/log.h>
> +#include <util/json.h>
>  
>  struct cxl_filter_params {
>  	const char *memdev_filter;
> @@ -59,6 +60,25 @@ struct cxl_dport *util_cxl_dport_filter_by_memdev(struct cxl_dport *dport,
>  						  const char *serial);
>  struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
>  					    const char *__ident);
> -int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *param);
> +struct json_object *cxl_filter_walk(struct cxl_ctx *ctx,
> +				    struct cxl_filter_params *param);
> +
> +static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
> +{
> +	unsigned long flags = 0;
> +
> +	if (param->idle)
> +		flags |= UTIL_JSON_IDLE;
> +	if (param->human)
> +		flags |= UTIL_JSON_HUMAN;
> +	if (param->health)
> +		flags |= UTIL_JSON_HEALTH;
> +	if (param->targets)
> +		flags |= UTIL_JSON_TARGETS;
> +	if (param->partition)
> +		flags |= UTIL_JSON_PARTITION;
> +	return flags;
> +}
> +
>  bool cxl_filter_has(const char *needle, const char *__filter);
>  #endif /* _CXL_UTIL_FILTER_H_ */
> diff --git a/cxl/list.c b/cxl/list.c
> index 8c48fbbaaec3..2026de2b548b 100644
> --- a/cxl/list.c
> +++ b/cxl/list.c
> @@ -72,6 +72,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		"cxl list [<options>]",
>  		NULL
>  	};
> +	struct json_object *jtopology;
>  	int i;
>  
>  	argc = parse_options(argc, argv, options, u, 0);
> @@ -140,5 +141,9 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.endpoints = true;
>  
>  	dbg(&param, "walk topology\n");
> -	return cxl_filter_walk(ctx, &param);
> +	jtopology = cxl_filter_walk(ctx, &param);
> +	if (!jtopology)
> +		return -ENOMEM;
> +	util_display_json_array(stdout, jtopology, cxl_filter_to_flags(&param));
> +	return 0;
>  }
> 
