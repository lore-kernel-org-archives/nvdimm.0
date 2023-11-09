Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DE636B14
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 19:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4EHNA66"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-da2b9211dc0so1295694276.3
        for <nvdimm@lists.linux.dev>; Thu, 09 Nov 2023 11:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699558361; x=1700163161; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hQXgJnErkBTO7U9SamYe262ZEbX3WawKujvUuoSNKBA=;
        b=X4EHNA66yW1V6lV1d51KAqN7o9ZJPve66Xpgy9zFLtUBzn8QNO8XqQcUNTaSQDR8Bt
         rgMNEkkVtG+8yPCcjMDQbAA22WRy5MuGs2gxGjV+dPaucq98Q3wg1Xk9x7ApCVT+pJCw
         OesSleE0x2H3AoMvpbOzJvLcSXl8gN1IvnSKQfRbo1IVNOmrWSPazbkcQ4y94NedsOk8
         tUBVzvRfeXI1KBYMgs89yyElfv+wjNp3s4Oe065UuV99Q4S314YODc+RpmbqT2t7Zch4
         7gfgA0edqOGyQ6suF9Shp0m65ya4/M+VgbM8S3aQ6pVgiJoTxjnvvIl3qLNyoYGp3HUi
         lk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699558361; x=1700163161;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQXgJnErkBTO7U9SamYe262ZEbX3WawKujvUuoSNKBA=;
        b=i0r6xspP/JEqQZk1y/PqcKDQ2pKFIDIUNhbnzuoCMkghgUBlCSxbUAr/28CjdmLdaY
         s5zWYw2ZwEK3N2omoji9u+zhCSIWFnqe3B82o8RIY+jQ4ISXtOLQXhRfOPasPrj/KzGj
         /pfjSjcr6fOgYlzyc2DyuipJZtmTp+0dGusA9KCX0J0UtIMRNB139naFFgmga1kIMsXJ
         wGXY8BCaNUVITXB46ItwWl5dIPfSxRVtgcT+YuIRBxOXtv9CzsZ8cnMM7QQ3xSOBkokM
         gC5hcoRHybN3QRFs0OzonNJ3vu2KxrK77GrKPTZZfVO0O4unKXxHFuY6uZ8cJyRD0LvX
         EtLQ==
X-Gm-Message-State: AOJu0Yzf3JLvHoFAHtCW2lrcnbATpm6Qm3TyDRqsl2Sw1SY9rKjXrPhR
	UtEGRUcyQYlZJxIydy9Urwg=
X-Google-Smtp-Source: AGHT+IHvL/vRqXQfRXZmA2Lomae7MK9Jd2JjbJUrzCC4TaOLfowGZTpwp/Gfv/6NUBIDG3/ohRY1eg==
X-Received: by 2002:a25:d391:0:b0:d9a:fd25:e3ef with SMTP id e139-20020a25d391000000b00d9afd25e3efmr5648549ybf.64.1699558361244;
        Thu, 09 Nov 2023 11:32:41 -0800 (PST)
Received: from debian ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 4-20020a251104000000b00d9cb47932a0sm7627329ybr.25.2023.11.09.11.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 11:32:40 -0800 (PST)
From: fan <nifan.cxl@gmail.com>
X-Google-Original-From: fan <fan@debian>
Date: Thu, 9 Nov 2023 11:32:25 -0800
To: Dave Jiang <dave.jiang@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, dan.j.williams@intel.com,
	yangx.jy@fujitsu.com
Subject: Re: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
Message-ID: <ZU0zyfKYTUkAyUrk@debian>
References: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>

On Tue, Oct 31, 2023 at 02:20:45PM -0700, Dave Jiang wrote:
> The current operation for disable-region does not check if the memory
> covered by a region is online before attempting to disable the cxl region.
> Have the tool attempt to offline the relevant memory before attempting to
> disable the region(s). If offline fails, stop and return error.
> 
> Provide a -f option for the region to continue disable the region even if
> the memory is not offlined. Add a warning to state that the physical
> memory is being leaked and unrecoverable unless reboot due to disable without
> offline.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Fan Ni <fan.ni@samsung.com>

