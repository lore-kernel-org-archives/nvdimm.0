Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CF229428;
	Fri,  7 Jun 2024 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739968; cv=none; b=VUDg73CPBwgkcCZIyoLRX88sq4SQU5VBUNeAiCTP7LH1sv1GHLRaCxMGKOkj2oQ97+SwLITsPy/vk/scdEMMxcotU9ATuhYYj2V22DUeNKLdNnoJdL8CJDs6xqbgYlhscmZ5q31kRM3Ash/IfkinOM0ocJGjprdR9kFe87xSO1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739968; c=relaxed/simple;
	bh=Q4gne7zGaRoQcAjCePg+bFPjkBElOwggMTq/gDbx5Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfbja0Lg2dwPYG3qC3ifim8HuMPa1ySF7E8247FWD402HGaH15NIhhlBrNIAGjioy957b6kcP3TGYXJP+YtYgxOWf7QN8SH0/1NBPO0VB2nfijlKUmFFlf2UPDPp8i4BoyikXLUa3WLEJvAXCyoyGF5cGtsNHi7dYvGsEC++EuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5Bb249wo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5Bb249wo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WcS17019swi+eot3hQXZLSEBmFN0nZ0zcexqseGp7yk=; b=5Bb249wozAdJbUwmxD3gYthR+0
	lOiO3TS+PJJEnWf8yfFee/NRzbm0tjVh12WfvI7HoWE3DzfWeqMkgkWa9XUPKLqlhEmyjMBqicWwX
	UhQDx1ExAKNTwlGFaw5+JQ4sCC/jQc8lsdu+EVceoyGOXEKXcgx/hT6gZ58wQIYCZRDOHEZbEgKqd
	79wDm5O2vA9Xjwu4T5YDVozdyBv860acBZnWEcUdNPfQe/FqwaS2ia+MNIM0iMCUVbW6+kXNyP7qv
	TRBl0Ut5/l9MMHh54vAvU5Ab90XuiiiElX0M7dIBkygNYbelw4ytZqUsqbf3eeXJKSlS7y+yWa24w
	17mLaLvw==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSdF-0000000CZyO-1Bpl;
	Fri, 07 Jun 2024 05:59:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 01/11] dm-integrity: use the nop integrity profile
Date: Fri,  7 Jun 2024 07:58:55 +0200
Message-ID: <20240607055912.3586772-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240607055912.3586772-1-hch@lst.de>
References: <20240607055912.3586772-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the block layer built-in nop profile instead of duplicating it.

Tested by:

$ dd if=/dev/urandom of=key.bin bs=512 count=1

$ cryptsetup luksFormat -q --type luks2 --integrity hmac-sha256 \
 	--integrity-no-wipe /dev/nvme0n1 key.bin
$ cryptsetup luksOpen /dev/nvme0n1 luks-integrity --key-file key.bin

and then doing mkfs.xfs and simple I/O on the mount file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Milan Broz <gmazyland@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/md/dm-crypt.c     |  4 ++--
 drivers/md/dm-integrity.c | 20 --------------------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b7a97cc377943..1dfc462f29cd6f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1176,8 +1176,8 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 	struct blk_integrity *bi = blk_get_integrity(cc->dev->bdev->bd_disk);
 	struct mapped_device *md = dm_table_get_md(ti->table);
 
-	/* From now we require underlying device with our integrity profile */
-	if (!bi || strcasecmp(bi->profile->name, "DM-DIF-EXT-TAG")) {
+	/* We require an underlying device with non-PI metadata */
+	if (!bi || strcmp(bi->profile->name, "nop")) {
 		ti->error = "Integrity profile not supported.";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 417fddebe367a2..c1cc27541673c7 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -350,25 +350,6 @@ static struct kmem_cache *journal_io_cache;
 #define DEBUG_bytes(bytes, len, msg, ...)	do { } while (0)
 #endif
 
-static void dm_integrity_prepare(struct request *rq)
-{
-}
-
-static void dm_integrity_complete(struct request *rq, unsigned int nr_bytes)
-{
-}
-
-/*
- * DM Integrity profile, protection is performed layer above (dm-crypt)
- */
-static const struct blk_integrity_profile dm_integrity_profile = {
-	.name			= "DM-DIF-EXT-TAG",
-	.generate_fn		= NULL,
-	.verify_fn		= NULL,
-	.prepare_fn		= dm_integrity_prepare,
-	.complete_fn		= dm_integrity_complete,
-};
-
 static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map);
 static void integrity_bio_wait(struct work_struct *w);
 static void dm_integrity_dtr(struct dm_target *ti);
@@ -3656,7 +3637,6 @@ static void dm_integrity_set(struct dm_target *ti, struct dm_integrity_c *ic)
 	struct blk_integrity bi;
 
 	memset(&bi, 0, sizeof(bi));
-	bi.profile = &dm_integrity_profile;
 	bi.tuple_size = ic->tag_size;
 	bi.tag_size = bi.tuple_size;
 	bi.interval_exp = ic->sb->log2_sectors_per_block + SECTOR_SHIFT;
-- 
2.43.0

