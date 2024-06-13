Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8B954757;
	Thu, 13 Jun 2024 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268539; cv=none; b=hkXn2GbwCsEMxYcvvoLUdK+8HNSH17+MSIDXliw/2REiw+VyxWjdPd3ADOyIt39wSwZ7uTTRDubtIAjo0AOZi4uda91tr8GEhgi/8JbR+zSOK00Sf2vtgGN50d0dXB3pPDDtpgQprkPaVxXLEVm04ampc/TkVtO04xKkbARtzAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268539; c=relaxed/simple;
	bh=jbw6sPg0ywQ50GPMyLJUA8X/11LRjzEhyV9K8Jtd8BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDZBqJinTZrvn4Ju1hnZ2YGREF+uw4ZZipG0bouHnNwUBPRTNtaGFd9rzuGOp1KIWn4OcfxyPHhwLtjJXz7CORdz0LHJNUa5UA2wX3CH0ImNs7yyDq2mop3aiPjp3GPJsu2xWWAZrhk96alYik8/fAWKwY3ZBtLaB4STN7j2SV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QJAwTDBU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QJAwTDBU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rDZ4qt3AoqoPcKWZiGxU0EtuQJXHPorwNNYlCF4FSTc=; b=QJAwTDBUrEVKEpKs8uRobM0tjW
	tVznz6MLlVW6EiQ0d1x4ms7I3gGqH6GjC/PuHJW2Be06l0ttgjlu1QU1mtBcei7aW1Sa1uXvFzDWJ
	8dnQXuLvfiLKHCPWkTkuGQYEWYMUoVQn82laC+dQCNkSf3sYzRnqweOCGWoToeeObsV8ZmskcuYy5
	dgyo2107ponpouQulJoKoRAQGdH7QBef4rB4REk/ysMQVAUaTtiBWs7SO9Igp0ydLbqE85+vfWI5L
	foNH32pCOXb6akbzS00sgpiMn9uR58iYB1y5TMfqIE16l9bYeKbOsKcG6JDg2MC6hgX3cw2qPi9VG
	a+rR8bkg==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8b-0000000Fn60-3mbI;
	Thu, 13 Jun 2024 08:48:54 +0000
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
	Milan Broz <gmazyland@gmail.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/12] dm-integrity: use the nop integrity profile
Date: Thu, 13 Jun 2024 10:48:14 +0200
Message-ID: <20240613084839.1044015-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240613084839.1044015-1-hch@lst.de>
References: <20240613084839.1044015-1-hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

