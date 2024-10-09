Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916C91DEFF0
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728495296; cv=none; b=EvYXOVLA5xdEgTHkcUgW3AWBsGS8x6b+4teHGrewficKJ8JKVB6bLMUNYog3Oz+ySrIernORmMVzsezlG+Pr+uNpZkH6+ue7I0Br8sUsBdIOlNTVJDbMMCrDWScRCd0ocMnc37ctMzwV+ScCN1ZtfzRnDis2cTOTXAXzxlPQY9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728495296; c=relaxed/simple;
	bh=oeLkdWrCv5LkmpnXbhNmxwvlNNYmSlIvBrYlfACHjGY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a585qglNemJF5UcQJresl1PHI706lPwt8Or/vPa0jTXS+lDz1wItaUjm7nwcT8F3Yg35tGc+cHFSL2EoBYu0dEE6kYlSa+cbhwcgQnZQUnKKrtlyUbWehe0kRUyymeObBte+gK0+qerb/en3t7dzXyODYdfKZWGM0e2hM4OOjUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=My4cNqvM; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="My4cNqvM"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6dbb24ee2ebso1169117b3.1
        for <nvdimm@lists.linux.dev>; Wed, 09 Oct 2024 10:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728495293; x=1729100093; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2woNv3OfgPw1OV3xE2cmaefjQ/xqlt3SqQjOoMCmrEc=;
        b=My4cNqvMhu8nSfgRZeYvrsnKnWpjNB4Z7mrJgy/zFsHVfMTnHPslfHhg7+gWYEPARB
         cuhH7LyTwT7M5IHa7QMn4LJgbrvhksxWfBt48vrzIu/yTbmO1w/4TrC+MXfjCbYEkgjR
         /8Bk7Lsm7ygpxALMkJiAmnKopodAjEReGkqyznKahE+NdwMXnkIxbpQB1Np1xTVEf6Yc
         y7TgpzKhs50y8rLieUcHGAmWINhT7JSlxyE/DgZ4doRkLFWmxurcw4Is7YxAB7Fc4xbz
         MCInmEf2V9cpXjrL+ero6ZnKjJqTI+E4rdBTqqc6pYoj05Hm9i4q0lPhYMiDbOZ45SKL
         onPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728495293; x=1729100093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2woNv3OfgPw1OV3xE2cmaefjQ/xqlt3SqQjOoMCmrEc=;
        b=QyDBX1Jt4U12ULtOAiIvAEXCF72NJFZA6D96G6n3d4GrLtVu0djCIg22V9DO0gD8qN
         yU3Zy77j4rngmf0dhgUSzrLX2fNhBeyTpDIOiXOJq3RvBlfLgI8LV+C+etLiIRb+c1gw
         NU10GFCZ4hLVP3fSOFFrzDOXp8QiSRGGCjqdGFOVGb48QuOCRuY6mUzI4uGs6zEseP2f
         scO3L804dXsc3JvT1QTk5bhfxUkATT1HcnQidpmK1GEv6HganWzmoZwktNbGDzmPjPYc
         HJDKw1ids6qawvq0YiKc2qHUCtDWWFEP6WVEayq4nIjim/SBaNpCmTFfDO4OsHxtHZ4S
         Zkuw==
X-Forwarded-Encrypted: i=1; AJvYcCV5USZnr0eIUaTghiWeYbWWjbuVvovPj8VhEYHGRug1xaSWpQyc3q01WwzAn19uVG9PEWPxWX0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvW1I/iGh77tmuz4F/Ra7WV//5OF1IgEDhuIB9ImViYTbIJa5S
	QSABfNHDnyOUeXw2YiM/k1oU9nMCm85WnQH91tnX+gA6pbl7j2G4Twc7GQ==
X-Google-Smtp-Source: AGHT+IEq3MufEOXftigWGdRndlAx7RSkyaK4tsjkc/CE/MlAYMgrL2JdUZFXoPxMKIZAE4l7TzPynA==
X-Received: by 2002:a05:690c:660b:b0:6e2:b263:1045 with SMTP id 00721157ae682-6e322132ef2mr37828337b3.6.1728495293438;
        Wed, 09 Oct 2024 10:34:53 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e2d9388279sm19362137b3.65.2024.10.09.10.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 10:34:53 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 9 Oct 2024 10:34:50 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 03/28] cxl/cdat: Use %pra for dpa range outputs
Message-ID: <Zwa-urzkRBCtV9S2@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-3-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-3-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:09PM -0500, Ira Weiny wrote:
> Now that there is a printk specifier for struct range use it in
> debug output of CDAT data.
> 
> To: Petr Mladek <pmladek@suse.com>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org (open list)
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

>  drivers/cxl/core/cdat.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> index ef1621d40f05..438869df241a 100644
> --- a/drivers/cxl/core/cdat.c
> +++ b/drivers/cxl/core/cdat.c
> @@ -247,8 +247,8 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
>  	dpa_perf->dpa_range = dent->dpa_range;
>  	dpa_perf->qos_class = dent->qos_class;
>  	dev_dbg(dev,
> -		"DSMAS: dpa: %#llx qos: %d read_bw: %d write_bw %d read_lat: %d write_lat: %d\n",
> -		dent->dpa_range.start, dpa_perf->qos_class,
> +		"DSMAS: dpa: %pra qos: %d read_bw: %d write_bw %d read_lat: %d write_lat: %d\n",
> +		&dent->dpa_range, dpa_perf->qos_class,
>  		dent->coord[ACCESS_COORDINATE_CPU].read_bandwidth,
>  		dent->coord[ACCESS_COORDINATE_CPU].write_bandwidth,
>  		dent->coord[ACCESS_COORDINATE_CPU].read_latency,
> @@ -279,8 +279,8 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
>  			 range_contains(&pmem_range, &dent->dpa_range))
>  			update_perf_entry(dev, dent, &mds->pmem_perf);
>  		else
> -			dev_dbg(dev, "no partition for dsmas dpa: %#llx\n",
> -				dent->dpa_range.start);
> +			dev_dbg(dev, "no partition for dsmas dpa: %pra\n",
> +				&dent->dpa_range);
>  	}
>  }
>  
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
