Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5617032ED4E
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 19:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779995222; cv=none; b=B/q2ST+5GK3vAu2/zD9Tv1lyIQr5uc0Xq0ZQMi8qjMmstaPqnOdBVLWriF1WAMb6+UBTL++yn8GQGzGZObpQS31p/7J+DNWfgK8FdJthpzdRYeUDhrEtTtTfZYZXBdlOC1r5uFUiq3vtAx2+gSHPeeqckh+Zpr/Ec+mENrmRc0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779995222; c=relaxed/simple;
	bh=KGafXqJBk5+8VloUP2rMPp7DzKN4JJqvlyMtizEMvws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJtdipP3GshsIgkOyyCJ1anpsFJLeAVVIZdw/bTXlBN3yCbeKhpDEgTn1dE827zboYjfR8oke0f7MedUJFoXi630fnUOcK/Cw48k+12U5jJSmPQChex6l8NTAA/7eREf/6hzPVTqcQ29AIBe3Pj5ooFDtTfQlN9d94jtFOXzwc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lX30Mf+W; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lX30Mf+W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779995219; x=1811531219;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KGafXqJBk5+8VloUP2rMPp7DzKN4JJqvlyMtizEMvws=;
  b=lX30Mf+Wz5iKbyrho5QFLOk1pGJrROk49pH9gkbLKshCQRlID4chjVe2
   WloYKhc6qoGs1Agy+d+xi+B9H3V06FcaxGVXErP4PbtUrE+XNPip/R4Nb
   pzhtRPxDPy2YhmrDC5B3K5lfeaBw5IOHZPSjd3+yiG417x4YUsec4GvoP
   YvOjQ5sGAKP4907xDvv4XjEaiKaqhM4NM5deRY84NLwVYyUUnJwGuBQHQ
   lIURcw0aNIHGxSUOBx1DIz+ywxqIuJnv5s82H7VKLJ35MfIjcvKwfYQPw
   cz5hGw09DHd+sOtYMeKDkJxQwlJjAU1jG7gibCxI4nCXEJcEidfrHQ7az
   g==;
