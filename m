Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 6CE261A1E4A
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jul 2016 18:52:29 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 1/3] pmem: clarify a debug print in pmem_clear_poison
Date: Wed, 20 Jul 2016 19:50:48 -0600
Message-Id: <1469065850-32401-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1469065850-32401-1-git-send-email-vishal.l.verma@intel.com>
References: <1469065850-32401-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prefix the sector number being cleared with a '0x' to make it clear that
this is a hex value.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc44..08ac2cb 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -57,7 +57,7 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
 
 	if (cleared > 0 && cleared / 512) {
-		dev_dbg(dev, "%s: %llx clear %ld sector%s\n",
+		dev_dbg(dev, "%s: %#llx clear %ld sector%s\n",
 				__func__, (unsigned long long) sector,
 				cleared / 512, cleared / 512 > 1 ? "s" : "");
 		badblocks_clear(&pmem->bb, sector, cleared / 512);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
