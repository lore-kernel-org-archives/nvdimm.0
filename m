Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 350D01A1E24
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jul 2016 17:46:26 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 1/3] pmem: clarify a debug print in pmem_clear_poison
Date: Mon, 18 Jul 2016 18:44:58 -0600
Message-Id: <1468889100-30698-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Prefix the sector number being cleared with a '0x' to make it clear that
this is a hex value.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc44..29ab25b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -57,7 +57,7 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
 
 	if (cleared > 0 && cleared / 512) {
-		dev_dbg(dev, "%s: %llx clear %ld sector%s\n",
+		dev_dbg(dev, "%s: 0x%llx clear %ld sector%s\n",
 				__func__, (unsigned long long) sector,
 				cleared / 512, cleared / 512 > 1 ? "s" : "");
 		badblocks_clear(&pmem->bb, sector, cleared / 512);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
