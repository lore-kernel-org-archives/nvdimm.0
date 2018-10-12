Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D26EA2116DFA2
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 13:40:05 -0700 (PDT)
Subject: [PATCH v2 3/4] libnvdimm: remove code to pull user key when there's
 no kernel key
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 13:40:05 -0700
Message-ID: <153937680516.70378.5638887247499767544.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
References: <153937659078.70378.7857051533055879370.stgit@djiang5-desk3.ch.intel.com>
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

Remove extraneous code that used to expect nvdimm_get_and_verify_key() to
return NULL when there's no kernel key. We want to enforce the behavior
that when there is no kernel key we should fail security ops.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |   49 +++++++++------------------------------------
 1 file changed, 10 insertions(+), 39 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 2de5ef107216..eb778667cd93 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -122,6 +122,12 @@ struct key *nvdimm_get_and_verify_key(struct nvdimm *nvdimm,
 	return key;
 }
 
+static void key_destroy(struct key *key)
+{
+	key_invalidate(key);
+	key_put(key);
+}
+
 int nvdimm_security_get_state(struct nvdimm *nvdimm)
 {
 	if (!nvdimm->security_ops)
@@ -136,7 +142,6 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 	struct key *key;
 	struct user_key_payload *payload;
 	struct device *dev = &nvdimm->dev;
-	bool is_userkey = false;
 
 	if (!nvdimm->security_ops)
 		return -EOPNOTSUPP;
@@ -162,18 +167,6 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 		rc = PTR_ERR(key);
 		goto out;
 	}
-	if (!key) {
-		dev_dbg(dev, "No cached key found\n");
-		/* get old user key */
-		key = nvdimm_lookup_user_key(dev, keyid);
-		if (!key) {
-			dev_dbg(dev, "Unable to retrieve user key: %#x\n",
-					keyid);
-			rc = -ENOKEY;
-			goto out;
-		}
-		is_userkey = true;
-	}
 
 	down_read(&key->sem);
 	payload = key->payload.data[0];
@@ -182,11 +175,8 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid)
 	up_read(&key->sem);
 
 	/* remove key since secure erase kills the passphrase */
-	if (!is_userkey) {
-		key_invalidate(key);
-		nvdimm->key = NULL;
-	}
-	key_put(key);
+	key_destroy(key);
+	nvdimm->key = NULL;
 
  out:
 	mutex_unlock(&nvdimm->key_mutex);
@@ -219,7 +209,6 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	struct key *key;
 	struct user_key_payload *payload;
 	struct device *dev = &nvdimm->dev;
-	bool is_userkey = false;
 
 	if (!nvdimm->security_ops)
 		return -EOPNOTSUPP;
@@ -234,15 +223,6 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 		mutex_unlock(&nvdimm->key_mutex);
 		return PTR_ERR(key);
 	}
-	if (!key) {
-		/* get old user key */
-		key = nvdimm_lookup_user_key(dev, keyid);
-		if (!key) {
-			mutex_unlock(&nvdimm->key_mutex);
-			return -ENOKEY;
-		}
-		is_userkey = true;
-	}
 
 	down_read(&key->sem);
 	payload = key->payload.data[0];
@@ -256,11 +236,8 @@ int nvdimm_security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	}
 
 	/* If we succeed then remove the key */
-	if (!is_userkey) {
-		key_invalidate(key);
-		nvdimm->key = NULL;
-	}
-	key_put(key);
+	key_destroy(key);
+	nvdimm->key = NULL;
 
  out:
 	mutex_unlock(&nvdimm->key_mutex);
@@ -330,12 +307,6 @@ void nvdimm_security_release(struct nvdimm *nvdimm)
 	mutex_unlock(&nvdimm->key_mutex);
 }
 
-static void key_destroy(struct key *key)
-{
-	key_invalidate(key);
-	key_put(key);
-}
-
 int nvdimm_security_change_key(struct nvdimm *nvdimm,
 		unsigned int old_keyid, unsigned int new_keyid)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
