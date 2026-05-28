Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B6135AC10
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 22:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008250; cv=none; b=gZ6k8/iLsS62lPRJd7D19KD3pEVlB6qxYFWopQDy4RA1Tdw6Two7cem4xYmAMg/hKVez0WYFNudB3Rw9tqJBtSoAWW24sfp2gb/8jvb+lcZkA/IafxhFm+5qN/RDk7/WsvNr7UkM8AblA3Tt/5S3S0NgrDJ4pO+tDECOzt7/4v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008250; c=relaxed/simple;
	bh=EQ+aTmDuIy1QxrE7HxhKMyjT0gTgnPIPHq1ZbpIc+zY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/hfwwKcKBbBl02B+sbCs9EW68EK4GBQP14YMXA6YLOGtklenwPUrIPf8+PxgCnStk1UJess3OxEAngdEPy49I1GqciXOEkWAonxvksa9VI9D3ELwpD90EgsJ0SxfuAm3uv0eVj2PovOtCAehcLa9Qv2XGV5nr4Bmxgk+osQWEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ot5nBssP; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ot5nBssP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780008249; x=1811544249;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EQ+aTmDuIy1QxrE7HxhKMyjT0gTgnPIPHq1ZbpIc+zY=;
  b=Ot5nBssPQXwwLpua/+GAOFSrpATrzq3uk9b2LdMu3qn9fUKxiOoUUw//
   CTCBS27HFZApkRCGWwatQt0WfbTaQQztjhrenPGABz59Z+xFFT7bG+9Ar
   OH0ZR0a4d8sdj1ySpUFxbjR8jx+KgDZHfH70dCQeQpZmSxSkXqIxWtyNd
   IeBdCyRd828Q5DSE/ZgokmZLpZlWVt7OwKcffkbIZOXld2exOTzzQg+g6
   3ZEVV/Qq3QsLhV4m5kqlF4Bu7VfqSkB/H2WP/Z7gMKE5c7Yqyj8tn5e+y
   B0ZsEqm27uUVWGJ7kvL1R1BcWvagHwMNVDUb8ZOgI1gQoRHKFmTRUtil4
   A==;
