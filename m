Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 731AE21E78212
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 07:52:34 -0700 (PDT)
Subject: [PATCH v8 07/14] iommu, dma-mapping: introduce dma_get_iommu_domain()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 07:49:37 -0700
Message-ID: <150764697773.16882.5489456954873798235.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a dma-mapping api helper to retrieve the generic iommu_domain for a
device.  The motivation for this interface is making RDMA transfers to
DAX mappings safe. If the DAX file's block map changes we need to be to
reliably stop accesses to blocks that have been freed or re-assigned to
a new file. With the iommu_domain and a callback from the DAX filesystem
the kernel can safely revoke access to a DMA device. The process that
performed the RDMA memory registration is also notified of this
revocation event, but the kernel can not otherwise be in the position of
waiting for userspace to quiesce the device.

Since PMEM+DAX is currently only enabled for x86, we only update the x86
iommu drivers.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/dma-mapping.c  |   10 ++++++++++
 drivers/iommu/amd_iommu.c   |   10 ++++++++++
 drivers/iommu/intel-iommu.c |   15 +++++++++++++++
 include/linux/dma-mapping.h |    3 +++
 4 files changed, 38 insertions(+)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index e584eddef0a7..fdb9764f95a4 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -369,3 +369,13 @@ void dma_deconfigure(struct device *dev)
 	of_dma_deconfigure(dev);
 	acpi_dma_deconfigure(dev);
 }
+
+struct iommu_domain *dma_get_iommu_domain(struct device *dev)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (ops && ops->get_iommu)
+		return ops->get_iommu(dev);
+	return NULL;
+}
+EXPORT_SYMBOL(dma_get_iommu_domain);
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 51f8215877f5..c8e1a45af182 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2271,6 +2271,15 @@ static struct protection_domain *get_domain(struct device *dev)
 	return domain;
 }
 
+static struct iommu_domain *amd_dma_get_iommu(struct device *dev)
+{
+	struct protection_domain *domain = get_domain(dev);
+
+	if (IS_ERR(domain))
+		return NULL;
+	return &domain->domain;
+}
+
 static void update_device_table(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
@@ -2689,6 +2698,7 @@ static const struct dma_map_ops amd_iommu_dma_ops = {
 	.unmap_sg	= unmap_sg,
 	.dma_supported	= amd_iommu_dma_supported,
 	.mapping_error	= amd_iommu_mapping_error,
+	.get_iommu	= amd_dma_get_iommu,
 };
 
 static int init_reserved_iova_ranges(void)
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 6784a05dd6b2..f3f4939cebad 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3578,6 +3578,20 @@ static int iommu_no_mapping(struct device *dev)
 	return 0;
 }
 
+static struct iommu_domain *intel_dma_get_iommu(struct device *dev)
+{
+	struct dmar_domain *domain;
+
+	if (iommu_no_mapping(dev))
+		return NULL;
+
+	domain = get_valid_domain_for_dev(dev);
+	if (!domain)
+		return NULL;
+
+	return &domain->domain;
+}
+
 static dma_addr_t __intel_map_single(struct device *dev, phys_addr_t paddr,
 				     size_t size, int dir, u64 dma_mask)
 {
@@ -3872,6 +3886,7 @@ const struct dma_map_ops intel_dma_ops = {
 	.map_page = intel_map_page,
 	.unmap_page = intel_unmap_page,
 	.mapping_error = intel_mapping_error,
+	.get_iommu = intel_dma_get_iommu,
 #ifdef CONFIG_X86
 	.dma_supported = x86_dma_supported,
 #endif
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29ce9815da87..aa62df1d0d72 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -128,6 +128,7 @@ struct dma_map_ops {
 				   enum dma_data_direction dir);
 	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
 	int (*dma_supported)(struct device *dev, u64 mask);
+	struct iommu_domain *(*get_iommu)(struct device *dev);
 #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
 	u64 (*get_required_mask)(struct device *dev);
 #endif
@@ -221,6 +222,8 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 }
 #endif
 
+extern struct iommu_domain *dma_get_iommu_domain(struct device *dev);
+
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      size_t size,
 					      enum dma_data_direction dir,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