X-CSE-ConnectionGUID: 6AfpBEoRQN2CsJmPgVWxtw==
X-CSE-MsgGUID: oWRom1ASSDSv13QVWzJxJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80698699"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80698699"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 12:06:59 -0700
X-CSE-ConnectionGUID: Va0pBG42SE+HdXZG53Bd4w==
X-CSE-MsgGUID: xwgPqTPfTwqMh3knRjFKUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="239612626"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 12:06:57 -0700
Message-ID: <f7f665f7-7423-4279-92ad-e1f8f87b1e7e@intel.com>
Date: Thu, 28 May 2026 12:06:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 14/31] cxl/extent: Handle DC Add Capacity events
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>, Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <22f480966589928b457ed34ee291161c8cf5af75.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <22f480966589928b457ed34ee291161c8cf5af75.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> Replace the empty-response stub in handle_add_event() with the real
> add pipeline.
> 
> DC Event Records can be grouped together with the 'More' flag. The
> previous commit completed the set up for holding onto extents in
> the pending list until receiving the last event record of the group,
> marked by 'More'=0.
> 
> This commit fills in the logic for processing the pending list and
> adds basic validation for extents before they are added to the
> device model as a child of the cxlr_dax region. More complete
> checks for tags/sequence numbers/alignment is added in subsequent commits.
> 
> For each tag that appears in the pending list:
> 1. Extract all extents in the pending list with that tag to a
>    local list.
> 
> 2. The spec requires that shareable extents are ordered by
>    shared extent sequence number, which "instructs each host
>    on the relative order these extents must be placed in adjacent
>    virtual address space" (r4.0 Section 9.13.3 Figure 9-23
>    Shared Extent List Example). Otherwise, retain arrival order.
> 
>    Thus the tag group is stable-sorted by shared_extn_seq; for non-sharable
>    extents every key is 0 and the stable sort preserves arrival
>    order.
> 
> Individual extents are checked for the following:
> 1. The extent's DPA range fully resolves to an endpoint decoder.
> 
> 2. Doesn't overlap with a previously accepted extent.
> 
> 3. Sequence number doesn't collide with others in the same
> tag group
> 
> Upon passing these checks, extents are "onlined" together
> as a tag group:
> online_tag_group() registers a struct device per
> dc_extent under cxlr_dax->dev so the dax layer can discover them
> via device_for_each_child().
> 
> Once the pending list has been fully processed, send the
> DC_ADD_RESPONSE.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> [anisa: restructured from the original "Process dynamic partition
>  events" monolith; this commit fills in the Add path on top of the
>  previous commit's stubs. Further validation lands in subsequent
>  commits.]
> ---
>  drivers/cxl/core/Makefile     |   2 +-
>  drivers/cxl/core/core.h       |  13 ++
>  drivers/cxl/core/extent.c     | 372 ++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/mbox.c       | 123 ++++++++++-
>  drivers/cxl/core/region_dax.c |   3 +
>  drivers/cxl/cxl.h             |  19 ++
>  tools/testing/cxl/Kbuild      |   5 +-
>  7 files changed, 528 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/cxl/core/extent.c
> 
> diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> index ce7213818d3c..208917ad8aac 100644
> --- a/drivers/cxl/core/Makefile
> +++ b/drivers/cxl/core/Makefile
> @@ -15,7 +15,7 @@ cxl_core-y += hdm.o
>  cxl_core-y += pmu.o
>  cxl_core-y += cdat.o
>  cxl_core-$(CONFIG_TRACING) += trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += region.o region_pmem.o region_dax.o
> +cxl_core-$(CONFIG_CXL_REGION) += region.o region_pmem.o region_dax.o extent.o
>  cxl_core-$(CONFIG_CXL_MCE) += mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 14723cfd05f0..1bae80dbf991 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -65,12 +65,24 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
>  int devm_cxl_add_dax_region(struct cxl_region *cxlr);
>  int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
>  
> +int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
> +		   u16 seq_num);
> +int online_tag_group(struct cxl_dc_tag_group *group);
>  #else
>  static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
>  				 const struct cxl_memdev *cxlmd, u64 dpa)
>  {
>  	return ULLONG_MAX;
>  }
> +static inline int cxl_add_extent(struct cxl_memdev_state *mds,
> +				 struct cxl_extent *extent, u16 seq_num)
> +{
> +	return 0;
> +}
> +static inline int online_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	return 0;
> +}
>  static inline
>  struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
>  				     struct cxl_endpoint_decoder **cxled)
> @@ -166,6 +178,7 @@ long cxl_pci_get_latency(struct pci_dev *pdev);
>  int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c);
>  int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
>  					struct access_coordinate *c);
> +void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
>  
>  static inline struct device *port_to_host(struct cxl_port *port)
>  {
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> new file mode 100644
> index 000000000000..94128d06f4ed
> --- /dev/null
> +++ b/drivers/cxl/core/extent.c
> @@ -0,0 +1,372 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  Copyright(c) 2024 Intel Corporation. All rights reserved. */
> +
> +#include <linux/device.h>
> +#include <cxl.h>
> +
> +#include "core.h"
> +
> +
> +static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
> +				 struct dc_extent *dc_extent)
> +{
> +	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
> +	struct device *dev = &cxled->cxld.dev;
> +
> +	dev_dbg(dev, "Remove extent %pra (%pU)\n",
> +		&dc_extent->dpa_range, &dc_extent->uuid);
> +	memdev_release_extent(mds, &dc_extent->dpa_range);
> +}
> +
> +static void free_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	xa_destroy(&group->dc_extents);
> +	kfree(group);
> +}
> +
> +static void dc_extent_release(struct device *dev)
> +{
> +	struct dc_extent *dc_extent = to_dc_extent(dev);

to_dc_extent() can return NULL. Need to check dc_extent before use.

> +	struct cxl_dc_tag_group *group = dc_extent->group;
> +
> +	cxled_release_extent(dc_extent->cxled, dc_extent);
> +	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);

This could potentially be a problem. See comments later with online_tag_group()

