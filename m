Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46223204699
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741348931; cv=none; b=WAMwsY5Y97xKQsbxBJuTyiZPKrh8K/smDc/zCvXTC5M3iFrf71baQuMoqHZxuaNQ/mTV9OOJhzWIuCucjwAGPEXVX5/wJlSB4Err33xT9/w/EQFgi65DU/P1Cq7wtSNA3dfiHJTd5VgvDvN87otF9Xnfi65vJTZdFdqWrLyVTpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741348931; c=relaxed/simple;
	bh=1dnFXfTJeW6Y1LRlvuhbPvcsWEcWMAij1buEHdPIDKI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mbKipNw+pmhX0VwUue+TQUCEsdYAWFynDemPhGoZaA20f5guCTlAhLwCeix+yK5G19fFlPRxAVcn2wpiBlal1IAJfLsV7kJay5ijfe2N181AwcOY8VJlaNn3aonfCgTbjhBGjUVwV/NVdZS85c/oZP9UEeITY5EjcLh0iWjuTSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AEnGWX8x; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AEnGWX8x"
X-UUID: fb59275afb4b11ef8eb9c36241bbb6fb-20250307
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Oi/1yul7QoqCYVR3VHpPFv7fpZcX0xh49zK0QqiiehU=;
	b=AEnGWX8xovgnGX01Gl48h0NnNYIMQZOLuMuEqdBX5eSvwetxP1BaxFubxbsK1nD47uupnsTVsXaijDSS6B9Yc5m9uE0z9+0cuF4iXyXdN8tx37LC/LnxR1YOBLCyud9iB95itFII2xl2AFl/pB+5L0xTd3bOTW7mqxHyw4vLyA8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:7199b0a6-6245-4dc4-9a93-5c9c0a3994a4,IP:0,UR
	L:0,TC:0,Content:-5,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-30
X-CID-META: VersionHash:0ef645f,CLOUDID:f00027ce-23b9-4c94-add0-e827a7999e28,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:1,
	IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:
	0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: fb59275afb4b11ef8eb9c36241bbb6fb-20250307
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <qun-wei.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1427047752; Fri, 07 Mar 2025 20:02:02 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 7 Mar 2025 20:02:01 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Fri, 7 Mar 2025 20:02:01 +0800
From: Qun-Wei Lin <qun-wei.lin@mediatek.com>
To: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, Sergey
 Senozhatsky <senozhatsky@chromium.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris
 Li <chrisl@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying"
	<ying.huang@intel.com>, Kairui Song <kasong@tencent.com>, Dan Schatzberg
	<schatzberg.dan@gmail.com>, Barry Song <baohua@kernel.org>, Al Viro
	<viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	Casper Li <casper.li@mediatek.com>, Chinwen Chang
	<chinwen.chang@mediatek.com>, Andrew Yang <andrew.yang@mediatek.com>, James
 Hsu <james.hsu@mediatek.com>, Qun-Wei Lin <qun-wei.lin@mediatek.com>
Subject: [PATCH 1/2] mm: Split BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO into separate read and write flags
Date: Fri, 7 Mar 2025 20:01:03 +0800
Message-ID: <20250307120141.1566673-2-qun-wei.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 292f127cae0a..66920b9d4701 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -370,7 +370,8 @@ static int brd_alloc(int i)
 		.max_hw_discard_sectors	= UINT_MAX,
 		.max_discard_segments	= 1,
 		.discard_granularity	= PAGE_SIZE,
-		.features		= BLK_FEAT_SYNCHRONOUS |
+		.features		= BLK_FEAT_READ_SYNCHRONOUS	|
+					  BLK_FEAT_WRITE_SYNCHRONOUS	|
 					  BLK_FEAT_NOWAIT,
 	};
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 3dee026988dc..2e1a70f2f4bd 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2535,8 +2535,9 @@ static int zram_add(void)
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
index d81faa9d89c9..81a57d7ca746 100644
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
index 08a727b40816..3070f2e9d862 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -305,20 +305,23 @@ typedef unsigned int __bitwise blk_features_t;
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
@@ -1321,9 +1324,14 @@ static inline bool bdev_nonrot(struct block_device *bdev)
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
index f3e0ac20c2e8..2068b6973648 100644
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
+	SWP_SCANNING	= (1 << 14),		/* refcount in scan_swap_map */
+						/* add others here before... */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/memory.c b/mm/memory.c
index 75c2dfd04f72..56c864d5d787 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4293,7 +4293,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	swapcache = folio;
 
 	if (!folio) {
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
+		if (data_race(si->flags & SWP_READ_SYNCHRONOUS_IO) &&
 		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			folio = alloc_swap_folio(vmf);
@@ -4430,7 +4430,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_nomap;
 	}
 
-	/* allocated large folios for SWP_SYNCHRONOUS_IO */
+	/* allocated large folios for SWP_READ_SYNCHRONOUS_IO */
 	if (folio_test_large(folio) && !folio_test_swapcache(folio)) {
 		unsigned long nr = folio_nr_pages(folio);
 		unsigned long folio_start = ALIGN_DOWN(vmf->address, nr * PAGE_SIZE);
diff --git a/mm/page_io.c b/mm/page_io.c
index 4b4ea8e49cf6..d692eafdd90c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -465,10 +465,10 @@ void __swap_writepage(struct folio *folio, struct writeback_control *wbc)
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
@@ -616,7 +616,7 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
-	bool synchronous = sis->flags & SWP_SYNCHRONOUS_IO;
+	bool synchronous = sis->flags & SWP_READ_SYNCHRONOUS_IO;
 	bool workingset = folio_test_workingset(folio);
 	unsigned long pflags;
 	bool in_thrashing;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b0a9071cfe1d..902e5698af44 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3488,8 +3488,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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

