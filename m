Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F06762116DA35
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 11:23:53 -0700 (PDT)
Subject: [PATCH 1/5] libnvdimm: fix updating of kernel key during nvdimm key
 update
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 11:23:53 -0700
Message-ID: <153936863308.55836.2972520178944977338.stgit@djiang5-desk3.ch.intel.com>
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

There are several issues WRT kernel key update when we are doing nvdimm
security key update.

1. The kernel key created needs to have proper permission for update
2. We need to check key_update() return value and make sure it didn't fail
3. We need to not hold the key->sem when calling key_update() since it will
   call down_write() when doing modification to the key.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 776c440a02ef..ef83bdf47c31 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -27,7 +27,7 @@ static struct key *make_kernel_key(struct key *key)
 
 	new_key = key_alloc(&key_type_logon, key->description,
 			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
-			KEY_POS_SEARCH, KEY_ALLOC_NOT_IN_QUOTA, NULL);
+			KEY_POS_ALL, KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(new_key))
 		return NULL;
 
@@ -419,11 +419,19 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm,
 		dev_warn(dev, "key update failed: %d\n", rc);
 
 	if (old_key) {
+		up_read(&old_key->sem);
 		/* copy new payload to old payload */
-		if (rc == 0)
-			key_update(make_key_ref(old_key, 1), new_data,
+		if (rc == 0) {
+			rc = key_update(make_key_ref(old_key, 1), new_data,
 					old_key->datalen);
-		up_read(&old_key->sem);
+			if (rc < 0) {
+				dev_warn(dev,
+					"kernel key update failed: %d\n", rc);
+				key_invalidate(old_key);
+				key_put(old_key);
+				nvdimm->key = NULL;
+			}
+		}
 	}
 	up_read(&key->sem);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
