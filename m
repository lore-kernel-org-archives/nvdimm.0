Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB5FA21290DE1
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jun 2019 12:52:45 -0700 (PDT)
From: Larry Bassel <larry.bassel@oracle.com>
Subject: [RFC PATCH v2 0/2] Share PMDs for FS/DAX on x86
Date: Fri,  7 Jun 2019 12:51:01 -0700
Message-Id: <1559937063-8323-1-git-send-email-larry.bassel@oracle.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: mike.kravetz@oracle.com, willy@infradead.org, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Changes from v1 to v2:

* Rebased on v5.2-rc3

* An incorrect reference to "page table entries" was fixed (pointed
out by Kirill Shutemov)

* Renamed CONFIG_ARCH_WANT_HUGE_PMD_SHARE
to CONFIG_ARCH_HAS_HUGE_PMD_SHARE instead of introducing
a new config option (suggested by Dan Williams)

* Removed some unnecessary #ifdef stubs (suggested by Matt Wilcox)

* A previously overlooked case involving mprotect() is now handled
properly (pointed out by Mike Kravetz)

---

This patchset implements sharing of page tables pointing
to 2MiB pages (PMDs) for FS/DAX on x86.

Only shared mmapings of files (i.e. neither private mmapings nor
anonymous pages) are eligible for PMD sharing.

Due to the characteristics of DAX, this code is simpler and
less intrusive than the general case would be.

In our use case (high end Oracle database using DAX/XFS/PMEM/2MiB
pages) there would be significant memory savings.

A future system might have 6 TiB of PMEM on it and
there might be 10000 processes each mapping all of this 6 TiB.
Here the savings would be approximately
(6 TiB / 2 MiB) * 8 bytes (page table size) * 10000 = 240 GiB
(and these page tables themselves would probably be in
non-PMEM (ordinary RAM)).

There would also be a reduction in page faults because in
some cases the page fault has already been satisfied and
the page table entry has been filled in (and so the processes
after the first would not take a fault).

The code for detecting whether PMDs can be shared and
the implementation of sharing and unsharing is based
on, but somewhat different than that in mm/hugetlb.c,
though some of the code from this file could be reused and
thus was made non-static.

Larry Bassel (2):
  Rename CONFIG_ARCH_WANT_HUGE_PMD_SHARE to
    CONFIG_ARCH_HAS_HUGE_PMD_SHARE
  Implement sharing/unsharing of PMDs for FS/DAX

 arch/arm64/Kconfig          |   2 +-
 arch/arm64/mm/hugetlbpage.c |   2 +-
 arch/x86/Kconfig            |   2 +-
 include/linux/hugetlb.h     |   4 ++
 mm/huge_memory.c            |  37 +++++++++++++++
 mm/hugetlb.c                |  14 +++---
 mm/memory.c                 | 108 +++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 158 insertions(+), 11 deletions(-)

-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
