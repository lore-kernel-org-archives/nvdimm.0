Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C527F14F11B;
	Fri,  7 Jun 2024 05:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739979; cv=none; b=s47ncjfA3zXgsHojnAyX2e8a5EHJSpu9Lk8ntCRBY3QG3Smw5s+SZpetyJp8EvI/gDpVaYFpBZdMwVcXuLOaJFNOM0i4lciJ2jXAUWt5LWSdZ3xETToK1eZNZnf1dRvr5VEvPG01MSKqKAactjWn+uIX2yrCmPRx44SOEnjM0uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739979; c=relaxed/simple;
	bh=L01A8gIKF+CtAG1vsxIl2wFgZf9MmBnuHf6ZSbhoG5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl5QdLhShQfkDNLctoW9OJlCnoFEbf3ePJyOHpVz+hXg1SIhVQvlUDimf//+wUIKZPuBRxalJzI5Gh1jIx59BrXI6R8dsN9zTPy5a7UgS8jlb4a3q5r6hMy20HBMKScKeDkNzs9t8pyrosky0Ujd6HtUiR/DAQGNOguCOTKCUWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i1f2RH+k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i1f2RH+k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iKNSFaenddomXWRrxAaHox+d4dOqey0huaBGoODt0PI=; b=i1f2RH+k0vbN7APoUBqL7CGrI3
	1iJFXuc1zXY0MGFlp1HfhibgnY+pGcYU/zFTauFCOVnUwKZNb2oCJPHRqULKNOwu/KbqhGDReTB6o
	qXO3cN90yCaFEHAkgv43sfzJnvCDof5uW+Qorex8wPssYyuNvrztazEQ0P4eOT4hRWbrqq39SmTSE
	cqSswv1WFRs5FCd6FlPXdnB4YdUTOxXLe+C1DmPzi+MXr/+MUDYoWnaeKL+fhwxotJ50Pouxgr78I
	jUnxpTPaWEDMufZUNCKRAFGi2sdxxs5m8ldyN7pc6wNRm67QmYPISnXKZAKnxKzL5/K5eye7/6+YW
	W2+My/bg==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSdP-0000000CZzs-2bOL;
	Fri, 07 Jun 2024 05:59:32 +0000
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
	linux-scsi@vger.kernel.org
Subject: [PATCH 04/11] block: remove the blk_integrity_profile structure
Date: Fri,  7 Jun 2024 07:58:58 +0200
Message-ID: <20240607055912.3586772-5-hch@lst.de>
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

Block layer integrity configuration is a bit complex right now, as it
indirects through operation vectors for a simple two-dimensional
configuration:

 a) the checksum type of none, ip checksum, crc, crc64
 b) the presence or absence of a reference tag

Remove the integrity profile, and instead add a separate csum_type flag
which replaces the existing ip-checksum field and a new flag that
indicates the presence of the reference tag.

This removes up to two layers of indirect calls, remove the need to
offload the no-op verification of non-PI metadata to a workqueue and
generally simplifies the code. The downside is that block/t10-pi.c now
has to be built into the kernel when CONFIG_BLK_DEV_INTEGRITY is
supported.  Given that both nvme and SCSI require t10-pi.ko, it is loaded
for all usual configurations that enabled CONFIG_BLK_DEV_INTEGRITY
already, though.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Kconfig                       |   8 +-
 block/Makefile                      |   3 +-
 block/bio-integrity.c               |  30 ++--
 block/blk-integrity.c               |  66 ++++----
 block/blk-mq.c                      |  13 +-
 block/blk.h                         |   8 +
 block/t10-pi.c                      | 241 ++++++++++------------------
 drivers/md/dm-crypt.c               |   2 +-
 drivers/nvme/host/Kconfig           |   1 -
 drivers/nvme/host/core.c            |  17 +-
 drivers/nvme/target/Kconfig         |   1 -
 drivers/nvme/target/io-cmd-bdev.c   |  16 +-
 drivers/scsi/Kconfig                |   1 -
 drivers/scsi/sd.c                   |   2 +-
 drivers/scsi/sd_dif.c               |  19 +--
 drivers/target/target_core_iblock.c |  49 +++---
 include/linux/blk-integrity.h       |  35 ++--
 include/linux/blkdev.h              |   9 +-
 include/linux/t10-pi.h              |   8 -
 19 files changed, 215 insertions(+), 314 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index dc12af58dbaeca..5b623b876d3b4a 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -62,6 +62,8 @@ config BLK_DEV_BSGLIB
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
+	select CRC_T10DIF
+	select CRC64_ROCKSOFT
 	help
 	Some storage devices allow extra information to be
 	stored/retrieved to help protect the data.  The block layer
@@ -72,12 +74,6 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
-config BLK_DEV_INTEGRITY_T10
-	tristate
-	depends on BLK_DEV_INTEGRITY
-	select CRC_T10DIF
-	select CRC64_ROCKSOFT
-
 config BLK_DEV_WRITE_MOUNTED
 	bool "Allow writing to mounted block devices"
 	default y
diff --git a/block/Makefile b/block/Makefile
index 168150b9c51025..ddfd21c1a9ffc9 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -26,8 +26,7 @@ obj-$(CONFIG_MQ_IOSCHED_KYBER)	+= kyber-iosched.o
 bfq-y				:= bfq-iosched.o bfq-wf2q.o bfq-cgroup.o
 obj-$(CONFIG_IOSCHED_BFQ)	+= bfq.o
 
-obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o
-obj-$(CONFIG_BLK_DEV_INTEGRITY_T10)	+= t10-pi.o
+obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o
 obj-$(CONFIG_BLK_MQ_PCI)	+= blk-mq-pci.o
 obj-$(CONFIG_BLK_MQ_VIRTIO)	+= blk-mq-virtio.o
 obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index c69da65759af89..e23acf59c12de3 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -378,10 +378,9 @@ EXPORT_SYMBOL_GPL(bio_integrity_map_user);
  * bio_integrity_process - Process integrity metadata for a bio
  * @bio:	bio to generate/verify integrity metadata for
  * @proc_iter:  iterator to process
- * @proc_fn:	Pointer to the relevant processing function
  */
 static blk_status_t bio_integrity_process(struct bio *bio,
-		struct bvec_iter *proc_iter, integrity_processing_fn *proc_fn)
+		struct bvec_iter *proc_iter)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct blk_integrity_iter iter;
@@ -392,17 +391,18 @@ static blk_status_t bio_integrity_process(struct bio *bio,
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = 1 << bi->interval_exp;
-	iter.tuple_size = bi->tuple_size;
 	iter.seed = proc_iter->bi_sector;
 	iter.prot_buf = bvec_virt(bip->bip_vec);
-	iter.pi_offset = bi->pi_offset;
 
 	__bio_for_each_segment(bv, bio, bviter, *proc_iter) {
 		void *kaddr = bvec_kmap_local(&bv);
 
 		iter.data_buf = kaddr;
 		iter.data_size = bv.bv_len;
-		ret = proc_fn(&iter);
+		if (bio_data_dir(bio) == WRITE)
+			blk_integrity_generate(&iter, bi);
+		else
+			ret = blk_integrity_verify(&iter, bi);
 		kunmap_local(kaddr);
 
 		if (ret)
@@ -448,12 +448,10 @@ bool bio_integrity_prep(struct bio *bio)
 		return true;
 
 	if (bio_data_dir(bio) == READ) {
-		if (!bi->profile->verify_fn ||
-		    !(bi->flags & BLK_INTEGRITY_VERIFY))
+		if (!(bi->flags & BLK_INTEGRITY_VERIFY))
 			return true;
 	} else {
-		if (!bi->profile->generate_fn ||
-		    !(bi->flags & BLK_INTEGRITY_GENERATE))
+		if (!(bi->flags & BLK_INTEGRITY_GENERATE))
 			return true;
 
 		/*
@@ -508,12 +506,10 @@ bool bio_integrity_prep(struct bio *bio)
 	}
 
 	/* Auto-generate integrity metadata if this is a write */
-	if (bio_data_dir(bio) == WRITE) {
-		bio_integrity_process(bio, &bio->bi_iter,
-				      bi->profile->generate_fn);
-	} else {
+	if (bio_data_dir(bio) == WRITE)
+		bio_integrity_process(bio, &bio->bi_iter);
+	else
 		bip->bio_iter = bio->bi_iter;
-	}
 	return true;
 
 err_end_io:
@@ -536,15 +532,13 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	struct bio_integrity_payload *bip =
 		container_of(work, struct bio_integrity_payload, bip_work);
 	struct bio *bio = bip->bip_bio;
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 
 	/*
 	 * At the moment verify is called bio's iterator was advanced
 	 * during split and completion, we need to rewind iterator to
 	 * it's original position.
 	 */
-	bio->bi_status = bio_integrity_process(bio, &bip->bio_iter,
-						bi->profile->verify_fn);
+	bio->bi_status = bio_integrity_process(bio, &bip->bio_iter);
 	bio_integrity_free(bio);
 	bio_endio(bio);
 }
@@ -566,7 +560,7 @@ bool __bio_integrity_endio(struct bio *bio)
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
-	    (bip->bip_flags & BIP_BLOCK_INTEGRITY) && bi->profile->verify_fn) {
+	    (bip->bip_flags & BIP_BLOCK_INTEGRITY) && bi->csum_type) {
 		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
 		queue_work(kintegrityd_wq, &bip->bip_work);
 		return false;
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index ccbeb6dfa87a4d..17d37badfbb8bc 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -123,10 +123,10 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 	struct blk_integrity *b1 = &gd1->queue->integrity;
 	struct blk_integrity *b2 = &gd2->queue->integrity;
 
-	if (!b1->profile && !b2->profile)
+	if (!b1->tuple_size && !b2->tuple_size)
 		return 0;
 
-	if (!b1->profile || !b2->profile)
+	if (!b1->tuple_size || !b2->tuple_size)
 		return -1;
 
 	if (b1->interval_exp != b2->interval_exp) {
@@ -150,10 +150,13 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 		return -1;
 	}
 
-	if (b1->profile != b2->profile) {
+	if (b1->csum_type != b2->csum_type ||
+	    (b1->flags & BLK_INTEGRITY_REF_TAG) !=
+	    (b2->flags & BLK_INTEGRITY_REF_TAG)) {
 		pr_err("%s: %s/%s type %s != %s\n", __func__,
 		       gd1->disk_name, gd2->disk_name,
-		       b1->profile->name, b2->profile->name);
+		       blk_integrity_profile_name(b1),
+		       blk_integrity_profile_name(b2));
 		return -1;
 	}
 
@@ -217,14 +220,37 @@ static inline struct blk_integrity *dev_to_bi(struct device *dev)
 	return &dev_to_disk(dev)->queue->integrity;
 }
 
+const char *blk_integrity_profile_name(struct blk_integrity *bi)
+{
+	switch (bi->csum_type) {
+	case BLK_INTEGRITY_CSUM_IP:
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
+			return "T10-DIF-TYPE1-IP";
+		return "T10-DIF-TYPE3-IP";
+	case BLK_INTEGRITY_CSUM_CRC:
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
+			return "T10-DIF-TYPE1-CRC";
+		return "T10-DIF-TYPE3-CRC";
+	case BLK_INTEGRITY_CSUM_CRC64:
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
+			return "EXT-DIF-TYPE1-CRC64";
+		return "EXT-DIF-TYPE3-CRC64";
+	case BLK_INTEGRITY_CSUM_NONE:
+		break;
+	}
+
+	return "nop";
+}
+EXPORT_SYMBOL_GPL(blk_integrity_profile_name);
+
 static ssize_t format_show(struct device *dev, struct device_attribute *attr,
 			   char *page)
 {
 	struct blk_integrity *bi = dev_to_bi(dev);
 
-	if (bi->profile && bi->profile->name)
-		return sysfs_emit(page, "%s\n", bi->profile->name);
-	return sysfs_emit(page, "none\n");
+	if (!bi->tuple_size)
+		return sysfs_emit(page, "none\n");
+	return sysfs_emit(page, "%s\n", blk_integrity_profile_name(bi));
 }
 
 static ssize_t tag_size_show(struct device *dev, struct device_attribute *attr,
@@ -326,28 +352,6 @@ const struct attribute_group blk_integrity_attr_group = {
 	.attrs = integrity_attrs,
 };
 
-static blk_status_t blk_integrity_nop_fn(struct blk_integrity_iter *iter)
-{
-	return BLK_STS_OK;
-}
-
-static void blk_integrity_nop_prepare(struct request *rq)
-{
-}
-
-static void blk_integrity_nop_complete(struct request *rq,
-		unsigned int nr_bytes)
-{
-}
-
-static const struct blk_integrity_profile nop_profile = {
-	.name = "nop",
-	.generate_fn = blk_integrity_nop_fn,
-	.verify_fn = blk_integrity_nop_fn,
-	.prepare_fn = blk_integrity_nop_prepare,
-	.complete_fn = blk_integrity_nop_complete,
-};
-
 /**
  * blk_integrity_register - Register a gendisk as being integrity-capable
  * @disk:	struct gendisk pointer to make integrity-aware
@@ -363,11 +367,11 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 {
 	struct blk_integrity *bi = &disk->queue->integrity;
 
+	bi->csum_type = template->csum_type;
 	bi->flags = BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE |
 		template->flags;
 	bi->interval_exp = template->interval_exp ? :
 		ilog2(queue_logical_block_size(disk->queue));
-	bi->profile = template->profile ? template->profile : &nop_profile;
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
 	bi->pi_offset = template->pi_offset;
@@ -394,7 +398,7 @@ void blk_integrity_unregister(struct gendisk *disk)
 {
 	struct blk_integrity *bi = &disk->queue->integrity;
 
-	if (!bi->profile)
+	if (!bi->tuple_size)
 		return;
 
 	/* ensure all bios are off the integrity workqueue */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3b4df8e5ac9e5f..0d4cd39c3d25da 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -804,10 +804,8 @@ static void blk_complete_request(struct request *req)
 	if (!bio)
 		return;
 
-#ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (blk_integrity_rq(req) && req_op(req) == REQ_OP_READ)
-		req->q->integrity.profile->complete_fn(req, total_bytes);
-#endif
+		blk_integrity_complete(req, total_bytes);
 
 	/*
 	 * Upper layers may call blk_crypto_evict_key() anytime after the last
@@ -875,11 +873,9 @@ bool blk_update_request(struct request *req, blk_status_t error,
 	if (!req->bio)
 		return false;
 
-#ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (blk_integrity_rq(req) && req_op(req) == REQ_OP_READ &&
 	    error == BLK_STS_OK)
-		req->q->integrity.profile->complete_fn(req, nr_bytes);
-#endif
+		blk_integrity_complete(req, nr_bytes);
 
 	/*
 	 * Upper layers may call blk_crypto_evict_key() anytime after the last
@@ -1264,10 +1260,9 @@ void blk_mq_start_request(struct request *rq)
 	WRITE_ONCE(rq->state, MQ_RQ_IN_FLIGHT);
 	rq->mq_hctx->tags->rqs[rq->tag] = rq;
 
-#ifdef CONFIG_BLK_DEV_INTEGRITY
 	if (blk_integrity_rq(rq) && req_op(rq) == REQ_OP_WRITE)
-		q->integrity.profile->prepare_fn(rq);
-#endif
+		blk_integrity_prepare(rq);
+
 	if (rq->bio && rq->bio->bi_opf & REQ_POLLED)
 	        WRITE_ONCE(rq->bio->bi_cookie, rq->mq_hctx->queue_num);
 }
diff --git a/block/blk.h b/block/blk.h
index 189bc25beb502a..79e8d5d4fe0caf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -9,6 +9,7 @@
 #include <xen/xen.h>
 #include "blk-crypto-internal.h"
 
+struct blk_integrity_iter;
 struct elevator_type;
 
 /* Max future timer expiry for timeouts */
@@ -673,4 +674,11 @@ int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
 	      const struct blk_holder_ops *hops, struct file *bdev_file);
 int bdev_permission(dev_t dev, blk_mode_t mode, void *holder);
 
+void blk_integrity_generate(struct blk_integrity_iter *iter,
+		struct blk_integrity *bi);
+blk_status_t blk_integrity_verify(struct blk_integrity_iter *iter,
+		struct blk_integrity *bi);
+void blk_integrity_prepare(struct request *rq);
+void blk_integrity_complete(struct request *rq, unsigned int nr_bytes);
+
 #endif /* BLK_INTERNAL_H */
diff --git a/block/t10-pi.c b/block/t10-pi.c
index f4cc91156da1f2..dadecf621497bb 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -11,17 +11,14 @@
 #include <linux/module.h>
 #include <net/checksum.h>
 #include <asm/unaligned.h>
+#include "blk.h"
 
-typedef __be16 (csum_fn) (__be16, void *, unsigned int);
-
-static __be16 t10_pi_crc_fn(__be16 crc, void *data, unsigned int len)
-{
-	return cpu_to_be16(crc_t10dif_update(be16_to_cpu(crc), data, len));
-}
-
-static __be16 t10_pi_ip_fn(__be16 csum, void *data, unsigned int len)
+static __be16 t10_pi_csum(__be16 csum, void *data, unsigned int len,
+		unsigned char csum_type)
 {
-	return (__force __be16)ip_compute_csum(data, len);
+	if (csum_type == BLK_INTEGRITY_CSUM_IP)
+		return (__force __be16)ip_compute_csum(data, len);
+	return cpu_to_be16(crc_t10dif_update(be16_to_cpu(csum), data, len));
 }
 
 /*
@@ -29,48 +26,44 @@ static __be16 t10_pi_ip_fn(__be16 csum, void *data, unsigned int len)
  * 16 bit app tag, 32 bit reference tag. Type 3 does not define the ref
  * tag.
  */
-static blk_status_t t10_pi_generate(struct blk_integrity_iter *iter,
-		csum_fn *fn, enum t10_dif_type type)
+static void t10_pi_generate(struct blk_integrity_iter *iter,
+		struct blk_integrity *bi)
 {
-	u8 offset = iter->pi_offset;
+	u8 offset = bi->pi_offset;
 	unsigned int i;
 
 	for (i = 0 ; i < iter->data_size ; i += iter->interval) {
 		struct t10_pi_tuple *pi = iter->prot_buf + offset;
 
-		pi->guard_tag = fn(0, iter->data_buf, iter->interval);
+		pi->guard_tag = t10_pi_csum(0, iter->data_buf, iter->interval,
+				bi->csum_type);
 		if (offset)
-			pi->guard_tag = fn(pi->guard_tag, iter->prot_buf,
-					   offset);
+			pi->guard_tag = t10_pi_csum(pi->guard_tag,
+					iter->prot_buf, offset, bi->csum_type);
 		pi->app_tag = 0;
 
-		if (type == T10_PI_TYPE1_PROTECTION)
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
 			pi->ref_tag = cpu_to_be32(lower_32_bits(iter->seed));
 		else
 			pi->ref_tag = 0;
 
 		iter->data_buf += iter->interval;
-		iter->prot_buf += iter->tuple_size;
+		iter->prot_buf += bi->tuple_size;
 		iter->seed++;
 	}
-
-	return BLK_STS_OK;
 }
 
 static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
-		csum_fn *fn, enum t10_dif_type type)
+		struct blk_integrity *bi)
 {
-	u8 offset = iter->pi_offset;
+	u8 offset = bi->pi_offset;
 	unsigned int i;
 
-	BUG_ON(type == T10_PI_TYPE0_PROTECTION);
-
 	for (i = 0 ; i < iter->data_size ; i += iter->interval) {
 		struct t10_pi_tuple *pi = iter->prot_buf + offset;
 		__be16 csum;
 
-		if (type == T10_PI_TYPE1_PROTECTION ||
-		    type == T10_PI_TYPE2_PROTECTION) {
+		if (bi->flags & BLK_INTEGRITY_REF_TAG) {
 			if (pi->app_tag == T10_PI_APP_ESCAPE)
 				goto next;
 
@@ -82,15 +75,17 @@ static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
 				       iter->seed, be32_to_cpu(pi->ref_tag));
 				return BLK_STS_PROTECTION;
 			}
-		} else if (type == T10_PI_TYPE3_PROTECTION) {
+		} else {
 			if (pi->app_tag == T10_PI_APP_ESCAPE &&
 			    pi->ref_tag == T10_PI_REF_ESCAPE)
 				goto next;
 		}
 
-		csum = fn(0, iter->data_buf, iter->interval);
+		csum = t10_pi_csum(0, iter->data_buf, iter->interval,
+				bi->csum_type);
 		if (offset)
-			csum = fn(csum, iter->prot_buf, offset);
+			csum = t10_pi_csum(csum, iter->prot_buf, offset,
+					bi->csum_type);
 
 		if (pi->guard_tag != csum) {
 			pr_err("%s: guard tag error at sector %llu " \
@@ -102,33 +97,13 @@ static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
 
 next:
 		iter->data_buf += iter->interval;
-		iter->prot_buf += iter->tuple_size;
+		iter->prot_buf += bi->tuple_size;
 		iter->seed++;
 	}
 
 	return BLK_STS_OK;
 }
 
-static blk_status_t t10_pi_type1_generate_crc(struct blk_integrity_iter *iter)
-{
-	return t10_pi_generate(iter, t10_pi_crc_fn, T10_PI_TYPE1_PROTECTION);
-}
-
-static blk_status_t t10_pi_type1_generate_ip(struct blk_integrity_iter *iter)
-{
-	return t10_pi_generate(iter, t10_pi_ip_fn, T10_PI_TYPE1_PROTECTION);
-}
-
-static blk_status_t t10_pi_type1_verify_crc(struct blk_integrity_iter *iter)
-{
-	return t10_pi_verify(iter, t10_pi_crc_fn, T10_PI_TYPE1_PROTECTION);
-}
-
-static blk_status_t t10_pi_type1_verify_ip(struct blk_integrity_iter *iter)
-{
-	return t10_pi_verify(iter, t10_pi_ip_fn, T10_PI_TYPE1_PROTECTION);
-}
-
 /**
  * t10_pi_type1_prepare - prepare PI prior submitting request to device
  * @rq:              request with PI that should be prepared
@@ -225,81 +200,15 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 	}
 }
 
-static blk_status_t t10_pi_type3_generate_crc(struct blk_integrity_iter *iter)
-{
-	return t10_pi_generate(iter, t10_pi_crc_fn, T10_PI_TYPE3_PROTECTION);
-}
-
-static blk_status_t t10_pi_type3_generate_ip(struct blk_integrity_iter *iter)
-{
-	return t10_pi_generate(iter, t10_pi_ip_fn, T10_PI_TYPE3_PROTECTION);
-}
-
-static blk_status_t t10_pi_type3_verify_crc(struct blk_integrity_iter *iter)
-{
-	return t10_pi_verify(iter, t10_pi_crc_fn, T10_PI_TYPE3_PROTECTION);
-}
-
-static blk_status_t t10_pi_type3_verify_ip(struct blk_integrity_iter *iter)
-{
-	return t10_pi_verify(iter, t10_pi_ip_fn, T10_PI_TYPE3_PROTECTION);
-}
-
-/* Type 3 does not have a reference tag so no remapping is required. */
-static void t10_pi_type3_prepare(struct request *rq)
-{
-}
-
-/* Type 3 does not have a reference tag so no remapping is required. */
-static void t10_pi_type3_complete(struct request *rq, unsigned int nr_bytes)
-{
-}
-
-const struct blk_integrity_profile t10_pi_type1_crc = {
-	.name			= "T10-DIF-TYPE1-CRC",
-	.generate_fn		= t10_pi_type1_generate_crc,
-	.verify_fn		= t10_pi_type1_verify_crc,
-	.prepare_fn		= t10_pi_type1_prepare,
-	.complete_fn		= t10_pi_type1_complete,
-};
-EXPORT_SYMBOL(t10_pi_type1_crc);
-
-const struct blk_integrity_profile t10_pi_type1_ip = {
-	.name			= "T10-DIF-TYPE1-IP",
-	.generate_fn		= t10_pi_type1_generate_ip,
-	.verify_fn		= t10_pi_type1_verify_ip,
-	.prepare_fn		= t10_pi_type1_prepare,
-	.complete_fn		= t10_pi_type1_complete,
-};
-EXPORT_SYMBOL(t10_pi_type1_ip);
-
-const struct blk_integrity_profile t10_pi_type3_crc = {
-	.name			= "T10-DIF-TYPE3-CRC",
-	.generate_fn		= t10_pi_type3_generate_crc,
-	.verify_fn		= t10_pi_type3_verify_crc,
-	.prepare_fn		= t10_pi_type3_prepare,
-	.complete_fn		= t10_pi_type3_complete,
-};
-EXPORT_SYMBOL(t10_pi_type3_crc);
-
-const struct blk_integrity_profile t10_pi_type3_ip = {
-	.name			= "T10-DIF-TYPE3-IP",
-	.generate_fn		= t10_pi_type3_generate_ip,
-	.verify_fn		= t10_pi_type3_verify_ip,
-	.prepare_fn		= t10_pi_type3_prepare,
-	.complete_fn		= t10_pi_type3_complete,
-};
-EXPORT_SYMBOL(t10_pi_type3_ip);
-
 static __be64 ext_pi_crc64(u64 crc, void *data, unsigned int len)
 {
 	return cpu_to_be64(crc64_rocksoft_update(crc, data, len));
 }
 
-static blk_status_t ext_pi_crc64_generate(struct blk_integrity_iter *iter,
-					enum t10_dif_type type)
+static void ext_pi_crc64_generate(struct blk_integrity_iter *iter,
+		struct blk_integrity *bi)
 {
-	u8 offset = iter->pi_offset;
+	u8 offset = bi->pi_offset;
 	unsigned int i;
 
 	for (i = 0 ; i < iter->data_size ; i += iter->interval) {
@@ -311,17 +220,15 @@ static blk_status_t ext_pi_crc64_generate(struct blk_integrity_iter *iter,
 					iter->prot_buf, offset);
 		pi->app_tag = 0;
 
-		if (type == T10_PI_TYPE1_PROTECTION)
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
 			put_unaligned_be48(iter->seed, pi->ref_tag);
 		else
 			put_unaligned_be48(0ULL, pi->ref_tag);
 
 		iter->data_buf += iter->interval;
-		iter->prot_buf += iter->tuple_size;
+		iter->prot_buf += bi->tuple_size;
 		iter->seed++;
 	}
-
-	return BLK_STS_OK;
 }
 
 static bool ext_pi_ref_escape(u8 *ref_tag)
@@ -332,9 +239,9 @@ static bool ext_pi_ref_escape(u8 *ref_tag)
 }
 
 static blk_status_t ext_pi_crc64_verify(struct blk_integrity_iter *iter,
-				      enum t10_dif_type type)
+		struct blk_integrity *bi)
 {
-	u8 offset = iter->pi_offset;
+	u8 offset = bi->pi_offset;
 	unsigned int i;
 
 	for (i = 0; i < iter->data_size; i += iter->interval) {
@@ -342,7 +249,7 @@ static blk_status_t ext_pi_crc64_verify(struct blk_integrity_iter *iter,
 		u64 ref, seed;
 		__be64 csum;
 
-		if (type == T10_PI_TYPE1_PROTECTION) {
+		if (bi->flags & BLK_INTEGRITY_REF_TAG) {
 			if (pi->app_tag == T10_PI_APP_ESCAPE)
 				goto next;
 
@@ -353,7 +260,7 @@ static blk_status_t ext_pi_crc64_verify(struct blk_integrity_iter *iter,
 					iter->disk_name, seed, ref);
 				return BLK_STS_PROTECTION;
 			}
-		} else if (type == T10_PI_TYPE3_PROTECTION) {
+		} else {
 			if (pi->app_tag == T10_PI_APP_ESCAPE &&
 			    ext_pi_ref_escape(pi->ref_tag))
 				goto next;
@@ -374,23 +281,13 @@ static blk_status_t ext_pi_crc64_verify(struct blk_integrity_iter *iter,
 
 next:
 		iter->data_buf += iter->interval;
-		iter->prot_buf += iter->tuple_size;
+		iter->prot_buf += bi->tuple_size;
 		iter->seed++;
 	}
 
 	return BLK_STS_OK;
 }
 
-static blk_status_t ext_pi_type1_verify_crc64(struct blk_integrity_iter *iter)
-{
-	return ext_pi_crc64_verify(iter, T10_PI_TYPE1_PROTECTION);
-}
-
-static blk_status_t ext_pi_type1_generate_crc64(struct blk_integrity_iter *iter)
-{
-	return ext_pi_crc64_generate(iter, T10_PI_TYPE1_PROTECTION);
-}
-
 static void ext_pi_type1_prepare(struct request *rq)
 {
 	struct blk_integrity *bi = &rq->q->integrity;
@@ -467,33 +364,61 @@ static void ext_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 	}
 }
 
-static blk_status_t ext_pi_type3_verify_crc64(struct blk_integrity_iter *iter)
+void blk_integrity_generate(struct blk_integrity_iter *iter,
+		struct blk_integrity *bi)
 {
-	return ext_pi_crc64_verify(iter, T10_PI_TYPE3_PROTECTION);
+	switch (bi->csum_type) {
+	case BLK_INTEGRITY_CSUM_CRC64:
+		ext_pi_crc64_generate(iter, bi);
+		break;
+	case BLK_INTEGRITY_CSUM_CRC:
+	case BLK_INTEGRITY_CSUM_IP:
+		t10_pi_generate(iter, bi);
+		break;
+	default:
+		break;
+	}
 }
 
-static blk_status_t ext_pi_type3_generate_crc64(struct blk_integrity_iter *iter)
+blk_status_t blk_integrity_verify(struct blk_integrity_iter *iter,
+		struct blk_integrity *bi)
 {
-	return ext_pi_crc64_generate(iter, T10_PI_TYPE3_PROTECTION);
+	switch (bi->csum_type) {
+	case BLK_INTEGRITY_CSUM_CRC64:
+		return ext_pi_crc64_verify(iter, bi);
+	case BLK_INTEGRITY_CSUM_CRC:
+	case BLK_INTEGRITY_CSUM_IP:
+		return t10_pi_verify(iter, bi);
+	default:
+		return BLK_STS_OK;
+	}
 }
 
-const struct blk_integrity_profile ext_pi_type1_crc64 = {
-	.name			= "EXT-DIF-TYPE1-CRC64",
-	.generate_fn		= ext_pi_type1_generate_crc64,
-	.verify_fn		= ext_pi_type1_verify_crc64,
-	.prepare_fn		= ext_pi_type1_prepare,
-	.complete_fn		= ext_pi_type1_complete,
-};
-EXPORT_SYMBOL_GPL(ext_pi_type1_crc64);
-
-const struct blk_integrity_profile ext_pi_type3_crc64 = {
-	.name			= "EXT-DIF-TYPE3-CRC64",
-	.generate_fn		= ext_pi_type3_generate_crc64,
-	.verify_fn		= ext_pi_type3_verify_crc64,
-	.prepare_fn		= t10_pi_type3_prepare,
-	.complete_fn		= t10_pi_type3_complete,
-};
-EXPORT_SYMBOL_GPL(ext_pi_type3_crc64);
+void blk_integrity_prepare(struct request *rq)
+{
+	struct blk_integrity *bi = &rq->q->integrity;
+
+	if (!(bi->flags & BLK_INTEGRITY_REF_TAG))
+		return;
+
+	if (bi->csum_type == BLK_INTEGRITY_CSUM_CRC64)
+		ext_pi_type1_prepare(rq);
+	else
+		t10_pi_type1_prepare(rq);
+}
+
+void blk_integrity_complete(struct request *rq, unsigned int nr_bytes)
+{
+	struct blk_integrity *bi = &rq->q->integrity;
+
+	if (!(bi->flags & BLK_INTEGRITY_REF_TAG))
+		return;
+
+	if (bi->csum_type == BLK_INTEGRITY_CSUM_CRC64)
+		ext_pi_type1_complete(rq, nr_bytes);
+	else
+		t10_pi_type1_complete(rq, nr_bytes);
+}
 
 MODULE_DESCRIPTION("T10 Protection Information module");
 MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1dfc462f29cd6f..6c013ceb0e5f1d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1177,7 +1177,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 	struct mapped_device *md = dm_table_get_md(ti->table);
 
 	/* We require an underlying device with non-PI metadata */
-	if (!bi || strcmp(bi->profile->name, "nop")) {
+	if (!bi || bi->csum_type != BLK_INTEGRITY_CSUM_NONE) {
 		ti->error = "Integrity profile not supported.";
 		return -EINVAL;
 	}
diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index b309c8be720f47..a3caef75aa0a83 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NVME_CORE
 	tristate
-	select BLK_DEV_INTEGRITY_T10 if BLK_DEV_INTEGRITY
 
 config BLK_DEV_NVME
 	tristate "NVM Express block device"
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5d150c62955d8..14bac248cde4ca 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1744,17 +1744,16 @@ static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head)
 	case NVME_NS_DPS_PI_TYPE3:
 		switch (head->guard_type) {
 		case NVME_NVM_NS_16B_GUARD:
-			integrity.profile = &t10_pi_type3_crc;
+			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC;
 			integrity.tag_size = sizeof(u16) + sizeof(u32);
 			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
 			break;
 		case NVME_NVM_NS_64B_GUARD:
-			integrity.profile = &ext_pi_type3_crc64;
+			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC64;
 			integrity.tag_size = sizeof(u16) + 6;
 			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
 			break;
 		default:
-			integrity.profile = NULL;
 			break;
 		}
 		break;
@@ -1762,22 +1761,22 @@ static bool nvme_init_integrity(struct gendisk *disk, struct nvme_ns_head *head)
 	case NVME_NS_DPS_PI_TYPE2:
 		switch (head->guard_type) {
 		case NVME_NVM_NS_16B_GUARD:
-			integrity.profile = &t10_pi_type1_crc;
+			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC;
 			integrity.tag_size = sizeof(u16);
-			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
+			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
+					   BLK_INTEGRITY_REF_TAG;
 			break;
 		case NVME_NVM_NS_64B_GUARD:
-			integrity.profile = &ext_pi_type1_crc64;
+			integrity.csum_type = BLK_INTEGRITY_CSUM_CRC64;
 			integrity.tag_size = sizeof(u16);
-			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
+			integrity.flags |= BLK_INTEGRITY_DEVICE_CAPABLE |
+					   BLK_INTEGRITY_REF_TAG;
 			break;
 		default:
-			integrity.profile = NULL;
 			break;
 		}
 		break;
 	default:
-		integrity.profile = NULL;
 		break;
 	}
 
diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index 872dd1a0acd804..c42aec41cc7b1f 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -6,7 +6,6 @@ config NVME_TARGET
 	depends on CONFIGFS_FS
 	select NVME_KEYRING if NVME_TARGET_TCP_TLS
 	select KEYS if NVME_TARGET_TCP_TLS
-	select BLK_DEV_INTEGRITY_T10 if BLK_DEV_INTEGRITY
 	select SGL_ALLOC
 	help
 	  This enabled target side support for the NVMe protocol, that is
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 6426aac2634aeb..b628bc5ee99847 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -61,15 +61,17 @@ static void nvmet_bdev_ns_enable_integrity(struct nvmet_ns *ns)
 {
 	struct blk_integrity *bi = bdev_get_integrity(ns->bdev);
 
-	if (bi) {
+	if (!bi)
+		return;
+
+	if (bi->csum_type == BLK_INTEGRITY_CSUM_CRC) {
 		ns->metadata_size = bi->tuple_size;
-		if (bi->profile == &t10_pi_type1_crc)
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
 			ns->pi_type = NVME_NS_DPS_PI_TYPE1;
-		else if (bi->profile == &t10_pi_type3_crc)
-			ns->pi_type = NVME_NS_DPS_PI_TYPE3;
 		else
-			/* Unsupported metadata type */
-			ns->metadata_size = 0;
+			ns->pi_type = NVME_NS_DPS_PI_TYPE3;
+	} else {
+		ns->metadata_size = 0;
 	}
 }
 
@@ -102,7 +104,7 @@ int nvmet_bdev_ns_enable(struct nvmet_ns *ns)
 
 	ns->pi_type = 0;
 	ns->metadata_size = 0;
-	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY_T10))
+	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
 		nvmet_bdev_ns_enable_integrity(ns);
 
 	if (bdev_is_zoned(ns->bdev)) {
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 065db86d602164..37c24ffea65cc0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -82,7 +82,6 @@ comment "SCSI support type (disk, tape, CD-ROM)"
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select BLK_DEV_INTEGRITY_T10 if BLK_DEV_INTEGRITY
 	help
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e21b7df5c31b0d..67f24607b862a3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -804,7 +804,7 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	unsigned int protect = 0;
 
 	if (dix) {				/* DIX Type 0, 1, 2, 3 */
-		if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
+		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
 		scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
 	}
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 1df847b5f74764..6f0921c7db787b 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -47,18 +47,13 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	memset(&bi, 0, sizeof(bi));
 
 	/* Enable DMA of protection information */
-	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP) {
-		if (type == T10_PI_TYPE3_PROTECTION)
-			bi.profile = &t10_pi_type3_ip;
-		else
-			bi.profile = &t10_pi_type1_ip;
+	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
+		bi.csum_type = BLK_INTEGRITY_CSUM_IP;
+	else
+		bi.csum_type = BLK_INTEGRITY_CSUM_CRC;
 
-		bi.flags |= BLK_INTEGRITY_IP_CHECKSUM;
-	} else
-		if (type == T10_PI_TYPE3_PROTECTION)
-			bi.profile = &t10_pi_type3_crc;
-		else
-			bi.profile = &t10_pi_type1_crc;
+	if (type != T10_PI_TYPE3_PROTECTION)
+		bi.flags |= BLK_INTEGRITY_REF_TAG;
 
 	bi.tuple_size = sizeof(struct t10_pi_tuple);
 
