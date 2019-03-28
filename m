Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D405211E0931
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 12:07:10 -0700 (PDT)
Subject: [PATCH 1/3] ndctl: fix load-keys for user master-key
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 28 Mar 2019 12:07:09 -0700
Message-ID: <155380002962.7924.11109542476291499729.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

load-keys incorrectly assumes that all keys have TPM handles. TPM handle is
only for trusted-keys. Fix in order to allow user master-key work.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/load-keys.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
index 8e4998f2..19380152 100644
--- a/ndctl/load-keys.c
+++ b/ndctl/load-keys.c
@@ -213,10 +213,8 @@ static int load_keys(struct loadkeys *lk_ctx, const char *keypath,
 
 	if (!tpmhandle) {
 		rc = check_tpm_handle(lk_ctx);
-		if (rc < 0) {
-			rc = -errno;
-			goto erropen;
-		}
+		if (rc < 0)
+			printf("No TPM handle discovered.\n");
 	}
 
 	rc = load_master_key(lk_ctx, param.key_path);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
