Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B8A32ED58
	for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 09:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781600472; cv=none; b=nOtp7u3yxTy478O3hpcTae29238AEZA8JMMeNch1fu4y/aSdVLDDCPOpFVcXtELGxjIwVwOPGQvsO9YOKLBmDQQJPBEVCzay3ECoZXVjDB6OSx1Hj2rnDEgzXkqSV9apW27DU9QGxM+xi1sLEw/Cba67qpJv3PG9oc02lHDv33M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781600472; c=relaxed/simple;
	bh=FRA1KwIFISMQKwypiH6P5YXZCV0SChYLUCjyR5PBoBc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFFlqAfgE4im/ipJKmQOq9xKmNEU+z8fP4BCCNqw2D40YttDG5f35UMqBcm3tyxAirWWiRe9Bu3MHwlVX/mL/1M3S90sg66EinXr/XUHz76d/fdEYPqS1VhLT2bi/Zbl1NNHYk1scyKZMl1OQfrm/YauKaJJqdRFhq9SviLoraI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pf77Ro9N; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pf77Ro9N"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30b932e4bf1so2584396eec.0
        for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781600470; x=1782205270; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gTHSWqIDphiu7OnXpJ8UEDiN1fONaHd50Es3Nexm0+E=;
        b=pf77Ro9N0xqGiAtNY56xA0cuTqTTFcSiUgv/cApyKTUc2ebuPNbhJ8IVjaGUKqCjZE
         5iTmmqlh8buc4syO633RPh9S+sjx3CvGnl7fbi4rlTMw1Z7QDQaOVpnf7kLE9QNgzTD2
         7wZ1nfCku7zwRNJRbapANqT/wWGV5bUbe5U6Rtj/IrN6xdXVCTDFDltpGtAVxKd4/qoU
         NuWjEqmrv1S8Xhtvj7yEwSXbPfF+wqoeQiSyr9uo8CNwm4bH0GrSb+Pnn4ZZeoBxJ1Ne
         z4ePxSfpDQoYbOYh61SDq41wilPo9UlNasr7c38P0kvSG2hKuQzmEKlRr/YzhepZZ6wt
         6rYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781600470; x=1782205270;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTHSWqIDphiu7OnXpJ8UEDiN1fONaHd50Es3Nexm0+E=;
        b=DAZqE3VJFoifafQghRM5gfJKpBugm/c5PCvv+tnPqF9hbbzxcjJ9HJFaFM+cO13FHq
         cMRWw1utol93tIADRTLDdmZjmEvaNCqVLUXbWwAOVm+sAMpc5DjfhW89D8K87LNT0xo+
         UFCM1QCAL11LXXvQ8dRWwtO5mJU4c7AHIn8VZSEc4xx1BgKBZqH26puyCTvlYSKD/ikS
         6kE3RP7aFWnqRrQDVXDn2/ZvYQxBOu8dgPjvKsL058YpRuixCHnENEOd0QcF9Y/YkiZC
         H4c3vT9/aGhwucRjVVOmEJkzfF2yF1XO8OIrn/UjkQxXw5bPW34VYjTJX0+YgE4CvBMN
         zekA==
X-Forwarded-Encrypted: i=1; AFNElJ/BhF/PNj5oAsdPCJAH47t8Ek4+ey9Crk4F0onn/AnawqBZ9zGGCoSeBeIIgE8toPUXBegcMg4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpog3s3+X6PgJFC5M6Sxl1M+mG+7TmykqeJg62p0m3u9O7RM92
	frtdX5qL2npgYHLEBU8fqPZNoYCmLl3HxQCxbhAYiPzpeyn5zKeEbezV
