Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DCCB203B992C
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 07:49:29 -0700 (PDT)
Subject: [PATCH 00/11] mm: Teach memory_failure() about ZONE_DEVICE pages
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 07:39:32 -0700
Message-ID: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: tony.luck@intel.com, Jan Kara <jack@suse.cz>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>, Souptick Joarder <jrdr.linux@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Wu Fengguang <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

As it stands, memory_failure() gets thoroughly confused by dev_pagemap
backed mappings. The recovery code has specific enabling for several
possible page states and needs new enabling to handle poison in dax
mappings.

In order to support reliable reverse mapping of user space addresses add
new locking in the fsdax implementation to prevent races between
page-address_space disassociation events and the rmap performed in the
memory_failure() path. Additionally, since dev_pagemap pages are hidden
from the page allocator, add a mechanism to determine the size of the
mapping that encompasses a given poisoned pfn. Lastly, since pmem errors
can be repaired, change the speculatively accessed poison protection,
mce_unmap_kpfn(), to be reversible and otherwise allow ongoing access
from the kernel.

---

Dan Williams (11):
      device-dax: convert to vmf_insert_mixed and vm_fault_t
      device-dax: cleanup vm_fault de-reference chains
      device-dax: enable page_mapping()
      device-dax: set page->index
      filesystem-dax: set page->index
      filesystem-dax: perform __dax_invalidate_mapping_entry() under the page lock
      mm, madvise_inject_error: fix page count leak
      x86, memory_failure: introduce {set,clear}_mce_nospec()
      mm, memory_failure: pass page size to kill_proc()
      mm, memory_failure: teach memory_failure() about dev_pagemap pages
      libnvdimm, pmem: restore page attributes when clearing errors


 arch/x86/include/asm/set_memory.h         |   29 ++++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   15 ---
 arch/x86/kernel/cpu/mcheck/mce.c          |   38 +-------
 drivers/dax/device.c                      |   91 ++++++++++++--------
 drivers/nvdimm/pmem.c                     |   26 ++++++
 drivers/nvdimm/pmem.h                     |   13 +++
 fs/dax.c                                  |  102 ++++++++++++++++++++--
 include/linux/huge_mm.h                   |    5 +
 include/linux/set_memory.h                |   14 +++
 mm/huge_memory.c                          |    4 -
 mm/madvise.c                              |   11 ++
 mm/memory-failure.c                       |  133 +++++++++++++++++++++++++++--
 12 files changed, 370 insertions(+), 111 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
