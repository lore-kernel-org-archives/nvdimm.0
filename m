Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E9D82194D387
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 10:10:33 -0700 (PDT)
Subject: [PATCH v5 00/10] mm: Sub-section memory hotplug support
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 09:57:54 -0700
Message-ID: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v4 [1]:
- Given v4 was from March of 2017 the bulk of the changes result from
  rebasing the patch set from a v4.11-rc2 baseline to v5.1-rc1.

- A unit test is added to ndctl to exercise the creation and dax
  mounting of multiple independent namespaces in a single 128M section.

[1]: https://lwn.net/Articles/717383/

---

Quote patch7:

"The libnvdimm sub-system has suffered a series of hacks and broken
 workarounds for the memory-hotplug implementation's awkward
 section-aligned (128MB) granularity. For example the following backtrace
 is emitted when attempting arch_add_memory() with physical address
 ranges that intersect 'System RAM' (RAM) with 'Persistent Memory' (PMEM)
 within a given section:
 
  WARNING: CPU: 0 PID: 558 at kernel/memremap.c:300 devm_memremap_pages+0x3b5/0x4c0
  devm_memremap_pages attempted on mixed region [mem 0x200000000-0x2fbffffff flags 0x200]
  [..]
  Call Trace:
    dump_stack+0x86/0xc3
    __warn+0xcb/0xf0
    warn_slowpath_fmt+0x5f/0x80
    devm_memremap_pages+0x3b5/0x4c0
    __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
    pmem_attach_disk+0x19a/0x440 [nd_pmem]
 
 Recently it was discovered that the problem goes beyond RAM vs PMEM
 collisions as some platform produce PMEM vs PMEM collisions within a
 given section. The libnvdimm workaround for that case revealed that the
 libnvdimm section-alignment-padding implementation has been broken for a
 long while. A fix for that long-standing breakage introduces as many
 problems as it solves as it would require a backward-incompatible change
 to the namespace metadata interpretation. Instead of that dubious route
 [2], address the root problem in the memory-hotplug implementation."

The approach is taken is to observe that each section already maintains
an array of 'unsigned long' values to hold the pageblock_flags. A single
additional 'unsigned long' is added to house a 'sub-section active'
bitmask. Each bit tracks the mapped state of one sub-section's worth of
capacity which is SECTION_SIZE / BITS_PER_LONG, or 2MB on x86-64.

The implication of allowing sections to be piecemeal mapped/unmapped is
that the valid_section() helper is no longer authoritative to determine
if a section is fully mapped. Instead pfn_valid() is updated to consult
the section-active bitmask. Given that typical memory hotplug still has
deep "section" dependencies the sub-section capability is limited to
'want_memblock=false' invocations of arch_add_memory(), effectively only
devm_memremap_pages() users for now.

With this in place the hacks in the libnvdimm sub-system can be
dropped, and other devm_memremap_pages() users need no longer be
constrained to 128MB mapping granularity.

[2]: https://lore.kernel.org/r/155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com

---

Dan Williams (10):
      mm/sparsemem: Introduce struct mem_section_usage
      mm/sparsemem: Introduce common definitions for the size and mask of a section
      mm/sparsemem: Add helpers track active portions of a section at boot
      mm/hotplug: Prepare shrink_{zone,pgdat}_span for sub-section removal
      mm/sparsemem: Convert kmalloc_section_memmap() to populate_section_memmap()
      mm/sparsemem: Prepare for sub-section ranges
      mm/sparsemem: Support sub-section hotplug
      mm/devm_memremap_pages: Enable sub-section remap
      libnvdimm/pfn: Fix fsdax-mode namespace info-block zero-fields
      libnvdimm/pfn: Stop padding pmem namespaces to section alignment


 arch/x86/mm/init_64.c          |   15 +-
 drivers/nvdimm/dax_devs.c      |    2 
 drivers/nvdimm/pfn.h           |   12 -
 drivers/nvdimm/pfn_devs.c      |   93 +++-------
 include/linux/memory_hotplug.h |    7 -
 include/linux/mm.h             |    4 
 include/linux/mmzone.h         |   60 ++++++
 kernel/memremap.c              |   57 ++----
 mm/hmm.c                       |    2 
 mm/memory_hotplug.c            |  119 +++++++-----
 mm/page_alloc.c                |    6 -
 mm/sparse-vmemmap.c            |   21 +-
 mm/sparse.c                    |  382 ++++++++++++++++++++++++++++------------
 13 files changed, 476 insertions(+), 304 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
