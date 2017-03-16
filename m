Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2BB2803DE
 for <linux-nvdimm@lists.01.org>; Wed, 15 Mar 2017 23:11:58 -0700 (PDT)
Subject: [PATCH v4 00/13] mm: sub-section memory hotplug support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Mar 2017 23:06:47 -0700
Message-ID: <148964440651.19438.2288075389153762985.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, Mel Gorman <mgorman@techsingularity.net>, linux-kernel@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, linux-mm@kvack.org, Nicolai Stange <nicstange@gmail.com>, Alexander Potapenko <glider@google.com>, Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:

1/ Rebased on v4.11-rc2

2/ Worked around kasan regression ("x86, kasan: clarify kasan's
   dependency on vmemmap_populate_hugepages()") (Nicolai)

[1]: https://lwn.net/Articles/712099/

---

The initial motivation for this change is persistent memory platforms
that, unfortunately, align the pmem range on a boundary less than a full
section (64M vs 128M), and may change the alignment from one boot to the
next. A secondary motivation is the arrival of prospective ZONE_DEVICE
users that want devm_memremap_pages() to map PCI-E device memory ranges
to enable peer-to-peer DMA. There is a range of possible physical
address alignments of PCI-E BARs that are less than 128M.

Currently the libnvdimm core injects padding when 'pfn' (struct page
mapping configuration) instances are created. However, not all users of
devm_memremap_pages() have the opportunity to inject such padding. Users
of the memmap=ss!nn kernel command line option can trigger the following
failure with unaligned parameters like "memmap=0xfc000000!8G":

 WARNING: CPU: 0 PID: 558 at kernel/memremap.c:300
 devm_memremap_pages attempted on mixed region [mem 0x200000000-0x2fbffffff flags 0x200]
 [..]
 Call Trace:
  [<ffffffff814c0393>] dump_stack+0x86/0xc3
  [<ffffffff810b173b>] __warn+0xcb/0xf0
  [<ffffffff810b17bf>] warn_slowpath_fmt+0x5f/0x80
  [<ffffffff811eb105>] devm_memremap_pages+0x3b5/0x4c0
  [<ffffffffa006f308>] __wrap_devm_memremap_pages+0x58/0x70 [nfit_test_iomap]
  [<ffffffffa00e231a>] pmem_attach_disk+0x19a/0x440 [nd_pmem]

Without this change a user could inadvertently lose access to nvdimm
namespaces after a configuration change. The act of adding, removing, or
rearranging DIMMs in the platform could lead to the BIOS changing the
base alignment of the namespace in an incompatible fashion.  With this
support we can accommodate a BIOS changing the namespace to any
alignment provided it is >= SECTION_ACTIVE_SIZE.

In other words, we are protecting against misalignment injected by the
BIOS after the libnvdimm sub-system already recorded that the namespace
does not need alignment padding. In that case the user would need to
figure out how to undo the configuration change to regain access to
their nvdimm capacity.

---

The patches have received a build success notification from the
0day-kbuild robot across 172 configs and pass the latest libnvdimm/ndctl
unit test suite. They depend on "mm: add private lock to serialize
memory hotplug operations" [2] which is already in -mm.

[2]: https://lkml.org/lkml/2017/3/9/395

---

Dan Williams (13):
      mm: fix type width of section to/from pfn conversion macros
      mm, devm_memremap_pages: use multi-order radix for ZONE_DEVICE lookups
      mm: introduce struct mem_section_usage to track partial population of a section
      mm: introduce common definitions for the size and mask of a section
      mm: cleanup sparse_init_one_section() return value
      mm: track active portions of a section at boot
      mm: fix register_new_memory() zone type detection
      x86, kasan: clarify kasan's dependency on vmemmap_populate_hugepages()
      mm: convert kmalloc_section_memmap() to populate_section_memmap()
      mm: prepare for hot-{add,remove} of sub-section ranges
      mm: support section-unaligned ZONE_DEVICE memory ranges
      mm: enable section-unaligned devm_memremap_pages()
      libnvdimm, pfn, dax: stop padding pmem namespaces to section alignment


 arch/x86/mm/init_64.c          |   17 +
 arch/x86/mm/kasan_init_64.c    |   30 ++-
 drivers/base/memory.c          |   26 +-
 drivers/nvdimm/pfn_devs.c      |   42 +---
 include/linux/memory.h         |    4 
 include/linux/memory_hotplug.h |    6 -
 include/linux/mm.h             |    5 
 include/linux/mmzone.h         |   30 ++-
 kernel/memremap.c              |   76 ++++---
 mm/Kconfig                     |    1 
 mm/memory_hotplug.c            |   95 ++++----
 mm/page_alloc.c                |    6 -
 mm/sparse-vmemmap.c            |   24 +-
 mm/sparse.c                    |  454 +++++++++++++++++++++++++++++-----------
 14 files changed, 540 insertions(+), 276 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
