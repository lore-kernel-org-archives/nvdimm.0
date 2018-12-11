Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEA582119AC08
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:26:36 -0800 (PST)
Subject: [PATCH v13 13/17] acpi/nfit,
 libnvdimm/security: add Intel DSM 1.8 master passphrase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:26:36 -0700
Message-ID: <154455999610.26509.15229596933105420734.stgit@djiang5-desk3.ch.intel.com>
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

With Intel DSM 1.8 [1] two new security DSMs are introduced. Enable/update
master passphrase and master secure erase. The master passphrase allows
a secure erase to be performed without the user passphrase that is set on
the NVDIMM. The commands of master_update and master_erase are added to
the sysfs knob in order to initiate the DSMs. They are similar in opeartion
mechanism compare to update and erase.

[1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.8.pdf

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c   |    2 +
 drivers/acpi/nfit/intel.c  |   61 ++++++++++++++++++++++++++++++++------------
 drivers/nvdimm/dimm_devs.c |   33 +++++++++++++++++++++---
 drivers/nvdimm/nd-core.h   |   10 ++++---
 drivers/nvdimm/security.c  |   41 ++++++++++++++++++++----------
 include/linux/libnvdimm.h  |    9 ++++--
 6 files changed, 115 insertions(+), 41 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 173517eb35b1..2e92b9d51c38 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -389,6 +389,8 @@ static u8 nfit_dsm_revid(unsigned family, unsigned func)
 			[NVDIMM_INTEL_SECURE_ERASE] = 2,
 			[NVDIMM_INTEL_OVERWRITE] = 2,
 			[NVDIMM_INTEL_QUERY_OVERWRITE] = 2,
+			[NVDIMM_INTEL_SET_MASTER_PASSPHRASE] = 2,
+			[NVDIMM_INTEL_MASTER_SECURE_ERASE] = 2,
 		},
 	};
 	u8 id;
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 3c3f99dfc32c..09317ea23e72 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -6,7 +6,8 @@
 #include "intel.h"
 #include "nfit.h"
 
-static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
+static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm,
+		bool master)
 {
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -34,17 +35,28 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
 		return -EIO;
 
 	/* check and see if security is enabled and locked */
-	if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
-		return -ENXIO;
-	else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
-		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
-			return NVDIMM_SECURITY_LOCKED;
-		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN ||
-				nd_cmd.cmd.state & ND_INTEL_SEC_STATE_PLIMIT)
-			return NVDIMM_SECURITY_FROZEN;
-		else
-			return NVDIMM_SECURITY_UNLOCKED;
+	if (master) {
+		if (nd_cmd.cmd.extended_state & ND_INTEL_SEC_ESTATE_ENABLED)
+			return NVDIMM_SECURITY_MASTER_ENABLED;
+		else if (nd_cmd.cmd.extended_state &
+				ND_INTEL_SEC_ESTATE_PLIMIT)
+			return NVDIMM_SECURITY_MASTER_FROZEN;
+	} else {
+		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
+			return -ENXIO;
+		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
+			if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
+				return NVDIMM_SECURITY_LOCKED;
+			else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN
+					|| nd_cmd.cmd.state &
+					ND_INTEL_SEC_STATE_PLIMIT)
+				return NVDIMM_SECURITY_FROZEN;
+			else
+				return NVDIMM_SECURITY_UNLOCKED;
+		}
 	}
+
+	/* this should cover master security disabled as well */
 	return NVDIMM_SECURITY_DISABLED;
 }
 
@@ -77,7 +89,8 @@ static int intel_security_freeze(struct nvdimm *nvdimm)
 
 static int intel_security_change_key(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *old_data,
-		const struct nvdimm_key_data *new_data)
+		const struct nvdimm_key_data *new_data,
+		bool master)
 {
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -85,7 +98,6 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 		struct nd_intel_set_passphrase cmd;
 	} nd_cmd = {
 		.pkg = {
-			.nd_command = NVDIMM_INTEL_SET_PASSPHRASE,
 			.nd_family = NVDIMM_FAMILY_INTEL,
 			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE * 2,
 			.nd_size_out = ND_INTEL_STATUS_SIZE,
@@ -94,7 +106,15 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 	};
 	int rc;
 
-	if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask))
+	if (master)
+		nd_cmd.pkg.nd_command = NVDIMM_INTEL_SET_MASTER_PASSPHRASE;
+	else
+		nd_cmd.pkg.nd_command = NVDIMM_INTEL_SET_PASSPHRASE;
+
+	if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask) ||
+			(master &&
+			 !test_bit(NVDIMM_INTEL_SET_MASTER_PASSPHRASE,
+				 &nfit_mem->dsm_mask)))
 		return -ENOTTY;
 
 	if (old_data)
