Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <540F2077.5000809@plexistor.com>
Date: Tue, 09 Sep 2014 18:44:55 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 4/9] SQUASHME: pmem: Support of multiple memory regions
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

After the last patch this is easy.

The API to pmem module is changed. We now have a single string
parameter named "map" of the form:
		 map=mapS[,mapS...]

		 where mapS=nn[KMG]$ss[KMG],
		 or    mapS=nn[KMG]@ss[KMG],

		 nn=size, ss=offset

Just like the Kernel command line map && memmap parameters,
so anything you did at grub just copy/paste to here.

The "@" form is exactly the same as the "$" form only that
at bash prompt we need to escape the "$" with \$ so also
support the '@' char for convenience.

For each specified mapS there will be a device created.

So needless to say that all the previous prd_XXX params are
removed as well as the Kconfig defaults.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/Kconfig | 28 -----------------------
 drivers/block/pmem.c  | 62 ++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 2d50125..5da8cbf 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -416,34 +416,6 @@ config BLK_DEV_PMEM
 	  Most normal users won't need this functionality, and can thus say N
 	  here.
 
-config BLK_DEV_PMEM_START
-	int "Offset in GiB of where to start claiming space"
-	default "0"
-	depends on BLK_DEV_PMEM
-	help
-	  Starting offset in GiB that PMEM should use when claiming memory.  This
-	  memory needs to be reserved from the OS at boot time using the
-	  "memmap" kernel parameter.
-
-	  If you provide PMEM with volatile memory it will act as a volatile
-	  RAM disk and your data will not be persistent.
-
-config BLK_DEV_PMEM_COUNT
-	int "Default number of PMEM disks"
-	default "4"
-	depends on BLK_DEV_PMEM
-	help
-	  Number of equal sized block devices that PMEM should create.
-
-config BLK_DEV_PMEM_SIZE
-	int "Size in GiB of space to claim"
-	depends on BLK_DEV_PMEM
-	default "0"
-	help
-	  Amount of memory in GiB that PMEM should use when creating block
-	  devices.  This memory needs to be reserved from the OS at
-	  boot time using the "memmap" kernel parameter.
-
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index d5c5c52..e07a373 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -212,17 +212,11 @@ static const struct block_device_operations pmem_fops = {
 };
 
 /* Kernel module stuff */
-static int pmem_start_gb = CONFIG_BLK_DEV_PMEM_START;
-module_param(pmem_start_gb, int, S_IRUGO);
-MODULE_PARM_DESC(pmem_start_gb, "Offset in GB of where to start claiming space");
-
-static int pmem_size_gb = CONFIG_BLK_DEV_PMEM_SIZE;
-module_param(pmem_size_gb,  int, S_IRUGO);
-MODULE_PARM_DESC(pmem_size_gb,  "Total size in GB of space to claim for all disks");
-
-static int pmem_count = CONFIG_BLK_DEV_PMEM_COUNT;
-module_param(pmem_count, int, S_IRUGO);
-MODULE_PARM_DESC(pmem_count, "Number of pmem devices to evenly split allocated space");
+static char *map;
+module_param(map, charp, S_IRUGO);
+MODULE_PARM_DESC(map,
+	"pmem device mapping: map=mapS[,mapS...] where:\n"
+	"mapS=nn[KMG]$ss[KMG] or mapS=nn[KMG]@ss[KMG], nn=size, ss=offset.");
 
 static LIST_HEAD(pmem_devices);
 static int pmem_major;
@@ -272,6 +266,13 @@ static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
 	struct gendisk *disk;
 	int err;
 
+	if (unlikely((phys_addr & ~PAGE_MASK) || (disk_size & ~PAGE_MASK))) {
+		pr_err("phys_addr=0x%llx disk_size=0x%zx must be 4k aligned\n",
+		       phys_addr, disk_size);
+		err = -EINVAL;
+		goto out;
+	}
+
 	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
 	if (unlikely(!pmem)) {
 		err = -ENOMEM;
@@ -344,16 +345,32 @@ static void pmem_del_one(struct pmem_device *pmem)
 	pmem_free(pmem);
 }
 
+static int pmem_parse_map_one(char *map, phys_addr_t *start, size_t *size)
+{
+	char *p = map;
+
+	*size = (size_t)memparse(p, &p);
+	if ((p == map) || ((*p != '$') && (*p != '@')))
+		return -EINVAL;
+
+	if (!*(++p))
+		return -EINVAL;
+
+	*start = (phys_addr_t)memparse(p, &p);
+
+	return *p == '\0' ? 0 : -EINVAL;
+}
+
 static int __init pmem_init(void)
 {
 	int result, i;
 	struct pmem_device *pmem, *next;
-	phys_addr_t phys_addr;
-	size_t total_size, disk_size;
+	char *p, *pmem_map = map;
 
-	phys_addr  = (phys_addr_t) pmem_start_gb * 1024 * 1024 * 1024;
-	total_size = (size_t)	   pmem_size_gb  * 1024 * 1024 * 1024;
-	disk_size = total_size / pmem_count;
+	if (!pmem_map) {
+		pr_err("pmem: must specify map=nn@ss parameter.\n");
+		return -EINVAL;
+	}
 
 	result = register_blkdev(0, "pmem");
 	if (result < 0)
@@ -361,14 +378,23 @@ static int __init pmem_init(void)
 	else
 		pmem_major = result;
 
-	for (i = 0; i < pmem_count; i++) {
+	i = 0;
+	while ((p = strsep(&pmem_map, ",")) != NULL) {
+		phys_addr_t phys_addr;
+		size_t disk_size;
+
+		if (!*p)
+			continue;
+		result = pmem_parse_map_one(p, &phys_addr, &disk_size);
+		if (result)
+			goto out_free;
 		pmem = pmem_alloc(phys_addr, disk_size, i);
 		if (IS_ERR(pmem)) {
 			result = PTR_ERR(pmem);
 			goto out_free;
 		}
 		list_add_tail(&pmem->pmem_list, &pmem_devices);
-		phys_addr += disk_size;
+		++i;
 	}
 
 	list_for_each_entry(pmem, &pmem_devices, pmem_list)
-- 
1.9.3


