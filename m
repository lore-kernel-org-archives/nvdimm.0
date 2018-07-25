Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 42D07209884B7
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 13:59:05 -0700 (PDT)
Subject: [PATCH v6 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 25 Jul 2018 13:58:59 -0700
Message-ID: <153255233932.51274.17371670672074459834.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
References: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/acpi/nfit/intel.c  |   68 +++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |  120 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    5 ++
 3 files changed, 193 insertions(+)

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
index 5b247f94807a..c6029e3f329e 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -156,6 +156,79 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 	return rc;
 }
 
+static int nvdimm_security_change_key(struct device *dev)
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
+	old_key = nvdimm_search_key(dev);
+	if (old_key) {
+		dev_dbg(dev, "%s: old key: %#x\n",
+				__func__, key_serial(old_key));
+		update = true;
+	}
+
+	/* request new key from userspace */
+	key = nvdimm_request_key(dev, update);
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
+		else
+			nvdimm->key_id = key_serial(key);
+	} else
+		dev_warn(dev, "key update failed\n");
+	up_read(&key->sem);
+
+	if (update)
+		key_invalidate(key);
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
@@ -513,11 +586,58 @@ static ssize_t available_slots_show(struct device *dev,
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
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	ssize_t rc = -EINVAL;
+
+        wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
+        if (atomic_read(&nvdimm->busy))
+                return -EBUSY;
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
