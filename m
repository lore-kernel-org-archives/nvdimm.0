Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1678E7BAEC;
	Tue, 30 Jan 2024 22:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706653766; cv=none; b=a0c3PluUOrmG3eyzK8pkHBDjGSj4oIgVKWy3QDQeL0F0sbsesuFDLsG5vnIzHFWrNYF2BLuI3VSx+oJ4yY65xs772DF7rRIhg9k8XB1HOB3Tz/1hD/xLE29v69VML6ptfn57EplkkLV9tEj+PKRbtsXdx1UnI3sZHva+J2Cq16o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706653766; c=relaxed/simple;
	bh=+PDyYpCTKPRJ2ZHDRt9P0SB+INa3HQ7HbxboV/jamvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m71yGIjPw458T+qUotB085IqgXGcmwFdyaa6cmlMlDCB4NCBzhXHdTmCov8K/2T+kbeYirXefFYmbDOvqLCPWJT0n11i3UrAwniYw7LNkG15PTKoYDwfgYwPO7mjjPWQE0ucddNOHR5s7gW40G50/lvHUBxYA9IpNMUIM0mtVOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9237DC433B1;
	Tue, 30 Jan 2024 22:29:25 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	ira.weiny@intel.com,
	vishal.l.verma@intel.com,
	alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com,
	dave@stgolabs.net
Subject: [PATCH v2 2/3] cxl: Fix sysfs export of qos_class for memdev
Date: Tue, 30 Jan 2024 15:29:04 -0700
Message-ID: <20240130222905.946109-2-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130222905.946109-1-dave.jiang@intel.com>
References: <20240130222905.946109-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current implementation exports only to
/sys/bus/cxl/devices/.../memN/qos_class. With both ram and pmem exposed,
the second registered sysfs attribute is rejected as duplicate. It's not
possible to create qos_class under the dev_groups via the driver due to
the ram and pmem sysfs sub-directories already created by the device sysfs
groups. Move the ram and pmem qos_class to the device sysfs groups and add
a call to sysfs_update() after the perf data are validated so the
qos_class can be visible. The end results should be
/sys/bus/cxl/devices/.../memN/ram/qos_class and
/sys/bus/cxl/devices/.../memN/pmem/qos_class.

The attributes are also updated once the mem driver is removed since they
are no longer valid.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Add update for when memdev driver is removed (Dan)
- Updated to use single cxl_dpa_perf (Dan)
---
 drivers/cxl/core/cdat.c   |  1 +
 drivers/cxl/core/memdev.c | 79 +++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  2 +
 drivers/cxl/mem.c         | 47 -----------------------
 4 files changed, 82 insertions(+), 47 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 99e4c8170c13..152f2d981047 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -383,6 +383,7 @@ void cxl_endpoint_parse_cdat(struct cxl_port *port)
 
 	cxl_memdev_set_qos_class(cxlds, dsmas_xa);
 	cxl_qos_class_verify(cxlmd);
+	cxl_memdev_update_attribute_groups(cxlmd);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_endpoint_parse_cdat, CXL);
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index dae8802ecdb0..a35f6ff3cd79 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -447,13 +447,49 @@ static struct attribute *cxl_memdev_attributes[] = {
 	NULL,
 };
 
+static ssize_t pmem_qos_class_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct cxl_dpa_perf *dpa_perf = &mds->pmem_perf;
+
+	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
+		return -ENODATA;
+
+	return sysfs_emit(buf, "%d\n", dpa_perf->qos_class);
+}
+
+static struct device_attribute dev_attr_pmem_qos_class =
+	__ATTR(qos_class, 0444, pmem_qos_class_show, NULL);
+
 static struct attribute *cxl_memdev_pmem_attributes[] = {
 	&dev_attr_pmem_size.attr,
+	&dev_attr_pmem_qos_class.attr,
 	NULL,
 };
 
+static ssize_t ram_qos_class_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct cxl_dpa_perf *dpa_perf = &mds->ram_perf;
+
+	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
+		return -ENODATA;
+
+	return sysfs_emit(buf, "%d\n", dpa_perf->qos_class);
+}
+
+static struct device_attribute dev_attr_ram_qos_class =
+	__ATTR(qos_class, 0444, ram_qos_class_show, NULL);
+
 static struct attribute *cxl_memdev_ram_attributes[] = {
 	&dev_attr_ram_size.attr,
+	&dev_attr_ram_qos_class.attr,
 	NULL,
 };
 
