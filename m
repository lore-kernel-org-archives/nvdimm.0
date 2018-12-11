Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5195E2119A47B
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:26:20 -0800 (PST)
Subject: [PATCH v13 10/17] acpi/nfit,
 libnvdimm: Add support for issue secure erase DSM to Intel nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:26:19 -0700
Message-ID: <154455997973.26509.10438790815435246380.stgit@djiang5-desk3.ch.intel.com>
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

Add support to issue a secure erase DSM to the Intel nvdimm. The
required passphrase is acquired from an encrypted key in the kernel user
keyring. To trigger the action, "erase <keyid>" is written to the
"security" sysfs attribute.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/intel.c  |   50 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/dimm_devs.c |   12 ++++++++++-
 drivers/nvdimm/nd-core.h   |    1 +
 drivers/nvdimm/security.c  |   41 ++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h  |    2 ++
 5 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 5d4557cfb0d7..ce65111ea4e1 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -205,6 +205,55 @@ static int intel_security_disable(struct nvdimm *nvdimm,
 	return 0;
 }
 
+static int intel_security_erase(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *key)
+{
+	int rc;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_secure_erase cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
+			.nd_size_out = ND_INTEL_STATUS_SIZE,
+			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+			.nd_command = NVDIMM_INTEL_SECURE_ERASE,
+		},
+		.cmd = {
+			.status = 0,
+		},
+	};
+
+	if (!test_bit(NVDIMM_INTEL_SECURE_ERASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	/* flush all cache before we erase DIMM */
+	nvdimm_invalidate_cache();
+	memcpy(nd_cmd.cmd.passphrase, key->data,
+			sizeof(nd_cmd.cmd.passphrase));
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
+	if (rc < 0)
+		return rc;
+
+	switch (nd_cmd.cmd.status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case ND_INTEL_STATUS_INVALID_PASS:
+		return -EINVAL;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		return -ENXIO;
+	}
+
+	/* DIMM erased, invalidate all CPU caches before we read it */
+	nvdimm_invalidate_cache();
+	return 0;
+}
+
 /*
  * TODO: define a cross arch wbinvd equivalent when/if
  * NVDIMM_FAMILY_INTEL command support arrives on another arch.
@@ -228,6 +277,7 @@ static const struct nvdimm_security_ops __intel_security_ops = {
 	.disable = intel_security_disable,
 #ifdef CONFIG_X86
 	.unlock = intel_security_unlock,
+	.erase = intel_security_erase,
 #endif
 };
 
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8669000ea6a6..e3b46849ee0a 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -430,6 +430,15 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 		rc = nvdimm_security_update(nvdimm, key, newkey);
 		if (rc < 0)
 			return rc;
+	} else if (sysfs_streq(cmd, "erase")) {
+		if (rc != 2)
+			return -EINVAL;
+		rc = kstrtouint(keystr, 0, &key);
+		if (rc < 0)
+			return rc;
+		rc = nvdimm_security_erase(nvdimm, key);
+		if (rc < 0)
+			return rc;
 	} else
 		return -EINVAL;
 
@@ -481,7 +490,8 @@ static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
 		return 0;
 	/* Are there any state mutation ops? */
 	if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
-			|| nvdimm->sec.ops->change_key)
+			|| nvdimm->sec.ops->change_key
+			|| nvdimm->sec.ops->erase)
 		return a->mode;
 	return 0444;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index ca020793a419..3c8cdd40c456 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -60,6 +60,7 @@ int nvdimm_security_freeze(struct nvdimm *nvdimm);
 int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
 int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 		unsigned int new_keyid);
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
 
 /**
  * struct blk_alloc_info - tracking info for BLK dpa scanning
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 654b64fe7e9d..4836f2fda271 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -33,6 +33,9 @@ static void *key_data(struct key *key)
 
 static void nvdimm_put_key(struct key *key)
 {
+	if (!key)
+		return;
+
 	up_read(&key->sem);
 	key_put(key);
 }
@@ -259,3 +262,41 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 	nvdimm->sec.state = nvdimm_security_state(nvdimm);
 	return rc;
 }
+
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
+{
+	struct device *dev = &nvdimm->dev;
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	int rc;
+
+	/* The bus lock should be held at the top level of the call stack */
+	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
+
+	if (!nvdimm->sec.ops || !nvdimm->sec.ops->erase
+			|| nvdimm->sec.state < 0)
+		return -EIO;
+
+	if (atomic_read(&nvdimm->busy)) {
+		dev_warn(dev, "Unable to secure erase while DIMM active.\n");
+		return -EBUSY;
+	}
+
+	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
+		dev_warn(dev, "Incorrect security state: %d\n",
+				nvdimm->sec.state);
+		return -EIO;
+	}
+
+	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
+	if (!key)
+		return -ENOKEY;
+
+	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key));
+	dev_dbg(dev, "key: %d erase: %s\n", key_serial(key),
+			rc == 0 ? "success" : "fail");
+
+	nvdimm_put_key(key);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	return rc;
+}
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d0afa115356e..9a6cb7067dc7 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -180,6 +180,8 @@ struct nvdimm_security_ops {
 			const struct nvdimm_key_data *key_data);
 	int (*disable)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
+	int (*erase)(struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *key_data);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
