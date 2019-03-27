Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B92B211E82FB
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 11:12:45 -0700 (PDT)
Subject: [PATCH v5 2/2] libnvdimm/security,
 acpi/nfit: unify zero-key for all security commands
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 27 Mar 2019 11:12:45 -0700
Message-ID: <155371024995.41052.11664581741534125308.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155371019392.41052.2119245365191332271.stgit@djiang5-desk3.ch.intel.com>
References: <155371019392.41052.2119245365191332271.stgit@djiang5-desk3.ch.intel.com>
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

With zero-key defined, we can remove previous detection of key id 0 or null
key in order to deal with a zero-key situation. Syncing all security
commands to use the zero-key. Helper functions are introduced to return the
data that points to the actual key payload or the zero_key. This helps
uniformly handle the key material even with zero_key.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v5:
- Updated commit message and header.
- Added helper functions for key payload management to support zero_key
  (Dan)
- Fixed up security unlock path as well. (Dan)

v4:
- Remove deprecated code to detect NULL key in acpi/nfit. (Dan)
v3:
- new patch. sync rest of the commands to use zero key. (Dan)

 drivers/acpi/nfit/intel.c |   10 ++--
 drivers/nvdimm/security.c |  117 +++++++++++++++++++++++++++------------------
 2 files changed, 73 insertions(+), 54 deletions(-)

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
index 6bea6852bf27..a570f2263a42 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -77,6 +77,16 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
 	return key;
 }
 
+static const void *nvdimm_get_key_payload(struct nvdimm *nvdimm,
+		struct key **key)
+{
+	*key = nvdimm_request_key(nvdimm);
+	if (!*key)
+		return zero_key;
+
+	return key_data(*key);
+}
+
 static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
 		key_serial_t id, int subclass)
 {
@@ -107,36 +117,57 @@ static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
 	return key;
 }
 
-static struct key *nvdimm_key_revalidate(struct nvdimm *nvdimm)
+static const void *nvdimm_get_user_key_payload(struct nvdimm *nvdimm,
+		key_serial_t id, int subclass, struct key **key)
+{
+	*key = NULL;
+	if (id == 0) {
+		if (subclass == NVDIMM_BASE_KEY)
+			return zero_key;
+		else
+			return NULL;
+	}
+
+	*key = nvdimm_lookup_user_key(nvdimm, id, subclass);
+	if (!*key)
+		return NULL;
+
+	return key_data(*key);
+}
+
+
+static int nvdimm_key_revalidate(struct nvdimm *nvdimm)
 {
 	struct key *key;
 	int rc;
+	const void *data;
 
 	if (!nvdimm->sec.ops->change_key)
-		return NULL;
+		return -EOPNOTSUPP;
 
-	key = nvdimm_request_key(nvdimm);
-	if (!key)
-		return NULL;
+	data = nvdimm_get_key_payload(nvdimm, &key);
 
 	/*
 	 * Send the same key to the hardware as new and old key to
 	 * verify that the key is good.
 	 */
-	rc = nvdimm->sec.ops->change_key(nvdimm, key_data(key),
-			key_data(key), NVDIMM_USER);
+	rc = nvdimm->sec.ops->change_key(nvdimm, data, data, NVDIMM_USER);
 	if (rc < 0) {
 		nvdimm_put_key(key);
-		key = NULL;
+		return rc;
 	}
-	return key;
+
+	nvdimm_put_key(key);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm, NVDIMM_USER);
+	return 0;
 }
 
 static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	struct key *key = NULL;
+	struct key *key;
+	const void *data;
 	int rc;
 
 	/* The bus lock should be held at the top level of the call stack */
@@ -162,16 +193,11 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 		if (!key_revalidate)
 			return 0;
 
-		key = nvdimm_key_revalidate(nvdimm);
-		if (!key)
-			return nvdimm_security_freeze(nvdimm);
+		return nvdimm_key_revalidate(nvdimm);
 	} else
-		key = nvdimm_request_key(nvdimm);
+		data = nvdimm_get_key_payload(nvdimm, &key);
 
-	if (!key)
-		return -ENOKEY;
-
-	rc = nvdimm->sec.ops->unlock(nvdimm, key_data(key));
+	rc = nvdimm->sec.ops->unlock(nvdimm, data);
 	dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
 
@@ -197,6 +223,7 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct key *key;
 	int rc;
+	const void *data;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -216,11 +243,12 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EBUSY;
 	}
 
-	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
-	if (!key)
+	data = nvdimm_get_user_key_payload(nvdimm, keyid,
+			NVDIMM_BASE_KEY, &key);
+	if (!data)
 		return -ENOKEY;
 
-	rc = nvdimm->sec.ops->disable(nvdimm, key_data(key));
+	rc = nvdimm->sec.ops->disable(nvdimm, data);
 	dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
 
@@ -237,6 +265,7 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct key *key, *newkey;
 	int rc;
+	const void *data, *newdata;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -251,22 +280,19 @@ int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EIO;
 	}
 
-	if (keyid == 0)
-		key = NULL;
-	else {
-		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
-		if (!key)
-			return -ENOKEY;
-	}
+	data = nvdimm_get_user_key_payload(nvdimm, keyid,
+			NVDIMM_BASE_KEY, &key);
+	if (!data)
+		return -ENOKEY;
 
-	newkey = nvdimm_lookup_user_key(nvdimm, new_keyid, NVDIMM_NEW_KEY);
-	if (!newkey) {
+	newdata = nvdimm_get_user_key_payload(nvdimm, new_keyid,
+			NVDIMM_NEW_KEY, &newkey);
+	if (!newdata) {
 		nvdimm_put_key(key);
 		return -ENOKEY;
 	}
 
-	rc = nvdimm->sec.ops->change_key(nvdimm, key ? key_data(key) : NULL,
-			key_data(newkey), pass_type);
+	rc = nvdimm->sec.ops->change_key(nvdimm, data, newdata, pass_type);
 	dev_dbg(dev, "key: %d %d update%s: %s\n",
 			key_serial(key), key_serial(newkey),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
@@ -322,13 +348,10 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EOPNOTSUPP;
 	}
 
-	if (keyid != 0) {
-		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
-		if (!key)
-			return -ENOKEY;
-		data = key_data(key);
-	} else
-		data = zero_key;
+	data = nvdimm_get_user_key_payload(nvdimm, keyid,
+			NVDIMM_BASE_KEY, &key);
+	if (!data)
+		return -ENOKEY;
 
 	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
 	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
@@ -344,8 +367,9 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	struct key *key;
+	struct key *key = NULL;
 	int rc;
+	const void *data;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -375,15 +399,12 @@ int nvdimm_security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EBUSY;
 	}
 
-	if (keyid == 0)
-		key = NULL;
-	else {
-		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
-		if (!key)
-			return -ENOKEY;
-	}
+	data = nvdimm_get_user_key_payload(nvdimm, keyid,
+			NVDIMM_BASE_KEY, &key);
+	if (!data)
+		return -ENOKEY;
 
-	rc = nvdimm->sec.ops->overwrite(nvdimm, key ? key_data(key) : NULL);
+	rc = nvdimm->sec.ops->overwrite(nvdimm, data);
 	dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
