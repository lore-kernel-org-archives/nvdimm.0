Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA4E521A02937
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 11:10:45 -0700 (PDT)
Subject: [PATCH v5 1/2] libnvdimm/security: provide fix for secure-erase to
 use zero-key
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 27 Mar 2019 11:10:44 -0700
Message-ID: <155371019392.41052.2119245365191332271.stgit@djiang5-desk3.ch.intel.com>
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

Add a zero key in order to standardize hardware that want a key of 0's to
be passed. Some platforms defaults to a zero-key with security enabled
rather than allow the OS to enable the security. The zero key would allow
us to manage those platform as well. This also adds a fix to secure erase
so it can use the zero key to do crypto erase. Some other security commands
already use zero keys. This introduces a standard zero-key to allow
unification of semantics cross nvdimm security commands.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v5:
- Updated commit message and header. (Dan)

v4: No change

v3:
- Add note in commit header about syncing zero key usage. (Dan)

v2:
- Make patch header explicitly zero key (Dan)
- Declare global static zero key (Dan)
- Make nfit_test explicitly test zero key (Dan)

 drivers/nvdimm/security.c        |   17 ++++++++++++-----
 tools/testing/nvdimm/test/nfit.c |   11 +++++++++--
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index f8bb746a549f..6bea6852bf27 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -22,6 +22,8 @@ static bool key_revalidate = true;
 module_param(key_revalidate, bool, 0444);
 MODULE_PARM_DESC(key_revalidate, "Require key validation at init.");
 
+static const char zero_key[NVDIMM_PASSPHRASE_LEN];
+
 static void *key_data(struct key *key)
 {
 	struct encrypted_key_payload *epayload = dereference_key_locked(key);
@@ -286,8 +288,9 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	struct key *key;
+	struct key *key = NULL;
 	int rc;
+	const void *data;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -319,11 +322,15 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EOPNOTSUPP;
 	}
 
-	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
-	if (!key)
-		return -ENOKEY;
+	if (keyid != 0) {
+		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
+		if (!key)
+			return -ENOKEY;
+		data = key_data(key);
+	} else
+		data = zero_key;
 
-	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key), pass_type);
+	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
 	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
 			rc == 0 ? "success" : "fail");
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index b579f962451d..cad719876ef4 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -225,6 +225,8 @@ static struct workqueue_struct *nfit_wq;
 
 static struct gen_pool *nfit_pool;
 
+static const char zero_key[NVDIMM_PASSPHRASE_LEN];
+
 static struct nfit_test *to_nfit_test(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1059,8 +1061,7 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
 	struct device *dev = &t->pdev.dev;
 	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
 
-	if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED) ||
-			(sec->state & ND_INTEL_SEC_STATE_FROZEN)) {
+	if (sec->state & ND_INTEL_SEC_STATE_FROZEN) {
 		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
 		dev_dbg(dev, "secure erase: wrong security state\n");
 	} else if (memcmp(nd_cmd->passphrase, sec->passphrase,
@@ -1068,6 +1069,12 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
 		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
 		dev_dbg(dev, "secure erase: wrong passphrase\n");
 	} else {
+		if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED)
+				&& (memcmp(nd_cmd->passphrase, zero_key,
+					ND_INTEL_PASSPHRASE_SIZE) != 0)) {
+			dev_dbg(dev, "invalid zero key\n");
+			return 0;
+		}
 		memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
 		memset(sec->master_passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
 		sec->state = 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