@@ -76,7 +71,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 
 	sd_first_printk(KERN_NOTICE, sdkp,
 			"Enabling DIX %s, application tag size %u bytes\n",
-			bi.profile->name, bi.tag_size);
+			blk_integrity_profile_name(&bi), bi.tag_size);
 out:
 	blk_integrity_register(disk, &bi);
 }
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7f6ca81778453b..a3e09adc4e767c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -148,35 +148,38 @@ static int iblock_configure_device(struct se_device *dev)
 		dev->dev_attrib.is_nonrot = 1;
 
 	bi = bdev_get_integrity(bd);
-	if (bi) {
-		struct bio_set *bs = &ib_dev->ibd_bio_set;
-
-		if (!strcmp(bi->profile->name, "T10-DIF-TYPE3-IP") ||
-		    !strcmp(bi->profile->name, "T10-DIF-TYPE1-IP")) {
-			pr_err("IBLOCK export of blk_integrity: %s not"
-			       " supported\n", bi->profile->name);
-			ret = -ENOSYS;
-			goto out_blkdev_put;
-		}
+	if (!bi)
+		return 0;
 
-		if (!strcmp(bi->profile->name, "T10-DIF-TYPE3-CRC")) {
-			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE3_PROT;
-		} else if (!strcmp(bi->profile->name, "T10-DIF-TYPE1-CRC")) {
+	switch (bi->csum_type) {
+	case BLK_INTEGRITY_CSUM_IP:
+		pr_err("IBLOCK export of blk_integrity: %s not supported\n",
+			blk_integrity_profile_name(bi));
+		ret = -ENOSYS;
+		goto out_blkdev_put;
+	case BLK_INTEGRITY_CSUM_CRC:
+		if (bi->flags & BLK_INTEGRITY_REF_TAG)
 			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE1_PROT;
-		}
+		else
+			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE3_PROT;
+		break;
+	default:
+		break;
+	}
 
-		if (dev->dev_attrib.pi_prot_type) {
-			if (bioset_integrity_create(bs, IBLOCK_BIO_POOL_SIZE) < 0) {
-				pr_err("Unable to allocate bioset for PI\n");
-				ret = -ENOMEM;
-				goto out_blkdev_put;
-			}
-			pr_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
-				 &bs->bio_integrity_pool);
+	if (dev->dev_attrib.pi_prot_type) {
+		struct bio_set *bs = &ib_dev->ibd_bio_set;
+
+		if (bioset_integrity_create(bs, IBLOCK_BIO_POOL_SIZE) < 0) {
+			pr_err("Unable to allocate bioset for PI\n");
+			ret = -ENOMEM;
+			goto out_blkdev_put;
 		}
-		dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
+		pr_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
+			 &bs->bio_integrity_pool);
 	}
 
