Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F665211F2696
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 12:21:24 -0700 (PDT)
Subject: [RFC PATCH 3/5] acpi/hmat: Track target address ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 Apr 2019 12:08:44 -0700
Message-ID: <155440492414.3190322.12683374224345847860.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-mm@kvack.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

As of ACPI 6.3 the HMAT no longer advertises the physical memory address
range for its entries. Instead, the expectation is the corresponding
entry in the SRAT is looked up by the target proximity domain.

Given there may be multiple distinct address ranges that share the same
performance profile (sparse address space), find_mem_target() is updated
to also consider the start address of the memory range. Target property
updates are also adjusted to loop over all possible 'struct target'
instances that may share the same proximity domain identification.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/hmat/hmat.c |   77 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
index b275016ff648..e7ae44c8d359 100644
--- a/drivers/acpi/hmat/hmat.c
+++ b/drivers/acpi/hmat/hmat.c
@@ -38,6 +38,7 @@ static struct memory_locality *localities_types[4];
 
 struct memory_target {
 	struct list_head node;
+	u64 start, size;
 	unsigned int memory_pxm;
 	unsigned int processor_pxm;
 	struct node_hmem_attrs hmem_attrs;
@@ -63,12 +64,13 @@ static __init struct memory_initiator *find_mem_initiator(unsigned int cpu_pxm)
 	return NULL;
 }
 
-static __init struct memory_target *find_mem_target(unsigned int mem_pxm)
+static __init struct memory_target *find_mem_target(unsigned int mem_pxm,
+		u64 start)
 {
 	struct memory_target *target;
 
 	list_for_each_entry(target, &targets, node)
-		if (target->memory_pxm == mem_pxm)
+		if (target->memory_pxm == mem_pxm && target->start == start)
 			return target;
 	return NULL;
 }
@@ -92,14 +94,15 @@ static __init void alloc_memory_initiator(unsigned int cpu_pxm)
 	list_add_tail(&initiator->node, &initiators);
 }
 
-static __init void alloc_memory_target(unsigned int mem_pxm)
+static __init void alloc_memory_target(unsigned int mem_pxm,
+		u64 start, u64 size)
 {
 	struct memory_target *target;
 
 	if (pxm_to_node(mem_pxm) == NUMA_NO_NODE)
 		return;
 
-	target = find_mem_target(mem_pxm);
+	target = find_mem_target(mem_pxm, start);
 	if (target)
 		return;
 
@@ -109,6 +112,8 @@ static __init void alloc_memory_target(unsigned int mem_pxm)
 
 	target->memory_pxm = mem_pxm;
 	target->processor_pxm = PXM_INVAL;
+	target->start = start;
+	target->size = size;
 	list_add_tail(&target->node, &targets);
 }
 
@@ -183,8 +188,8 @@ static __init u32 hmat_normalize(u16 entry, u64 base, u8 type)
 	return value;
 }
 
