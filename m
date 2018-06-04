Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13D69210EFAFD
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 16:21:36 -0700 (PDT)
Subject: [PATCH v3 00/12] mm: Teach memory_failure() about ZONE_DEVICE pages
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 04 Jun 2018 16:11:39 -0700
Message-ID: <152815389835.39010.13253559944508110923.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Note: With this repost this series is now being actively revised during
the 4.18 merge window. Just holler if you want this to stop and wait for
4.19. Otherwise, this series completes the poison handling story for
pmem + dax with the other memcpy_mcsafe() changes that are going in this
cycle.

---

Changes since v2 [1]:
* Fix compilation failure in "device-dax: Enable page_mapping()". Update
  the function signature for __dev_dax_pud_fault() in the
  CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=n case. (0day Kbuild Robot)

* Prepare {reserve,free}_memtype() for decoy addresses

* Fix the set_mce_nospec() helper to use a decoy address. (Tony)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2018-June/016120.html

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

A side effect of this enabling is that MADV_HWPOISON becomes usable for
dax mappings, however the primary motivation is to allow the system to
survive userspace consumption of hardware-poison via dax. Specifically
the current behavior is:

    mce: Uncorrected hardware memory error in user-access at af34214200
    {1}[Hardware Error]: It has been corrected by h/w and requires no further action
    mce: [Hardware Error]: Machine check events logged
    {1}[Hardware Error]: event severity: corrected
    Memory failure: 0xaf34214: reserved kernel page still referenced by 1 users
    [..]
    Memory failure: 0xaf34214: recovery action for reserved kernel page: Failed
    mce: Memory error not recovered

...and with these changes:

    Injecting memory failure for pfn 0x20cb00 at process virtual address 0x7f763dd00000
    Memory failure: 0x20cb00: Killing dax-pmd:5421 due to hardware memory corruption
    Memory failure: 0x20cb00: recovery action for dax page: Recovered

---

Dan Williams (12):
      device-dax: Convert to vmf_insert_mixed and vm_fault_t
      device-dax: Cleanup vm_fault de-reference chains
      device-dax: Enable page_mapping()
      device-dax: Set page->index
      filesystem-dax: Set page->index
      mm, madvise_inject_error: Let memory_failure() optionally take a page reference
      x86/mm/pat: Prepare {reserve,free}_memtype() for "decoy" addresses
      x86/memory_failure: Introduce {set,clear}_mce_nospec()
      mm, memory_failure: Pass page size to kill_proc()
      mm, memory_failure: Fix page->mapping assumptions relative to the page lock
      mm, memory_failure: Teach memory_failure() about dev_pagemap pages
      libnvdimm, pmem: Restore page attributes when clearing errors


 arch/x86/include/asm/set_memory.h         |   42 ++++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   15 --
 arch/x86/kernel/cpu/mcheck/mce.c          |   38 -----
 arch/x86/mm/pat.c                         |   16 ++
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
 14 files changed, 395 insertions(+), 119 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