@@ -206,7 +226,7 @@ static int intel_security_disable(struct nvdimm *nvdimm,
 }
 
 static int intel_security_erase(struct nvdimm *nvdimm,
-		const struct nvdimm_key_data *key)
+		const struct nvdimm_key_data *key, bool master)
 {
 	int rc;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -219,14 +239,21 @@ static int intel_security_erase(struct nvdimm *nvdimm,
 			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
 			.nd_size_out = ND_INTEL_STATUS_SIZE,
 			.nd_fw_size = ND_INTEL_STATUS_SIZE,
-			.nd_command = NVDIMM_INTEL_SECURE_ERASE,
 		},
 		.cmd = {
 			.status = 0,
 		},
 	};
 
-	if (!test_bit(NVDIMM_INTEL_SECURE_ERASE, &nfit_mem->dsm_mask))
+	if (master)
+		nd_cmd.pkg.nd_command = NVDIMM_INTEL_MASTER_SECURE_ERASE;
+	else
+		nd_cmd.pkg.nd_command = NVDIMM_INTEL_SECURE_ERASE;
+
+	if (!test_bit(NVDIMM_INTEL_SECURE_ERASE, &nfit_mem->dsm_mask) ||
+			(master &&
+			 !test_bit(NVDIMM_INTEL_MASTER_SECURE_ERASE,
+				 &nfit_mem->dsm_mask)))
 		return -ENOTTY;
 
 	/* flush all cache before we erase DIMM */
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index fa42774efb15..8825551aad84 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -387,6 +387,8 @@ static ssize_t security_show(struct device *dev,
 		return sprintf(buf, "frozen\n");
 	case NVDIMM_SECURITY_OVERWRITE:
 		return sprintf(buf, "overwrite\n");
+	default:
+		return -ENOTTY;
 	}
 
 	return -ENOTTY;
@@ -428,7 +430,7 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 		rc = kstrtouint(nkeystr, 0, &newkey);
 		if (rc < 0)
 			return rc;
-		rc = nvdimm_security_update(nvdimm, key, newkey);
+		rc = nvdimm_security_update(nvdimm, key, newkey, false);
 		if (rc < 0)
 			return rc;
 	} else if (sysfs_streq(cmd, "erase")) {
@@ -437,7 +439,7 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 		rc = kstrtouint(keystr, 0, &key);
 		if (rc < 0)
 			return rc;
-		rc = nvdimm_security_erase(nvdimm, key);
+		rc = nvdimm_security_erase(nvdimm, key, false);
 		if (rc < 0)
 			return rc;
 	} else if (sysfs_streq(cmd, "overwite")) {
@@ -449,6 +451,27 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 		rc = nvdimm_security_overwrite(nvdimm, key);
 		if (rc < 0)
 			return rc;
+	} else if (sysfs_streq(cmd, "master_update")) {
+		if (rc != 3)
+			return -EINVAL;
+		rc = kstrtouint(keystr, 0, &key);
+		if (rc < 0)
+			return rc;
+		rc = kstrtouint(nkeystr, 0, &newkey);
+		if (rc < 0)
+			return rc;
+		rc = nvdimm_security_update(nvdimm, key, newkey, true);
+		if (rc < 0)
+			return rc;
+	} else if (sysfs_streq(cmd, "master_erase")) {
+		if (rc != 2)
+			return -EINVAL;
+		rc = kstrtouint(keystr, 0, &key);
+		if (rc < 0)
+			return rc;
+		rc = nvdimm_security_erase(nvdimm, key, true);
+		if (rc < 0)
+			return rc;
 	} else
 		return -EINVAL;
 
@@ -551,7 +574,9 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	 * Security state must be initialized before device_add() for
 	 * attribute visibility.
 	 */
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	/* get security state and extended (master) state */
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
+	nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, true);
 	nd_device_register(dev);
 
 	return nvdimm;
