Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAB5610E
	for <nvdimm@lists.linux.dev>; Fri, 24 Feb 2023 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677252596; x=1708788596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Aj/mFk9uBP2ayvZGuXAoGTOjpWoy6rUq6becmuwIXXQ=;
  b=FL0dhXPTZ/D5UE/miLsPSMdBPICLyC1yqXZCDCx3KJYj7p0QqW9eiS3W
   POaPMbj9cMCHh/DWo8unrCpp3fqiszJbFxy/AJRxPiekun4WnQkjEyMur
   Z2ZDmG46KDkgIHt2geOv7Yl60G1r8MLCgmNwZ/YptvI+yxN9R5OUMZrQA
   zFhSoC8izUpY6cw+DeBYJ7upMK4vYqZ12jx5oCg0sVyV+I1vw4Wy4aiIa
   VdANp0UKUh1llvvigiFgtX135uZHiniWmxanseS7Z4fAaflCnd757Rbur
   BAjN6JQ2TuqCZr6EgcLSR5Or7W62snCg3dSDrpPMWqDLfu7nCE0vFFUKz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="398230107"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="398230107"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 07:29:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="1001857496"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="1001857496"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.22.194]) ([10.212.22.194])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 07:29:55 -0800
Message-ID: <414e2318-3026-c234-2d72-eee15cca5b6f@intel.com>
Date: Fri, 24 Feb 2023 08:29:54 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH ndctl 2/2] cxl/event-trace: use the wrapped
 util_json_new_u64()
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
 Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
References: <20230223-meson-build-fixes-v1-0-5fae3b606395@intel.com>
 <20230223-meson-build-fixes-v1-2-5fae3b606395@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230223-meson-build-fixes-v1-2-5fae3b606395@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/23/23 10:45 PM, Vishal Verma wrote:
> The json-c API json_object_new_uint64() is relatively new, and some distros
> may not have it available. There is already a wrapped version in
> util/json.h which falls back to the int64 API, based on meson's
> determination of the availability of the uint64 version at compile time.
> Replace the direct uint64 calls with this wrapped version.
> 
> Link: https://github.com/pmem/ndctl/issues/233
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Reported-by: Michal Suchánek <msuchanek@suse.de>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/event_trace.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index 926f446..db8cc85 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -25,7 +25,7 @@ static struct json_object *num_to_json(void *num, int elem_size, unsigned long f
>   		if (sign)
>   			return json_object_new_int64(*(int64_t *)num);
>   		else
> -			return json_object_new_uint64(*(uint64_t *)num);
> +			return util_json_new_u64(*(uint64_t *)num);
>   	}
>   
>   	/* All others fit in a signed 64 bit */
> @@ -98,7 +98,7 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
>   	}
>   	json_object_object_add(jevent, "event", jobj);
>   
> -	jobj = json_object_new_uint64(record->ts);
> +	jobj = util_json_new_u64(record->ts);
>   	if (!jobj) {
>   		rc = -ENOMEM;
>   		goto err_jevent;
> 
