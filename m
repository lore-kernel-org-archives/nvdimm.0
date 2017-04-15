Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E36C2194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:40:48 -0700 (PDT)
Subject: [PATCH v2 22/33] dax,
 pmem: introduce an optional 'flush' dax_operation
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:35:04 -0700
Message-ID: <149222370431.32363.14712321407388916940.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Filesystem-DAX flushes caches whenever it writes to the address returned
through dax_direct_access() and when writing back dirty radix entries.
That flushing is only required in the pmem case, so add a dax operation
to allow pmem to take this extra action, but skip it for other dax
capable devices that do not provide a flush routine.

An example for this differentiation might be a volatile ram disk where
there is no expectation of persistence. In fact the pmem driver itself might
front such an address range specified by the NFIT. So, this "no flush"
property might be something passed down by the bus / libnvdimm.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   11 +++++++++++
 include/linux/dax.h   |    2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e501df4ab4b4..822b85fb3365 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -276,9 +276,20 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
 }
 
+static void pmem_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t size)
+{
+	/*
+	 * TODO: move arch specific cache management into the driver
+	 * directly.
+	 */
+	wb_cache_pmem(addr, size);
+}
+
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
 	.copy_from_iter = pmem_copy_from_iter,
+	.flush = pmem_dax_flush,
 };
 
 static void pmem_release_queue(void *q)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index cd8561bb21f3..c88bbcba26d9 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -19,6 +19,8 @@ struct dax_operations {
 	/* copy_from_iter: dax-driver override for default copy_from_iter */
 	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
 			struct iov_iter *);
+	/* flush: optional driver-specific cache management after writes */
+	void (*flush)(struct dax_device *, pgoff_t, void *, size_t);
 };
 
 int dax_read_lock(void);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
