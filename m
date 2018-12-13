Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82B69211A2DA1
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 15:49:03 -0800 (PST)
Subject: [PATCH v15 12/16] acpi/nfit,
 libnvdimm/security: add Intel DSM 1.8 master passphrase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 13 Dec 2018 16:49:03 -0700
Message-ID: <154474494296.64529.5458307768576375796.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
References: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
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
 drivers/acpi/nfit/core.c   |    2 ++
 drivers/acpi/nfit/intel.c  |   53 ++++++++++++++++++++++++++++++--------------
 drivers/nvdimm/dimm_devs.c |   34 ++++++++++++++++++++--------
 drivers/nvdimm/nd-core.h   |   11 ++++++---
 drivers/nvdimm/security.c  |   43 ++++++++++++++++++++++++++----------
 include/linux/libnvdimm.h  |   14 +++++++++---
 6 files changed, 111 insertions(+), 46 deletions(-)

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
index f33044b73591..78fbc095508e 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -7,7 +7,8 @@
 #include "intel.h"
 #include "nfit.h"
 
-static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
+static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm,
+		enum nvdimm_passphrase_type ptype)
 {
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 	struct {
@@ -33,7 +34,7 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
 	 * The DSM spec states that the security state is indeterminate
 	 * until the overwrite DSM completes.
 	 */
-	if (nvdimm_in_overwrite(nvdimm))
+	if (nvdimm_in_overwrite(nvdimm) && ptype == NVDIMM_USER)
 		return NVDIMM_SECURITY_OVERWRITE;
 
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -43,17 +44,28 @@ static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
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
+	if (ptype == NVDIMM_MASTER) {
+		if (nd_cmd.cmd.extended_state & ND_INTEL_SEC_ESTATE_ENABLED)
 			return NVDIMM_SECURITY_UNLOCKED;
+		else if (nd_cmd.cmd.extended_state &
+				ND_INTEL_SEC_ESTATE_PLIMIT)
+			return NVDIMM_SECURITY_FROZEN;
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
 
@@ -86,24 +98,28 @@ static int intel_security_freeze(struct nvdimm *nvdimm)
 
 static int intel_security_change_key(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *old_data,
-		const struct nvdimm_key_data *new_data)
+		const struct nvdimm_key_data *new_data,
+		enum nvdimm_passphrase_type ptype)
 {
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	unsigned int cmd = ptype == NVDIMM_MASTER ?
+		NVDIMM_INTEL_SET_MASTER_PASSPHRASE :
+		NVDIMM_INTEL_SET_PASSPHRASE;
 	struct {
 		struct nd_cmd_pkg pkg;
 		struct nd_intel_set_passphrase cmd;
 	} nd_cmd = {
 		.pkg = {
-			.nd_command = NVDIMM_INTEL_SET_PASSPHRASE,
 			.nd_family = NVDIMM_FAMILY_INTEL,
 			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE * 2,
 			.nd_size_out = ND_INTEL_STATUS_SIZE,
 			.nd_fw_size = ND_INTEL_STATUS_SIZE,
+			.nd_command = cmd,
 		},
 	};
 	int rc;
 
-	if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask))
+	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
 	if (old_data)
@@ -212,10 +228,13 @@ static int intel_security_disable(struct nvdimm *nvdimm,
 }
 
 static int intel_security_erase(struct nvdimm *nvdimm,
-		const struct nvdimm_key_data *key)
+		const struct nvdimm_key_data *key,
+		enum nvdimm_passphrase_type ptype)
 {
 	int rc;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	unsigned int cmd = ptype == NVDIMM_MASTER ?
+		NVDIMM_INTEL_MASTER_SECURE_ERASE : NVDIMM_INTEL_SECURE_ERASE;
 	struct {
 		struct nd_cmd_pkg pkg;
 		struct nd_intel_secure_erase cmd;
@@ -225,11 +244,11 @@ static int intel_security_erase(struct nvdimm *nvdimm,
 			.nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
 			.nd_size_out = ND_INTEL_STATUS_SIZE,
 			.nd_fw_size = ND_INTEL_STATUS_SIZE,
-			.nd_command = NVDIMM_INTEL_SECURE_ERASE,
+			.nd_command = cmd,
 		},
 	};
 
-	if (!test_bit(NVDIMM_INTEL_SECURE_ERASE, &nfit_mem->dsm_mask))
+	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
 	/* flush all cache before we erase DIMM */
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 6affa270abd3..bd3f156463b1 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -386,17 +386,21 @@ static ssize_t security_show(struct device *dev,
 		return sprintf(buf, "frozen\n");
 	case NVDIMM_SECURITY_OVERWRITE:
 		return sprintf(buf, "overwrite\n");
+	default:
+		return -ENOTTY;
 	}
 
 	return -ENOTTY;
 }
 
