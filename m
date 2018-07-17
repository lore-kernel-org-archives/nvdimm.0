Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E921120988747
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 13:54:51 -0700 (PDT)
Subject: [PATCH v5 08/12] nfit/libnvdimm: add freeze security support to
 Intel nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 17 Jul 2018 13:54:49 -0700
Message-ID: <153186088947.27463.6856256644351393107.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for freeze security on Intel nvdimm. This locks out any
changes to security for the DIMM unless a reboot is done. This is triggered
by writing "freeze" to the "security" sysfs attribute. libnvdimm will
support the generic freeze_lock API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c  |   51 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   22 +++++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 3 files changed, 75 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 2418f4b8c1fd..0ab56f03ebc4 100644
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
 		struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
 {
@@ -241,6 +288,9 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 	else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
 		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
 			*state = NVDIMM_SECURITY_LOCKED;
+		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN ||
+				nd_cmd.cmd.state & ND_INTEL_SEC_STATE_PLIMIT)
+			*state = NVDIMM_SECURITY_FROZEN;
 		else
 			*state = NVDIMM_SECURITY_UNLOCKED;
 	} else
@@ -257,4 +307,5 @@ struct nvdimm_security_ops intel_security_ops = {
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
 	.disable = intel_dimm_security_disable,
+	.freeze_lock = intel_dimm_security_freeze_lock,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index def10000c230..6a653476bb7c 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -125,6 +125,26 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static int nvdimm_security_freeze_lock(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	int rc;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
+		return 0;
+
+	rc = nvdimm->security_ops->freeze_lock(nvdimm_bus, nvdimm);
+	if (rc < 0)
+		return rc;
+
+	nvdimm_security_get_state(dev);
+	return 0;
+}
+
 static int nvdimm_security_disable(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -672,6 +692,8 @@ static ssize_t security_store(struct device *dev,
 		rc = nvdimm_security_change_key(dev);
 	else if (sysfs_streq(buf, "disable"))
 		rc = nvdimm_security_disable(dev);
+	else if (sysfs_streq(buf, "freeze"))
+		rc = nvdimm_security_freeze_lock(dev);
 	else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 59ad04261f34..1836599ed5b8 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -185,6 +185,8 @@ struct nvdimm_security_ops {
 			struct nvdimm_key_data *new_data);
 	int (*disable)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm, struct nvdimm_key_data *nkey);
+	int (*freeze_lock)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
