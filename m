Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E3662114083E
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:56:09 -0700 (PDT)
Subject: [PATCH v12 07/12] nfit/libnvdimm: add freeze security support to
 Intel nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 08 Oct 2018 16:56:08 -0700
Message-ID: <153904296848.60070.14021093483871071063.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
References: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for freeze security on Intel nvdimm. This locks out any
changes to security for the DIMM unless a reboot is done. This is triggered
by writing "freeze" to the "security" sysfs attribute. libnvdimm will
support the generic freeze_lock API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c           |   51 +++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c          |    3 ++
 drivers/nvdimm/dimm_devs_security.c |   20 ++++++++++++++
 drivers/nvdimm/nd.h                 |    6 ++++
 include/linux/libnvdimm.h           |    2 +
 5 files changed, 82 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 21d30222371f..ba886f1f5399 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,53 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_freeze_lock cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_FREEZE_LOCK,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_in = 0,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+		},
+		.cmd = {
+			.status = 0,
+		},
+	};
+
+	if (!test_bit(NVDIMM_INTEL_FREEZE_LOCK, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
+			sizeof(nd_cmd), &cmd_rc);
+	if (rc < 0)
+		goto out;
+	if (cmd_rc < 0) {
+		rc = cmd_rc;
+		goto out;
+	}
+
+	switch (nd_cmd.cmd.status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+ out:
+	return rc;
+}
+
 static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
 {
@@ -254,6 +301,9 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 	else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
 		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
 			*state = NVDIMM_SECURITY_LOCKED;
+		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN ||
+				nd_cmd.cmd.state & ND_INTEL_SEC_STATE_PLIMIT)
+			*state = NVDIMM_SECURITY_FROZEN;
 		else
 			*state = NVDIMM_SECURITY_UNLOCKED;
 	} else
@@ -270,4 +320,5 @@ const struct nvdimm_security_ops intel_security_ops = {
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
 	.disable = intel_dimm_security_disable,
+	.freeze_lock = intel_dimm_security_freeze_lock,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index ae0c3e02e4f5..a1c4c28d951f 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -442,6 +442,9 @@ static ssize_t security_store(struct device *dev,
 			return -EINVAL;
 		dev_dbg(dev, "disable %#x\n", old_key);
 		rc = nvdimm_security_disable(dev, old_key);
+	} else if (sysfs_streq(buf, "freeze")) {
+		dev_dbg(dev, "freeze\n");
+		rc = nvdimm_security_freeze_lock(dev);
 	} else
 		return -EINVAL;
 
diff --git a/drivers/nvdimm/dimm_devs_security.c b/drivers/nvdimm/dimm_devs_security.c
index 6f8b9021292c..767c5ae06cb5 100644
--- a/drivers/nvdimm/dimm_devs_security.c
+++ b/drivers/nvdimm/dimm_devs_security.c
@@ -164,6 +164,26 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+int nvdimm_security_freeze_lock(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	int rc;
+
+	if (!nvdimm->security_ops)
+		return -EOPNOTSUPP;
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
+		return -EOPNOTSUPP;
+
+	rc = nvdimm->security_ops->freeze_lock(nvdimm_bus, nvdimm);
+	if (rc < 0)
+		return rc;
+
+	nvdimm_security_get_state(dev);
+	return 0;
+}
+
 int nvdimm_security_disable(struct device *dev, unsigned int keyid)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b80cab3a12df..d89fe1423f9a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -431,6 +431,7 @@ int nvdimm_security_get_state(struct device *dev);
 int nvdimm_security_change_key(struct device *dev, unsigned int old_keyid,
 		unsigned int new_keyid);
 int nvdimm_security_disable(struct device *dev, unsigned int keyid);
+int nvdimm_security_freeze_lock(struct device *dev);
 #else
 static inline struct key *nvdimm_get_key(struct device *dev)
 {
@@ -458,5 +459,10 @@ static inline int nvdimm_security_disable(struct device *dev,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int nvdimm_security_freeze_lock(struct device *dev)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 #endif /* __ND_H__ */
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index c60ab4b238f3..bcab42caa948 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -185,6 +185,8 @@ struct nvdimm_security_ops {
 	int (*disable)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
+	int (*freeze_lock)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
