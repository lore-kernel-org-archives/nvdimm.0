Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1695C2119AC08
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:26:15 -0800 (PST)
Subject: [PATCH v13 09/17] acpi/nfit,
 libnvdimm: Add enable/update passphrase support for Intel nvdimms
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:26:14 -0700
Message-ID: <154455997435.26509.899289981872486244.stgit@djiang5-desk3.ch.intel.com>
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

Add support for enabling and updating passphrase on the Intel nvdimms.
The passphrase is the an encrypted key in the kernel user keyring.
We trigger the update via writing "update <old_keyid> <new_keyid>" to the
sysfs attribute "security". If no <old_keyid> exists (for enabling
security) then a 0 should be used.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c |   24 ++++++++++++++----
 drivers/nvdimm/nd-core.h   |    2 ++
 drivers/nvdimm/security.c  |   58 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 3a5727102a30..8669000ea6a6 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -397,14 +397,15 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	ssize_t rc;
-	char cmd[SEC_CMD_SIZE+1], keystr[KEY_ID_SIZE+1];
-	unsigned int key;
+	char cmd[SEC_CMD_SIZE+1], keystr[KEY_ID_SIZE+1],
+		nkeystr[KEY_ID_SIZE+1];
+	unsigned int key, newkey;
 
 	if (atomic_read(&nvdimm->busy))
 		return -EBUSY;
 
-	rc = sscanf(buf, "%"__stringify(SEC_CMD_SIZE)"s %"__stringify(KEY_ID_SIZE)"s",
-			cmd, keystr);
+	rc = sscanf(buf, "%"__stringify(SEC_CMD_SIZE)"s %"__stringify(KEY_ID_SIZE)"s %"__stringify(KEY_ID_SIZE)"s",
+			cmd, keystr, nkeystr);
 	if (sysfs_streq(buf, "freeze")) {
 		dev_dbg(dev, "freeze\n");
 		rc = nvdimm_security_freeze(nvdimm);
@@ -417,6 +418,18 @@ static ssize_t __security_store(struct device *dev, const char *buf, size_t len)
 		rc = nvdimm_security_disable(nvdimm, key);
 		if (rc < 0)
 			return rc;
+	} else if (sysfs_streq(cmd, "update")) {
+		if (rc != 3)
+			return -EINVAL;
+		rc = kstrtouint(keystr, 0, &key);
+		if (rc < 0)
+			return rc;
+		rc = kstrtouint(nkeystr, 0, &newkey);
+		if (rc < 0)
+			return rc;
+		rc = nvdimm_security_update(nvdimm, key, newkey);
+		if (rc < 0)
+			return rc;
 	} else
 		return -EINVAL;
 
@@ -467,7 +480,8 @@ static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (nvdimm->sec.state < 0)
 		return 0;
 	/* Are there any state mutation ops? */
-	if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable)
+	if (nvdimm->sec.ops->freeze || nvdimm->sec.ops->disable
+			|| nvdimm->sec.ops->change_key)
 		return a->mode;
 	return 0444;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 93e63c12ea45..ca020793a419 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -58,6 +58,8 @@ static inline enum nvdimm_security_state nvdimm_security_state(
 }
 int nvdimm_security_freeze(struct nvdimm *nvdimm);
 int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid);
+int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
+		unsigned int new_keyid);
 
 /**
  * struct blk_alloc_info - tracking info for BLK dpa scanning
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 55d8806a5040..654b64fe7e9d 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -15,6 +15,9 @@
 #include "nd-core.h"
 #include "nd.h"
 
+#define NVDIMM_BASE_KEY		0
+#define NVDIMM_NEW_KEY		1
+
 static bool key_revalidate = true;
 module_param(key_revalidate, bool, 0444);
 MODULE_PARM_DESC(key_revalidate, "Require key validation at init.");
@@ -70,7 +73,7 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
 }
 
 static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
-		key_serial_t id)
+		key_serial_t id, int subclass)
 {
 	key_ref_t keyref;
 	struct key *key;
@@ -86,10 +89,10 @@ static struct key *nvdimm_lookup_user_key(struct nvdimm *nvdimm,
 		key_put(key);
 		return NULL;
 	}
-	dev_dbg(dev, "%s: key found: %#x\n", __func__, key_serial(key));
 
+	dev_dbg(dev, "%s: key found: %#x\n", __func__, key_serial(key));
 
-	down_read(&key->sem);
+	down_read_nested(&key->sem, subclass);
 	epayload = dereference_key_locked(key);
 	if (epayload->decrypted_datalen != NVDIMM_PASSPHRASE_LEN) {
 		up_read(&key->sem);
@@ -197,7 +200,7 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		return -EIO;
 	}
 
-	key = nvdimm_lookup_user_key(nvdimm, keyid);
+	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
 	if (!key)
 		return -ENOKEY;
 
@@ -209,3 +212,50 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	nvdimm->sec.state = nvdimm_security_state(nvdimm);
 	return rc;
 }
+
+int nvdimm_security_update(struct nvdimm *nvdimm, unsigned int keyid,
+		unsigned int new_keyid)
+{
+	struct device *dev = &nvdimm->dev;
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key, *newkey;
+	int rc;
+
+	/* The bus lock should be held at the top level of the call stack */
+	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
+
+	if (!nvdimm->sec.ops || !nvdimm->sec.ops->change_key
+			|| nvdimm->sec.state < 0)
+		return -EIO;
+
+	if (nvdimm->sec.state >= NVDIMM_SECURITY_FROZEN) {
+		dev_warn(dev, "Incorrect security state: %d\n",
+				nvdimm->sec.state);
+		return -EIO;
+	}
+
+	if (keyid == 0)
+		key = NULL;
+	else {
+		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
+		if (!key)
+			return -ENOKEY;
+	}
+
+	newkey = nvdimm_lookup_user_key(nvdimm, new_keyid, NVDIMM_NEW_KEY);
+	if (!newkey) {
+		nvdimm_put_key(key);
+		return -ENOKEY;
+	}
+
+	rc = nvdimm->sec.ops->change_key(nvdimm, key ? key_data(key) : NULL,
+			key_data(newkey));
+	dev_dbg(dev, "key: %d %d update: %s\n",
+			key_serial(key), key_serial(newkey),
+			rc == 0 ? "success" : "fail");
+
+	nvdimm_put_key(newkey);
+	nvdimm_put_key(key);
+	nvdimm->sec.state = nvdimm_security_state(nvdimm);
+	return rc;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
