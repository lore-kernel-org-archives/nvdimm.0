Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B15139588
	for <nvdimm@lists.linux.dev>; Wed, 24 Jul 2024 20:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721854513; cv=none; b=HN/XaToQdIN7PGkNzY29XQovZhC2aFoiFGXbVrUdgzrYV2QQkPgOOnaVCQc/YincrZHfDKYsedqphVxjrsPyhmlH26nqrq+7G9PtUzJwuuDOfnYHo+GQmXWXwQESE2AO909BL0/7HKSitC7o1wpCUvaEqImQwT5BS2q44+LiU+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721854513; c=relaxed/simple;
	bh=ipotZBOPZTagpFBEudJ3ESRaxCn9j/hIT/fn4wAXbuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fQi7X71oFyLcR3jWbkJmhSjVr6Lnvm04yJa0BCnr9iFuLoT4yPbbAgCtVPsNQ8hLuNS7UdAFmu5JpcXsK6yYQuPKj+0THeWgHdA/XRaUKwSvAeEW+nR3PHsUaCtQ9YKw0Jxd8ImCPKocTNbdBz8eZIPK8cYV2Xguau/vk0XLeAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrdhneCh; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrdhneCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721854511; x=1753390511;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ipotZBOPZTagpFBEudJ3ESRaxCn9j/hIT/fn4wAXbuY=;
  b=FrdhneChl/3L8FV5FEQyGjxsU0uUYuB5pYYurnFneqXDna7OALlIzIks
   AJVDHpVhcDtVg0JqppIt1s5pUq91e9Bh+c0pibzW0PSJ09BR0xpZhGxpp
   lWIYXbeg298IErbwJ4SA6vkG1iakzGxQBPDwRPjPx3T0NXZrUamtmiGxx
   eOhaDhwTxpZC0eZPfsNOXloLQmz3z0FjRc/ZcLh6iVqkXmpnklU2cRWC9
   0Gt45H44kvqo4FxNNvdjJLrbJexVCKvzsXuCxhvVT8UraJOeM1l8S038A
   8PtOCEBcirMf+XxQRqjMwemebTN8WvwnJ75ttrYyiWSJ2JxAPFqOgf7PE
   A==;
X-CSE-ConnectionGUID: DkmWaXjWSQCuFY8hN+u/sA==
X-CSE-MsgGUID: OfnynXxsTVCYcuoF7HMkpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="30226814"
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="30226814"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 13:55:11 -0700
X-CSE-ConnectionGUID: U0yjK1cIR1i/Ie9yNeWJXg==
X-CSE-MsgGUID: YoExdQfvT16GnmF3ToEAqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,233,1716274800"; 
   d="scan'208";a="52623614"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.110.208]) ([10.125.110.208])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2024 13:55:11 -0700
Message-ID: <041104c0-ac92-4819-a511-3fa6655b94ef@intel.com>
Date: Wed, 24 Jul 2024 13:55:09 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v13 3/8] util/trace: pass an event_ctx to its own
 parse_event method
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <cover.1720241079.git.alison.schofield@intel.com>
 <da9be6ff7edcaef18470cc1579343fc08bc1dc1e.1720241079.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <da9be6ff7edcaef18470cc1579343fc08bc1dc1e.1720241079.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/5/24 11:24 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Tidy-up the calling convention used in trace event parsing by
> passing the entire event_ctx to its parse_event method. This
> makes it explicit that a parse_event operates on an event_ctx
> object and it allows the parse_event function to access any
> members of the event_ctx structure.
> 
> This is in preparation for adding a private parser requiring more
> context for cxl_poison events.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  util/event_trace.c | 9 ++++-----
>  util/event_trace.h | 2 +-
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/util/event_trace.c b/util/event_trace.c
> index 57318e2adace..1f5c180a030b 100644
> --- a/util/event_trace.c
> +++ b/util/event_trace.c
> @@ -60,7 +60,7 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
>  }
>  
>  static int event_to_json(struct tep_event *event, struct tep_record *record,
> -			 struct list_head *jlist_head)
> +			 struct event_ctx *ctx)
>  {
>  	struct json_object *jevent, *jobj, *jarray;
>  	struct tep_format_field **fields;
> @@ -190,7 +190,7 @@ static int event_to_json(struct tep_event *event, struct tep_record *record,
>  		}
>  	}
>  
> -	list_add_tail(jlist_head, &jnode->list);
> +	list_add_tail(&ctx->jlist_head, &jnode->list);
>  	return 0;
>  
>  err_jevent:
> @@ -220,10 +220,9 @@ static int event_parse(struct tep_event *event, struct tep_record *record,
>  	}
>  
>  	if (event_ctx->parse_event)
> -		return event_ctx->parse_event(event, record,
> -					      &event_ctx->jlist_head);
> +		return event_ctx->parse_event(event, record, event_ctx);
>  
> -	return event_to_json(event, record, &event_ctx->jlist_head);
> +	return event_to_json(event, record, event_ctx);
>  }
>  
>  int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx)
> diff --git a/util/event_trace.h b/util/event_trace.h
> index 6586e1dc254d..9c53eba7533f 100644
> --- a/util/event_trace.h
> +++ b/util/event_trace.h
> @@ -17,7 +17,7 @@ struct event_ctx {
>  	const char *event_name; /* optional */
>  	int event_pid; /* optional */
>  	int (*parse_event)(struct tep_event *event, struct tep_record *record,
> -			   struct list_head *jlist_head); /* optional */
> +			   struct event_ctx *ctx);
>  };
>  
>  int trace_event_parse(struct tracefs_instance *inst, struct event_ctx *ectx);
