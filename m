Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC430567E
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 22:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008878; cv=none; b=o65E2qtFur3uNdD06LsSXk+beUK7+mzmPxJFJdjjBbZ8Rs/Y9+G2azlfiV7dI8IrzLNF0hEgazOzdsjjbQ9sJfzAY+qwLh8UDrAeOmfjhX+/De8B3YdHLOMpepcvVkIy/QRjUs7TUcEKCvgjDRD8rp2xzaynGs/d5WECY2qTx2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008878; c=relaxed/simple;
	bh=/cE5D2q85/Or45mTlIVfk79Fkg1UQUtq+VVOA0/Kf1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qMxrB72nb8TK65bob5rnYrJDgY8Lrmgp3Arx5rbi5QRwdViTYqcDDz4SMZFAxrw2FDrHx7z+oIKrMFXYpplty9n5uq5ZJVob1Wrps720VN2sEaU4uTaQu4LDC7PrcZvl6slT+BRFnMPXmxnk9c3YpUktB3Na94KQJtwuTQdsUCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q2HevPaG; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q2HevPaG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780008877; x=1811544877;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/cE5D2q85/Or45mTlIVfk79Fkg1UQUtq+VVOA0/Kf1Y=;
  b=Q2HevPaGdSrkk1e89dj7Gj6DV1nRDg5asaFZIp/vn93ogVmyPBNtVPTS
   zeM0x54MWLFHMnF9uRnYvCZcRSe7+QQXDVmVtEokzBgwMsl683hA+z7LD
   0Ww4a+Nnq8//cB4oGlbcN6kK+6QakpOx7VTMFdXHd50ASICTVPVZOL4vW
   GMIDMJnxlGWwhLBvoCvjMEL476p7jB+QiW1srxZEvDKH92QNbmoQEF1P7
   BcDE5zkyBLGuyYd7ykEQ1MDzgTM+vM0C0WPU72ES8TdPxEVF8/wMA9xgp
   gC0wXRASkm+MN6MaPXzhXtSXRDTR3J7yZtOKHACzap/hYsrWduAZ+utp6
   Q==;
X-CSE-ConnectionGUID: 0tesQGOjTCCeuj/SOBdk6A==
X-CSE-MsgGUID: sEyz6PI1RGqCI8u/RvBLmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="92336369"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="92336369"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:54:37 -0700
X-CSE-ConnectionGUID: MscU9u3KQZ6CrAsUTFtMkw==
X-CSE-MsgGUID: xnN18+q9T0+8zXeJiicD+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="242780232"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:54:35 -0700
Message-ID: <e29c7d64-4ea1-4fe6-b47b-2141a832f5a8@intel.com>
Date: Thu, 28 May 2026 15:54:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 20/31] cxl/region/extent: Expose dc_extent information
 in sysfs
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, Fan Ni <fan.ni@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <52f5a9ba175424c0f0a181e32ed6c04f26993d96.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <52f5a9ba175424c0f0a181e32ed6c04f26993d96.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Extent information can be helpful to the user to coordinate memory
> usage with the external orchestrator and FM.
> 
> Expose the details of each dc_extent by creating the following sysfs
> entries.
> 
> 	/sys/bus/cxl/devices/dax_regionX/extentX.Y
> 	/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> 	/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> 	/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
> 
> Each dc_extent surfaces as its own extentX.Y device under the parent
> dax_region.  offset and length describe that dc_extent's HPA range,
> not an aggregate bounding box across the containing tagged
> allocation — so when a tagged allocation has multiple
> DPA-discontiguous extents, each is reported with its own offset and
> length.  uuid is the tag identifying the containing allocation; it
> is shared across dc_extents that belong to the same tagged
> allocation and is hidden for untagged extents.
> 
> Based on an original patch by Navneet Singh.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Fan Ni <fan.ni@samsung.com>
> Tested-by: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Missing Anisa sign off

> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 36 +++++++++++++++
>  drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 3080aef9ad67..38cf0a2894b9 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -661,3 +661,39 @@ Description:
>  		The count is persistent across power loss and wraps back to 0
>  		upon overflow. If this file is not present, the device does not
>  		have the necessary support for dirty tracking.
> +
> +
> +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
> +Date:		May, 2025
> +KernelVersion:	v6.16

Update date and kernel version for all

> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) [For Dynamic Capacity regions only] Users can use the
> +		extent information to create DAX devices on specific extents.
> +		This is done by creating and destroying DAX devices in specific
> +		sequences and looking at the mappings created.  Extent offset
> +		within the region.
> +
> +
> +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
> +Date:		May, 2025
> +KernelVersion:	v6.16
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) [For Dynamic Capacity regions only] Users can use the
> +		extent information to create DAX devices on specific extents.
> +		This is done by creating and destroying DAX devices in specific
> +		sequences and looking at the mappings created.  Extent length
> +		within the region.
> +
> +
> +What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
> +Date:		May, 2025
> +KernelVersion:	v6.16
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) [For Dynamic Capacity regions only] Users can use the
> +		extent information to create DAX devices on specific extents.
> +		This is done by creating and destroying DAX devices in specific
> +		sequences and looking at the mappings created.  UUID of this
> +		extent.
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index f66fa8c600c5..34babfe032d1 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -6,6 +6,63 @@
>  
>  #include "core.h"
>  
> +static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct dc_extent *dc_extent = to_dc_extent(dev);
> +
> +	return sysfs_emit(buf, "%#llx\n", dc_extent->hpa_range.start);
> +}
> +static DEVICE_ATTR_RO(offset);
> +
> +static ssize_t length_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct dc_extent *dc_extent = to_dc_extent(dev);
> +	u64 length = range_len(&dc_extent->hpa_range);
> +
> +	return sysfs_emit(buf, "%#llx\n", length);
> +}
> +static DEVICE_ATTR_RO(length);
> +
> +static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{
> +	struct dc_extent *dc_extent = to_dc_extent(dev);
> +
> +	return sysfs_emit(buf, "%pUb\n", &dc_extent->group->uuid);
> +}
> +static DEVICE_ATTR_RO(uuid);
> +
> +static struct attribute *dc_extent_attrs[] = {
> +	&dev_attr_offset.attr,
> +	&dev_attr_length.attr,
> +	&dev_attr_uuid.attr,
> +	NULL
> +};
> +
> +static uuid_t empty_uuid = { 0 };
> +
> +static umode_t dc_extent_visible(struct kobject *kobj,
> +				 struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct dc_extent *dc_extent = to_dc_extent(dev);
> +
> +	if (a == &dev_attr_uuid.attr &&
> +	    uuid_equal(&dc_extent->group->uuid, &empty_uuid))'

uuid_is_null() can be used?

DJ

> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static const struct attribute_group dc_extent_attribute_group = {
> +	.attrs = dc_extent_attrs,
> +	.is_visible = dc_extent_visible,
> +};
> +
> +__ATTRIBUTE_GROUPS(dc_extent_attribute);
> +
>  
>  static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
>  				 struct dc_extent *dc_extent)
> @@ -93,6 +150,7 @@ static void dc_extent_release(struct device *dev)
>  static const struct device_type dc_extent_type = {
>  	.name = "extent",
>  	.release = dc_extent_release,
> +	.groups = dc_extent_attribute_groups,
>  };
>  
>  bool is_dc_extent(struct device *dev)

