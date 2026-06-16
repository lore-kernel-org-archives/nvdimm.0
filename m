Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846F842188F
	for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 10:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606882; cv=none; b=rfVScbnXDQKLdum6S8pwx6TYi+tuP3Lkt7sX0UkuUSbePvYDhXiv/VBAZCPbhyZj18kFUTNgvv3Hc3ES7zc+svLSQ7bA19rrxgt/72fHeRKyVOyvpZWXH5k5yIJMxIffSJ75/4UlSdkZSpfhoP0TxJ6dhKcq6rlT0m9lIHtaFlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606882; c=relaxed/simple;
	bh=PWLfHbMooANN0Npma3i7Ip4N1ascBmX7a+M4+wkjSus=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAzIl366qVKYv8Ve34o1xFCHR5dlLtk2vEUHY6sjOnnmw4OksgOyxa596p6ikNluzf5nEA8Q2EGk5pMmdt2kiUwJ6Qqr+zpCzFPnLdDX7YsqhLXpVv2G1VpU+YzQj9cSHYijnNeb+hYN5pSe6m1Rrnhtj046GxteVcLiOC7MrnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfMkAMfL; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfMkAMfL"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30b9e755555so2410630eec.1
        for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 03:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781606880; x=1782211680; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VtQJ/mGJtnqYeAZw4yNlFP0CxKDcQCnLGTzvzPavxYw=;
        b=dfMkAMfLKLE0ZZx7z83oGAlFlNG5rbc7vng3yCfu69QywpjspEB6zYw8JkWpsKQUu4
         0oENUemUxI6cSzJmwmRnGiKTh3TuwB4YexpYLkd8RFyEc0Qf3AK7isKn4SQuoMKbwAi8
         lqU/ugdUDnRcMNHQTADLA8tfaAlwMOnrNufFF7Op122lcN4nAcuBLY/YPZKmo8YkolbU
         nJVrZHLGLz4+TaFzycXbvjb5rdpCF57wEiOtL+7aQ4D2YHlNOmvUvkMLm6X2fli6QZoo
         4SPTgxZhHedmT5Zvn7DNy8ouukcTs46KyLVv579puusLTEuJmjOFwujebwJD6bE3e58j
         GH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781606880; x=1782211680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VtQJ/mGJtnqYeAZw4yNlFP0CxKDcQCnLGTzvzPavxYw=;
        b=tSQa7+lepvMlN5+Yd0tXkg9REuwRZhivcqdcpP5wzqvwuLEHgk0C0lFlSD99csuep8
         TYa1GluVdTm/aqoHuVWippa7x1EuPqgZF8ArwoP7EaaXHT9nzyVQSbmd8TkX0OAvqXUT
         79QrA0Fexso6LZ4Kwn3K9Rx5yYA1l6CE+kG4OByuEag25VoKbrfmXqj3Al4cAwROaNAz
         lavolAyePQILUWAkDUgXpzVq7AeiKKvm/8C5G+tPtxRjMnG8aPfWopmXd7hEmlHysuzJ
         LqsVVHELDvMyCnNWvbovT0IP/l8tDx8vurouDSVRZWtAyen28JMjphUy9TdTtstzz8rN
         iMwQ==
X-Forwarded-Encrypted: i=1; AFNElJ/5cc9RFOdc822TKF6RPrvx+Pe3k5OmfdHfhgDutuu+jdZYcdL8Bokh9BFMMyOXMeMHvIOe6iY=@lists.linux.dev
X-Gm-Message-State: AOJu0YysSD317UPBbdDnQnbyj7QZMPqLLHvMZcXx3BUMSP5uKWn2cHka
	ghF2dwWck3SDOFeAYloJ2y8M1CLk2ampv0OjinA/qE5RLmGYgEt2NtKB
