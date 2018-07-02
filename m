Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04909210DF4E2
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:39:35 -0700 (PDT)
Subject: [PATCH 05/11] nfit/libnvdimm: add set passphrase support for Intel
 nvdimms
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:39:34 -0700
Message-ID: <153057477488.38125.10748005421631673877.stgit@djiang5-desk3.ch.intel.com>
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

Adding support for setting and/or updating passphrase on the Intel nvdimms.
The passphrase is pulled from userspace through the kernel key management.
We trigger the update via writing "update" to the sysfs attribute
"security". The state of the security can also be read via the "security"
attribute. libnvdimm will generically support the key_change API call.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.c  |   54 ++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |  110 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    4 ++
 3 files changed, 168 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 1bdb493694e0..792a5c694a9e 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -16,6 +16,59 @@
 #include <acpi/nfit.h>
 #include "nfit.h"
 
+static int intel_dimm_security_update_passphrase(
+		struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+		const char *old_pass, const char *new_pass)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0, pkg_size;
+	struct nd_intel_set_passphrase *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	pkg_size = sizeof(*pkg) + sizeof(*cmd);
+	pkg = kzalloc(pkg_size, GFP_KERNEL);
+	if (!pkg)
+		return -ENOMEM;
+
+	pkg->nd_command = NVDIMM_INTEL_SET_PASSPHRASE;
+	pkg->nd_family = NVDIMM_FAMILY_INTEL;
+	pkg->nd_size_in = ND_INTEL_PASSPHRASE_SIZE * 2;
+	pkg->nd_size_out = ND_INTEL_STATUS_SIZE;
+	pkg->nd_fw_size = pkg->nd_size_out;
+	cmd = (struct nd_intel_set_passphrase *)&pkg->nd_payload;
+	if (old_pass)
+		memcpy(cmd->old_pass, old_pass, ND_INTEL_PASSPHRASE_SIZE);
+	memcpy(cmd->new_pass, new_pass, ND_INTEL_PASSPHRASE_SIZE);
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
 static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
 		struct nvdimm *nvdimm, const char *passphrase)
 {
@@ -139,4 +192,5 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
 struct nvdimm_security_ops intel_security_ops = {
 	.state = intel_dimm_security_state,
 	.unlock = intel_dimm_security_unlock,
+	.change_key = intel_dimm_security_update_passphrase,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index f92bbe78e0df..d3d738c77adb 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -131,6 +131,75 @@ int nvdimm_security_unlock_dimm(struct device *dev)
 	return rc;
 }
 
+static int nvdimm_security_change_key(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key = NULL, *old_key = NULL;
+	int rc;
+	char *old_pass, *new_pass;
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
+	if (key->datalen == NVDIMM_DEFAULT_PASSPHRASE_LEN) {
+		old_pass = NULL;
+		new_pass = key->payload.data[0];
+	} else if (key->datalen == (NVDIMM_DEFAULT_PASSPHRASE_LEN * 2)) {
+		old_pass = key->payload.data[0];
+		new_pass = old_pass + NVDIMM_DEFAULT_PASSPHRASE_LEN;
+	} else {
+		key_invalidate(key);
+		key_put(key);
+		dev_warn(dev, "Incorrect key payload size for update: %u\n",
+				key->datalen);
+		return -EINVAL;
+	}
+
+	down_read(&key->sem);
+	rc = nvdimm->security_ops->change_key(nvdimm_bus, nvdimm, old_pass,
+			new_pass);
+	if (rc == 0 && key->datalen == (NVDIMM_DEFAULT_PASSPHRASE_LEN * 2))
+		memcpy(old_pass, new_pass, NVDIMM_DEFAULT_PASSPHRASE_LEN);
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
@@ -488,11 +557,52 @@ static ssize_t available_slots_show(struct device *dev,
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
+	if (strcmp(buf, "update") == 0 || strcmp(buf, "update\n") == 0)
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
index be98afb5f27e..7b609409042c 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -162,6 +162,7 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_DISABLED,
 	NVDIMM_SECURITY_UNLOCKED,
 	NVDIMM_SECURITY_LOCKED,
+	NVDIMM_SECURITY_FROZEN,
 	NVDIMM_SECURITY_UNSUPPORTED,
 };
 
@@ -173,6 +174,9 @@ struct nvdimm_security_ops {
 			enum nvdimm_security_state *state);
 	int (*unlock)(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm *nvdimm, const char *passphrase);
+	int (*change_key)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm, const char *old_pass,
+			const char *new_pass);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