-#define OPS						\
-	C( OP_FREEZE,		"freeze",	1),	\
-	C( OP_DISABLE,		"disable",	2),	\
-	C( OP_UPDATE,		"update",	3),	\
-	C( OP_ERASE,		"erase",	2),	\
-	C( OP_OVERWRITE,	"overwrite",	2)
+#define OPS							\
+	C( OP_FREEZE,		"freeze",		1),	\
+	C( OP_DISABLE,		"disable",		2),	\
+	C( OP_UPDATE,		"update",		3),	\
+	C( OP_ERASE,		"erase",		2),	\
+	C( OP_OVERWRITE,	"overwrite",		2),	\
+	C( OP_MASTER_UPDATE,	"master_update",	3),	\
+	C( OP_MASTER_ERASE,	"master_erase",		2)
 #undef C
 #define C(a, b, c) a
 enum nvdimmsec_op_ids { OPS };
@@ -449,13 +453,21 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 		rc = nvdimm_security_disable(nvdimm, key);
 	} else if (i == OP_UPDATE) {
 		dev_dbg(dev, "update %u %u\n", key, newkey);
-		rc = nvdimm_security_update(nvdimm, key, newkey);
+		rc = nvdimm_security_update(nvdimm, key, newkey, NVDIMM_USER);
 	} else if (i == OP_ERASE) {
 		dev_dbg(dev, "erase %u\n", key);
-		rc = nvdimm_security_erase(nvdimm, key);
+		rc = nvdimm_security_erase(nvdimm, key, NVDIMM_USER);
 	} else if (i == OP_OVERWRITE) {
 		dev_dbg(dev, "overwrite %u\n", key);
 		rc = nvdimm_security_overwrite(nvdimm, key);
+	} else if (i == OP_MASTER_UPDATE) {
+		dev_dbg(dev, "master_update %u %u\n", key, newkey);
+		rc = nvdimm_security_update(nvdimm, key, newkey,
+				NVDIMM_MASTER);
+	} else if (i == OP_MASTER_ERASE) {
+		dev_dbg(dev, "master_erase %u\n", key);
+		rc = nvdimm_security_erase(nvdimm, key,
+				NVDIMM_MASTER);
 	} else
 		return -EINVAL;
 
@@ -557,7 +569,9 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	 * Security state must be initialized before device_add() for
 	 * attribute visibility.
 	 */
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	/* get security state and extended (master) state */
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
+	nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, NVDIMM_MASTER);
 	nd_device_register(dev);
 
 	return nvdimm;
@@ -598,7 +612,7 @@ int nvdimm_security_freeze(struct nvdimm *nvdimm)
 	}
 
 	rc = nvdimm->sec.ops->freeze(nvdimm);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
 
 	return rc;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 657231ba0607..cf9458afcee6 100644
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
@@ -53,18 +54,20 @@ struct nvdimm {
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
+		unsigned int new_keyid,
+		enum nvdimm_passphrase_type pass_type);
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
+		enum nvdimm_passphrase_type pass_type);
 
 int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid);
 void nvdimm_security_overwrite_query(struct work_struct *work);
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index ef6727a4cbdf..f06f9234a899 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -121,7 +121,8 @@ static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
 	 * Send the same key to the hardware as new and old key to
 	 * verify that the key is good.
 	 */
