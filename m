Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20EF721951C86
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 00:47:30 -0700 (PDT)
Date: Wed, 26 Apr 2017 15:47:27 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 2/2] dax: add regression test for stale mmap reads
Message-ID: <20170426074727.GG26397@eguan.usersys.redhat.com>
References: <20170425205106.20576-1-ross.zwisler@linux.intel.com>
 <20170425205106.20576-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170425205106.20576-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 02:51:06PM -0600, Ross Zwisler wrote:
> This adds a regression test for the following kernel patch:
> 
>   dax: fix data corruption due to stale mmap reads
> 
> The above patch fixes an issue where users of DAX can suffer data
> corruption from stale mmap reads via the following sequence:
> 
> - open an mmap over a 2MiB hole
> 
> - read from a 2MiB hole, faulting in a 2MiB zero page
> 
> - write to the hole with write(3p).  The write succeeds but we incorrectly
>   leave the 2MiB zero page mapping intact.
> 
> - via the mmap, read the data that was just written.  Since the zero page
>   mapping is still intact we read back zeroes instead of the new data.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

I reproduced it now with 4.10 kernel, I think it was because I enalbed
KASAN on my 4.11-rc8 kernel. And the special mkfs options for ext4/xfs
are not needed either.

> ---
>  .gitignore            |  1 +
>  src/Makefile          |  2 +-
>  src/t_dax_stale_pmd.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/427     | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/427.out |  2 ++
>  tests/generic/group   |  1 +
>  6 files changed, 131 insertions(+), 1 deletion(-)
>  create mode 100644 src/t_dax_stale_pmd.c
>  create mode 100755 tests/generic/427
>  create mode 100644 tests/generic/427.out
> 
> diff --git a/.gitignore b/.gitignore
> index ded4a61..9664dc9 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -134,6 +134,7 @@
>  /src/renameat2
>  /src/t_rename_overwrite
>  /src/t_mmap_dio
> +/src/t_dax_stale_pmd
>  
>  # dmapi/ binaries
>  /dmapi/src/common/cmd/read_invis
> diff --git a/src/Makefile b/src/Makefile
> index abfd873..7e22b50 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -12,7 +12,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	godown resvtest writemod makeextents itrash rename \
>  	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
>  	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
> -	holetest t_truncate_self t_mmap_dio af_unix
> +	holetest t_truncate_self t_mmap_dio af_unix t_dax_stale_pmd
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/t_dax_stale_pmd.c b/src/t_dax_stale_pmd.c
> new file mode 100644
> index 0000000..59fbbe1
> --- /dev/null
> +++ b/src/t_dax_stale_pmd.c
> @@ -0,0 +1,59 @@
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <libgen.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +
> +#define MiB(a) ((a)*1024*1024)
> +
> +void err_exit(char *op)
> +{
> +	fprintf(stderr, "%s: %s\n", op, strerror(errno));
> +	exit(1);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	volatile int a __attribute__((__unused__));
> +	char *buffer = "HELLO WORLD!";
> +	char *data;
> +	int fd;
> +
> +	if (argc < 2) {
> +		printf("Usage: %s <pmem file>\n", basename(argv[0]));
> +		exit(0);
> +	}
> +
> +	fd = open(argv[1], O_RDWR);
> +	if (fd < 0)
> +		err_exit("fd");
> +
> +	data = mmap(NULL, MiB(2), PROT_READ, MAP_SHARED, fd, MiB(2));
> +
> +	/*
> +	 * This faults in a 2MiB zero page to satisfy the read.
> +	 * 'a' is volatile so this read doesn't get optimized out.
> +	 */
> +	a = data[0];
> +
> +	pwrite(fd, buffer, strlen(buffer), MiB(2));
> +
> +	/*
> +	 * Try and use the mmap to read back the data we just wrote with
> +	 * pwrite().  If the kernel bug is present the mapping from the 2MiB
> +	 * zero page will still be intact, and we'll read back zeros instead.
> +	 */
> +	if (strncmp(buffer, data, strlen(buffer))) {
> +		fprintf(stderr, "strncmp mismatch: '%s' vs '%s'\n", buffer,
> +				data);
> +		exit(1);
> +	}
> +
> +	close(fd);
> +	return 0;
> +}
> diff --git a/tests/generic/427 b/tests/generic/427
> new file mode 100755
> index 0000000..6e265a1
> --- /dev/null
> +++ b/tests/generic/427
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# FS QA Test 427
> +#
> +# This is a regression test for kernel patch:
> +#  dax: fix data corruption due to stale mmap reads
> +# created by Ross Zwisler <ross.zwisler@linux.intel.com>
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Intel Corporation.  All Rights Reserved.
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
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test_program "t_dax_stale_pmd"
> +_require_xfs_io_command "falloc"

I'm wondering if falloc is really needed? If not, this test could be run
with ext2/3 too. See below.

> +_require_user

This is not needed anymore.

> +
> +# real QA test starts here
> +
> +# ensure we have no pre-existing block allocations, so we get a hole
> +rm -f $TEST_DIR/testfile
> +$XFS_IO_PROG -f -c "falloc 0 4M" $TEST_DIR/testfile >> $seqres.full 2>&1

I found that 'xfs_io -fc "truncate 4M" $TEST_DIR/testfile' works too,
from the comments in test and kernel patch, if I understand correctly,
we only need to mmap un-allocated blocks, right?

If truncate(2) works too, I think we can move truncate operation to the
t_dax_stale_pmd program too, because the whole truncate && mmap && read
sequence are logically together, this also avoids the confusion on why
testfile is in 4M size.

Thanks,
Eryu

> +chmod 0644 $TEST_DIR/testfile
> +
> +src/t_dax_stale_pmd $TEST_DIR/testfile
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/427.out b/tests/generic/427.out
> new file mode 100644
> index 0000000..61295e5
> --- /dev/null
> +++ b/tests/generic/427.out
> @@ -0,0 +1,2 @@
> +QA output created by 427
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index f29009c..06f6e9d 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -429,3 +429,4 @@
>  424 auto quick
>  425 auto quick attr
>  426 auto quick exportfs
> +427 auto quick
> -- 
> 2.9.3
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
