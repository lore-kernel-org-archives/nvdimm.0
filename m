Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72CAE21CB02FF
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jul 2017 14:27:45 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 6/6] pmem, btt: fix potential deadlock while clearing errors
Date: Mon, 17 Jul 2017 15:27:39 -0600
Message-Id: <20170717212739.5411-7-vishal.l.verma@intel.com>
In-Reply-To: <20170717212739.5411-1-vishal.l.verma@intel.com>
References: <20170717212739.5411-1-vishal.l.verma@intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the ACPI NFIT 'DSM' methods, acpi can be called from IO paths.
Specifically, the DSM to clear media errors is called during writes, so
that we can provide a writes-fix-errors model.

However it is easy to imagine a scenario like:
 -> write through the nvdimm driver
   -> acpi allocation
     -> writeback, causes more IO through the nvdimm driver
       -> deadlock

Fix this by using memalloc_noio_{save,restore}, which sets the GFP_NOIO
flag for the current scope when issuing commands/IOs that are expected
to clear errors.

Cc: <linux-acpi@vger.kernel.org>
Cc: <linux-nvdimm@lists.01.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c  | 8 +++++++-
 drivers/nvdimm/pmem.c | 4 ++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 48382ca9..25b576d 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -11,6 +11,7 @@
  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  * more details.
  */
+#include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/blkdev.h>
@@ -494,17 +495,22 @@ static int arena_clear_freelist_error(struct arena_info *arena, u32 lane)
 	if (arena->freelist[lane].has_err) {
 		u32 lba = arena->freelist[lane].block;
 		u64 nsoff = to_namespace_offset(arena, lba);
+		unsigned int noio_flag;
 		void *zerobuf;
 
+		noio_flag = memalloc_noio_save();
 		zerobuf = kzalloc(arena->sector_size, GFP_KERNEL);
-		if (!zerobuf)
+		if (!zerobuf) {
+			memalloc_noio_restore(noio_flag);
 			return -ENOMEM;
+		}
 
 		mutex_lock(&arena->freelist[lane].err_lock);
 		ret = arena_write_bytes(arena, nsoff, zerobuf,
 			arena->sector_size, 0);
 		arena->freelist[lane].has_err = 0;
 		mutex_unlock(&arena->freelist[lane].err_lock);
+		memalloc_noio_restore(noio_flag);
 		kfree(zerobuf);
 	}
 	return ret;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5c45e17..468e032 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
+#include <linux/sched/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/blk-mq.h>
 #include <linux/pfn_t.h>
@@ -53,12 +54,14 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		unsigned int len)
 {
 	struct device *dev = to_dev(pmem);
+	unsigned int noio_flag;
 	sector_t sector;
 	long cleared;
 	int rc = 0;
 
 	sector = (offset - pmem->data_offset) / 512;
 
+	noio_flag = memalloc_noio_save();
 	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
 	if (cleared < len)
 		rc = -EIO;
@@ -69,6 +72,7 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 				cleared > 1 ? "s" : "");
 		badblocks_clear(&pmem->bb, sector, cleared);
 	}
+	memalloc_noio_restore(noio_flag);
 
 	invalidate_pmem(pmem->virt_addr + offset, len);
 
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