-	rc = nvdimm->sec.ops->change_key(nvdimm, key_data(key), key_data(key));
+	rc = nvdimm->sec.ops->change_key(nvdimm, key_data(key),
+			key_data(key), NVDIMM_USER);
 	if (rc < 0) {
 		nvdimm_put_key(key);
 		key = NULL;
@@ -173,7 +174,7 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
 	return rc;
 }
 
@@ -222,12 +223,13 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
 	return rc;
 }
 
 int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
-		unsigned int new_keyid)
+		unsigned int new_keyid,
+		enum nvdimm_passphrase_type pass_type)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
@@ -262,18 +264,25 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 	}
 
 	rc = nvdimm->sec.ops->change_key(nvdimm, key ? key_data(key) : NULL,
-			key_data(newkey));
-	dev_dbg(dev, "key: %d %d update: %s\n",
+			key_data(newkey), pass_type);
+	dev_dbg(dev, "key: %d %d update%s: %s\n",
 			key_serial(key), key_serial(newkey),
+			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(newkey);
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	if (pass_type == NVDIMM_MASTER)
+		nvdimm->sec.ext_state = nvdimm_security_state(nvdimm,
+				NVDIMM_MASTER);
+	else
+		nvdimm->sec.state = nvdimm_security_state(nvdimm,
+				NVDIMM_USER);
 	return rc;
 }
 
-int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
+		enum nvdimm_passphrase_type pass_type)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
@@ -303,16 +312,24 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EBUSY;
 	}
 
+	if (nvdimm->sec.ext_state != NVDIMM_SECURITY_UNLOCKED
+			&& pass_type == NVDIMM_MASTER) {
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
+	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key), pass_type);
+	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
+			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
 			rc == 0 ? "success" : "fail");
 
 	nvdimm_put_key(key);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
 	return rc;
 }
 
@@ -375,6 +392,7 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 		get_device(dev);
 		queue_delayed_work(system_wq, &nvdimm->dwork, 0);
 	}
+
 	return rc;
 }
 
@@ -421,7 +439,8 @@ void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 	clear_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags);
 	clear_bit(NDD_WORK_PENDING, &nvdimm->flags);
 	put_device(&nvdimm->dev);
-	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
+	nvdimm->sec.ext_state = nvdimm_security_state(nvdimm, NVDIMM_MASTER);
 }
 
 void nvdimm_security_overwrite_query(struct work_struct *work)
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d18885304020..5440f11b0907 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -174,18 +174,26 @@ struct nvdimm_key_data {
 	u8 data[NVDIMM_PASSPHRASE_LEN];
 };
 
+enum nvdimm_passphrase_type {
+	NVDIMM_USER,
+	NVDIMM_MASTER,
+};
+
 struct nvdimm_security_ops {
-	enum nvdimm_security_state (*state)(struct nvdimm *nvdimm);
+	enum nvdimm_security_state (*state)(struct nvdimm *nvdimm,
+			enum nvdimm_passphrase_type pass_type);
 	int (*freeze)(struct nvdimm *nvdimm);
 	int (*change_key)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *old_data,
-			const struct nvdimm_key_data *new_data);
+			const struct nvdimm_key_data *new_data,
+			enum nvdimm_passphrase_type pass_type);
 	int (*unlock)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*disable)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*erase)(struct nvdimm *nvdimm,
-			const struct nvdimm_key_data *key_data);
+			const struct nvdimm_key_data *key_data,
+			enum nvdimm_passphrase_type pass_type);
 	int (*overwrite)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*query_overwrite)(struct nvdimm *nvdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
