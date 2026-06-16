Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92BF30F803
	for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 08:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781599948; cv=none; b=KWOQVvr6L232q2Wzl29EWgBltR1sGe5HCj7Jk9KY87rznW32daRYnLXZBSPH8zBjbBAOgafk/mUni5JSA51q44yDJFn3VajqlKqk9RJ5klVUQAC22azLnuOQ8FsqfbfBlPFhsrnrzA61/971Do19eqwcQdi5Fzfs12PIkxNdCkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781599948; c=relaxed/simple;
	bh=DgIRg0/Ae/rj+He5hXmmINFFMWD79ugN2T/eFvahRgY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DW3bRYsGETRq42JW6ILfM/DQERCccer5eQdB+i4hCrYq5JfyTUAhQqzwubM6TcJYrvhOaLr30tRK8vxplECDs/Rn7uV7IEh8aOng/KJDlgbaJMLcC/07H8EOe6KrpAEXf7k7pKT03vfWAfjXjciTQusck9EfD60aLfVAOuLLRFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s2WQstMf; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s2WQstMf"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-306f36df4feso2966106eec.0
        for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 01:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781599946; x=1782204746; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DKn7OvjHw/lRk7pr53nXXyGHvM+kf1zPMbMYFNvXDvA=;
        b=s2WQstMfEdWzkdmnYrT5LVZClnsqFHQ7Wyo9p+epPUvqmuORXBrjHoeT9iw6ZQO3aA
         CJSyDmi+z911hgrKNbLNoyuNH7qenwOdqQSk9KKMSGTPqEf7lmNkLkv5KjOVX+wEUzSJ
         zDe5vvpk1+9UQmEVqfnsAgeW3+FyO9f+hBrNngliIuTInpEdoX6uwKZRFMaQDaCrvL7F
         X+ohDYPddhVY4dwHo18Wt3W6711ShQ5zqfcUKEsfToa/DI6qzY2jCvO6iyID2S5IX9Hg
         OFZIFTNUA+QQr7e2SYJJFdH2Jfbp55Xg8Y/7Wj6Ifm4JVLg1shQaLZFX030Gs3I5yCGR
         M2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781599946; x=1782204746;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKn7OvjHw/lRk7pr53nXXyGHvM+kf1zPMbMYFNvXDvA=;
        b=kDbdTRLHFULu5y2otdlF67VyePWIrMz0VdpI9M5y+owZo0tq8/pFDY6olx8WdEwsRR
         ajYq+Buoe5nc3wjPZUe3RCguxG8uGqIkbg9kZvkvrVHGFbN6kaJGnCtZHdLui6O4QgNS
         y58KvHzatoycTui4kWaZVhRJ9wXEe752ju2aY9PorNKt6xhrfD7fuDcD7sttEDJ90BYQ
         Kq6VVMaXkzOxtYumxarkGfq0FkUJVDuNfnRREXLW4BAfdNpQNNIuJBQ7LM6cF2IdAdG6
         P8jtRluI8ttx5qHtwkjCOXRyLr+xucm3RC0ZjoiGGu/hxi1QSJR43NmBPr5vbpBdEw6W
         qm6w==
X-Forwarded-Encrypted: i=1; AFNElJ+jS44+N3u6qFj2QLqc2xQ8vgE0aZ/WxUUPo94Eb49YpB8ACXZr49u/yveVNrqZEFiGk4URlaA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyDMyOQMvC1EOWHpsaslaGL+5df+Tg7qpKYwLczndU7QDpxNDJ
	wCZMh48g47AjeAUSKnoKyNKCVlIg7CK0LmuYWa3LTPDhFl4wjOrjNqmN
X-Gm-Gg: Acq92OHX7PsrQytTRnrk6pwjsrbNaN/UwOwkHIjg+aEDm2ojSPmVS6Z1gjMOlZITHBq
	KsLUGkTaX//BSJethmyWlMv5JJAGMyM48a3Gx9m0iEUFv6V3XGmXpzujinBzVShyRNj5O9Ezy/s
	h2FUutCSAynlXXCad0U/CBV5A0S9LpH0lLjmR6iqdVbiMU+aX8sa5Lc6Fa4ZEuJe/Tz/ikNlP28
	agV0NlIZKyFIg7XMiY6wUUW6OumpYQ/6IthxfiQBphiQJfh+Wd+GXJ+WIl0ovsH+kawimsXcxvw
	SaJnKez4BoeysUBbza45L9ZjT92UoCKNe8R/oS2oZR0q6N+SxYx5bDPF4dp5PXs1pFUwYPuK372
	+ed0PoE1GYBfIRCTEsHGF6Wjw4GpcdeqtqArC2w0U13G21GALzgBVNfgwNXch8VJNBEu3YOqn6s
	UZDb18w8t9N3dJoqPQtQGnw44kci9/MfdfJg3AhxNKzcduCXFfg2r83M/yALPxnDsdn/nfeA2Jy
	gyp7FR+x4swa+sNWw==
