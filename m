Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44533655C2;
	Sun, 21 Jun 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782047010; cv=pass; b=o/dbx1AzZfrWOzcDiRyZ0YOZsey8aprpb5PNpwY5dbRJS3oZvwB2mffPSw+++qmZOpMXs//HHgKJ7xDUIJKReTumUCQE2fmPEeA1k4JL9TLeZ4iaAd2uxLq1DMZ2O3EGwDjJGsmdPYZVp57xe6uoJO3htGjXhyOPeoNE5NpIXcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782047010; c=relaxed/simple;
	bh=hyJUYuMM3yNKIj/7gM8TyqSviP72o38Bz2OQhycgbZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkuF+EEX+WONjc+McSJVgaMO6wQ1UzbNa9eLm/kZHelVLR+eMAZ6ed6MoYI9hur5WQWZPgYty+zTXU6iG7xw03T3MM4QGHSoVQqJTrXprohu/yZeFZX2GqMFtu7jne1H6Z7k+NN6IYYbUPObDEAC46A+lkYNdh3yBRUqBb9xJYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=ZSzmJW7M; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="ZSzmJW7M"
ARC-Seal: i=1; a=rsa-sha256; t=1782046998; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NfF1pGePgsZnut26MfgdjhbBWAbislLX2xHm++Vl1m012jp28gTJFqlkHRJl1FhRKVAbkMfh+TZx6U7RB2Oq8LXXKTtjswu8ax9H6wr+s6ABBN55u+Ng3qsDe4ZJZB7q4S05WMjKp2Bp16zystlIRRl58m50+qD2AbAUpKdV4Ac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782046998; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FQJiXUAaMOJcZLDmmijVIF15/BdHvIXbJtlsM+hDaqQ=; 
	b=MAk0Aa/dY+0dOhAh81AdVf17/boVnuCrQu7/KFL5Gers5quqXPYkJbfT1zSy9v6NChEujHkxZCgWrHfC5xVchmFp27bmYXmCZwdIIHw6HB81Xgnmib++WEFfRhujEgYcW1WrBAlkKktt0FBF8y2M4nvJZqcaczUH8h7MNd23lPY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782046998;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FQJiXUAaMOJcZLDmmijVIF15/BdHvIXbJtlsM+hDaqQ=;
	b=ZSzmJW7MyPmJ84hjBV4vHsZISAGKGgk4KeuvSaCH2sYQFgiqLaDa7J2HSitA+3Sc
	IX9+I6wopkdNDSou+5Ez9di46XnJrOUznz87s6lEm7S+0ZhDrjodIHVdRsFgbfnZar+
	CdITMXmZdcLgx15vZc8ODUbPiU5nmmCYYRezgSiE=
Received: by mx.zohomail.com with SMTPS id 1782046996030630.2157956865668;
	Sun, 21 Jun 2026 06:03:16 -0700 (PDT)
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
Subject: [PATCH v6 04/12] nvdimm: virtio_pmem: stop allocating child flush bio
Date: Sun, 21 Jun 2026 21:02:35 +0800
Message-ID: <20260621130246.2973254-5-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260621130246.2973254-1-me@linux.beauty>
References: <20260621130246.2973254-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

pmem_submit_bio() passes the parent bio to nvdimm_flush() for
REQ_FUA. For virtio-pmem this makes async_pmem_flush() allocate
and submit a child PREFLUSH bio chained to the parent.

That child allocation is in the block submit path. Making it
blocking with GFP_NOIO can consume the same global bio mempool that
submit_bio() uses, while making it GFP_ATOMIC can fail under
pressure. A forced failure of the child allocation produced:

virtio_pmem: forcing child bio allocation failure for test
Buffer I/O error on dev pmem0, logical block 0, lost sync page write
EXT4-fs (pmem0): I/O error while writing superblock
EXT4-fs (pmem0): mount failed

Avoid the child bio completely. Flush FUA synchronously, like
REQ_PREFLUSH, then complete the parent after the flush. Since no
child bio can be created, async_pmem_flush() now only issues the
virtio flush and preserves negative errno values.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v6:
- Replace the child bio allocation fix with synchronous FUA flushing.

 drivers/nvdimm/nd_virtio.c | 22 ++++------------------
 drivers/nvdimm/pmem.c      |  2 +-
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4176046627beb..4b2e9c47af0f5 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -110,27 +110,13 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 /* The asynchronous flush callback function */
 int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 {
-	/*
-	 * Create child bio for asynchronous flush and chain with
-	 * parent bio. Otherwise directly call nd_region flush.
-	 */
-	if (bio && bio->bi_iter.bi_sector != -1) {
-		struct bio *child = bio_alloc(bio->bi_bdev, 0,
-					      REQ_OP_WRITE | REQ_PREFLUSH,
-					      GFP_ATOMIC);
+	int err;
 
-		if (!child)
-			return -ENOMEM;
-		bio_clone_blkg_association(child, bio);
-		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
-		return 0;
-	}
-	if (virtio_pmem_flush(nd_region))
+	err = virtio_pmem_flush(nd_region);
+	if (err > 0)
 		return -EIO;
 
-	return 0;
+	return err;
 };
 EXPORT_SYMBOL_GPL(async_pmem_flush);
 MODULE_DESCRIPTION("Virtio Persistent Memory Driver");
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 82ee1ddb3a445..058d2739c95a1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -242,7 +242,7 @@ static void pmem_submit_bio(struct bio *bio)
 	}
 
 	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
-		ret = nvdimm_flush(nd_region, bio);
+		ret = nvdimm_flush(nd_region, NULL);
 
 	if (ret)
 		bio->bi_status = errno_to_blk_status(ret);
-- 
2.52.0