X-Gm-Gg: Acq92OHZXrHCeG3mSdljcZn7XyAfQ7BaaSJUAt8NQXhI4Swuymo8+6igxnvmX8i9NdN
	Kmudu0vir9dEIcsw9W/0tyIcl/Ma/urk2VB8kfvlhbzaCQliirefiMlMbl+vnghMgXcSPJN+4CG
	zCAXRqEZ0Miim91On8fVk9Sc3A17Oyv2JNFaRjTlNKgw732XkJkLn7kfvj9+zrSK3IVE9drkD0D
	2RV8I9xLouW1xvsi3MXIeJYO8HAoO2xeBWBLvTSKhGylbr3ywal3dOALeMBcc20kvPvutDFrDot
	9kNy+qf2MdsSDcd27DvM9I3SpOpivC1IxVBXzqq25bGwsIjIJBcbSzf6X1na38RGOGdJfCrd/tC
	tB4I4gwSmwL2BPIqSZHwMjYKrYFQ7O3dHIZSFF7+f/r6mchKvk5Xsz15n1+X9TTKQ1Y9bq7Vsey
	lc1XsYhCGkI4U5h/Ui7Zi8cVRkfrr4AAJdnCli02Dd74UPGtFjw2wBKV/aeRJo7n9sXH1VQuCN9
	VU/Zic=
X-Received: by 2002:a05:7300:640a:b0:2f1:496c:94bf with SMTP id 5a478bee46e88-3093ec3deb0mr7396433eec.16.1781600469774;
        Tue, 16 Jun 2026 02:01:09 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081eb8d3c9sm18149333eec.26.2026.06.16.02.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:01:09 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 16 Jun 2026 02:01:08 -0700
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
Subject: Re: [PATCH v10 26/31] dax/bus: Tag-aware uuid claim and show on DC
 dax devices
Message-ID: <ajEQ1HiL0rZ0jrCP@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <89784b600e4284772c4136b462e948e016129cdf.1779528761.git.anisa.su@samsung.com>
 <7731c0e2-83e7-4502-a722-8d009532d1a9@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7731c0e2-83e7-4502-a722-8d009532d1a9@intel.com>

