Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F84507.8010904@plexistor.com>
Date: Thu, 05 Mar 2015 13:59:03 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 6/8] mm: New add_persistent_memory/remove_persistent_memory
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>


Persistent Memory is not Memory. It is not presented as
a Memory Zone and is not available through the page allocators
for application/kernel volatile usage.

It belongs to A block device just as any other Persistent storage,
the novelty here is that it is directly mapped on the CPU Memory
bus, and usually as fast or almost as fast as system RAM.

The main motivation of add_persistent_memory is to allocate a
page-struct "Section" for a given physical memory region. This is because
The user of this memory mapped device might need to pass pages-struct
of this memory to a Kernel subsytem like block-layer or networking
and have it's content directly DMAed to other devices

(For example these pages can be put on a bio and sent to disk
 in a copy-less manner)

It will also request_mem_region_exclusive(.., "persistent_memory")
to own that physical memory region.

And will map that physical region to the Kernel's VM at the
address expected for page_address() of those pages allocated
above

remove_persistent_memory() must be called to undo what
add_persistent_memory did.

A user of this API will then use pfn_to_page(PHISICAL_ADDR >> PAGE_SIZE)
to receive a page-struct for use on its pmem.

Any operation like page_address() page_to_pfn() page_lock() ... can
be preformed on these pages just as usual.

An example user is presented in the next patch to pmem.c Block Device
driver (There are 3 more such drivers in the Kernel that could use this
API)

This patch is based on research and patch made by
Yigal Korman <yigal@plexistor.com> to the pmem driver. I took his code
and adapted it to mm, where it belongs.

[v2 SQUASHME1]
    Fixing 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
    '__meminit' should be added
	Signed-off-by: Yigal Korman <yigal@plexistor.com>
[v3 SQUASHME2]
	We need to calculate the nid for every section, it is
	possible that the same contiguous range will span two
	numa-nodes.
	Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

