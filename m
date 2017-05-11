Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BB5721A16E28
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:07:32 -0700 (PDT)
Subject: [ndctl PATCH 3/4] ndctl, list: fix span for btt badblocks check
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 15:01:40 -0700
Message-ID: <149454010081.30857.7934265050481005763.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149454009049.30857.6643219237076670086.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149454009049.30857.6643219237076670086.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The size returned by ndctl_btt_get_size() accounts for space consumed by
metadata or otherwise lost to sector size geometry. For the
'badblock_count' property all we can do is report a count of possible
badblocks which may be larger than actual badblocks impacting live data.
Use the raw namespace size for this check.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/util/json.c b/util/json.c
index f72ffca910ae..17595267c34c 100644
--- a/util/json.c
+++ b/util/json.c
@@ -379,14 +379,14 @@ static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
 {
 	struct ndctl_region *region = ndctl_btt_get_region(btt);
 	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
-	unsigned long long btt_begin, btt_size;
+	unsigned long long begin, size;
 
-	btt_begin = ndctl_namespace_get_resource(ndns);
-	if (btt_begin == ULLONG_MAX)
+	begin = ndctl_namespace_get_resource(ndns);
+	if (begin == ULLONG_MAX)
 		return;
 
-	btt_size = ndctl_btt_get_size(btt);
-	if (btt_size == ULLONG_MAX)
+	size = ndctl_namespace_get_size(ndns);
+	if (size == ULLONG_MAX)
 		return;
 
 	/*
@@ -397,8 +397,7 @@ static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
 	 * FIXME: switch to native BTT badblocks representation
 	 * when / if the kernel provides it.
 	 */
-	dev_badblocks_to_json(region, btt_begin, btt_size,
-			false, bb_count);
+	dev_badblocks_to_json(region, begin, size, false, bb_count);
 }
 
 static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