@@ -587,7 +612,7 @@ int nvdimm_security_freeze(struct nvdimm *nvdimm)
 	}
 
 	rc = nvdimm->sec.ops->freeze(nvdimm);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
 
 	return rc;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 2c93e2139346..f3e05e32c530 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -46,6 +46,7 @@ struct nvdimm {
 	struct {
 		const struct nvdimm_security_ops *ops;
 		enum nvdimm_security_state state;
+		enum nvdimm_security_state ext_state;
 		unsigned int overwrite_tmo;
 		struct kernfs_node *overwrite_state;
 	} sec;
@@ -53,18 +54,19 @@ struct nvdimm {
 };
 
 static inline enum nvdimm_security_state nvdimm_security_state(
-		struct nvdimm *nvdimm)
+		struct nvdimm *nvdimm, bool master)
 {
 	if (!nvdimm->sec.ops)
 		return -ENXIO;
 
-	return nvdimm->sec.ops->state(nvdimm);
+	return nvdimm->sec.ops->state(nvdimm, master);
 }
 int nvdimm_security_freeze(struct nvdimm *nvdimm);
 int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
 int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
-		unsigned int new_keyid);
-int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
+		unsigned int new_keyid, bool master);
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
+		bool master);
 static inline int nvdimm_security_check_busy(struct nvdimm *nvdimm)
 {
 	if (test_bit(NDD_SECURITY_BUSY, &nvdimm->flags))
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 3603c5fda1cf..a10eaf4e23c3 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -121,7 +121,8 @@ static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
 	 * Send the same key to the hardware as new and old key to
 	 * verify that the key is good.
 	 */
-	rc = nvdimm->sec.ops->change_key(nvdimm, key_data(key), key_data(key));
+	rc = nvdimm->sec.ops->change_key(nvdimm, key_data(key),
+			key_data(key), false);
 	if (rc < 0) {
 		nvdimm_put_key(key);
 		key = NULL;
@@ -174,7 +175,7 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
 	return rc;
 }
 
@@ -224,12 +225,12 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
 	return rc;
 }
 
 int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
-		unsigned int new_keyid)
+		unsigned int new_keyid, bool master)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
@@ -264,18 +265,23 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 	}
 
 	rc = nvdimm->sec.ops->change_key(nvdimm, key ? key_data(key) : NULL,
-			key_data(newkey));
-	dev_dbg(dev, "key: %d %d update: %s\n",
+			key_data(newkey), master);
+	dev_dbg(dev, "key: %d %d update%s: %s\n",
 			key_serial(key), key_serial(newkey),
+			master ? "(master)" : "",
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(newkey);
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	if (master)
+		nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, true);
+	else
+		nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
 	return rc;
 }
 
-int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
+		bool master)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
@@ -306,16 +312,24 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		return rc;
 	}
 
+	if (nvdimm->sec.ext_state !=
+			NVDIMM_SECURITY_MASTER_ENABLED	&& master) {
+		dev_warn(dev,
+			"Attempt to secure erase in wrong master state.\n");
+		return -EOPNOTSUPP;
+	}
+
 	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 	if (!key)
 		return -ENOKEY;
 
-	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key));
-	dev_dbg(dev, "key: %d erase: %s\n", key_serial(key),
+	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key), master);
+	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
+			master ? "(master)" : "",
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
 	return rc;
 }
 
@@ -370,7 +384,7 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
 	nvdimm_set_security_busy(nvdimm);
 	return rc;
 }
@@ -412,5 +426,6 @@ void nvdimm_security_overwrite_query(struct work_struct *work)
 		sysfs_notify_dirent(nvdimm->sec.overwrite_state);
 	nvdimm->sec.overwrite_tmo = 0;
 	nvdimm_clear_security_busy(nvdimm);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, false);
+	nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, true);
 }
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index b728952ccb28..5383a22d6ba0 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -163,6 +163,8 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_LOCKED,
 	NVDIMM_SECURITY_FROZEN,
 	NVDIMM_SECURITY_OVERWRITE,
+	NVDIMM_SECURITY_MASTER_ENABLED,
+	NVDIMM_SECURITY_MASTER_FROZEN,
 };
 
 #define NVDIMM_PASSPHRASE_LEN		32
@@ -173,17 +175,18 @@ struct nvdimm_key_data {
 };
 
 struct nvdimm_security_ops {
-	enum nvdimm_security_state (*state)(struct nvdimm *nvdimm);
+	enum nvdimm_security_state (*state)(struct nvdimm *nvdimm,
+			bool master);
 	int (*freeze)(struct nvdimm *nvdimm);
 	int (*change_key)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *old_data,
-			const struct nvdimm_key_data *new_data);
+			const struct nvdimm_key_data *new_data, bool master);
 	int (*unlock)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*disable)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*erase)(struct nvdimm *nvdimm,
-			const struct nvdimm_key_data *key_data);
+			const struct nvdimm_key_data *key_data, bool master);
 	int (*overwrite)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*query_overwrite)(struct nvdimm *nvdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
