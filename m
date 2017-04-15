Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2B9E2194EB6E
 for <linux-nvdimm@lists.01.org>; Sat, 15 Apr 2017 10:12:58 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id x184so25447981oia.1
 for <linux-nvdimm@lists.01.org>; Sat, 15 Apr 2017 10:12:58 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 15 Apr 2017 10:12:57 -0700
Message-ID: <CAPcyv4gmS18ET_=R0p-V+Hfd1Qi4Nw2kNrRSdxqBg+HJCYtUWw@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for 4.11-rc7
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive:

A small crop of lockdep, sleeping while atomic, and other fixes /
band-aids in advance of the full-blown reworks targeting the next
merge window. The largest change here is "libnvdimm: fix blk free
space accounting" which deletes a pile of buggy code that better
testing would have caught before merging. The next change that is
borderline too big for a late rc is switching the device-dax locking
from rcu to srcu, I couldn't think of a smaller way to make that fix.

The __copy_user_nocache fix will have a full replacement in 4.12 to
move those pmem special case considerations into the pmem driver. The
"libnvdimm: band aid btt vs clear poison locking" commit admits that
our error clearing support for btt went in broken, so we just disable
it in 4.11 and -stable. A replacement / full fix is in the pipeline
for 4.12

Some of these would have been caught earlier had
CONFIG_DEBUG_ATOMIC_SLEEP been enabled on my development station. I
wonder if we should have:

config DEBUG_ATOMIC_SLEEP
        default PROVE_LOCKING

...since I mistakenly thought I got both with CONFIG_PROVE_LOCKING=y.

These have received a build success notification from the 0day robot,
and some have appeared in a -next release with no reported issues.

---

