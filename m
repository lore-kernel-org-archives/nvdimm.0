Return-Path: <owner-linux-mm@kvack.org>
From: Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH, RFC 0/2] Share PMDs for FS/DAX on x86
Date: Thu,  9 May 2019 09:05:31 -0700
Message-Id: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
Sender: owner-linux-mm@kvack.org
To: mike.kravetz@oracle.com, willy@infradead.org, dan.j.williams@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Larry Bassel <larry.bassel@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

This patchset implements sharing of page table entries pointing
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
(and these page tables themselves would be in non-PMEM (ordinary RAM)).

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
  Add config option to enable FS/DAX PMD sharing.
  Implement sharing/unsharing of PMDs for FS/DAX.

 arch/x86/Kconfig        |   3 ++
 include/linux/hugetlb.h |   4 ++
 mm/huge_memory.c        |  32 ++++++++++++++
 mm/hugetlb.c            |  21 ++++++++--
 mm/memory.c             | 108 +++++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 163 insertions(+), 5 deletions(-)

-- 
1.8.3.1
