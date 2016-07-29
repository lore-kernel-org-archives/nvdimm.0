Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 99AC21A1E20
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 13:59:21 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] libnvdimm, nd_blk: mask off reserved status bits
Date: Fri, 29 Jul 2016 14:59:12 -0600
Message-Id: <20160729205912.20436-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, stable@vger.kernel.org, linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

The "NVDIMM Block Window Driver Writer's Guide":

http://pmem.io/documents/
http://pmem.io/documents/NVDIMM_DriverWritersGuide-July-2016.pdf

defines the layout of the block window status register.  For the July 2016
version of the spec linked to above, this happens in Figure 4 on page 26.

The only bits defined in this spec are bits 31, 5, 4, 2, 1 and 0.  The rest
of the bits in the status register are reserved, and there is a warning
following the diagram that says:

  Note: The driver cannot assume the value of the RESERVED bits in the
  status register are zero. These reserved bits need to be masked off, and
  the driver must avoid checking the state of those bits.

This change ensures that for hardware implementations that set these
reserved bits in the status register, the driver won't incorrectly fail the
block I/Os.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/acpi/nfit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 1f0e060..375c10f 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1396,11 +1396,12 @@ static u32 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 {
 	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
 	u64 offset = nfit_blk->stat_offset + mmio->size * bw;
+	const u32 STATUS_MASK = 0x80000037;
 
 	if (mmio->num_lines)
 		offset = to_interleave_offset(offset, mmio);
 
-	return readl(mmio->addr.base + offset);
+	return readl(mmio->addr.base + offset) & STATUS_MASK;
 }
 
 static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