The following changes since commit c02ed2e75ef4c74e41e421acb4ef1494671585e8:

  Linux 4.11-rc4 (2017-03-26 14:15:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 11e63f6d920d6f2dfd3cd421e939a4aec9a58dcd:

  x86, pmem: fix broken __copy_user_nocache cache-bypass assumptions
(2017-04-12 13:45:18 -0700)

----------------------------------------------------------------
Dan Williams (6):
      acpi, nfit, libnvdimm: fix interleave set cookie calculation
(64-bit comparison)
      libnvdimm: fix blk free space accounting
      libnvdimm: fix reconfig_mutex, mmap_sem, and jbd2_handle lockdep splat
      libnvdimm: band aid btt vs clear poison locking
      device-dax: switch to srcu, fix rcu_read_lock() vs pte allocation
      x86, pmem: fix broken __copy_user_nocache cache-bypass assumptions

 arch/x86/include/asm/pmem.h | 42 ++++++++++++++++++-------
 drivers/acpi/nfit/core.c    |  6 +++-
 drivers/dax/Kconfig         |  1 +
 drivers/dax/dax.c           | 13 ++++----
 drivers/nvdimm/bus.c        |  6 ++++
 drivers/nvdimm/claim.c      | 10 +++++-
 drivers/nvdimm/dimm_devs.c  | 77 +++++++--------------------------------------
 7 files changed, 70 insertions(+), 85 deletions(-)

commit b03b99a329a14b7302f37c3ea6da3848db41c8c5
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Mar 27 21:53:38 2017 -0700

    acpi, nfit, libnvdimm: fix interleave set cookie calculation
(64-bit comparison)

    While reviewing the -stable patch for commit 86ef58a4e35e "nfit,
    libnvdimm: fix interleave set cookie calculation" Ben noted:

        "This is returning an int, thus it's effectively doing a 32-bit
         comparison and not the 64-bit comparison you say is needed."

    Update the compare operation to be immune to this integer demotion problem.

    Cc: <stable@vger.kernel.org>
    Cc: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
    Fixes: 86ef58a4e35e ("nfit, libnvdimm: fix interleave set cookie
calculation")
    Reported-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fe514739d8538783749d3ce72f78e5a999ea5668
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Apr 4 15:08:36 2017 -0700

    libnvdimm: fix blk free space accounting

    Commit a1f3e4d6a0c3 "libnvdimm, region: update nd_region_available_dpa()
    for multi-pmem support" reworked blk dpa (DIMM Physical Address)
    accounting to comprehend multiple pmem namespace allocations aliasing
    with a given blk-dpa range.

    The following call trace is a result of failing to account for allocated
    blk capacity.

     WARNING: CPU: 1 PID: 2433 at
tools/testing/nvdimm/../../../drivers/nvdimm/names
    4 size_store+0x6f3/0x930 [libnvdimm]
     nd_region region5: allocation underrun: 0x0 of 0x1000000 bytes
     [..]
     Call Trace:
      dump_stack+0x86/0xc3
      __warn+0xcb/0xf0
      warn_slowpath_fmt+0x5f/0x80
      size_store+0x6f3/0x930 [libnvdimm]
      dev_attr_store+0x18/0x30

    If a given blk-dpa allocation does not alias with any pmem ranges then
    the full allocation should be accounted as busy space, not the size of
    the current pmem contribution to the region.

    The thinkos that led to this confusion was not realizing that the struct
    resource management is already guaranteeing no collisions between pmem
    allocations and blk allocations on the same dimm. Also, we do not try to
    support blk allocations in aliased pmem holes.

    This patch also fixes a case where the available blk goes negative.

    Cc: <stable@vger.kernel.org>
    Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update
nd_region_available_dpa() for multi-pmem support").
    Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
    Reported-by: Dave Jiang <dave.jiang@intel.com>
    Reported-by: Vishal Verma <vishal.l.verma@intel.com>
    Tested-by: Dave Jiang <dave.jiang@intel.com>
    Tested-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0beb2012a1722633515c8aaa263c73449636c893
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Apr 7 09:47:24 2017 -0700

    libnvdimm: fix reconfig_mutex, mmap_sem, and jbd2_handle lockdep splat

    Holding the reconfig_mutex over a potential userspace fault sets up a
    lockdep dependency chain between filesystem-DAX and the libnvdimm ioctl
    path. Move the user access outside of the lock.

         [ INFO: possible circular locking dependency detected ]
         4.11.0-rc3+ #13 Tainted: G        W  O
         -------------------------------------------------------
         fallocate/16656 is trying to acquire lock:
          (&nvdimm_bus->reconfig_mutex){+.+.+.}, at:
[<ffffffffa00080b1>] nvdimm_bus_lock+0x21/0x30 [libnvdimm]
         but task is already holding lock:
          (jbd2_handle){++++..}, at: [<ffffffff813b4944>]
start_this_handle+0x104/0x460

        which lock already depends on the new lock.

        the existing dependency chain (in reverse order) is:

        -> #2 (jbd2_handle){++++..}:
                lock_acquire+0xbd/0x200
                start_this_handle+0x16a/0x460
                jbd2__journal_start+0xe9/0x2d0
                __ext4_journal_start_sb+0x89/0x1c0
                ext4_dirty_inode+0x32/0x70
                __mark_inode_dirty+0x235/0x670
                generic_update_time+0x87/0xd0
                touch_atime+0xa9/0xd0
                ext4_file_mmap+0x90/0xb0
                mmap_region+0x370/0x5b0
                do_mmap+0x415/0x4f0
                vm_mmap_pgoff+0xd7/0x120
                SyS_mmap_pgoff+0x1c5/0x290
                SyS_mmap+0x22/0x30
                entry_SYSCALL_64_fastpath+0x1f/0xc2

        -> #1 (&mm->mmap_sem){++++++}:
                lock_acquire+0xbd/0x200
                __might_fault+0x70/0xa0
                __nd_ioctl+0x683/0x720 [libnvdimm]
                nvdimm_ioctl+0x8b/0xe0 [libnvdimm]
                do_vfs_ioctl+0xa8/0x740
                SyS_ioctl+0x79/0x90
                do_syscall_64+0x6c/0x200
                return_from_SYSCALL_64+0x0/0x7a

        -> #0 (&nvdimm_bus->reconfig_mutex){+.+.+.}:
                __lock_acquire+0x16b6/0x1730
                lock_acquire+0xbd/0x200
                __mutex_lock+0x88/0x9b0
                mutex_lock_nested+0x1b/0x20
                nvdimm_bus_lock+0x21/0x30 [libnvdimm]
                nvdimm_forget_poison+0x25/0x50 [libnvdimm]
                nvdimm_clear_poison+0x106/0x140 [libnvdimm]
                pmem_do_bvec+0x1c2/0x2b0 [nd_pmem]
                pmem_make_request+0xf9/0x270 [nd_pmem]
                generic_make_request+0x118/0x3b0
                submit_bio+0x75/0x150

    Cc: <stable@vger.kernel.org>
    Fixes: 62232e45f4a2 ("libnvdimm: control (ioctl) messages for
nvdimm_bus and nvdimm devices")
    Cc: Dave Jiang <dave.jiang@intel.com>
    Reported-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4aa5615e080a9855e607accc75b07ab79b252dde
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Apr 7 12:25:52 2017 -0700

    libnvdimm: band aid btt vs clear poison locking

    The following warning results from holding a lane spinlock,
    preempt_disable(), or the btt map spinlock and then trying to take the
    reconfig_mutex to walk the poison list and potentially add new entries.

     BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:747
     in_atomic(): 1, irqs_disabled(): 0, pid: 17159, name: dd
     [..]
     Call Trace:
      dump_stack+0x85/0xc8
      ___might_sleep+0x184/0x250
      __might_sleep+0x4a/0x90
      __mutex_lock+0x58/0x9b0
      ? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
      ? __nvdimm_bus_badblocks_clear+0x2f/0x60 [libnvdimm]
      ? acpi_nfit_forget_poison+0x79/0x80 [nfit]
      ? _raw_spin_unlock+0x27/0x40
      mutex_lock_nested+0x1b/0x20
      nvdimm_bus_lock+0x21/0x30 [libnvdimm]
      nvdimm_forget_poison+0x25/0x50 [libnvdimm]
      nvdimm_clear_poison+0x106/0x140 [libnvdimm]
      nsio_rw_bytes+0x164/0x270 [libnvdimm]
      btt_write_pg+0x1de/0x3e0 [nd_btt]
      ? blk_queue_enter+0x30/0x290
      btt_make_request+0x11a/0x310 [nd_btt]
      ? blk_queue_enter+0xb7/0x290
      ? blk_queue_enter+0x30/0x290
      generic_make_request+0x118/0x3b0

    As a minimal fix, disable error clearing when the BTT is enabled for the
    namespace. For the final fix a larger rework of the poison list locking
    is needed.

    Note that this is not a problem in the blk case since that path never
    calls nvdimm_clear_poison().

    Cc: <stable@vger.kernel.org>
    Fixes: 82bf1037f2ca ("libnvdimm: check and clear poison before
writing to pmem")
    Cc: Dave Jiang <dave.jiang@intel.com>
    [jeff: dynamically disable error clearing in the btt case]
    Suggested-by: Jeff Moyer <jmoyer@redhat.com>
    Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
    Reported-by: Vishal Verma <vishal.l.verma@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 956a4cd2c957acf638ff29951aabaa9d8e92bbc2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Apr 7 16:42:08 2017 -0700

    device-dax: switch to srcu, fix rcu_read_lock() vs pte allocation

    The following warning triggers with a new unit test that stresses the
    device-dax interface.

     ===============================
     [ ERR: suspicious RCU usage.  ]
     4.11.0-rc4+ #1049 Tainted: G           O
     -------------------------------
     ./include/linux/rcupdate.h:521 Illegal context switch in RCU
read-side critical section!

     other info that might help us debug this:

     rcu_scheduler_active = 2, debug_locks = 0
     2 locks held by fio/9070:
      #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8d0739d7>]
__do_page_fault+0x167/0x4f0
      #1:  (rcu_read_lock){......}, at: [<ffffffffc03fbd02>]
dax_dev_huge_fault+0x32/0x620 [dax]

     Call Trace:
      dump_stack+0x86/0xc3
      lockdep_rcu_suspicious+0xd7/0x110
      ___might_sleep+0xac/0x250
      __might_sleep+0x4a/0x80
      __alloc_pages_nodemask+0x23a/0x360
      alloc_pages_current+0xa1/0x1f0
      pte_alloc_one+0x17/0x80
      __pte_alloc+0x1e/0x120
      __get_locked_pte+0x1bf/0x1d0
      insert_pfn.isra.70+0x3a/0x100
      ? lookup_memtype+0xa6/0xd0
      vm_insert_mixed+0x64/0x90
      dax_dev_huge_fault+0x520/0x620 [dax]
      ? dax_dev_huge_fault+0x32/0x620 [dax]
      dax_dev_fault+0x10/0x20 [dax]
      __do_fault+0x1e/0x140
      __handle_mm_fault+0x9af/0x10d0
      handle_mm_fault+0x16d/0x370
      ? handle_mm_fault+0x47/0x370
      __do_page_fault+0x28c/0x4f0
      trace_do_page_fault+0x58/0x2a0
      do_async_page_fault+0x1a/0xa0
      async_page_fault+0x28/0x30

    Inserting a page table entry may trigger an allocation while we are
    holding a read lock to keep the device instance alive for the duration
    of the fault. Use srcu for this keep-alive protection.

    Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 11e63f6d920d6f2dfd3cd421e939a4aec9a58dcd
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Apr 6 09:04:31 2017 -0700

    x86, pmem: fix broken __copy_user_nocache cache-bypass assumptions

    Before we rework the "pmem api" to stop abusing __copy_user_nocache()
    for memcpy_to_pmem() we need to fix cases where we may strand dirty data
    in the cpu cache. The problem occurs when copy_from_iter_pmem() is used
    for arbitrary data transfers from userspace. There is no guarantee that
    these transfers, performed by dax_iomap_actor(), will have aligned
    destinations or aligned transfer lengths. Backstop the usage
    __copy_user_nocache() with explicit cache management in these unaligned
    cases.

    Yes, copy_from_iter_pmem() is now too big for an inline, but addressing
    that is saved for a later patch that moves the entirety of the "pmem
    api" into the pmem driver directly.

    Fixes: 5de490daec8b ("pmem: add copy_from_iter_pmem() and clear_pmem()")
    Cc: <stable@vger.kernel.org>
    Cc: <x86@kernel.org>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jeff Moyer <jmoyer@redhat.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Matthew Wilcox <mawilcox@microsoft.com>
    Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
