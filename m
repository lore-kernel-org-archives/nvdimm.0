Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32781F91E3;
	Wed, 17 Jun 2026 12:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699138; cv=pass; b=fhBTH8LQI3hxsZJEyKe1daTIhjl66IKP83YRPSmaRDthu3PaooAzTtjRwy5slHU2HKNLlrwjM7T4HxGsBjP43pQUxHmExxC9Z38w+GLKxFaN4gMAt9hIDwWfROjRb7YVuza5/uRgrvzkilLfymNKu9vz+YWTmg2wxbFKgS9Vrb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699138; c=relaxed/simple;
	bh=0IknSZs+CZ2aWmgORtDW0RLrqT1UT710/Y0X+nmzfrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLP+bg1C289vQY0pjoxIY8M5h4l9X1xeswffICEZ9iMGNjQMDhIbQN1W9Pbf1dYB0KE6MNbsmgPic2kQKF68pDf08AY/hC+y0b1DvljVdVpcbnRuCZpR+c//lAWlSxkIB9fhTQdnV1GXgytQ4LwGUsqpx54f6Lipa0M/mg9zwjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ewXxRX03; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ewXxRX03"
ARC-Seal: i=1; a=rsa-sha256; t=1781699114; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PEbrA/y38ehDPU7bVtrHPf/LulBQx3HkjMAD3ztOKGPLn3m/62QRfk0d/WS48c0rSqFZiUtvwntMJ6u42hy366+ukQ8zCFfAtsQQbpEmdk6ZbAxBBODZKqjn3JStJFFlYr2/pN2cmMimuxe0HEowkh47SxtZaOGQSuKVig7nPsU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781699114; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=gPpF3KoeRkWvCn/WAd7dxNBXjTnxN4iFAXPZPuhQ5Bc=; 
	b=ImvaK0vBxmubG5cMihQazdNWq3G7UrSU+KjXQf0SUCZKcc38KLOLK42qqEvxddD8GHi3TvQTWIkeEOTsaQeuVzRo05cpyAa2Fsjqv+X/mQARP0xlHpUq1StO9Uo7SR3tcRPv+5r4GRh+4pDthhhVpDc8lZLYaCztzfFXEW3Q2OE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781699114;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=gPpF3KoeRkWvCn/WAd7dxNBXjTnxN4iFAXPZPuhQ5Bc=;
	b=ewXxRX03WYHBKOheqvuvRSL0cGdq4IRRhdKnaDrfUnaHey4LoPB1LKoaSlaeyn3k
	QwaUbZXgZ9wsTUdl1ghKS9uQllhtTZ6HrNjhS10OeUUGqrufomOpfbm+O97soLqjgGy
	PZOG3TQbMnBUNwcC9jSJ4ZA+jLkmyGGe+8FGeAKc=
Received: by mx.zohomail.com with SMTPS id 1781699112062181.5672867241185;
	Wed, 17 Jun 2026 05:25:12 -0700 (PDT)
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
Subject: [PATCH v5 3/8] nvdimm: virtio_pmem: use GFP_NOIO for child flush bio
Date: Wed, 17 Jun 2026 20:24:35 +0800
Message-ID: <20260617122442.2118957-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260617122442.2118957-1-me@linux.beauty>
References: <20260617122442.2118957-1-me@linux.beauty>
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
