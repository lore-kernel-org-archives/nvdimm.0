Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2353815FB
	for <nvdimm@lists.linux.dev>; Thu, 16 Jul 2026 04:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784174899; cv=none; b=C3874iiSYREqZBvbViM0A6hlU/dvjAypU0QLyj7/3otNwpsq1thHuw+bPmDMDFfWN0ideGfiV1cRr5ZesGNvrVehTkmbpD741TjyiJYyIbdDH7V9IMO0ceQA6J95OroW+tUclu3epmEjY1IGeDsh0QDb7rOdP2XicKc5hRHDtYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784174899; c=relaxed/simple;
	bh=R9xKCPWUV4jE/Y73zK46+N8T9xEUacgdX7igmryS87o=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubPxoLsI3QwarbmpJEIUPBZ0kU4URQhXDtzgOpQkzA0ZBex9/MKsRaz+Ff18fr1Z8s+tt+MRXQtJaCzL+RFdVEQW/UPKFKFHCgadG7ORs8frcjCBLY6BYrc4njW/xkXTiRAavCSbr7BQYmOTpVku3F+jDaPHbYEEM3iaFCy41rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nil2pjn3; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nil2pjn3"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so4793177a91.0
        for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 21:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784174897; x=1784779697; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f9V0pZbsyulMpnH6R6OfoQOZz9JXss18PvQ1c2eqK3s=;
        b=Nil2pjn3z0RoRpltdOij+SbCwr2dfDB5XS3kGVH3kOS2T5F1cD9lT2OZ8Vf8Nk9W//
         7xEoqR+HKAAk+CKTb4zuyhZxNK5F+syh3V4HgiI7m2eg/4ibdca94SlCYcWnubzGR87f
         Vvw+Pr0l/F2Rj14W1Ar5c2f6KLHM/T2F6K4c71jyo24fDvodj9xImMQKgmftum5cmsyz
         6aQ6+cu+vKuuycScyyoUcxMm8kUBf9IttrLNewGj/gK+bl4beAF0v0sBz8l0yppldg3/
         xX2Sd90rz/CcqVF96ZagERy5mNxeYXOf8yJxgYi21MJfYKmhVenan5S1BS+ANlseDx5h
         Pt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784174897; x=1784779697;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f9V0pZbsyulMpnH6R6OfoQOZz9JXss18PvQ1c2eqK3s=;
        b=C+EQQQ5HkgiXRXlH5otu4bpN6aQhZzQE9IoBXJF5soQg1EihrjcXG6PQ50x/mR2zNu
         XuQP1bsA1r9N222aNYHzYpVeBPMtI9Zznf5AZA26Oqkf57hBiBjWgVGvgsSxWOhBjNbU
         QO2hQKilY8Zquz2kBnhDWu74c41n9U+ruU2ITrG9E04S7g1KtwIL7Vub0Tbp9BMuf43e
         MAfGozyG4GRTzpXCCB+dTKUjEQbXHB9wKhl2hTmBD2kT2TU9JoiTUOX3DcqcvAMbF4v1
         ZoU5kTT8EV9uT86krpYrqdFm4Dhe7TPejQsPuUaYyQPCSPmgyUtxVzYh5odYULzD3Z29
         mSjw==
X-Forwarded-Encrypted: i=1; AHgh+RoSJphboi/xxPSe88mYeE4TLFIwhgstLPEJfnpgsa3y6LvYmEaBu9qgJE8SJGcFyatouj+Hrng=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3kJrXZQwpIXbtjTrIR5BnUR3Qj0OlhKvSwjMpEbpLO6/5aaiu
	mSpSYJqnoz5taLJ5rG/4ETjYwWSFWEplhm2CY+QkJj2QZ+y+svYEM7i+
X-Gm-Gg: AfdE7clNDbJljEY/4QFUSXJYc6cNPZKMFmSTBRkWK0Hj3k3XdWrov6M51X0Jw5qPsqj
	tjNJScTY4sYnuqIRclVFscSxXcN4tHJ+6mPfqJ2EzML7KcnVS/UrNKhLyreoT1R+Dun52dEsn8w
	zJe2Kkqu/4luqTCEdnlio9/lZy49usyWxDc/lCwY27M604UTMrR4y4ElbVtTJCiqhxmO/umXP1T
	F9Ltug28vMYdz3J6hLM5hetFUTNnEERQqG03hFphwq14gMUk6KoDZ04QQx5StUd+BNsxeYnp0AK
	u4MJkOIhK43tOlxJHW+Q1kTcVkKXNd9vqE2iZAGQbYo45sUyXK/Nhlr1RpQMTAWtO19e1UUpKFG
	htjRxGrYivsaEsnDFMTenjBKSXrQCBwcCyZpkSS6XRGKIzbgZaWT/+ByzhjmUbO+fg+paL/l9t9
	Dw6nQNPEzSoKUUHzcgmNjK5x+iU71G/p5l+kcrSBLW8wy2tvE7EXPBYtqRrw==
