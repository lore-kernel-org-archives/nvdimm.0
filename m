Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C9D40BCDA;
	Tue,  9 Jun 2026 12:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006891; cv=pass; b=lgp6GyIrPlcq/kQWHTJugtH+4/FLOuaHQDCRXr34a4olAn0rbspcPZrm8aY4fkof+zGB0pU9kOsmV4hhddQT+uwTShKwWQulV1ViDnG/jqPiJ2XX2DBPVX4JRGcEJSBYVAOABV18aRsDEH09jNGdBu3FDn/qO7FojGyRT98iONU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006891; c=relaxed/simple;
	bh=0IknSZs+CZ2aWmgORtDW0RLrqT1UT710/Y0X+nmzfrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIgro2s7h1eZ9sZktQ5e2PSOAbpPeOixNQiGT8XkHdx7/gBBKnBfGov/4mkVQ+gKUWaStpd2xFo4aP8ipxBK7pr6uuc0P8m1wnH1Oqtt8iZb/fZGjLs5SGm7ck1qK0AM9jTivMCbWtBlf0CLAII1e9ZCxoVUMrhODK54PtQVpYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=X4nSMQKL; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="X4nSMQKL"
ARC-Seal: i=1; a=rsa-sha256; t=1781006877; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=SdBUhFRRiHwe0Z/MI26OU/qxJr/5zJB0rBn8v+63+MSfwHkzmhdyuZmygkf1tLL0YaQpmK0yIaSIfb7K0siCbO9AUmvynHDya6sP7CMpBb3kaouefsD3FM/SNxaGqCr3IBcJ5fBO1wUHnHoi8xn0Amvm3brhbZV/s7Aqi2vJ47c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781006877; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=gPpF3KoeRkWvCn/WAd7dxNBXjTnxN4iFAXPZPuhQ5Bc=; 
	b=jgPKqa5Y3WCuenyYcgsBTln9fIO2kVuxuEm6dTdxpgoRK1D75gqdZnipNCSgyUfb8/OxYoB54pT3Hn78U2u/OEy9MrsgxyMIDktH7Bmt3DhHuXEAU8L9lLwDiy0nwy6yX4+L6Rq43knQY8RFG7eHBz+vOdd6zx5HSQkZpeX2GaY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781006876;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=gPpF3KoeRkWvCn/WAd7dxNBXjTnxN4iFAXPZPuhQ5Bc=;
	b=X4nSMQKLEZfo/+ij+4QVzjhlZ6uloJowd/b/Fu/RscALXNsbsO5aWbwx2LLmmD2u
	U7EegZwOJjpn0bWbVG/HhoFkiADezJArulTH881cnQf5mKutG6i9GTzkqjHxj8qrmKJ
	6cf6Vylk4Bw90AKHMB28JxNxDTh65ZypEJ8e1B2E=
Received: by mx.zohomail.com with SMTPS id 1781006874820153.56041895581916;
	Tue, 9 Jun 2026 05:07:54 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v4 2/7] nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
Date: Tue,  9 Jun 2026 20:07:16 +0800
Message-ID: <20260609120726.1714780-3-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260609120726.1714780-1-me@linux.beauty>
References: <20260609120726.1714780-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

async_pmem_flush() can allocate a child flush bio from filesystem flush
and writeback paths. GFP_ATOMIC is unnecessarily restrictive there and can
make the allocation fail under pressure, which then propagates -ENOMEM to
the flush caller.

A local virtio-pmem mkfs sanity test hit a flush failure before this
change:

  wipefs: /dev/pmem0: cannot flush modified buffers: Input/output error
  mkfs.ext4: Input/output error while writing out and closing file system
  nd_region region0: dbg: nvdimm_flush rc=-5

The debug log showed async_pmem_flush() was entered and nvdimm_flush()
returned -EIO. With GFP_NOIO, the same test reached mkfs_rc=0, mount_rc=0,
and umount_rc=0.

Use GFP_NOIO instead. The path may sleep, but it must not recurse into
filesystem I/O reclaim while it is already servicing a flush request.

Signed-off-by: Li Chen <me@linux.beauty>
---
v3->v4:
- New patch.

 drivers/nvdimm/nd_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4176046627beb..081370aac6317 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -117,7 +117,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 	if (bio && bio->bi_iter.bi_sector != -1) {
 		struct bio *child = bio_alloc(bio->bi_bdev, 0,
 					      REQ_OP_WRITE | REQ_PREFLUSH,
-					      GFP_ATOMIC);
+					      GFP_NOIO);
 
 		if (!child)
 			return -ENOMEM;
-- 
2.52.0

