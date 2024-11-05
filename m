Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1571F81BD
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831967; cv=none; b=aSBF4mr5PjQZSXkyGvZo06wRkjlL6bhTO+otdZEdgKLjqorQ5S52ieXG99kUr1++Nat64/3LP/Ij8Pl05p6hcP4TU84HgxLeg6XMvB1TdecczBY1Lom7jOcbxHj3fuIceHOYEHl5Ud4vCFJBkk03NpHtHvyK43V7B2FKraX042w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831967; c=relaxed/simple;
	bh=/z57Di8+4MoIcNaFT/SVhi/tHc+RshShPSpFz6BZQZM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y/s/r2Tj2lS2BTSHOp9p0s3bE+ily5QoLv7q2VNx3HlVs458v5n4Ww1CXp5gsmyKZGC7+hm+g/8gSHo7IyxXe1UM5f7Amk6UdFE5s9AK25ZxVgALJMU48lxtUaXPJ1vfBgJ6qM9Uyq4xmtjz41+y6Jaa5pedxyiSK6v00bpR/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HP/SSinM; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HP/SSinM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831966; x=1762367966;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=/z57Di8+4MoIcNaFT/SVhi/tHc+RshShPSpFz6BZQZM=;
  b=HP/SSinMCe3ZbpuQrETRynwiD6fGPfHqlQtwfKn96hIuc+9ozP1Arf5R
   5Xayuuwq/B7BWJFAd9/ZWZgQF7nMUPiME+Y5q9GkYOJAB/TwH2vxhGVWb
   Fl5kp2wrfTZGfXLiGtryv1fXIRQ4GMc+4/GmYOTkOBh5PRPoyTom3e8lL
   w9A1NgwApncT418/CoP1kvvsbQCt7kXQDvMGUIRC1WmVxRDLvoYOV0+u+
   Z5WEHWFZznxZjSrghJQ5U98f2bRA4yxR16F3mEfViEcb21c1Wh18PnE3X
   lhK+J5XXfuerTh7b7ana7KHROBI6SGz7abOXrtireVJKDa2gfAVSbe3vq
   A==;
X-CSE-ConnectionGUID: gIjH3B7PQlyVMtpnJzuqDg==
X-CSE-MsgGUID: FQkjx+gUQp6Apnk7yMMIRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30012784"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="30012784"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:25 -0800
X-CSE-ConnectionGUID: O1OiMiHkR4KiOSYwSgy44g==
X-CSE-MsgGUID: oXYJfTjfQ4mAXdMNOsFU7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="88624682"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:23 -0800
From: ira.weiny@intel.com
Date: Tue, 05 Nov 2024 12:38:43 -0600
Subject: [PATCH v6 21/27] cxl/region/extent: Expose region extent
 information in sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-21-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=4991;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=jn/tPekUkdIM6oMRPpacsGan7cxQjZRBW1QHWy0/zyY=;
 b=tKjIjyB9wwApsdn1dAu0rdVaEQUChUzf4mZME6aLe+w4F7bTViUoxcVz7jGrLO3f37vbESmDg
 i1zUkHT97wIA8+r9LzEpiUSHy757Yhm6wCtrhcpXUnfHCc7WNlwhdbZ
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Extent information can be helpful to the user to coordinate memory usage
with the external orchestrator and FM.

Expose the details of region extents by creating the following
sysfs entries.

        /sys/bus/cxl/devices/dax_regionX/extentX.Y
        /sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
        /sys/bus/cxl/devices/dax_regionX/extentX.Y/length
        /sys/bus/cxl/devices/dax_regionX/extentX.Y/tag

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 33 +++++++++++++++++++
 drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index aeff248ea368cf49c9977fcaf43ab4def978e896..ee2ef4ea33e17cbc65e1252753f46f6d0dce1aee 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -632,3 +632,36 @@ Description:
 		See Documentation/ABI/stable/sysfs-devices-node. access0 provides
 		the number to the closest initiator and access1 provides the
 		number to the closest CPU.
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent offset
+		within the region.
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent length
+		within the region.
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/tag
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  UUID extent
+		tag.
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index bb12abe4792bcadd2442de3c21bf5ce4d48edf06..9f493aa8a5a26ca1dbaae48a396f67f0e644e1ce 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -6,6 +6,63 @@
 
 #include "core.h"
 
+static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	return sysfs_emit(buf, "%#llx\n", region_extent->hpa_range.start);
+}
+static DEVICE_ATTR_RO(offset);
+
+static ssize_t length_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+	u64 length = range_len(&region_extent->hpa_range);
+
+	return sysfs_emit(buf, "%#llx\n", length);
+}
+static DEVICE_ATTR_RO(length);
+
+static ssize_t tag_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	return sysfs_emit(buf, "%pUb\n", &region_extent->tag);
+}
+static DEVICE_ATTR_RO(tag);
+
+static struct attribute *region_extent_attrs[] = {
+	&dev_attr_offset.attr,
+	&dev_attr_length.attr,
+	&dev_attr_tag.attr,
+	NULL
+};
+
+static uuid_t empty_tag = { 0 };
+
+static umode_t region_extent_visible(struct kobject *kobj,
+				     struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct region_extent *region_extent = to_region_extent(dev);
+
+	if (a == &dev_attr_tag.attr &&
+	    uuid_equal(&region_extent->tag, &empty_tag))
+		return 0;
+
+	return a->mode;
+}
+
+static const struct attribute_group region_extent_attribute_group = {
+	.attrs = region_extent_attrs,
+	.is_visible = region_extent_visible,
+};
+
+__ATTRIBUTE_GROUPS(region_extent_attribute);
+
 static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 				 struct cxled_extent *ed_extent)
 {
@@ -45,6 +102,7 @@ static void region_extent_release(struct device *dev)
 static const struct device_type region_extent_type = {
 	.name = "extent",
 	.release = region_extent_release,
+	.groups = region_extent_attribute_groups,
 };
 
 bool is_region_extent(struct device *dev)

-- 
2.47.0

