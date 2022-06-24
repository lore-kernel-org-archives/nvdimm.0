Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E0023CA;
	Fri, 24 Jun 2022 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656044417; x=1687580417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fSlF2VXXQ0/DmGPCkefoOCnkko80YB8DFPEJHcVFEOI=;
  b=AgaEocOPAVDMc/zd6Bcqz/jkXQLANK+61JNFeYSmrDGu1SjWyfAWsZ6J
   4wwVkKw4f4FVsdrSup6wHqbPwJydVYJeAFLlgiIRsDrIEZZaM0QRrVq2H
   TnpIN1tBuTZckLqmeiB5Pp8rdTE/XA8LUhGaVJOOEwmkaoNJjU2bLG7s9
   ysvR/A+3gBGk4frdRPPmskcQlig7pl2WtyIRF6TXFJoLFH8PFHleyRfuC
   PIDhyzT3U5aIJdO9B5sQDMexEYMsO9bY5yQlOTG0umZ1sLsu9iucoB0h7
   76OFkh3gvOpiTnFPda5RmlxjGIWOGk5UacGdDAyy0cqvvmStT2rQxtGXg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="344912802"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="344912802"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="645092941"
Received: from daharell-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.intel.com) ([10.209.66.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 21:20:13 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org,
	patches@lists.linux.dev,
	hch@lst.de,
	Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Subject: [PATCH 37/46] cxl/region: Allocate host physical address (HPA) capacity to new regions
Date: Thu, 23 Jun 2022 21:19:41 -0700
Message-Id: <20220624041950.559155-12-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a region's interleave parameters (ways and granularity) are set,
add a way for regions to allocate HPA from the free capacity in their
decoder. The allocator for this capacity reuses the 'struct resource'
based allocator used for CONFIG_DEVICE_PRIVATE.

Once the tuple of "ways, granularity, and size" is set the
region configuration transitions to the CXL_CONFIG_INTERLEAVE_ACTIVE
state which is a precursor to allowing endpoint decoders to be added to
a region.

Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  25 ++++
 drivers/cxl/Kconfig                     |   3 +
 drivers/cxl/core/region.c               | 148 +++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |   2 +
 4 files changed, 177 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 46d5295c1149..3658facc9944 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -294,3 +294,28 @@ Description:
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
+		When written to, this attribute will allocate space out of the
+		CXL root decoder's address space. When read the size of the
+		address space is reported and should match the span of the
+		region's resource attribute. Size shall be set after the
+		interleave configuration parameters.
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
index 78af42454760..a604c24ff918 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -241,10 +241,150 @@ static ssize_t interleave_granularity_store(struct device *dev,
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
+	if (!p->interleave_ways || !p->interleave_granularity)
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
 
@@ -290,7 +430,11 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 
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
@@ -440,3 +584,5 @@ static ssize_t delete_region_store(struct device *dev,
 	return len;
 }
 DEVICE_ATTR_WO(delete_region);
+
+MODULE_IMPORT_NS(CXL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 13ee04b00e0c..25960c1e4ebd 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -334,6 +334,7 @@ enum cxl_config_state {
  * @uuid: unique id for persistent regions
  * @interleave_ways: number of endpoints in the region
  * @interleave_granularity: capacity each endpoint contributes to a stripe
+ * @res: allocated iomem capacity for this region
  *
  * State transitions are protected by the cxl_region_rwsem
  */
@@ -342,6 +343,7 @@ struct cxl_region_params {
 	uuid_t uuid;
 	int interleave_ways;
 	int interleave_granularity;
+	struct resource *res;
 };
 
 /**
-- 
2.36.1

