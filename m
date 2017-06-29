Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B7F7D2095A6BF
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:59:11 -0700 (PDT)
Subject: [PATCH v4 15/16] libnvdimm, pmem,
 dax: export a cache control attribute
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:54:17 -0700
Message-ID: <149875885755.10031.2960001252640880575.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The dax_flush() operation can be turned into a nop on platforms where
firmware arranges for cpu caches to be flushed on a power-fail event.
The ACPI 6.2 specification defines a mechanism for the platform to
indicate this capability so the kernel can select the proper default.
However, for other platforms, the administrator must toggle this setting
manually.

Given this flush setting is a dax-specific mechanism we advertise it
through a 'dax' attribute group hanging off a host device. For example,
a 'pmem0' block-device gets a 'dax' sysfs-subdirectory with a
'write_cache' attribute to control response to dax cache flush requests.
This is similar to the 'queue/write_cache' attribute that appears under
block devices.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/pmem.c |   10 ++++++
 include/linux/dax.h   |    3 ++
 3 files changed, 92 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 8bf71195921b..4827251782a1 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -119,6 +119,8 @@ EXPORT_SYMBOL_GPL(__bdev_dax_supported);
 enum dax_device_flags {
 	/* !alive + rcu grace period == no new operations / mappings */
 	DAXDEV_ALIVE,
+	/* gate whether dax_flush() calls the low level flush routine */
+	DAXDEV_WRITE_CACHE,
 };
 
 /**
@@ -139,6 +141,71 @@ struct dax_device {
 	const struct dax_operations *ops;
 };
 
+static ssize_t write_cache_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
+	ssize_t rc;
+
+	WARN_ON_ONCE(!dax_dev);
+	if (!dax_dev)
+		return -ENXIO;
+
+	rc = sprintf(buf, "%d\n", !!test_bit(DAXDEV_WRITE_CACHE,
+				&dax_dev->flags));
+	put_dax(dax_dev);
+	return rc;
+}
+
+static ssize_t write_cache_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	bool write_cache;
+	int rc = strtobool(buf, &write_cache);
+	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
+
+	WARN_ON_ONCE(!dax_dev);
+	if (!dax_dev)
+		return -ENXIO;
+
+	if (rc)
+		len = rc;
+	else if (write_cache)
+		set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+	else
+		clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+
+	put_dax(dax_dev);
+	return len;
+}
+static DEVICE_ATTR_RW(write_cache);
+
+static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
+
+	WARN_ON_ONCE(!dax_dev);
+	if (!dax_dev)
+		return 0;
+
+	if (a == &dev_attr_write_cache.attr && !dax_dev->ops->flush)
+		return 0;
+	return a->mode;
+}
+
+static struct attribute *dax_attributes[] = {
+	&dev_attr_write_cache.attr,
+	NULL,
+};
+
+struct attribute_group dax_attribute_group = {
+	.name = "dax",
+	.attrs = dax_attributes,
+	.is_visible = dax_visible,
+};
+EXPORT_SYMBOL_GPL(dax_attribute_group);
+
 /**
  * dax_direct_access() - translate a device pgoff to an absolute pfn
  * @dax_dev: a dax_device instance representing the logical memory range
@@ -194,11 +261,23 @@ void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 	if (!dax_alive(dax_dev))
 		return;
 
+	if (!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags))
+		return;
+
 	if (dax_dev->ops->flush)
 		dax_dev->ops->flush(dax_dev, pgoff, addr, size);
 }
 EXPORT_SYMBOL_GPL(dax_flush);
 
+void dax_write_cache(struct dax_device *dax_dev, bool wc)
+{
+	if (wc)
+		set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+	else
+		clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(dax_write_cache);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 06f6c27ec1e9..7339d184070e 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -253,6 +253,11 @@ static const struct dax_operations pmem_dax_ops = {
 	.flush = pmem_dax_flush,
 };
 
+static const struct attribute_group *pmem_attribute_groups[] = {
+	&dax_attribute_group,
+	NULL,
+};
+
 static void pmem_release_queue(void *q)
 {
 	blk_cleanup_queue(q);
@@ -287,6 +292,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct pmem_device *pmem;
 	struct resource pfn_res;
 	struct request_queue *q;
+	struct device *gendev;
 	struct gendisk *disk;
 	void *addr;
 
@@ -384,8 +390,12 @@ static int pmem_attach_disk(struct device *dev,
 		put_disk(disk);
 		return -ENOMEM;
 	}
+	dax_write_cache(dax_dev, true);
 	pmem->dax_dev = dax_dev;
 
+	gendev = disk_to_dev(disk);
+	gendev->groups = pmem_attribute_groups;
+
 	device_add_disk(dev, disk);
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 73fca1bebaf3..8f39db7439c3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -23,6 +23,8 @@ struct dax_operations {
 	void (*flush)(struct dax_device *, pgoff_t, void *, size_t);
 };
 
+extern struct attribute_group dax_attribute_group;
+
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *dax_get_by_host(const char *host);
 void put_dax(struct dax_device *dax_dev);
@@ -84,6 +86,7 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t size);
+void dax_write_cache(struct dax_device *dax_dev, bool wc);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
