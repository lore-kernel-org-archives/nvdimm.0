Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE15F7460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843444; x=1689379444;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RcqA2cHy2KOsfTBn7OfvgHq5dSs6tJXyHh0qNEkK6Fg=;
  b=i3xRtXFehUvfw3+oRUihAkNusRIzFkKRnnIE4riPbW1BwB7bikCH0gAp
   UF9EE8YmtOXAxQM7S0iKFcAQQtfYUf7mCHWr8yy+pCfi0Yd+eSGTJCu7l
   7GSE01LT9DpW6YsfqSuZQC8nveEpPCD2TdEMQx5J1Uxge5DypSbUUPkzE
   h6GbVmqCLKz5xfyU2Wo5ov/7RFKpPLkHf4smf3c+Gj+iYHBIoVwreg2YL
   2r2ONeeXOBK/pUDi+vx2GtgcWehQTBkoxQ0y5W/4RFXK4QtukGrmvjA5M
   IaMi24Anpq0Xskqo9+K8xXn6ld+U23kkzYj0TOy2v8q/CFg3BXuwNPKq/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="265451077"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="265451077"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="772801623"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:36 -0700
Subject: [PATCH v2 20/28] cxl/region: Allocate HPA capacity to regions
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <bwidawsk@kernel.org>, hch@lst.de, nvdimm@lists.linux.dev,
 linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:02:36 -0700
Message-ID: <165784335630.1758207.420216490941955417.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

After a region's interleave parameters (ways and granularity) are set,
add a way for regions to allocate HPA (host physical address space) from
the free capacity in their parent root-decoder. The allocator for this
capacity reuses the 'struct resource' based allocator used for
CONFIG_DEVICE_PRIVATE.

Once the tuple of "ways, granularity, and size" is set the
region configuration transitions to the CXL_CONFIG_INTERLEAVE_ACTIVE
state which is a precursor to allowing endpoint decoders to be added to
a region.

Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |   29 ++++++
 drivers/cxl/Kconfig                     |    3 +
 drivers/cxl/core/region.c               |  150 +++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h                       |    2 
 4 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index bfa42bcc8383..0c6c3da4da5a 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -313,3 +313,32 @@ Description:
 		(RW) Configures the number of devices participating in the
 		region is set by writing this value. Each device will provide
 		1/interleave_ways of storage for the region.
+
+
+What:		/sys/bus/cxl/devices/regionZ/size
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) System physical address space to be consumed by the region.
+		When written trigger the driver to allocate space out of the
+		parent root decoder's address space. When read the size of the
+		address space is reported and should match the span of the
+		region's resource attribute. Size shall be set after the
+		interleave configuration parameters. Once set it cannot be
+		changed, only freed by writing 0. The kernel makes no guarantees
+		that data is maintained over an address space freeing event, and
+		there is no guarantee that a free followed by an allocate
+		results in the same address being allocated.
+
+
+What:		/sys/bus/cxl/devices/regionZ/resource
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) A region is a contiguous partition of a CXL root decoder
+		address space. Region capacity is allocated by writing to the
+		size attribute, the resulting physical address space determined
+		by the driver is reflected here. It is therefore not useful to
+		read this before writing a value to the size attribute.
diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index aa2728de419e..74c2cd069d9d 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -105,6 +105,9 @@ config CXL_SUSPEND
 config CXL_REGION
 	bool
 	default CXL_BUS
+	# For MAX_PHYSMEM_BITS
+	depends on SPARSEMEM
 	select MEMREGION
+	select GET_FREE_REGION
 
 endif
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 3289caa5d882..b1e847827c6b 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -244,10 +244,152 @@ static ssize_t interleave_granularity_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(interleave_granularity);
 
