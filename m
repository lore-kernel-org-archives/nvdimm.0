Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE36121E95E0D
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:36:54 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v7 0/6] BTT error clearing rework
Date: Wed, 30 Aug 2017 19:35:57 -0600
Message-Id: <20170831013603.16997-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

changes in v7:
 - There were cases where any problem while attempting to clear errors
   would result in the BTT thread doing IO to be locked in an infinite
   retry loop. Fix those conditions by detecting any error in clearing
   and bailing on that write. (Toshi, Dan).

changes in v6:
 - Remove the refactoring patch where we move the namespace offset
   calculations to all call sites, instead add a helper for the final
   initial_offset calculation, and call it directly from btt_is_badblock

changes in v5:
 - Add patch 6 that refactors initial_offset calculations, and fix a bug
   that caused error clearing to be missed in some cases (Toshi)
   (I have a unit test for this that is mostly ready, but it depends
   in a better error injection capability in nfit_test, so I will send
   it out once that is ready).

Changes in v4:
 - move the deadlock fix to before enabling the BTT error clear paths (Dan)
 - No need for an error lock per freelist entry, just have one per arena (Dan)

Changes in v3:
 - Change the dynamically allocated (during IO) zerobuf to the kernel's
   ZERO_PAGE for error clearing (patch 5) (Dan).
 - Move the NOIO fixes a level down into nvdimm_clear_poison since both
   btt and pmem poison clearing goes through that (Dan).

Changes in v2:
 - Drop the ACPI allocation change patch. Instead use
   memalloc_noio_{save,restore} to set the GFP_NOIO flag around anything
   that can be expected to call into ACPI for clearing errors. (Rafael, Dan).

Clearing errors or badblocks during a BTT write requires sending an ACPI
DSM, which means potentially sleeping. Since a BTT IO happens in atomic
context (preemption disabled, spinlocks may be held), we cannot perform
error clearing in the course of an IO. Due to this error clearing for
BTT IOs has hitherto been disabled.

This series fixes these problems by moving the error clearing out of
the atomic sections in the BTT.

Also fix a potential deadlock that can occur while clearing errors
from either BTT or pmem due to memory allocations in the IO path.


Vishal Verma (6):
  btt: fix a missed NVDIMM_IO_ATOMIC case in the write path
  btt: refactor map entry operations with macros
  btt: ensure that flags were also unchanged during a map_read
  btt: cache sector_size in arena_info
  libnvdimm: fix potential deadlock while clearing errors
  libnvdimm, btt: rework error clearing

 drivers/nvdimm/btt.c   | 137 ++++++++++++++++++++++++++++++++++++++++++-------
 drivers/nvdimm/btt.h   |  11 ++++
 drivers/nvdimm/bus.c   |   6 +++
 drivers/nvdimm/claim.c |   9 +---
 4 files changed, 136 insertions(+), 27 deletions(-)

-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
