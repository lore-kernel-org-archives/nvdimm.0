Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF0182097F575
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 13:48:56 -0700 (PDT)
Subject: [PATCH v4 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 12 Jul 2018 13:48:56 -0700
Message-ID: <153142853603.27297.14939716671780414552.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
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

Add support for setting and/or updating passphrase on the Intel nvdimms.
The passphrase is pulled from userspace through the kernel key management.
We trigger the update via writing "update" to the sysfs attribute
"security". The state of the security can also be read via the "security"
attribute. libnvdimm will generically support the key_change API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |   57 +++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |  110 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    5 ++
 3 files changed, 172 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 9155b8e63f0e..b0a62248467d 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,62 @@
 #include "intel.h"
 #include "nfit.h"
 
+static int intel_dimm_security_update_passphrase(
+		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+		struct nvdimm_key_data *old_data,
+		struct nvdimm_key_data *new_data)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_set_passphrase cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_SET_PASSPHRASE,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE * 2,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+		},
+		.cmd = {
+			.status = 0,
+		},
+	};
+
+	if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	if (old_data)
+		memcpy(nd_cmd.cmd.old_pass, old_data->data,
+				ND_INTEL_PASSPHRASE_SIZE);
+	memcpy(nd_cmd.cmd.new_pass, new_data->data, ND_INTEL_PASSPHRASE_SIZE);
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
 static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
 {
@@ -148,4 +204,5 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 struct nvdimm_security_ops intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
+	.change_key = intel_dimm_security_update_passphrase,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 5e190120f4aa..2ab846a2114a 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -171,6 +171,75 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 	return rc;
 }
 
+static int nvdimm_security_change_key(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key = NULL, *old_key = NULL;
+	int rc;
+	void *old_data, *new_data;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	if (nvdimm->state == NVDIMM_SECURITY_FROZEN)
+		return -EBUSY;
+
+	/* look for a key from keyring if exists and remove */
+	old_key = nvdimm_search_key(dev);
+	if (old_key) {
+		dev_dbg(dev, "%s: killing old key: %#x\n",
+				__func__, old_key->serial);
+		key_invalidate(old_key);
+		key_put(old_key);
+		/* need key garbage collection to take effect */
+		cond_resched();
+	}
+
+	/* request new key from userspace */
+	key = nvdimm_request_key(dev);
+	if (!key) {
+		dev_dbg(dev, "%s: failed to acquire new key\n", __func__);
+		return -ENXIO;
+	}
+
+	dev_dbg(dev, "%s: new key: %#x\n", __func__, key->serial);
+
+	if (key->datalen == NVDIMM_PASSPHRASE_LEN) {
+		old_data = NULL;
+		new_data = key->payload.data[0];
+	} else if (key->datalen == (NVDIMM_PASSPHRASE_LEN * 2)) {
+		new_data = key->payload.data[0];
+		old_data = new_data + NVDIMM_PASSPHRASE_LEN;
+	} else {
+		key_invalidate(key);
+		key_put(key);
+		dev_warn(dev, "Incorrect key payload size for update: %u\n",
+				key->datalen);
+		return -EINVAL;
+	}
+
+	down_read(&key->sem);
+	rc = nvdimm->security_ops->change_key(nvdimm_bus, nvdimm, old_data,
+			new_data);
+	if (rc == 0 && key->datalen == (NVDIMM_PASSPHRASE_LEN * 2))
+		memcpy(old_data, new_data, NVDIMM_PASSPHRASE_LEN);
+	up_read(&key->sem);
+
+	/*
+	 * If we successfully update, link the new key to our keyring,
+	 * otherwise, nuke the key.
+	 */
+	if (rc == 0)
+		key_link(nvdimm_cred->thread_keyring, key);
+	else
+		key_invalidate(key);
+
+	key_put(key);
+	nvdimm_security_get_state(dev);
+	return rc;
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
@@ -528,11 +597,52 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
+static ssize_t security_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	switch (nvdimm->state) {
+	case NVDIMM_SECURITY_DISABLED:
+		return sprintf(buf, "disabled\n");
+	case NVDIMM_SECURITY_UNLOCKED:
+		return sprintf(buf, "unlocked\n");
+	case NVDIMM_SECURITY_LOCKED:
+		return sprintf(buf, "locked\n");
+	case NVDIMM_SECURITY_FROZEN:
+		return sprintf(buf, "frozen\n");
+	case NVDIMM_SECURITY_UNSUPPORTED:
+	default:
+		return sprintf(buf, "unsupported\n");
+	}
+
+	return -ENOTTY;
+}
+
+static ssize_t security_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+
+{
+	ssize_t rc = -EINVAL;
+
+	if (sysfs_streq(buf, "update"))
+		rc = nvdimm_security_change_key(dev);
+	else
+		return -EINVAL;
+
+	if (rc == 0)
+		rc = len;
+
+	return rc;
+}
+static DEVICE_ATTR_RW(security);
+
 static struct attribute *nvdimm_attributes[] = {
 	&dev_attr_state.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_commands.attr,
 	&dev_attr_available_slots.attr,
+	&dev_attr_security.attr,
 	NULL,
 };
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 692217f82c6e..7889fea75281 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -162,6 +162,7 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_DISABLED,
 	NVDIMM_SECURITY_UNLOCKED,
 	NVDIMM_SECURITY_LOCKED,
+	NVDIMM_SECURITY_FROZEN,
 	NVDIMM_SECURITY_UNSUPPORTED,
 };
 
@@ -178,6 +179,10 @@ struct nvdimm_security_ops {
 			enum nvdimm_security_state *state);
 	int (*unlock)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm, struct nvdimm_key_data *nkey);
+	int (*change_key)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm,
+			struct nvdimm_key_data *old_data,
+			struct nvdimm_key_data *new_data);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
