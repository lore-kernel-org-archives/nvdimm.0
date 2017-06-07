Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9C5421A16EC1
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 13:59:30 -0700 (PDT)
Subject: [PATCH] ndctl: fix uninitialized bb_count in list command
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 07 Jun 2017 14:00:38 -0700
Message-ID: <149686923837.13885.5048755294647675245.stgit@djiang5-desk3.ch.intel.com>
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

bb_count would be 0 if util_region_badblocks_to_json() returns NULL.
Initialize bb_count to 0 by default.

Reported-by: Andy Rudoff <andy.rudoff@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/list.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 4d5050c..ad710ed 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -138,7 +138,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	struct json_object *jobj, *jbbs, *jmappings = NULL;
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
-	unsigned int bb_count;
+	unsigned int bb_count = 0;
 
 	if (!jregion)
 		return NULL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
