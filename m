Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B21DF81DE5
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 09:45:56 -0800 (PST)
Subject: [PATCH v2] libnvdimm: check and clear poison before writing to pmem
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 10 Nov 2016 10:45:36 -0700
Message-ID: <147879993593.130465.16954973899565924428.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We need to clear any poison when we are writing to pmem. The granularity
will be sector size. If it's less then we can't do anything about it
barring corruption.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/claim.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index d5dc80c..306d8fd 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -226,6 +226,11 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 		resource_size_t offset, void *buf, size_t size, int rw)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
+	sector_t sector = offset >> 9;
+
+	if (unlikely(!size))
+		return -EINVAL;
 
 	if (unlikely(offset + size > nsio->size)) {
 		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
@@ -233,12 +238,25 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	if (rw == READ) {
-		unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
-
-		if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
+		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
 		return memcpy_from_pmem(buf, nsio->addr + offset, size);
 	} else {
+
+		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
+			if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
+				long cleared;
+
+				cleared = nvdimm_clear_poison(&ndns->dev,
+							      offset, size);
+				if (cleared != size)
+					return -EIO;
+
+				badblocks_clear(&nsio->bb, sector,
+						cleared >> 9);
+			}
+		}
+
 		memcpy_to_pmem(nsio->addr + offset, buf, size);
 		nvdimm_flush(to_nd_region(ndns->dev.parent));
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
