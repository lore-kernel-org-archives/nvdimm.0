Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6DB3ED5B6;
	Tue, 30 Jun 2026 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811477; cv=pass; b=KRs27kG5TK+V/O3FFJ14710VvhT61AESudNHuvBSzJd5Qy/s0gUvNHpojvqf8WDVy3oTPjZ4QFQQGV/bti7qIVJSM+vuLtOtHV7f7wVxHy83bbNhlmn8scxZ58EwvDt9O2/C/WqxVswEB2yISly9NVVzoulO1xzOIDKGEDVJMIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811477; c=relaxed/simple;
	bh=BbMHDQceA1IdfyisIn0tkpVZ7C9XiyB446xm6M8uM5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+8JgS+nhu/VCJ71Y7RWkUO+85PIMVplT6IhLNUzR/F4e1Qx1LYQRS2oqOC3zWxrnEnp6gCGU5ojOPdfEmHsDHcBv1jV0B0qjcQ+4hkL9N5ZDxS98DUIqoA32mfx1GYO6r+MN0LlzPbl4sxUYznDM2JJRPjdDwCZB5qsU3fVS48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=P6SoNts2; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="P6SoNts2"
ARC-Seal: i=1; a=rsa-sha256; t=1782811452; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Qkb26UckPdusQBA+wqK64VlxDkwGbAG9BOTAs3ldQ4wdujE0W9clrsCyk02qbUAMBZtNCIADHaJIHSt+LHySldD6oVBArl1b2gQLO4BUAWtmxv1WUSM7CnIE3CJannybs268hRPszyr9qbLRAMURwjZSRhh5FXVIp/aLEBuU62Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782811452; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Je6+4i8hHO9bTEgatESYCTKIjgqxdEou43Rg/WNVvWk=; 
	b=gnfeLCDDARrvC8G/RjsWjMKIXkCYwi/EDJsiiUH67ZKLyyTmPxD+/1ICD4Rm7n023VmkPLoIaIXHFlVWPgvlM6vgRTAJMae0Q0JPgiHRnNKbmSXmcb8BU4/wswUiGgcRn7hjAa1t6CezAWMEyjjlBkNm4G9sKi4UkjKV68/N2kg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782811452;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Je6+4i8hHO9bTEgatESYCTKIjgqxdEou43Rg/WNVvWk=;
	b=P6SoNts2ErvqxRSGZu8nAK1MlgLmzR1Im/toBgzafEXVIjhpuawg+6X9gEqyE5Y1
	qXaQ81vJHAODY6srdElPFqtkZ0FMzuQHrMSXG/sSfFCuTAnfU2oJYiW2zxYtAZHbPuZ
	zB5mZvYXQuEblhYKiR/0ak684beKgFACF36Hcn8o=
Received: by mx.zohomail.com with SMTPS id 1782811448856466.2061160607277;
	Tue, 30 Jun 2026 02:24:08 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v7 04/12] nvdimm: virtio_pmem: stop allocating child flush bio
Date: Tue, 30 Jun 2026 17:23:29 +0800
Message-ID: <20260630092338.2094628-5-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260630092338.2094628-1-me@linux.beauty>
References: <20260630092338.2094628-1-me@linux.beauty>
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

Avoid the child bio without turning REQ_FUA into a synchronous
submit-path wait. Let provider flush callbacks return
NVDIMM_FLUSH_ASYNC after taking ownership of parent bio completion.
pmem_submit_bio() returns in that case, and virtio-pmem queues an
ordered WQ_MEM_RECLAIM work item that runs the existing host flush
path and completes the parent bio.

This keeps the asynchronous completion model of the child-bio path
while removing the child bio allocation from the submit path.

Signed-off-by: Li Chen <me@linux.beauty>
---
Changes in v7:
- Replace synchronous FUA flushing with provider-owned asynchronous parent bio
  completion.
- Add NVDIMM_FLUSH_ASYNC and ordered WQ_MEM_RECLAIM flush work.
Changes in v6:
- Replace the child bio allocation fix with synchronous FUA flushing.

 drivers/nvdimm/nd_virtio.c   | 54 +++++++++++++++++++++++++-----------
 drivers/nvdimm/pmem.c        |  5 +++-
 drivers/nvdimm/region_devs.c |  2 ++
 drivers/nvdimm/virtio_pmem.c | 17 +++++++++++-
 drivers/nvdimm/virtio_pmem.h |  4 +++
 include/linux/libnvdimm.h    |  9 ++++++
 6 files changed, 73 insertions(+), 18 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 4176046627beb..8e16b7780be1a 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -9,6 +9,12 @@
 #include "virtio_pmem.h"
 #include "nd.h"
 
+struct virtio_pmem_flush_work {
+	struct work_struct work;
+	struct nd_region *nd_region;
+	struct bio *bio;
+};
+
  /* The interrupt handler */
 void virtio_pmem_host_ack(struct virtqueue *vq)
 {
@@ -107,30 +113,46 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	return err;
 };
 