X-Received: by 2002:a05:7301:644c:b0:302:b44b:b64a with SMTP id 5a478bee46e88-30ba32064fcmr1903411eec.1.1781599945849;
        Tue, 16 Jun 2026 01:52:25 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30bbcb11310sm275833eec.14.2026.06.16.01.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 01:52:25 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 16 Jun 2026 01:52:24 -0700
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
Subject: Re: [PATCH v10 22/31] cxl + dax: Release dax_resources on DCD
 Release Capacity events
Message-ID: <ajEOyOF3MrHVgACd@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <e6cea279dcb208684c08b756f6de65438529ad65.1779528761.git.anisa.su@samsung.com>
 <e5bd578c-15dc-4b69-9cd2-2eb3c3aa516a@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5bd578c-15dc-4b69-9cd2-2eb3c3aa516a@intel.com>

On Thu, May 28, 2026 at 04:53:43PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > Implement the release path that mirrors the add path: when the
> > device asks for capacity back, the dax layer tears down the
> > per-extent resources for the whole tag group atomically.
> > 
> > If any extent in the group is still mapped by a dev_dax, the release
> > is refused with -EBUSY and no state changes; the cxl side then leaves
> > the tag group intact and the device retries.
> > 
> > Also add a rollback to the add path: if any per-extent registration
> > fails midway through a group, undo the ones already added so a
> > partial group never leaks into the dax region.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> Just a nit below
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> 
> > 
> > ---
> > Changes:
> > [anisa: split out from the original "Surface dc_extents" commit;
> >  fills in the RELEASE half of the bridge, moves the cxl-side RELEASE
> >  notify into this commit, and adds the rollback path to ADD.]
> > ---
> >  drivers/cxl/core/extent.c | 13 +++++++++
> >  drivers/dax/bus.c         | 59 +++++++++++++++++++++++++++++++++++++++
> >  drivers/dax/cxl.c         | 54 +++++++++++++++++++++++++++--------
> >  drivers/dax/dax-private.h |  8 ++++--
> >  4 files changed, 120 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> > index 3fc4b7292664..2c8edfe53c0a 100644
> > --- a/drivers/cxl/core/extent.c
> > +++ b/drivers/cxl/core/extent.c
> > @@ -532,6 +532,7 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
> >  	struct range dpa_range;
> >  	unsigned long idx;
> >  	uuid_t tag;
> > +	int rc;
> >  
> >  	dpa_range = (struct range) {
> >  		.start = start_dpa,
> > @@ -588,6 +589,18 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
> >  		return -EINVAL;
> >  	}
> >  
> > +	rc = cxlr_notify_extent(cxlr, DCD_RELEASE_CAPACITY, group);
> > +	if (rc) {
> > +		/*
> > +		 * dax layer refused (-EBUSY) or failed (-ENOMEM, etc.).  Do
> > +		 * not proceed to tear down the tag group — leave its
> > +		 * dax_resources alive so we do not free them out from under
> > +		 * live dev_dax ranges.  The device will retry the release.
> > +		 */
> > +		return 0;
> > +	}
> > +
> > +	/* Release the entire tag group */
> >  	rm_tag_group(group);
> >  	return 0;
> >  }
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index a6ee59f2d8a1..6368bdfdf93a 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -253,6 +253,65 @@ int dax_region_add_resource(struct dax_region *dax_region,
> >  }
> >  EXPORT_SYMBOL_GPL(dax_region_add_resource);
> >  
> > +int dax_region_rm_resource(struct dax_region *dax_region,
> > +			   struct device *dev)
> > +{
> > +	struct dax_resource *dax_resource;
> > +
> > +	guard(rwsem_write)(&dax_region_rwsem);
> > +
> > +	dax_resource = dev_get_drvdata(dev);
> > +	if (!dax_resource)
> > +		return 0;
> > +
> > +	if (dax_resource->use_cnt)
> > +		return -EBUSY;
> > +
> > +	/*
> > +	 * release the resource under dax_region_rwsem to avoid races with
> > +	 * users trying to use the extent
> > +	 */
> > +	__dax_release_resource(dax_resource);
> > +	dev_set_drvdata(dev, NULL);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dax_region_rm_resource);
> 
> No reason to export. Seems only used within DAX.
> 
Called from static int cxl_dax_group_add() in drivers/dax/cxl.c so needs
to be exported from dax to dax_cxl I think?