Signed-off-by: Yigal Korman <yigal@plexistor.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 include/linux/memory_hotplug.h |   4 +
 mm/Kconfig                     |  23 ++++++
 mm/memory_hotplug.c            | 177 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 77ca3a4..b7d6c6e 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -192,6 +192,10 @@ extern void get_page_bootmem(unsigned long ingo, struct page *page,
 void get_online_mems(void);
 void put_online_mems(void);
 
+int add_persistent_memory(phys_addr_t phys_addr, size_t size,
+			  void **o_virt_addr);
+void remove_persistent_memory(phys_addr_t phys_addr, size_t size);
+
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
  * Stub functions for when hotplug is off
diff --git a/mm/Kconfig b/mm/Kconfig
index a03131b..05c9585 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -200,6 +200,29 @@ config MEMORY_HOTREMOVE
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
+
+# User of PERSISTENT_MEMORY_SECTION should:
+#	depends on PERSISTENT_MEMORY_DEPENDENCY and
+#	select DRIVER_NEEDS_PERSISTENT_MEMORY
+# Note that it will not be enabled if MEMORY_HOTPLUG is not enabled
+#
+# If you have changed the dependency/select of MEMORY_HOTREMOVE please also
+# update here
+#
+config PERSISTENT_MEMORY_DEPENDENCY
+	def_bool y
+	depends on MEMORY_HOTPLUG
+	depends on ARCH_ENABLE_MEMORY_HOTREMOVE && MIGRATION
+
+config DRIVER_NEEDS_PERSISTENT_MEMORY
+	bool
+
+config PERSISTENT_MEMORY_SECTION
+	def_bool y
+	depends on PERSISTENT_MEMORY_DEPENDENCY
+	depends on DRIVER_NEEDS_PERSISTENT_MEMORY
+	select MEMORY_HOTREMOVE
+
 #
 # If we have space for more page flags then we can enable additional
 # optimizations and functionality.
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7a73d30..416efdb 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -2025,3 +2025,180 @@ void __ref remove_memory(int nid, u64 start, u64 size)
 }
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
+
+#ifdef CONFIG_PERSISTENT_MEMORY_SECTION
+
+/* This helper is so we do not need to allocate a page_array bigger
+ * than PAGE_SIZE
+ */
+static int _map_sec_range(ulong sec_start_pfn, struct page **page_array)
+{
+	const uint NUM_PAGES = PAGE_SIZE / sizeof(*page_array);
+	const uint ARRAYS_IN_SECTION = PAGES_PER_SECTION / NUM_PAGES;
+	ulong pfn = sec_start_pfn;
+	uint a;
+
+	for (a = 0; a < ARRAYS_IN_SECTION; ++a) {
+		ulong virt_addr = (ulong)page_address(pfn_to_page(pfn));
+		uint p;
+		int ret;
+
+		for (p = 0; p < NUM_PAGES; ++p)
+			page_array[p] = pfn_to_page(pfn++);
+
+		ret = map_kernel_range_noflush(virt_addr, NUM_PAGES * PAGE_SIZE,
+					       PAGE_KERNEL, page_array);
+		if (unlikely(ret < 0)) {
+			pr_warn("%s: map_kernel_range(0x%lx, 0x%lx) => %d\n",
+				__func__, sec_start_pfn, virt_addr, ret);
+			return ret;
+		}
+		if (unlikely(ret < NUM_PAGES)) {
+			pr_warn("%s: map_kernel_range(0x%lx) => %d != %d last_pfn=0x%lx\n",
+				 __func__, virt_addr, NUM_PAGES, ret, pfn);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * add_persistent_memory - Add memory sections and maps them to Kernel space
+ * @phys_addr: start of physical address to add & map
+ * @size: size of the memory range in bytes
+ * @o_virt_addr: The returned virtual address of the mapped memory range
+ *
+ * A persistent_memory block-device will use this function to add memory
+ * sections and map its physical memory range. After the call to this function
+ * There will be page-struct associated with each pfn added here, and it will
+ * be accessible from Kernel space through the returned @o_virt_addr
+ * @phys_addr will be rounded down to the nearest SECTION_SIZE, the range
+ * mapped will be in full SECTION_SIZE sections.
+ * @o_virt_addr is the address of @phys_addr not the start of the mapped section
+ * so usually mapping a range unaligned on SECTION_SIZE will work just that the
+ * unaligned start and/or end, will ignore the error and continue.
+ * (but will print "memory section XX already exists")
+ *
+ * NOTE:
+ * persistent_memory is not system ram and is not available through any
+ * allocator, for regular consumption. Therefore it does not belong to any
+ * memory zone.
+ * But it will need a memory-section allocated, so page-structs are available
+ * for this memory, so it can be DMA'd directly with zero copy.
+ * After a call to this function the ranged pages belong exclusively to the
+ * caller.
+ *
+ * RETURNS:
+ * zero on success, or -errno on failure. If successful @o_virt_addr will be set
+ */
+int __meminit add_persistent_memory(phys_addr_t phys_addr, size_t size,
+			  void **o_virt_addr)
+{
+	ulong start_pfn = phys_addr >> PAGE_SHIFT;
+	ulong nr_pages = size >> PAGE_SHIFT;
+	ulong start_sec = pfn_to_section_nr(start_pfn);
+	ulong end_sec = pfn_to_section_nr(start_pfn + nr_pages +
+							PAGES_PER_SECTION - 1);
+	struct resource *res_mem;
+	struct page **page_array;
+	ulong i;
+	int ret = 0;
+
+	page_array = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (unlikely(!page_array))
+		return -ENOMEM;
+
+	res_mem = request_mem_region_exclusive(phys_addr, size,
+					       "persistent_memory");
+	if (unlikely(!res_mem)) {
+		pr_warn("%s: request_mem_region_exclusive phys=0x%llx size=0x%zx failed\n",
+			__func__, phys_addr, size);
+		ret = -EINVAL;
+		goto free_array;
+	}
+
+	for (i = start_sec; i < end_sec; ++i) {
+		ulong sec_pfn = i << PFN_SECTION_SHIFT;
+		int nid = memory_add_physaddr_to_nid(sec_pfn << PAGE_SHIFT);
+
+		if (pfn_valid(sec_pfn)) {
+			pr_warn("%s: memory section %lu already exists.\n",
+				__func__, i);
+			continue;
+		}
+
+		ret = sparse_add_one_section(nid, sec_pfn);
+		if (unlikely(ret < 0)) {
+			if (ret == -EEXIST) {
+				ret = 0;
+				continue;
+			} else {
+				pr_warn("%s: sparse_add_one_section => %d\n",
+					__func__, ret);
+				goto release_region;
+			}
+		}
+
+		ret = _map_sec_range(sec_pfn, page_array);
+		if (unlikely(ret))
+			goto release_region;
+	}
+
+	*o_virt_addr = page_address(pfn_to_page(start_pfn));
+
+free_array:
+	kfree(page_array);
+	return ret;
+
+release_region:
+	release_mem_region(phys_addr, size);
+	goto free_array;
+}
+EXPORT_SYMBOL_GPL(add_persistent_memory);
+
+/**
+ * remove_persistent_memory - undo anything add_persistent_memory did
+ * @phys_addr: start of physical address to remove
+ * @size: size of the memory range in bytes
+ *
+ * A successful call to add_persistent_memory must be paired with
+ * remove_persistent_memory when done. It will unmap passed PFNs from
+ * Kernel virtual address, and will remove the memory sections.
+ * @phys_addr, @size must be exactly those passed to add_persistent_memory
+ * otherwise results are unexpected, there are no checks done on this.
+ */
+void remove_persistent_memory(phys_addr_t phys_addr, size_t size)
+{
+	ulong start_pfn = phys_addr >> PAGE_SHIFT;
+	ulong nr_pages = size >> PAGE_SHIFT;
+	ulong start_sec = pfn_to_section_nr(start_pfn);
+	ulong end_sec = pfn_to_section_nr(start_pfn + nr_pages +
+							PAGES_PER_SECTION - 1);
+	int nid = pfn_to_nid(start_pfn);
+	ulong virt_addr;
+	unsigned int i;
+
+	virt_addr = (ulong)page_address(
+				pfn_to_page(start_sec << PFN_SECTION_SHIFT));
+
+	for (i = start_sec; i < end_sec; ++i) {
+		struct mem_section *ms;
+
+		unmap_kernel_range(virt_addr, 1UL << SECTION_SIZE_BITS);
+		virt_addr += 1UL << SECTION_SIZE_BITS;
+
+		ms = __nr_to_section(i);
+		if (!valid_section(ms)) {
+			pr_warn("%s: memory section %d is missing.\n",
+				__func__, i);
+			continue;
+		}
+		sparse_remove_one_section(nid, ms);
+	}
+
+	release_mem_region(phys_addr, size);
+}
+EXPORT_SYMBOL_GPL(remove_persistent_memory);
+
+#endif /* def CONFIG_PERSISTENT_MEMORY_SECTION */
+
-- 
1.9.3