+static void virtio_pmem_flush_work(struct work_struct *work)
+{
+	struct virtio_pmem_flush_work *flush;
+	int err;
+
+	flush = container_of(work, struct virtio_pmem_flush_work, work);
+	err = virtio_pmem_flush(flush->nd_region);
+	if (err > 0)
+		err = -EIO;
+	if (err)
+		flush->bio->bi_status = errno_to_blk_status(err);
+	bio_endio(flush->bio);
+	kfree(flush);
+}
+
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
+	struct virtio_device *vdev = nd_region->provider_data;
+	struct virtio_pmem *vpmem = vdev->priv;
+	struct virtio_pmem_flush_work *flush;
+	int err;
 
-		if (!child)
+	if (bio && bio->bi_iter.bi_sector != -1) {
+		flush = kmalloc_obj(*flush, GFP_NOIO);
+		if (!flush)
 			return -ENOMEM;
-		bio_clone_blkg_association(child, bio);
-		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
-		return 0;
+
+		INIT_WORK(&flush->work, virtio_pmem_flush_work);
+		flush->nd_region = nd_region;
+		flush->bio = bio;
+		queue_work(vpmem->flush_wq, &flush->work);
+		return NVDIMM_FLUSH_ASYNC;
 	}
-	if (virtio_pmem_flush(nd_region))
+
+	err = virtio_pmem_flush(nd_region);
+	if (err > 0)
 		return -EIO;
 
-	return 0;
+	return err;
 };
 EXPORT_SYMBOL_GPL(async_pmem_flush);
 MODULE_DESCRIPTION("Virtio Persistent Memory Driver");
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 82ee1ddb3a445..30a51c365ce8b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -241,8 +241,11 @@ static void pmem_submit_bio(struct bio *bio)
 			bio_end_io_acct(bio, start);
 	}
 
-	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status)
+	if ((bio->bi_opf & REQ_FUA) && !bio->bi_status) {
 		ret = nvdimm_flush(nd_region, bio);
+		if (ret == NVDIMM_FLUSH_ASYNC)
+			return;
+	}
 
 	if (ret)
 		bio->bi_status = errno_to_blk_status(ret);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 7cd2c2f0d3121..c540f1cff9250 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1116,6 +1116,8 @@ int nvdimm_flush(struct nd_region *nd_region, struct bio *bio)
 		rc = generic_nvdimm_flush(nd_region);
 	else {
 		rc = nd_region->flush(nd_region, bio);
+		if (rc > 0)
+			return rc;
 		if (rc && rc != -ENOMEM)
 			rc = -EIO;
 	}
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 77b1966619059..9cf822a6c0c38 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -67,10 +67,17 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	mutex_init(&vpmem->flush_lock);
 	vpmem->vdev = vdev;
 	vdev->priv = vpmem;
+	vpmem->flush_wq = alloc_ordered_workqueue("virtio-pmem-flush",
+						  WQ_MEM_RECLAIM);
+	if (!vpmem->flush_wq) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
 	err = init_vq(vpmem);
 	if (err) {
 		dev_err(&vdev->dev, "failed to initialize virtio pmem vq's\n");
-		goto out_err;
+		goto out_wq;
 	}
 
 	if (virtio_has_feature(vdev, VIRTIO_PMEM_F_SHMEM_REGION)) {
@@ -131,6 +138,8 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	nvdimm_bus_unregister(vpmem->nvdimm_bus);
 out_vq:
 	vdev->config->del_vqs(vdev);
+out_wq:
+	destroy_workqueue(vpmem->flush_wq);
 out_err:
 	return err;
 }
@@ -138,14 +147,20 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 static void virtio_pmem_remove(struct virtio_device *vdev)
 {
 	struct nvdimm_bus *nvdimm_bus = dev_get_drvdata(&vdev->dev);
+	struct virtio_pmem *vpmem = vdev->priv;
 
 	nvdimm_bus_unregister(nvdimm_bus);
+	drain_workqueue(vpmem->flush_wq);
 	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	destroy_workqueue(vpmem->flush_wq);
 }
 
 static int virtio_pmem_freeze(struct virtio_device *vdev)
 {
+	struct virtio_pmem *vpmem = vdev->priv;
+
+	drain_workqueue(vpmem->flush_wq);
 	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
 
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index f72cf17f9518f..e6dfc10ce0762 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -15,6 +15,7 @@
 #include <linux/libnvdimm.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 
 struct virtio_pmem_request {
 	struct virtio_pmem_req req;
@@ -39,6 +40,9 @@ struct virtio_pmem {
 	/* Serialize flush requests to the device. */
 	struct mutex flush_lock;
 
+	/* Complete asynchronous FUA flushes outside the submit path. */
+	struct workqueue_struct *flush_wq;
+
 	/* nvdimm bus registers virtio pmem device */
 	struct nvdimm_bus *nvdimm_bus;
 	struct nvdimm_bus_descriptor nd_desc;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 28f086c4a1873..d929d83abf3be 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -126,6 +126,15 @@ struct nd_mapping_desc {
 struct bio;
 struct resource;
 struct nd_region;
+
+/*
+ * Provider flush callback return values:
+ *   0: flush completed synchronously
+ *  <0: flush failed
+ *  >0: flush completion was queued and @bio will be completed later
+ */
+#define NVDIMM_FLUSH_ASYNC 1
+
 struct nd_region_desc {
 	struct resource *res;
 	struct nd_mapping_desc *mapping;
-- 
2.52.0
