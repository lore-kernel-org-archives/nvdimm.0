Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FF10211D59AF
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 10:07:38 -0700 (PDT)
Subject: [PATCH v4 2/2] libnvdimm/security,
 acpi/nfit: move other seucrity commands to utilize zero key
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 26 Mar 2019 10:07:37 -0700
Message-ID: <155362001378.42665.10201475913225259437.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155361997046.42665.15819732417231761031.stgit@djiang5-desk3.ch.intel.com>
References: <155361997046.42665.15819732417231761031.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Sync update passphrase and overwrite to utilize the the same mechansim for
zero key.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v4:
- Remove deprecated code to detect NULL key in acpi/nfit. (Dan)
v3:
- new patch. sync rest of the commands to use zero key. (Dan)

 drivers/acpi/nfit/intel.c |   10 ++++------
 drivers/nvdimm/security.c |   28 +++++++++++++++-------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index f70de71f79d6..cddd0fcf622c 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -122,9 +122,8 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-	if (old_data)
-		memcpy(nd_cmd.cmd.old_pass, old_data->data,
-				sizeof(nd_cmd.cmd.old_pass));
+	memcpy(nd_cmd.cmd.old_pass, old_data->data,
+			sizeof(nd_cmd.cmd.old_pass));
 	memcpy(nd_cmd.cmd.new_pass, new_data->data,
 			sizeof(nd_cmd.cmd.new_pass));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
@@ -336,9 +335,8 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 
 	/* flush all cache before we erase DIMM */
 	nvdimm_invalidate_cache();
-	if (nkey)
-		memcpy(nd_cmd.cmd.passphrase, nkey->data,
-				sizeof(nd_cmd.cmd.passphrase));
+	memcpy(nd_cmd.cmd.passphrase, nkey->data,
+			sizeof(nd_cmd.cmd.passphrase));
 	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 6bea6852bf27..429cb3cbc1c3 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -235,8 +235,9 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	struct key *key, *newkey;
+	struct key *key = NULL, *newkey;
 	int rc;
+	const void *data;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -251,13 +252,13 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EIO;
 	}
 
-	if (keyid == 0)
-		key = NULL;
-	else {
+	if (keyid != 0) {
 		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 		if (!key)
 			return -ENOKEY;
-	}
+		data = key_data(key);
+	} else
+		data = zero_key;
 
 	newkey = nvdimm_lookup_user_key(nvdimm, new_keyid, NVDIMM_NEW_KEY);
 	if (!newkey) {
@@ -265,8 +266,8 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 		return -ENOKEY;
 	}
 
-	rc = nvdimm->sec.ops->change_key(nvdimm, key ? key_data(key) : NULL,
-			key_data(newkey), pass_type);
+	rc = nvdimm->sec.ops->change_key(nvdimm, data, key_data(newkey),
+			pass_type);
 	dev_dbg(dev, "key: %d %d update%s: %s\n",
 			key_serial(key), key_serial(newkey),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
@@ -344,8 +345,9 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	struct key *key;
+	struct key *key = NULL;
 	int rc;
+	const void *data;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -375,15 +377,15 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EBUSY;
 	}
 
-	if (keyid == 0)
-		key = NULL;
-	else {
+	if (keyid != 0) {
 		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 		if (!key)
 			return -ENOKEY;
-	}
+		data = key_data(key);
+	} else
+		data = zero_key;
 
-	rc = nvdimm->sec.ops->overwrite(nvdimm, key ? key_data(key) : NULL);
+	rc = nvdimm->sec.ops->overwrite(nvdimm, data);
 	dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