> DJ
> 
Thanks,
Anisa
> > +
> > +/**
> > + * dax_region_rm_resources - atomically remove a set of dax_resources.
> > + *
> > + * Walk @devs twice under dax_region_rwsem.  First pass refuses the
> > + * operation if any member's use_cnt is non-zero; second pass releases
> > + * each.  This gives refuse-all-or-none semantics across the set, which
> > + * a tag group's atomic release relies on.  Devices with no
> > + * dax_resource attached are silently skipped.
> > + */
> > +int dax_region_rm_resources(struct dax_region *dax_region,
> > +			    struct device * const *devs, unsigned int n)
> > +{
> > +	unsigned int i;
> > +
> > +	guard(rwsem_write)(&dax_region_rwsem);
> > +
> > +	for (i = 0; i < n; i++) {
> > +		struct dax_resource *r = dev_get_drvdata(devs[i]);
> > +
> > +		if (r && r->use_cnt)
> > +			return -EBUSY;
> > +	}
> > +
> > +	for (i = 0; i < n; i++) {
> > +		struct dax_resource *r = dev_get_drvdata(devs[i]);
> > +
> > +		if (!r)
> > +			continue;
> > +		__dax_release_resource(r);
> > +		dev_set_drvdata(devs[i], NULL);
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(dax_region_rm_resources);
> > +
> >  bool static_dev_dax(struct dev_dax *dev_dax)
> >  {
> >  	return is_static(dev_dax->region);
> > diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> > index 690cf625e052..04b73315a8f2 100644
> > --- a/drivers/dax/cxl.c
> > +++ b/drivers/dax/cxl.c
> > @@ -44,19 +44,52 @@ static int cxl_dax_group_add(struct dax_region *dax_region,
> >  
> >  	xa_for_each(&group->dc_extents, index, dc_extent) {
> >  		rc = __cxl_dax_add_resource(dax_region, dc_extent);
> > -		if (rc)
> > +		if (rc) {
> > +			/*
> > +			 * Unwind every dax_resource already added for this
> > +			 * group; one rm per owner suffices.
> > +			 */
> > +			struct dc_extent *u;
> > +			unsigned long uidx;
> > +
> > +			xa_for_each(&group->dc_extents, uidx, u) {
> > +				if (u == dc_extent)
> > +					break;
> > +				dax_region_rm_resource(dax_region, &u->dev);
> > +			}
> >  			return rc;
> > +		}
> >  	}
> >  	return 0;
> >  }
> >  
> > -/*
> > - * RELEASE is still a stub here — the atomic dax_region_rm_resources API
> > - * and its wire-up land in the next commit.  An incoming RELEASE returns
> > - * success and the cxl side proceeds to rm_tag_group(), which device-
> > - * unregisters each dc_extent; the devm action armed by
> > - * dax_region_add_resource() then tears down each dax_resource.
> > - */
> > +static int cxl_dax_group_rm(struct dax_region *dax_region,
> > +			    struct cxl_dc_tag_group *group)
> > +{
> > +	struct dc_extent *dc_extent;
> > +	struct device **devs;
> > +	unsigned long index;
> > +	unsigned int n = 0;
> > +	int rc;
> > +
> > +	if (!group->nr_extents)
> > +		return 0;
> > +
> > +	devs = kmalloc_array(group->nr_extents, sizeof(*devs), GFP_KERNEL);
> > +	if (!devs)
> > +		return -ENOMEM;
> > +
> > +	xa_for_each(&group->dc_extents, index, dc_extent) {
> > +		if (n == group->nr_extents)
> > +			break;
> > +		devs[n++] = &dc_extent->dev;
> > +	}
> > +
> > +	rc = dax_region_rm_resources(dax_region, devs, n);
> > +	kfree(devs);
> > +	return rc;
> > +}
> > +
> >  static int cxl_dax_region_notify(struct device *dev,
> >  				 struct cxl_notify_data *notify_data)
> >  {
> > @@ -68,10 +101,7 @@ static int cxl_dax_region_notify(struct device *dev,
> >  	case DCD_ADD_CAPACITY:
> >  		return cxl_dax_group_add(dax_region, group);
> >  	case DCD_RELEASE_CAPACITY:
> > -		dev_dbg(&cxlr_dax->dev,
> > -			"DCD RELEASE notify (tag %pUb): no-op (stub)\n",
> > -			&group->uuid);
> > -		return 0;
> > +		return cxl_dax_group_rm(dax_region, group);
> >  	case DCD_FORCED_CAPACITY_RELEASE:
> >  	default:
> >  		dev_err(&cxlr_dax->dev, "Unknown DC event %d\n",
> > diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> > index f2ae5918f94d..414813a6137f 100644
> > --- a/drivers/dax/dax-private.h
> > +++ b/drivers/dax/dax-private.h
> > @@ -146,13 +146,17 @@ struct dax_resource {
> >  };
> >  
> >  /*
> > - * Similar to run_dax() dax_region_add_resource() is exported but is not
> > - * intended to be a generic operation outside the dax subsystem.  It is only
> > + * Similar to run_dax() dax_region_{add,rm}_resource() are exported but are not
> > + * intended to be generic operations outside the dax subsystem.  They are only
> >   * generic between the dax layer and the dax drivers.
> >   */
> >  int dax_region_add_resource(struct dax_region *dax_region, struct device *dev,
> >  			    resource_size_t start, resource_size_t length,
> >  			    const uuid_t *tag, u16 seq_num);
> > +int dax_region_rm_resource(struct dax_region *dax_region,
> > +			   struct device *dev);
> > +int dax_region_rm_resources(struct dax_region *dax_region,
> > +			    struct device * const *devs, unsigned int n);
> >  
> >  static inline struct dev_dax *to_dev_dax(struct device *dev)
> >  {
> 
