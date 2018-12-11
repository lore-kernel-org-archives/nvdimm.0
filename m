Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B90F02119AC08
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:26:09 -0800 (PST)
Subject: [PATCH v13 08/17] acpi/nfit,
 libnvdimm: Add disable passphrase support to Intel nvdimm.
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:26:09 -0700
Message-ID: <154455996895.26509.1794498992650579619.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support to disable passphrase (security) for the Intel nvdimm. The
passphrase used for disabling is pulled from an encrypted-key in the kernel
user keyring. The action is triggered by writing "disable <keyid>" to the
sysfs attribute "security".

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c  |   44 +++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   17 +++++++++++-
 drivers/nvdimm/nd-core.h   |    1 +
 drivers/nvdimm/security.c  |   63 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    2 +
 5 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 5b627ca35d3b..5d4557cfb0d7 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -162,6 +162,49 @@ static int intel_security_unlock(struct nvdimm *nvdimm,
 	return 0;
 }
 
+static int intel_security_disable(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *key_data)
+{
+	int rc;
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
+	memcpy(nd_cmd.cmd.passphrase, key_data->data,
+			sizeof(nd_cmd.cmd.passphrase));
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
+	if (rc < 0)
+		return rc;
+
+	switch (nd_cmd.cmd.status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_INVALID_PASS:
+		return -EINVAL;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 /*
  * TODO: define a cross arch wbinvd equivalent when/if
  * NVDIMM_FAMILY_INTEL command support arrives on another arch.
@@ -182,6 +225,7 @@ static const struct nvdimm_security_ops __intel_security_ops = {
 	.state = intel_security_state,
 	.freeze = intel_security_freeze,
 	.change_key = intel_security_change_key,
+	.disable = intel_security_disable,
 #ifdef CONFIG_X86
 	.unlock = intel_security_unlock,
 #endif
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8e0bd2ce4dd0..3a5727102a30 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -391,17 +391,32 @@ static ssize_t security_show(struct device *dev,
 	return -ENOTTY;
 }
 
+#define SEC_CMD_SIZE 32
+#define KEY_ID_SIZE 10 /* u32 size in string */
 static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	ssize_t rc;
+	char cmd[SEC_CMD_SIZE+1], keystr[KEY_ID_SIZE+1];
+	unsigned int key;
 
 	if (atomic_read(&nvdimm->busy))
 		return -EBUSY;
 
+	rc = sscanf(buf, "%"__stringify(SEC_CMD_SIZE)"s %"__stringify(KEY_ID_SIZE)"s",
+			cmd, keystr);
 	if (sysfs_streq(buf, "freeze")) {
 		dev_dbg(dev, "freeze\n");
 		rc = nvdimm_security_freeze(nvdimm);
+	} else if (sysfs_streq(cmd, "disable")) {
+		if (rc != 2)
+			return -EINVAL;
+		rc = kstrtouint(keystr, 0, &key);
+		if (rc < 0)
+			return rc;
+		rc = nvdimm_security_disable(nvdimm, key);
+		if (rc < 0)
+			return rc;
 	} else
 		return -EINVAL;
 
@@ -452,7 +467,7 @@ static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (nvdimm->sec.state < 0)
 		return 0;
 	/* Are there any state mutation ops? */
-	if (nvdimm->sec.ops->freeze)
+	if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable)
 		return a->mode;
 	return 0444;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 15eff40f55f6..93e63c12ea45 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -57,6 +57,7 @@ static inline enum nvdimm_security_state nvdimm_security_state(
 	return nvdimm->sec.ops->state(nvdimm);
 }
 int nvdimm_security_freeze(struct nvdimm *nvdimm);
+int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
 
 /**
  * struct blk_alloc_info - tracking info for BLK dpa scanning
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 51d77a67a9fb..55d8806a5040 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -69,6 +69,36 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
 	return key;
 }
 
+static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
+		key_serial_t id)
+{
+	key_ref_t keyref;
+	struct key *key;
+	struct encrypted_key_payload *epayload;
+	struct device *dev = &nvdimm->dev;
+
+	keyref = lookup_user_key(id, 0, 0);
+	if (IS_ERR(keyref))
+		return NULL;
+
+	key = key_ref_to_ptr(keyref);
+	if (key->type != &key_type_encrypted) {
+		key_put(key);
+		return NULL;
+	}
+	dev_dbg(dev, "%s: key found: %#x\n", __func__, key_serial(key));
+
+
+	down_read(&key->sem);
+	epayload = dereference_key_locked(key);
+	if (epayload->decrypted_datalen != NVDIMM_PASSPHRASE_LEN) {
+		up_read(&key->sem);
+		key_put(key);
+		key = NULL;
+	}
+	return key;
+}
+
 static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
 {
 	struct key *key;
@@ -146,3 +176,36 @@ int nvdimm_security_unlock(struct device *dev)
 	nvdimm_bus_unlock(dev);
 	return rc;
 }
+
+int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
+{
+	struct device *dev = &nvdimm->dev;
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	int rc;
+
+	/* The bus lock should be held at the top level of the call stack */
+	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
+
+	if (!nvdimm->sec.ops || !nvdimm->sec.ops->disable
+			|| nvdimm->sec.state < 0)
+		return -EIO;
+
+	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
+		dev_warn(dev, "Incorrect security state: %d\n",
+				nvdimm->sec.state);
+		return -EIO;
+	}
+
+	key = nvdimm_lookup_user_key(nvdimm, keyid);
+	if (!key)
+		return -ENOKEY;
+
+	rc = nvdimm->sec.ops->disable(nvdimm, key_data(key));
+	dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
+			rc == 0 ? "success" : "fail");
+
+	nvdimm_put_key(key);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	return rc;
+}
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0f0ab276134e..d0afa115356e 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -178,6 +178,8 @@ struct nvdimm_security_ops {
 			const struct nvdimm_key_data *new_data);
 	int (*unlock)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
+	int (*disable)(struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *key_data);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