-static __init void hmat_update_target_access(struct memory_target *target,
-					     u8 type, u32 value)
+static __init void __hmat_update_target_access(struct memory_target *target,
+		u8 type, u32 value)
 {
 	switch (type) {
 	case ACPI_HMAT_ACCESS_LATENCY:
@@ -212,6 +217,20 @@ static __init void hmat_update_target_access(struct memory_target *target,
 	}
 }
 
+static __init void hmat_update_target_access(int memory_pxm, int processor_pxm,
+		u8 type, u32 value)
+{
+	struct memory_target *target;
+
+	list_for_each_entry(target, &targets, node) {
+		if (target->processor_pxm != processor_pxm)
+			continue;
+		if (target->memory_pxm != memory_pxm)
+			continue;
+		__hmat_update_target_access(target, type, value);
+	}
+}
+
 static __init void hmat_add_locality(struct acpi_hmat_locality *hmat_loc)
 {
 	struct memory_locality *loc;
@@ -255,7 +274,6 @@ static __init int hmat_parse_locality(union acpi_subtable_headers *header,
 				      const unsigned long end)
 {
 	struct acpi_hmat_locality *hmat_loc = (void *)header;
-	struct memory_target *target;
 	unsigned int init, targ, total_size, ipds, tpds;
 	u32 *inits, *targs, value;
 	u16 *entries;
@@ -296,11 +314,9 @@ static __init int hmat_parse_locality(union acpi_subtable_headers *header,
 				inits[init], targs[targ], value,
 				hmat_data_type_suffix(type));
 
-			if (mem_hier == ACPI_HMAT_MEMORY) {
-				target = find_mem_target(targs[targ]);
-				if (target && target->processor_pxm == inits[init])
-					hmat_update_target_access(target, type, value);
-			}
+			if (mem_hier == ACPI_HMAT_MEMORY)
+				hmat_update_target_access(targs[targ],
+						inits[init], type, value);
 		}
 	}
 
@@ -367,6 +383,7 @@ static int __init hmat_parse_proximity_domain(union acpi_subtable_headers *heade
 {
 	struct acpi_hmat_proximity_domain *p = (void *)header;
 	struct memory_target *target = NULL;
+	bool found = false;
 
 	if (p->header.length != sizeof(*p)) {
 		pr_notice("HMAT: Unexpected address range header length: %d\n",
@@ -382,23 +399,34 @@ static int __init hmat_parse_proximity_domain(union acpi_subtable_headers *heade
 		pr_info("HMAT: Memory Flags:%04x Processor Domain:%d Memory Domain:%d\n",
 			p->flags, p->processor_PD, p->memory_PD);
 
-	if (p->flags & ACPI_HMAT_MEMORY_PD_VALID) {
-		target = find_mem_target(p->memory_PD);
-		if (!target) {
-			pr_debug("HMAT: Memory Domain missing from SRAT\n");
-			return -EINVAL;
-		}
-	}
-	if (target && p->flags & ACPI_HMAT_PROCESSOR_PD_VALID) {
-		int p_node = pxm_to_node(p->processor_PD);
+	if ((p->flags & ACPI_HMAT_MEMORY_PD_VALID) == 0)
+		return 0;
+
+	list_for_each_entry(target, &targets, node) {
+		int p_node;
+
+		if (target->memory_pxm != p->memory_PD)
+			continue;
+		found = true;
 
+		if ((p->flags & ACPI_HMAT_PROCESSOR_PD_VALID) == 0)
+			continue;
+
+		p_node = pxm_to_node(p->processor_PD);
 		if (p_node == NUMA_NO_NODE) {
-			pr_debug("HMAT: Invalid Processor Domain\n");
+			pr_debug("HMAT: Invalid Processor Domain: %d\n",
+					p->processor_PD);
 			return -EINVAL;
 		}
+
 		target->processor_pxm = p_node;
 	}
 
+	if (!found) {
+		pr_debug("HMAT: Memory Domain missing from SRAT for pxm: %d\n",
+				p->memory_PD);
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -431,7 +459,7 @@ static __init int srat_parse_mem_affinity(union acpi_subtable_headers *header,
 		return -EINVAL;
 	if (!(ma->flags & ACPI_SRAT_MEM_ENABLED))
 		return 0;
-	alloc_memory_target(ma->proximity_domain);
+	alloc_memory_target(ma->proximity_domain, ma->base_address, ma->length);
 	return 0;
 }
 
@@ -568,7 +596,8 @@ static __init void hmat_register_target_initiators(struct memory_target *target)
 				clear_bit(initiator->processor_pxm, p_nodes);
 		}
 		if (best)
-			hmat_update_target_access(target, loc->hmat_loc->data_type, best);
+			__hmat_update_target_access(target,
+					loc->hmat_loc->data_type, best);
 	}
 
 	for_each_set_bit(i, p_nodes, MAX_NUMNODES) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
