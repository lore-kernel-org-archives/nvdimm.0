Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 239A621A16E28
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:07:22 -0700 (PDT)
Subject: [ndctl PATCH 1/4] util: mark badblocks helpers static
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 15:01:30 -0700
Message-ID: <149454009049.30857.6643219237076670086.stgit@dwillia2-desk3.amr.corp.intel.com>
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

These helpers are only used internal to util/json.c.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |    6 +++---
 util/json.h |    6 ------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/util/json.c b/util/json.c
index 0092017262bd..b2c84181cadb 100644
--- a/util/json.c
+++ b/util/json.c
@@ -356,7 +356,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 	return NULL;
 }
 
-struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
+static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
 		bool include_media_errors, unsigned int *bb_count)
 {
 	struct ndctl_region *region = ndctl_pfn_get_region(pfn);
@@ -374,7 +374,7 @@ struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
 			include_media_errors, bb_count);
 }
 
-struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
+static struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
 		bool include_media_errors, unsigned int *bb_count)
 {
 	struct ndctl_region *region = ndctl_btt_get_region(btt);
@@ -393,7 +393,7 @@ struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
 			include_media_errors, bb_count);
 }
 
-struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
+static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
 		bool include_media_errors, unsigned int *bb_count)
 {
 	struct ndctl_region *region = ndctl_dax_get_region(dax);
diff --git a/util/json.h b/util/json.h
index b3bc2084b621..1a6caeeb6e9e 100644
--- a/util/json.h
+++ b/util/json.h
@@ -13,12 +13,6 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		bool include_idle, bool include_dax, bool include_media_errs);
 struct daxctl_region;
 struct daxctl_dev;
-struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
-		bool include_media_errors, unsigned int *bb_count);
-struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
-		bool include_media_errors, unsigned int *bb_count);
-struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
-		bool include_media_errors, unsigned int *bb_count);
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 		bool include_media_errors, unsigned int *bb_count);
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
