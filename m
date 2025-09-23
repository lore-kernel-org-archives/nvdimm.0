Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF50A238C0A
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 10:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758622689; cv=none; b=qvkCtceCXRIzT0TRhH+ZkOwlOAxd0DrKTR1cpdKris/ekpqQ0wqaJlhkiqcvKDeTvdNfCZlCCTXZoyFY32uhvtlSamIX660+HpICat4TGF2NKHLK44Oh/xmIg1YMmlUKgk1b5MqTFFoGCFUMXEDTKhIpFYrkR47Gjt76ME/KQ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758622689; c=relaxed/simple;
	bh=mErpwrnnUt1a4UbgMPITpz273rY3AVhVIAbWJHjwDDE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSkvZu8JB4qGiXWtR6SXMqQatEJADj7uMgA+sXkKAcoN/K7Ptc15OOVEcioggON7MKfIzAXFMXoERVLqW+c/qQElh6NRgU9PKbmY6nYhnxvsNrxsyNyhNqhMZUK9qlzif++6gC+V8F4giu9vIbgUT1ZNtuP2mvcXqo0BzOd6+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cWG7Z1R58z6D92b;
	Tue, 23 Sep 2025 18:15:06 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 367911401DC;
	Tue, 23 Sep 2025 18:18:03 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Sep
 2025 11:18:02 +0100
Date: Tue, 23 Sep 2025 11:18:01 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <dan.j.williams@intel.com>,
	<s.neeraj@samsung.com>
Subject: Re: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
Message-ID: <20250923111801.00001d62@huawei.com>
In-Reply-To: <20250922211330.1433044-1-dave.jiang@intel.com>
References: <20250922211330.1433044-1-dave.jiang@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 22 Sep 2025 14:13:30 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Converting nvdimm_bus_lock/unlock to guard() to clean up usage
> of gotos for error handling and avoid future mistakes of missed
> unlock on error paths.
> 
> Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Hi Dave,

Thanks for looking at this.

Fully agree with Dan about the getting rid of all gotos by end of series.

A few other things inline.  Mostly places where the use of guard()
opens up low hanging fruit that improves readability (+ shortens code).

This code has a lot of dev_dbg() and some of them are so generic I'm not
sure they are actually useful (cover a whole set of error paths).  Perhaps
it is worth splitting some of those up, or reducing the paths that trigger
them as part of this refactor.

Jonathan


>  EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 497fd434a6a1..b35bcbe5db7f 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c

...

> @@ -95,10 +93,9 @@ static ssize_t namespace_show(struct device *dev,
>  	struct nd_btt *nd_btt = to_nd_btt(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	rc = sprintf(buf, "%s\n", nd_btt->ndns
>  			? dev_name(&nd_btt->ndns->dev) : "");


	return sprintf();
and drop the local variable.


> -	nvdimm_bus_unlock(dev);
>  	return rc;
>  }
>  

> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 0ccf4a9e523a..d2c2d71e7fe0 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
>  static int nvdimm_bus_probe(struct device *dev)
> @@ -1177,15 +1175,15 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  		goto out;
>  	}
>  
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
>  	if (rc)
> -		goto out_unlock;
> +		goto out;
>  
>  	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
>  	if (rc < 0)
> -		goto out_unlock;
> +		goto out;
>  
>  	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
>  		struct nd_cmd_clear_error *clear_err = buf;
> @@ -1197,9 +1195,6 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  	if (copy_to_user(p, buf, buf_len))
>  		rc = -EFAULT;
>  
> -out_unlock:
> -	nvdimm_bus_unlock(dev);
> -	device_unlock(dev);
>  out:
Hmm. I'm not a fan of gotos that rely on initializing a bunch of pointers to NULL
so fewer labels are used. Will be nice to replace that as well via __free

Going to need a DEFINE_FREE for the vfree that follow these but that looks standard to me.

>  	kfree(in_env);
>  	kfree(out_env);
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 51614651d2e7..e53a2cc04695 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -35,9 +35,8 @@ void nd_detach_ndns(struct device *dev,
>  	if (!ndns)
>  		return;
>  	get_device(&ndns->dev);
> -	nvdimm_bus_lock(&ndns->dev);
> -	__nd_detach_ndns(dev, _ndns);
> -	nvdimm_bus_unlock(&ndns->dev);
> +	scoped_guard(nvdimm_bus, &ndns->dev)
> +		__nd_detach_ndns(dev, _ndns);
>  	put_device(&ndns->dev);

maybe a guard for this as well? Then you could just use
guards for both rather than needing the scoped guard.



>  }

> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index 37b743acbb7b..a5d44b5c9452 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -104,10 +104,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>  		return -ENODEV;
>  	}
>  
> -	nvdimm_bus_lock(&ndns->dev);
> -	nd_dax = nd_dax_alloc(nd_region);
> -	dax_dev = nd_dax_devinit(nd_dax, ndns);
> -	nvdimm_bus_unlock(&ndns->dev);
> +	scoped_guard(nvdimm_bus, &ndns->dev) {
> +		nd_dax = nd_dax_alloc(nd_region);
> +		dax_dev = nd_dax_devinit(nd_dax, ndns);
> +	}
>  	if (!dax_dev)
>  		return -ENOMEM;
Maybe move this check under the lock? For me that would be a little more obvious
as right next to where it is set.

>  	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 91d9163ee303..2018458a3dba 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -95,13 +95,13 @@ static int nvdimm_probe(struct device *dev)
>  
>  	dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
>  
> -	nvdimm_bus_lock(dev);
> -	if (ndd->ns_current >= 0) {
> -		rc = nd_label_reserve_dpa(ndd);
> -		if (rc == 0)
> -			nvdimm_set_labeling(dev);
> +	scoped_guard(nvdimm_bus, dev) {
> +		if (ndd->ns_current >= 0) {
> +			rc = nd_label_reserve_dpa(ndd);
> +			if (rc == 0)
> +				nvdimm_set_labeling(dev);
> +		}
>  	}
> -	nvdimm_bus_unlock(dev);

This one looks awkward wrt to the goto and put_ndd().
Might not be worth the bother.  I tend to take the view that it is
fine to use guard() for a lock where it helps but not force it to be
used universally if there are places where it doesn't.


>  
>  	if (rc)
>  		goto err;
> @@ -117,9 +117,8 @@ static void nvdimm_remove(struct device *dev)
>  {
>  	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
>  
> -	nvdimm_bus_lock(dev);
> -	dev_set_drvdata(dev, NULL);
> -	nvdimm_bus_unlock(dev);
> +	scoped_guard(nvdimm_bus, dev)
> +		dev_set_drvdata(dev, NULL);
>  	put_ndd(ndd);
>  }
>  
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 21498d461fde..4b293c4ad15c 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c

> @@ -326,7 +326,7 @@ static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
>  		return -ENXIO;
>  
>  	dev = ndd->dev;
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	nfree = nd_label_nfree(ndd);
>  	if (nfree - 1 > nfree) {
>  		dev_WARN_ONCE(dev, 1, "we ate our last label?\n");
> @@ -334,7 +334,6 @@ static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
>  	} else
>  		nfree--;
>  	rc = sprintf(buf, "%d\n", nfree);
> -	nvdimm_bus_unlock(dev);
>  	return rc;

return sprintf() nad drop then then unused rc.


>  }
>  
> @@ -395,12 +394,10 @@ static ssize_t security_store(struct device *dev,
>  	 * done while probing is idle and the DIMM is not in active use
>  	 * in any region.
>  	 */
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	rc = nvdimm_security_store(dev, buf, len);

return nvdimm_security_store()

> -	nvdimm_bus_unlock(dev);
> -	device_unlock(dev);
>  
>  	return rc;
>  }
> @@ -454,9 +451,8 @@ static ssize_t result_show(struct device *dev, struct device_attribute *attr, ch
>  	if (!nvdimm->fw_ops)
>  		return -EOPNOTSUPP;
>  
> -	nvdimm_bus_lock(dev);
> -	result = nvdimm->fw_ops->activate_result(nvdimm);
> -	nvdimm_bus_unlock(dev);
> +	scoped_guard(nvdimm_bus, dev)

Maybe just guard?  Seems unlikely to matter if we do the prints under the lock.

> +		result = nvdimm->fw_ops->activate_result(nvdimm);
>  
>  	switch (result) {
>  	case NVDIMM_FWA_RESULT_NONE:
> @@ -483,9 +479,8 @@ static ssize_t activate_show(struct device *dev, struct device_attribute *attr,
>  	if (!nvdimm->fw_ops)
>  		return -EOPNOTSUPP;
>  
> -	nvdimm_bus_lock(dev);
> -	state = nvdimm->fw_ops->activate_state(nvdimm);
> -	nvdimm_bus_unlock(dev);
> +	scoped_guard(nvdimm_bus, dev)
Similar to above. I'd just hold it to function exit to simplify the code a little.

> +		state = nvdimm->fw_ops->activate_state(nvdimm);
>  
>  	switch (state) {
>  	case NVDIMM_FWA_IDLE:
..


> @@ -641,11 +634,11 @@ void nvdimm_delete(struct nvdimm *nvdimm)
>  	bool dev_put = false;
>  
>  	/* We are shutting down. Make state frozen artificially. */
> -	nvdimm_bus_lock(dev);
> -	set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
> -	if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
> -		dev_put = true;
> -	nvdimm_bus_unlock(dev);
> +	scoped_guard(nvdimm_bus, dev) {
> +		set_bit(NVDIMM_SECURITY_FROZEN, &nvdimm->sec.flags);
> +		if (test_and_clear_bit(NDD_WORK_PENDING, &nvdimm->flags))
> +			dev_put = true;
Not sure why this isn't

		dev_put = test_and_clear_bit();

Maybe some earlier refactoring left this somewhat odd bit of code or


> +	}
>  	cancel_delayed_work_sync(&nvdimm->dwork);
>  	if (dev_put)
>  		put_device(dev);
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..38933abfb2a6 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c

...

> @@ -893,9 +888,8 @@ resource_size_t nvdimm_namespace_capacity(struct nd_namespace_common *ndns)
>  {
>  	resource_size_t size;
>  
> -	nvdimm_bus_lock(&ndns->dev);
> +	guard(nvdimm_bus)(&ndns->dev);
>  	size = __nvdimm_namespace_capacity(ndns);
> -	nvdimm_bus_unlock(&ndns->dev);
>  
>  	return size;
	
	return __nvdimm_namespace_capacity(ndns);

>  }

> @@ -1119,8 +1111,8 @@ static ssize_t sector_size_store(struct device *dev,
>  	} else
>  		return -ENXIO;
>  
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (to_ndns(dev)->claim)
>  		rc = -EBUSY;
>  	if (rc >= 0)

There is a bit mess of if (rc >= 0)
stuff in here that could just become early exits and generally result I think
in more readable code flow (enabled by the guard() usage)  The side effect
being the dev_dbg() might need to be replicated but it could ten say what actually
happened rather than current case of one of 3 things failed.

	if (to_ndns(dev)->claim) {
		dev_dbg(dev...)
		return -EBUSY;
	}
	rc = nd_size_select_store();
	if (rc < 0) {
		dev_dbg()
		return rc;
	}
	rc = nd_namespace_label_update(nd_region, dev);
	if (rc < 0) {
		dev_dbg();  // if all these are actually useful given we know what we wrote and what failed.
		return rc;
	}


> @@ -1145,7 +1135,7 @@ static ssize_t dpa_extents_show(struct device *dev,
>  	int count = 0, i;
>  	u32 flags = 0;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (is_namespace_pmem(dev)) {
>  		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
>  
> @@ -1167,8 +1157,6 @@ static ssize_t dpa_extents_show(struct device *dev,
>  				count++;
>  	}
>   out:

Can drop this and return early particularly as it's just
	return sprintf(buf, "0\n");
in that one path.


> -	nvdimm_bus_unlock(dev);
> -
>  	return sprintf(buf, "%d\n", count);
>  }
>  static DEVICE_ATTR_RO(dpa_extents);

> @@ -2152,31 +2138,38 @@ static int init_active_labels(struct nd_region *nd_region)
>  					nd_region);
>  }
>  
> +static int __create_namespaces(struct nd_region *nd_region, int *type,
naming is a little odd given it calls create_namespaces internally.
Maybe

create_relevant_namespace() or something along those lines.
Or rename the create_namespaces() to be PMEM specific and reuse
that name for the wrapper.


> +			       struct device ***devs)
> +{
> +	int rc;
> +
> +	guard(nvdimm_bus)(&nd_region->dev);
> +	rc = init_active_labels(nd_region);
> +	if (rc)
> +		return rc;
> +
> +	*type = nd_region_to_nstype(nd_region);
> +	switch (*type) {
> +	case ND_DEVICE_NAMESPACE_IO:
> +		*devs = create_namespace_io(nd_region);
> +		break;
> +	case ND_DEVICE_NAMESPACE_PMEM:
> +		*devs = create_namespaces(nd_region);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
>  {
>  	struct device **devs = NULL;
>  	int i, rc = 0, type;
>  
>  	*err = 0;
> -	nvdimm_bus_lock(&nd_region->dev);
> -	rc = init_active_labels(nd_region);
> -	if (rc) {
> -		nvdimm_bus_unlock(&nd_region->dev);
> +	rc = __create_namespaces(nd_region, &type, &devs);
> +	if (rc)
>  		return rc;
> -	}
> -
> -	type = nd_region_to_nstype(nd_region);
> -	switch (type) {
> -	case ND_DEVICE_NAMESPACE_IO:
> -		devs = create_namespace_io(nd_region);
> -		break;
> -	case ND_DEVICE_NAMESPACE_PMEM:
> -		devs = create_namespaces(nd_region);
> -		break;
> -	default:
> -		break;
> -	}
> -	nvdimm_bus_unlock(&nd_region->dev);
>  
>  	if (!devs)
>  		return -ENODEV;
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index cc5c8f3f81e8..a8013033509c 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -632,6 +632,8 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
>  u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
>  void nvdimm_bus_lock(struct device *dev);
>  void nvdimm_bus_unlock(struct device *dev);
> +DEFINE_GUARD(nvdimm_bus, struct device *, nvdimm_bus_lock(_T), nvdimm_bus_unlock(_T));

You want that if (_T) or the IS_ERR_OR_NULL variant if appropriate.
Technically not needed, but as Peter Z pointed out in a similar case, sometimes the compiler
might spot that _T is always NULL in a path and optimize out the call.  So he was
very keen to keep that guard in the definition unless the the cleanup was also visible
(As an inline in the header for instance).

> +
>  bool is_nvdimm_bus_locked(struct device *dev);
>  void nvdimm_check_and_set_ro(struct gendisk *disk);
>  void nvdimm_drvdata_release(struct kref *kref);
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 8f3e816e805d..f2a44d1f62be 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -57,8 +57,8 @@ static ssize_t mode_store(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc = 0;
>  
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (dev->driver)
>  		rc = -EBUSY;

Maybe just do an early return here.  Is it really that useful to
see anything other than -EBUSY?  If so maybe have a new dev_dbg()
for this path. Nice to reduce the indent on the rest.

>  	else {
> @@ -78,8 +78,6 @@ static ssize_t mode_store(struct device *dev,
>  	}
>  	dev_dbg(dev, "result: %zd wrote: %s%s", rc, buf,
>  			buf[len - 1] == '\n' ? "" : "\n");
> -	nvdimm_bus_unlock(dev);
> -	device_unlock(dev);
>  
>  	return rc ? rc : len;
>  }

> @@ -170,10 +166,9 @@ static ssize_t namespace_show(struct device *dev,
>  	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	rc = sprintf(buf, "%s\n", nd_pfn->ndns
>  			? dev_name(&nd_pfn->ndns->dev) : "");
> -	nvdimm_bus_unlock(dev);
>  	return rc;

return sprintf()

>  }

...


> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index de1ee5ebc851..b2b4519e9f4c 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c

> +int nd_region_activate(struct nd_region *nd_region)
> +{
> +	int i, j, rc, num_flush;
> +	struct nd_region_data *ndrd;
> +	struct device *dev = &nd_region->dev;
> +	size_t flush_data_size;
> +
> +	rc = get_flush_data(nd_region, &flush_data_size, &num_flush);
> +	if (rc)
> +		return rc;
>  
>  	rc = nd_region_invalidate_memregion(nd_region);
>  	if (rc)
> @@ -327,8 +340,8 @@ static ssize_t set_cookie_show(struct device *dev,
>  	 * the v1.1 namespace label cookie definition. To read all this
>  	 * data we need to wait for probing to settle.
>  	 */
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	if (nd_region->ndr_mappings) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
> @@ -343,8 +356,6 @@ static ssize_t set_cookie_show(struct device *dev,
>  						nsindex));
>  		}
>  	}
> -	nvdimm_bus_unlock(dev);
> -	device_unlock(dev);
>  
>  	if (rc)
>  		return rc;
> @@ -401,12 +412,10 @@ static ssize_t available_size_show(struct device *dev,
>  	 * memory nvdimm_bus_lock() is dropped, but that's userspace's
>  	 * problem to not race itself.
>  	 */
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	available = nd_region_available_dpa(nd_region);
> -	nvdimm_bus_unlock(dev);
> -	device_unlock(dev);
>  
>  	return sprintf(buf, "%llu\n", available);

Could role this together without I think any real loss of readability.

	return sprintf(buf, "%llu\n", nd_region_available_dpa(nd_region));

>  }
> @@ -418,12 +427,10 @@ static ssize_t max_available_extent_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	unsigned long long available = 0;
>  
> -	device_lock(dev);
> -	nvdimm_bus_lock(dev);
> +	guard(device)(dev);
> +	guard(nvdimm_bus)(dev);
>  	wait_nvdimm_bus_probe_idle(dev);
>  	available = nd_region_allocatable_dpa(nd_region);
> -	nvdimm_bus_unlock(dev);
> -	device_unlock(dev);
>  
>  	return sprintf(buf, "%llu\n", available);
Similarly.

>  }
> @@ -435,12 +442,11 @@ static ssize_t init_namespaces_show(struct device *dev,
>  	struct nd_region_data *ndrd = dev_get_drvdata(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (ndrd)
>  		rc = sprintf(buf, "%d/%d\n", ndrd->ns_active, ndrd->ns_count);
>  	else
>  		rc = -ENXIO;
> -	nvdimm_bus_unlock(dev);
>  
>  	return rc;
I'd do
	if (!ndrd)
		return -ENXIO;

	return sprintf();
>  }
> @@ -452,12 +458,11 @@ static ssize_t namespace_seed_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (nd_region->ns_seed)
>  		rc = sprintf(buf, "%s\n", dev_name(nd_region->ns_seed));
>  	else
>  		rc = sprintf(buf, "\n");
> -	nvdimm_bus_unlock(dev);
>  	return rc;

likewise, I'd just return directly in each of the legs

>  }
>  static DEVICE_ATTR_RO(namespace_seed);
> @@ -468,12 +473,11 @@ static ssize_t btt_seed_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (nd_region->btt_seed)
>  		rc = sprintf(buf, "%s\n", dev_name(nd_region->btt_seed));
>  	else
>  		rc = sprintf(buf, "\n");
> -	nvdimm_bus_unlock(dev);
>  
>  	return rc;

Here as well.

>  }
> @@ -485,12 +489,11 @@ static ssize_t pfn_seed_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (nd_region->pfn_seed)
>  		rc = sprintf(buf, "%s\n", dev_name(nd_region->pfn_seed));
>  	else
>  		rc = sprintf(buf, "\n");
> -	nvdimm_bus_unlock(dev);
>  
>  	return rc;
A common theme is emerging ;)

>  }
> @@ -502,12 +505,11 @@ static ssize_t dax_seed_show(struct device *dev,
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	ssize_t rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	if (nd_region->dax_seed)
>  		rc = sprintf(buf, "%s\n", dev_name(nd_region->dax_seed));
>  	else
>  		rc = sprintf(buf, "\n");
> -	nvdimm_bus_unlock(dev);
And again.
>  
>  	return rc;
>  }


> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index a03e3c45f297..e70dc3b08458 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -221,9 +221,8 @@ int nvdimm_security_unlock(struct device *dev)
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
>  	int rc;
>  
> -	nvdimm_bus_lock(dev);
> +	guard(nvdimm_bus)(dev);
>  	rc = __nvdimm_security_unlock(nvdimm);
> -	nvdimm_bus_unlock(dev);
>  	return rc;
return __nvdimm_se...

>  }
>  
