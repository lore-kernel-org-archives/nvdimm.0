Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255B610F6
	for <nvdimm@lists.linux.dev>; Tue, 21 Feb 2023 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676997855; x=1708533855;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZhwehMAw41GtMcDVQ6KHdWKXOcaiQZygQ73vYJx2B24=;
  b=ed+rdv3s6cgP0wBcKsMYSPdCd+0zr0D9etNmoC2fVuFqZq/s/2mFpzfW
   OaXA4avCF+bROtXRHwvJlvPLdPBHKOm75aEiDyPAMQP6WePlePpms/Y1Q
   hUjcXB0m4YL5E/HND9ClaSqlnCv42pkF9QzuStatcK2Y2QPF2CWsj6e2e
   EBCEtx1StWCw2JC4t8+DKNWUVK7wUnqv8/mdYae/ZGOgz/7fL8oIMm+1Q
   JbRox2LTkT2/Dt9rjVNQPIdE9XVcm7l04NJGETdx8pM68K+DfypUuqmuf
   zg4TDSoocxumoonypsVo2CKFa56MFZ6EimY5PlJ+tWw5a5p9fg4dpzGIz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="334879622"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="334879622"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:44:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="845740346"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="845740346"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.184.163]) ([10.213.184.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 08:44:14 -0800
Message-ID: <5cc778de-3ae5-56b9-84d2-9e543c1fc93c@intel.com>
Date: Tue, 21 Feb 2023 09:44:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH ndctl 1/3] cxl/event_trace: fix a resource leak in
 cxl_event_to_json()
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
 <20230217-coverity-fixes-v1-1-043fac896a40@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230217-coverity-fixes-v1-1-043fac896a40@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/17/23 5:40 PM, Vishal Verma wrote:
> Static analysis reports that a 'return -ENOMEM' in the above function
> bypasses the error unwinding and leaks 'jevent'.
> 
> Fix the error handling to use the right goto sequence before returning.
> 
> Fixes: 8dedc6cf5e85 ("cxl: add a helper to parse trace events into a json object")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/event_trace.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> index a973a1f..76dd4e7 100644
> --- a/cxl/event_trace.c
> +++ b/cxl/event_trace.c
> @@ -142,7 +142,8 @@ static int cxl_event_to_json(struct tep_event *event, struct tep_record *record,
>   				jobj = num_to_json(data, f->elementsize, f->flags);
>   				if (!jobj) {
>   					json_object_put(jarray);
> -					return -ENOMEM;
> +					rc = -ENOMEM;
> +					goto err_jevent;
>   				}
>   				json_object_array_add(jarray, jobj);
>   				data += f->elementsize;
> 
