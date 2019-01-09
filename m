From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v3 3/5] libnvdimm: add nd_region buffered dax_dev flag
Date: Wed,  9 Jan 2019 20:17:34 +0530
Message-ID: <20190109144736.17452-4-pagupta@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109144736.17452-1-pagupta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: jack@suse.cz, stefanha@redhat.com, dan.j.williams@intel.com, riel@surriel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com, david@redhat.com, jmoyer@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org, mst@redhat.com, jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com, eblake@redhat.com, willy@infradead.org, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, rjw@rjwysocki.net, pagupta@redhat.com
List-Id: linux-nvdimm@lists.01.org

This patch adds 'DAXDEV_BUFFERED' flag which is set
for virtio pmem corresponding nd_region. This later
is used to disable MAP_SYNC functionality for ext4
& xfs filesystem.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 drivers/dax/super.c          | 17 +++++++++++++++++
 drivers/nvdimm/pmem.c        |  3 +++
 drivers/nvdimm/region_devs.c |  7 +++++++
 drivers/virtio/pmem.c        |  1 +
 include/linux/dax.h          |  9 +++++++++
 include/linux/libnvdimm.h    |  6 ++++++
 6 files changed, 43 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 6e928f3..9128740 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -167,6 +167,8 @@ enum dax_device_flags {
 	DAXDEV_ALIVE,
 	/* gate whether dax_flush() calls the low level flush routine */
 	DAXDEV_WRITE_CACHE,
+	/* flag to disable MAP_SYNC for virtio based host page cache flush */
+	DAXDEV_BUFFERED,
 };
 
 /**
@@ -335,6 +337,21 @@ bool dax_write_cache_enabled(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
 
+void virtio_pmem_host_cache(struct dax_device *dax_dev, bool wc)
+{
+	if (wc)
+		set_bit(DAXDEV_BUFFERED, &dax_dev->flags);
+	else
+		clear_bit(DAXDEV_BUFFERED, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(virtio_pmem_host_cache);
+
+bool virtio_pmem_host_cache_enabled(struct dax_device *dax_dev)
+{
+	return test_bit(DAXDEV_BUFFERED, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(virtio_pmem_host_cache_enabled);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fe1217b..8d190a3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -472,6 +472,9 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
+
+	/* Set buffered bit in 'dax_dev' for virtio pmem */
+	virtio_pmem_host_cache(dax_dev, nvdimm_is_buffered(nd_region));
 	pmem->dax_dev = dax_dev;
 
 	gendev = disk_to_dev(disk);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index f8218b4..1f8b2be 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1264,6 +1264,13 @@ int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
 	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
 }
 
+int nvdimm_is_buffered(struct nd_region *nd_region)
+{
+	return is_nd_pmem(&nd_region->dev) &&
+		test_bit(ND_REGION_BUFFERED, &nd_region->flags);
+}
+EXPORT_SYMBOL_GPL(nvdimm_is_buffered);
+
 void __exit nd_region_devs_exit(void)
 {
 	ida_destroy(&region_ida);
diff --git a/drivers/virtio/pmem.c b/drivers/virtio/pmem.c
index 51f5349..901767b 100644
--- a/drivers/virtio/pmem.c
+++ b/drivers/virtio/pmem.c
@@ -81,6 +81,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 	ndr_desc.numa_node = nid;
 	ndr_desc.flush = virtio_pmem_flush;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+	set_bit(ND_REGION_BUFFERED, &ndr_desc.flags);
 	nd_region = nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc);
 	nd_region->provider_data =  dev_to_virtio
 					(nd_region->dev.parent->parent);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0dd316a..d16e03e 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -37,6 +37,8 @@ void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
+void virtio_pmem_host_cache(struct dax_device *dax_dev, bool wc);
+bool virtio_pmem_host_cache_enabled(struct dax_device *dax_dev);
 #else
 static inline struct dax_device *dax_get_by_host(const char *host)
 {
@@ -64,6 +66,13 @@ static inline bool dax_write_cache_enabled(struct dax_device *dax_dev)
 {
 	return false;
 }
+static inline void virtio_pmem_host_cache(struct dax_device *dax_dev, bool wc)
+{
+}
+static inline bool virtio_pmem_host_cache_enabled(struct dax_device *dax_dev)
+{
+	return false;
+}
 #endif
 
 struct writeback_control;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index ca8bc07..94616f1 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -64,6 +64,11 @@ enum {
 	 */
 	ND_REGION_PERSIST_MEMCTRL = 2,
 
+	/* provides virtio based asynchronous flush mechanism for buffered
+	 * host page cache.
+	 */
+	ND_REGION_BUFFERED = 3,
+
 	/* mark newly adjusted resources as requiring a label update */
 	DPA_RESOURCE_ADJUSTED = 1 << 0,
 };
@@ -265,6 +270,7 @@ int generic_nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
+int nvdimm_is_buffered(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.9.3