X-CSE-ConnectionGUID: IswVsJmzR0SrZ7SpPq5c3Q==
X-CSE-MsgGUID: Khp2B/7sSaGdBuObbMOfvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80974341"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80974341"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:44:08 -0700
X-CSE-ConnectionGUID: hABSmAGfT+Obe2eJ1hcJBQ==
X-CSE-MsgGUID: ob61pm+xSbu3tgSJ54XPlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="242778093"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:44:07 -0700
Message-ID: <690d607e-ba61-43d2-a97e-ece40dfbc22c@intel.com>
Date: Thu, 28 May 2026 15:44:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 19/31] cxl/extent: Enforce cross-region tag uniqueness
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <8f4aa2f5da26221efdd85650578c953657466e0f.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <8f4aa2f5da26221efdd85650578c953657466e0f.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> The per-region scan in cxl_tag_already_committed() only catches a tag
> re-appearing on the same cxlr_dax.  The orchestrator owns tag
> allocation and is responsible for global uniqueness, but a buggy FM
> (or firmware redelivering a tag for a previously-closed allocation)
> can still hand the same uuid to extents on two different regions or
> memdevs, and the per-region check accepts the second one — leaving
> two independent cxl_dc_tag_group objects with the same uuid.
> 
> Add a host-wide registry of live tag groups with non-null uuids.
> alloc_tag_group() inserts on success, free_tag_group() removes; both
> skip the null-uuid case since the spec defines no cross-chain identity
> for untagged allocations.
> 
> An attempt to add a second group with the same uuid fails with
> -EBUSY.
> 
> No exit hook is needed: cxl_core only unloads after every dependent
> module has, by which point every live tag group has been freed and
> the registry is empty.
> 
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/core/core.h   |  5 ++++
>  drivers/cxl/core/extent.c | 60 +++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c   | 19 +++++++++++++
>  drivers/cxl/cxl.h         |  3 ++
>  4 files changed, 87 insertions(+)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 65daaaadf68e..02b36728c22d 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -69,6 +69,7 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
>  
>  int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
>  		   u16 seq_num);
> +bool cxl_tag_already_committed(const uuid_t *tag);
>  int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
>  int online_tag_group(struct cxl_dc_tag_group *group);
>  #else
> @@ -91,6 +92,10 @@ static inline int online_tag_group(struct cxl_dc_tag_group *group)
>  {
>  	return 0;
>  }
> +static inline bool cxl_tag_already_committed(const uuid_t *tag)
> +{
> +	return false;
> +}
>  static inline
>  struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
>  				     struct cxl_endpoint_decoder **cxled)
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 51116c8139ed..f66fa8c600c5 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -18,8 +18,60 @@ static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
>  	memdev_release_extent(mds, &dc_extent->dpa_range);
>  }
>  
> +/*
> + * Host-wide registry of live tag groups with non-null uuids.  Enforces
> + * that within this host, a tag uuid identifies exactly one allocation
> + * across all regions and memdevs — closing the gap left by the
> + * per-region scans in cxlr_add_extent() and uuid_claim_tagged().  The
> + * orchestrator (FM) owns tag-uuid allocation per spec; this is a
> + * defense against firmware bugs and orchestrator misbehavior.  Untagged
> + * (null uuid) allocations are not tracked: the spec defines no
> + * cross-chain identity for them.
> + */
> +static DEFINE_MUTEX(cxl_tag_lock);
> +static LIST_HEAD(cxl_tag_groups);
> +
> +static int cxl_tag_register(struct cxl_dc_tag_group *grp)
> +{
> +	struct cxl_dc_tag_group *g;
> +
> +	if (uuid_is_null(&grp->uuid))
> +		return 0;
> +
> +	guard(mutex)(&cxl_tag_lock);
> +	list_for_each_entry(g, &cxl_tag_groups, registry_node)
> +		if (uuid_equal(&g->uuid, &grp->uuid))
> +			return -EBUSY;
> +	list_add_tail(&grp->registry_node, &cxl_tag_groups);
> +	return 0;
> +}
> +
> +static void cxl_tag_unregister(struct cxl_dc_tag_group *grp)
> +{
> +	if (uuid_is_null(&grp->uuid))
> +		return;
> +
> +	guard(mutex)(&cxl_tag_lock);
> +	list_del(&grp->registry_node);
> +}
> +
> +bool cxl_tag_already_committed(const uuid_t *tag)
> +{
> +	struct cxl_dc_tag_group *g;
> +
> +	if (uuid_is_null(tag))
> +		return false;
> +
> +	guard(mutex)(&cxl_tag_lock);
> +	list_for_each_entry(g, &cxl_tag_groups, registry_node)
> +		if (uuid_equal(&g->uuid, tag))
> +			return true;
> +	return false;
> +}
> +
>  static void free_tag_group(struct cxl_dc_tag_group *group)
>  {
> +	cxl_tag_unregister(group);
>  	xa_destroy(&group->dc_extents);
>  	kfree(group);
>  }
> @@ -54,12 +106,20 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
>  {
>  	struct cxl_dc_tag_group *group __free(kfree) =
>  				kzalloc(sizeof(*group), GFP_KERNEL);
> +	int rc;
> +
>  	if (!group)
>  		return ERR_PTR(-ENOMEM);
>  
>  	group->cxlr_dax = cxlr_dax;
>  	uuid_copy(&group->uuid, uuid);
>  	xa_init(&group->dc_extents);
> +	INIT_LIST_HEAD(&group->registry_node);
> +
> +	rc = cxl_tag_register(group);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
>  	return no_free_ptr(group);
>  }
>  
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 70e6c4c9743c..85959dee35ea 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1474,6 +1474,25 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
>  		extract_tag_group(pending, &tag, &group);
>  		list_sort(NULL, &group, extent_seq_compare);
>  
> +		/*
> +		 * Cross-More-chain uniqueness.  A non-null tag seen in this
> +		 * group must not already correspond to a committed tag group
> +		 * anywhere on this host.  More=0 was supposed to close that
> +		 * allocation, and tag uuids must be unique across all regions
> +		 * and memdevs (the orchestrator owns assignment per spec).
> +		 * Either constraint failing — same chain redelivered, or two
> +		 * distinct allocations colliding on the same uuid — is a
> +		 * firmware/orchestrator bug; reject the whole group.
> +		 */
> +		if (cxl_tag_already_committed(&tag)) {
> +			dev_warn(dev,
> +				 "Tag %pUb: dropping group, tag already committed (firmware/orchestrator bug)\n",
> +				 &tag);
> +			list_for_each_entry_safe(pos, tmp, &group, list)
> +				delete_extent_node(pos);
> +			continue;
> +		}
> +
>  		/* Sequence-number integrity */
>  		if (cxl_check_group_seq(dev, &tag, &group)) {
>  			list_for_each_entry_safe(pos, tmp, &group, list)
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index cbbfba92fea9..a28e7b12a4a8 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -598,12 +598,15 @@ struct cxl_dax_region {
>   *		allocations.
>   * @nr_extents: live count of dc_extents in the group; the group is freed
>   *		when the last dc_extent device is released.
> + * @registry_node: anchor in the host-wide non-null-tag registry that
> + *		enforces tag uuid uniqueness across all regions and memdevs.
>   */
>  struct cxl_dc_tag_group {
>  	struct cxl_dax_region *cxlr_dax;
>  	uuid_t uuid;
>  	struct xarray dc_extents;
>  	unsigned int nr_extents;
> +	struct list_head registry_node;
>  };
>  
>  bool is_dc_extent(struct device *dev);

