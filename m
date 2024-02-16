Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F66312F58A
	for <nvdimm@lists.linux.dev>; Fri, 16 Feb 2024 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708097629; cv=none; b=sH5TscrerQq6DHKS9hty2fjANt8UVdIjzqWE6CdDMfgqiMCSvOPQFEZ61q8UZQRUCMeWQ8AVWDsR6hWuu7zLoVfEk3eLtHoA5HcY07BElt6Zg2QDHusmmH9LJOYUnez+Wyu6GapOLXf43ZZ7o8wn+FvRU/2d06VMYszOxAhEzb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708097629; c=relaxed/simple;
	bh=OS40/PbHR+rczIRsxqevje9QpOpm9PuYW2JbIxtKokI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNBPzl4d3U2UoCPrLVRRr6n3MN85GSU/S5z+aoe2HMfhvKhruvl9X0qNHty5b6F0iKV37lOq+v4HhMl5AyiQly0PnwPH0GT42yrPpY54QkSFFrwV1MKlsJpaN0TJWn7m8cY2L+VxztTfPZqtoJCQDfLX3srbuA9/rchjFpw5+xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaQjz4Q1; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaQjz4Q1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708097627; x=1739633627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OS40/PbHR+rczIRsxqevje9QpOpm9PuYW2JbIxtKokI=;
  b=EaQjz4Q1hLcaaOlI/3N9dWFSvqBiyh2dVTCIjthAdG50KxRpIwHHXJSD
   esZs3g65i+L8C32CyohWPoYtohPgalYGPZF4mzGliF5sipjXZEkhpJ2Gn
   W3mFyXUO8gs7FJxgWbm0hnYvIyTDg0HLC7xeQ6Mtpx/GJcB0HKVKHyiZ4
   6waPGGyKIAtvBqawd0WExVAQOcdZPGLgweKUAYrFnX+8mXN9ukyTRR+DG
   n0X/TXkqzabZHieqNJWdCzM/hzMQh4pBLJFWwjvrQHN8G9j2B9Q8jrhuQ
   ci9QCa6up29NH2yNBIXIcmHSR2bgAc8brAG3qD8dNwPY23wuYSO+GsJq4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="2634926"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="2634926"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:33:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="8502676"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.4]) ([10.246.112.4])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 07:33:46 -0800
Message-ID: <9191ea3c-3bb4-448c-a8b1-f03dff21e7de@intel.com>
Date: Fri, 16 Feb 2024 08:33:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/event_trace: parse arrays separately from
 strings
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20240216060610.1951127-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240216060610.1951127-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/15/24 11:06 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Arrays are being parsed as strings based on a flag that seems like
> it would be the differentiator, ARRAY and STRING, but it is not.
> 
> libtraceevent sets the flags for arrays and strings like this:
> array:  TEP_FIELD_IS_[ARRAY | STRING]
> string: TEP_FIELD_IS_[ARRAY | STRING | DYNAMIC]
> 
> Use TEP_FIELD_IS_DYNAMIC to discover the field type, otherwise arrays
> get parsed as strings and 'cxl monitor' returns gobbledygook in the
> array type fields.
> 
> This fixes the "data" field of cxl_generic_events and the "uuid" field
> of cxl_poison.
> 
> Before:
> {"system":"cxl","event":"cxl_generic_event","timestamp":3469041387470,"memdev":"mem0","host":"cxl_mem.0","log":0,"hdr_uuid":"ba5eba11-abcd-efeb-a55a-a55aa5a55aa5","serial":0,"hdr_flags":8,"hdr_handle":1,"hdr_related_handle":42422,"hdr_timestamp":0,"hdr_length":128,"hdr_maint_op_class":0,"data":"Þ­¾ï"}
> 
> After:
> {"system":"cxl","event":"cxl_generic_event","timestamp":312851657810,"memdev":"mem0","host":"cxl_mem.0","log":0,"hdr_uuid":"ba5eba11-abcd-efeb-a55a-a55aa5a55aa5","serial":0,"hdr_flags":8,"hdr_handle":1,"hdr_related_handle":42422,"hdr_timestamp":0,"hdr_length":128,"hdr_maint_op_class":0,"data":[222,173,190,239,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
> 
> Before:
> {"system":"cxl","event":"cxl_poison","timestamp":3292418311609,"memdev":"mem1","host":"cxl_mem.1","serial":1,"trace_type":2,"region":"region5","overflow_ts":0,"hpa":1035355557888,"dpa":1073741824,"dpa_length":64,"uuid":"�Fe�c�CI�����2�]","source":0,"flags":0}
> 
> After:
> {"system":"cxl","event":"cxl_poison","timestamp":94600531271,"memdev":"mem1","host":"cxl_mem.1","serial":1,"trace_type":2,"region":"region5","overflow_ts":0,"hpa":1035355557888,"dpa":1073741824,"dpa_length":64,"uuid":[139,200,184,22,236,103,76,121,157,243,47,110,243,11,158,62],"source":0,"flags":0}
> 
> That cxl_poison uuid format can be further improved by using the trace
> type (__field_struct uuid_t) in the CXL kernel driver. The parser will
> automatically pick up that new type, as illustrated in the "hdr_uuid"
> of cxl_generic_media event trace above.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/event_trace.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index db8cc85f0b6f..1b5aa09de8b2 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -109,7 +109,13 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
>  		struct tep_format_field *f = fields[i];
>  		int len;
>  
> -		if (f->flags & TEP_FIELD_IS_STRING) {
> +		/*
> +		 * libtraceevent differentiates arrays and strings like this:
> +		 * array:  TEP_FIELD_IS_[ARRAY | STRING]
> +		 * string: TEP_FIELD_IS_[ARRAY | STRING | DYNAMIC]
> +		 */
> +		if ((f->flags & TEP_FIELD_IS_STRING) &&
> +		    ((f->flags & TEP_FIELD_IS_DYNAMIC))) {
>  			char *str;
>  
>  			str = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> 
> base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
