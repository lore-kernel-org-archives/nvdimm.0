Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2C64210C2D65
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jun 2018 13:33:40 -0700 (PDT)
Subject: [PATCH v2] mm: disallow mapping that conflict for
 devm_memremap_pages()
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 15 Jun 2018 13:33:39 -0700
Message-ID: <152909478401.50143.312364396244072931.stgit@djiang5-desk3.ch.intel.com>
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
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When pmem namespaces created are smaller than section size, this can cause
issue during removal and gpf was observed:

[ 249.613597] general protection fault: 0000 1 SMP PTI
[ 249.725203] CPU: 36 PID: 3941 Comm: ndctl Tainted: G W
4.14.28-1.el7uek.x86_64 #2
[ 249.745495] task: ffff88acda150000 task.stack: ffffc900233a4000
[ 249.752107] RIP: 0010:__put_page+0x56/0x79
[ 249.844675] Call Trace:
[ 249.847410] devm_memremap_pages_release+0x155/0x23a
[ 249.852953] release_nodes+0x21e/0x260
[ 249.857138] devres_release_all+0x3c/0x48
[ 249.861606] device_release_driver_internal+0x15c/0x207
[ 249.867439] device_release_driver+0x12/0x14
[ 249.872204] unbind_store+0xba/0xd8
[ 249.876098] drv_attr_store+0x27/0x31
[ 249.880186] sysfs_kf_write+0x3f/0x46
[ 249.884266] kernfs_fop_write+0x10f/0x18b
[ 249.888734] __vfs_write+0x3a/0x16d
[ 249.892628] ? selinux_file_permission+0xe5/0x116
[ 249.897881] ? security_file_permission+0x41/0xbb
[ 249.903133] vfs_write+0xb2/0x1a1
[ 249.906835] ? syscall_trace_enter+0x1ce/0x2b8
[ 249.911795] SyS_write+0x55/0xb9
[ 249.915397] do_syscall_64+0x79/0x1ae
[ 249.919485] entry_SYSCALL_64_after_hwframe+0x3d/0x0

Add code to check whether we have mapping already in the same section and
prevent additional mapping from created if that is the case.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: Change dev_warn() to dev_WARN() to provide helpful backtrace. (Robert E)

 kernel/memremap.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 5857267a4af5..a734b1747466 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -176,10 +176,27 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	unsigned long pfn, pgoff, order;
 	pgprot_t pgprot = PAGE_KERNEL;
 	int error, nid, is_ram;
+	struct dev_pagemap *conflict_pgmap;
 
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
+	align_end = align_start + align_size - 1;
+
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(align_start), NULL);
+	if (conflict_pgmap) {
+		dev_WARN(dev, "Conflicting mapping in same section\n");
+		put_dev_pagemap(conflict_pgmap);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(align_end), NULL);
+	if (conflict_pgmap) {
+		dev_WARN(dev, "Conflicting mapping in same section\n");
+		put_dev_pagemap(conflict_pgmap);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	is_ram = region_intersects(align_start, align_size,
 		IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
 
@@ -199,7 +216,6 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
-	align_end = align_start + align_size - 1;
 
 	foreach_order_pgoff(res, order, pgoff) {
 		error = __radix_tree_insert(&pgmap_radix,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
