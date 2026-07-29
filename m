Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6329437465
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 08:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785314470; cv=none; b=OLgOKL9zcCvK/+XaNFUUT0HOYv9GAxcvG14RTE5ajDWwanWkeAQmzK2CeS8/GzndGEtO0Bw5/z1IKqz41wyOyguPfa/Uh2quaQ9s12u30iEGVJYn3Qg02T3Rh4ahF+vopSNRxdj6MJvELkUwrt/0lohAEuZnujCWEe1/k7vI/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785314470; c=relaxed/simple;
	bh=AoaCHVUlogiTnFufxBVUpWVGN0xOur8l/4UX/MML0K8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0mXAojmLaAkHRoLu4+To9/51UyElXgrQSLVN30ZNSi/M6nZwzCjRRzes2lggHEojGXGA89Pm7U7ow+btLdtMBWtxcuJ6Dasy7QKFVHlbrqiOcXxiGaQjIzLJzF1aUM/yvnzDZwSnhklxrlFez0hmRAIN2TQRDCfGkwyeyVHip4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edF4Kv0v; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edF4Kv0v"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so9874905ad.1
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 01:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785314468; x=1785919268; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JYTx72Rn0uzNL9+eoqaoZGN5MRd0NWcXqTetb/qXnzw=;
        b=edF4Kv0vNkuRxwRwZKsiDTsh+OeeQynFs3kO4H/fSfEk8OIOLwP200JgT/rUAxboym
         uXpzmtBKqVWvKW2IHv0e6nNJ+bo1PZQEgzDN4z+hu0vVXT8/LY6OOiDbM2QeZ0pd5h71
         Qnx/GQqPZpwW9xmdw0PKASnMmGYJNcy1TVI9cYVTotwhYyyfiVU0oE3/609oAEprVucp
         QnphaW1g47fmIO2xznVlBMCo/6kOElenF39dOW9tV9sYj3Ww6fgqj3wLpFLDCopGbzmD
         VFORL4VNbUUSXVcCit3iOOg12oNajkyH8oqhtRER85dOy6DvgNg24XAnzrgjJvzAjN1k
         vU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314468; x=1785919268;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JYTx72Rn0uzNL9+eoqaoZGN5MRd0NWcXqTetb/qXnzw=;
        b=fsLC0D2cVfKD++Nrd+ClLgqpozrd3QAEnvQyUcgIhkAPT9YZlHKwJ1WXGxZ0ibBkV6
         jMTmIouwIby9Na1SsbwI4bo5yBckkG41ksBDiejMgRI+E9hfNltrZjy2rk8r8ewDk028
         +xg8AqLwQqH8u1nsMJU10TUt1507T6RrHoOq0VSm0PJ/VA1cabYz+Ngp1QQ7wChE7a7j
         th8heEzoVcRxLAa5rJTeG275hQ4Ckp6dHRjDFdAQfRFn2x+jRAsPtKkLrVOINrGIkGv4
         mqZUIWnZT2dgaCoI3PZFLrVl44+oCHBEv9KJnr4OGrAAJSzRZ9ktSm4e1xqP4RT1/gcZ
         0RpA==
X-Forwarded-Encrypted: i=1; AHgh+RqtGGCI84HUOQv8rvXR6idDbXR/W9Ny7GTwnAZNccbXrxQVNa4q4z1O0uEUHycqiydxc6SZmN8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5u20xEO0PlXKBIE3jFJPn50FP/9KMmPg/j12YbaVpFg+1WIfB
	u07zAewB49kpB5ts2Oab4zImYgtDweH1uDusYWplp7r/k7OSOUQqUZ9Z
X-Gm-Gg: AR+sD10IIlblfDr29/1wm2M4HPAshnH24zp3SgFBAyidZseby4VGt15RRQ5Q1T3WoBD
	Fj4giuNOwj7h5dmLADd/19ankU9tgz6/K/FxGindCFp8LzAYa9y6fE2U04Q5pTCK0zS4nRkXUog
	bl6HcjzEE/TfDktZWn+ky8WUkihRQGJ1i2CpvWsM3BFgIxX944sfaw8ZOPHY8+TTEO1PzbdqDL5
	MbGM5JBiZD7I/11w3AGnPK9M5qC92gPdLdso6qEi4YSitrNVoopKGXYo9gctml+gF42wRF2PTXX
	oCH4uPopp3vqTBHhRI9O5MdEcug99I0lrtaB4pFWiqPI5lzKzLYXsFG8+6ihYZH5omcz9GZxEyC
	4jM4GLHqkcudbIi/S1zWckUtCwIsPOjHj3I3M1a1ckfwqG8i6tZNvPpEO1RztxFsyyEF7oujIkm
	qsKtisTk6th6gfiXX6Jbg2BkEMcxjxUKjNE76n3aEL5XGp4jgEshDd1u2iRFJnt12snGjbqY1Qs
	jz6+RekR2BBhhNcKZM2iK5TPbCTmBn3nixRtxH0zN6Y
