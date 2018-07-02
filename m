Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD050209603EF
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:39:46 -0700 (PDT)
Subject: [PATCH 07/11] nfit/libnvdimm: add freeze security support to Intel
 nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:39:46 -0700
Message-ID: <153057478596.38125.16368895958393903118.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
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

Adding support for freeze security on Intel nvdimm. This locks out any
changes to security for the DIMM unless a reboot is done. This is triggered
by writing "freeze" to the "security" sysfs attribute. libnvdimm will
support the generic freeze_lock API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |   47 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   22 +++++++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 3 files changed, 71 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 6d73493f02cc..41602be2a33b 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -16,6 +16,52 @@
 #include <acpi/nfit.h>
 #include "nfit.h"
 
+static int intel_dimm_security_freeze_lock(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0, pkg_size;
+	struct nd_intel_freeze_lock *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (!test_bit(NVDIMM_INTEL_FREEZE_LOCK, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	pkg_size = sizeof(*pkg) + sizeof(*cmd);
+	pkg = kzalloc(pkg_size, GFP_KERNEL);
+	if (!pkg)
+		return -ENOMEM;
+
+	pkg->nd_command = NVDIMM_INTEL_FREEZE_LOCK;
+	pkg->nd_family = NVDIMM_FAMILY_INTEL;
+	pkg->nd_size_in = 0;
+	pkg->nd_size_out = ND_INTEL_STATUS_SIZE;
+	pkg->nd_fw_size = pkg->nd_size_out;
+	cmd = (struct nd_intel_freeze_lock *)&pkg->nd_payload;
+	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, pkg,
+			sizeof(pkg_size), &cmd_rc);
+	if (rc < 0)
+		goto out;
+	if (cmd_rc < 0) {
+		rc = cmd_rc;
+		goto out;
+	}
+
+	switch (cmd->status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+ out:
+	kfree(pkg);
+	return rc;
+}
+
 static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm, const char *pass)
 {
@@ -244,4 +290,5 @@ struct nvdimm_security_ops intel_security_ops = {
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
 	.disable = intel_dimm_security_disable,
+	.freeze_lock = intel_dimm_security_freeze_lock,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 070811cb4cdc..cd0624663621 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -85,6 +85,26 @@ int nvdimm_security_get_state(struct device *dev)
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
@@ -628,6 +648,8 @@ static ssize_t security_store(struct device *dev,
 		rc = nvdimm_security_change_key(dev);
 	else if (strcmp(buf, "disable") == 0 || strcmp(buf, "disable\n") == 0)
 		rc = nvdimm_security_disable(dev);
+	else if (strcmp(buf, "freeze") == 0 || strcmp(buf, "freeze\n") == 0)
+		rc = nvdimm_security_freeze_lock(dev);
 	else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0990dfd5a0a3..683e4cadc7f6 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -179,6 +179,8 @@ struct nvdimm_security_ops {
 			const char *new_pass);
 	int (*disable)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm, const char *pass);
+	int (*freeze_lock)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
