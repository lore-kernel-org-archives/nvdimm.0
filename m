Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FA4C81EEA
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 15:47:19 -0800 (PST)
Subject: [PATCH 0/3] 1G transparent hugepage support for device dax
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 23 Jan 2017 16:47:18 -0700
Message-ID: <148521477073.31533.17781371321988910714.stgit@djiang5-desk3.ch.intel.com>
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
Cc: mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, vbabka@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

The following series implements support for 1G trasparent hugepage on
x86 for device dax. The bulk of the code was written by Mathew Wilcox
a while back supporting transparent 1G hugepage for fs DAX. I have
forward ported the relevant bits to 4.10-rc. The current submission has
only the necessary code to support device DAX.

---

Dave Jiang (1):
      dax: Support for transparent PUD pages for device DAX

Matthew Wilcox (2):
      mm,fs,dax: Change ->pmd_fault to ->huge_fault
      mm,x86: Add support for PUD-sized transparent hugepages


 arch/Kconfig                          |    3 
 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/paravirt.h       |   11 +
 arch/x86/include/asm/paravirt_types.h |    2 
 arch/x86/include/asm/pgtable-2level.h |   17 ++
 arch/x86/include/asm/pgtable-3level.h |   24 +++
 arch/x86/include/asm/pgtable.h        |  145 +++++++++++++++++++
 arch/x86/include/asm/pgtable_64.h     |   15 ++
 arch/x86/kernel/paravirt.c            |    1 
 arch/x86/mm/pgtable.c                 |   31 ++++
 drivers/dax/dax.c                     |   82 ++++++++---
 fs/dax.c                              |   43 ++++--
 fs/ext2/file.c                        |    2 
 fs/ext4/file.c                        |    6 -
 fs/xfs/xfs_file.c                     |   10 +
 fs/xfs/xfs_trace.h                    |    2 
 include/asm-generic/pgtable.h         |   75 +++++++++-
 include/asm-generic/tlb.h             |   14 ++
 include/linux/dax.h                   |    6 -
 include/linux/huge_mm.h               |   83 ++++++++++-
 include/linux/mm.h                    |   40 +++++
 include/linux/mmu_notifier.h          |   14 ++
 include/linux/pfn_t.h                 |    8 +
 mm/gup.c                              |    7 +
 mm/huge_memory.c                      |  249 +++++++++++++++++++++++++++++++++
 mm/memory.c                           |  102 ++++++++++++--
 mm/pagewalk.c                         |   20 +++
 mm/pgtable-generic.c                  |   14 ++
 28 files changed, 952 insertions(+), 75 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
