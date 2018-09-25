Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B194E21157436
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 16:38:25 -0700 (PDT)
Subject: [PATCH v9 07/12] nfit/libnvdimm: add disable passphrase support to
 Intel nvdimm.
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 25 Sep 2018 16:38:24 -0700
Message-ID: <153791870482.70158.5593077631830193184.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153791805740.70158.12896535066689316343.stgit@djiang5-desk3.ch.intel.com>
References: <153791805740.70158.12896535066689316343.stgit@djiang5-desk3.ch.intel.com>
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

Add support to disable passphrase (security) for the Intel nvdimm. The
passphrase used for disabling is pulled from userspace via the kernel
key management. The action is triggered by writing "disable <old_keyid>" to
the sysfs attribute "security". libnvdimm will support the generic disable
API call. The kernel will verify the passphrase of the user key against
the cached kernel key. If no kernel key exists, then the user key will be
tried for the op.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c  |   53 ++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   55 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    3 ++
 3 files changed, 111 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 314eae7e02d7..21d30222371f 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,58 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_disable(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
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
+	memcpy(nd_cmd.cmd.passphrase, nkey->data,
+			sizeof(nd_cmd.cmd.passphrase));
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
 /*
  * The update passphrase takes the old passphrase and the new passphrase
  * and send those to the nvdimm. The nvdimm will verify the old
@@ -217,4 +269,5 @@ const struct nvdimm_security_ops intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
 	.change_key = intel_dimm_security_update_passphrase,
+	.disable = intel_dimm_security_disable,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e915e6de6c12..ed4a8bece2ef 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -160,6 +160,7 @@ struct key *nvdimm_get_and_verify_key(struct device *dev,
 	if (rc < 0)
 		key = ERR_PTR(rc);
 	return key;
+
 }
 
 static int nvdimm_check_key_len(unsigned short len)
@@ -182,6 +183,57 @@ int nvdimm_security_get_state(struct device *dev)
 			&nvdimm->state);
 }
 
+static int nvdimm_security_disable(struct device *dev, unsigned int keyid)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	int rc;
+	struct user_key_payload *payload;
+	bool is_userkey = false;
+
+	if (!nvdimm->security_ops)
+		return -EOPNOTSUPP;
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED)
+		return -EOPNOTSUPP;
+
+	/* look for a key from keyring if exists and remove */
+	key = nvdimm_get_and_verify_key(dev, old_keyid);
+	if (IS_ERR(old_key))
+		return PTR_ERR(old_key);
+	if (!key) {
+		/* get old user key */
+		key = nvdimm_lookup_user_key(dev, keyid);
+		if (!key)
+			return -ENOKEY;
+		is_userkey = true;
+	}
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+
+	rc = nvdimm->security_ops->disable(nvdimm_bus, nvdimm,
+			(void *)payload->data);
+	up_read(&key->sem);
+	if (rc < 0) {
+		dev_warn(dev, "unlock failed\n");
+		goto out;
+	}
+
+	/* If we succeed then remove the key */
+	if (!is_userkey) {
+		key_unlink(nvdimm_keyring, key);
+		key_invalidate(key);
+		nvdimm->key = NULL;
+	}
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
@@ -739,6 +791,9 @@ static ssize_t security_store(struct device *dev,
 	if (strcmp(cmd, "update") == 0)	{
 		dev_dbg(dev, "update %u %u\n", old_key, new_key);
 		rc = nvdimm_security_change_key(dev, old_key, new_key);
+	} else if (strcmp(cmd, "disable") == 0) {
+		dev_dbg(dev, "disable %u\n", old_key);
+		rc = nvdimm_security_disable(dev, old_key);
 	} else
 		return -EINVAL;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index bd6a413164ee..c60ab4b238f3 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -182,6 +182,9 @@ struct nvdimm_security_ops {
 			struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *old_data,
 			const struct nvdimm_key_data *new_data);
+	int (*disable)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *nkey);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
