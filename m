Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2D20B1F4
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 09:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728637911; cv=none; b=G96JDetgzbnyF3XkS6v6b8czPW6/OiI2H5Yq0O1nqSy0PcAvZGC5T0yo5H19Cop2bfPgfRfWteMSH0chj2abNsAmURb9zVyaV+6xqQ61JL1K/deFrU8796YR5PAwmVWFPnjwcO3zlMRBHszIgKGiU+1SVGiPMOq7Dx6Hz1jx4iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728637911; c=relaxed/simple;
	bh=ORHk/MtWm+5n2GP1vxz61zHs/LHbHCwCLpPCJRrIoq4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kzXWPlJVOXERHIqnq0TdN91J0EVdTzHV0asCMri7iPwUDNZTX/UTx5G7FrBuWK3f9dAMvYh7ukirSw6DCAVQGrdbD/IneF0Oud0mQiNiJSer07G5+tyvnlrgIwcAIssYaSB+SHf1ZWlHMPftYE/wSxaN5H0garwWDD4ad20AQgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hgnAzCIl; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hgnAzCIl"
X-UUID: d6affe2e87b011ef88ecadb115cee93b-20241011
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=XLdY4eVKFUF5U3hhdsNnHSjGU57ONtroIJeWyFkOtok=;
	b=hgnAzCIlxX+GU8+6USzVgGjjno3NuQQjO2Nd/3hPsemm0LTQJ6hV7IqcadTx7FXH1OQoJAqcg4NW8JtsoUbfBe8kMHDTQkbmOEJ+khb01daetiAi4S/oCwxQ1YZJbiyhCG1J32SyJayGHCjbCKJUzJEO/1uTCimijlTyedlql6w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:aa41cf0c-3fcc-4de7-b8e4-e1ebb76c3160,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6dc6a47,CLOUDID:e33e1765-444a-4b47-a99a-591ade3b04b2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: d6affe2e87b011ef88ecadb115cee93b-20241011
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <qun-wei.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 949481295; Fri, 11 Oct 2024 17:11:45 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 11 Oct 2024 02:11:44 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 11 Oct 2024 17:11:44 +0800
From: Qun-Wei Lin <qun-wei.lin@mediatek.com>
To: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, Sergey
 Senozhatsky <senozhatsky@chromium.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, "Huang,
 Ying" <ying.huang@intel.com>, Chris Li <chrisl@kernel.org>, Ryan Roberts
	<ryan.roberts@arm.com>, David Hildenbrand <david@redhat.com>, Kairui Song
	<kasong@tencent.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Dan
 Schatzberg <schatzberg.dan@gmail.com>, Barry Song <baohua@kernel.org>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	Casper Li <casper.li@mediatek.com>, Chinwen Chang
	<chinwen.chang@mediatek.com>, Andrew Yang <andrew.yang@mediatek.com>, John
 Hsu <john.hsu@mediatek.com>, <wsd_upstream@mediatek.com>, Qun-Wei Lin
	<qun-wei.lin@mediatek.com>
Subject: [PATCH] mm: Split BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO into separate read and write flags
Date: Fri, 11 Oct 2024 17:11:33 +0800
Message-ID: <20241011091133.28173-1-qun-wei.lin@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

This patch splits the BLK_FEAT_SYNCHRONOUS feature flag into two
separate flags: BLK_FEAT_READ_SYNCHRONOUS and
BLK_FEAT_WRITE_SYNCHRONOUS. Similarly, the SWP_SYNCHRONOUS_IO flag is
split into SWP_READ_SYNCHRONOUS_IO and SWP_WRITE_SYNCHRONOUS_IO.

These changes are motivated by the need to better accommodate certain
swap devices that support synchronous read operations but asynchronous write
operations.

The existing BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO flags are not
sufficient for these devices, as they enforce synchronous behavior for
both read and write operations.

Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
---
 drivers/block/brd.c           |  3 ++-
 drivers/block/zram/zram_drv.c |  5 +++--
 drivers/nvdimm/btt.c          |  3 ++-
 drivers/nvdimm/pmem.c         |  5 +++--
 include/linux/blkdev.h        | 24 ++++++++++++++++--------
 include/linux/swap.h          | 31 ++++++++++++++++---------------
 mm/memory.c                   |  4 ++--
 mm/page_io.c                  |  6 +++---
 mm/swapfile.c                 |  7 +++++--
 9 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 2fd1ed101748..619a56bf747e 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -336,7 +336,8 @@ static int brd_alloc(int i)
 		.max_hw_discard_sectors	= UINT_MAX,
 		.max_discard_segments	= 1,
 		.discard_granularity	= PAGE_SIZE,
