Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C2E92096F328
 for <linux-nvdimm@lists.01.org>; Sat,  2 Jun 2018 22:32:41 -0700 (PDT)
Subject: [PATCH v2 00/11] mm: Teach memory_failure() about ZONE_DEVICE pages
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 02 Jun 2018 22:22:43 -0700
Message-ID: <152800336321.17112.3300876636370683279.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Tony Luck <tony.luck@intel.com>, jack@suse.cz, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* Rework the locking to not use lock_page() instead use a combination of
  rcu_read_lock(), xa_lock_irq(&mapping->pages), and igrab() to validate
  that dax pages are still associated with the given mapping, and to
  prevent the address_space from being freed while memory_failure() is
  busy. (Jan)

* Fix use of MF_COUNT_INCREASED in madvise_inject_error() to account for
  the case where the injected error is a dax mapping and the pinned
  reference needs to be dropped. (Naoya)

* Clarify with a comment that VM_FAULT_NOPAGE may not always indicate a
  mapping of the storage capacity, it could also indicate the zero page.
  (Jan)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-May/015932.html

---

As it stands, memory_failure() gets thoroughly confused by dev_pagemap
backed mappings. The recovery code has specific enabling for several
possible page states and needs new enabling to handle poison in dax
mappings.

In order to support reliable reverse mapping of user space addresses:

1/ Add new locking in the memory_failure() rmap path to prevent races
that would typically be handled by the page lock.

2/ Since dev_pagemap pages are hidden from the page allocator and the
"compound page" accounting machinery, add a mechanism to determine the
size of the mapping that encompasses a given poisoned pfn.

3/ Given pmem errors can be repaired, change the speculatively accessed
poison protection, mce_unmap_kpfn(), to be reversible and otherwise
allow ongoing access from the kernel.

---

Dan Williams (11):
      device-dax: Convert to vmf_insert_mixed and vm_fault_t
      device-dax: Cleanup vm_fault de-reference chains
      device-dax: Enable page_mapping()
      device-dax: Set page->index
      filesystem-dax: Set page->index
      mm, madvise_inject_error: Let memory_failure() optionally take a page reference
      x86, memory_failure: Introduce {set,clear}_mce_nospec()
      mm, memory_failure: Pass page size to kill_proc()
      mm, memory_failure: Fix page->mapping assumptions relative to the page lock
      mm, memory_failure: Teach memory_failure() about dev_pagemap pages
      libnvdimm, pmem: Restore page attributes when clearing errors


 arch/x86/include/asm/set_memory.h         |   29 ++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   15 --
 arch/x86/kernel/cpu/mcheck/mce.c          |   38 -----
 drivers/dax/device.c                      |   97 ++++++++-----
 drivers/nvdimm/pmem.c                     |   26 ++++
 drivers/nvdimm/pmem.h                     |   13 ++
 fs/dax.c                                  |   16 ++
 include/linux/huge_mm.h                   |    5 -
 include/linux/mm.h                        |    1 
 include/linux/set_memory.h                |   14 ++
 mm/huge_memory.c                          |    4 -
 mm/madvise.c                              |   18 ++
 mm/memory-failure.c                       |  209 ++++++++++++++++++++++++++---
 13 files changed, 366 insertions(+), 119 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
