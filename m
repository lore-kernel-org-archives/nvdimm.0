Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8541737F8D7
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 05:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781243768; cv=none; b=lxyvQJ3cdWjH8t8wtYl2ivy8JQ/i+r5QPNGLSHrqvroMQz3gsUpDwsKcMKMV0+Cunl6bFhpm66+CBmMNWP0qAoBabSOYOEv8StfGKncZL7Lx3U2ScxmBIQWyXnq3AQ/gShqqnWQY/mcsveB/G7chWUojhnYh1i5alVqHVSkaoAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781243768; c=relaxed/simple;
	bh=Hc0t+F7CCUlC0T1+T5f5uD9dtK/GKGmUbz0K7fr8HAw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBLw5IhNRS8a5tj1wLF0+OCnqOG/nomFQyol7QlEAkmrxw75LcZBZrMyGJpqKsLQ/MzM2qu/xax54z/mK4gVmOreiCwYZnYLz6CS3Jfo2uZnuVY0tk6LQ2mDvwtd57dKYKbAV+doviiSiEwqDRzTeCdNQZfNFB2+kenO1GuahqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMRrKprr; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMRrKprr"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-304d7f31215so624736eec.1
        for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 22:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781243766; x=1781848566; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o1/8HbI2tQXE6yGxF18OB+Fgo5WuZLJkcMP+v9NB1fE=;
        b=QMRrKprro+DoU8ln2jt3ajmZEVhJN6VWf/czyIrreZN6wbiIZvykwJtF56tqgplLs4
         VDla8PNAj3gI1GJP1ZMKCTlwknD4UBv1ri0SMgT0HXTNNGupgL0KEe3ffHzKw21O3PdC
         +efxdhg83zrM3ZOz/Kez74w0vZ5gY3+AAE0QCbBWmNIFjKEfhSTuHMntKqt/WJlflIjb
         IxbzosmwJIAtgRVMqpX/gh/r9XUgkXIH9fsuaSUBsSUspxiUH2j8jUGLFgJ6DyKNApHp
         O9GN0u+PPE/VAgBc7vFMnVM/8odheZqcMj0zt2hH5eXsuVPVxHicx0BepEiPtXzs3rwJ
         Lgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781243766; x=1781848566;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1/8HbI2tQXE6yGxF18OB+Fgo5WuZLJkcMP+v9NB1fE=;
        b=BZh3m+UeQq1+rh2FDHV8FIrUoZU0XEiSq+Xk6PMIWwPw6m06jwTlPJ0WOeVZCc4KdA
         2S7eFAr24Z68DqZ28G6conHhjoEt2AqGfXaOVeQ8D5lHnxJ4rzXr2KHM/zgDtssyIRDP
         9RjarjY0eQhBcYYJAO/Q8aujTpYSd/fUbZmVPiwj6hY2S1y7juCcg9dy7e5V4OMXl2Xa
         2/LmgVFYU8d+/1eZ2DTn0y5WxaI0p1Nkt+330DWRmbu7saYHT1pCJD1tEgYWbtdJEHy1
         97uujaqsG9Qje1aB+LkcCa+FQS3bqiF3rTU+XTgZCHmZfraQMA6OEZy9iIjK1dxnP1Z0
         TDIg==
X-Forwarded-Encrypted: i=1; AFNElJ9H4gsMNtX33/r8eC7OtLAXZa4y2tl2qyN68q2y4GBj92+w9mJaWmykR1aCNyJV/5wPlAMjwic=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXvKL0Z6BQgxp20TJIvkDe1dFR1IipAQYWbwcHg65S5AHHjOgq
	ynVubq9XXSi6ckteQioKAMMD2vmjQ868uH547pWv+FZBZ1O8XQOiy/N8
X-Gm-Gg: Acq92OGimpyLqTLai2bCVr0Rd9wBwV7JUq/XWcwZvjTTO3dPX6gzLZvgfQIZioP4RPK
	wZm1CYFny2E69mYbjw6Ov0kfJZ7X00o8Mel3nBSO5L8sHmW1nmuAr4lzLEvR8kr/1oxHpNIXycX
	Y6BLLQZiuXfhZq8eJPN2IDb+hFnDd30c2NhuNWhANgG42i1CQawEsz/WL9gD1PyZDNfJD+ap/I6
	grJ4IeM+jpQRTK58hs+nJuRlWR23N1uAEumqFUk/KESSOnkRCrRP2barJx9Q2kWvEL875JVUj2j
	siG8b7l9GXIlLJ4pGnih/HUk0rXlnQMBCD8OSqlw79tyi8FNkP3aY0g3PFewJiMkx1w07zu/QZx
	awq38tULpRfgcwOV0liZrwWDYjjsXiVaxj84WFZi6bWoHyYrGMhrq91KW9zTAwgwb3bGe4Ed/i6
	CHgiorZqfhqPgg4OELFh+LctWglqoAxJq51/Lu7SZMPn2+R7+HObkTnSTjW7xEfJ/iNEJMmjIn/
	Kht65g=