> +	xa_erase(&group->dc_extents, dc_extent->seq_num);
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +	kfree(dc_extent);
> +}
> +
> +static const struct device_type dc_extent_type = {
> +	.name = "extent",
> +	.release = dc_extent_release,
> +};
> +
> +bool is_dc_extent(struct device *dev)
> +{
> +	return dev->type == &dc_extent_type;
> +}
> +EXPORT_SYMBOL_NS_GPL(is_dc_extent, "CXL");
> +
> +static struct cxl_dc_tag_group *
> +alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
> +{
> +	struct cxl_dc_tag_group *group __free(kfree) =
> +				kzalloc(sizeof(*group), GFP_KERNEL);
> +	if (!group)
> +		return ERR_PTR(-ENOMEM);
> +
> +	group->cxlr_dax = cxlr_dax;
> +	uuid_copy(&group->uuid, uuid);
> +	xa_init(&group->dc_extents);
> +	return no_free_ptr(group);
> +}
> +
> +/*
> + * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
> + * to its region/endpoint decoder and ext_range, and verify the range
> + * fits in the resolved endpoint decoder's DPA resource.  Further
> + * per-extent invariants layer into this function in subsequent commits.
> + *
> + * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
> + * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
> + * resolved handles consumed by the rest of the pipeline.
> + */
> +static int cxl_validate_extent(struct cxl_memdev_state *mds,
> +			       struct cxl_extent *extent,
> +			       struct cxl_endpoint_decoder **out_cxled,
> +			       struct cxl_dax_region **out_cxlr_dax,
> +			       struct range *out_ext_range)
> +{
> +	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> +	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_region *cxlr;
> +	struct range ext_range = (struct range) {
> +		.start = start_dpa,
> +		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> +	};
> +	struct range ed_range;
> +
> +	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> +	if (!cxlr)
> +		return -ENXIO;
> +
> +	ed_range = (struct range) {
> +		.start = cxled->dpa_res->start,
> +		.end = cxled->dpa_res->end,
> +	};
> +	if (!range_contains(&ed_range, &ext_range)) {
> +		dev_err_ratelimited(&cxled->cxld.dev,
> +				    "DC extent DPA %pra (%pU) is not fully in ED %pra\n",
> +				    &ext_range, extent->uuid, &ed_range);
> +		return -ENXIO;
> +	}
> +
> +	*out_cxled = cxled;
> +	*out_cxlr_dax = cxlr->cxlr_dax;

Should there be check for cxled and cxlr->cxlr_dax to make sure they aren't NULL?

> +	*out_ext_range = ext_range;
> +	return 0;
> +}
> +
> +enum cxl_extent_class {
> +	CXL_EXT_NEW,
> +	CXL_EXT_DUPLICATE,
> +	CXL_EXT_OVERLAP,
> +};
> +
> +/*
> + * Stage 2: classify @ext_range against extents already accepted on this
> + * cxlr_dax+cxled.  Walks cxlr_dax->dc_extents once: a stored extent that
> + * fully contains @ext_range means a duplicate accept (idempotent, fine);
> + * a stored extent that only overlaps means an inconsistent offer.
> + */
> +static enum cxl_extent_class
> +cxlr_dax_classify_extent(struct cxl_dax_region *cxlr_dax,
> +			 struct cxl_endpoint_decoder *cxled,
> +			 const struct range *ext_range)
> +{
> +	struct dc_extent *entry;
> +	unsigned long i;
> +
> +	xa_for_each(&cxlr_dax->dc_extents, i, entry) {
> +		if (entry->cxled != cxled)
> +			continue;
> +		if (range_contains(&entry->dpa_range, ext_range))
> +			return CXL_EXT_DUPLICATE;
> +		if (range_overlaps(&entry->dpa_range, ext_range))
> +			return CXL_EXT_OVERLAP;
> +	}
> +	return CXL_EXT_NEW;
> +}
> +
> +/*
> + * Stage 3: allocate and populate a dc_extent for an already-validated,
> + * already-classified-as-new @ext_range.  Only -ENOMEM can fail here.
> + */
> +static struct dc_extent *
> +dc_extent_build(struct cxl_endpoint_decoder *cxled,
> +		struct cxl_dax_region *cxlr_dax,
> +		struct cxl_extent *extent,
> +		const struct range *ext_range, u16 seq_num)
> +{
> +	resource_size_t dpa_offset = ext_range->start - cxled->dpa_res->start;
> +	resource_size_t hpa = cxled->cxld.hpa_range.start + dpa_offset;
> +	struct dc_extent *dc_extent;
> +
> +	dc_extent = kzalloc(sizeof(*dc_extent), GFP_KERNEL);
> +	if (!dc_extent)
> +		return ERR_PTR(-ENOMEM);
> +
> +	dc_extent->cxled = cxled;
> +	dc_extent->dpa_range = *ext_range;
> +	dc_extent->hpa_range.start = hpa - cxlr_dax->hpa_range.start;
> +	dc_extent->hpa_range.end = dc_extent->hpa_range.start +
> +				   range_len(ext_range) - 1;
> +	dc_extent->seq_num = seq_num;
> +	import_uuid(&dc_extent->uuid, extent->uuid);
> +	return dc_extent;
> +}
> +
> +/*
> + * Stage 4: insert @dc_extent into the pending tag group.  All extents in
> + * one More-chain group share a UUID — enforced here as the group is
> + * either being created (first extent) or appended to.  On any failure
> + * the dc_extent is freed.
> + */
> +static int cxlr_add_extent(struct cxl_memdev_state *mds,
> +			   struct cxl_dax_region *cxlr_dax,
> +			   struct dc_extent *dc_extent)
> +{
> +	struct cxl_dc_tag_group **group = &mds->add_ctx.group;
> +	int rc;
> +
> +	if (*group && !uuid_equal(&(*group)->uuid, &dc_extent->uuid)) {
> +		kfree(dc_extent);
> +		return -EINVAL;
> +	}
> +
> +	if (!*group) {
> +		dev_dbg(&cxlr_dax->dev, "Alloc new tag group\n");
> +		*group = alloc_tag_group(cxlr_dax, &dc_extent->uuid);
> +		if (IS_ERR(*group)) {
> +			rc = PTR_ERR(*group);
> +			*group = NULL;
> +			kfree(dc_extent);
> +			return rc;
> +		}
> +	} else {
> +		dev_dbg(&cxlr_dax->dev, "Append dc_extent to tag group\n");
> +	}
> +
> +	dc_extent->group = *group;
> +
> +	/*
> +	 * Key by @seq_num so iteration order equals assembly order, in both
> +	 * the sharable case (device-stamped 1..n) and the non-sharable case
> +	 * (host-assigned arrival-order 1..n).  A collision here signals a
> +	 * cxl-side validation gap.
> +	 */
> +	rc = xa_insert(&(*group)->dc_extents, dc_extent->seq_num,
> +		       dc_extent, GFP_KERNEL);
> +	if (rc) {
> +		dev_WARN_ONCE(&cxlr_dax->dev, rc == -EBUSY,
> +			"duplicate seq_num %u in tag %pUb\n",
> +			dc_extent->seq_num, &dc_extent->uuid);
> +		kfree(dc_extent);
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
> +		   u16 seq_num)
> +{
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_dax_region *cxlr_dax;
> +	struct dc_extent *dc_extent;
> +	struct range ext_range;
> +	int rc;
> +
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +
> +	rc = cxl_validate_extent(mds, extent, &cxled, &cxlr_dax, &ext_range);
> +	if (rc)
> +		return rc;
> +
> +	switch (cxlr_dax_classify_extent(cxlr_dax, cxled, &ext_range)) {
> +	case CXL_EXT_DUPLICATE:
> +		/*
> +		 * Idempotent accept simplifies the dax-side scan for existing
> +		 * extents on region creation; reply success without duplicating.
> +		 */
> +		dev_warn_ratelimited(&cxled->cxld.dev,
> +				     "Extent %pra exists; accept again\n",
> +				     &ext_range);
> +		return 0;

Does this cause issues with the accounting in cxl_add_pending()? At the end the total_accepted would include duplicates as well. I wonder if modify cxlr_add_extent() to return 1 if an extent is added and handle the returns approriately would make the accounting more accurate.

> +	case CXL_EXT_OVERLAP:
> +		return -ENXIO;
> +	case CXL_EXT_NEW:
> +		break;
> +	}
> +
> +	dc_extent = dc_extent_build(cxled, cxlr_dax, extent, &ext_range,
> +				    seq_num);
> +	if (IS_ERR(dc_extent))
> +		return PTR_ERR(dc_extent);
> +
> +	dev_dbg(&cxled->cxld.dev, "Add extent %pra (%pU)\n",
> +		&dc_extent->dpa_range, &dc_extent->uuid);
> +
> +	return cxlr_add_extent(mds, cxlr_dax, dc_extent);
> +}
> +
> +static void dc_extent_unregister(void *ext)
> +{
> +	struct dc_extent *dc_extent = ext;
> +
> +	dev_dbg(&dc_extent->dev, "DAX region rm extent HPA %pra\n",
> +		&dc_extent->hpa_range);
> +	device_unregister(&dc_extent->dev);
> +}
> +
> +static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
> +{
> +	struct cxl_dc_tag_group *group = dc_extent->group;
> +
> +	cxled_release_extent(dc_extent->cxled, dc_extent);
> +	xa_erase(&group->dc_extents, dc_extent->seq_num);
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +	kfree(dc_extent);
> +}
> +
> +int online_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	struct cxl_dax_region *cxlr_dax = group->cxlr_dax;
> +	struct dc_extent *dc_extent;
> +	unsigned long index;
> +	int rc = 0;
> +
> +	/*
> +	 * Seed nr_extents with the full group size plus a +1 pin held by
> +	 * this function.  The size counts every dc_extent that might
> +	 * decrement nr_extents on cleanup; the pin keeps @group alive
> +	 * across the body even if every dc_extent release fires inside
> +	 * the loop (e.g. devm_add_action_or_reset failure on the only
> +	 * pending extent).  The pin is dropped at the end of the function.
> +	 */
> +	xa_for_each(&group->dc_extents, index, dc_extent)
> +		group->nr_extents++;
> +	group->nr_extents++;
> +
> +	xa_for_each(&group->dc_extents, index, dc_extent) {
> +		struct device *dev = &dc_extent->dev;
> +		u32 id;
> +
> +		device_initialize(dev);
> +		device_set_pm_not_required(dev);
> +		dev->parent = &cxlr_dax->dev;
> +		dev->type = &dc_extent_type;
> +
> +		rc = xa_alloc(&cxlr_dax->dc_extents, &id, dc_extent,
> +			      xa_limit_32b, GFP_KERNEL);
> +		if (rc < 0) {
> +			put_device(dev);

Here xa_alloc() fails, so there no valid id. But the put_device() will trigger dc_extent_release(). And therefore dev->id of 0 is passed in and potentially erase the id 0 slot even if that's not the intended id. Can always define xarray with XA_FLAGS_ALLOC1 to start it at 1 and therefore slot 0 is not used.


> +			break;
> +		}
> +		dev->id = id;
> +
> +		rc = dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id,
> +				  dev->id);
> +		if (rc) {
> +			xa_erase(&cxlr_dax->dc_extents, dev->id);
> +			put_device(dev);
> +			break;
> +		}
> +
> +		rc = device_add(dev);
> +		if (rc) {
> +			xa_erase(&cxlr_dax->dc_extents, dev->id);
> +			put_device(dev);
> +			break;
> +		}
> +
> +		dev_dbg(dev, "dc_extent HPA %pra (%pU)\n",
> +			&dc_extent->hpa_range, &group->uuid);
> +
> +		rc = devm_add_action_or_reset(&cxlr_dax->dev,
> +					      dc_extent_unregister, dc_extent);
> +		if (rc)
> +			break;
> +	}
> +
> +	if (rc) {
> +		/*
> +		 * Unwind every remaining dc_extent in the group.  The pin
> +		 * above keeps @group alive across this walk.  Distinguish
> +		 * onlined dc_extents (have a devm action) from pending ones
> +		 * via devm_remove_action_nowarn(): a 0 return means the
> +		 * action was installed and is now consumed, so we run the
> +		 * unregister ourselves; -ENOENT means pending.
> +		 */
> +		xa_for_each(&group->dc_extents, index, dc_extent) {
> +			int r = devm_remove_action_nowarn(&cxlr_dax->dev,
> +							  dc_extent_unregister,
> +							  dc_extent);
> +			if (r == 0)
> +				dc_extent_unregister(dc_extent);
> +			else
> +				cleanup_pending_dc_extent(dc_extent);
> +		}
> +	}
> +
> +	/* Drop the pin; if nothing else still references @group, free it. */
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +	return rc;
> +}
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index c376492fa166..e5edc3975e8f 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -6,6 +6,7 @@
>  #include <linux/mutex.h>
>  #include <linux/unaligned.h>
>  #include <linux/list.h>
> +#include <linux/list_sort.h>
>  #include <cxlpci.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
> @@ -1181,7 +1182,7 @@ static void delete_extent_node(struct cxl_extent_list_node *node)
>  	kfree(node);
>  }
>  
> -static void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
> +void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
>  {
>  	struct device *dev = mds->cxlds.dev;
>  	struct cxl_extent_list_node *node;
> @@ -1280,11 +1281,120 @@ static int add_to_pending_list(struct list_head *pending_list,
>  }
>  
>  /*
> - * Stub: stage extents on the pending list and reply with an empty
> - * ADD_DC_RESPONSE on More=0 (refuse all).  A later commit replaces
> - * the no-op tail with the real Add pipeline that surfaces a dax
> - * device per accepted extent.
> + * Compare two extents by shared_extn_seq (ascending).  list_sort is
> + * stable so when shared_extn_seq is 0 for every entry (non-sharable
> + * partition) ties fall back to arrival order via list_add_tail() in
> + * add_to_pending_list().
>   */
> +static int extent_seq_compare(void *priv,
> +			      const struct list_head *a,
> +			      const struct list_head *b)
> +{
> +	const struct cxl_extent_list_node *ea =
> +		list_entry(a, struct cxl_extent_list_node, list);
> +	const struct cxl_extent_list_node *eb =
> +		list_entry(b, struct cxl_extent_list_node, list);
> +	u16 sa = le16_to_cpu(ea->extent->shared_extn_seq);
> +	u16 sb = le16_to_cpu(eb->extent->shared_extn_seq);
> +
> +	if (sa < sb)
> +		return -1;
> +	if (sa > sb)
> +		return 1;
> +	return 0;
> +}
> +
> +/*
> + * Move every pending extent whose tag matches @tag onto @group, preserving
> + * the order they appear in @pending.
> + */
> +static void extract_tag_group(struct list_head *pending,
> +			      const uuid_t *tag,
> +			      struct list_head *group)
> +{
> +	struct cxl_extent_list_node *pos, *tmp;
> +
> +	list_for_each_entry_safe(pos, tmp, pending, list) {
> +		uuid_t t;
> +
> +		import_uuid(&t, pos->extent->uuid);
> +		if (uuid_equal(&t, tag))
> +			list_move_tail(&pos->list, group);
> +	}
> +}
> +
> +/*
> + * Drive the pending Add-Capacity records through cxl_add_extent(),
> + * grouped by tag.  Per group: extract from pending, stable-sort by
> + * shared_extn_seq, then attempt to add each extent.  Online the tag
> + * group via online_tag_group() once all of its extents have been
> + * realized.  Validation gates layer onto this loop in later commits.
> + */
> +static int cxl_add_pending(struct cxl_memdev_state *mds)
> +{
> +	struct device *dev = mds->cxlds.dev;
> +	struct list_head *pending = &mds->add_ctx.pending_extents;
> +	struct cxl_extent_list_node *pos, *tmp;
> +	LIST_HEAD(accepted);
> +	int total_accepted = 0;
> +
> +	while (!list_empty(pending)) {
> +		LIST_HEAD(group);
> +		struct cxl_dc_tag_group *tag_group;
> +		int group_cnt = 0;
> +		uuid_t tag;
> +		int rc;
> +
> +		import_uuid(&tag,
> +			list_first_entry(pending,
> +					 struct cxl_extent_list_node,
> +					 list)->extent->uuid);
> +		extract_tag_group(pending, &tag, &group);
> +		list_sort(NULL, &group, extent_seq_compare);
> +
> +		u16 logical_seq = 1;

declaring var in middle of code

> +		list_for_each_entry_safe(pos, tmp, &group, list) {
> +			u16 raw = le16_to_cpu(pos->extent->shared_extn_seq);
> +			u16 seq = raw ? raw : logical_seq;
> +
> +			logical_seq++;
> +
> +			if (cxl_add_extent(mds, pos->extent, seq)) {
> +				dev_dbg(dev,
> +					"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
> +					&tag,
> +					le64_to_cpu(pos->extent->start_dpa),
> +					le64_to_cpu(pos->extent->length));
> +				delete_extent_node(pos);
> +				continue;
> +			}
> +			group_cnt++;
> +		}
> +
> +		tag_group = mds->add_ctx.group;
> +		if (!tag_group)
> +			continue;

Does it need to add delete_extent_node() for the group before continue?

DJ

> +
> +		rc = online_tag_group(tag_group);
> +		if (rc) {
> +			dev_warn(dev,
> +				 "Tag %pUb: failed to online tag group (%d)\n",
> +				 &tag, rc);
> +			list_for_each_entry_safe(pos, tmp, &group, list)
> +				delete_extent_node(pos);
> +		} else {
> +			list_splice_tail_init(&group, &accepted);
> +			total_accepted += group_cnt;
> +		}
> +
> +		mds->add_ctx.group = NULL;
> +	}
> +
> +	list_splice(&accepted, pending);
> +	return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				    pending, total_accepted);
> +}
> +
>  static int handle_add_event(struct cxl_memdev_state *mds,
>  			    struct cxl_event_dcd *event)
>  {
> @@ -1316,8 +1426,7 @@ static int handle_add_event(struct cxl_memdev_state *mds,
>  	ctx->armed = false;
>  	cancel_delayed_work(&ctx->timeout_work);
>  
> -	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> -				  &mds->add_ctx.pending_extents, 0);
> +	rc = cxl_add_pending(mds);
>  	clear_pending_extents(mds);
>  	return rc;
>  }
> diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
> index d6bf69155827..519e203c486a 100644
> --- a/drivers/cxl/core/region_dax.c
> +++ b/drivers/cxl/core/region_dax.c
> @@ -13,6 +13,7 @@ static void cxl_dax_region_release(struct device *dev)
>  {
>  	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
>  
> +	xa_destroy(&cxlr_dax->dc_extents);
>  	kfree(cxlr_dax);
>  }
>  
> @@ -57,11 +58,13 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
>  	if (!cxlr_dax)
>  		return ERR_PTR(-ENOMEM);
>  
> +	xa_init_flags(&cxlr_dax->dc_extents, XA_FLAGS_ALLOC);
>  	cxlr_dax->hpa_range.start = p->res->start;
>  	cxlr_dax->hpa_range.end = p->res->end;
>  
>  	dev = &cxlr_dax->dev;
>  	cxlr_dax->cxlr = cxlr;
> +	cxlr->cxlr_dax = cxlr_dax;
>  	device_initialize(dev);
>  	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
>  	device_set_pm_not_required(dev);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 5ef2cf4d005b..cbbfba92fea9 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -495,6 +495,7 @@ struct cxl_region_params {
>   * @type: Endpoint decoder target type
>   * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
>   * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
> + * @cxlr_dax: (for DC regions) cached copy of CXL DAX bridge
>   * @flags: Region state flags
>   * @params: active + config params for the region
>   * @coord: QoS access coordinates for the region
> @@ -510,6 +511,7 @@ struct cxl_region {
>  	enum cxl_decoder_type type;
>  	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct cxl_pmem_region *cxlr_pmem;
> +	struct cxl_dax_region *cxlr_dax;
>  	unsigned long flags;
>  	struct cxl_region_params params;
>  	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
> @@ -568,6 +570,15 @@ struct cxl_dax_region {
>  	struct device dev;
>  	struct cxl_region *cxlr;
>  	struct range hpa_range;
> +	/*
> +	 * dc_extents is keyed by an allocator-assigned u32 (see
> +	 * online_tag_group()).  Tag groups have no first-class identity in
> +	 * this xarray; siblings within a tag find each other via
> +	 * dc_extent->group.  Tag-uniqueness lookup is a linear xa_for_each
> +	 * walk, adequate at the bounded per-region extent counts the
> +	 * driver handles.
> +	 */
> +	struct xarray dc_extents;
>  };
>  
>  /**
> @@ -595,6 +606,14 @@ struct cxl_dc_tag_group {
>  	unsigned int nr_extents;
>  };
>  
> +bool is_dc_extent(struct device *dev);
> +static inline struct dc_extent *to_dc_extent(struct device *dev)
> +{
> +	if (!is_dc_extent(dev))
> +		return NULL;
> +	return container_of(dev, struct dc_extent, dev);
> +}
> +
>  /**
>   * struct cxl_port - logical collection of upstream port devices and
>   *		     downstream port devices to construct a CXL memory
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index 2be1df80fcc9..8941cf187462 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -63,7 +63,10 @@ cxl_core-y += $(CXL_CORE_SRC)/hdm.o
>  cxl_core-y += $(CXL_CORE_SRC)/pmu.o
>  cxl_core-y += $(CXL_CORE_SRC)/cdat.o
>  cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/region_pmem.o $(CXL_CORE_SRC)/region_dax.o
> +cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o \
> +				 $(CXL_CORE_SRC)/region_pmem.o \
> +				 $(CXL_CORE_SRC)/region_dax.o \
> +				 $(CXL_CORE_SRC)/extent.o
>  cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o

