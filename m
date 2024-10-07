Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F7F199E92
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343034; cv=none; b=notRIwHl0Kj++GzMRRzaj7dGq2Em54a/agAZHpFOX+j0B5KcdER3PB2a7yTXIVr8HMxS9o5hUYccXthQwGXHDG3h65yX3OYgXD2JVM41w8zfPWPVjovFrVwtbbsydzgNQ2tIjGMNDvJO6mKOp6abnHSwWBIwZDbMilrNFfpALAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343034; c=relaxed/simple;
	bh=I0ZAbMgV2otcNfQh3EcfteK8gPIcaI9eNkGtF2GytF8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s3F7BulUpVvDta92groU0jBqqL72eduORclSxUQzpRFr9YE2QUlQk3Mg6w00aSHk89WqtKFEgsGEb4vQKg8JuPJ/i73fdRWEumqeapPMCBqQaZzQjG3cIj7kfPVpC1NWAJaQXXei2l/6tiWx/PnXTYiv7bbGBpZtyZeuzNc2h+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=isX1jSZx; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="isX1jSZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343032; x=1759879032;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=I0ZAbMgV2otcNfQh3EcfteK8gPIcaI9eNkGtF2GytF8=;
  b=isX1jSZxcq0qKi/PiyaERhhUihss2GM+d6p1FSCCDWSyNF67P66S63Zt
   VX/HGQjmw1FjeGtDVfMPT+yrwxzIcy9gZdg2GJPK+4Fo6IeU6WDy3urKG
   u6qZpJLekrmnmouj59KAt4+9QjJD32M5MCC+h0y8k76ZyOWLjHXb0j/9i
   +bBgborGRirVmGjX0HYJkervgnp0W+0yY4KUvA+W5TU24//lmoU//7KOL
   rC9g55NRxhjg+Spfq6fTZAtjynzJmUIjb3ZC2FDLiJ8OqA+f4zjIUbKEY
   4hXD3dPR6kHMjPrM68RJgu8Kx6srKa8U8sNrNTEsRYupaZDfdCQ6VIGmK
   g==;
X-CSE-ConnectionGUID: +lpLtfK0QWWfaEWDRq8V/A==
X-CSE-MsgGUID: yguo8ivLSiCiQWeq6OycdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45036920"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="45036920"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:53 -0700
X-CSE-ConnectionGUID: CMDbu9WvTCqYAyvmDgwVAg==
X-CSE-MsgGUID: /Ps28Cl+QHWnJPvToRt7jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75309111"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:50 -0700
From: ira.weiny@intel.com
Date: Mon, 07 Oct 2024 18:16:19 -0500
Subject: [PATCH v4 13/28] cxl/mem: Expose DCD partition capabilities in
 sysfs
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-13-c261ee6eeded@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=8416;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=rasv04aJpGFTO/AOxfFKRee4+yO+8zO1yJogVVWRuYs=;
 b=S/XMtvpR6yhSciT7hPThkBKdCqDXaqdl65AK+jNTymooTIcTmVu9rZ7bmxoBtk8fR8TpPqbIQ
 2nM4pwbyReTBp9c7oMy1pvgfDuw/6e3Wih9ryjRUsne4m9neNF+sS3z
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

To properly configure CXL regions on Dynamic Capacity Devices (DCD),
user space will need to know the details of the DC partitions available.

Expose dynamic capacity capabilities through sysfs.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: Change .../memX/dc/* to .../memX/dcY/*]
[iweiny: add read only and shareable attributes from DSMAS]
[djiang: Split sysfs docs]
[iweiny: Adjust sysfs doc dates]
[iweiny: Add qos details]
---
 Documentation/ABI/testing/sysfs-bus-cxl |  45 ++++++++++++
 drivers/cxl/core/memdev.c               | 126 ++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 3f5627a1210a..b865eefdb74c 100644
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
+		a matching platform class, mismatches are not recommended and
+		there are platform specific performance related side-effects
+		that may result. First class-id is displayed.
 
 What:		/sys/bus/cxl/devices/memX/pmem/qos_class
 Date:		May, 2023
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 84fefb76dafa..2565b10a769c 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 Intel Corporation. */
 
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/string_choices.h>
 #include <linux/firmware.h>
 #include <linux/device.h>
 #include <linux/slab.h>
@@ -449,6 +450,123 @@ static struct attribute *cxl_memdev_security_attributes[] = {
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
+			  str_false_true(mds->dc_region[pos].read_only));
+}
+
+static ssize_t show_shareable_dcN(struct cxl_memdev *cxlmd, char *buf, int pos)
+{
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	return sysfs_emit(buf, "%s\n",
+			  str_false_true(mds->dc_region[pos].shareable));
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
+	NULL,									\
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
+	if (!mds || n >= mds->nr_dc_region)					\
+		return false;							\
+	return true;								\
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
@@ -525,6 +643,14 @@ static struct attribute_group cxl_memdev_security_attribute_group = {
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
2.46.0

