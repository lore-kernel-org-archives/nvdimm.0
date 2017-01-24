From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 0/2] mmap dio and DAX
Date: Tue, 24 Jan 2017 15:28:55 -0700
Message-ID: <20170124222855.GA26631@linux.intel.com>
References: <1484878888-11483-1-git-send-email-xzhou@redhat.com>
 <1484892950-25178-1-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484892950-25178-1-git-send-email-xzhou@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: fstests@vger.kernel.org, jmoyer@redhat.com, ross.zwisler@linux.intel.com, eguan@redhat.com, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Jan 20, 2017 at 02:15:48PM +0800, Xiong Zhou wrote:
> common/rc         : requires SCRATCH_DEV support DAX
> src/t_mmap_dio.c  : intro mmap and O_DIRECT rw through files
> tests/generic/405 : IO between DAX/non-DAX mountpoints
> tests/xfs/138     : IO between DAX/non-DAX xfs files(per-inode flag)
> 
> v2 :
>   Merge helper function changes into the first patch;
>   Rewrite _require_dax, check options for sure;
>   Print msg in t_mmap_dio.c to show which test going wrong;
>   Empty mount options and check after mount to ensure we
> wont mount with wrong option;
>   Remove unnecessary leading underscore and _fail;
>   Use xfs_io instead of dd;
>   Other minor fixes.
> 
> v3:
>  close fds in C test programme for clean up.
> 
> v4:
>  Test both buffered and O_DIRECT IO;
>  Fix arg numbers in C test programme;
>  Fix fs options check after mount.
>  Cc Jeff Moyer since this test is based on his code.
>  (Sorry for the late cc!)
> 
> Test status:
>   Both cases not run on normal block device;
>   Both cases PASS on ramdisk based pmem devices;
>   DIO in both cases FAIL on brd based ramdisk with:
>   DIO in both cases FAIL on nvdimm devices with:
>     +write(Bad address) len 1024 dio dax to nondax
>     +write(Bad address) len 4096 dio dax to nondax
>     +write(Bad address) len 16777216 dio dax to nondax
>     +write(Bad address) len 67108864 dio dax to nondax
> 
>   I've reported this to nvdimm list.
>   https://lists.01.org/pipermail/linux-nvdimm/2017-January/008600.html
> 
> Xiong Zhou (2):
>   xfs: test per-inode DAX flag by IO
>   generic: test mmap io through DAX and non-DAX
> 
>  .gitignore            |   1 +
>  common/rc             |  13 ++++++
>  src/Makefile          |   2 +-
>  src/t_mmap_dio.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/405     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/405.out |   2 +
>  tests/generic/group   |   1 +
>  tests/xfs/138         | 116 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/138.out     |   2 +
>  tests/xfs/group       |   1 +
>  10 files changed, 361 insertions(+), 1 deletion(-)
>  create mode 100644 src/t_mmap_dio.c
>  create mode 100755 tests/generic/405
>  create mode 100644 tests/generic/405.out
>  create mode 100755 tests/xfs/138
>  create mode 100644 tests/xfs/138.out
> 
> -- 
> 1.8.3.1

I just wanted to let you know that I'm testing with these new xfstests right
now, and so far I've been unable to successfully get any PMD faults.  I'm
looking into why that is right now, and should hopefully have some changes so
we can do both PTE and PMD testing with this set.

Also, it looks like the test number "generic/405" was already used in
xfstests/master by this commit:

66768bc generic/405: test mkfs against thin provision device

So this may need to be generic/406. :)
