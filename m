Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3A76169E
	for <nvdimm@lists.linux.dev>; Mon,  4 Mar 2024 18:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709576807; cv=none; b=CfVO1lJwFylOnhcSdWwleOlxdzkQVEZMxwM1WDA7GojTZn4UAIyoDO1n+vGni9k9CrEnrBchqBeCtrQRAe8WPDde/aJyPpoBwNSm9BjmN2QGMEjCvaqvp+szGCrZUtOWIPH/JK8krXKY1E8Cru142PKC1xZQrqG2i28PGiUTvo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709576807; c=relaxed/simple;
	bh=ZRGWEwfGo3XHCGL1E28+X/9CFNSVgUWBmMd0ddtjZKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KNTENKnFau+r0Aflf8n6XImimDgV+UmqOR+1dX5aHHFZAADAIqVTdguIJO2ktVmhsZdae3vXja11gNIuRJIuHbATjxWA5F4lt66ifq5MG+2nA9jYu3kQa8m4ydiAGTJIISavkHuogXjCeaHX93TGpSvvJf3HsxL8uEuBaMvGT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+xoED3y; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+xoED3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709576806; x=1741112806;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZRGWEwfGo3XHCGL1E28+X/9CFNSVgUWBmMd0ddtjZKU=;
  b=G+xoED3yQg0NuCG+339k4a4kRElKerby4nJNY4mf32+RL/y+2/fk6cAY
   zHv22HQUS2WpWR/qlE3a6BRW+a8Xg19WDL0/5f8eCAaOtf/NNT9xhWVzS
   W5lPMESE/qQvw3Vjh10VpUJZUEj0+l3LpkmEcOPmkGWgiYME+xIhMLRpI
   QV68TV1fPl6zipVNiF4SBqhJW1nI0qZh5N0b1FtO1fBon6Vm2T/Y957hf
   t9t5ii9x6fWjE5a7fK8gZxDSPvAZoA8jF0PLct7oixK3XteGftmOn2S3O
   xsZzu1OvuJLlu2FkSojg5mLz8kahfdswBFSWClFUipbcyzn15F0szw1qB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4254651"
X-IronPort-AV: E=Sophos;i="6.06,204,1705392000"; 
   d="scan'208";a="4254651"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 10:26:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,204,1705392000"; 
   d="scan'208";a="39947049"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.247.118.63]) ([10.247.118.63])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 10:26:42 -0800
Message-ID: <5a01344f-2365-4ae1-a5aa-e13085c0605c@intel.com>
Date: Mon, 4 Mar 2024 11:26:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v9 4/7] cxl/event_trace: add helpers to retrieve tep
 fields by type
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1709253898.git.alison.schofield@intel.com>
 <6e07b4ceb01a56aa6791749709c2bf311bb91e1d.1709253898.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <6e07b4ceb01a56aa6791749709c2bf311bb91e1d.1709253898.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/29/24 6:31 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Add helpers to extract the value of an event record field given the
> field name. This is useful when the user knows the name and format
> of the field and simply needs to get it.
> 
> Since this is in preparation for adding a cxl_poison private parser
> for 'cxl list --media-errors' support, add those specific required
> types: u8, u32, u64, char*
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/event_trace.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/event_trace.h | 10 ++++++-
>  2 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index bdad0c19dbd4..6cc9444f3204 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -15,6 +15,81 @@
>  #define _GNU_SOURCE
>  #include <string.h>
>  
> +static struct tep_format_field *__find_field(struct tep_event *event,
> +					     const char *name)
> +{
> +	struct tep_format_field **fields;
> +
> +	fields = tep_event_fields(event);
> +	if (!fields)
> +		return NULL;
> +
> +	for (int i = 0; fields[i]; i++) {
> +		struct tep_format_field *f = fields[i];
> +
> +		if (strcmp(f->name, name) != 0)
> +			continue;
> +
> +		return f;
> +	}
> +	return NULL;
> +}
> +
> +u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
> +		      const char *name)
> +{
> +	struct tep_format_field *f;
> +	unsigned char *val;
> +	int len;
> +
> +	f = __find_field(event, name);
> +	if (!f)
> +		return ULLONG_MAX;
> +
> +	val = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> +	if (!val)
> +		return ULLONG_MAX;
> +
> +	return *(u64 *)val;
> +}
> +
> +char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
> +			   const char *name)
> +{
> +	struct tep_format_field *f;
> +	int len;
> +
> +	f = __find_field(event, name);
> +	if (!f)
> +		return NULL;
> +
> +	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> +}
> +
> +u32 cxl_get_field_u32(struct tep_event *event, struct tep_record *record,
> +		      const char *name)
> +{
> +	char *val;
> +
> +	val = cxl_get_field_string(event, record, name);
> +	if (!val)
> +		return UINT_MAX;
> +
> +	return *(u32 *)val;
> +}
> +
> +u8 cxl_get_field_u8(struct tep_event *event, struct tep_record *record,
> +		    const char *name)
> +{
> +	char *val;
> +
> +	val = cxl_get_field_string(event, record, name);
> +	if (!val)
> +		return UCHAR_MAX;
> +
> +	return *(u8 *)val;
> +}
> +
>  static struct json_object *num_to_json(void *num, int elem_size, unsigned long flags)
>  {
>  	bool sign = flags & TEP_FIELD_IS_SIGNED;
> diff --git a/cxl/event_trace.h b/cxl/event_trace.h
> index ec61962abbc6..bbdea3b896e0 100644
> --- a/cxl/event_trace.h
> +++ b/cxl/event_trace.h
> @@ -5,6 +5,7 @@
>  
>  #include <json-c/json.h>
>  #include <ccan/list/list.h>
> +#include <ccan/short_types/short_types.h>
>  
>  struct jlist_node {
>  	struct json_object *jobj;
> @@ -25,5 +26,12 @@ int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
>  int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system,
>  		const char *event);
>  int cxl_event_tracing_disable(struct tracefs_instance *inst);
> -
> +char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
> +			   const char *name);
> +u8 cxl_get_field_u8(struct tep_event *event, struct tep_record *record,
> +		    const char *name);
> +u32 cxl_get_field_u32(struct tep_event *event, struct tep_record *record,
> +		      const char *name);
> +u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
> +		      const char *name);
>  #endif
