Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3546772
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 07:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=zYbf2KyTm+Ug4vgM7cfngjON2HXbsmOKfquO1lyy4pY=; b=ofYqNBXCU5Ulg0LrJXS0vtqlHJ
	dsfwXeP116ZkZnxPZrUD+8lG+OKNHbZT5WrzDPz5M9VmO2iXR10wTprmwNewqJG/BlW+Z9Qlw/X1b
	ajFktP17wyN8u27kEoOFfFynUNcTUmsDem4HnFz1tgxVwdG5o12002HKczLqRHHi6nBlTifdyvzm9
	oeEM6QkoJcu+eb13jPNVbzvJjkek7yQQVXJ/sDrwjSxoF7HPISLLe3lSvtiui3r5qj9md8l9f4rLK
	bKH/IYY82F3bg3ffpcSqGsLTSu9a3kchwOZxDaNIw79Ei+ph7TY6aoIj+47GiR8vyCqRJCS8PqDZ6
	xNGYUuag==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mSDjS-002SVD-Lv; Mon, 20 Sep 2021 07:29:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 2/3] nvdimm/pmem: move dax_attribute_group from dax to pmem
Date: Mon, 20 Sep 2021 09:27:25 +0200
Message-Id: <20210920072726.1159572-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210920072726.1159572-1-hch@lst.de>
References: <20210920072726.1159572-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

dax_attribute_group is only used by the pmem driver, and can avoid the
completely pointless lookup by the disk name if moved there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c   | 64 -------------------------------------------
 drivers/nvdimm/pmem.c | 43 +++++++++++++++++++++++++++++
 include/linux/dax.h   |  2 --
 3 files changed, 43 insertions(+), 66 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index fc89e91beea7c..e03d94bdc0449 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -231,70 +231,6 @@ enum dax_device_flags {
 	DAXDEV_SYNC,
 };
 
-static ssize_t write_cache_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
-	ssize_t rc;
-
-	WARN_ON_ONCE(!dax_dev);
-	if (!dax_dev)
-		return -ENXIO;
-
-	rc = sprintf(buf, "%d\n", !!dax_write_cache_enabled(dax_dev));
-	put_dax(dax_dev);
-	return rc;
-}
-
-static ssize_t write_cache_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	bool write_cache;
-	int rc = strtobool(buf, &write_cache);
-	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
-
-	WARN_ON_ONCE(!dax_dev);
-	if (!dax_dev)
-		return -ENXIO;
-
-	if (rc)
-		len = rc;
-	else
-		dax_write_cache(dax_dev, write_cache);
-
-	put_dax(dax_dev);
-	return len;
-}
-static DEVICE_ATTR_RW(write_cache);
-
-static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
-{
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
-	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
-
-	WARN_ON_ONCE(!dax_dev);
-	if (!dax_dev)
-		return 0;
-
-#ifndef CONFIG_ARCH_HAS_PMEM_API
-	if (a == &dev_attr_write_cache.attr)
-		return 0;
-#endif
-	return a->mode;
-}
-
-static struct attribute *dax_attributes[] = {
-	&dev_attr_write_cache.attr,
-	NULL,
-};
-
-struct attribute_group dax_attribute_group = {
-	.name = "dax",
-	.attrs = dax_attributes,
-	.is_visible = dax_visible,
-};
-EXPORT_SYMBOL_GPL(dax_attribute_group);
-
 /**
  * dax_direct_access() - translate a device pgoff to an absolute pfn
  * @dax_dev: a dax_device instance representing the logical memory range
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ef4950f808326..bbeb3f46db157 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -328,6 +328,49 @@ static const struct dax_operations pmem_dax_ops = {
 	.zero_page_range = pmem_dax_zero_page_range,
 };
 
+static ssize_t write_cache_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct pmem_device *pmem = dev_to_disk(dev)->private_data;
+
+	return sprintf(buf, "%d\n", !!dax_write_cache_enabled(pmem->dax_dev));
+}
+
+static ssize_t write_cache_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct pmem_device *pmem = dev_to_disk(dev)->private_data;
+	bool write_cache;
+	int rc;
+
+	rc = strtobool(buf, &write_cache);
+	if (rc)
+		return rc;
+	dax_write_cache(pmem->dax_dev, write_cache);
+	return len;
+}
+static DEVICE_ATTR_RW(write_cache);
+
+static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+#ifndef CONFIG_ARCH_HAS_PMEM_API
+	if (a == &dev_attr_write_cache.attr)
+		return 0;
+#endif
+	return a->mode;
+}
+
+static struct attribute *dax_attributes[] = {
+	&dev_attr_write_cache.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_attribute_group = {
+	.name		= "dax",
+	.attrs		= dax_attributes,
+	.is_visible	= dax_visible,
+};
+
 static const struct attribute_group *pmem_attribute_groups[] = {
 	&dax_attribute_group,
 	NULL,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 2619d94c308d4..8623caa673889 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -38,8 +38,6 @@ struct dax_operations {
 	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
 };
 
-extern struct attribute_group dax_attribute_group;
-
 #if IS_ENABLED(CONFIG_DAX)
 struct dax_device *alloc_dax(void *private, const char *host,
 		const struct dax_operations *ops, unsigned long flags);
-- 
2.30.2

