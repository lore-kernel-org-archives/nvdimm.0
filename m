Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0684C81F5C
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:21:01 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 4/8 linux-next] libnvdimm,
 namespace: avoid multiple sector calculations
Date: Fri,  2 Dec 2016 20:20:56 +0100
Message-Id: <1480706456-21111-1-git-send-email-fabf@skynet.be>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

add cleared_sectors variable to add more readability.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/nvdimm/pmem.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 204912c..4da4735 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -52,16 +52,16 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 {
 	struct device *dev = to_dev(pmem);
 	sector_t sector;
-	long cleared;
+	long cleared, cleared_sectors;
 
 	sector = (offset - pmem->data_offset) / 512;
 	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
-
-	if (cleared > 0 && cleared / 512) {
+	cleared_sectors = cleared / 512;
+	if (cleared > 0 && cleared_sectors) {
 		dev_dbg(dev, "%s: %#llx clear %ld sector%s\n",
-				__func__, (unsigned long long) sector,
-				cleared / 512, cleared / 512 > 1 ? "s" : "");
-		badblocks_clear(&pmem->bb, sector, cleared / 512);
+			     __func__, (unsigned long long) sector,
+			     cleared_sectors, cleared_sectors > 1 ? "s" : "");
+		badblocks_clear(&pmem->bb, sector, cleared_sectors);
 	} else {
 		return -EIO;
 	}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
