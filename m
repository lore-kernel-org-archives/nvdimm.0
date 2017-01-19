From: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] xfs: test per-inode DAX flag by IO
Date: Thu, 19 Jan 2017 12:24:01 +0800
Message-ID: <20170119042401.GS1859@eguan.usersys.redhat.com>
References: <1484708826-23529-1-git-send-email-xzhou@redhat.com>
 <1484708826-23529-4-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484708826-23529-4-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Jan 18, 2017 at 11:07:05AM +0800, Xiong Zhou wrote:
> We do mmap and O_DIRECT read/write, through files
> with and without DAX flag.
> 
> Signed-off-by: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I think patch 1/4 and 2/4 could be folded into this patch, where the new
helper and test program are used for the first time.

> ---
>  tests/xfs/138     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/138.out |   2 ++
>  tests/xfs/group   |   1 +
>  3 files changed, 108 insertions(+)
>  create mode 100755 tests/xfs/138
>  create mode 100644 tests/xfs/138.out
> 
> diff --git a/tests/xfs/138 b/tests/xfs/138
> new file mode 100755
> index 0000000..4b965b3
> --- /dev/null
> +++ b/tests/xfs/138
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# FS QA Test 138
> +#
> +# Test per-inode DAX flag by mmap direct IO.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch_dax
> +_require_test_program "feature"

Need _require_test_program "t_mmap_dio"

> +_require_xfs_io_command "chattr" "+/-x"
> +
> +# $1 mmap read/write size
> +_dax_flag_mmap_dio()

Name local functions without leading underscore, it's reserved for
common helpers.

> +{
> +	# both dax
> +	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_s
> +	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_d
> +	src/t_mmap_dio $SCRATCH_MNT/tf_s $SCRATCH_MNT/tf_d $1
> +
> +	# from non dax to dax
> +	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_s
> +	src/t_mmap_dio $SCRATCH_MNT/tf_s $SCRATCH_MNT/tf_d $1
> +
> +	# from dax to non dax
> +	$XFS_IO_PROG -c "chattr +x" $SCRATCH_MNT/tf_s
> +	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_d
> +	src/t_mmap_dio $SCRATCH_MNT/tf_s $SCRATCH_MNT/tf_d $1
> +
> +	# both non dax
> +	$XFS_IO_PROG -c "chattr -x" $SCRATCH_MNT/tf_s
> +	src/t_mmap_dio $SCRATCH_MNT/tf_s $SCRATCH_MNT/tf_d $1
> +}
> +
> +_do_tests()
> +{
> +	# less than page size
> +	_dax_flag_mmap_dio 1024
> +	# page size
> +	_dax_flag_mmap_dio `src/feature -s`
> +	# bigger sizes, for PMD faults
> +	_dax_flag_mmap_dio 16777216
> +	_dax_flag_mmap_dio 67108864
> +}
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +
> +# mount with dax option
> +_scratch_mount "-o dax" >> $seqres.full 2>&1 || \
> +	_fail "mount -o dax failed"

No need to _fail, test would fail if mkfs & mount failed.

> +
> +dd if=/dev/zero of=$SCRATCH_MNT/tf_s bs=4k count=256k > /dev/null 2>&1
> +dd if=/dev/zero of=$SCRATCH_MNT/tf_d bs=4k count=256k > /dev/null 2>&1
> +
> +_do_tests
> +_scratch_unmount >> $seqres.full 2>&1 || _fail "umount failed"
> +
> +# mount again wo/ dax option
> +_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
> +_do_tests
> +_scratch_unmount >> $seqres.full 2>&1

No need to unmount, test harness does this for you after test :)

Thanks,
Eryu

> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/xfs/138.out b/tests/xfs/138.out
> new file mode 100644
> index 0000000..614ba1a
> --- /dev/null
> +++ b/tests/xfs/138.out
> @@ -0,0 +1,2 @@
> +QA output created by 138
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 3c5884c..4b406c0 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -135,6 +135,7 @@
>  135 auto logprint quick v2log
>  136 attr2
>  137 auto metadata v2log
> +138 auto attr quick
>  139 auto quick clone
>  140 auto clone
>  141 auto log metadata
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
