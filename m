From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] xfs: test per-inode DAX flag by IO
Date: Thu, 19 Jan 2017 13:49:25 -0700
Message-ID: <20170119204925.GB28456@linux.intel.com>
References: <20170119055405.GT1859@eguan.usersys.redhat.com>
 <1484820838-5098-1-git-send-email-xzhou@redhat.com>
 <1484820838-5098-2-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484820838-5098-2-git-send-email-xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Jan 19, 2017 at 06:13:57PM +0800, Xiong Zhou wrote:
> In a DAX mountpoint, do IO betwen files with and
> without DAX per-inode flag. We do mmap and O_DIRECT
> read/write IO in this case. Then test again in the
> same device without dax mountoption.
> 
> Add help _require_scratch_dax to make sure we can
> test DAX feature on SCRATCH_DEV.
> 
> Add mmap dio test programme to test read/write
> between a mmap area of one file and another file
> directly, with different size.
> 
> Signed-off-by: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  .gitignore        |   1 +
>  common/rc         |  14 +++++++
>  src/Makefile      |   2 +-
>  src/t_mmap_dio.c  |  81 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/138     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/138.out |   2 +
>  tests/xfs/group   |   1 +
>  7 files changed, 210 insertions(+), 1 deletion(-)
>  create mode 100644 src/t_mmap_dio.c
>  create mode 100755 tests/xfs/138
>  create mode 100644 tests/xfs/138.out
> 
> diff --git a/.gitignore b/.gitignore
> index 7dcea14..48a40a0 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -129,6 +129,7 @@
>  /src/cloner
>  /src/renameat2
>  /src/t_rename_overwrite
> +/src/t_mmap_dio
>  
>  # dmapi/ binaries
>  /dmapi/src/common/cmd/read_invis
> diff --git a/common/rc b/common/rc
> index 892c46e..3706620 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2632,6 +2632,20 @@ _require_scratch_shutdown()
>  	_scratch_unmount
>  }
>  
> +# Does dax mount option work on this dev/fs?
> +_require_scratch_dax()
> +{
> +	_require_scratch
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount -o dax
> +	# Check options to be sure. XFS ignores dax option
> +	# and goes on if dev underneath does not support dax.
> +	_fs_options $SCRATCH_DEV | grep -w "dax" > /dev/null 2>&1
> +	[ $? -ne 0 ] && \
> +		_notrun "$SCRATCH_DEV $FSTYP does not support -o dax"
> +	_scratch_unmount
> +}
> +
>  # Does norecovery support by this fs?
>  _require_norecovery()
>  {
> diff --git a/src/Makefile b/src/Makefile
> index 94d74aa..eb5a56c 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -12,7 +12,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
>  	godown resvtest writemod makeextents itrash rename \
>  	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
>  	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
> -	holetest t_truncate_self
> +	holetest t_truncate_self t_mmap_dio
>  
>  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> diff --git a/src/t_mmap_dio.c b/src/t_mmap_dio.c
> new file mode 100644
> index 0000000..1a26e1b
> --- /dev/null
> +++ b/src/t_mmap_dio.c
> @@ -0,0 +1,81 @@
> +/*
> + * This programme was originally written by
> + *     Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> + */
> +#define _GNU_SOURCE 1
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <sys/mman.h>
> +#include <libaio.h>
> +#include <errno.h>
> +#include <sys/time.h>
> +
> +void usage(char *prog)
> +{
> +	fprintf(stderr,
> +		"usage: %s <src file> <dest file> <size> <msg>\n",
> +		prog);
> +	exit(1);
> +}
> +
> +void err_exit(char *op, unsigned long len, char *s)
> +{
> +	fprintf(stderr, "%s(%s) len %lu %s\n",
> +		op, strerror(errno), len, s);
> +	exit(1);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int fd, fd2, ret;
> +	char *map;
> +	unsigned long len;
> +
> +	if (argc < 3)
> +		usage(basename(argv[0]));
> +
> +	len = strtoul(argv[3], NULL, 10);
> +	if (errno == ERANGE)
> +		err_exit("strtoul", 0, argv[4]);
> +
> +	/* Open source file and mmap*/
> +	fd = open(argv[1], O_RDWR, 0644);
> +	if (fd < 0)
> +		err_exit("open s", len, argv[4]);
> +
> +	map = (char *)mmap(NULL, len,
> +		PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> +	if (map == MAP_FAILED)
> +		err_exit("mmap", len, argv[4]);
> +
> +	/* Open dest file with O_DIRECT */
> +	fd2 = open(argv[2], O_RDWR|O_DIRECT, 0644);
> +	if (fd2 < 0)
> +		err_exit("open d", len, argv[4]);
> +
> +	/* First, test storing to dest file from source mapping */
> +	ret = write(fd2, map, len);
> +	if (ret != len)
> +		err_exit("write", len, argv[4]);
> +
> +	ret = (int)lseek(fd2, 0, SEEK_SET);
> +	if (ret == -1)
> +		err_exit("lseek", len, argv[4]);
> +
> +	/* Next, test reading from dest file into source mapping */
> +	ret = read(fd2, map, len);
> +	if (ret != len)
> +		err_exit("read", len, argv[4]);
> +	ret = msync(map, len, MS_SYNC);
> +	if (ret < 0)
> +		err_exit("msync", len, argv[4]);
> +
> +	ret = munmap(map, len);
> +	if (ret < 0)
> +		err_exit("munmap", len, argv[4]);

Small nit: you munmap() to clean up the mmap(), but you don't close fd or fd2.
