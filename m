Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C86B81FEB
 for <linux-nvdimm@lists.01.org>; Wed,  8 Feb 2017 11:12:20 -0800 (PST)
Date: Wed, 8 Feb 2017 12:11:56 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: WARN_ON_ONCE() during generic/270
Message-ID: <20170208191156.GA19071@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

I hit the following WARN_ON_ONCE() during generic/270 with xfs (passed through
kasan_symbolize.py):

  run fstests generic/270 at 2017-02-08 10:56:07
  XFS (pmem0p2): Unmounting Filesystem
  XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
  XFS (pmem0p2): Mounting V5 Filesystem
  XFS (pmem0p2): Ending clean mount
  XFS (pmem0p2): Quotacheck needed: Please wait.
  XFS (pmem0p2): Quotacheck: Done.
  XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
  ------------[ cut here ]------------
  WARNING: CPU: 7 PID: 23652 at fs/xfs/libxfs/xfs_bmap.c:5981[<      none      >] xfs_bmse_shift_one+0x3da/0x4c0 fs/xfs/libxfs/xfs_bmap.c:5981
  Modules linked in: dax_pmem nd_pmem dax nd_btt nd_e820 libnvdimm
  CPU: 4 PID: 23652 Comm: 23288.fsstress. Not tainted 4.10.0-rc7-00065-g926af627 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
  Call Trace:
  [<     inline     >] __dump_stack lib/dump_stack.c:15
  [<      none      >] dump_stack+0x86/0xc3 lib/dump_stack.c:51
  [<      none      >] __warn+0xcb/0xf0 kernel/panic.c:547
  [<      none      >] warn_slowpath_null+0x1d/0x20 kernel/panic.c:582
  [<      none      >] xfs_bmse_shift_one+0x3da/0x4c0 fs/xfs/libxfs/xfs_bmap.c:5981
  [<      none      >] xfs_bmap_shift_extents+0x305/0x490 fs/xfs/libxfs/xfs_bmap.c:6144
  [<      none      >] xfs_shift_file_space+0x25f/0x320 fs/xfs/xfs_bmap_util.c:1475
  [<      none      >] xfs_insert_file_space+0x5a/0x180 fs/xfs/xfs_bmap_util.c:1548
  [<      none      >] xfs_file_fallocate+0x34c/0x3b0 fs/xfs/xfs_file.c:844
   ?[<      none      >] rcu_sync_lockdep_assert+0x2f/0x60 kernel/rcu/sync.c:68
  [<      none      >] vfs_fallocate+0x15a/0x230 fs/open.c:320
  [<     inline     >] SYSC_fallocate fs/open.c:343
  [<      none      >] SyS_fallocate+0x48/0x80 fs/open.c:337
  [<      none      >] entry_SYSCALL_64_fastpath+0x1f/0xc2 /home/rzwisler/project/linux/arch/x86/entry/entry_64.S:204
  RIP: 0033:0x7f34dc4ff0ca
  RSP: 002b:00007ffcffa58058 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
  RAX: ffffffffffffffda RBX: 0000000000000166 RCX: 00007f34dc4ff0ca
  RDX: 00000000000ba000 RSI: 0000000000000020 RDI: 0000000000000003
  RBP: 0000000000000003 R08: 000000000000007b R09: 00007ffcffa5807c
  R10: 00000000000bc000 R11: 0000000000000246 R12: 00007f34d8000de0
  R13: 00000000ffffffff R14: 000000000000af4a R15: 0000000000000000
  ---[ end trace e24f5d4cbfc216f6 ]---

This trace is with the current linux/master:

commit 926af6273fc6 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")

though I initially his this issue with a v4.9 kernel.  My test setup is a pair
of PMEM ramdisks made with the memmap command line parameter, and my
test filesystem is mounted with DAX.

This can be reproduced pretty easily by just running generic/270 in a
loop.

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
