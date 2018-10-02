Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 252F921BADAB2
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 20:31:51 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/5] util/json: consolidate check for the
 UTIL_JSON_MEDIA_ERRORS flag
Date: Mon,  1 Oct 2018 21:31:39 -0600
Message-Id: <20181002033140.21295-4-vishal.l.verma@intel.com>
In-Reply-To: <20181002033140.21295-1-vishal.l.verma@intel.com>
References: <20181002033140.21295-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We don't need to check for the above flag for each badblock we're
iterating over. Remove the check in the respective loops, and return
early if it is not set.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/util/json.c b/util/json.c
index 30b56c3..4dd5fc3 100644
--- a/util/json.c
+++ b/util/json.c
@@ -457,7 +457,8 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 		jbbs = json_object_new_array();
 		if (!jbbs)
 			return NULL;
-	}
+	} else
+		return NULL;
 
 	ndctl_region_badblock_foreach(region, bb) {
 		struct json_object *jdimms;
@@ -465,9 +466,6 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 		bbs += bb->len;
 
-		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
-			continue;
-
 		/* get start address of region */
 		addr = ndctl_region_get_resource(region);
 		if (addr == ULLONG_MAX)
@@ -527,7 +525,8 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		jbbs = json_object_new_array();
 		if (!jbbs)
 			return NULL;
-	}
+	} else
+		return NULL;
 
 	ndctl_region_badblock_foreach(region, bb) {
 		unsigned long long bb_begin, bb_end, begin, end;
@@ -554,9 +553,6 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 		bbs += len;
 
-		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
-			continue;
-
 		jbb = json_object_new_object();
 		if (!jbb)
 			goto err_array;
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
