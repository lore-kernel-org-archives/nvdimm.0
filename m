Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7B9820965DD6
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 19:55:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 7/7] dm-error: remove unnecessary direct_access() stub
Date: Thu, 24 May 2018 20:55:18 -0600
Message-Id: <20180525025518.11405-8-ross.zwisler@linux.intel.com>
In-Reply-To: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This stub was added so that we could use dm-error with
DM_TYPE_DAX_BIO_BASED mode devices.  That mode and the transition issues
associated with it no longer exist, so we can remove this dead code.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-target.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 314d17ca6466..c4dbc15f7862 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -140,12 +140,6 @@ static void io_err_release_clone_rq(struct request *clone)
 {
 }
 
-static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	return -EIO;
-}
-
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 5, 0},
@@ -155,7 +149,6 @@ static struct target_type error_target = {
 	.map  = io_err_map,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
-	.direct_access = io_err_dax_direct_access,
 };
 
 int __init dm_target_init(void)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
