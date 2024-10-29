Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D539208224
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234151; cv=none; b=URYosGBCKcCZFzzPJKILYdVAMsCaFxdL73L+I2KcpytA0lfgJIBAREAyGMkWGp8iSYpqv95xbu2MI9G8WgElA5Eux1lN+9B4E06MRQGjhShJgaA0WARXf3r5Cbks58r7LuxsXsXKKHvTYuIJwOC6K5L9uTAhCr94tJau3vaQYRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234151; c=relaxed/simple;
	bh=lEJdW0Ygrx9GRwy2/nzdpfgA35lo+JrftZEIMp/SVbI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RAAXmEnGv34EPl4ErdB5yAKYr4d+2Mj4LyeWxuze62BOPlpAaKc6h2ZVaLRAN0sjXzv9luV4pupLLKQBA1vHiVNh2fqOkVL6NgkqdDr3KSSCh6mazT7NX+p3T9A72cPTJsSQTcKmbcpm6TqI/qsI78GVsQLYjez0ROXUQBnLUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vu0zVGIO; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vu0zVGIO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234149; x=1761770149;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=lEJdW0Ygrx9GRwy2/nzdpfgA35lo+JrftZEIMp/SVbI=;
  b=Vu0zVGIOu1i3DrmAxs3xlMR3BMY3XxDms9wXQgWIxYRaSS8DkzNf17Px
   w4WxZ4zTk1WH01HfLFaIgL/XchxXpiLy9WoWTZ1GVZLM0AbBna7aapYU8
   kb/x7tWULPffrPM2i8dJHuUuJ0G5O/BoE/qR6S2ebIhu5SG8Rd56+EFti
   ZtBp+lvQrk98FMNCW/fMGKO+bdOWPWqmVs2kfjsjmO6Qa00ehbql8mJxB
   RMEn1DNSSG44u2g91V/8n6LTR84PHJeTDkqWe8x+WuYS8YqbuKZIJ/XyR
   zEL5WEPxKQQttQAqWF33K5L0kyI6UUKpLGHQUItSdMbt6mH/JtfKYvm2q
   A==;
X-CSE-ConnectionGUID: AcAKbJ82RludjCU9WPa9Pw==
X-CSE-MsgGUID: l3xIFvH8Sli73U8QDGy8ZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="40485486"
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="40485486"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:48 -0700
X-CSE-ConnectionGUID: XvGB0VBwTRGxa/CCd7dIxA==
X-CSE-MsgGUID: k6DWd0ZWQMO2j4FPnJUwtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="82185334"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:46 -0700
From: ira.weiny@intel.com
Date: Tue, 29 Oct 2024 15:34:48 -0500
Subject: [PATCH v5 13/27] cxl/mem: Expose DCD partition capabilities in
 sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-13-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=8446;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ZwbtMWDmEoyXzsmrWVPmRQ4t8Fr2WPPGgA5XxSb/NKM=;
 b=lwJf0ReqSOcGSfbrxB3h0+se8lRxTwDXCMbNRvv9wyUMpNQADJn2ibnRXvEcKtkquM91TAz7G
 C22GjWW5cM2CeW/uNo6UWVhD64iQvsHKvATNLtBqh/wPVCXrK4THagK
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

To properly configure CXL regions on Dynamic Capacity Devices (DCD),
user space will need to know the details of the DC partitions available.

Expose dynamic capacity capabilities through sysfs.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes:
[Fan: Use proper str_false_true() call]
[Jonathan: minor cleanups]
[Bagas: Clean up documentation language]
---
 Documentation/ABI/testing/sysfs-bus-cxl |  45 ++++++++++++
 drivers/cxl/core/memdev.c               | 124 ++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 3f5627a1210a16aca7c18d17131a56491048a0c2..ff3ae83477f0876c0ee2d3955d27a11fa9d16d83 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -54,6 +54,51 @@ Description:
 		identically named field in the Identify Memory Device Output
 		Payload in the CXL-2.0 specification.
 
+What:		/sys/bus/cxl/devices/memX/dcY/size
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) Dynamic Capacity (DC) region information.  Devices only
+		export dcY if DCD partition Y is supported.
+		dcY/size is the size of each of those partitions.
+
+What:		/sys/bus/cxl/devices/memX/dcY/read_only
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) Dynamic Capacity (DC) region information.  Devices only
+		export dcY if DCD partition Y is supported.
+		dcY/read_only indicates true if the region is exported
+		read_only from the device.
+
+What:		/sys/bus/cxl/devices/memX/dcY/shareable
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) Dynamic Capacity (DC) region information.  Devices only
+		export dcY if DCD partition Y is supported.
+		dcY/shareable indicates true if the region is exported
+		shareable from the device.
+
+What:		/sys/bus/cxl/devices/memX/dcY/qos_class
+Date:		December, 2024
+KernelVersion:	v6.13
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) Dynamic Capacity (DC) region information.  Devices only
+		export dcY if DCD partition Y is supported.  For CXL host
+		platforms that support "QoS Telemmetry" this attribute conveys
+		a comma delimited list of platform specific cookies that
+		identifies a QoS performance class for the persistent partition
+		of the CXL mem device. These class-ids can be compared against
+		a similar "qos_class" published for a root decoder. While it is
+		not required that the endpoints map their local memory-class to
+		a matching platform class, mismatches are not recommended as
+		there are platform specific performance related side-effects
+		that may result. First class-id is displayed.
 
 What:		/sys/bus/cxl/devices/memX/pmem/qos_class
 Date:		May, 2023
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 84fefb76dafabc22e6e1a12397381b3f18eea7c5..857a9dd88b20291116d20b9c0bbe9e7961f4491f 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 Intel Corporation. */
 
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/string_choices.h>
 #include <linux/firmware.h>
 #include <linux/device.h>
 #include <linux/slab.h>
