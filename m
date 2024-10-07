Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B540F1DF745
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343041; cv=none; b=d7BUqqdAmkyxjSoXl2s/pQ6lHC15RtxMvtJ7oFgURCu9T6ajvZhZYtxXA7+6AxgRLvvuXzWoSbKLcY0PQT1UmMmtz/LDs+MANFzV/8QOi/Z4PAC/JHB8k2fxCHO5EGm26+vn35OBqst4n73dbBz6sS9Yt1tPDEdTq/U+xrIWpOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343041; c=relaxed/simple;
	bh=RYD5mX4v541rozxI90MPUDtRQ6WgI1e9REWFUZB3eSI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FG9iHZ3Z9T5/qNe/Q2AeMGbI+5ZJCOAd8A9Tlzf+c+JxTUrKUMZNxosozmcYGIpE3Aa1Am/no1dL/7XxtWwMMoOOTz/fqAB3CqxqMKTmqaJ3KVeAF36yQwMCnj5hpT+2mOzNAxbXaSORBNf3prFmC1AQxts1Tgf6atyJANC9idQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lY+Wcsbg; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lY+Wcsbg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343040; x=1759879040;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=RYD5mX4v541rozxI90MPUDtRQ6WgI1e9REWFUZB3eSI=;
  b=lY+Wcsbg1wDvKyY0D+Iw9tLJHOujXixSYflcyHh9nTczy4zGbhcOM3jv
   kiU3ZkcUmsDtUph/O2QbdPiUT04ktT8MTDann5FNhjMlikxuri2H/a9D5
   MF1OpJAHP4L1EpgA2izlX+/sbh2Kr3wr9Hh5CqqqkVDGAYzLzGduK3vSQ
   uWFdpZM4QJ92t503j6rRGpTPdtvRa1qLB4r4wBly5hYVV9hE2Hd909dME
   k1NckXxcgb5gIOasiyEsnU020JWrjQ5Zyk30HNkEa0Jf6YQ/EW8UU/ZJg
   FXA4fIbzDz5EWql8T+jgs/tQ+PXY7DsEC4Sf52b6fOHkkJ5IwF13HcemH
   w==;
X-CSE-ConnectionGUID: i/UIGyK+SAOOSQ/Z5Cc3Yg==
X-CSE-MsgGUID: 01qbIfATT7akXV7CylIqJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="26972676"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="26972676"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:19 -0700
X-CSE-ConnectionGUID: 1PyCAfo2SP2l0kPlJ/0gMA==
X-CSE-MsgGUID: +QazMjtdRuqXjln9IIwxXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="76001804"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:17 -0700
From: ira.weiny@intel.com
Date: Mon, 07 Oct 2024 18:16:28 -0500
Subject: [PATCH v4 22/28] cxl/region/extent: Expose region extent
 information in sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-22-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=4810;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=+h1dc0HZCoo0KKUZMEsS6awspM1Y177ePPaCUO0qWIw=;
 b=myXgaoNgsRB8a7EMRPvw1CJ4ovKlYRQ7vUC+Z6mKOWLtuJBxMTCA0+HYmuMH36/LF7AtPj/kn
 IJ8dCfbnF8FDSAbqKVHXG1udmUx9vVqX+0WuXpAOxF2xHwPWPoQfxm1
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
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[djiang: Split sysfs docs up]
[iweiny: Adjust sysfs docs dates]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 32 ++++++++++++++++++
 drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index b63ab622515f..64918180a3c9 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -632,3 +632,35 @@ Description:
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
+		sequences and looking at the mappings created.  Extent tag.
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 69a7614ba6a9..a1eb6e8e4f1a 100644
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
+	NULL,
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
@@ -44,6 +101,7 @@ static void region_extent_release(struct device *dev)
 static const struct device_type region_extent_type = {
 	.name = "extent",
 	.release = region_extent_release,
+	.groups = region_extent_attribute_groups,
 };
 
 bool is_region_extent(struct device *dev)

-- 
2.46.0