-		.features		= BLK_FEAT_SYNCHRONOUS |
+		.features		= BLK_FEAT_READ_SYNCHRONOUS	|
+					  BLK_FEAT_WRITE_SYNCHRONOUS	|
 					  BLK_FEAT_NOWAIT,
 	};
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ad9c9bc3ccfc..d2927ea76488 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2345,8 +2345,9 @@ static int zram_add(void)
 #if ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE
 		.max_write_zeroes_sectors	= UINT_MAX,
 #endif
-		.features			= BLK_FEAT_STABLE_WRITES |
-						  BLK_FEAT_SYNCHRONOUS,
+		.features			= BLK_FEAT_STABLE_WRITES	|
+						  BLK_FEAT_READ_SYNCHRONOUS	|
+						  BLK_FEAT_WRITE_SYNCHRONOUS,
 	};
 	struct zram *zram;
 	int ret, device_id;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 423dcd190906..1665d98f51af 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1501,7 +1501,8 @@ static int btt_blk_init(struct btt *btt)
 		.logical_block_size	= btt->sector_size,
 		.max_hw_sectors		= UINT_MAX,
 		.max_integrity_segments	= 1,
-		.features		= BLK_FEAT_SYNCHRONOUS,
+		.features		= BLK_FEAT_READ_SYNCHRONOUS |
+					  BLK_FEAT_WRITE_SYNCHRONOUS,
 	};
 	int rc;
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 210fb77f51ba..c22a6ee13769 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -455,8 +455,9 @@ static int pmem_attach_disk(struct device *dev,
 		.logical_block_size	= pmem_sector_size(ndns),
 		.physical_block_size	= PAGE_SIZE,
 		.max_hw_sectors		= UINT_MAX,
-		.features		= BLK_FEAT_WRITE_CACHE |
-					  BLK_FEAT_SYNCHRONOUS,
+		.features		= BLK_FEAT_WRITE_CACHE		|
+					  BLK_FEAT_READ_SYNCHRONOUS	|
+					  BLK_FEAT_WRITE_SYNCHRONOUS,
 	};
 	int nid = dev_to_node(dev), fua;
 	struct resource *res = &nsio->res;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 50c3b959da28..88e96d6cead2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -304,20 +304,23 @@ typedef unsigned int __bitwise blk_features_t;
 /* don't modify data until writeback is done */
 #define BLK_FEAT_STABLE_WRITES		((__force blk_features_t)(1u << 5))
 
-/* always completes in submit context */
-#define BLK_FEAT_SYNCHRONOUS		((__force blk_features_t)(1u << 6))
+/* read operations always completes in submit context */
+#define BLK_FEAT_READ_SYNCHRONOUS	((__force blk_features_t)(1u << 6))
+
+/* write operations always completes in submit context */
+#define BLK_FEAT_WRITE_SYNCHRONOUS	((__force blk_features_t)(1u << 7))
 
 /* supports REQ_NOWAIT */
-#define BLK_FEAT_NOWAIT			((__force blk_features_t)(1u << 7))
+#define BLK_FEAT_NOWAIT			((__force blk_features_t)(1u << 8))
 
 /* supports DAX */
-#define BLK_FEAT_DAX			((__force blk_features_t)(1u << 8))
+#define BLK_FEAT_DAX			((__force blk_features_t)(1u << 9))
 
 /* supports I/O polling */
-#define BLK_FEAT_POLL			((__force blk_features_t)(1u << 9))
+#define BLK_FEAT_POLL			((__force blk_features_t)(1u << 10))
 
 /* is a zoned device */
-#define BLK_FEAT_ZONED			((__force blk_features_t)(1u << 10))
+#define BLK_FEAT_ZONED			((__force blk_features_t)(1u << 11))
 
 /* supports PCI(e) p2p requests */
 #define BLK_FEAT_PCI_P2PDMA		((__force blk_features_t)(1u << 12))
@@ -1303,9 +1306,14 @@ static inline bool bdev_nonrot(struct block_device *bdev)
 	return blk_queue_nonrot(bdev_get_queue(bdev));
 }
 
