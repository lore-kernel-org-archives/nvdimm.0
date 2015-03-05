Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F84538.8080500@plexistor.com>
Date: Thu, 05 Mar 2015 13:59:52 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 7/8] pmem: Add support for page structs
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


One of the current shortcomings of the NVDIMM/PMEM
support is that this memory does not have a page-struct(s)
associated with its memory and therefor cannot be passed
to a block-device or network or DMAed in any way through
another device in the system.

The use of add_persistent_memory() fixes all this. After this patch
an FS can do:
	bdev_direct_access(,&pfn,);
	page = pfn_to_page(pfn);
And use that page for a lock_page(), set_page_dirty(), and/or
anything else one might do with a page *.
(Note that with brd one can already do this)

[pmem-pages-ref-count]
pmem will serve it's pages with ref==0. Once an FS does
an blkdev_get_XXX(,FMODE_EXCL,), that memory is own by the FS.
The FS needs to manage its allocation, just as it already does
for its disk blocks. The fs should set page->count = 2, before
submission to any Kernel subsystem so when it returns it will
never be released to the Kernel's page-allocators. (page_freeze)

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/Kconfig | 13 +++++++++++++
 drivers/block/pmem.c  | 20 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 1530c2a..635fa6a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -422,6 +422,19 @@ config BLK_DEV_PMEM
 	  Most normal users won't need this functionality, and can thus say N
 	  here.
 
+config BLK_DEV_PMEM_USE_PAGES
+	bool "Enable use of page struct pages with pmem"
+	depends on BLK_DEV_PMEM
+	depends on PERSISTENT_MEMORY_DEPENDENCY
+	select DRIVER_NEEDS_PERSISTENT_MEMORY
+	default y
+	help
+	  If a user of PMEM device needs "struct page" associated
+	  with its memory, so this memory can be sent to other
+	  block devices, or sent on the network, or be DMA transferred
+	  to other devices in the system, then you must say "Yes" here.
+	  If unsure leave as Yes.
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index f0f0ba0..d0c80f4 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -20,6 +20,7 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
+#include <linux/memory_hotplug.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
@@ -141,6 +142,24 @@ MODULE_PARM_DESC(map,
 
 static LIST_HEAD(pmem_devices);
 
+#ifdef CONFIG_BLK_DEV_PMEM_USE_PAGES
+/* pmem->phys_addr and pmem->size need to be set.
+ * Will then set pmem->virt_addr if successful.
+ */
+int pmem_mapmem(struct pmem_device *pmem)
+{
+	return add_persistent_memory(pmem->phys_addr, pmem->size,
+				     &pmem->virt_addr);
+}
+
+static void pmem_unmapmem(struct pmem_device *pmem)
+{
+	remove_persistent_memory(pmem->phys_addr, pmem->size);
+}
+
+#define PMEM_ALIGNMEM (1UL << SECTION_SIZE_BITS)
+#else /* !CONFIG_BLK_DEV_PMEM_USE_PAGES */
+
 /* pmem->phys_addr and pmem->size need to be set.
  * Will then set virt_addr if successful.
  */
@@ -180,6 +199,7 @@ void pmem_unmapmem(struct pmem_device *pmem)
 }
 
 #define PMEM_ALIGNMEM PAGE_SIZE
+#endif /* ! CONFIG_BLK_DEV_PMEM_USE_PAGES */
 
 static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
 				      int i)
-- 
1.9.3

