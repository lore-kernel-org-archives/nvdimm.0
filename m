Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 1/3] pmem: clarify a debug print in pmem_clear_poison
Date: Fri, 22 Jul 2016 17:21:31 -0600
Message-Id: <1469229693-17980-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1469229693-17980-1-git-send-email-vishal.l.verma@intel.com>
References: <1469229693-17980-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Prefix the sector number being cleared with a '0x' to make it clear that
this is a hex value.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 7251b4b..9f75eb8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -58,7 +58,7 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
 
 	if (cleared > 0 && cleared / 512) {
-		dev_dbg(dev, "%s: %llx clear %ld sector%s\n",
+		dev_dbg(dev, "%s: %#llx clear %ld sector%s\n",
 				__func__, (unsigned long long) sector,
 				cleared / 512, cleared / 512 > 1 ? "s" : "");
 		badblocks_clear(&pmem->bb, sector, cleared / 512);
-- 
2.7.4