X-Received: by 2002:a17:903:1b24:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d015c92ce3mr65710025ad.7.1785314468117;
        Wed, 29 Jul 2026 01:41:08 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a465f7sm7962085ad.24.2026.07.29.01.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:41:07 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 29 Jul 2026 01:41:06 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v11 17/31] cxl/mem: Enforce tag-group semantics
Message-ID: <amm8ovfX2d9p3ijj@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-18-anisa.su@samsung.com>
 <20260625182418.E9F8E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625182418.E9F8E1F00A3A@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:24:18PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Untagged extents spanning different DC partitions and DAX regions are incorrectly coalesced and assigned to the same region.

Fixed in patch 12. extract_tag_group() originally put all untagged
extents into the same tag_group. This has been fixed to put each
untagged extent into its own tag_group so they are not coalesced and
assigned to the same region.

> - [High] Fully duplicate extent groups are incorrectly rejected and omitted from the device response.

Duplicate false positive from patch 14 and 16.
> --
> 
> commit c2cf18ae81b1c32953f39b06aeaa9e153f4ac609
> Author: Anisa Su <anisa.su887@gmail.com>
> 
> cxl/mem: Enforce tag-group semantics
> 
> This commit completes tag-group validation. It adds sequence integrity
> checks to verify that sharable partitions have dense shared_extn_seq
> values, and verifies that tagged allocations do not span DC partitions.
> 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 14ba263044f08..7967b0db2c512 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> 
> [ ... ]
> 
> > +static int cxl_check_group_partition(struct cxl_memdev_state *mds,
> > +				     const uuid_t *tag,
> > +				     const struct list_head *group)
> > +{
> > +	struct device *dev = mds->cxlds.dev;
> > +	const struct cxl_dpa_partition *first_part = NULL;
> > +	u64 first_dpa = 0;
> > +	struct cxl_extent_list_node *pos;
> > +
> > +	if (uuid_is_null(tag) || list_empty(group))
> > +		return 0;
> 
> [Severity: High]
> This is a pre-existing issue, but does this explicit bypass for untagged
> extents allow them to span different DC partitions?
> 
> If a device sends multiple untagged DC add capacity events spanning
> different partitions, cxl_add_pending() appears to extract them all into a
> single group.
> 
> Since this check returns 0 for null UUIDs, cxl_realize_group() processes them
> together. Would cxlr_add_extent() then register them all under the DAX region
> of the first extent, effectively merging extents from different partitions into
> the same region's resource tree?
> 
> [ ... ]
> 
> >  static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
> > -			     struct list_head *group, bool existing)
> > +			     struct list_head *group, bool shareable,
> > +			     bool existing)
> >  {
> >  	struct device *dev = mds->cxlds.dev;
> >  	struct cxl_extent_list_node *pos, *tmp;
> >  	struct cxl_dc_tag_group *tag_group;
> >  	int group_cnt = 0;
> > +	u16 seq_num;
> >  	int rc;
> >  
> > +	seq_num = -1;
> >  	list_for_each_entry_safe(pos, tmp, group, list) {
> > -		/*
> > -		 * Pass the device-stamped 0-based shared_extn_seq through
> > -		 * unchanged as the dax-side @seq_num (0..n-1).
> > -		 */
> > -		u16 seq = le16_to_cpu(pos->extent->shared_extn_seq);
> > +		if (shareable)
> > +			seq_num = le16_to_cpu(pos->extent->shared_extn_seq);
> > +		else
> > +			seq_num++;
> >  
> > -		if (cxl_add_extent(mds, pos->extent, seq) < 0) {
> > +		if (cxl_add_extent(mds, pos->extent, seq_num) < 0) {
> 
> [Severity: High]
> This is a pre-existing issue, but what happens if a device resends a tag group
> where all extents have already been accepted?
> 
> If cxl_add_extent() detects a duplicate, it returns 0 without calling
> cxlr_add_extent(). If this happens for every extent in the group,
> mds->add_ctx.group is never allocated and remains NULL.
> 
> Does this cause the subsequent if (!tag_group) check in this function to drop
> the group and return -ENXIO instead of returning group_cnt to acknowledge
> the extents back to the device?
> 
> >  			dev_dbg(dev,
> >  				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
> >  				tag,
> > @@ -1412,15 +1532,22 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=17
