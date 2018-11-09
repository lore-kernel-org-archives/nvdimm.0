Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8652E2118EF65
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:35 -0800 (PST)
Subject: [PATCH 09/11] acpi/nfit,
 libnvdimm/security: add Intel DSM 1.8 master passphrase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:34 -0700
Message-ID: <154180167436.70506.13449520468879463615.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
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
 Documentation/nvdimm/security.txt |   23 ++++++
 drivers/acpi/nfit/core.c          |    2 +
 drivers/acpi/nfit/intel.c         |  132 ++++++++++++++++++++++++++++++++++++-
 drivers/acpi/nfit/intel.h         |   18 +++++
 drivers/acpi/nfit/nfit.h          |    6 +-
 drivers/nvdimm/dimm_devs.c        |   16 ++++
 drivers/nvdimm/nd-core.h          |    1 
 drivers/nvdimm/nd.h               |    5 +
 drivers/nvdimm/security.c         |   34 ++++++++--
 include/linux/libnvdimm.h         |   15 ++++
 10 files changed, 236 insertions(+), 16 deletions(-)

diff --git a/Documentation/nvdimm/security.txt b/Documentation/nvdimm/security.txt
index dfe70a8fa25b..a2d954349417 100644
--- a/Documentation/nvdimm/security.txt
+++ b/Documentation/nvdimm/security.txt
@@ -110,5 +110,28 @@ Overwrite can last tens of minutes or more depending on nvdimm size.
 An encrypted key with the current key passphrase that is tied to the nvdimm
 should be injected and its keyid should be passed in via sysfs.
 
