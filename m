From: Xiong Zhou <xzhou@redhat.com>
Subject: fsx tests on DAX started to fail with msync failure on 0307 -next
 tree
Date: Tue, 14 Mar 2017 10:56:42 +0800
Message-ID: <20170314025642.nwpf7zxbc6655gum@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: linux-nvdimm@ml01.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-nvdimm@lists.01.org

Hi,

xfstests cases:
generic/075 generic/112 generic/127 generic/231 generic/263

fail with DAX, pass without it. Both xfs and ext4.

It was okay on 0306 -next tree.

+ ./check generic/075
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-dl360g9-12 4.11.0-rc1-linux-next-5be4921-next-20170310
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /daxsch

generic/075 4s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/075.out.bad)
    --- tests/generic/075.out	2016-12-13 14:38:25.984557426 +0800
    +++ /root/xfstests/results//generic/075.out.bad	2017-03-14 10:40:23.083052839 +0800
    @@ -4,15 +4,4 @@
     -----------------------------------------------
     fsx.0 : -d -N numops -S 0
     -----------------------------------------------
    -
    ------------------------------------------------
    -fsx.1 : -d -N numops -S 0 -x
    ------------------------------------------------
    ...
    (Run 'diff -u tests/generic/075.out /root/xfstests/results//generic/075.out.bad'  to see the entire diff)
..

$ diff -u xfstests/tests/generic/075.out /root/xfstests/results//generic/075.out.bad
--- xfstests/tests/generic/075.out	2016-12-13 14:38:25.984557426 +0800
+++ /root/xfstests/results//generic/075.out.bad	2017-03-14 10:40:23.083052839 +0800
@@ -4,15 +4,4 @@
 -----------------------------------------------
 fsx.0 : -d -N numops -S 0
 -----------------------------------------------
-
------------------------------------------------
-fsx.1 : -d -N numops -S 0 -x
------------------------------------------------
-
------------------------------------------------
-fsx.2 : -d -N numops -l filelen -S 0
------------------------------------------------
-
------------------------------------------------
-fsx.3 : -d -N numops -l filelen -S 0 -x
------------------------------------------------
+    fsx (-d -N 1000 -S 0) failed, 0 - compare /root/xfstests/results//generic/075.0.{good,bad,fsxlog}

$ diff -u /root/xfstests/results//generic/075.0.{good,fsxlog} | tail -20
-03cb30 f903 da03 1103 7503 5403 8903 9f03 6b03
-03cb40 bb03 fb03 5603 7e03 c503 ca03 0103 9603
-03cb50 7f03 7c03 0c03 5103 ed03 dc03 a403 5c03
-03cb60 5403 b903 4403 3c03 4b03 a903 2303 1a03
-03cb70 2b03 5f03 fd03 ee03 1303 9703 2903 d303
-03cb80 4e03 9903 f903 8003 b803 2503 2203 c903
-03cb90 6803 7a03 0f03 6303 de03 ba03 6e03 6503
-03cba0 db03
-03cba2
+skipping zero size read
+skipping insert range behind EOF
+3 mapwrite	0x2e836 thru	0x3cba1	(0xe36c bytes)
+domapwrite: msync: Invalid argument
+LOG DUMP (3 total operations):
+1(  1 mod 256): SKIPPED (no operation)
+2(  2 mod 256): SKIPPED (no operation)
+3(  3 mod 256): MAPWRITE 0x2e836 thru 0x3cba1	(0xe36c bytes)
+Log of operations saved to "075.0.fsxops"; replay with --replay-ops
+Correct content saved for comparison
+(maybe hexdump "075.0" vs "075.0.fsxgood")

https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/generic/075
https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/ltp/fsx.c
