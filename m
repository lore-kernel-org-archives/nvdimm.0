Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A1E581F37
 for <linux-nvdimm@lists.01.org>; Thu,  1 Dec 2016 14:34:29 -0800 (PST)
Subject: [PATCH 06/11] mm: fix register_new_memory() zone type detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Dec 2016 14:30:19 -0800
Message-ID: <148063141951.37496.13890642643091004054.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148063138593.37496.4684424640746238765.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148063138593.37496.4684424640746238765.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for sub-section memory hotplug support, remove a
dependency on ->section_mem_map being populated. In SPARSEMEM_VMEMMAP=y
configurations pfn_to_page() does not use ->section_mem_map. The
sub-section hotplug support relies on this fact and skips initializing
it. Without ->section_mem_map populated, or aligned to section boundary,
conversions of mem_section instances to zones is not possible.

So, this removes a false dependency on a structure field that will only
be valid in the SPARSEMEM_VMEMMAP=n case, and only used for
pfn_to_page() (and similar) operations.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/memory.c  |   26 +++++++++-----------------
 include/linux/memory.h |    4 ++--
 mm/memory_hotplug.c    |    4 ++--
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 62c63c0c5c22..ac34f27274bf 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -687,24 +687,16 @@ static int add_memory_block(int base_section_nr)
 	return 0;
 }
 
-static bool is_zone_device_section(struct mem_section *ms)
-{
-	struct page *page;
-
-	page = sparse_decode_mem_map(ms->section_mem_map, __section_nr(ms));
-	return is_zone_device_page(page);
-}
-
 /*
  * need an interface for the VM to add new memory regions,
  * but without onlining it.
  */
-int register_new_memory(int nid, struct mem_section *section)
+int register_new_memory(struct zone *zone, int nid, struct mem_section *section)
 {
 	int ret = 0;
 	struct memory_block *mem;
 
-	if (is_zone_device_section(section))
+	if (is_dev_zone(zone))
 		return 0;
 
 	mutex_lock(&mem_sysfs_mutex);
@@ -738,14 +730,11 @@ unregister_memory(struct memory_block *memory)
 	device_unregister(&memory->dev);
 }
 
-static int remove_memory_section(unsigned long node_id,
-			       struct mem_section *section, int phys_device)
+static int remove_memory_section(struct zone *zone, unsigned long node_id,
+		struct mem_section *section, int phys_device)
 {
 	struct memory_block *mem;
 
-	if (is_zone_device_section(section))
-		return 0;
-
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
 	unregister_mem_sect_under_nodes(mem, __section_nr(section));
@@ -760,12 +749,15 @@ static int remove_memory_section(unsigned long node_id,
 	return 0;
 }
 
-int unregister_memory_section(struct mem_section *section)
+int unregister_memory_section(struct zone *zone, struct mem_section *section)
 {
+	if (is_dev_zone(zone))
+		return 0;
+
 	if (!present_section(section))
 		return -EINVAL;
 
-	return remove_memory_section(0, section, 0);
+	return remove_memory_section(zone, 0, section, 0);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 093607f90b91..301dfb03ecb7 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -108,12 +108,12 @@ extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb);
-extern int register_new_memory(int, struct mem_section *);
+extern int register_new_memory(struct zone *, int, struct mem_section *);
 extern int memory_block_change_state(struct memory_block *mem,
 				     unsigned long to_state,
 				     unsigned long from_state_req);
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern int unregister_memory_section(struct mem_section *);
+extern int unregister_memory_section(struct zone *, struct mem_section *);
 #endif
 extern int memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c7b3b2308ac3..c8b1a4926fb7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -516,7 +516,7 @@ static int __meminit __add_section(int nid, struct zone *zone,
 	if (ret < 0)
 		return ret;
 
-	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
+	return register_new_memory(zone, nid, __pfn_to_section(phys_start_pfn));
 }
 
 /*
@@ -785,7 +785,7 @@ static int __remove_section(struct zone *zone, struct mem_section *ms,
 	if (!valid_section(ms))
 		return ret;
 
-	ret = unregister_memory_section(ms);
+	ret = unregister_memory_section(zone, ms);
 	if (ret)
 		return ret;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
