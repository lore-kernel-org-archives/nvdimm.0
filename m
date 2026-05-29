Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A234E3403E7
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780077207; cv=none; b=djrzp9Bw0qups+ysmQNVN4dg8IGq++QiwPoHQcCph/SvY+d2Aa227pzSsQvGvW4qsXNttRoYzei1UTEYrBT8R3ewnZEnfeA30kaFFMn281hspZh5zDY26Eqb+Z8lLLEsQ1NhKEK4GoqY3GAb0w0ZznOCkEo0fjMv3P6LjP6yllQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780077207; c=relaxed/simple;
	bh=oc+YdykJsDo5hnUms3pOszdDnlHE1dNt+5tx3RLRNyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=osFEgXK2aFlA364ojLMcpL6OjRkcXbdCn5xNWkLZDCeGFOTIU4LEI6RKeTwwNUV/IALzkNrUAghKDdQvFv6ni7QM5b6QXhV5BGGe1XbH94se+FzlAvyEE/tgZvINuO9kLgim0+d5Fs79gPPcPuQMS7x0lPJNlIfSxW57iywY99U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WDg1126T; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WDg1126T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780077206; x=1811613206;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oc+YdykJsDo5hnUms3pOszdDnlHE1dNt+5tx3RLRNyE=;
  b=WDg1126T6L35g5XQ2J8nU/bZE2Ea5G8oHLJgEhuJKext/2XOxKb7jsdS
   AHIohPG4tTxjpjk6NQZtso2hkbCepmD3f9UI1sGBpRMih+7Y5h7aBnrqx
   P5/Ep6zHAZV2OC949UDgAzmLbR5ESVSw3ySIyNVeU/YJgo5/1rglxWfjY
   4W3JFzGvUzLuL631kibSsDf1sk/0/jBMHl0B3Lb/l39u1/qQghCRs5ZeG
   re8pvoy1tvgfLqIN4aHjqtQ55/Oof5lSbGEcKOCrK+hrANOq/Gxig9snN
   28X45ZcvJKLeTLqeprNyvUjhkCQEIJe5r4QzihyycCmdPFwfqZ3ZhKgL9
   g==;
