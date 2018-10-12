Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0455E2116DF9A
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 14:11:02 -0700 (PDT)
Subject: [PATCH] libnvdimm: add warning output when request_key() fails
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 14:11:01 -0700
Message-ID: <153937866114.12317.12018314886353779354.stgit@djiang5-desk3.ch.intel.com>
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

Provide useful error output when request_key() fails.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/security.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 3a905c58a935..5aacc590b4c0 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -73,11 +73,17 @@ static struct key *nvdimm_request_key(struct nvdimm *nvdimm)
 {
 	struct key *key = NULL;
 	char desc[NVDIMM_KEY_DESC_LEN + sizeof(NVDIMM_PREFIX)];
+	struct device *dev = &nvdimm->dev;
 
 	sprintf(desc, "%s%s", NVDIMM_PREFIX, nvdimm->dimm_id);
 	key = request_key(&key_type_logon, desc, "");
-	if (IS_ERR(key))
+	if (IS_ERR(key)) {
+		if (PTR_ERR(key) == -ENOKEY)
+			dev_warn(dev, "request_key() found no key\n");
+		else
+			dev_warn(dev, "request_key() upcall failed\n");
 		key = NULL;
+	}
 
 	return key;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