@@ -449,6 +450,121 @@ static struct attribute *cxl_memdev_security_attributes[] = {
 	NULL,
 };
 
+static ssize_t show_size_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	return sysfs_emit(buf, "%#llx\n", mds->dc_region[pos].decode_len);
+}
+
+static ssize_t show_read_only_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	return sysfs_emit(buf, "%s\n",
+			  str_true_false(mds->dc_region[pos].read_only));
+}
+
+static ssize_t show_shareable_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	return sysfs_emit(buf, "%s\n",
+			  str_true_false(mds->dc_region[pos].shareable));
+}
+
+static ssize_t show_qos_class_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	return sysfs_emit(buf, "%d\n", mds->dc_perf[pos].qos_class);
+}
+
+#define CXL_MEMDEV_DC_ATTR_GROUP(n)						\
+static ssize_t dc##n##_size_show(struct device *dev,				\
+				 struct device_attribute *attr,			\
+				 char *buf)					\
+{										\
+	return show_size_dcN(to_cxl_memdev(dev), buf, (n));			\
+}										\
+struct device_attribute dc##n##_size = {					\
+	.attr	= { .name = "size", .mode = 0444 },				\
+	.show	= dc##n##_size_show,						\
+};										\
+static ssize_t dc##n##_read_only_show(struct device *dev,			\
+				      struct device_attribute *attr,		\
+				      char *buf)				\
+{										\
+	return show_read_only_dcN(to_cxl_memdev(dev), buf, (n));		\
+}										\
+struct device_attribute dc##n##_read_only = {					\
+	.attr	= { .name = "read_only", .mode = 0444 },			\
+	.show	= dc##n##_read_only_show,					\
+};										\
+static ssize_t dc##n##_shareable_show(struct device *dev,			\
+				     struct device_attribute *attr,		\
+				     char *buf)					\
+{										\
+	return show_shareable_dcN(to_cxl_memdev(dev), buf, (n));		\
+}										\
+struct device_attribute dc##n##_shareable = {					\
+	.attr	= { .name = "shareable", .mode = 0444 },			\
+	.show	= dc##n##_shareable_show,					\
+};										\
+static ssize_t dc##n##_qos_class_show(struct device *dev,			\
+				      struct device_attribute *attr,		\
+				      char *buf)				\
+{										\
+	return show_qos_class_dcN(to_cxl_memdev(dev), buf, (n));		\
+}										\
+struct device_attribute dc##n##_qos_class = {					\
+	.attr	= { .name = "qos_class", .mode = 0444 },			\
+	.show	= dc##n##_qos_class_show,					\
+};										\
+static struct attribute *cxl_memdev_dc##n##_attributes[] = {			\
+	&dc##n##_size.attr,							\
+	&dc##n##_read_only.attr,						\
+	&dc##n##_shareable.attr,						\
+	&dc##n##_qos_class.attr,						\
+	NULL									\
+};										\
+static umode_t cxl_memdev_dc##n##_attr_visible(struct kobject *kobj,		\
+					       struct attribute *a,		\
+					       int pos)				\
+{										\
+	struct device *dev = kobj_to_dev(kobj);					\
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);				\
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);	\
+										\
+	/* Not a memory device */						\
+	if (!mds)								\
+		return 0;							\
+	return a->mode;								\
+}										\
+static umode_t cxl_memdev_dc##n##_group_visible(struct kobject *kobj)		\
+{										\
+	struct device *dev = kobj_to_dev(kobj);					\
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);				\
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);	\
+										\
+	/* Not a memory device or partition not supported */			\
+	return mds && n < mds->nr_dc_region;					\
+}										\
+DEFINE_SYSFS_GROUP_VISIBLE(cxl_memdev_dc##n);					\
+static struct attribute_group cxl_memdev_dc##n##_group = {			\
+	.name = "dc"#n,								\
+	.attrs = cxl_memdev_dc##n##_attributes,					\
+	.is_visible = SYSFS_GROUP_VISIBLE(cxl_memdev_dc##n),			\
+}
+CXL_MEMDEV_DC_ATTR_GROUP(0);
+CXL_MEMDEV_DC_ATTR_GROUP(1);
+CXL_MEMDEV_DC_ATTR_GROUP(2);
+CXL_MEMDEV_DC_ATTR_GROUP(3);
+CXL_MEMDEV_DC_ATTR_GROUP(4);
+CXL_MEMDEV_DC_ATTR_GROUP(5);
+CXL_MEMDEV_DC_ATTR_GROUP(6);
+CXL_MEMDEV_DC_ATTR_GROUP(7);
+
 static umode_t cxl_memdev_visible(struct kobject *kobj, struct attribute *a,
 				  int n)
 {
@@ -525,6 +641,14 @@ static struct attribute_group cxl_memdev_security_attribute_group = {
 };
 
 static const struct attribute_group *cxl_memdev_attribute_groups[] = {
+	&cxl_memdev_dc0_group,
+	&cxl_memdev_dc1_group,
+	&cxl_memdev_dc2_group,
+	&cxl_memdev_dc3_group,
+	&cxl_memdev_dc4_group,
+	&cxl_memdev_dc5_group,
+	&cxl_memdev_dc6_group,
+	&cxl_memdev_dc7_group,
 	&cxl_memdev_attribute_group,
 	&cxl_memdev_ram_attribute_group,
 	&cxl_memdev_pmem_attribute_group,

-- 
2.47.0