X-Gm-Gg: Acq92OHfZGw5bUmugN4SJvyxy8pWN5rG5wkHm9f/pDZn6WBB0ER25j+NT4ZRUQHPrEI
	D4JZA2BOC4zgGtwdIg7LkZdSjYcQDW2SKq4EpUpUvUpNX6SOYX3nqbsRnHfuP/e7+cxFU2oTGjz
	Pq02CmxAxmFIqx27gGDtylfqO+8+E8t3P5FyXKmZp+oFBhbpk272BCxIS3NVF31N9MyK2Z9luyp
	pW6gqumaq2ZpxNTy42Tv/a4KcSUy4YbLRPywkDQcGDyl3pOt+mnUccm0HUIyQ0MGlD8AIg05PYR
	kYsbf5vZVpXxTRIQHwmI6lPq/ZIoakJALGoc4iUpfyxHuymgH4dLOHsLxlA2mDXBbJD1wGa60Un
	EAc4HK7xhE6DC/VMTSmOI1ogLkTLfZYXnKaybnma/eLmBjfkoIyqXMU3PW7mSbvH7yxfTPJIuNp
	KGYSO9iPZHXvgXP9EP5oC2cqmAPlalaajcfRBdV7hiHyHC4qwlV2/8feu7gd9E2S4zECfNJba83
	oaQUcc=
X-Received: by 2002:a05:7300:6423:b0:307:91f9:c1c1 with SMTP id 5a478bee46e88-309400767bbmr7976530eec.25.1781606879672;
        Tue, 16 Jun 2026 03:47:59 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e91f88bsm18846523eec.16.2026.06.16.03.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 03:47:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 16 Jun 2026 03:47:57 -0700
To: Richard Cheng <icheng@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Anisa Su <anisa.su887@gmail.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 5/7] cxl/region: Add extent output to region query
Message-ID: <ajEp3cuT4DQIaaOu@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-6-anisa.su@samsung.com>
 <ad25c4ad-b967-46c5-a983-a0c0ceb7d825@intel.com>
 <aijfsGSwTAD33KCN@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aijfsGSwTAD33KCN@MWDK4CY14F>

