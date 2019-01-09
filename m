From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v3 1/5] libnvdimm: nd_region flush callback support
Date: Wed,  9 Jan 2019 20:17:32 +0530
Message-ID: <20190109144736.17452-2-pagupta@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109144736.17452-1-pagupta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: jack@suse.cz, stefanha@redhat.com, dan.j.williams@intel.com, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, david@redhat.com, jmoyer@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, rjw@rjwysocki.net, pagupta@redhat.com
List-Id: linux-nvdimm@lists.01.org

This patch adds functionality to perform flush from guest
to host over VIRTIO. We are registering a callback based
on 'nd_region' type. virtio_pmem driver requires this special
flush function. For rest of the region types we are registering
existing flush function. Report error returned by host fsync
failure to userspace.

This also handles asynchronous flush requests from the block layer
by creating a child bio and chaining it with parent bio.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 drivers/acpi/nfit/core.c     |  4 ++--
 drivers/nvdimm/claim.c       |  6 ++++--
 drivers/nvdimm/nd.h          |  1 +
 drivers/nvdimm/pmem.c        | 12 ++++++++----
 drivers/nvdimm/region_devs.c | 38 ++++++++++++++++++++++++++++++++++++--
 include/linux/libnvdimm.h    |  5 ++++-
 6 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index b072cfc..f154852 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2234,7 +2234,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 		offset = to_interleave_offset(offset, mmio);
 
 	writeq(cmd, mmio->addr.base + offset);
-	nvdimm_flush(nfit_blk->nd_region);
+	nvdimm_flush(nfit_blk->nd_region, NULL, false);
 
 	if (nfit_blk->dimm_flags & NFIT_BLK_DCR_LATCH)
 		readq(mmio->addr.base + offset);
@@ -2283,7 +2283,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 	}
 
 	if (rw)
-		nvdimm_flush(nfit_blk->nd_region);
+		nvdimm_flush(nfit_blk->nd_region, NULL, false);
 
 	rc = read_blk_stat(nfit_blk, lane) ? -EIO : 0;
 	return rc;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index fb667bf..a1dfa06 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -263,7 +263,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
 	sector_t sector = offset >> 9;
-	int rc = 0;
+	int rc = 0, ret = 0;
 
 	if (unlikely(!size))
 		return 0;
@@ -301,7 +301,9 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	memcpy_flushcache(nsio->addr + offset, buf, size);
-	nvdimm_flush(to_nd_region(ndns->dev.parent));
+	ret = nvdimm_flush(to_nd_region(ndns->dev.parent), NULL, false);
+	if (ret)
+		rc = ret;
 
 	return rc;
 }
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 98317e7..d53a2d1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -160,6 +160,7 @@ struct nd_region {
 	struct nd_interleave_set *nd_set;
 	struct nd_percpu_lane __percpu *lane;
 	struct nd_mapping mapping[0];
+	int (*flush)(struct nd_region *nd_region);
 };
 
 struct nd_blk_region {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 6071e29..5d6a4a1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -192,6 +192,7 @@ static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 
 static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 {
+	int ret = 0;
 	blk_status_t rc = 0;
 	bool do_acct;
 	unsigned long start;
@@ -201,7 +202,7 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 	struct nd_region *nd_region = to_region(pmem);
 
 	if (bio->bi_opf & REQ_PREFLUSH)
-		nvdimm_flush(nd_region);
+		ret = nvdimm_flush(nd_region, bio, true);
 
 	do_acct = nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
@@ -216,7 +217,10 @@ static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
 	if (bio->bi_opf & REQ_FUA)
-		nvdimm_flush(nd_region);
+		ret = nvdimm_flush(nd_region, bio, true);
+
+	if (ret)
+		bio->bi_status = errno_to_blk_status(ret);
 
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
@@ -528,14 +532,14 @@ static int nd_pmem_remove(struct device *dev)
 		sysfs_put(pmem->bb_state);
 		pmem->bb_state = NULL;
 	}
-	nvdimm_flush(to_nd_region(dev->parent));
+	nvdimm_flush(to_nd_region(dev->parent), NULL, false);
 
 	return 0;
 }
 
 static void nd_pmem_shutdown(struct device *dev)
 {
-	nvdimm_flush(to_nd_region(dev->parent));
+	nvdimm_flush(to_nd_region(dev->parent), NULL, false);
 }
 
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index fa37afc..5508727 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -290,7 +290,9 @@ static ssize_t deep_flush_store(struct device *dev, struct device_attribute *att
 		return rc;
 	if (!flush)
 		return -EINVAL;
-	nvdimm_flush(nd_region);
+	rc = nvdimm_flush(nd_region, NULL, false);
+	if (rc)
+		return rc;
 
 	return len;
 }
@@ -1065,6 +1067,11 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	dev->of_node = ndr_desc->of_node;
 	nd_region->ndr_size = resource_size(ndr_desc->res);
 	nd_region->ndr_start = ndr_desc->res->start;
+	if (ndr_desc->flush)
+		nd_region->flush = ndr_desc->flush;
+	else
+		nd_region->flush = generic_nvdimm_flush;
+
 	nd_device_register(dev);
 
 	return nd_region;
@@ -1105,11 +1112,36 @@ struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 }
 EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
 
+int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async)
+{
+	int rc = 0;
+
+	/* Create child bio for asynchronous flush and chain with
+	 * parent bio. Otherwise directly call nd_region flush.
+	 */
+	if (async && bio->bi_iter.bi_sector != -1) {
+
+		struct bio *child = bio_alloc(GFP_ATOMIC, 0);
+
+		if (!child)
+			return -ENOMEM;
+		bio_copy_dev(child, bio);
+		child->bi_opf = REQ_PREFLUSH;
+		child->bi_iter.bi_sector = -1;
+		bio_chain(child, bio);
+		submit_bio(child);
+	} else {
+		if (nd_region->flush(nd_region))
+			rc = -EIO;
+	}
+
+	return rc;
+}
 /**
  * nvdimm_flush - flush any posted write queues between the cpu and pmem media
  * @nd_region: blk or interleaved pmem region
  */
-void nvdimm_flush(struct nd_region *nd_region)
+int generic_nvdimm_flush(struct nd_region *nd_region)
 {
 	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
 	int i, idx;
@@ -1133,6 +1165,8 @@ void nvdimm_flush(struct nd_region *nd_region)
 		if (ndrd_get_flush_wpq(ndrd, i, 0))
 			writeq(1, ndrd_get_flush_wpq(ndrd, i, idx));
 	wmb();
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nvdimm_flush);
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 097072c..b49632c 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -115,6 +115,7 @@ struct nd_mapping_desc {
 	int position;
 };
 
+struct nd_region;
 struct nd_region_desc {
 	struct resource *res;
 	struct nd_mapping_desc *mapping;
@@ -126,6 +127,7 @@ struct nd_region_desc {
 	int numa_node;
 	unsigned long flags;
 	struct device_node *of_node;
+	int (*flush)(struct nd_region *nd_region);
 };
 
 struct device;
@@ -201,7 +203,8 @@ unsigned long nd_blk_memremap_flags(struct nd_blk_region *ndbr);
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
-void nvdimm_flush(struct nd_region *nd_region);
+int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async);
+int generic_nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 
-- 
2.9.3