X-Received: by 2002:a17:90b:254d:b0:38d:c0f9:30be with SMTP id 98e67ed59e1d1-38e1b012d38mr8272945a91.38.1784174897247;
        Wed, 15 Jul 2026 21:08:17 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6f0fcdsm6473974eec.30.2026.07.15.21.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 21:08:16 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 15 Jul 2026 21:08:14 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v11 12/31] cxl/mem: Set up framework for handling DC
 Events
Message-ID: <alhZLnHZgvRcOvO8@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-13-anisa.su@samsung.com>
 <dc8155d9-df6a-444b-a954-dad2d59cf704@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc8155d9-df6a-444b-a954-dad2d59cf704@intel.com>

On Fri, Jun 26, 2026 at 02:54:43PM -0700, Dave Jiang wrote:
> 
> 
> On 6/25/26 4:04 AM, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Adds the support for receiving DC event records but defers
> > the real add/release logic to subsequent commits. Simply refuse all
> > extents for DC_ADD and ack all DC_RELEASE events for now. Forced
> > release is currently unsupported.
> > 
> > In order, this commit adds the following:
> > 
> > 1. Learn about DC Event Records and how to respond to them
> > 
> > * cxl_mem_get_event_records() learns about the DC Event record.
> > Records of that type are routed to cxl_handle_dcd_event_records().
> > 
> > * cxl_handle_dcd_event_records() switches on event_type:
> > 	- DCD_ADD_CAPACITY     -> handle_add_event()
> > 	- DCD_RELEASE_CAPACITY -> cxl_rm_extent()
> > 	- DCD_FORCED_CAPACITY_RELEASE is logged and ignored (FM/device-only).
> > 
> > * cxl_send_dc_response() sends the reply mailbox commands
> > ADD_DC_RESPONSE / RELEASE_DC
> > 
> > 2. Add stubs for DC_ADD and DC_RELEASE logic
> > 
> > * handle_add_event() stages incoming extents onto
> > mds->add_ctx.pending_extents and, when More=0 closes the chain,
> > replies with an empty ADD_DC_RESPONSE — refusing all extents for now
> > 
> > * cxl_rm_extent() acks the release via memdev_release_extent() so the
> > device's view stays consistent; we can ack all releases because
> > we currently don't accept/use any extents offered.
> > 
> > 3. Structural setup for later commits:
> > 
> > * struct dc_extent, struct cxl_dc_tag_group, and pending_add_ctx
> > set up the stage for the real DC_ADD path, which will enforce
> > tag/grouping semantics
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> Just a minor comment below besides all the issues raised by sashiko
> 
Got it!

> 
> > 
> > +
[snip]

I also meant to ask in the last rev but I forgot: are these stub
comments useful or should I just get rid of them?

> > +/*
> > + * Stub: ack the release back to the device so it knows we are not
> > + * using the range.  A later commit replaces this with the real
> > + * teardown that walks the region's tag group and tears down the
> > + * member dc_extent devices.
> > + */
> > +static int cxl_rm_extent(struct cxl_memdev_state *mds,
> > +			 struct cxl_extent *extent)
> > +{
> > +	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> > +	struct range dpa_range = {
> > +		.start = start_dpa,
> > +		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> > +	};
> > +
> > +	memdev_release_extent(mds, &dpa_range);
> > +	return 0;
> > +}
> > +
> > +static char *cxl_dcd_evt_type_str(u8 type)
> 
> Should it return 'const char *' instead?
> 
Yes

> DJ
> 
Thanks,
Anisa

> > +{
> > +	switch (type) {
> > +	case DCD_ADD_CAPACITY:
> > +		return "add";
> > +	case DCD_RELEASE_CAPACITY:
> > +		return "release";
> > +	case DCD_FORCED_CAPACITY_RELEASE:
> > +		return "force release";
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return "<unknown>";
> > +}
> > +
[snip]
 