On Wed, Jun 10, 2026 at 11:55:12AM +0800, Richard Cheng wrote:
> On Mon, Jun 08, 2026 at 05:08:19PM +0800, Dave Jiang wrote:
> > 
> > 
> > On 5/23/26 2:50 AM, Anisa Su wrote:
> > > From: Ira Weiny <ira.weiny@intel.com>
> > > 
> > > DCD regions have 0 or more extents.  The ability to list those and their
> > > properties is useful to end users.
> > > 
> > > Add an option for extent output to region queries.  An example of this
> > > is:
> > > 
> > > 	$ ./build/cxl/cxl list -r 8 -Nu
> > > 	{
> > > 	  "region":"region8",
> > > 	  ...
> > > 	  "type":"dc",
> > > 	  ...
> > > 	  "extents":[
> > > 	    {
> > > 	      "offset":"0x10000000",
> > > 	      "length":"64.00 MiB (67.11 MB)",
> > > 	      "tag":"00000000-0000-0000-0000-000000000000"
> > 
> > I think the code emits "uuid". Update commit log.
> > > 	    },
> > > 	    {
> > > 	      "offset":"0x8000000",
> > > 	      "length":"64.00 MiB (67.11 MB)",
> > > 	      "tag":"00000000-0000-0000-0000-000000000000"
> > 
> > same here
> > 
> > DJ
> > 
> > > 	    }
> > > 	  ]
> > > 	}
> > > 
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > 
> > > ---
> > > Changes:
> > > [iweiny: s/tag/uuid/]
> > > ---
> > >  Documentation/cxl/cxl-list.txt | 29 +++++++++++++++++++++
> > >  cxl/filter.h                   |  3 +++
> > >  cxl/json.c                     | 47 ++++++++++++++++++++++++++++++++++
> > >  cxl/json.h                     |  3 +++
> > >  cxl/list.c                     |  3 +++
> > >  util/json.h                    |  1 +
> > >  6 files changed, 86 insertions(+)
> > > 
> > > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > > index 193860b..7512687 100644
> > > --- a/Documentation/cxl/cxl-list.txt
> > > +++ b/Documentation/cxl/cxl-list.txt
> > > @@ -426,6 +426,35 @@ OPTIONS
> > >  }
> > >  ----
> > >  
> > > +-N::
> > > +--extents::
> > > +	Append Dynamic Capacity extent information.
> > > +----
> > > +13:34:28 > ./build/cxl/cxl list -r 8 -Nu
> > > +{
> > > +  "region":"region8",
> > > +  "resource":"0xf030000000",
> > > +  "size":"512.00 MiB (536.87 MB)",
> > > +  "type":"dc",
> > > +  "interleave_ways":1,
> > > +  "interleave_granularity":256,
> > > +  "decode_state":"commit",
> > > +  "extents":[
> > > +    {
> > > +      "offset":"0x10000000",
> > > +      "length":"64.00 MiB (67.11 MB)",
> > > +      "uuid":"00000000-0000-0000-0000-000000000000"
> > > +    },
> > > +    {
> > > +      "offset":"0x8000000",
> > > +      "length":"64.00 MiB (67.11 MB)",
> > > +      "uuid":"00000000-0000-0000-0000-000000000000"
> > > +    }
> > > +  ]
> > > +}
> > > +----
> > > +
> > > +
> > >  -r::
> > >  --region::
> > >  	Specify CXL region device name(s), or device id(s), to filter the listing.
> > > diff --git a/cxl/filter.h b/cxl/filter.h
> > > index 70463c4..30e7fe2 100644
> > > --- a/cxl/filter.h
> > > +++ b/cxl/filter.h
> > > @@ -31,6 +31,7 @@ struct cxl_filter_params {
> > >  	bool alert_config;
> > >  	bool dax;
> > >  	bool media_errors;
> > > +	bool extents;
> > >  	int verbose;
> > >  	struct log_ctx ctx;
> > >  };
> > > @@ -93,6 +94,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
> > >  		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
> > >  	if (param->media_errors)
> > >  		flags |= UTIL_JSON_MEDIA_ERRORS;
> > > +	if (param->extents)
> > > +		flags |= UTIL_JSON_EXTENTS;
> > >  	return flags;
> > >  }
> > >  
> > > diff --git a/cxl/json.c b/cxl/json.c
> > > index e94c809..7922b32 100644
> > > --- a/cxl/json.c
> > > +++ b/cxl/json.c
> > > @@ -1022,6 +1022,50 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
> > >  	json_object_object_add(jregion, "mappings", jmappings);
> > >  }
> > >  
> > > +void util_cxl_extents_append_json(struct json_object *jregion,
> > > +				  struct cxl_region *region,
> > > +				  unsigned long flags)
> > > +{
> > > +	struct json_object *jextents;
> > > +	struct cxl_region_extent *extent;
> > > +
> > > +	jextents = json_object_new_array();
> > > +	if (!jextents)
> > > +		return;
> > > +
> > > +	cxl_extent_foreach(region, extent) {
> 
> Every region rendered with the flag, including non-DC RAM/PMEM regions.
> They all get a spurious "extents": [].
> I would suggest guarding on cxl_extent_get_first(region) != NULL before
> adding the key.
> 
> What do you think?
> 
Good point, thanks for catching that! Now checks
cxl_extent_get_first(region) != NULL at top of function

> Best regards,
> Richard Cheng.
> 
Thanks,
Anisa

> > > +		struct json_object *jextent, *jobj;
> > > +		unsigned long long val;
> > > +		char uuid_str[40];
> > > +		uuid_t uuid;
> > > +
> > > +		jextent = json_object_new_object();
> > > +		if (!jextent)
> > > +			continue;
> > > +
> > > +		val = cxl_extent_get_offset(extent);
> > > +		jobj = util_json_object_hex(val, flags);
> > > +		if (jobj)
> > > +			json_object_object_add(jextent, "offset", jobj);
> > > +
> > > +		val = cxl_extent_get_length(extent);
> > > +		jobj = util_json_object_size(val, flags);
> > > +		if (jobj)
> > > +			json_object_object_add(jextent, "length", jobj);
> > > +
> > > +		cxl_extent_get_uuid(extent, uuid);
> > > +		uuid_unparse(uuid, uuid_str);
> > > +		jobj = json_object_new_string(uuid_str);
> > > +		if (jobj)
> > > +			json_object_object_add(jextent, "uuid", jobj);
> > > +
> > > +		json_object_array_add(jextents, jextent);
> > > +		json_object_set_userdata(jextent, extent, NULL);
> > > +	}
> > > +
> > > +	json_object_object_add(jregion, "extents", jextents);
> > > +}
> > > +
> > >  struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> > >  					     unsigned long flags)
> > >  {
> > > @@ -1126,6 +1170,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> > >  		}
> > >  	}
> > >  
> > > +	if (flags & UTIL_JSON_EXTENTS)
> > > +		util_cxl_extents_append_json(jregion, region, flags);
> > > +
> > >  	if (cxl_region_qos_class_mismatch(region)) {
> > >  		jobj = json_object_new_boolean(true);
> > >  		if (jobj)
> > > diff --git a/cxl/json.h b/cxl/json.h
> > > index eb7572b..f9c07ab 100644
> > > --- a/cxl/json.h
> > > +++ b/cxl/json.h
> > > @@ -20,6 +20,9 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
> > >  void util_cxl_mappings_append_json(struct json_object *jregion,
> > >  				  struct cxl_region *region,
> > >  				  unsigned long flags);
> > > +void util_cxl_extents_append_json(struct json_object *jregion,
> > > +				  struct cxl_region *region,
> > > +				  unsigned long flags);
> > >  void util_cxl_targets_append_json(struct json_object *jdecoder,
> > >  				  struct cxl_decoder *decoder,
> > >  				  const char *ident, const char *serial,
> > > diff --git a/cxl/list.c b/cxl/list.c
> > > index 0b25d78..47d1351 100644
> > > --- a/cxl/list.c
> > > +++ b/cxl/list.c
> > > @@ -59,6 +59,8 @@ static const struct option options[] = {
> > >  		    "include alert configuration information"),
> > >  	OPT_BOOLEAN('L', "media-errors", &param.media_errors,
> > >  		    "include media-error information "),
> > > +	OPT_BOOLEAN('N', "extents", &param.extents,
> > > +		    "include extent information (Dynamic Capacity regions only)"),
> > >  	OPT_INCR('v', "verbose", &param.verbose, "increase output detail"),
> > >  #ifdef ENABLE_DEBUG
> > >  	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
> > > @@ -135,6 +137,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> > >  		param.decoders = true;
> > >  		param.targets = true;
> > >  		param.regions = true;
> > > +		param.extents = true;
> > >  		/*fallthrough*/
> > >  	case 0:
> > >  		break;
> > > diff --git a/util/json.h b/util/json.h
> > > index 560f845..79ae324 100644
> > > --- a/util/json.h
> > > +++ b/util/json.h
> > > @@ -21,6 +21,7 @@ enum util_json_flags {
> > >  	UTIL_JSON_TARGETS	= (1 << 11),
> > >  	UTIL_JSON_PARTITION	= (1 << 12),
> > >  	UTIL_JSON_ALERT_CONFIG	= (1 << 13),
> > > +	UTIL_JSON_EXTENTS	= (1 << 14),
> > >  };
> > >  
> > >  void util_display_json_array(FILE *f_out, struct json_object *jarray,
> > 
> > 
