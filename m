Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97D1121102D93
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:47:52 -0700 (PDT)
Subject: [PATCH v8 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:47:51 -0700
Message-ID: <153549647177.4089.18112512093259339717.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
References: <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: alison.schofield@intel.com, keescook@chromium.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for setting and/or updating passphrase on the Intel nvdimms.
The passphrase is pulled from userspace through the kernel key management.
We trigger the update via writing "update" to the sysfs attribute
"security". The state of the security can also be read via the "security"
attribute. libnvdimm will generically support the key_change API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |   68 ++++++++++++
 drivers/nvdimm/dimm_devs.c |  256 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    5 +
 3 files changed, 329 insertions(+)

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
index fe61f2a2ad5d..e7129998a5f3 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/key.h>
 #include <linux/init_task.h>
+#include <linux/key-type.h>
 #include <keys/user-type.h>
 #include "nd-core.h"
 #include "label.h"
@@ -51,6 +52,57 @@ static struct key *nvdimm_get_key(struct device *dev)
 	return nvdimm->key;
 }
 
+/*
+ * Replacing the user key with a kernel key
+ */
+static struct key *nvdimm_replace_key(struct key *key)
+{
+	struct key *new_key;
+	struct user_key_payload *payload;
+	int rc;
+
+	new_key = key_alloc(&key_type_logon, key->description,
+			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, &init_cred, 0,
+			KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(new_key))
+		return NULL;
+
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	rc = key_instantiate_and_link(new_key, payload->data, key->datalen,
+			nvdimm_keyring, NULL);
+	up_read(&key->sem);
+	if (rc < 0) {
+		key_revoke(new_key);
+		key_put(new_key);
+		return NULL;
+	}
+
+	key_invalidate(key);
+	key_put(key);
+
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
+	dev_dbg(dev, "%s: key found: %d\n", __func__, key_serial(key));
+
+	return key;
+}
+
 /*
  * Retrieve kernel key for DIMM and request from user space if necessary.
  */
@@ -152,6 +204,96 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 	return rc;
 }
 
+static int nvdimm_security_change_key(struct device *dev,
+		unsigned int old_keyid, unsigned int new_keyid)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key = NULL, *old_key = NULL;
+	int rc;
+	void *old_data, *new_data;
+	bool update = false;
+	struct user_key_payload *payload;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	if (nvdimm->state == NVDIMM_SECURITY_FROZEN)
+		return -EBUSY;
+
+	/* look for a key from keyring if exists and remove */
+	if (old_keyid != 0) {
+		old_key = nvdimm_get_key(dev);
+		if (old_key) {
+			if (key_serial(old_key) != old_keyid) {
+				dev_warn(dev, "incorrect key id: %u\n",
+						old_keyid);
+				return -EINVAL;
+			}
+			dev_dbg(dev, "%s: old key: %#x\n",
+					__func__, key_serial(old_key));
+			update = true;
+		}
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
+	rc = nvdimm_check_key_len(key->datalen, update);
+	if (rc < 0)
+		goto out;
+
+	if (!update)
+		key = nvdimm_replace_key(key);
+
+	if (!key)
+		goto out;
+
+	payload = key->payload.data[0];
+	if (!update) {
+		old_data = NULL;
+		new_data = payload->data;
+	} else {
+		new_data = payload->data;
+		old_data = new_data + NVDIMM_PASSPHRASE_LEN;
+	}
+
+	down_read(&key->sem);
+	rc = nvdimm->security_ops->change_key(nvdimm_bus, nvdimm, old_data,
+			new_data);
+	/* copy new payload to old payload */
+	if (rc == 0) {
+		if (update)
+			key_update(make_key_ref(old_key, 1), new_data,
+					old_key->datalen);
+	} else
+		dev_warn(dev, "key update failed\n");
+	up_read(&key->sem);
+
+	if (update)
+		key_invalidate(key);
+	else {
+		key_link(nvdimm_keyring, key);
+		nvdimm->key = key;
+		key->perm |= KEY_USR_SEARCH;
+	}
+	nvdimm_security_get_state(dev);
+
+ out:
+	if (old_key)
+		key_put(old_key);
+	if (key)
+		key_put(key);
+	return rc;
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
@@ -509,11 +651,125 @@ static ssize_t available_slots_show(struct device *dev,
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
+/*
+ * The update command:
+ *	update:<old_id>:<new_id>
+ */
+#define STR_UPDATE_LEN		6
+/* ":0:0" */
+#define NVDIMM_UPDATE_MIN_LEN	STR_UPDATE_LEN + 4
+
+static int __parse_update(const char *buf, size_t len, unsigned int *old_id,
+		unsigned int *new_id)
+{
+	int i, rc = 0;
+	const char *tmp, *old_idstr;
+	char *desc;
+	size_t buf_len;
+
+	if (len < NVDIMM_UPDATE_MIN_LEN)
+		return -EINVAL;
+
+	desc = kmemdup_nul(buf, STR_UPDATE_LEN, GFP_KERNEL);
+	if (!desc)
+		return -EINVAL;
+
+	if (strcmp(desc, "update") != 0) {
+		rc = -ENOMEM;
+		goto free_desc;
+	}
+
+	tmp = &buf[STR_UPDATE_LEN];
+	if (*tmp != ':') {
+		rc = -EINVAL;
+		goto free_desc;
+	}
+
+	tmp++;
+
+	buf_len = len - STR_UPDATE_LEN - 1;
+	for (i = 0; i < buf_len; i++) {
+		if (tmp[i] == ':')
+			break;
+	}
+
+	old_idstr = kmemdup_nul(tmp, i, GFP_KERNEL);
+	if (!old_idstr) {
+		rc = -ENOMEM;
+		goto free_desc;
+	}
+
+	rc = kstrtouint(old_idstr, 0, old_id);
+	if (rc < 0)
+		goto free_old;
+
+	tmp += i + 1;
+
+	rc = kstrtouint(tmp, 0, new_id);
+	if (rc < 0)
+		goto free_old;
+
+free_old:
+	kfree(old_idstr);
+free_desc:
+	kfree(desc);
+	return rc;
+}
+
+static ssize_t security_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	ssize_t rc = -EINVAL;
+	unsigned int new_id, old_id;
+
+        wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
+        if (atomic_read(&nvdimm->busy))
+                return -EBUSY;
+
+	if (__parse_update(buf, len, &old_id, &new_id) == 0) {
+		dev_dbg(dev, "update: old: %u new: %u\n", old_id, new_id);
+		rc = nvdimm_security_change_key(dev, old_id, new_id);
+	} else
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
