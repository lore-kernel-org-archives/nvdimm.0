Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F84445.9050208@plexistor.com>
Date: Thu, 05 Mar 2015 13:55:49 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 2/8] pmem: KISS, remove register_blkdev
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


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
index 02cd118..bba53af 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -113,7 +113,6 @@ MODULE_PARM_DESC(map,
 	"mapS=nn[KMG]$ss[KMG] or mapS=nn[KMG]@ss[KMG], nn=size, ss=offset.");
 
 static LIST_HEAD(pmem_devices);
-static int pmem_major;
 
 /* pmem->phys_addr and pmem->size need to be set.
  * Will then set virt_addr if successful.
@@ -204,8 +203,6 @@ static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
 		goto out_free_queue;
 	}
 
-	disk->major		= pmem_major;
-	disk->first_minor	= 0;
 	disk->fops		= &pmem_fops;
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
@@ -268,12 +265,6 @@ static int __init pmem_init(void)
 		return -EINVAL;
 	}
 
-	result = register_blkdev(0, "pmem");
-	if (unlikely(result < 0))
-		return -EIO;
-
-	pmem_major = result;
-
 	map_dup = pmem_map = kstrdup(map, GFP_KERNEL);
 	if (unlikely(!pmem_map)) {
 		pr_debug("pmem_init strdup(%s) failed\n", map);
@@ -312,7 +303,6 @@ out_free:
 		pmem_free(pmem);
 	}
 	kfree(map_dup);
-	unregister_blkdev(pmem_major, "pmem");
 
 	return result;
 }
@@ -324,7 +314,6 @@ static void __exit pmem_exit(void)
 	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list)
 		pmem_del_one(pmem);
 
-	unregister_blkdev(pmem_major, "pmem");
 	pr_info("pmem: module unloaded\n");
 }
 
-- 
1.9.3