On Fri, May 29, 2026 at 10:53:23AM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > DC DAX regions are populated with dax_resource children that each carry a
> > backing tag uuid and a per-allocation sequence number (seq_num).  Add the
> > userspace claim semantics that resolve those tagged groups into DAX
> > devices.
> > 
> > A DC region's seed dax device is created at 0-size on probe; userspace
> > populates it by writing to its 'uuid' attribute:
> > 
> >   * A non-null UUID claims every dax_resource on this region whose tag
> >     matches, in seq_num order via uuid_claim_tagged().  The match set
> >     must form a dense 1..n sequence (no gap, no duplicate); the CXL
> >     side maintains this invariant for both sharable allocations (where
> >     the device stamps shared_extn_seq) and non-sharable allocations
> >     (where cxl_add_pending assigns arrival-order seq).  The resulting
> >     DAX device's size equals the sum of every member extent's size.
> > 
> >   * "0" claims a single untagged dax_resource via
> >     uuid_claim_untagged().  Untagged extents are independent
> >     allocations; collapsing several would aggregate unrelated capacity,
> >     so each uuid="0" write consumes exactly one untagged resource.
> > 
> >   * A write that matches no dax_resource returns -ENOENT; the device
> >     stays at size 0.
> > 
> > uuid_show() reads back the backing tag uuid (or the null UUID for an
> > untagged claim).  The attribute is read-only (0444) on non-DC dax
> > devices; writes to it on non-DC regions return -EOPNOTSUPP.
> > 
> > dev_dax_visible() exposes the uuid attribute only on DC dax devices.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: split out from the original "Surface dc_extents" commit;
> >  userspace tag-claim semantics only.]
> > ---
> >  drivers/dax/bus.c | 260 +++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 256 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index c030eb103ad0..1dccb3e5cd0f 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -5,6 +5,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/list.h>
> >  #include <linux/slab.h>
> > +#include <linux/sort.h>
> >  #include <linux/dax.h>
> >  #include <linux/io.h>
> >  #include "dax-private.h"
> > @@ -1316,6 +1317,89 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
> >  	return 0;
> >  }
> >  
> > +/* DC extents are all-or-nothing: an extent is either free or fully claimed. */
> > +static bool dax_resource_in_use(const struct dax_resource *dax_resource)
> > +{
> > +	return dax_resource->use_cnt > 0;
> > +}
> > +
> > +struct dax_uuid_match {
> > +	const struct dax_region *dax_region;
> > +	const uuid_t *uuid;
> > +};
> > +
> > +static int find_uuid_extent(struct device *dev, const void *data)
> > +{
> > +	const struct dax_uuid_match *match = data;
> > +	struct dax_resource *dax_resource;
> > +
> > +	if (!match->dax_region->dc_ops->is_extent(dev))
> > +		return 0;
> > +
> > +	dax_resource = dev_get_drvdata(dev);
> > +	if (!dax_resource || dax_resource_in_use(dax_resource))
> > +		return 0;
> > +	return uuid_equal(&dax_resource->uuid, match->uuid);
> > +}
> > +
> > +struct dax_tag_collect {
> > +	const struct dax_region *dax_region;
> > +	const uuid_t *uuid;
> > +	struct dax_resource **arr;
> > +	unsigned int count;
> > +	unsigned int cap;
> > +};
> > +
> > +static int collect_uuid_extent(struct device *dev, void *data)
> > +{
> > +	struct dax_tag_collect *c = data;
> > +	struct dax_resource *dax_resource;
> > +
> > +	if (!c->dax_region->dc_ops->is_extent(dev))
> > +		return 0;
> > +
> > +	dax_resource = dev_get_drvdata(dev);
> > +	if (!dax_resource || dax_resource_in_use(dax_resource))
> > +		return 0;
> > +	if (!uuid_equal(&dax_resource->uuid, c->uuid))
> > +		return 0;
> > +
> > +	if (c->count == c->cap)
> > +		return -ENOSPC;
> > +	c->arr[c->count++] = dax_resource;
> > +	return 0;
> > +}
> > +
> > +static int count_uuid_extent(struct device *dev, void *data)
> > +{
> > +	struct dax_tag_collect *c = data;
> > +	struct dax_resource *dax_resource;
> > +
> > +	if (!c->dax_region->dc_ops->is_extent(dev))
> > +		return 0;
> > +
> > +	dax_resource = dev_get_drvdata(dev);
> > +	if (!dax_resource || dax_resource_in_use(dax_resource))
> > +		return 0;
> > +	if (!uuid_equal(&dax_resource->uuid, c->uuid))
> > +		return 0;
> > +
> > +	c->count++;
> > +	return 0;
> > +}
> > +
> > +static int dax_resource_seq_cmp(const void *a, const void *b)
> > +{
> > +	const struct dax_resource * const *pa = a;
> > +	const struct dax_resource * const *pb = b;
> > +
> > +	if ((*pa)->seq_num < (*pb)->seq_num)
> > +		return -1;
> > +	if ((*pa)->seq_num > (*pb)->seq_num)
> > +		return 1;
> > +	return 0;
> > +}
> > +
> >  static ssize_t size_store(struct device *dev, struct device_attribute *attr,
> >  		const char *buf, size_t len)
> >  {
> > @@ -1548,13 +1632,177 @@ static DEVICE_ATTR_RO(numa_node);
> >  static ssize_t uuid_show(struct device *dev,
> >  		struct device_attribute *attr, char *buf)
> >  {
> > -	return sysfs_emit(buf, "%d\n", 0);
> > +	struct dev_dax *dev_dax = to_dev_dax(dev);
> > +	int rc;
> > +
> > +	rc = down_read_interruptible(&dax_dev_rwsem);
> 
> Since we are here, may as well convert these to ACQUIRE() and be rid of the gotos
> 
> ACQUIRE(rwsem_read_intr, rwsem)(&dax_dev_rwsem);
> if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
> 	...
> 
Fixed!

> 
> > +	if (rc)
> > +		return rc;
> > +
> > +	for (int i = 0; i < dev_dax->nr_range; i++) {
> > +		struct dax_resource *r = dev_dax->ranges[i].dax_resource;
> > +
> > +		if (r && !uuid_is_null(&r->uuid)) {
> > +			rc = sysfs_emit(buf, "%pUb\n", &r->uuid);
> > +			goto out;
> > +		}
> > +	}
> > +	rc = sysfs_emit(buf, "0\n");
> 
> As pointed out earlyer, should display null_uuid to be consistent.
> 
Yep, fix from prev commit propagated to current.

> > +out:
> > +	up_read(&dax_dev_rwsem);
> > +	return rc;
> > +}
> > +
> > +static ssize_t uuid_claim_untagged(struct dax_region *dax_region,
> > +				   struct dev_dax *dev_dax)
> > +{
> > +	struct dax_uuid_match match = {
> > +		.dax_region = dax_region,
> > +		.uuid = &uuid_null,
> > +	};
> > +	struct dax_resource *dax_resource;
> > +	resource_size_t to_alloc;
> > +	struct device *extent_dev;
> > +	ssize_t alloc;
> > +
> > +	extent_dev = device_find_child(dax_region->dev, &match,
> > +				       find_uuid_extent);
> > +	if (!extent_dev)
> > +		return -ENOENT;
> > +
> > +	dax_resource = dev_get_drvdata(extent_dev);
> > +	to_alloc = resource_size(dax_resource->res);
> > +	alloc = __dev_dax_resize(dax_resource->res, dev_dax, to_alloc,
> > +				 dax_resource);
> > +	put_device(extent_dev);
> > +	if (alloc < 0)
> > +		return alloc;
> > +	if (alloc == 0)
> > +		return -ENOENT;
> > +	dax_resource->use_cnt++;
> > +	return 0;
> > +}
> > +
> > +static ssize_t uuid_claim_tagged(struct dax_region *dax_region,
> > +				 struct dev_dax *dev_dax, const uuid_t *uuid)
> > +{
> > +	struct dax_tag_collect c = {
> > +		.dax_region = dax_region,
> > +		.uuid = uuid,
> > +	};
> > +	unsigned int i;
> > +	ssize_t rc;
> > +
> > +	/* Two-pass: count, then collect into a sized array. */
> > +	device_for_each_child(dax_region->dev, &c, count_uuid_extent);
> > +	if (!c.count)
> > +		return -ENOENT;
> > +
> > +	c.arr = kmalloc_array(c.count, sizeof(*c.arr), GFP_KERNEL);
> > +	if (!c.arr)
> > +		return -ENOMEM;
> > +	c.cap = c.count;
> > +	c.count = 0;
> > +
> > +	rc = device_for_each_child(dax_region->dev, &c, collect_uuid_extent);
> > +	if (rc)
> > +		goto out;
> > +
> > +	sort(c.arr, c.count, sizeof(*c.arr), dax_resource_seq_cmp, NULL);
> > +
> > +	/*
> > +	 * Tagged groups carry a dense 1..n @seq_num regardless of source
> > +	 * (sharable: device-stamped; non-sharable: host-assigned in
> > +	 * arrival order — see &struct dax_resource).  A gap or
> > +	 * out-of-range value here means an extent went missing on the
> > +	 * cxl side (e.g. a per-extent failure in cxl_add_pending) or a
> > +	 * cxl-side validation gap; in either case refuse the whole
> > +	 * group rather than carve a partial allocation.
> > +	 */
> > +	for (i = 0; i < c.count; i++) {
> > +		if (c.arr[i]->seq_num != i + 1) {
> > +			dev_WARN_ONCE(dax_region->dev, 1,
> > +				"tag %pUb seq invariant violated at slot %u (got %u)\n",
> > +				uuid, i, c.arr[i]->seq_num);
> > +			rc = -EINVAL;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < c.count; i++) {
> > +		resource_size_t to_alloc = resource_size(c.arr[i]->res);
> > +		ssize_t alloc;
> > +
> > +		alloc = __dev_dax_resize(c.arr[i]->res, dev_dax, to_alloc,
> > +					 c.arr[i]);
> > +		if (alloc < 0) {
> > +			rc = alloc;
> > +			goto rollback;
> > +		}
> > +		if (alloc == 0) {
> > +			rc = -ENOSPC;
> > +			goto rollback;
> > +		}
> > +		c.arr[i]->use_cnt++;
> > +	}
> > +	rc = 0;
> > +	goto out;
> > +
> > +rollback:
> > +	/*
> > +	 * Partial failure: trim every range we added in this attempt.
> > +	 * trim_dev_dax_range pops the most-recently-appended range from
> > +	 * dev_dax->ranges[] and decrements its dax_resource->use_cnt, so
> > +	 * looping until we have undone @i additions restores both
> > +	 * dev_dax->ranges[] and the matched dax_resources' use_cnt.
> > +	 */
> > +	while (i-- > 0)
> > +		trim_dev_dax_range(dev_dax);
> > +out:
> > +	kfree(c.arr);
> > +	return rc;
> >  }
> >  
> >  static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
> >  			  const char *buf, size_t len)
> >  {
> > -	return -EOPNOTSUPP;
> > +	struct dev_dax *dev_dax = to_dev_dax(dev);
> > +	struct dax_region *dax_region = dev_dax->region;
> > +	uuid_t uuid;
> > +	ssize_t rc;
> > +
> > +	if (!is_dynamic(dax_region))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (sysfs_streq(buf, "0"))
> > +		uuid_copy(&uuid, &uuid_null);
> > +	else {
> > +		rc = uuid_parse(buf, &uuid);
> > +		if (rc)
> > +			return rc;
> > +	}
> > +
> > +	rc = down_write_killable(&dax_region_rwsem);
> > +	if (rc)
> > +		return rc;
> > +	if (!dax_region->dev->driver) {
> > +		rc = -ENXIO;
> > +		goto err_region;
> > +	}
> > +	rc = down_write_killable(&dax_dev_rwsem);
> 
> same comments about ACQUIRE()
> 
Same applied here

> > +	if (rc)
> > +		goto err_region;
> > +
> 
> Does it need to check if the device is already claimed before proceeding to claiming? What happens if the uuid is written twice to this sysfs file?
> 
yes; new check added:

/* A claimed device already has capacity; do not overwrite its uuid. */
if (dev_dax_size(dev_dax))
	return -EBUSY;

> DJ

Thanks,
Anisa
> > +	if (uuid_is_null(&uuid))
> > +		rc = uuid_claim_untagged(dax_region, dev_dax);
> > +	else
> > +		rc = uuid_claim_tagged(dax_region, dev_dax, &uuid);
> > +
> > +	up_write(&dax_dev_rwsem);
> > +err_region:
> > +	up_write(&dax_region_rwsem);
> > +
> > +	return rc < 0 ? rc : len;
> >  }
> >  static DEVICE_ATTR_RW(uuid);
> >  
> > @@ -1614,8 +1862,12 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
> >  		return 0;
> >  	if (a == &dev_attr_mapping.attr && is_dynamic(dax_region))
> >  		return 0;
> > -	if ((a == &dev_attr_align.attr ||
> > -	     a == &dev_attr_size.attr) && is_static(dax_region))
> > +	if (a == &dev_attr_uuid.attr && !is_dynamic(dax_region))
> > +		return 0444;
> > +	if (a == &dev_attr_align.attr &&
> > +	    (is_static(dax_region) || is_dynamic(dax_region)))
> > +		return 0444;
> > +	if (a == &dev_attr_size.attr && is_static(dax_region))
> >  		return 0444;
> >  	return a->mode;
> >  }
> 
