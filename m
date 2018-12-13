Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5086C211A2D93
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 15:48:31 -0800 (PST)
Subject: [PATCH v15 06/16] acpi/nfit,
 libnvdimm: Add freeze security support to Intel nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 13 Dec 2018 16:48:29 -0700
Message-ID: <154474490959.64529.8641211153851434603.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
References: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for freeze security on Intel nvdimm. This locks out any
changes to security for the DIMM until a hard reset of the DIMM is
performed. This is triggered by writing "freeze" to the generic
nvdimm/nmemX "security" sysfs attribute.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c  |   28 +++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   66 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    1 +
 4 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index fd7a8f6d2c20..f98d680d1a39 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -48,7 +48,35 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
 	return NVDIMM_SECURITY_DISABLED;
 }
 
+static int intel_security_freeze(struct nvdimm *nvdimm)
+{
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_freeze_lock cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_FREEZE_LOCK,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+		},
+	};
+	int rc;
+
+	if (!test_bit(NVDIMM_INTEL_FREEZE_LOCK, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
+	if (rc < 0)
+		return rc;
+	if (nd_cmd.cmd.status)
+		return -EIO;
+	return 0;
+}
+
 static const struct nvdimm_security_ops __intel_security_ops = {
 	.state = intel_security_state,
+	.freeze = intel_security_freeze,
 };
 const struct nvdimm_security_ops *intel_security_ops = &__intel_security_ops;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 9609b671311b..8e0bd2ce4dd0 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -390,7 +390,48 @@ static ssize_t security_show(struct device *dev,
 
 	return -ENOTTY;
 }
-static DEVICE_ATTR_RO(security);
+
+static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	ssize_t rc;
+
+	if (atomic_read(&nvdimm->busy))
+		return -EBUSY;
+
+	if (sysfs_streq(buf, "freeze")) {
+		dev_dbg(dev, "freeze\n");
+		rc = nvdimm_security_freeze(nvdimm);
+	} else
+		return -EINVAL;
+
+	if (rc == 0)
+		rc = len;
+	return rc;
+
+}
+
+static ssize_t security_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+
+{
+	ssize_t rc;
+
+	/*
+	 * Require all userspace triggered security management to be
+	 * done while probing is idle and the DIMM is not in active use
+	 * in any region.
+	 */
+	device_lock(dev);
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
+	rc = __security_store(dev, buf, len);
+	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(security);
 
 static struct attribute *nvdimm_attributes[] = {
 	&dev_attr_state.attr,
@@ -410,7 +451,10 @@ static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
 		return a->mode;
 	if (nvdimm->sec.state < 0)
 		return 0;
-	return a->mode;
+	/* Are there any state mutation ops? */
+	if (nvdimm->sec.ops->freeze)
+		return a->mode;
+	return 0444;
 }
 
 struct attribute_group nvdimm_attribute_group = {
@@ -462,6 +506,24 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(__nvdimm_create);
 
+int nvdimm_security_freeze(struct nvdimm *nvdimm)
+{
+	int rc;
+
+	WARN_ON_ONCE(!is_nvdimm_bus_locked(&nvdimm->dev));
+
+	if (!nvdimm->sec.ops || !nvdimm->sec.ops->freeze)
+		return -EOPNOTSUPP;
+
+	if (nvdimm->sec.state < 0)
+		return -EIO;
+
+	rc = nvdimm->sec.ops->freeze(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+
+	return rc;
+}
+
 int alias_dpa_busy(struct device *dev, void *data)
 {
 	resource_size_t map_end, blk_start, new;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1919f5c0d581..15eff40f55f6 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -56,6 +56,7 @@ static inline enum nvdimm_security_state nvdimm_security_state(
 
 	return nvdimm->sec.ops->state(nvdimm);
 }
+int nvdimm_security_freeze(struct nvdimm *nvdimm);
 
 /**
  * struct blk_alloc_info - tracking info for BLK dpa scanning
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f4d63f49f7dd..42c815f97c02 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -165,6 +165,7 @@ enum nvdimm_security_state {
 
 struct nvdimm_security_ops {
 	enum nvdimm_security_state (*state)(struct nvdimm *nvdimm);
+	int (*freeze)(struct nvdimm *nvdimm);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
