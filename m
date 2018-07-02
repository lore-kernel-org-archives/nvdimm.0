Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D3E2210D83DF
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:39:41 -0700 (PDT)
Subject: [PATCH 06/11] nfit/libnvdimm: add disable passphrase support to
 Intel nvdimm.
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:39:40 -0700
Message-ID: <153057478052.38125.4677218866266067369.stgit@djiang5-desk3.ch.intel.com>
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

Adding support to disable passphrase (security) for the Intel nvdimm. The
passphrase used for disabling is pulled from userspace via the kernel
key management. The action is triggered by writing "disable" to the sysfs
attribute "security". libnvdimm will support the generic disable API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |   51 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   41 +++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 3 files changed, 94 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 792a5c694a9e..6d73493f02cc 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -16,6 +16,56 @@
 #include <acpi/nfit.h>
 #include "nfit.h"
 
+static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, const char *pass)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0, pkg_size;
+	struct nd_intel_disable_passphrase *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (!test_bit(NVDIMM_INTEL_DISABLE_PASSPHRASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	pkg_size = sizeof(*pkg) + sizeof(*cmd);
+	pkg = kzalloc(pkg_size, GFP_KERNEL);
+	if (!pkg)
+		return -ENOMEM;
+
+	pkg->nd_command = NVDIMM_INTEL_DISABLE_PASSPHRASE;
+	pkg->nd_family = NVDIMM_FAMILY_INTEL;
+	pkg->nd_size_in = ND_INTEL_PASSPHRASE_SIZE;
+	pkg->nd_size_out = ND_INTEL_STATUS_SIZE;
+	pkg->nd_fw_size = pkg->nd_size_out;
+	cmd = (struct nd_intel_disable_passphrase *)&pkg->nd_payload;
+	memcpy(cmd->passphrase, pass, ND_INTEL_PASSPHRASE_SIZE);
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
+	case ND_INTEL_STATUS_INVALID_PASS:
+		rc = -EINVAL;
+		goto out;
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
 static int intel_dimm_security_update_passphrase(
 		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		const char *old_pass, const char *new_pass)
@@ -193,4 +243,5 @@ struct nvdimm_security_ops intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
+	.disable = intel_dimm_security_disable,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d3d738c77adb..070811cb4cdc 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -85,6 +85,45 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static int nvdimm_security_disable(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	int rc;
+	char *payload;
+	bool cached_key = false;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
+		return 0;
+
+	key = nvdimm_search_key(dev);
+	if (!key)
+		key = nvdimm_request_key(dev);
+	else
+		cached_key = true;
+	if (!key)
+		return -ENXIO;
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	rc = nvdimm->security_ops->disable(nvdimm_bus, nvdimm, payload);
+	up_read(&key->sem);
+	if (rc < 0)
+		goto out;
+
+	/* If we succeed then remove the key */
+	key_invalidate(key);
+
+ out:
+	key_put(key);
+	nvdimm_security_get_state(dev);
+	return rc;
+}
+
 int nvdimm_security_unlock_dimm(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -587,6 +626,8 @@ static ssize_t security_store(struct device *dev,
 
 	if (strcmp(buf, "update") == 0 || strcmp(buf, "update\n") == 0)
 		rc = nvdimm_security_change_key(dev);
+	else if (strcmp(buf, "disable") == 0 || strcmp(buf, "disable\n") == 0)
+		rc = nvdimm_security_disable(dev);
 	else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 7b609409042c..0990dfd5a0a3 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -177,6 +177,8 @@ struct nvdimm_security_ops {
 	int (*change_key)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm, const char *old_pass,
 			const char *new_pass);
+	int (*disable)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm, const char *pass);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
