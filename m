Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DADE421939234
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 16:16:42 -0700 (PDT)
Subject: [PATCH v2] libnvdimm: fix btt vs clear poison locking
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Apr 2017 16:10:58 -0700
Message-ID: <149195214773.14530.8851419580700446789.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The following warning results from holding a lane spinlock,
preempt_disable(), or the btt map spinlock and then trying to take the
reconfig_mutex to walk the poison list and potentially add new entries.

 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:747
 in_atomic(): 1, irqs_disabled(): 0, pid: 17159, name: dd
 [..]
 Call Trace:
  dump_stack+0x85/0xc8
  ___might_sleep+0x184/0x250
  __might_sleep+0x4a/0x90
  __mutex_lock+0x58/0x9b0
  ? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
  ? __nvdimm_bus_badblocks_clear+0x2f/0x60 [libnvdimm]
  ? acpi_nfit_forget_poison+0x79/0x80 [nfit]
  ? _raw_spin_unlock+0x27/0x40
  mutex_lock_nested+0x1b/0x20
  nvdimm_bus_lock+0x21/0x30 [libnvdimm]
  nvdimm_forget_poison+0x25/0x50 [libnvdimm]
  nvdimm_clear_poison+0x106/0x140 [libnvdimm]
  nsio_rw_bytes+0x164/0x270 [libnvdimm]
  btt_write_pg+0x1de/0x3e0 [nd_btt]
  ? blk_queue_enter+0x30/0x290
  btt_make_request+0x11a/0x310 [nd_btt]
  ? blk_queue_enter+0xb7/0x290
  ? blk_queue_enter+0x30/0x290
  generic_make_request+0x118/0x3b0

As a minimal fix, disable error clearing when the BTT is enabled for the
namespace. For the final fix a larger rework of the poison list locking
is needed.

Note that this is not a problem in the blk case since that path never
calls nvdimm_clear_poison().

Cc: <stable@vger.kernel.org>
Fixes: 82bf1037f2ca ("libnvdimm: check and clear poison before writing to pmem")
Cc: Dave Jiang <dave.jiang@intel.com>
[jeff: dynamically disable error clearing in the btt case]
Suggested-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
v2: check for btt at run time rather than compile time (Jeff)

 drivers/nvdimm/claim.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index b3323c0697f6..ca6d572c48fc 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -243,7 +243,15 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
-		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
+		/*
+		 * FIXME: nsio_rw_bytes() may be called from atomic
+		 * context in the btt case and nvdimm_clear_poison()
+		 * takes a sleeping lock. Until the locking can be
+		 * reworked this capability requires that the namespace
+		 * is not claimed by btt.
+		 */
+		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
+				&& (!ndns->claim || !is_nd_btt(ndns->claim))) {
 			long cleared;
 
 			cleared = nvdimm_clear_poison(&ndns->dev, offset, size);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
