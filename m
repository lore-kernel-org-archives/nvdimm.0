Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E14B021A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 10:25:43 -0700 (PDT)
Subject: [PATCH] libnvdimm: restore "libnvdimm: band aid btt vs clear poison
 locking"
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 May 2017 10:19:48 -0700
Message-ID: <149365918855.23471.2493940794453999099.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This continues the 4.11 status quo of disabling of error clearing from
the BTT I/O path. Toshi found that even though we have eliminated all
the libnvdimm sources of sleeping-while-atomic triggers, we still have
sleeping operations that will occur in the path to send the ACPI DSM to
the DIMM to clear the error:

 BUG: sleeping function called from invalid context at mm/slab.h:432
 in_atomic(): 1, irqs_disabled(): 0, pid: 13353, name: dd
 Call Trace:
  dump_stack+0x86/0xc3
  ___might_sleep+0x17d/0x250
  __might_sleep+0x4a/0x80
  __kmalloc+0x1c0/0x2e0
  acpi_os_allocate_zeroed+0x2d/0x2f
  acpi_evaluate_object+0x59/0x3b1
  acpi_evaluate_dsm+0xbd/0x10c
  acpi_nfit_ctl+0x1ef/0x7c0 [nfit]
  ? nsio_rw_bytes+0x152/0x280
  nvdimm_clear_poison+0x77/0x140
  nsio_rw_bytes+0x18f/0x280
  btt_write_pg+0x1d4/0x3d0 [nd_btt]
  btt_make_request+0x119/0x2d0 [nd_btt]

A solution for tracking and handling media errors natively in the BTT is
needed.

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/claim.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 35b210dc1e56..6945e35058bf 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -250,7 +250,16 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
-		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
+		/*
+		 * FIXME: nsio_rw_bytes() may be called from atomic
+		 * context in the btt case and the ACPI DSM path for
+		 * clearing the error takes sleeping locks and allocates
+		 * memory. An explicit error clearing path, and support
+		 * for tracking badblocks in BTT metadata is needed to
+		 * work around this collision.
+		 */
+		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
+				&& (!ndns->claim || !is_nd_btt(ndns->claim))) {
 			long cleared;
 
 			cleared = nvdimm_clear_poison(&ndns->dev,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
