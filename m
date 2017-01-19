From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] mmap dio and DAX
Date: Thu, 19 Jan 2017 18:13:56 +0800
Message-ID: <1484820838-5098-1-git-send-email-xzhou@redhat.com>
References: <20170119055405.GT1859@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170119055405.GT1859-+7p9VZFSOIEFmhoHi+V13ACJwEvxM/w9@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

v2 :
  Merge helper function changes into the first patch;
  Rewrite _require_dax, check options for sure;
  Print msg in t_mmap_dio.c to show which test going wrong;
  Empty mount options and check after mount to ensure we
wont mount with wrong option;
  Remove unnecessary leading underscore and _fail;
  Use xfs_io instead of dd;
  Other minor fixes.

Test status:
  Both cases not run on normal block device;
  Both cases PASS on ramdisk based pmem devices;
  Both cases FAIL on nvdimm devices with:
    +write(Bad address) len 1024 dax to nondax
    +write(Bad address) len 4096 dax to nondax
    +write(Bad address) len 16777216 dax to nondax
    +write(Bad address) len 67108864 dax to nondax

Xiong Zhou (2):
  xfs: test per-inode DAX flag by IO
  generic: test mmap dio through DAX and non-DAX

 .gitignore            |   1 +
 common/rc             |  14 ++++++
 src/Makefile          |   2 +-
 src/t_mmap_dio.c      |  81 +++++++++++++++++++++++++++++++++++
 tests/generic/405     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/405.out |   2 +
 tests/generic/group   |   1 +
 tests/xfs/138         | 110 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/138.out     |   2 +
 tests/xfs/group       |   1 +
 10 files changed, 329 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_dio.c
 create mode 100755 tests/generic/405
 create mode 100644 tests/generic/405.out
 create mode 100755 tests/xfs/138
 create mode 100644 tests/xfs/138.out

-- 
1.8.3.1
