Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF4592097DD18
 for <linux-nvdimm@lists.01.org>; Mon, 16 Jul 2018 10:10:18 -0700 (PDT)
Subject: [PATCH v2 00/14] mm: Asynchronous + multithreaded memmap init for
 ZONE_DEVICE
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Jul 2018 10:00:19 -0700
Message-ID: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm@kvack.org, Rich Felker <dalias@libc.org>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-nvdimm@lists.01.org, x86@kernel.org, Pavel Tatashin <pasha.tatashin@oracle.com>, Matthew Wilcox <willy@infradead.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, Ingo Molnar <mingo@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* Teach memmap_sync() to take over a sub-set of memmap initialization in
  the foreground. This foreground work still needs to await the
  completion of vmemmap_populate_hugepages(), but it will otherwise
  steal 1/1024th of the 'struct page' init work for the given range.
  (Jan)
* Add kernel-doc for all the new 'async' structures.
* Split foreach_order_pgoff() to its own patch.
* Add Pavel and Daniel to the cc as they have been active in the memory
  hotplug code.
* Fix a typo that prevented CONFIG_DAX_DRIVER_DEBUG=y from performing
  early pfn retrieval at dax-filesystem mount time.
* Improve some of the changelogs

[1]: https://lwn.net/Articles/759117/

---

In order to keep pfn_to_page() a simple offset calculation the 'struct
page' memmap needs to be mapped and initialized in advance of any usage
of a page. This poses a problem for large memory systems as it delays
full availability of memory resources for 10s to 100s of seconds.

For typical 'System RAM' the problem is mitigated by the fact that large
memory allocations tend to happen after the kernel has fully initialized
and userspace services / applications are launched. A small amount, 2GB
of memory, is initialized up front. The remainder is initialized in the
background and freed to the page allocator over time.

Unfortunately, that scheme is not directly reusable for persistent
memory and dax because userspace has visibility to the entire resource
pool and can choose to access any offset directly at its choosing. In
other words there is no allocator indirection where the kernel can
satisfy requests with arbitrary pages as they become initialized.

That said, we can approximate the optimization by performing the
initialization in the background, allow the kernel to fully boot the
platform, start up pmem block devices, mount filesystems in dax mode,
and only incur delay at the first userspace dax fault. When that initial
fault occurs that process is delegated a portion of the memmap to
initialize in the foreground so that it need not wait for initialization
of resources that it does not immediately need.

With this change an 8 socket system was observed to initialize pmem
namespaces in ~4 seconds whereas it was previously taking ~4 minutes.

These patches apply on top of the HMM + devm_memremap_pages() reworks:

https://marc.info/?l=linux-mm&m=153128668008585&w=2

---

Dan Williams (10):
      mm: Plumb dev_pagemap instead of vmem_altmap to memmap_init_zone()
      mm: Enable asynchronous __add_pages() and vmemmap_populate_hugepages()
      mm: Teach memmap_init_zone() to initialize ZONE_DEVICE pages
      mm: Multithread ZONE_DEVICE initialization
      mm, memremap: Up-level foreach_order_pgoff()
      mm: Allow an external agent to coordinate memmap initialization
      filesystem-dax: Make mount time pfn validation a debug check
      libnvdimm, pmem: Initialize the memmap in the background
      device-dax: Initialize the memmap in the background
      libnvdimm, namespace: Publish page structure init state / control

Huaisheng Ye (4):
      libnvdimm, pmem: Allow a NULL-pfn to ->direct_access()
      tools/testing/nvdimm: Allow a NULL-pfn to ->direct_access()
      s390, dcssblk: Allow a NULL-pfn to ->direct_access()
      filesystem-dax: Do not request a pfn when not required


 arch/ia64/mm/init.c             |    5 +
 arch/powerpc/mm/mem.c           |    5 +
 arch/s390/mm/init.c             |    8 +
 arch/sh/mm/init.c               |    5 +
 arch/x86/mm/init_32.c           |    8 +
 arch/x86/mm/init_64.c           |   27 ++--
 drivers/dax/Kconfig             |   10 +
 drivers/dax/dax-private.h       |    2 
 drivers/dax/device-dax.h        |    2 
 drivers/dax/device.c            |   16 ++
 drivers/dax/pmem.c              |    5 +
 drivers/dax/super.c             |   64 ++++++---
 drivers/nvdimm/nd.h             |    2 
 drivers/nvdimm/pfn_devs.c       |   50 +++++--
 drivers/nvdimm/pmem.c           |   17 ++
 drivers/nvdimm/pmem.h           |    1 
 drivers/s390/block/dcssblk.c    |    5 -
 fs/dax.c                        |   10 -
 include/linux/memmap_async.h    |  110 ++++++++++++++++
 include/linux/memory_hotplug.h  |   18 ++-
 include/linux/memremap.h        |   31 ++++
 include/linux/mm.h              |    8 +
 kernel/memremap.c               |   85 ++++++------
 mm/memory_hotplug.c             |   73 ++++++++---
 mm/page_alloc.c                 |  271 +++++++++++++++++++++++++++++++++++----
 mm/sparse-vmemmap.c             |   56 ++++++--
 tools/testing/nvdimm/pmem-dax.c |   11 +-
 27 files changed, 717 insertions(+), 188 deletions(-)
 create mode 100644 include/linux/memmap_async.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
