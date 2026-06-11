Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E6335F60B
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163318; cv=none; b=PUQMA/PT/I60nqDACrc2SYfqrdReoWAeaF9KCMqyGDscN7Mtw+CZNcoHOx8CNg+S4RVuq0Hh9b3+3rTWb/TEqPGRbygJ1k6NHN38U4mjTaXB8DyG6YK4TG8egoaEDKGgezBpzkD4E29iZbHOLnIL3cwd4Nhmnu5Kj3zpSg6ioyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163318; c=relaxed/simple;
	bh=ILpNiLCWDwhEg+xrOtsVZTMCa8TTJKYnqIb1fsBn/to=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i69LJXNfUYFxA18vXD6WSqztfwkQmFCqzZoXN27SjC1MbQ8Ux3OUWx+4IrP4bhN6aplyPy+qkFglMJ5dulQnhQPaqEJxLriSN2uz2+ZbyOtlSz4yO7yJLJvbGYgKR/amORhk2He5bv4xITEUomiLLgAyaNGtA8cuQkeTXio1dIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gm/8TH8u; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gm/8TH8u"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3075ce9c05aso2874190eec.1
        for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 00:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781163315; x=1781768115; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o532ZBa92Bn1kV6y/svVQfZGV2JIbpTmE8EZMxhPVcU=;
        b=gm/8TH8uEGZWuTEO+KA6mU25xGYipAf0S1ctJY1ItYcaULhjOMKRoMs/eo6T0LCMeG
         9vluwlu2L2BypErNxADd+uGKHzRvLNeW0k7rmGYW2U0Ntt35CAe3cIxWlGJjD+8/ybTL
         dpkwQ8OyNT86zFg2u6pxSoCL7J1O1e3acIdX92drep67atupNmTsWuXRU+OecKwthy1K
         SdDDV8Q8aVHmubMbVtYxfhY6wGoyzarGnh3KUImIlS4prdJoZ2TIi8vdksKLksFND2Wo
         6NyZbmljiV6tApn52k16aq2/Nh+ZQGL17jtipJAHBrDyXYOufdOAEIUtDbCiv+VxjnK6
         meHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781163315; x=1781768115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o532ZBa92Bn1kV6y/svVQfZGV2JIbpTmE8EZMxhPVcU=;
        b=BbGcm7R9Fm5CGvRMGSCWI34PLq/Nl5doU2P/4AtI9L7BiRcOXRk+KVU9uK65UiYiRW
         53utHFLr6Oimyn5KCJVK+64eFXfsH47lPtXmjypxiDgspxWU6JdgyBtizU7cWMUL8Ah0
         HPDq9Bakc9vsf72m/oo0Ivu8JRQ/R/mw5CkUbMIQHzeBpZAZZ3cd7Fc8+OEVxUoSPAU+
         mHtTm8lEYC5WVRnpdVxOQmihtrTiFzIrzHN9X3uAF+zFIKoecZlUGUQ2ib6bF+FaA5Bg
         H1YVuhs07TPabyEjFvQ1LA7jnViSkOZlKbFZPiJZEmAmts4mUcqUGqd4xfBZgW/nYZNA
         cX/g==
X-Forwarded-Encrypted: i=1; AFNElJ8/LT0RGUkjptXRN+B/WOETvCfCJH/ka3dY/P9Axi25l8ZHHOJGB/yc6IWmZ3QEFbsDgJNOXP8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyErtssRo0vC0VGEjN0AmiIpDX0GiLk5n+Ux9H/csV6c49JlQcA
	Wg3+g8uVZBUxpU/hVFygZhZQ28CUYVIv3VnMl6Jmrj7VUH326fonGrU7
