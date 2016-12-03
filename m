Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay104.isp.belgacom.be (mailrelay104.isp.belgacom.be
 [195.238.20.131])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A35381F98
 for <linux-nvdimm@lists.01.org>; Sat,  3 Dec 2016 10:53:57 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 2/3 libnvdimm-pending] libnvdimm,
 namespace: avoid multiple sector calculations
Date: Sat,  3 Dec 2016 19:53:53 +0100
Message-Id: <1480791233-21398-1-git-send-email-fabf@skynet.be>
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

Use sector_t for cleared

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: -applied on top of libnvdimm-pending

 drivers/nvdimm/pmem.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0f47062..9edad8b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -51,17 +51,16 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
 	struct device *dev = to_dev(pmem);
-	sector_t sector;
-	long cleared;
+	sector_t sector, cleared;
 
 	sector = (offset - pmem->data_offset) / 512;
-	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
+	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len) / 512;
 
-	if (cleared > 0 && cleared / 512) {
+	if (cleared) {
 		dev_dbg(dev, "%s: %#llx clear %ld sector%s\n",
 				__func__, (unsigned long long) sector,
-				cleared / 512, cleared / 512 > 1 ? "s" : "");
-		badblocks_clear(&pmem->bb, sector, cleared / 512);
+				cleared, cleared > 1 ? "s" : "");
+		badblocks_clear(&pmem->bb, sector, cleared);
 	} else {
 		return -EIO;
 	}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
