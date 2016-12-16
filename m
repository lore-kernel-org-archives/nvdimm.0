Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40DA681C4E
 for <linux-nvdimm@lists.01.org>; Fri, 16 Dec 2016 14:10:53 -0800 (PST)
Subject: [PATCH] libnvdimm: fix mishandled nvdimm_clear_poison() return value
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Dec 2016 14:06:44 -0800
Message-ID: <148192600397.40331.16038852518288391005.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Fabian Frederick <fabf@skynet.be>, Colin Ian King <colin.king@canonical.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Colin, via static analysis, reports that the length could be negative
from nvdimm_clear_poison() in the error case. There was a similar
problem with commit 0a3f27b9a6a8 "libnvdimm, namespace: avoid multiple
sector calculations" that I noticed when merging the for-4.10/libnvdimm
topic branch into libnvdimm-for-next, but I missed this one. Fix both of
them to the following procedure:

* if we clear a block's worth of media, clear that many blocks in
  badblocks

* if we clear less than the requested size of the transfer return an
  error

* always invalidate cache after any non-error / non-zero
  nvdimm_clear_poison result

Fixes: 82bf1037f2ca ("libnvdimm: check and clear poison before writing to pmem")
Fixes: 0a3f27b9a6a8 ("libnvdimm, namespace: avoid multiple sector calculations")
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Dave Jiang <dave.jiang@intel.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/claim.c |    9 +++++----
 drivers/nvdimm/pmem.c  |   21 ++++++++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 97d1772774a8..b3323c0697f6 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -247,12 +247,13 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 			long cleared;
 
 			cleared = nvdimm_clear_poison(&ndns->dev, offset, size);
-			if (cleared != size) {
-				size = cleared;
+			if (cleared < size)
 				rc = -EIO;
+			if (cleared > 0 && cleared / 512) {
+				cleared /= 512;
+				badblocks_clear(&nsio->bb, sector, cleared);
 			}
-
-			badblocks_clear(&nsio->bb, sector, cleared >> 9);
+			invalidate_pmem(nsio->addr + offset, size);
 		} else
 			rc = -EIO;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index bcc359a4e64d..ecf79fd64517 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -47,22 +47,29 @@ static struct nd_region *to_region(struct pmem_device *pmem)
 	return to_nd_region(to_dev(pmem)->parent);
 }
 
-static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
+static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
 	struct device *dev = to_dev(pmem);
-	sector_t sector, cleared;
+	sector_t sector;
+	long cleared;
+	int rc = 0;
 
 	sector = (offset - pmem->data_offset) / 512;
-	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len) / 512;
 
-	if (cleared) {
-		dev_dbg(dev, "%s: %#llx clear %ld sector%s\n",
-				__func__, (unsigned long long) sector,
-				cleared, cleared > 1 ? "s" : "");
+	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
+	if (cleared < len)
+		rc = -EIO;
+	if (cleared > 0 && cleared / 512) {
+		cleared /= 512;
+		dev_dbg(dev, "%s: %#llx clear %ld sector%s\n", __func__,
+				(unsigned long long) sector, cleared,
+				cleared > 1 ? "s" : "");
 		badblocks_clear(&pmem->bb, sector, cleared);
 	}
 	invalidate_pmem(pmem->virt_addr + offset, len);
+
+	return rc;
 }
 
 static void write_pmem(void *pmem_addr, struct page *page,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
