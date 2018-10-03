Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46A5021A07A92
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 11:16:07 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 4/5] util/json: Add comments around re-checking the
 UTIL_JSON_MEDIA_ERRORS flag
Date: Wed,  3 Oct 2018 12:15:05 -0600
Message-Id: <20181003181506.17682-4-vishal.l.verma@intel.com>
In-Reply-To: <20181003181506.17682-1-vishal.l.verma@intel.com>
References: <20181003181506.17682-1-vishal.l.verma@intel.com>
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

Add comments to clarify that in the various ndctl_*_babdlock_foreach
loops where we compose the json output, the additional check for
UTIL_JSON_MEDIA_ERRORS is valid because even if we're not printing
media errors, we still want the badblock_count to be updated, which
requires a full badblocks traversal.

Cc: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/util/json.c b/util/json.c
index 30b56c3..702ccf4 100644
--- a/util/json.c
+++ b/util/json.c
@@ -465,6 +465,7 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 		bbs += bb->len;
 
+		/* recheck so we can still get the badblocks_count from above */
 		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
 			continue;
 
@@ -554,6 +555,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 		bbs += len;
 
+		/* recheck so we can still get the badblocks_count from above */
 		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
 			continue;
 
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
