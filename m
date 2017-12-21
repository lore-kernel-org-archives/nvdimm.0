Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2ED4422085883
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 14:15:48 -0800 (PST)
Date: Thu, 21 Dec 2017 14:18:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfsprogs PATCH v4 1/2] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171221221818.GA12613@magnolia>
References: <20171221220800.14382-1-ross.zwisler@linux.intel.com>
 <20171221220800.14382-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171221220800.14382-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 21, 2017 at 03:07:59PM -0700, Ross Zwisler wrote:
> Add support for a new -S flag to xfs_io's mmap command.  This opens the
> mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> standard MAP_SHARED flag.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  include/linux.h       |  8 ++++++++
>  io/Makefile           |  4 ++++
>  io/io.h               |  1 +
>  io/mmap.c             | 29 ++++++++++++++++++++++++-----
>  m4/package_libcdev.m4 | 16 ++++++++++++++++
>  man/man8/xfs_io.8     |  6 +++++-
>  8 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index e5d0309f..f3325aa0 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -163,6 +163,7 @@ AC_HAVE_MREMAP
>  AC_NEED_INTERNAL_FSXATTR
>  AC_HAVE_GETFSMAP
>  AC_HAVE_STATFS_FLAGS
> +AC_HAVE_MAP_SYNC
>  
>  if test "$enable_blkid" = yes; then
>  AC_HAVE_BLKID_TOPO
> diff --git a/include/builddefs.in b/include/builddefs.in
> index fd274ddc..126f7e95 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -115,6 +115,7 @@ HAVE_MREMAP = @have_mremap@
>  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  HAVE_GETFSMAP = @have_getfsmap@
>  HAVE_STATFS_FLAGS = @have_statfs_flags@
> +HAVE_MAP_SYNC = @have_map_sync@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/include/linux.h b/include/linux.h
> index 6ce344c5..1998941a 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -327,4 +327,12 @@ fsmap_advance(
>  #define HAVE_GETFSMAP
>  #endif /* HAVE_GETFSMAP */
>  
> +#ifndef HAVE_MAP_SYNC
> +#define MAP_SYNC 0
> +#define MAP_SHARED_VALIDATE 0
> +#else
> +#include <asm-generic/mman.h>
> +#include <asm-generic/mman-common.h>
> +#endif /* HAVE_MAP_SYNC */
> +
>  #endif	/* __XFS_LINUX_H__ */
> diff --git a/io/Makefile b/io/Makefile
> index 6725936d..2987ee11 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -103,6 +103,10 @@ ifeq ($(HAVE_MREMAP),yes)
>  LCFLAGS += -DHAVE_MREMAP
>  endif
>  
> +ifeq ($(HAVE_MAP_SYNC),yes)
> +LCFLAGS += -DHAVE_MAP_SYNC
> +endif
> +
>  # On linux we get fsmap from the system or define it ourselves
>  # so include this based on platform type.  If this reverts to only
>  # the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> diff --git a/io/io.h b/io/io.h
> index 3862985f..8b2753b3 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -65,6 +65,7 @@ typedef struct mmap_region {
>  	size_t		length;		/* length of mapping */
>  	off64_t		offset;		/* start offset into backing file */
>  	int		prot;		/* protection mode of the mapping */
> +	bool		map_sync;	/* is this a MAP_SYNC mapping? */
>  	char		*name;		/* name of backing file */
>  } mmap_region_t;
>  
> diff --git a/io/mmap.c b/io/mmap.c
> index b0c1f764..04a828a4 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -42,7 +42,7 @@ print_mapping(
>  	int		index,
>  	int		braces)
>  {
> -	unsigned char	buffer[8] = { 0 };
> +	char		buffer[8] = { 0 };
>  	int		i;
>  
>  	static struct {
> @@ -57,6 +57,10 @@ print_mapping(
>  
>  	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
>  		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
> +
> +	if (map->map_sync)
> +		sprintf(&buffer[i], " S");
> +
>  	printf("%c%03d%c 0x%lx - 0x%lx %s  %14s (%lld : %ld)\n",
>  		braces? '[' : ' ', index, braces? ']' : ' ',
>  		(unsigned long)map->addr,
> @@ -147,6 +151,7 @@ mmap_help(void)
>  " -r -- map with PROT_READ protection\n"
>  " -w -- map with PROT_WRITE protection\n"
>  " -x -- map with PROT_EXEC protection\n"
> +" -S -- map with MAP_SYNC and MAP_SHARED_VALIDATE flags\n"
>  " -s <size> -- first do mmap(size)/munmap(size), try to reserve some free space\n"
>  " If no protection mode is specified, all are used by default.\n"
>  "\n"));
> @@ -162,7 +167,7 @@ mmap_f(
>  	void		*address = NULL;
>  	char		*filename;
>  	size_t		blocksize, sectsize;
> -	int		c, prot = 0;
> +	int		c, prot = 0, flags = MAP_SHARED;
>  
>  	exitcode = 1;
>  	if (argc == 1) {
> @@ -186,7 +191,7 @@ mmap_f(
>  
>  	init_cvtnum(&blocksize, &sectsize);
>  
> -	while ((c = getopt(argc, argv, "rwxs:")) != EOF) {
> +	while ((c = getopt(argc, argv, "rwxSs:")) != EOF) {
>  		switch (c) {
>  		case 'r':
>  			prot |= PROT_READ;
> @@ -197,6 +202,19 @@ mmap_f(
>  		case 'x':
>  			prot |= PROT_EXEC;
>  			break;
> +		case 'S':
> +			flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> +
> +			/*
> +			 * If MAP_SYNC and MAP_SHARED_VALIDATE aren't defined
> +			 * in the system headers we will have defined them
> +			 * both as 0.
> +			 */
> +			if (!flags) {
> +				printf("MAP_SYNC not supported\n");
> +				return 0;
> +			}
> +			break;
>  		case 's':
>  			length2 = cvtnum(blocksize, sectsize, optarg);
>  			break;
> @@ -240,7 +258,7 @@ mmap_f(
>  		               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>  		munmap(address, length2);
>  	}
> -	address = mmap(address, length, prot, MAP_SHARED, file->fd, offset);
> +	address = mmap(address, length, prot, flags, file->fd, offset);
>  	if (address == MAP_FAILED) {
>  		perror("mmap");
>  		free(filename);
> @@ -265,6 +283,7 @@ mmap_f(
>  	mapping->offset = offset;
>  	mapping->name = filename;
>  	mapping->prot = prot;
> +	mapping->map_sync = (flags == (MAP_SYNC | MAP_SHARED_VALIDATE));
>  	exitcode = 0;
>  	return 0;
>  }
> @@ -691,7 +710,7 @@ mmap_init(void)
>  	mmap_cmd.argmax = -1;
>  	mmap_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK |
>  			 CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;
> -	mmap_cmd.args = _("[N] | [-rwx] [-s size] [off len]");
> +	mmap_cmd.args = _("[N] | [-rwxS] [-s size] [off len]");
>  	mmap_cmd.oneline =
>  		_("mmap a range in the current file, show mappings");
>  	mmap_cmd.help = mmap_help;
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 7b4dfc85..71cedc5c 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -328,3 +328,19 @@ AC_DEFUN([AC_HAVE_STATFS_FLAGS],
>      )
>      AC_SUBST(have_statfs_flags)
>    ])
> +
> +#
> +# Check if we have MAP_SYNC defines (Linux)
> +#
> +AC_DEFUN([AC_HAVE_MAP_SYNC],
> +  [ AC_MSG_CHECKING([for MAP_SYNC])
> +    AC_TRY_COMPILE([
> +#include <asm-generic/mman.h>
> +#include <asm-generic/mman-common.h>
> +    ], [
> +        int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
> +    ], have_map_sync=yes
> +	AC_MSG_RESULT(yes),
> +	AC_MSG_RESULT(no))
> +    AC_SUBST(have_map_sync)
> +  ])
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 9bf1a478..1693f7f1 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -764,7 +764,7 @@ Each (sec, nsec) pair constitutes a single timestamp value.
>  
>  .SH MEMORY MAPPED I/O COMMANDS
>  .TP
> -.BI "mmap [ " N " | [[ \-rwx ] [\-s " size " ] " "offset length " ]]
> +.BI "mmap [ " N " | [[ \-rwxS ] [\-s " size " ] " "offset length " ]]
>  With no arguments,
>  .B mmap
>  shows the current mappings. Specifying a single numeric argument
> @@ -780,6 +780,10 @@ PROT_WRITE
>  .RB ( \-w ),
>  and PROT_EXEC
>  .RB ( \-x ).
> +The mapping will be created with the MAP_SHARED flag by default, or with the
> +Linux specific (MAP_SYNC | MAP_SHARED_VALIDATE) flags if
> +.B -S
> +is given.
>  .BI \-s " size"
>  is used to do a mmap(size) && munmap(size) operation at first, try to reserve some
>  extendible free memory space, if
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
