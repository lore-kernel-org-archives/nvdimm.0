Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F9D1A5BBB
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 12:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741348930; cv=none; b=Fmf/N/JP96I2M/SCNtohB8YhZNnbGZBcIdC79WM7l4+3k6PNghe58fUMw3q0wAIMO3TDv6vOQ6c7C6cZgEDHkAE9WgOwvJY0rYIS84hS7bt7KtXBWAFaMi6UMHUNBtBNR2Vpgblc/2hLCon/W/oux+2DpPYrNgRaw9hy7imQW7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741348930; c=relaxed/simple;
	bh=ZyP1mg00MasTdJcKj2JJLqQCpZqtzGDabLizmnL5s+Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nT3kJwk0XdA+UW9DIoi3j0sZ9/E+9nMcOqy6JtbEFqiyURX7l50EwSADmulTYkssz8Wd0bfUq3+EpYzhqvHIArcAF3vnMS2cPwtar62hzQ9C7mG6DxTkEcI/tg3VXnv0OYEWS+hE38HP2uecBi024y9pIoF0xNwjCRB5SA5RVQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=iy8T8atn; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iy8T8atn"
X-UUID: fad550b0fb4b11ef8eb9c36241bbb6fb-20250307
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=z29LXW8H6j5+YRRi20VzwXPPtbzAx8PDXEJJyuBSweA=;
	b=iy8T8atnxWBpiv4K8S5gBAoe6cHhhxTIYMQ0ui2oZyoX3fRif1h37NXcMYc2piKPF3vxAnqvXTULZ+OoaYayrP/Bsm0d8YE4c/WgaRB/aBqmBOaGHMdREBv3hofNtqS9aBiCEbuNeQEDbVjE+J3kg799+swipg86lduTxnsP3hM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:2835b6ae-8b4d-4238-9054-a8570afb41e6,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:290a168c-f5b8-47d5-8cf3-b68fe7530c9a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: fad550b0fb4b11ef8eb9c36241bbb6fb-20250307
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <qun-wei.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 332338863; Fri, 07 Mar 2025 20:02:02 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
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
Subject: [PATCH 0/2] Improve Zram by separating compression context from kswapd
Date: Fri, 7 Mar 2025 20:01:02 +0800
Message-ID: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

This patch series introduces a new mechanism called kcompressd to
improve the efficiency of memory reclaiming in the operating system. The
main goal is to separate the tasks of page scanning and page compression
into distinct processes or threads, thereby reducing the load on the
kswapd thread and enhancing overall system performance under high memory
pressure conditions.

Problem:
 In the current system, the kswapd thread is responsible for both
 scanning the LRU pages and compressing pages into the ZRAM. This
 combined responsibility can lead to significant performance bottlenecks,
 especially under high memory pressure. The kswapd thread becomes a
 single point of contention, causing delays in memory reclaiming and
 overall system performance degradation.

Target:
 The target of this invention is to improve the efficiency of memory
 reclaiming. By separating the tasks of page scanning and page
 compression into distinct processes or threads, the system can handle
 memory pressure more effectively.

Patch 1:
- Introduces 2 new feature flags, BLK_FEAT_READ_SYNCHRONOUS and
  SWP_READ_SYNCHRONOUS_IO.

Patch 2:
- Implemented the core functionality of Kcompressd and made necessary
  modifications to the zram driver to support it.

In our handheld devices, we found that applying this mechanism under high
memory pressure scenarios can increase the rate of pgsteal_anon per second
by over 260% compared to the situation with only kswapd.

Qun-Wei Lin (2):
  mm: Split BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO into separate
    read and write flags
  kcompressd: Add Kcompressd for accelerated zram compression

 drivers/block/brd.c             |   3 +-
 drivers/block/zram/Kconfig      |  11 ++
 drivers/block/zram/Makefile     |   3 +-
 drivers/block/zram/kcompressd.c | 340 ++++++++++++++++++++++++++++++++
 drivers/block/zram/kcompressd.h |  25 +++
 drivers/block/zram/zram_drv.c   |  21 +-
 drivers/nvdimm/btt.c            |   3 +-
 drivers/nvdimm/pmem.c           |   5 +-
 include/linux/blkdev.h          |  24 ++-
 include/linux/swap.h            |  31 +--
 mm/memory.c                     |   4 +-
 mm/page_io.c                    |   6 +-
 mm/swapfile.c                   |   7 +-
 13 files changed, 446 insertions(+), 37 deletions(-)
 create mode 100644 drivers/block/zram/kcompressd.c
 create mode 100644 drivers/block/zram/kcompressd.h

-- 
2.45.2