+10. Master Update
+-----------------
+The command format for doing a master update is:
+update <old keyid> <new keyid>
+
+The operating mechansim for master update is identical to update except the
+master passphrase key is passed to the kernel. The master passphrase key
+is just another encrypted key.
+
+This command is only available when security is disabled.
+
+11. Master Erase
+----------------
+The command format for doing a master erase is:
+master_erase <current keyid>
+
+This command has the same operating mechanism as erase except the master
+passphrase key is passed to the kernel. The master passphrase key is just
+another encrypted key.
+
+This command is only available when the master security is enabled, indicated
+by the extended security status.
+
 [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.7.pdf
 [2]: http://www.t13.org/documents/UploadedDocuments/docs2006/e05179r4-ACS-SecurityClarifications.pdf
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 3e6c7b653872..867e6fea3737 100644
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
index f6d2b217f1c8..4e47fc2b524c 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -20,6 +20,123 @@
 
 #include <asm/smp.h> /* for wbinvd_on_all_cpus() on !SMP builds */
 
+static int intel_dimm_security_master_erase(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *nkey)
+{
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_secure_erase cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_MASTER_SECURE_ERASE,
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
+	if (!test_bit(NVDIMM_INTEL_MASTER_SECURE_ERASE, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	/* flush all cache before we erase DIMM */
+	wbinvd_on_all_cpus();
+	memcpy(nd_cmd.cmd.passphrase, nkey->data,
+			sizeof(nd_cmd.cmd.passphrase));
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
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
+	case ND_INTEL_STATUS_NOT_SUPPORTED:
+		rc = -EOPNOTSUPP;
+		goto out;
+	case ND_INTEL_STATUS_INVALID_PASS:
+		rc = -EINVAL;
+		goto out;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* DIMM erased, invalidate all CPU caches before we read it */
+	wbinvd_on_all_cpus();
+
+ out:
+	return rc;
+}
+
+static int intel_dimm_security_master_update_passphrase(struct nvdimm *nvdimm,
+		const struct nvdimm_key_data *old_data,
+		const struct nvdimm_key_data *new_data)
+{
+	int cmd_rc, rc = 0;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_set_passphrase cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_SET_MASTER_PASSPHRASE,
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
+	if (!test_bit(NVDIMM_INTEL_SET_MASTER_PASSPHRASE,
+				&nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	if (old_data)
+		memcpy(nd_cmd.cmd.old_pass, old_data->data,
+				sizeof(nd_cmd.cmd.old_pass));
+	else
+		memset(nd_cmd.cmd.old_pass, 0, sizeof(nd_cmd.cmd.old_pass));
+	memcpy(nd_cmd.cmd.new_pass, new_data->data,
+			sizeof(nd_cmd.cmd.new_pass));
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), &cmd_rc);
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
+	case ND_INTEL_STATUS_NOT_SUPPORTED:
+		rc = -EOPNOTSUPP;
+		goto out;
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
 static int intel_dimm_security_query_overwrite(struct nvdimm *nvdimm)
 {
 	int cmd_rc, rc = 0;
@@ -397,7 +514,8 @@ static int intel_dimm_security_unlock(struct nvdimm *nvdimm,
 }
 
 static int intel_dimm_security_state(struct nvdimm *nvdimm,
-		enum nvdimm_security_state *state)
+		enum nvdimm_security_state *state,
+		enum nvdimm_security_extended_state *ext_state)
 {
 	int cmd_rc, rc = 0;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -465,9 +583,17 @@ static int intel_dimm_security_state(struct nvdimm *nvdimm,
 	} else
 		*state = NVDIMM_SECURITY_DISABLED;
 
+	*ext_state = NVDIMM_SECURITY_MASTER_DISABLED;
+	if (nd_cmd.cmd.extended_state & ND_INTEL_SEC_ESTATE_ENABLED)
+		*ext_state = NVDIMM_SECURITY_MASTER_ENABLED;
+	else if (nd_cmd.cmd.extended_state & ND_INTEL_SEC_ESTATE_PLIMIT)
+		*ext_state = NVDIMM_SECURITY_MASTER_FROZEN;
+
  out:
-	if (rc < 0)
+	if (rc < 0) {
 		*state = NVDIMM_SECURITY_INVALID;
+		*ext_state = NVDIMM_SECURITY_MASTER_INVALID;
+	}
 	return rc;
 }
 
@@ -480,5 +606,7 @@ static const struct nvdimm_security_ops __intel_security_ops = {
 	.erase = intel_dimm_security_erase,
 	.overwrite = intel_dimm_security_overwrite,
 	.query_overwrite = intel_dimm_security_query_overwrite,
+	.master_change_key = intel_dimm_security_master_update_passphrase,
+	.master_erase = intel_dimm_security_master_erase,
 };
 const struct nvdimm_security_ops *intel_security_ops = &__intel_security_ops;
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index 0140d9b6a0b7..0c33f49d0272 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -46,6 +46,7 @@ extern const struct nvdimm_security_ops *intel_security_ops;
 #define ND_INTEL_STATUS_SIZE		4
 #define ND_INTEL_PASSPHRASE_SIZE	32
 
+#define ND_INTEL_STATUS_NOT_SUPPORTED	1
 #define ND_INTEL_STATUS_RETRY		5
 #define ND_INTEL_STATUS_NOT_READY	9
 #define ND_INTEL_STATUS_INVALID_STATE	10
@@ -61,9 +62,13 @@ extern const struct nvdimm_security_ops *intel_security_ops;
 #define ND_INTEL_SEC_STATE_UNSUPPORTED	0x20
 #define ND_INTEL_SEC_STATE_OVERWRITE	0x40
 
+#define ND_INTEL_SEC_ESTATE_ENABLED	0x01
+#define ND_INTEL_SEC_ESTATE_PLIMIT	0x02
+
 struct nd_intel_get_security_state {
 	u32 status;
-	u32 reserved;
+	u8 extended_state;
+	u8 reserved[3];
 	u8 state;
 	u8 reserved1[3];
 } __packed;
@@ -101,6 +106,17 @@ struct nd_intel_overwrite {
 struct nd_intel_query_overwrite {
 	u32 status;
 } __packed;
+
+struct nd_intel_set_master_passphrase {
+	u8 old_pass[ND_INTEL_PASSPHRASE_SIZE];
+	u8 new_pass[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_master_secure_erase {
+	u8 passphrase[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
 #else /* CONFIG_X86 */
 #define intel_security_ops (NULL)
 #endif /* CONFIG_X86 */
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index d50dbb4cdeaf..e0ee54049c89 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -68,13 +68,17 @@ enum nvdimm_family_cmds {
 	NVDIMM_INTEL_SECURE_ERASE = 24,
 	NVDIMM_INTEL_OVERWRITE = 25,
 	NVDIMM_INTEL_QUERY_OVERWRITE = 26,
+	NVDIMM_INTEL_SET_MASTER_PASSPHRASE = 27,
+	NVDIMM_INTEL_MASTER_SECURE_ERASE = 28,
 };
 
 #define NVDIMM_INTEL_SECURITY_CMDMASK \
 (1 << NVDIMM_INTEL_GET_SECURITY_STATE | 1 << NVDIMM_INTEL_SET_PASSPHRASE \
 | 1 << NVDIMM_INTEL_DISABLE_PASSPHRASE | 1 << NVDIMM_INTEL_UNLOCK_UNIT \
 | 1 << NVDIMM_INTEL_FREEZE_LOCK | 1 << NVDIMM_INTEL_SECURE_ERASE \
-| 1 << NVDIMM_INTEL_OVERWRITE | 1 << NVDIMM_INTEL_QUERY_OVERWRITE)
+| 1 << NVDIMM_INTEL_OVERWRITE | 1 << NVDIMM_INTEL_QUERY_OVERWRITE \
+| 1 << NVDIMM_INTEL_SET_MASTER_PASSPHRASE \
+| 1 << NVDIMM_INTEL_MASTER_SECURE_ERASE)
 
 #define NVDIMM_INTEL_CMDMASK \
 (NVDIMM_STANDARD_CMDMASK | 1 << NVDIMM_INTEL_GET_MODES \
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 39e40074b5df..fdb32c30d01d 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -421,7 +421,8 @@ static ssize_t security_store(struct device *dev,
 		if (rc != 3)
 			return -EINVAL;
 		dev_dbg(dev, "update %#x %#x\n", old_key, new_key);
-		rc = nvdimm_security_change_key(nvdimm, old_key, new_key);
+		rc = nvdimm_security_change_key(nvdimm, old_key, new_key,
+				false);
 	} else if (sysfs_streq(cmd, "disable")) {
 		if (rc != 2)
 			return -EINVAL;
@@ -434,12 +435,23 @@ static ssize_t security_store(struct device *dev,
 		if (rc != 2)
 			return -EINVAL;
 		dev_dbg(dev, "erase %#x\n", old_key);
-		rc = nvdimm_security_erase(nvdimm, old_key);
+		rc = nvdimm_security_erase(nvdimm, old_key, false);
 	} else if (sysfs_streq(cmd, "overwrite")) {
 		if (rc != 2)
 			return -EINVAL;
 		dev_dbg(dev, "overwrite %u\n", old_key);
 		rc = nvdimm_security_overwrite(nvdimm, old_key);
+	} else if (sysfs_streq(cmd, "master_update")) {
+		if (rc != 3)
+			return -EINVAL;
+		dev_dbg(dev, "master_update %#x %#x\n", old_key, new_key);
+		rc = nvdimm_security_change_key(nvdimm,
+				old_key, new_key, true);
+	} else if (sysfs_streq(cmd, "master_erase")) {
+		if (rc != 2)
+			return -EINVAL;
+		dev_dbg(dev, "master_erase %#x\n", old_key);
+		rc = nvdimm_security_erase(nvdimm, old_key, true);
 	} else
 		return -EINVAL;
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index b96e1b10e3eb..98facc66dd88 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -46,6 +46,7 @@ struct nvdimm {
 	const char *dimm_id;
 	const struct nvdimm_security_ops *security_ops;
 	enum nvdimm_security_state state;
+	enum nvdimm_security_extended_state ext_state;
 	struct mutex sec_mutex;
 	struct delayed_work dwork;
 	unsigned int overwrite_tmo;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ba41582c4cc2..11a268ffa63d 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -431,10 +431,11 @@ bool pmem_should_map_pages(struct device *dev);
 int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm);
 int nvdimm_security_get_state(struct nvdimm *nvdimm);
 int nvdimm_security_change_key(struct nvdimm *nvdimm, unsigned int old_keyid,
-		unsigned int new_keyid);
+		unsigned int new_keyid, bool master);
 int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
 int nvdimm_security_freeze_lock(struct nvdimm *nvdimm);
-int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid);
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
+		bool master);
 int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid);
 void nvdimm_overwrite_query(struct work_struct *work);
 
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index f5ba633545b7..2e835e6a7b74 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -90,7 +90,8 @@ int nvdimm_security_get_state(struct nvdimm *nvdimm)
 	if (!nvdimm->security_ops)
 		return 0;
 
-	return nvdimm->security_ops->state(nvdimm, &nvdimm->state);
+	return nvdimm->security_ops->state(nvdimm, &nvdimm->state,
+			&nvdimm->ext_state);
 }
 
 void nvdimm_overwrite_query(struct work_struct *work)
@@ -211,7 +212,8 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 
 }
 
-int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
+int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
+		bool master)
 {
 	int rc = 0;
 	struct key *key;
@@ -243,6 +245,12 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		goto out;
 	}
 
+	if (nvdimm->ext_state != NVDIMM_SECURITY_MASTER_ENABLED && master) {
+		dev_warn(dev, "Attempt to secure erase in wrong master state.\n");
+		rc = -EOPNOTSUPP;
+		goto out;
+	}
+
 	key = nvdimm_lookup_user_key(dev, keyid);
 	if (!key) {
 		dev_dbg(dev, "Unable to get and verify key\n");
@@ -253,8 +261,12 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 	down_read(&key->sem);
 	epayload = dereference_key_locked(key);
 	data = epayload->decrypted_data;
-	rc = nvdimm->security_ops->erase(nvdimm,
-			(const struct nvdimm_key_data *)data);
+	if (master)
+		rc = nvdimm->security_ops->master_erase(nvdimm,
+				(const struct nvdimm_key_data *)data);
+	else
+		rc = nvdimm->security_ops->erase(nvdimm,
+				(const struct nvdimm_key_data *)data);
 	up_read(&key->sem);
 	key_put(key);
 
@@ -454,7 +466,7 @@ int nvdimm_security_unlock_dimm(struct nvdimm *nvdimm)
 }
 
 int nvdimm_security_change_key(struct nvdimm *nvdimm,
-		unsigned int old_keyid, unsigned int new_keyid)
+		unsigned int old_keyid, unsigned int new_keyid, bool master)
 {
 	int rc;
 	struct key *key = NULL, *old_key = NULL;
@@ -468,6 +480,10 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm,
 	if (nvdimm->state == NVDIMM_SECURITY_FROZEN)
 		return -EBUSY;
 
+	/* can only change master passphrase when security is disabled */
+	if (nvdimm->ext_state != NVDIMM_SECURITY_MASTER_ENABLED && master)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&nvdimm->sec_mutex);
 	rc = nvdimm_check_security_busy(nvdimm);
 	if (rc < 0)
@@ -499,8 +515,12 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm,
 		old_data = old_epayload->decrypted_data;
 	}
 
-	rc = nvdimm->security_ops->change_key(nvdimm, old_data,
-			new_data);
+	if (master)
+		rc = nvdimm->security_ops->master_change_key(nvdimm, old_data,
+				new_data);
+	else
+		rc = nvdimm->security_ops->change_key(nvdimm, old_data,
+				new_data);
 	if (rc)
 		dev_warn(dev, "key update failed: %d\n", rc);
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index c3c5a1c6b1b7..3d14f73c7bca 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -167,6 +167,13 @@ enum nvdimm_security_state {
 	NVDIMM_SECURITY_UNSUPPORTED,
 };
 
+enum nvdimm_security_extended_state {
+	NVDIMM_SECURITY_MASTER_INVALID = 0,
+	NVDIMM_SECURITY_MASTER_DISABLED,
+	NVDIMM_SECURITY_MASTER_ENABLED,
+	NVDIMM_SECURITY_MASTER_FROZEN,
+};
+
 #define NVDIMM_PASSPHRASE_LEN		32
 #define NVDIMM_KEY_DESC_LEN		22
 
@@ -176,7 +183,8 @@ struct nvdimm_key_data {
 
 struct nvdimm_security_ops {
 	int (*state)(struct nvdimm *nvdimm,
-			enum nvdimm_security_state *state);
+			enum nvdimm_security_state *state,
+			enum nvdimm_security_extended_state *ex_state);
 	int (*unlock)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
 	int (*change_key)(struct nvdimm *nvdimm,
@@ -190,6 +198,11 @@ struct nvdimm_security_ops {
 	int (*overwrite)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *nkey);
 	int (*query_overwrite)(struct nvdimm *nvdimm);
+	int (*master_change_key)(struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *old_key,
+			const struct nvdimm_key_data *new_key);
+	int (*master_erase)(struct nvdimm *nvdimm,
+			const struct nvdimm_key_data *nkey);
 };
 
 void badrange_init(struct badrange *badrange);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
