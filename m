Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 797D32116DFA6
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 13:39:55 -0700 (PDT)
Subject: [PATCH v2 1/4] libnvdimm: fix updating of kernel key during nvdimm
 key update
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 13:39:54 -0700
Message-ID: <153937679428.70378.14173556349575982662.stgit@djiang5-desk3.ch.intel.com>
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

There are several issues WRT kernel key update when we are doing nvdimm
security key update.

1. The kernel key created needs to have proper permission for update
2. We need to check key_update() return value and make sure it didn't fail
3. We need to not hold the key->sem when calling key_update() since it will
   call down_write() when doing modification to the key.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 2e764abe015a..8de34b03d402 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -27,7 +27,8 @@ static struct key *make_kernel_key(struct key *key)
 
 	new_key = key_alloc(&key_type_logon, key->description,
 			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
-			KEY_POS_SEARCH, KEY_ALLOC_NOT_IN_QUOTA, NULL);
+			KEY_POS_ALL & ~KEY_POS_SETATTR,
+			KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(new_key))
 		return NULL;
 
@@ -413,11 +414,23 @@ int nvdimm_security_change_key(struct nvdimm *nvdimm,
 		dev_warn(dev, "key update failed: %d\n", rc);
 
 	if (old_key) {
-		/* copy new payload to old payload */
-		if (rc == 0)
-			key_update(make_key_ref(old_key, 1), new_data,
-					old_key->datalen);
 		up_read(&old_key->sem);
+		/*
+		 * With the key update done via hardware, we no longer need
+		 * the old payload and need to replace it with the new
+		 * payload. key_update() will acquire write sem of the
+		 * old key and update with new data.
+		 */
+		if (rc == 0) {
+			rc = key_update(make_key_ref(old_key, 1), new_data,
+					old_key->datalen);
+			if (rc < 0) {
+				dev_warn(dev,
+					"kernel key update failed: %d\n", rc);
+				key_destroy(old_key);
+				nvdimm->key = NULL;
+			}
+		}
 	}
 	up_read(&key->sem);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