+static ssize_t resource_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	u64 resource = -1ULL;
+	ssize_t rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	if (p->res)
+		resource = p->res->start;
+	rc = sysfs_emit(buf, "%#llx\n", resource);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(resource);
+
+static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
+	struct cxl_region_params *p = &cxlr->params;
+	struct resource *res;
+	u32 remainder = 0;
+
+	lockdep_assert_held_write(&cxl_region_rwsem);
+
+	/* Nothing to do... */
+	if (p->res && resource_size(res) == size)
+		return 0;
+
+	/* To change size the old size must be freed first */
+	if (p->res)
+		return -EBUSY;
+
+	if (p->state >= CXL_CONFIG_INTERLEAVE_ACTIVE)
+		return -EBUSY;
+
+	/* ways, granularity and uuid (if PMEM) need to be set before HPA */
+	if (!p->interleave_ways || !p->interleave_granularity ||
+	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
+		return -ENXIO;
+
+	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
+	if (remainder)
+		return -EINVAL;
+
+	res = alloc_free_mem_region(cxlrd->res, size, SZ_256M,
+				    dev_name(&cxlr->dev));
+	if (IS_ERR(res)) {
+		dev_dbg(&cxlr->dev, "failed to allocate HPA: %ld\n",
+			PTR_ERR(res));
+		return PTR_ERR(res);
+	}
+
+	p->res = res;
+	p->state = CXL_CONFIG_INTERLEAVE_ACTIVE;
+
+	return 0;
+}
+
+static void cxl_region_iomem_release(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+
+	if (device_is_registered(&cxlr->dev))
+		lockdep_assert_held_write(&cxl_region_rwsem);
+	if (p->res) {
+		remove_resource(p->res);
+		kfree(p->res);
+		p->res = NULL;
+	}
+}
+
+static int free_hpa(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+
+	lockdep_assert_held_write(&cxl_region_rwsem);
+
+	if (!p->res)
+		return 0;
+
+	if (p->state >= CXL_CONFIG_ACTIVE)
+		return -EBUSY;
+
+	cxl_region_iomem_release(cxlr);
+	p->state = CXL_CONFIG_IDLE;
+	return 0;
+}
+
+static ssize_t size_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	u64 val;
+	int rc;
+
+	rc = kstrtou64(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	rc = down_write_killable(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+
+	if (val)
+		rc = alloc_hpa(cxlr, val);
+	else
+		rc = free_hpa(cxlr);
+	up_write(&cxl_region_rwsem);
+
+	if (rc)
+		return rc;
+
+	return len;
+}
+
+static ssize_t size_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	u64 size = 0;
+	ssize_t rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc)
+		return rc;
+	if (p->res)
+		size = resource_size(p->res);
+	rc = sysfs_emit(buf, "%#llx\n", size);
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(size);
+
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
 	&dev_attr_interleave_ways.attr,
 	&dev_attr_interleave_granularity.attr,
+	&dev_attr_resource.attr,
+	&dev_attr_size.attr,
 	NULL,
 };
 
@@ -293,7 +435,11 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 
 static void unregister_region(void *dev)
 {
-	device_unregister(dev);
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	device_del(dev);
+	cxl_region_iomem_release(cxlr);
+	put_device(dev);
 }
 
 static struct lock_class_key cxl_region_key;
@@ -445,3 +591,5 @@ static ssize_t delete_region_store(struct device *dev,
 	return len;
 }
 DEVICE_ATTR_WO(delete_region);
+
+MODULE_IMPORT_NS(CXL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index a4e65c102bed..837bfa67f469 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -341,6 +341,7 @@ enum cxl_config_state {
  * @uuid: unique id for persistent regions
  * @interleave_ways: number of endpoints in the region
  * @interleave_granularity: capacity each endpoint contributes to a stripe
+ * @res: allocated iomem capacity for this region
  *
  * State transitions are protected by the cxl_region_rwsem
  */
@@ -349,6 +350,7 @@ struct cxl_region_params {
 	uuid_t uuid;
 	int interleave_ways;
 	int interleave_granularity;
+	struct resource *res;
 };
 
 /**

