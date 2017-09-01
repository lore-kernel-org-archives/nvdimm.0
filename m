Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53E3020958BED
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 17:33:28 -0700 (PDT)
Subject: [PATCH] ndctl: make ndctl_namspace_set_sector_size() more verbose
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 17:29:47 -0700
Message-ID: <150422578789.8329.15965986648705526561.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Since we already walk all the supported sector sizes in the success
case, move that loop to the start of the routine and use it for logging
bad input parameters.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index f52ecfe9d142..4361cd8f26c5 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3549,8 +3549,15 @@ NDCTL_EXPORT int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 	char sector_str[40];
 	int i;
 
-	if (ndns->lbasize.num == 0)
-		return -ENXIO;
+	for (i = 0; i < ndns->lbasize.num; i++)
+		if (ndns->lbasize.supported[i] == sector_size)
+			break;
+
+	if (i > ndns->lbasize.num) {
+		err(ctx, "%s: unsupported sector size %d\n",
+				ndctl_namespace_get_devname(ndns), sector_size);
+		return -EOPNOTSUPP;
+	}
 
 	if (snprintf(path, len, "%s/sector_size", ndns->ndns_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
@@ -3563,9 +3570,8 @@ NDCTL_EXPORT int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 	if (rc != 0)
 		return rc;
 
-	for (i = 0; i < ndns->lbasize.num; i++)
-		if (ndns->lbasize.supported[i] == sector_size)
-			ndns->lbasize.select = i;
+	ndns->lbasize.select = i;
+
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
