Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1A472114083E
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:55:59 -0700 (PDT)
Subject: [PATCH v12 05/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 08 Oct 2018 16:55:57 -0700
Message-ID: <153904295732.60070.8161738114334740920.stgit@djiang5-desk3.ch.intel.com>
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

Add support for setting and/or updating passphrase on the Intel nvdimms.
The passphrase is pulled from userspace through the kernel key management.
We trigger the update via writing "update <old_keyid> <new_keyid>" to the
sysfs attribute "security". If no <old_keyid> exists (for enabling security)
then a 0 should be used. The state of the security can also be read via the
"security" attribute. libnvdimm will generically support the key_change
API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c           |   68 ++++++++++++
 drivers/nvdimm/dimm_devs.c          |   62 +++++++++++
 drivers/nvdimm/dimm_devs_security.c |  192 +++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd.h                 |    8 +
 include/linux/libnvdimm.h           |    5 +
 5 files changed, 335 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 4bfc1c1da339..314eae7e02d7 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -18,6 +18,73 @@
 #include "intel.h"
 #include "nfit.h"
 
+/*
+ * The update passphrase takes the old passphrase and the new passphrase
+ * and send those to the nvdimm. The nvdimm will verify the old
+ * passphrase and then update it with the new passphrase if pending
+ * verification. The function will pass in a zeroed passphrase field
+ * if the old passphrase is NULL. This typically happens when we are
+ * enabling security from the disabled state.
+ */
+static int intel_dimm_security_update_passphrase(
+		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *old_data,
+		const struct nvdimm_key_data *new_data)
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
+				sizeof(nd_cmd.cmd.old_pass));
+	else
+		memset(nd_cmd.cmd.old_pass, 0, sizeof(nd_cmd.cmd.old_pass));
+	memcpy(nd_cmd.cmd.new_pass, new_data->data,
+			sizeof(nd_cmd.cmd.new_pass));
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
 		struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
 {
@@ -149,4 +216,5 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 const struct nvdimm_security_ops intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
+	.change_key = intel_dimm_security_update_passphrase,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 024b1c4dfe88..fe1a90636749 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -389,11 +389,73 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
+#ifdef CONFIG_NVDIMM_SECURITY
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
+#define SEC_CMD_SIZE 128
+static ssize_t security_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	ssize_t rc = -EINVAL;
+	unsigned int new_key = 0, old_key = 0;
+	char cmd[SEC_CMD_SIZE+1];
+
+	if (len > SEC_CMD_SIZE)
+		return -EINVAL;
+
+        wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
+        if (atomic_read(&nvdimm->busy))
+                return -EBUSY;
+
+	rc = sscanf(buf, "%"__stringify(SEC_CMD_SIZE)"s %u %u",
+			cmd, &old_key, &new_key);
+	if (sysfs_streq(cmd, "update"))	{
+		if (rc != 3)
+			return -EINVAL;
+		dev_dbg(dev, "update %#x %#x\n", old_key, new_key);
+		rc = nvdimm_security_change_key(dev, old_key, new_key);
+	} else
+		return -EINVAL;
+
+	if (rc == 0)
+		rc = len;
+
+	return rc;
+}
+static DEVICE_ATTR_RW(security);
+#endif
+
 static struct attribute *nvdimm_attributes[] = {
 	&dev_attr_state.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_commands.attr,
 	&dev_attr_available_slots.attr,
+#ifdef CONFIG_NVDIMM_SECURITY
+	&dev_attr_security.attr,
+#endif
 	NULL,
 };
 
diff --git a/drivers/nvdimm/dimm_devs_security.c b/drivers/nvdimm/dimm_devs_security.c
index 9ebf0b4f4739..d9d0355e1844 100644
--- a/drivers/nvdimm/dimm_devs_security.c
+++ b/drivers/nvdimm/dimm_devs_security.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/cred.h>
 #include <linux/key.h>
+#include <linux/key-type.h>
 #include <keys/user-type.h>
 #include "nd-core.h"
 #include "nd.h"
@@ -30,6 +31,58 @@ struct key *nvdimm_get_key(struct device *dev)
 	return nvdimm->key;
 }
 
+/*
+ * Replacing the user key with a kernel key. The function expects that
+ * we hold the sem for the key passed in. The function will release that
+ * sem when done process. We will also hold the sem for the valid new key
+ * returned.
+ */
+static struct key *nvdimm_replace_key(struct key *key)
+{
+	struct key *new_key;
+	struct user_key_payload *payload;
+	int rc;
+
+	new_key = key_alloc(&key_type_logon, key->description,
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
+			KEY_POS_SEARCH, KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(new_key))
+		return NULL;
+
+	payload = key->payload.data[0];
+	rc = key_instantiate_and_link(new_key, payload->data,
+			payload->datalen, NULL, NULL);
+	up_read(&key->sem);
+	if (rc < 0) {
+		key_put(new_key);
+		return NULL;
+	}
+
+	key_put(key);
+
+	down_read(&new_key->sem);
+	return new_key;
+}
+
+/*
+ * Retrieve user injected key
+ */
+static struct key *nvdimm_lookup_user_key(struct device *dev,
+		key_serial_t id)
+{
+	key_ref_t keyref;
+	struct key *key;
+
+	keyref = lookup_user_key(id, 0, 0);
+	if (IS_ERR(keyref))
+		return NULL;
+
+	key = key_ref_to_ptr(keyref);
+	dev_dbg(dev, "%s: key found: %#x\n", __func__, key_serial(key));
+
+	return key;
+}
+
 /*
  * Retrieve kernel key for DIMM and request from user space if necessary.
  */