X-Gm-Gg: Acq92OGQ2Kmju84ALvjjJVlTzSL0NaLFVM05CQwhnMgPaJB7zi/MIXc5qLmjrWtulWu
	8Xd7CyF6YrVRFBn8yZ86hZ/1R2KZSUee9H2oItzstZcGx50W5Yc/bp6tOBXKTzH2/v67ygAhwCi
	eKx3l9BYfvVfUbu8DyUszDg9BNq/Uo04eZYYEQ4szeXAf0C7g6Hs3oPTDqos7yyRmGxls54hkqw
	ucR/SJLmZqdPXcqPkTkXU2YEQA2w3ivB6UHwftPkiMA3GVwCG9hG038Vf0BjYb8qVQ4RTSDA4TT
	HquRq2Nd2hmQU3oTKBDZJSAUvxR8n09gfLizFo4CYLSCm/GtADZ3/i9gZCu3uZYiHr0v2oGeKS5
	YAW0aZ+Z3rnYpiIRLD+2ZtLdCkhPQCzMdpubw139KuVJavvAUc5+mabN6GO6wWuMW9LyaYj6RFh
	KV2umY1B8kRbojZcYzzwMWUtOEFGb1atoMAy6YQ4HfW5GM8E1jpDfQi4ctn/i0KQ33+aNCa6YNv
	tmM8GTA00nr1hGNxA==
X-Received: by 2002:a05:7300:4307:b0:2e6:e504:5431 with SMTP id 5a478bee46e88-30804a0f00dmr1450108eec.22.1781163312992;
        Thu, 11 Jun 2026 00:35:12 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30806ebb105sm989695eec.23.2026.06.11.00.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 00:35:12 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 11 Jun 2026 00:35:11 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 16/31] cxl/extent: Validate DC extent partition
Message-ID: <aiplL-1v0Puf2xut@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <def526ee51b647e9256c7e777c6b7bd5cd647f89.1779528761.git.anisa.su@samsung.com>
 <dbcfcbe8-5a4a-4b5d-b1f1-188e33eb2a4b@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbcfcbe8-5a4a-4b5d-b1f1-188e33eb2a4b@intel.com>

On Thu, May 28, 2026 at 02:34:49PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > Extend cxl_validate_extent() — the per-extent check of the add pipeline
> > to check partition membership.
> > 
> > Resolves an extent's DPA to its containing DC partition. Then based on
> > if the partition is shareable:
> > 
> >   - Shareable: tag must be non-null and shared_extn_seq must be non-zero
> >     — multiple hosts reading the same allocation rely on the device-
> >     stamped 1..n sequence to assemble extents in agreed order.
> >   - Non-sharable: shared_extn_seq must be zero — sequencing is
> >     meaningless when only one host consumes the allocation; tag is
> >     optional (null UUID permitted).
> > 
> > Any cross-mix is a device firmware bug; reject the extent.
> > 
> > Based on patches by John Groves.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: John Groves <John@Groves.net>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: split out as a separate validation step]
> > ---
> >  drivers/cxl/core/core.h   |  4 ++
> >  drivers/cxl/core/extent.c | 78 +++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 79 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > index 1bae80dbf991..30b6b05b155b 100644
> > --- a/drivers/cxl/core/core.h
> > +++ b/drivers/cxl/core/core.h
> > @@ -179,6 +179,10 @@ int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c);
> >  int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
> >  					struct access_coordinate *c);
> >  void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
> > +const struct cxl_dpa_partition *
> > +cxl_extent_dc_partition(struct cxl_memdev_state *mds,
> > +			struct cxl_extent *extent,
> > +			struct range *ext_range);
> >  
> >  static inline struct device *port_to_host(struct cxl_port *port)
> >  {
> > diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> > index 94128d06f4ed..b01507022cff 100644
> > --- a/drivers/cxl/core/extent.c
> > +++ b/drivers/cxl/core/extent.c
> > @@ -63,11 +63,55 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
> >  	return no_free_ptr(group);
> >  }
> >  
> > +/*
> > + * Find the DC (Dynamic Capacity) partition that fully contains @ext_range,
> > + * or NULL if the extent falls outside every DC partition on this memdev.
> > + * The returned pointer is owned by mds->cxlds.part[] and lives for the
> > + * lifetime of the memdev.
> > + */
> > +const struct cxl_dpa_partition *
> > +cxl_extent_dc_partition(struct cxl_memdev_state *mds,
> > +			struct cxl_extent *extent,
> > +			struct range *ext_range)
> 
> This can be static, given it's only called in extent.c
> 
Fixed. Later called in mbox.c so declared non-static in that commit.

