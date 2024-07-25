Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE13BBC2
	for <nvdimm@lists.linux.dev>; Thu, 25 Jul 2024 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721935346; cv=none; b=sjQZVmJK7co7zuPnsgr3itfOg2fhIjrs/GOJb0suOiHRdWUzJRx1lKRuvpzmVuWpywW3ussiEZ26aH7L+Ab/DQiDr+laiRNks57ursQx1+Rt3cJSvu1/v35zeUWtq88Kqg/kEFEymgi27rmn7XJ1XxIsBQNn6sGlG3n+zE/C0d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721935346; c=relaxed/simple;
	bh=fmeHloxeHOgn40k7He3+RXXjEeMTSM32MF04CBVoJB4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xkw+nfKckaPmKb7YzOJR/MMYKyyYuuk8BDnigUiIRzdH3AxCyowzv/ncgEPupRYdpoJRbzt/jl5R1f4oxmW99z2pE+Qxj4g3GlX4UgXB3gCrcyd6smXPFe5lNerZH32lZq1YE/ykUZESyt2uOIgE5q9q5ZPcODVoAx02MCfS38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQ5S7k/d; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQ5S7k/d"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fd6ed7688cso11692795ad.3
        for <nvdimm@lists.linux.dev>; Thu, 25 Jul 2024 12:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721935344; x=1722540144; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b5AgIC8M+mSDoG8S1la9gEv75TPyLAajBHhXa0YRYkI=;
        b=CQ5S7k/dnGGO+Rx1KBqklOWjpMgc6xmFx1mw7jIkpJupWaVhJID6wM24GYx244dPj2
         TBYE2qeSEb0Z/VlgkUETx2CTwdPFkYLfXZiFenHJYQtQKrw8Wu/LJKMdSFRbLzZ2mR/F
         AEiLHeIIdM2O0lETHtFbwG5xtdcmpMcvdMvI9KIWEWVQkVhQe+kqyoagAllHQCzji2xJ
         y14eYcMew+nMbPcHVoGLKwykVfiitLlwvG+F0AaUJCs55LSQPQ49fNU56boXyLbJauUF
         t2BY+nlSQh6qOKeCaQqxT934q5LlZ2pbBYKlVHDWYnDH7Lc5J2iPmlQ/Y4lKQHr7e0Dm
         +9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721935344; x=1722540144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5AgIC8M+mSDoG8S1la9gEv75TPyLAajBHhXa0YRYkI=;
        b=KpCH6OI0CgHggdoJsZwP95uVBThkz2g6eHVOwpfXCB8lYdT0VjGySMxejptoiKEWx0
         VzWYgS9sge+rslYti1l7wgMjjJgQTx4enLRxayh7PTwRssom6yiYeSjf/dc5FhoF+LzT
         DJ+phftQEPatbUfiWJnbkeftT+4VA/+LyoGVQNkLf/4OA3mqdCR05NY57nD7d00txpt6
         ERJA49YCJhAvEaKT5Irfqcen47xLCOa6J5gudA1pphJeApQny/zZVlJJxId7cyJc3sf2
         2QKqS5KwcdgB4y2sOIREVGiKPQiSIQN0Kcf/QPpIGZdJgodmoljLMRRE5f52VQ7peqyc
         1ezg==
X-Gm-Message-State: AOJu0Yx0xo0Jp2TZMP51gjZFk107lss440Ury6XfB3OFFzSScYX+KQDn
	EaRFlOpRa8Y1vucUDRjPcrUVJOoqKc9gw3SosmQBq9o901USX36QA/JUYg==
X-Google-Smtp-Source: AGHT+IETDvJnBhB8TU68dhcjyeHDQae5qz3pV9dlFOX8cIjeTmnC28aE/MqCumXczQ2nvWDmgnWr8w==
X-Received: by 2002:a17:902:e749:b0:1fd:9d0c:99a2 with SMTP id d9443c01a7336-1fed3ad7beamr51244285ad.54.1721935344094;
        Thu, 25 Jul 2024 12:22:24 -0700 (PDT)
Received: from debian ([2601:646:8f03:9fee:712d:3b8b:71f1:cced])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7f36cc2sm17754715ad.215.2024.07.25.12.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jul 2024 12:22:23 -0700 (PDT)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan.ni@samsung.com>
Date: Thu, 25 Jul 2024 12:22:05 -0700
To: alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH] cxl/list: add firmware_version to default memdev
 listing
Message-ID: <ZqKl3cVFTnbaBHpJ@debian>
References: <20240725073050.219952-1-alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725073050.219952-1-alison.schofield@intel.com>

On Thu, Jul 25, 2024 at 12:30:50AM -0700, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl list users may discover the firmware revision of a memory
> device by using the -F option to cxl list. That option uses
> the CXL GET_FW_INFO command and emits this json:
> 
> "firmware":{
>       "num_slots":2,
>       "active_slot":1,
>       "staged_slot":1,
>       "online_activate_capable":false,
>       "slot_1_version":"BWFW VERSION 0",
>       "fw_update_in_progress":false
>     }
> 
> Since device support for GET_FW_INFO is optional, the above method
> is not guaranteed. However, the IDENTIFY command is mandatory and
> provides the current firmware revision.
> 
> Accessors already exist for retrieval from sysfs so simply add
> the new json member to the default memdev listing.
> 
> This means users of the -F option will get the same info twice if
> GET_FW_INFO is supported.
> 
> [
>   {
>     "memdev":"mem9",
>     "pmem_size":268435456,
>     "serial":0,
>     "host":"0000:c0:00.0"
>     "firmware_version":"BWFW VERSION 00",
>   }
> ]
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> ---
>  cxl/json.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 0c27abaea0bd..0b0b186a2594 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -577,6 +577,7 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  	const char *devname = cxl_memdev_get_devname(memdev);
>  	struct json_object *jdev, *jobj;
>  	unsigned long long serial, size;
> +	const char *fw_version;
>  	int numa_node;
>  	int qos_class;
>  
> @@ -646,6 +647,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  	if (jobj)
>  		json_object_object_add(jdev, "host", jobj);
>  
> +	fw_version = cxl_memdev_get_firmware_version(memdev);
> +	if (fw_version) {
> +		jobj = json_object_new_string(fw_version);
> +		if (jobj)
> +			json_object_object_add(jdev, "firmware_version", jobj);
> +	}
> +
>  	if (!cxl_memdev_is_enabled(memdev)) {
>  		jobj = json_object_new_string("disabled");
>  		if (jobj)
> -- 
> 2.37.3
> 
