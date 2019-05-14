Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [RFC PATCH] mm/nvdimm: Fix kernel crash on devm_mremap_pages_release
Date: Tue, 14 May 2019 08:23:54 +0530
Message-Id: <20190514025354.9108-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

When we initialize the namespace, if we support altmap, we don't initialize all the
backing struct page where as while releasing the namespace we look at some of
these uninitilized struct page. This results in a kernel crash as below.

kernel BUG at include/linux/mm.h:1034!
cpu 0x2: Vector: 700 (Program Check) at [c00000024146b870]
    pc: c0000000003788f8: devm_memremap_pages_release+0x258/0x3a0
    lr: c0000000003788f4: devm_memremap_pages_release+0x254/0x3a0
    sp: c00000024146bb00
   msr: 800000000282b033
  current = 0xc000000241382f00
  paca    = 0xc00000003fffd680   irqmask: 0x03   irq_happened: 0x01
    pid   = 4114, comm = ndctl
 c0000000009bf8c0 devm_action_release+0x30/0x50
 c0000000009c0938 release_nodes+0x268/0x2d0
 c0000000009b95b4 device_release_driver_internal+0x164/0x230
 c0000000009b638c unbind_store+0x13c/0x190
 c0000000009b4f44 drv_attr_store+0x44/0x60
 c00000000058ccc0 sysfs_kf_write+0x70/0xa0
 c00000000058b52c kernfs_fop_write+0x1ac/0x290
 c0000000004a415c __vfs_write+0x3c/0x70
 c0000000004a85ac vfs_write+0xec/0x200
 c0000000004a8920 ksys_write+0x80/0x130
 c00000000000bee4 system_call+0x5c/0x70

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 59661106da16..892eabe1ec13 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5740,8 +5740,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 
 #ifdef CONFIG_ZONE_DEVICE
 	/*
-	 * Honor reservation requested by the driver for this ZONE_DEVICE
-	 * memory. We limit the total number of pages to initialize to just
+	 * We limit the total number of pages to initialize to just
 	 * those that might contain the memory mapping. We will defer the
 	 * ZONE_DEVICE page initialization until after we have released
 	 * the hotplug lock.
@@ -5750,8 +5749,6 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		if (!altmap)
 			return;
 
-		if (start_pfn == altmap->base_pfn)
-			start_pfn += altmap->reserve;
 		end_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
 	}
 #endif
-- 
2.21.0
