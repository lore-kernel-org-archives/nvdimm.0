Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8D423D40D
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888562; cv=none; b=hadltbn8jtnaCl4uwjVkX9MQYyOTM5ILNDDzyVKarFvMcpGSMq4G5ofhhVI2hQ7cv4mRKAp6jV7BAJ0vgPaQEcbwwXbmHEdiQN/g2QQ9zHFRTbeK8VxUYt07bzPhyUnVMlGp+zp6PfaXe9qJNnAUvICQaT0ybbZ2GMq+9v9KdRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888562; c=relaxed/simple;
	bh=beHVFk5bRU2vAYTtToMFtRA7apf+RRjFQAYfurCb+Lg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VTSW9vO+yQTS6+T5W/fkgWOXBN2U3sHLb/g2aJOU0MgMQSNBctuMtMrRGZ1uLP+wiEJ9eqJ7rgYwtSGqCrXQwdsenVX8wL2u4X3LBNKVO1rJHcGNouKSMDeTO/gmD8mhRK8h7htyvTcLyoo8I/0M2Sr9Ab1WR/8O7qBiG7Msz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ep8SfLB0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ep8SfLB0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888561; x=1765424561;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=beHVFk5bRU2vAYTtToMFtRA7apf+RRjFQAYfurCb+Lg=;
  b=Ep8SfLB0OmnNZwvzWGU6cf6WdlGXSs/TrDZVWixVeU8ar6pQpxN5wg8q
   FbcRpUN3IBlWe5G54rAzIfEmHiifZwpgT6jdtJ51MTq+WH+jpbWJvb/Aw
   opGLKUuSTtmUxuCETdNId1dOPRGNSfTymMQA9x0BpTEEJsij6+jJSUllx
   wNAe81eFvDBeWqAbP2gezyhYGJ+L6EFeQhIAmxTaN39ay5qF6/hitCP0Y
   QA/T2O2H7P3lSJil67qXShxQW2+tSerZADq0F6BcRKPN7ZdmfyiKfuDSL
   MNJR8iC+ufBYaS6HAbwXJeQTdtsxl1swWWQEbv8+WzRV2Fm4WbOeJyqDu
   g==;
X-CSE-ConnectionGUID: QeU4ZCPjTqaXqDyjcjTLeg==
X-CSE-MsgGUID: vv4s+NeWR/iusUFuSltCDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34395706"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34395706"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:41 -0800
X-CSE-ConnectionGUID: PUlNj3GCQJ+feN1W144lRA==
X-CSE-MsgGUID: 5TvckwYQSNSI0yC/au2rGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95696851"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:39 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 10 Dec 2024 21:42:23 -0600
Subject: [PATCH v8 08/21] cxl/port: Add endpoint decoder DC mode support to
 sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-dcd-type2-upstream-v8-8-812852504400@intel.com>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
In-Reply-To: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=6220;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=beHVFk5bRU2vAYTtToMFtRA7apf+RRjFQAYfurCb+Lg=;
 b=2YsemNr62getQxqXs7NULch019mQlPTtM0warlvl511Qbnc7ifoHG4/HXGQ4wRbXsTaG5tO2S
 9J2A8WnAZE1Bo5DZARl7ZgajNGE7/irvSIUbgrN/OhoHqp0MLHPcfYS
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Endpoint decoder mode is used to represent the partition the decoder
points to such as ram or pmem.

Expand the mode to allow a decoder to point to a specific DC partition
(Region).

Based on an original patch by Navneet Singh.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[Carpenter/smatch: fix cxl_decoder_mode_names array]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 25 ++++++++++++------------
 drivers/cxl/core/hdm.c                  | 16 ++++++++++++++++
 drivers/cxl/core/port.c                 | 16 +++++++++++-----
 drivers/cxl/cxl.h                       | 34 +++++++++++++++++----------------
 4 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index ff3ae83477f0876c0ee2d3955d27a11fa9d16d83..8d990d702f63363879150cf523c0be6229f315e0 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -361,23 +361,24 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, October 2024
+KernelVersion:	v6.0, v6.13 (dcY)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
-		translates from a host physical address range, to a device local
-		address range. Device-local address ranges are further split
-		into a 'ram' (volatile memory) range and 'pmem' (persistent
-		memory) range. The 'mode' attribute emits one of 'ram', 'pmem',
-		'mixed', or 'none'. The 'mixed' indication is for error cases
-		when a decoder straddles the volatile/persistent partition
-		boundary, and 'none' indicates the decoder is not actively
-		decoding, or no DPA allocation policy has been set.
+		translates from a host physical address range, to a device
+		local address range. Device-local address ranges are further
+		split into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory) range, and Dynamic Capacity (DC) ranges. The 'mode'
+		attribute emits one of 'ram', 'pmem', 'dcY', 'mixed', or
+		'none'. The 'mixed' indication is for error cases when a
+		decoder straddles partition boundaries, and 'none' indicates
+		the decoder is not actively decoding, or no DPA allocation
+		policy has been set.
 
 		'mode' can be written, when the decoder is in the 'disabled'