X-Received: by 2002:a05:7301:578d:b0:304:ccdd:594a with SMTP id 5a478bee46e88-3081ff3db4amr924271eec.5.1781243765379;
        Thu, 11 Jun 2026 22:56:05 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081ea4f7a0sm1839668eec.24.2026.06.11.22.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 22:56:04 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 11 Jun 2026 22:56:02 -0700
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
Subject: Re: [PATCH v10 18/31] cxl/extent: Handle DC Release Capacity events
Message-ID: <aiufclf81RZQHDrp@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <b6069cc18b77f9eb7b2f1655721c8206fc447733.1779528761.git.anisa.su@samsung.com>
 <de6c7708-64cc-4ada-94cb-4916022b706d@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de6c7708-64cc-4ada-94cb-4916022b706d@intel.com>

On Thu, May 28, 2026 at 03:13:29PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > Replace the no-op ack stub for cxl_rm_extent() with the real teardown:
> > resolve the released DPA range to its region and endpoint decoder,
> > locate the matching dc_extent in cxlr_dax->dc_extents (filtering by
> > cxled, range containment, and tag), and tear down the entire containing
> > tag group atomically through rm_tag_group().  Partial release is not
> > supported.
> > 
> > rm_tag_group() invalidates caches once for the whole group (no mappings
> > exist at this point — partial release is not supported, so all members
> > are leaving together), then walks the group's dc_extents and releases
> > each via its devm action installed at online_tag_group() time.
> > 
> > cxl_region_invalidate_memregion() becomes non-static and is declared
> > in core.h so rm_tag_group() can flush caches before tearing the group down.
> > 
> > When the released range maps to no region (host crashed before
> > persisting acceptance, region destruction raced device release, or the
> > device is confused) the host has nothing to drop, so reply via
> > memdev_release_extent() to keep the device's view consistent.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: restructured from the original "Process dynamic partition
> >  events" monolith; this commit replaces the stubbed release with the
> >  real walk-and-tear-down of the matching tag group.]
> > ---
> >  drivers/cxl/core/core.h   |   8 +++
> >  drivers/cxl/core/extent.c | 101 ++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/core/mbox.c   |  19 -------
> >  drivers/cxl/core/region.c |   2 +-
> >  4 files changed, 110 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > index 30b6b05b155b..65daaaadf68e 100644
> > --- a/drivers/cxl/core/core.h
> > +++ b/drivers/cxl/core/core.h
> > @@ -28,6 +28,8 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
> >  	return container_of(cxlds, struct cxl_memdev_state, cxlds);
> >  }
> >  
> > +int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
> 
> Doesn't this need to go within CONFIG_CXL_REGION?
> 
oopsie yes
> > +
> >  #ifdef CONFIG_CXL_REGION
> >  
> >  struct cxl_region_context {
> > @@ -67,6 +69,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
> >  
> >  int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
> >  		   u16 seq_num);
> > +int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
> >  int online_tag_group(struct cxl_dc_tag_group *group);
> >  #else
> >  static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
> > @@ -79,6 +82,11 @@ static inline int cxl_add_extent(struct cxl_memdev_state *mds,
> >  {
> >  	return 0;
> >  }
> > +static inline int cxl_rm_extent(struct cxl_memdev_state *mds,
> > +				struct cxl_extent *extent)
> > +{
> > +	return 0;
> > +}
> >  static inline int online_tag_group(struct cxl_dc_tag_group *group)
> >  {
> >  	return 0;
> > diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> > index b01507022cff..51116c8139ed 100644
> > --- a/drivers/cxl/core/extent.c
> > +++ b/drivers/cxl/core/extent.c
> > @@ -344,6 +344,107 @@ static void dc_extent_unregister(void *ext)
> >  	device_unregister(&dc_extent->dev);
> >  }
> >  
> > +static void rm_tag_group(struct cxl_dc_tag_group *group)
> > +{
> > +	struct device *region_dev = &group->cxlr_dax->dev;
> > +	struct dc_extent *dc_extent;
> > +	unsigned long index;
> > +
> > +	/*
> > +	 * Tagged allocations release atomically.  Invalidate caches once
> > +	 * for the whole group (no mappings exist at this point — partial
> > +	 * release is not supported, so all members are leaving use
> > +	 * together) before tearing down each dc_extent device.
> > +	 *
> > +	 * Pin @group across the walk: each devm_release_action runs the
> > +	 * dc_extent_unregister action synchronously, which drops the last
> > +	 * reference on the dc_extent device and fires dc_extent_release.
> > +	 * The release decrements group->nr_extents and, on the final
> > +	 * decrement, frees @group.  Without the pin the next iteration's
> > +	 * xa_find_after() dereferences a freed xarray.
> > +	 */
> > +	cxl_region_invalidate_memregion(group->cxlr_dax->cxlr);
> 
> check return value?
> 
done. if invalidate_memregion fails, doesn't release and device needs to
retry

> > +
> > +	group->nr_extents++;
> > +	xa_for_each(&group->dc_extents, index, dc_extent)
> > +		devm_release_action(region_dev, dc_extent_unregister, dc_extent);
> > +	group->nr_extents--;
> > +	if (!group->nr_extents)
> > +		free_tag_group(group);
> > +}
> > +
> > +int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
> > +{
> > +	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> > +	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> > +	struct cxl_endpoint_decoder *cxled;
> > +	struct cxl_dax_region *cxlr_dax;
> > +	struct cxl_dc_tag_group *group;
> > +	struct dc_extent *dc_extent;
> > +	struct cxl_region *cxlr;
> > +	struct range dpa_range;
> > +	unsigned long idx;
> > +	uuid_t tag;
> > +
> > +	dpa_range = (struct range) {
> > +		.start = start_dpa,
> > +		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> > +	};
> > +
> > +	guard(rwsem_read)(&cxl_rwsem.region);
> > +	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> > +	if (!cxlr) {
> > +		/*
> > +		 * No region can happen here for a few reasons:
> > +		 *
> > +		 * 1) Extents were accepted and the host crashed/rebooted
> > +		 *    leaving them in an accepted state.  On reboot the host
> > +		 *    has not yet created a region to own them.
> > +		 *
> > +		 * 2) Region destruction won the race with the device releasing
> > +		 *    all the extents.  Here the release will be a duplicate of
> > +		 *    the one sent via region destruction.
> > +		 *
> > +		 * 3) The device is confused and releasing extents for which no
> > +		 *    region ever existed.
> > +		 *
> > +		 * In all these cases make sure the device knows we are not
> > +		 * using this extent.
> > +		 */
> > +		memdev_release_extent(mds, &dpa_range);
> > +		return -ENXIO;
> > +	}
> > +
> > +	cxlr_dax = cxlr->cxlr_dax;
> 
> Does it need to check if cxlr_dax is NULL?
> 
added check. same behavior as if !cxlr, bc if !cxlr_dax, we're not
tracking or using any extents, so safe to reply to device with release

> DJ
> 
Thanks,
Anisa
> > +	import_uuid(&tag, extent->uuid);
> > +
> > +	/*
> > +	 * Find the dc_extent whose DPA range covers the released range and
> > +	 * whose tag matches.  The release targets the entire containing
> > +	 * tag group atomically; partial release is not supported.
> > +	 */
> > +	group = NULL;
> > +	xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
> > +		if (dc_extent->cxled != cxled)
> > +			continue;
> > +		if (!range_contains(&dc_extent->dpa_range, &dpa_range))
> > +			continue;
> > +		if (!uuid_equal(&dc_extent->group->uuid, &tag))
> > +			continue;
> > +		group = dc_extent->group;
> > +		break;
> > +	}
> > +	if (!group) {
> > +		dev_err(&cxlr_dax->dev,
> > +			"release DPA %pra (%pU) matches no dc_extent\n",
> > +			&dpa_range, &tag);
> > +		return -EINVAL;
> > +	}
> > +
> > +	rm_tag_group(group);
> > +	return 0;
> > +}
> > +
> >  static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
> >  {
> >  	struct cxl_dc_tag_group *group = dc_extent->group;
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 545c48c9c373..70e6c4c9743c 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1587,25 +1587,6 @@ static int handle_add_event(struct cxl_memdev_state *mds,
> >  	return rc;
> >  }
> >  
> > -/*
> > - * Stub: ack the release back to the device so it knows we are not
> > - * using the range.  A later commit replaces this with the real
> > - * teardown that walks the region's tag group and tears down the
> > - * member dc_extent devices.
> > - */
> > -static int cxl_rm_extent(struct cxl_memdev_state *mds,
> > -			 struct cxl_extent *extent)
> > -{
> > -	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> > -	struct range dpa_range = {
> > -		.start = start_dpa,
> > -		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> > -	};
> > -
> > -	memdev_release_extent(mds, &dpa_range);
> > -	return 0;
> > -}
> > -
> >  static char *cxl_dcd_evt_type_str(u8 type)
> >  {
> >  	switch (type) {
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index 733d77c07493..317630d8bf2e 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -222,7 +222,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
> >  	return xa_load(&port->regions, (unsigned long)cxlr);
> >  }
> >  
> > -static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
> > +int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
> >  {
> >  	if (!cpu_cache_has_invalidate_memregion()) {
> >  		if (IS_ENABLED(CONFIG_CXL_REGION_INVALIDATION_TEST)) {
> 