+	dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
 	return 0;
 
 out_blkdev_put:
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index 7428cb43952da0..56ce1ae355805d 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -10,7 +10,7 @@ enum blk_integrity_flags {
 	BLK_INTEGRITY_VERIFY		= 1 << 0,
 	BLK_INTEGRITY_GENERATE		= 1 << 1,
 	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
-	BLK_INTEGRITY_IP_CHECKSUM	= 1 << 3,
+	BLK_INTEGRITY_REF_TAG		= 1 << 3,
 };
 
 struct blk_integrity_iter {
@@ -19,22 +19,10 @@ struct blk_integrity_iter {
 	sector_t		seed;
 	unsigned int		data_size;
 	unsigned short		interval;
-	unsigned char		tuple_size;
-	unsigned char		pi_offset;
 	const char		*disk_name;
 };
 
-typedef blk_status_t (integrity_processing_fn) (struct blk_integrity_iter *);
-typedef void (integrity_prepare_fn) (struct request *);
-typedef void (integrity_complete_fn) (struct request *, unsigned int);
-
-struct blk_integrity_profile {
-	integrity_processing_fn		*generate_fn;
-	integrity_processing_fn		*verify_fn;
-	integrity_prepare_fn		*prepare_fn;
-	integrity_complete_fn		*complete_fn;
-	const char			*name;
-};
+const char *blk_integrity_profile_name(struct blk_integrity *bi);
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_integrity_register(struct gendisk *, struct blk_integrity *);
@@ -44,14 +32,17 @@ int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
 				   struct scatterlist *);
 int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
 
