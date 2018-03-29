Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E89AE225501C8
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 16:12:04 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/3] ndctl, check: fix a few error returns
Date: Thu, 29 Mar 2018 17:18:34 -0600
Message-Id: <20180329231836.29453-1-vishal.l.verma@intel.com>
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

We were returning a raw '-1' in one case, and a couple of other 'errno'
returns without making them negative. Fix them to make the returns
consistent.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/check.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ndctl/check.c b/ndctl/check.c
index 57bbf3f..d2d74a2 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -139,7 +139,7 @@ static int btt_write_info(struct btt_chk *bttc, struct btt_sb *btt_sb, u64 off)
 		err(bttc, "BTT info block at offset %#lx needs to be restored\n",
 			off);
 		repair_msg(bttc);
-		return -1;
+		return -EIO;
 	}
 	info(bttc, "Restoring BTT info block at offset %#lx\n", off);
 
@@ -184,7 +184,7 @@ static int btt_copy_to_info2(struct arena_info *a)
 	ms_align = (void *)rounddown((u64)a->map.info2, a->bttc->sys_page_size);
 	ms_size = max(BTT_INFO_SIZE, a->bttc->sys_page_size);
 	if (msync(ms_align, ms_size, MS_SYNC) < 0)
-		return errno;
+		return -errno;
 
 	return 0;
 }
@@ -231,7 +231,7 @@ static int btt_map_write(struct arena_info *a, u32 lba, u32 mapping)
 	ms_align = (void *)rounddown((u64)&a->map.map[lba],
 		a->bttc->sys_page_size);
 	if (msync(ms_align, a->bttc->sys_page_size, MS_SYNC) < 0)
-		return errno;
+		return -errno;
 
 	return 0;
 }
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
