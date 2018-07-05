Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A940210D93A5
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 13:22:45 -0700 (PDT)
Subject: [PATCH v2 06/11] nfit/libnvdimm: adding disable passphrase support
 to Intel nvdimm.
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 05 Jul 2018 13:22:44 -0700
Message-ID: <153082216451.61422.2923876535893157241.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153082172527.61422.13689320279597181069.stgit@djiang5-desk3.ch.intel.com>
References: <153082172527.61422.13689320279597181069.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/acpi/nfit/intel.c  |   52 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   41 +++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 3 files changed, 95 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 82514ff3e644..e413e78c0cee 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -17,6 +17,57 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_disable_passphrase cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_DISABLE_PASSPHRASE,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+		},
+		.cmd = {
+			.status = 0,
+		},
+	};
+
+	if (!test_bit(NVDIMM_INTEL_DISABLE_PASSPHRASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	memcpy(nd_cmd.cmd.passphrase, nkey->data, ND_INTEL_PASSPHRASE_SIZE);
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
+	return rc;
+}
+
 static int intel_dimm_security_update_passphrase(
 		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		struct nvdimm_key_data *old_data,
@@ -200,4 +251,5 @@ struct nvdimm_security_ops intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
+	.disable = intel_dimm_security_disable,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 645979665808..9ee8f269b1ce 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -125,6 +125,45 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static int nvdimm_security_disable(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	int rc;
+	void *payload;
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
@@ -627,6 +666,8 @@ static ssize_t security_store(struct device *dev,
 
 	if (strcmp(buf, "update") == 0 || strcmp(buf, "update\n") == 0)
 		rc = nvdimm_security_change_key(dev);
+	else if (strcmp(buf, "disable") == 0 || strcmp(buf, "disable\n") == 0)
+		rc = nvdimm_security_disable(dev);
 	else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 7889fea75281..59ad04261f34 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -183,6 +183,8 @@ struct nvdimm_security_ops {
 			struct nvdimm *nvdimm,
 			struct nvdimm_key_data *old_data,
 			struct nvdimm_key_data *new_data);
+	int (*disable)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm, struct nvdimm_key_data *nkey);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
