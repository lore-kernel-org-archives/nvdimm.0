Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] nfit, nd_blk: BLK status register is only 32 bits
Date: Thu, 20 Aug 2015 16:27:38 -0600
Message-Id: <1440109658-29164-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Only read 32 bits for the BLK status register in read_blk_stat().

The format and size of this register is defined in the
"NVDIMM Driver Writer's guide":

http://pmem.io/documents/NVDIMM_Driver_Writers_Guide.pdf

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
---
 drivers/acpi/nfit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 7c2638f..8689ee1 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1009,7 +1009,7 @@ static void wmb_blk(struct nfit_blk *nfit_blk)
 		wmb_pmem();
 }
 
-static u64 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
+static u32 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 {
 	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
 	u64 offset = nfit_blk->stat_offset + mmio->size * bw;
@@ -1017,7 +1017,7 @@ static u64 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 	if (mmio->num_lines)
 		offset = to_interleave_offset(offset, mmio);
 
-	return readq(mmio->base + offset);
+	return readl(mmio->base + offset);
 }
 
 static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
-- 
2.1.0