-static inline bool bdev_synchronous(struct block_device *bdev)
+static inline bool bdev_read_synchronous(struct block_device *bdev)
+{
+	return bdev->bd_disk->queue->limits.features & BLK_FEAT_READ_SYNCHRONOUS;
+}
+
+static inline bool bdev_write_synchronous(struct block_device *bdev)
 {
-	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
+	return bdev->bd_disk->queue->limits.features & BLK_FEAT_WRITE_SYNCHRONOUS;
 }
 
 static inline bool bdev_stable_writes(struct block_device *bdev)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index ca533b478c21..6719c6006894 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -205,21 +205,22 @@ struct swap_extent {
 	  offsetof(union swap_header, info.badpages)) / sizeof(int))
 
 enum {
-	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
-	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
-	SWP_DISCARDABLE = (1 << 2),	/* blkdev support discard */
-	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
-	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
-	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
-	SWP_BLKDEV	= (1 << 6),	/* its a block device */
-	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
-	SWP_FS_OPS	= (1 << 8),	/* swapfile operations go through fs */
-	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
-	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
-	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
-	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
-					/* add others here before... */
-	SWP_SCANNING	= (1 << 14),	/* refcount in scan_swap_map */
+	SWP_USED	= (1 << 0),		/* is slot in swap_info[] used? */
+	SWP_WRITEOK	= (1 << 1),		/* ok to write to this swap?	*/
+	SWP_DISCARDABLE = (1 << 2),		/* blkdev support discard */
+	SWP_DISCARDING	= (1 << 3),		/* now discarding a free cluster */
+	SWP_SOLIDSTATE	= (1 << 4),		/* blkdev seeks are cheap */
+	SWP_CONTINUED	= (1 << 5),		/* swap_map has count continuation */
+	SWP_BLKDEV	= (1 << 6),		/* its a block device */
+	SWP_ACTIVATED	= (1 << 7),		/* set after swap_activate success */
+	SWP_FS_OPS	= (1 << 8),		/* swapfile operations go through fs */
+	SWP_AREA_DISCARD = (1 << 9),		/* single-time swap area discards */
+	SWP_PAGE_DISCARD = (1 << 10),		/* freed swap page-cluster discards */
+	SWP_STABLE_WRITES = (1 << 11),		/* no overwrite PG_writeback pages */
+	SWP_READ_SYNCHRONOUS_IO = (1 << 12),	/* synchronous read IO is efficient */
+	SWP_WRITE_SYNCHRONOUS_IO = (1 << 13),	/* synchronous write IO is efficient */
+						/* add others here before... */
+	SWP_SCANNING	= (1 << 14),		/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/memory.c b/mm/memory.c
index 2366578015ad..93eb6c29e52c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4278,7 +4278,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	swapcache = folio;
 
 	if (!folio) {
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
+		if (data_race(si->flags & SWP_READ_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			folio = alloc_swap_folio(vmf);
@@ -4413,7 +4413,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_nomap;
 	}
 
-	/* allocated large folios for SWP_SYNCHRONOUS_IO */
+	/* allocated large folios for SWP_READ_SYNCHRONOUS_IO */
 	if (folio_test_large(folio) && !folio_test_swapcache(folio)) {
 		unsigned long nr = folio_nr_pages(folio);
 		unsigned long folio_start = ALIGN_DOWN(vmf->address, nr * PAGE_SIZE);
diff --git a/mm/page_io.c b/mm/page_io.c
index 78bc88acee79..ffcc9dbbe61e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -455,10 +455,10 @@ void __swap_writepage(struct folio *folio, struct writeback_control *wbc)
 		swap_writepage_fs(folio, wbc);
 	/*
 	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
-	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
+	 * but that will never affect SWP_WRITE_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
-	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
+	else if (data_race(sis->flags & SWP_WRITE_SYNCHRONOUS_IO))
 		swap_writepage_bdev_sync(folio, wbc, sis);
 	else
 		swap_writepage_bdev_async(folio, wbc, sis);
@@ -592,7 +592,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
-	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
+	bool synchronous = sis->flags & SWP_READ_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0cded32414a1..84f6fc86be2b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3460,8 +3460,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
-	if (si->bdev && bdev_synchronous(si->bdev))
-		si->flags |= SWP_SYNCHRONOUS_IO;
+	if (si->bdev && bdev_read_synchronous(si->bdev))
+		si->flags |= SWP_READ_SYNCHRONOUS_IO;
+
+	if (si->bdev && bdev_write_synchronous(si->bdev))
+		si->flags |= SWP_WRITE_SYNCHRONOUS_IO;
 
 	if (si->bdev && bdev_nonrot(si->bdev)) {
 		si->flags |= SWP_SOLIDSTATE;
-- 
2.45.2

