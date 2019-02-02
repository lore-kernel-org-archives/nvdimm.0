Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0003C21BADAB2
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:53:00 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/4] ndctl,
 load-keys: fix a resource leak in load_dimm_keys()
Date: Fri,  1 Feb 2019 18:52:53 -0700
Message-Id: <20190202015253.20051-4-vishal.l.verma@intel.com>
In-Reply-To: <20190202015253.20051-1-vishal.l.verma@intel.com>
References: <20190202015253.20051-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Static analysis reports that we potentially leak 'fname' in the above
function. Fix by freeing it as well as 'blob' in the exit path.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/load-keys.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
index 184fa2d..95c4d4d 100644
--- a/ndctl/load-keys.c
+++ b/ndctl/load-keys.c
@@ -86,7 +86,7 @@ static int load_dimm_keys(struct loadkeys *lk_ctx)
 {
 	int rc;
 	struct dirent *dent;
-	char *fname, *id, *blob;
+	char *fname = NULL, *id, *blob = NULL;
 	char desc[ND_KEY_DESC_SIZE];
 	int size, count = 0;
 	key_serial_t key;
@@ -142,6 +142,8 @@ static int load_dimm_keys(struct loadkeys *lk_ctx)
 
 	printf("%d nvdimm keys loaded\n", count);
 
+	free(fname);
+	free(blob);
 	return 0;
 }
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