> 
> ---
> v3:
> - Remove movable check. (Dan)
> - Attempt to offline if not offline. -f will disable region anyways even
>   if memory not offline. (Dan)
> v2:
> - Update documentation and help output. (Vishal)
> ---
>  Documentation/cxl/cxl-disable-region.txt |   10 ++++++
>  cxl/region.c                             |   54 +++++++++++++++++++++++++++++-
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
> index 4b0625e40bf6..9abf19e96094 100644
> --- a/Documentation/cxl/cxl-disable-region.txt
> +++ b/Documentation/cxl/cxl-disable-region.txt
> @@ -14,6 +14,10 @@ SYNOPSIS
>  
>  include::region-description.txt[]
>  
> +If there are memory blocks that are still online, the operation will attempt to
> +offline the relevant blocks. If the offlining fails, the operation fails when not
> +using the -f (force) parameter.
> +
>  EXAMPLE
>  -------
>  ----
> @@ -27,6 +31,12 @@ OPTIONS
>  -------
>  include::bus-option.txt[]
>  
> +-f::
> +--force::
> +	Attempt to disable-region even though memory cannot be offlined successfully.
> +	Will emit warning that operation will permanently leak phiscal address space
> +	and cannot be recovered until a reboot.
> +
>  include::decoder-option.txt[]
>  
>  include::debug-option.txt[]
> diff --git a/cxl/region.c b/cxl/region.c
> index bcd703956207..5cbbf2749e2d 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -14,6 +14,7 @@
>  #include <util/parse-options.h>
>  #include <ccan/minmax/minmax.h>
>  #include <ccan/short_types/short_types.h>
> +#include <daxctl/libdaxctl.h>
>  
>  #include "filter.h"
>  #include "json.h"
> @@ -95,6 +96,8 @@ static const struct option enable_options[] = {
>  
>  static const struct option disable_options[] = {
>  	BASE_OPTIONS(),
> +	OPT_BOOLEAN('f', "force", &param.force,
> +		    "attempt to offline memory before disabling the region"),
>  	OPT_END(),
>  };
>  
> @@ -789,13 +792,62 @@ static int destroy_region(struct cxl_region *region)
>  	return cxl_region_delete(region);
>  }
>  
> +static int disable_region(struct cxl_region *region)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct daxctl_region *dax_region;
> +	struct daxctl_memory *mem;
> +	struct daxctl_dev *dev;
> +	int failed = 0, rc;
> +
> +	dax_region = cxl_region_get_daxctl_region(region);
> +	if (!dax_region)
> +		goto out;
> +
> +	daxctl_dev_foreach(dax_region, dev) {
> +		mem = daxctl_dev_get_memory(dev);
> +		if (!mem)
> +			return -ENXIO;
> +
> +		/*
> +		 * If memory is still online and user wants to force it, attempt
> +		 * to offline it.
> +		 */
> +		if (daxctl_memory_is_online(mem)) {
> +			rc = daxctl_memory_offline(mem);
> +			if (rc < 0) {
> +				log_err(&rl, "%s: unable to offline %s: %s\n",
> +					devname,
> +					daxctl_dev_get_devname(dev),
> +					strerror(abs(rc)));
> +				if (!param.force)
> +					return rc;
> +
> +				failed++;
> +			}
> +		}
> +	}
> +
> +	if (failed) {
> +		log_err(&rl, "%s: Forcing region disable without successful offline.\n",
> +			devname);
> +		log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
> +			devname);
> +		log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
> +			devname);
> +	}
> +
> +out:
> +	return cxl_region_disable(region);
> +}
> +
>  static int do_region_xable(struct cxl_region *region, enum region_actions action)
>  {
>  	switch (action) {
>  	case ACTION_ENABLE:
>  		return cxl_region_enable(region);
>  	case ACTION_DISABLE:
> -		return cxl_region_disable(region);
> +		return disable_region(region);
>  	case ACTION_DESTROY:
>  		return destroy_region(region);
>  	default:
> 
> 
