From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/5] libnvdimm: add nd_region buffered dax_dev flag
Date: Wed,  9 Jan 2019 19:20:22 +0530
Message-ID: <20190109135024.14093-4-pagupta@redhat.com>
References: <20190109135024.14093-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190109135024.14093-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This patch adds 'DAXDEV_BUFFERED' flag which is set
for virtio pmem corresponding nd_region. This later
is used to disable MAP_SYNC functionality for ext4
& xfs filesystem.

Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
