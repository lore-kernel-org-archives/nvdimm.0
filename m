Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7526621954068
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 14:05:07 -0700 (PDT)
Subject: [ndctl PATCH 3/5] test,
 libndctl: gate ndctl_namespace_get_mode() on v4.5+
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 13:59:14 -0700
Message-ID: <149272195485.23427.477956361004200064.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
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

This support was added upstream with commit 0731de0dd95b "libnvdimm, pfn:
move 'memory mode' indication to sysfs".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index f5a6abe50edd..38a0bb746905 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -1033,6 +1033,8 @@ static int check_btt_size(struct ndctl_btt *btt)
 static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace *ndns,
 		struct namespace *namespace)
 {
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	struct btt *btt_s = namespace->btt_settings;
 	int i, fd, retry = 10;
 	struct ndctl_btt *btt;
@@ -1070,10 +1072,13 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
 			goto err;
 		}
 
-		mode = ndctl_namespace_get_mode(ndns);
-		if (mode >= 0 && mode != NDCTL_NS_MODE_SAFE)
-			fprintf(stderr, "%s: expected safe mode got: %d\n",
-					devname, mode);
+		/* prior to v4.5 the mode attribute did not exist */
+		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 5, 0))) {
+			mode = ndctl_namespace_get_mode(ndns);
+			if (mode >= 0 && mode != NDCTL_NS_MODE_SAFE)
+				fprintf(stderr, "%s: expected safe mode got: %d\n",
+						devname, mode);
+		}
 
 		rc = check_btt_size(btt);
 		if (rc)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