-static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
+static inline bool
+blk_integrity_queue_supports_integrity(struct request_queue *q)
 {
-	struct blk_integrity *bi = &disk->queue->integrity;
+	return q->integrity.tuple_size;
+}
 
-	if (!bi->profile)
+static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
+{
+	if (!blk_integrity_queue_supports_integrity(disk->queue))
 		return NULL;
-
-	return bi;
+	return &disk->queue->integrity;
 }
 
 static inline struct blk_integrity *
@@ -60,12 +51,6 @@ bdev_get_integrity(struct block_device *bdev)
 	return blk_get_integrity(bdev->bd_disk);
 }
 
-static inline bool
-blk_integrity_queue_supports_integrity(struct request_queue *q)
-{
-	return q->integrity.profile;
-}
-
 static inline unsigned short
 queue_max_integrity_segments(const struct request_queue *q)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ac8e0cb2353a0e..bdd33388e1ced8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -105,9 +105,16 @@ enum {
 struct disk_events;
 struct badblocks;
 
+enum blk_integrity_checksum {
+	BLK_INTEGRITY_CSUM_NONE		= 0,
+	BLK_INTEGRITY_CSUM_IP		= 1,
+	BLK_INTEGRITY_CSUM_CRC		= 2,
+	BLK_INTEGRITY_CSUM_CRC64	= 3,
+} __packed ;
+
 struct blk_integrity {
-	const struct blk_integrity_profile	*profile;
 	unsigned char				flags;
+	enum blk_integrity_checksum		csum_type;
 	unsigned char				tuple_size;
 	unsigned char				pi_offset;
 	unsigned char				interval_exp;
diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
index 248f4ac9564258..d2bafb76badfb9 100644
--- a/include/linux/t10-pi.h
+++ b/include/linux/t10-pi.h
@@ -48,11 +48,6 @@ static inline u32 t10_pi_ref_tag(struct request *rq)
 	return blk_rq_pos(rq) >> (shift - SECTOR_SHIFT) & 0xffffffff;
 }
 
-extern const struct blk_integrity_profile t10_pi_type1_crc;
-extern const struct blk_integrity_profile t10_pi_type1_ip;
-extern const struct blk_integrity_profile t10_pi_type3_crc;
-extern const struct blk_integrity_profile t10_pi_type3_ip;
-
 struct crc64_pi_tuple {
 	__be64 guard_tag;
 	__be16 app_tag;
@@ -79,7 +74,4 @@ static inline u64 ext_pi_ref_tag(struct request *rq)
 	return lower_48_bits(blk_rq_pos(rq) >> (shift - SECTOR_SHIFT));
 }
 
-extern const struct blk_integrity_profile ext_pi_type1_crc64;
-extern const struct blk_integrity_profile ext_pi_type3_crc64;
-
 #endif
-- 
2.43.0

