Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1588D211CF353
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 16:06:33 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v5 1/2] nvdimm,
 btt: remove unnecessary code in btt_freelist_init
Date: Wed, 27 Feb 2019 17:06:26 -0700
Message-Id: <20190228000627.2339-1-vishal.l.verma@intel.com>
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
Cc: pbarbuda@microsoft.com
List-ID: <linux-nvdimm@lists.01.org>

We call btt_log_read() twice, once to get the 'old' log entry, and again
to get the 'new' entry. However, we have no use for the 'old' entry, so
remove it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

v5: no changes in this patch

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index b123b0dcf274..cd4fa87ea48c 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -541,9 +541,9 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 
 static int btt_freelist_init(struct arena_info *arena)
 {
-	int old, new, ret;
+	int new, ret;
 	u32 i, map_entry;
-	struct log_entry log_new, log_old;
+	struct log_entry log_new;
 
 	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
 					GFP_KERNEL);
@@ -551,10 +551,6 @@ static int btt_freelist_init(struct arena_info *arena)
 		return -ENOMEM;
 
 	for (i = 0; i < arena->nfree; i++) {
-		old = btt_log_read(arena, i, &log_old, LOG_OLD_ENT);
-		if (old < 0)
-			return old;
-
 		new = btt_log_read(arena, i, &log_new, LOG_NEW_ENT);
 		if (new < 0)
 			return new;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