-		state, with either 'ram' or 'pmem' to set the boundaries for the
-		next allocation.
+		state, with 'ram', 'pmem', or 'dcY' to set the boundaries for
+		the next allocation.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index e15241f94d17b774aa5befb37fb453af637a17ce..d0c32c3c6564df869d41030144c6d2a7c063747d 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -548,6 +548,7 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 	switch (mode) {
 	case CXL_DECODER_RAM:
 	case CXL_DECODER_PMEM:
+	case CXL_DECODER_DC0 ... CXL_DECODER_DC7:
 		break;
 	default:
 		dev_dbg(dev, "unsupported mode: %d\n", mode);
@@ -571,6 +572,21 @@ int cxl_dpa_set_mode(struct cxl_endpoint_decoder *cxled,
 		return -ENXIO;
 	}
 
+	if (mode >= CXL_DECODER_DC0 && mode <= CXL_DECODER_DC7) {
+		struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+		int index;
+
+		index = dc_mode_to_region_index(mode);
+		if (!resource_size(&cxlds->dc_res[index])) {
+			dev_dbg(dev, "no available dynamic capacity\n");
+			return -ENXIO;
+		}
+		if (mds->dc_region[index].shareable) {
+			dev_err(dev, "DC region %d is shareable\n", index);
+			return -EINVAL;
+		}
+	}
+
 	cxled->mode = mode;
 	return 0;
 }
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 5c0b8ead315f41c4df14918ad4dcdb269990c5dd..7459ca8eae002727405bf1077d0187bcfb579144 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -205,11 +205,17 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 	enum cxl_decoder_mode mode;
 	ssize_t rc;
 
-	if (sysfs_streq(buf, "pmem"))
-		mode = CXL_DECODER_PMEM;
-	else if (sysfs_streq(buf, "ram"))
-		mode = CXL_DECODER_RAM;
-	else
+	for (mode = 0; mode < CXL_DECODER_MODE_MAX; mode++)
+		if (sysfs_streq(buf, cxl_decoder_mode_names[mode]))
+			break;
+
+	if (mode == CXL_DECODER_NONE ||
+	    mode == CXL_DECODER_DEAD ||
+	    mode == CXL_DECODER_MODE_MAX)
+		return -EINVAL;
+
+	/* Not yet supported */
+	if (mode >= CXL_DECODER_MIXED)
 		return -EINVAL;
 
 	rc = cxl_dpa_set_mode(cxled, mode);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 055c840b6c2856ec77162c3c5f87293f00f8d8ec..79660c87e6be533a1d55311896f9a3c5514648f8 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -389,27 +389,29 @@ enum cxl_decoder_mode {
 	CXL_DECODER_DC7,
 	CXL_DECODER_MIXED,
 	CXL_DECODER_DEAD,
+	CXL_DECODER_MODE_MAX,
+};
+
+static const char * const cxl_decoder_mode_names[] = {
+	[CXL_DECODER_NONE] = "none",
+	[CXL_DECODER_RAM] = "ram",
+	[CXL_DECODER_PMEM] = "pmem",
+	[CXL_DECODER_DC0] = "dc0",
+	[CXL_DECODER_DC1] = "dc1",
+	[CXL_DECODER_DC2] = "dc2",
+	[CXL_DECODER_DC3] = "dc3",
+	[CXL_DECODER_DC4] = "dc4",
+	[CXL_DECODER_DC5] = "dc5",
+	[CXL_DECODER_DC6] = "dc6",
+	[CXL_DECODER_DC7] = "dc7",
+	[CXL_DECODER_MIXED] = "mixed",
+	[CXL_DECODER_DEAD] = "dead",
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 {
-	static const char * const names[] = {
-		[CXL_DECODER_NONE] = "none",
-		[CXL_DECODER_RAM] = "ram",
-		[CXL_DECODER_PMEM] = "pmem",
-		[CXL_DECODER_DC0] = "dc0",
-		[CXL_DECODER_DC1] = "dc1",
-		[CXL_DECODER_DC2] = "dc2",
-		[CXL_DECODER_DC3] = "dc3",
-		[CXL_DECODER_DC4] = "dc4",
-		[CXL_DECODER_DC5] = "dc5",
-		[CXL_DECODER_DC6] = "dc6",
-		[CXL_DECODER_DC7] = "dc7",
-		[CXL_DECODER_MIXED] = "mixed",
-	};
-
 	if (mode >= CXL_DECODER_NONE && mode <= CXL_DECODER_MIXED)
-		return names[mode];
+		return cxl_decoder_mode_names[mode];
 	return "mixed";
 }
 

-- 
2.47.1

