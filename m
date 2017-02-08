From: Xiong Zhou <xzhou@redhat.com>
Subject: [PATCH v6 0/2]  mmap dio and DAX
Date: Wed,  8 Feb 2017 12:11:16 +0800
Message-ID: <1486527078-11173-1-git-send-email-xzhou@redhat.com>
References: <20170206191717.GB12290@linux.intel.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170206191717.GB12290@linux.intel.com>
Sender: fstests-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, fstests@vger.kernel.org
Cc: linux-nvdimm@ml01.01.org, jmoyer@redhat.com, eguan@redhat.com, Xiong Zhou <xzhou@redhat.com>
List-Id: linux-nvdimm@lists.01.org

Hi Ross and all,

After adding some initialization of test files, I've
got different test results that the write call succeeds
while the following read call fails.

Please help test and review, Thanks!

-----
common/rc         : requires SCRATCH_DEV support DAX
src/t_mmap_dio.c  : intro mmap and O_DIRECT rw through files
tests/generic/405 : IO between DAX/non-DAX mountpoints
tests/xfs/138     : IO between DAX/non-DAX xfs files(per-inode flag)

v2 :
  Merge helper function changes into the first patch;
  Rewrite _require_dax, check options for sure;
  Print msg in t_mmap_dio.c to show which test going wrong;
  Empty mount options and check after mount to ensure we
wont mount with wrong option;
  Remove unnecessary leading underscore and _fail;
  Use xfs_io instead of dd;
  Other minor fixes.

v3:
 close fds in C test programme for clean up.

v4:
 Test both buffered and O_DIRECT IO;
 Fix arg numbers in C test programme;
 Fix fs options check after mount.
 Cc Jeff Moyer since this test is based on his code.
 (Sorry for the late cc!)

v5:
 Mainly from Ross Zwisler <ross.zwisler@linux.intel.com>
 Add mkfs options to make fs 2M aligned, to hit PMD faults;
 Use falloc instead of pwrite to init test file aviding 4k
alignment;
 64M test file instead of 1G;
 Bumping test seq numners;
 Other minor fixes.

v6:
 Test file size increase to 128M;
 Add fsync after write in t_mmap_dio.c;
 Split sub tests in both cases, re-initialize test files
before every sub test. This change reveals the new read
failure issue.

Test status:
  Both cases not run on normal block device;
  Both cases not run on ext2/3 fs(no falloc);
  Both cases PASS on memory-mode nvdimm devices;
  DIO in both cases FAIL on brd based ramdisk with:
  DIO in both cases FAIL on raw-mode nvdimm devices with:
    +read(Bad address) len 1024 dio dax to nondax
    +read(Bad address) len 4096 dio dax to nondax
    +read(Bad address) len 16777216 dio dax to nondax
    +read(Bad address) len 67108864 dio dax to nondax
  I've reported this as an issue:
  https://lists.01.org/pipermail/linux-nvdimm/2017-February/008781.html


Xiong Zhou (2):
  xfs: test per-inode DAX flag by IO
  generic: test mmap io through DAX and non-DAX

 .gitignore            |   1 +
 common/rc             |  13 +++++
 src/Makefile          |   2 +-
 src/t_mmap_dio.c      | 111 +++++++++++++++++++++++++++++++++++
 tests/generic/407     | 152 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/407.out |   2 +
 tests/generic/group   |   1 +
 tests/xfs/196         | 158 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/196.out     |   2 +
 tests/xfs/group       |   1 +
 10 files changed, 442 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_dio.c
 create mode 100755 tests/generic/407
 create mode 100644 tests/generic/407.out
 create mode 100755 tests/xfs/196
 create mode 100644 tests/xfs/196.out

-- 
1.8.3.1
