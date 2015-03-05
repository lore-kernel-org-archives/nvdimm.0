Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F8458E.2060202@plexistor.com>
Date: Thu, 05 Mar 2015 14:01:18 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 8/8] OUT-OF-TREE: pmem: Allow request_mem to fail (BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET)
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


With old Kernels there was a bug in x86 where any unknown
memory chip type would come up BUSY when calling
request_mem_region_exclusive().

So for pmem to work with old Kernels and real NvDIMM chips
we have a new Kconfig option CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET.

People have been running with hacked up pmem that will ignore
the return code from request_mem_region_exclusive. So here it is
official

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/Kconfig | 12 ++++++++++++
 drivers/block/pmem.c  |  9 ++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 635fa6a..58a2c69 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -435,6 +435,18 @@ config BLK_DEV_PMEM_USE_PAGES
 	  to other devices in the system, then you must say "Yes" here.
 	  If unsure leave as Yes.
 
+config BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET
+	bool "Ignore the return code from request_mem_region_exclusive"
+	depends on BLK_DEV_PMEM
+	help
+	  In Old Kernels type-12 Memory type which is used by NvDIMM
+	  chips Comes out busy when calling request_mem_region_exclusive,
+	  because of a bug.
+	  If this option is set to "yes". The pmem will ignore the
+	  failure, and continue as usual. If you have an old Kernel and
+	  a real NvDIMM chip you must say yes here.
+	  (Ignored if BLK_DEV_PMEM_USE_PAGES=y)
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index d0c80f4..ba1167c 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -172,8 +172,10 @@ int pmem_mapmem(struct pmem_device *pmem)
 					       "pmem");
 	if (unlikely(!res_mem)) {
 		pr_warn("pmem: request_mem_region_exclusive phys=0x%llx size=0x%zx failed\n",
-			   pmem->phys_addr, pmem->size);
-		return -EINVAL;
+			pmem->phys_addr, pmem->size);
+#ifndef CONFIG_BLK_DEV_PMEM_IGNORE_REQUEST_MEM_RET
+		return -EBUSY;
+#endif
 	}
 
 	pmem->virt_addr = ioremap_cache(pmem->phys_addr, pmem->size);
@@ -184,7 +186,8 @@ int pmem_mapmem(struct pmem_device *pmem)
 	return 0;
 
 out_release:
-	release_mem_region(pmem->phys_addr, pmem->size);
+	if (res_mem)
+		release_mem_region(pmem->phys_addr, pmem->size);
 	return err;
 }
 
-- 
1.9.3