X-CSE-ConnectionGUID: AvzalgmaTAC46cHDPESkgQ==
X-CSE-MsgGUID: BOx8ntmdRKWsPLg+VclTDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="83511936"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="83511936"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 10:53:25 -0700
X-CSE-ConnectionGUID: k0axKeFhRxip5wsJR6/UVA==
X-CSE-MsgGUID: hOqQrFoPTNaWWLemYekUzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="242117102"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.151]) ([10.125.111.151])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 10:53:24 -0700
Message-ID: <7731c0e2-83e7-4502-a722-8d009532d1a9@intel.com>
Date: Fri, 29 May 2026 10:53:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 26/31] dax/bus: Tag-aware uuid claim and show on DC
 dax devices
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <89784b600e4284772c4136b462e948e016129cdf.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <89784b600e4284772c4136b462e948e016129cdf.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> DC DAX regions are populated with dax_resource children that each carry a
> backing tag uuid and a per-allocation sequence number (seq_num).  Add the
> userspace claim semantics that resolve those tagged groups into DAX
> devices.
> 
> A DC region's seed dax device is created at 0-size on probe; userspace
> populates it by writing to its 'uuid' attribute:
> 
>   * A non-null UUID claims every dax_resource on this region whose tag
>     matches, in seq_num order via uuid_claim_tagged().  The match set
>     must form a dense 1..n sequence (no gap, no duplicate); the CXL
>     side maintains this invariant for both sharable allocations (where
>     the device stamps shared_extn_seq) and non-sharable allocations
>     (where cxl_add_pending assigns arrival-order seq).  The resulting
>     DAX device's size equals the sum of every member extent's size.
> 
>   * "0" claims a single untagged dax_resource via
>     uuid_claim_untagged().  Untagged extents are independent
>     allocations; collapsing several would aggregate unrelated capacity,
>     so each uuid="0" write consumes exactly one untagged resource.
> 
>   * A write that matches no dax_resource returns -ENOENT; the device
>     stays at size 0.
> 
> uuid_show() reads back the backing tag uuid (or the null UUID for an
> untagged claim).  The attribute is read-only (0444) on non-DC dax
> devices; writes to it on non-DC regions return -EOPNOTSUPP.
> 
> dev_dax_visible() exposes the uuid attribute only on DC dax devices.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> [anisa: split out from the original "Surface dc_extents" commit;
>  userspace tag-claim semantics only.]
> ---
>  drivers/dax/bus.c | 260 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 256 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index c030eb103ad0..1dccb3e5cd0f 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -5,6 +5,7 @@
>  #include <linux/mutex.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
> +#include <linux/sort.h>
>  #include <linux/dax.h>
>  #include <linux/io.h>
>  #include "dax-private.h"
> @@ -1316,6 +1317,89 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>  	return 0;
>  }
>  
> +/* DC extents are all-or-nothing: an extent is either free or fully claimed. */
> +static bool dax_resource_in_use(const struct dax_resource *dax_resource)
> +{
> +	return dax_resource->use_cnt > 0;
> +}
> +
> +struct dax_uuid_match {
> +	const struct dax_region *dax_region;
> +	const uuid_t *uuid;
> +};
> +
> +static int find_uuid_extent(struct device *dev, const void *data)
> +{
> +	const struct dax_uuid_match *match = data;
> +	struct dax_resource *dax_resource;
> +
> +	if (!match->dax_region->dc_ops->is_extent(dev))
> +		return 0;
> +
> +	dax_resource = dev_get_drvdata(dev);
> +	if (!dax_resource || dax_resource_in_use(dax_resource))
> +		return 0;
> +	return uuid_equal(&dax_resource->uuid, match->uuid);
> +}
> +
> +struct dax_tag_collect {
> +	const struct dax_region *dax_region;
> +	const uuid_t *uuid;
> +	struct dax_resource **arr;
> +	unsigned int count;
> +	unsigned int cap;
> +};
> +
> +static int collect_uuid_extent(struct device *dev, void *data)
> +{
> +	struct dax_tag_collect *c = data;
> +	struct dax_resource *dax_resource;
> +
> +	if (!c->dax_region->dc_ops->is_extent(dev))
> +		return 0;
> +
> +	dax_resource = dev_get_drvdata(dev);
> +	if (!dax_resource || dax_resource_in_use(dax_resource))
> +		return 0;
> +	if (!uuid_equal(&dax_resource->uuid, c->uuid))
> +		return 0;
> +
> +	if (c->count == c->cap)
> +		return -ENOSPC;
> +	c->arr[c->count++] = dax_resource;
> +	return 0;
> +}
> +
> +static int count_uuid_extent(struct device *dev, void *data)
> +{
> +	struct dax_tag_collect *c = data;
> +	struct dax_resource *dax_resource;
> +
> +	if (!c->dax_region->dc_ops->is_extent(dev))
> +		return 0;
> +
> +	dax_resource = dev_get_drvdata(dev);
> +	if (!dax_resource || dax_resource_in_use(dax_resource))
> +		return 0;
> +	if (!uuid_equal(&dax_resource->uuid, c->uuid))
> +		return 0;
> +
> +	c->count++;
> +	return 0;
> +}
> +
> +static int dax_resource_seq_cmp(const void *a, const void *b)
> +{
> +	const struct dax_resource * const *pa = a;
> +	const struct dax_resource * const *pb = b;
> +
> +	if ((*pa)->seq_num < (*pb)->seq_num)
> +		return -1;
> +	if ((*pa)->seq_num > (*pb)->seq_num)
> +		return 1;
> +	return 0;
> +}
> +
>  static ssize_t size_store(struct device *dev, struct device_attribute *attr,
>  		const char *buf, size_t len)
>  {
> @@ -1548,13 +1632,177 @@ static DEVICE_ATTR_RO(numa_node);
>  static ssize_t uuid_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> -	return sysfs_emit(buf, "%d\n", 0);
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	int rc;
> +
> +	rc = down_read_interruptible(&dax_dev_rwsem);

Since we are here, may as well convert these to ACQUIRE() and be rid of the gotos

ACQUIRE(rwsem_read_intr, rwsem)(&dax_dev_rwsem);
if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
	...


> +	if (rc)
> +		return rc;
> +
> +	for (int i = 0; i < dev_dax->nr_range; i++) {
> +		struct dax_resource *r = dev_dax->ranges[i].dax_resource;
> +
> +		if (r && !uuid_is_null(&r->uuid)) {
> +			rc = sysfs_emit(buf, "%pUb\n", &r->uuid);
> +			goto out;
> +		}
> +	}
> +	rc = sysfs_emit(buf, "0\n");

As pointed out earlyer, should display null_uuid to be consistent.

> +out:
> +	up_read(&dax_dev_rwsem);
> +	return rc;
> +}
> +
> +static ssize_t uuid_claim_untagged(struct dax_region *dax_region,
> +				   struct dev_dax *dev_dax)
> +{
> +	struct dax_uuid_match match = {
> +		.dax_region = dax_region,
> +		.uuid = &uuid_null,
> +	};
> +	struct dax_resource *dax_resource;
> +	resource_size_t to_alloc;
> +	struct device *extent_dev;
> +	ssize_t alloc;
> +
> +	extent_dev = device_find_child(dax_region->dev, &match,
> +				       find_uuid_extent);
> +	if (!extent_dev)
> +		return -ENOENT;
> +
> +	dax_resource = dev_get_drvdata(extent_dev);
> +	to_alloc = resource_size(dax_resource->res);
> +	alloc = __dev_dax_resize(dax_resource->res, dev_dax, to_alloc,
> +				 dax_resource);
> +	put_device(extent_dev);
> +	if (alloc < 0)
> +		return alloc;
> +	if (alloc == 0)
> +		return -ENOENT;
> +	dax_resource->use_cnt++;
> +	return 0;
> +}
> +
> +static ssize_t uuid_claim_tagged(struct dax_region *dax_region,
> +				 struct dev_dax *dev_dax, const uuid_t *uuid)
> +{
> +	struct dax_tag_collect c = {
> +		.dax_region = dax_region,
> +		.uuid = uuid,
> +	};
> +	unsigned int i;
> +	ssize_t rc;
> +
> +	/* Two-pass: count, then collect into a sized array. */
> +	device_for_each_child(dax_region->dev, &c, count_uuid_extent);
> +	if (!c.count)
> +		return -ENOENT;
> +
> +	c.arr = kmalloc_array(c.count, sizeof(*c.arr), GFP_KERNEL);
> +	if (!c.arr)
> +		return -ENOMEM;
> +	c.cap = c.count;
> +	c.count = 0;
> +
> +	rc = device_for_each_child(dax_region->dev, &c, collect_uuid_extent);
> +	if (rc)
> +		goto out;
> +
> +	sort(c.arr, c.count, sizeof(*c.arr), dax_resource_seq_cmp, NULL);
> +
> +	/*
> +	 * Tagged groups carry a dense 1..n @seq_num regardless of source
> +	 * (sharable: device-stamped; non-sharable: host-assigned in
> +	 * arrival order — see &struct dax_resource).  A gap or
> +	 * out-of-range value here means an extent went missing on the
> +	 * cxl side (e.g. a per-extent failure in cxl_add_pending) or a
> +	 * cxl-side validation gap; in either case refuse the whole
> +	 * group rather than carve a partial allocation.
> +	 */
> +	for (i = 0; i < c.count; i++) {
> +		if (c.arr[i]->seq_num != i + 1) {
> +			dev_WARN_ONCE(dax_region->dev, 1,
> +				"tag %pUb seq invariant violated at slot %u (got %u)\n",
> +				uuid, i, c.arr[i]->seq_num);
> +			rc = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	for (i = 0; i < c.count; i++) {
> +		resource_size_t to_alloc = resource_size(c.arr[i]->res);
> +		ssize_t alloc;
> +
> +		alloc = __dev_dax_resize(c.arr[i]->res, dev_dax, to_alloc,
> +					 c.arr[i]);
> +		if (alloc < 0) {
> +			rc = alloc;
> +			goto rollback;
> +		}
> +		if (alloc == 0) {
> +			rc = -ENOSPC;
> +			goto rollback;
> +		}
> +		c.arr[i]->use_cnt++;
> +	}
> +	rc = 0;
> +	goto out;
> +
> +rollback:
> +	/*
> +	 * Partial failure: trim every range we added in this attempt.
> +	 * trim_dev_dax_range pops the most-recently-appended range from
> +	 * dev_dax->ranges[] and decrements its dax_resource->use_cnt, so
> +	 * looping until we have undone @i additions restores both
> +	 * dev_dax->ranges[] and the matched dax_resources' use_cnt.
> +	 */
> +	while (i-- > 0)
> +		trim_dev_dax_range(dev_dax);
> +out:
> +	kfree(c.arr);
> +	return rc;
>  }
>  
>  static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
>  			  const char *buf, size_t len)
>  {
> -	return -EOPNOTSUPP;
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	struct dax_region *dax_region = dev_dax->region;
> +	uuid_t uuid;
> +	ssize_t rc;
> +
> +	if (!is_dynamic(dax_region))
> +		return -EOPNOTSUPP;
> +
> +	if (sysfs_streq(buf, "0"))
> +		uuid_copy(&uuid, &uuid_null);
> +	else {
> +		rc = uuid_parse(buf, &uuid);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	rc = down_write_killable(&dax_region_rwsem);
> +	if (rc)
> +		return rc;
> +	if (!dax_region->dev->driver) {
> +		rc = -ENXIO;
> +		goto err_region;
> +	}
> +	rc = down_write_killable(&dax_dev_rwsem);

same comments about ACQUIRE()

> +	if (rc)
> +		goto err_region;
> +

Does it need to check if the device is already claimed before proceeding to claiming? What happens if the uuid is written twice to this sysfs file?

DJ
> +	if (uuid_is_null(&uuid))
> +		rc = uuid_claim_untagged(dax_region, dev_dax);
> +	else
> +		rc = uuid_claim_tagged(dax_region, dev_dax, &uuid);
> +
> +	up_write(&dax_dev_rwsem);
> +err_region:
> +	up_write(&dax_region_rwsem);
> +
> +	return rc < 0 ? rc : len;
>  }
>  static DEVICE_ATTR_RW(uuid);
>  
> @@ -1614,8 +1862,12 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  		return 0;
>  	if (a == &dev_attr_mapping.attr && is_dynamic(dax_region))
>  		return 0;
> -	if ((a == &dev_attr_align.attr ||
> -	     a == &dev_attr_size.attr) && is_static(dax_region))
> +	if (a == &dev_attr_uuid.attr && !is_dynamic(dax_region))
> +		return 0444;
> +	if (a == &dev_attr_align.attr &&
> +	    (is_static(dax_region) || is_dynamic(dax_region)))
> +		return 0444;
> +	if (a == &dev_attr_size.attr && is_static(dax_region))
>  		return 0444;
>  	return a->mode;
>  }

