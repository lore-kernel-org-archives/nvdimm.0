Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF47D21157FF0
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 19:34:16 -0700 (PDT)
Subject: [PATCH] libnvdimm, security: Comment fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 19:22:28 -0700
Message-ID: <153801494828.825550.15533638717371880458.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: dave.jiang@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Correct some spelling and stray comments.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 06d0395c1f43..8740c6c61912 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -237,8 +237,8 @@ static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
 	rc = nvdimm->security_ops->erase(nvdimm,
 			(struct nvdimm_key_data *) payload->data);
 	up_read(&key->sem);
-	/* remove key since secure erase kills the passphrase */
 
+	/* remove key since secure erase kills the passphrase */
 	if (!is_userkey) {
 		key_unlink(nvdimm_keyring, key);
 		key_invalidate(key);
@@ -423,14 +423,12 @@ static int nvdimm_security_change_key(struct device *dev,
 		goto out;
 	}
 
-	/* we need to check description as well */
-
 	if (!update)
 		key = nvdimm_replace_key(key);
 
 	/*
-	 * We don't need to release key->sem here because nvdimm_repalce_key
-	 * will.
+	 * We don't need to release key->sem here because
+	 * nvdimm_replace_key will.
 	 */
 	if (!key)
 		goto out;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
