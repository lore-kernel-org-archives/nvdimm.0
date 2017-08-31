Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E36AD21E95E12
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:36:54 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v7 1/6] btt: fix a missed NVDIMM_IO_ATOMIC case in the write
 path
Date: Wed, 30 Aug 2017 19:35:58 -0600
Message-Id: <20170831013603.16997-2-vishal.l.verma@intel.com>
In-Reply-To: <20170831013603.16997-1-vishal.l.verma@intel.com>
References: <20170831013603.16997-1-vishal.l.verma@intel.com>
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

The IO context conversion for rw_bytes missed a case in the BTT write
path (btt_map_write) which should've been marked as atomic.

In reality this should not cause a problem, because map writes are to
small for nsio_rw_bytes to attempt error clearing, but it should be
fixed for posterity.

Add a might_sleep() in the non-atomic section of nsio_rw_bytes so that
things like the nfit unit tests, which don't actually sleep, can catch
bugs like this.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c   | 3 ++-
 drivers/nvdimm/claim.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 14323fa..f6ea82f 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1156,7 +1156,8 @@ static int btt_write_pg(struct btt *btt, struct bio_integrity_payload *bip,
 		if (ret)
 			goto out_map;
 
-		ret = btt_map_write(arena, premap, new_postmap, 0, 0, 0);
+		ret = btt_map_write(arena, premap, new_postmap, 0, 0,
+			NVDIMM_IO_ATOMIC);
 		if (ret)
 			goto out_map;
 
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 4777046..3e6404f 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -292,6 +292,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 				&& !(flags & NVDIMM_IO_ATOMIC)) {
 			long cleared;
 
+			might_sleep();
 			cleared = nvdimm_clear_poison(&ndns->dev,
 					nsio->res.start + offset, size);
 			if (cleared < size)
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
