Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/3] mm, x86: Fix ioremap RAM check interfaces
Date: Fri, 19 Jun 2015 15:44:02 -0600
Message-Id: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org
Cc: travis@sgi.com, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ioremap() checks if a target range is RAM and fails the request
if true.  There are multiple issues in the iormap RAM check
interfaces.

 1. region_is_ram() does not work at all.
 2. The RAM checks, region_is_ram() and __ioremap_caller() via
    walk_system_ram_range(), are redundant.
 3. walk_system_ram_range() requires the RAM ranges page-aligned
    in the resource table.  This restriction has allowed multiple
    ioremap calls to setup_data, which is not page-aligned.

This patchset solves issue 1 and 2.  Issue 3 is not addressed in
this patchset, but is taken into the account that ioremap continues
to allow such callers until it is addressed.

---
Toshi Kani (3):
  1/3 mm, x86: Fix warning in ioremap RAM check
  2/3 mm, x86: Remove region_is_ram() call from ioremap
  3/3 mm: Fix bugs in region_is_ram()

---
 arch/x86/mm/ioremap.c | 23 ++++++-----------------
 kernel/resource.c     |  6 +++---
 2 files changed, 9 insertions(+), 20 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