@@ -477,14 +513,42 @@ static struct attribute_group cxl_memdev_attribute_group = {
 	.is_visible = cxl_memdev_visible,
 };
 
+static umode_t cxl_ram_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	if (a == &dev_attr_ram_qos_class.attr)
+		if (mds->ram_perf.qos_class == CXL_QOS_CLASS_INVALID)
+			return 0;
+
+	return a->mode;
+}
+
 static struct attribute_group cxl_memdev_ram_attribute_group = {
 	.name = "ram",
 	.attrs = cxl_memdev_ram_attributes,
+	.is_visible = cxl_ram_visible,
 };
 
+static umode_t cxl_pmem_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
+
+	if (a == &dev_attr_pmem_qos_class.attr)
+		if (mds->pmem_perf.qos_class == CXL_QOS_CLASS_INVALID)
+			return 0;
+
+	return a->mode;
+}
+
 static struct attribute_group cxl_memdev_pmem_attribute_group = {
 	.name = "pmem",
 	.attrs = cxl_memdev_pmem_attributes,
+	.is_visible = cxl_pmem_visible,
 };
 
 static umode_t cxl_memdev_security_visible(struct kobject *kobj,
@@ -519,6 +583,21 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
 	NULL,
 };
 
+void cxl_memdev_update_attribute_groups(struct cxl_memdev *cxlmd)
+{
+	const struct attribute_group *grp = cxl_memdev_attribute_groups[0];
+
+	for (int i = 0; grp; i++) {
+		int rc = sysfs_update_group(&cxlmd->dev.kobj, grp);
+
+		if (rc)
+			dev_dbg(&cxlmd->dev,
+				"Unable to update memdev attribute group.\n");
+		grp = cxl_memdev_attribute_groups[i + 1];
+	}
+}
+EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_attribute_groups, CXL);
+
 static const struct device_type cxl_memdev_type = {
 	.name = "cxl_memdev",
 	.release = cxl_memdev_release,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b6017c0c57b4..1f630b30d845 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -880,6 +880,8 @@ void cxl_switch_parse_cdat(struct cxl_port *port);
 int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 				      struct access_coordinate *coord);
 
+void cxl_memdev_update_attribute_groups(struct cxl_memdev *cxlmd);
+
 /*
  * Unit test builds overrides this to __weak, find the 'strong' version
  * of these symbols in tools/testing/cxl/.
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index a62099e47d71..0c79d9ce877c 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -215,43 +215,6 @@ static ssize_t trigger_poison_list_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(trigger_poison_list);
 
-static ssize_t ram_qos_class_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
-{
-	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
-	struct cxl_dpa_perf *dpa_perf = &mds->ram_perf;
-
-	if (!dev->driver)
-		return -ENOENT;
-
-	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
-		return -ENODATA;
-
-	return sysfs_emit(buf, "%d\n", dpa_perf->qos_class);
-}
-
-static struct device_attribute dev_attr_ram_qos_class =
-	__ATTR(qos_class, 0444, ram_qos_class_show, NULL);
-
-static ssize_t pmem_qos_class_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
-	struct cxl_dpa_perf *dpa_perf = &mds->pmem_perf;
-
-	if (dpa_perf->qos_class == CXL_QOS_CLASS_INVALID)
-		return -ENODATA;
-
-	return sysfs_emit(buf, "%d\n", dpa_perf->qos_class);
-}
-
-static struct device_attribute dev_attr_pmem_qos_class =
-	__ATTR(qos_class, 0444, pmem_qos_class_show, NULL);
-
 static umode_t cxl_mem_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
@@ -263,21 +226,11 @@ static umode_t cxl_mem_visible(struct kobject *kobj, struct attribute *a, int n)
 			      mds->poison.enabled_cmds))
 			return 0;
 
-	if (a == &dev_attr_pmem_qos_class.attr)
-		if (mds->pmem_perf.qos_class == CXL_QOS_CLASS_INVALID)
-			return 0;
-
-	if (a == &dev_attr_ram_qos_class.attr)
-		if (mds->ram_perf.qos_class == CXL_QOS_CLASS_INVALID)
-			return 0;
-
 	return a->mode;
 }
 
 static struct attribute *cxl_mem_attrs[] = {
 	&dev_attr_trigger_poison_list.attr,
-	&dev_attr_ram_qos_class.attr,
-	&dev_attr_pmem_qos_class.attr,
 	NULL
 };
 
-- 
2.43.0

