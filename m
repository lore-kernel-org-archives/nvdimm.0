From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/2] mmap dio and DAX
Date: Fri, 20 Jan 2017 14:15:48 +0800
Message-ID: <1484892950-25178-1-git-send-email-xzhou@redhat.com>
References: <1484878888-11483-1-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1484878888-11483-1-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

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

Test status:
  Both cases not run on normal block device;
  Both cases PASS on ramdisk based pmem devices;
  DIO in both cases FAIL on brd based ramdisk with:
  DIO in both cases FAIL on nvdimm devices with:
    +write(Bad address) len 1024 dio dax to nondax
    +write(Bad address) len 4096 dio dax to nondax
    +write(Bad address) len 16777216 dio dax to nondax
    +write(Bad address) len 67108864 dio dax to nondax

  I've reported this to nvdimm list.
  https://lists.01.org/pipermail/linux-nvdimm/2017-January/008600.html

Xiong Zhou (2):
  xfs: test per-inode DAX flag by IO
  generic: test mmap io through DAX and non-DAX

 .gitignore            |   1 +
 common/rc             |  13 ++++++
 src/Makefile          |   2 +-
 src/t_mmap_dio.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/405     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/405.out |   2 +
 tests/generic/group   |   1 +
 tests/xfs/138         | 116 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/138.out     |   2 +
 tests/xfs/group       |   1 +
 10 files changed, 361 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_dio.c
 create mode 100755 tests/generic/405
 create mode 100644 tests/generic/405.out
 create mode 100755 tests/xfs/138
 create mode 100644 tests/xfs/138.out

-- 
1.8.3.1