> > +{
> > +	struct cxl_dev_state *cxlds = &mds->cxlds;
> > +	struct device *dev = mds->cxlds.dev;
> > +
> > +	for (int i = 0; i < cxlds->nr_partitions; i++) {
> > +		struct cxl_dpa_partition *part = &cxlds->part[i];
> > +		struct range partition_range = {
> > +			.start = part->res.start,
> > +			.end = part->res.end,
> > +		};
> > +
> > +		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_A)
> > +			continue;
> > +
> > +		if (range_contains(&partition_range, ext_range)) {
> > +			dev_dbg(dev, "DC extent DPA %pra (DCR:%pra)(%pU)\n",
> > +				ext_range, &partition_range, extent->uuid);
> > +			return part;
> > +		}
> > +	}
> > +
> > +	dev_err_ratelimited(dev,
> > +			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
> > +			    ext_range, extent->uuid);
> > +	return NULL;
> > +}
> > +
> >  /*
> >   * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
> > - * to its region/endpoint decoder and ext_range, and verify the range
> > - * fits in the resolved endpoint decoder's DPA resource.  Further
> > - * per-extent invariants layer into this function in subsequent commits.
> > + * to its region/endpoint decoder and ext_range, and enforce every
> > + * per-extent invariant the device must satisfy:
> > + *
> > + *   - DPA falls inside a Dynamic Capacity partition (cxl_extent_dc_partition).
> > + *   - CDAT-sharability rules:
> > + *       sharable:     tag must be non-null AND shared_extn_seq != 0
> > + *       non-sharable: shared_extn_seq must be 0  (tag is optional)
> > + *     Any cross-mixing is a device firmware bug.
> > + *   - DPA resolves to an endpoint decoder attached to a region.
> > + *   - The extent's range is fully contained in that ED's DPA resource.
> >   *
> >   * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
> >   * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
> > @@ -81,6 +125,10 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
> >  {
> >  	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> >  	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> > +	struct device *dev = mds->cxlds.dev;
> > +	uuid_t *uuid = (uuid_t *)extent->uuid;
> 
> Consider using import_uuid() instead of direct cast.
> 
Fixed
> > +	u16 seq = le16_to_cpu(extent->shared_extn_seq);
> > +	const struct cxl_dpa_partition *part;
> >  	struct cxl_endpoint_decoder *cxled;
> >  	struct cxl_region *cxlr;
> >  	struct range ext_range = (struct range) {
> > @@ -89,6 +137,30 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
> >  	};
> >  	struct range ed_range;
> >  
> > +	part = cxl_extent_dc_partition(mds, extent, &ext_range);
> > +	if (!part)
> > +		return -ENXIO;
> > +
> > +	if (part->perf.shareable) {
> > +		if (uuid_is_null(uuid)) {
> > +			dev_err_ratelimited(dev,
> > +				"DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
> > +				&ext_range);
> > +			return -ENXIO;
> > +		}
> > +		if (seq == 0) {
> 
> I don't think this complies with the spec language. In r4.0 Table 8-230: "For extents describing shareable regions this field shall be within the range of 0 to n-1 where n is the number of extents, with each value appearing only once." So seq == 0 is an acceptable value.
> 
> Also, looking at cxl_add_pending() @ line ~1396, does shared seq number '0' holds special meanings? Maybe that needs to change? Also suggest adding comments to point out what's happening there if '0' is special. 
> 

Fixed to enforce 0...n-1 for shared seq num instead of 1...n.
0 no longer used as sentinel val for unshared extents. 

'Enforce tag-group semantics', which checks seq num have no
duplicates/gaps, is also fixed

> DJ
> 
Thanks,
Anisa
> 
> > +			dev_err_ratelimited(dev,
> > +				"DC extent DPA %pra (%pU): sharable-partition extent missing shared_extn_seq (firmware bug)\n",
> > +				&ext_range, uuid);
> > +			return -ENXIO;
> > +		}
> > +	} else if (seq != 0) {
> > +		dev_err_ratelimited(dev,
> > +			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
> > +			&ext_range, uuid, seq);
> > +		return -ENXIO;
> > +	}
> > +
> >  	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> >  	if (!cxlr)
> >  		return -ENXIO;
> 