@@ -55,6 +108,50 @@ static int nvdimm_check_key_len(unsigned short len)
 	return -EINVAL;
 }
 
+struct key *nvdimm_get_and_verify_key(struct device *dev,
+		unsigned int user_key_id)
+{
+	struct key *user_key, *key;
+	struct user_key_payload *upayload, *payload;
+	int rc = 0;
+
+	key = nvdimm_get_key(dev);
+	/* we don't have a cached key */
+	if (!key) {
+		dev_dbg(dev, "No cached kernel key\n");
+		return NULL;
+	}
+	dev_dbg(dev, "cached_key: %#x\n", key_serial(key));
+
+	user_key = nvdimm_lookup_user_key(dev, user_key_id);
+	if (!user_key) {
+		dev_dbg(dev, "Old user key lookup failed\n");
+		rc = -EINVAL;
+		goto out;
+	}
+	dev_dbg(dev, "user_key: %#x\n", key_serial(user_key));
+
+	down_read(&key->sem);
+	down_read(&user_key->sem);
+	payload = key->payload.data[0];
+	upayload = user_key->payload.data[0];
+
+	if (memcmp(payload->data, upayload->data,
+				NVDIMM_PASSPHRASE_LEN) != 0) {
+		rc = -EINVAL;
+		dev_warn(dev, "Supplied old user key fails check.\n");
+	}
+
+	up_read(&user_key->sem);
+	key_put(user_key);
+	up_read(&key->sem);
+
+out:
+	if (rc < 0)
+		key = ERR_PTR(rc);
+	return key;
+}
+
 int nvdimm_security_get_state(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -127,3 +224,98 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 	nvdimm_security_get_state(dev);
 	return rc;
 }
+
+int nvdimm_security_change_key(struct device *dev,
+		unsigned int old_keyid, unsigned int new_keyid)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key, *old_key;
+	int rc;
+	void *old_data = NULL, *new_data;
+	bool update = false;
+	struct user_key_payload *payload, *old_payload;
+
+	if (!nvdimm->security_ops)
+		return -EOPNOTSUPP;
+
+	if (nvdimm->state == NVDIMM_SECURITY_FROZEN)
+		return -EBUSY;
+
+	mutex_lock(&nvdimm->key_mutex);
+	/* look for a key from cached key if exists */
+	old_key = nvdimm_get_and_verify_key(dev, old_keyid);
+	if (IS_ERR(old_key)) {
+		mutex_unlock(&nvdimm->key_mutex);
+		return PTR_ERR(old_key);
+	}
+	if (old_key) {
+		dev_dbg(dev, "%s: old key: %#x\n",
+				__func__, key_serial(old_key));
+		update = true;
+	}
+
+	/* request new key from userspace */
+	key = nvdimm_lookup_user_key(dev, new_keyid);
+	if (!key) {
+		dev_dbg(dev, "%s: failed to acquire new key\n", __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	dev_dbg(dev, "%s: new key: %#x\n", __func__, key_serial(key));
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	rc = nvdimm_check_key_len(payload->datalen);
+	if (rc < 0) {
+		up_read(&key->sem);
+		goto out;
+	}
+
+	if (!update)
+		key = nvdimm_replace_key(key);
+
+	/*
+	 * We don't need to release key->sem here because
+	 * nvdimm_replace_key() will.
+	 */
+	if (!key)
+		goto out;
+
+	payload = key->payload.data[0];
+
+	if (old_key) {
+		down_read(&old_key->sem);
+		old_payload = old_key->payload.data[0];
+		old_data = old_payload->data;
+	}
+
+	new_data = payload->data;
+
+	rc = nvdimm->security_ops->change_key(nvdimm_bus, nvdimm, old_data,
+			new_data);
+	/* copy new payload to old payload */
+	if (rc == 0) {
+		if (update)
+			key_update(make_key_ref(old_key, 1), new_data,
+					old_key->datalen);
+	} else
+		dev_warn(dev, "key update failed\n");
+	if (old_key)
+		up_read(&old_key->sem);
+	up_read(&key->sem);
+
+	if (!update) {
+		if (rc == 0) {
+			dev_dbg(dev, "key cached: %#x\n", key_serial(key));
+			nvdimm->key = key;
+		} else
+			key_invalidate(key);
+	}
+	nvdimm_security_get_state(dev);
+
+ out:
+	mutex_unlock(&nvdimm->key_mutex);
+	return rc;
+}
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 934219232177..61bdc0c45c11 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -428,6 +428,8 @@ bool pmem_should_map_pages(struct device *dev);
 struct key *nvdimm_get_key(struct device *dev);
 int nvdimm_security_unlock_dimm(struct device *dev);
 int nvdimm_security_get_state(struct device *dev);
+int nvdimm_security_change_key(struct device *dev, unsigned int old_keyid,
+		unsigned int new_keyid);
 #else
 static inline struct key *nvdimm_get_key(struct device *dev)
 {
@@ -443,5 +445,11 @@ static inline int nvdimm_security_get_state(struct device *dev)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int nvdimm_security_change_key(struct device *dev,
+		unsigned int old_keyid, unsigned int new_keyid)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 #endif /* __ND_H__ */
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 257ff2637ce1..bd6a413164ee 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -160,6 +160,7 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_DISABLED,
 	NVDIMM_SECURITY_UNLOCKED,
 	NVDIMM_SECURITY_LOCKED,
+	NVDIMM_SECURITY_FROZEN,
 	NVDIMM_SECURITY_UNSUPPORTED,
 };
 
@@ -177,6 +178,10 @@ struct nvdimm_security_ops {
 	int (*unlock)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
+	int (*change_key)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *old_data,
+			const struct nvdimm_key_data *new_data);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
