Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <540F21E4.5070801@plexistor.com>
Date: Tue, 09 Sep 2014 18:51:00 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 9/9] pmem: KISS, remove register_blkdev
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com>
In-Reply-To: <540F1EC6.4000504@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Boaz Harrosh <boaz@plexistor.com>

Though this looks revolutionary, it actually does nothing
but removes dead code.

Since the move of pmem to the dynamic BLOCK_EXT_MAJOR
range, by Ross, pmem_major returned from register_blkdev
is not used.

If inspecting the code at add_disk() we can see that
whatever number we will put at
	disk->major		= ...
	disk->first_minor	= ...

will be immediately overwritten with the BLOCK_EXT_MAJOR
and a dynamically allocated minor. Regardless of the
registration and/or what ever we put at disk->major.

I have tested all the tests that I know how to perform
on the devices, fdisk, partitions, multiple pmemX devices,
mknode, lsblk, blkid, and it all behaves exactly as
before this patch.

I have also done:
	find /sys/ -name "*pmem*"
	find /proc/ -name "*pmem*"
	find /dev/ -name "*pmem*"
And get the same output as before this patch.

The only thing missing is an entry in /proc/devices of
the form: "250 pmem" (250 or what ever is free at the moment)

But this is good because if one tries to look for 250
devices after loading pmem he will fail because pmem
is always registered as 259 (blkext) now.

If anyone knows of what would work differently after this
patch please do tell.

But it looks like the calls to register_blkdev is just dead
code for us right now

Thanks

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/pmem.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 600d225..5eda95a 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -225,7 +225,6 @@ MODULE_PARM_DESC(map,
 	"mapS=nn[KMG]$ss[KMG] or mapS=nn[KMG]@ss[KMG], nn=size, ss=offset.");
 
 static LIST_HEAD(pmem_devices);
-static int pmem_major;
 
 #ifdef CONFIG_BLK_DEV_PMEM_USE_PAGES
 /* pmem->phys_addr and pmem->size need to be set.
@@ -333,8 +332,6 @@ static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
 		goto out_free_queue;
 	}
 
-	disk->major		= pmem_major;
-	disk->first_minor	= 0;
 	disk->fops		= &pmem_fops;
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
@@ -397,12 +394,6 @@ static int __init pmem_init(void)
 		return -EINVAL;
 	}
 
-	result = register_blkdev(0, "pmem");
-	if (result < 0)
-		return -EIO;
-	else
-		pmem_major = result;
-
 	i = 0;
 	while ((p = strsep(&pmem_map, ",")) != NULL) {
 		phys_addr_t phys_addr;
@@ -433,7 +424,6 @@ out_free:
 		list_del(&pmem->pmem_list);
 		pmem_free(pmem);
 	}
-	unregister_blkdev(pmem_major, "pmem");
 
 	return result;
 }
@@ -445,7 +435,6 @@ static void __exit pmem_exit(void)
 	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list)
 		pmem_del_one(pmem);
 
-	unregister_blkdev(pmem_major, "pmem");
 	pr_info("pmem: module unloaded\n");
 }
 
-- 
1.9.3

