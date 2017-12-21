Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 519F122198F6E
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 09:10:41 -0800 (PST)
Date: Thu, 21 Dec 2017 09:14:02 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfsprogs PATCH v3 3/3] xfs_io: add a new 'log_writes' command
Message-ID: <20171221171402.GU12613@magnolia>
References: <20171205235651.17102-4-ross.zwisler@linux.intel.com>
 <20171206181323.16989-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171206181323.16989-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 06, 2017 at 11:13:23AM -0700, Ross Zwisler wrote:
> Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> log marks.  It's helpful to allow users of xfs_io to adds these marks from
> within xfs_io instead of waiting until after xfs_io exits because then they
> are able to replay the dm-log-writes log up to immediately after another
> xfs_io operation such as mwrite.  This isolates the log replay from other
> operations that happen as part of xfs_io exiting (file handles being
> closed, mmaps being torn down, etc.).  This also allows users to insert
> multiple marks between different xfs_io commands.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> ---
> 
> Changes from v2:
>  - Use 'exitcode' to have the xfs_io shell command error out with status
>    1 if we hit any of our many error condtions during execution. (Dave)
> 
> ---
>  configure.ac            |   1 +
>  debian/control          |   2 +-
>  include/builddefs.in    |   2 +
>  io/Makefile             |   6 +++
>  io/init.c               |   1 +
>  io/io.h                 |   6 +++
>  io/log_writes.c         | 106 ++++++++++++++++++++++++++++++++++++++++++++++++
>  m4/Makefile             |   1 +
>  m4/package_devmapper.m4 |  11 +++++
>  man/man8/xfs_io.8       |  23 ++++++++++-
>  10 files changed, 157 insertions(+), 2 deletions(-)
>  create mode 100644 io/log_writes.c
>  create mode 100644 m4/package_devmapper.m4
> 
> diff --git a/configure.ac b/configure.ac
> index f3325aa0..f83d5817 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -164,6 +164,7 @@ AC_NEED_INTERNAL_FSXATTR
>  AC_HAVE_GETFSMAP
>  AC_HAVE_STATFS_FLAGS
>  AC_HAVE_MAP_SYNC
> +AC_HAVE_DEVMAPPER
>  
>  if test "$enable_blkid" = yes; then
>  AC_HAVE_BLKID_TOPO
> diff --git a/debian/control b/debian/control
> index ad816622..5c26e3d7 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
> -Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev
> +Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev
>  Standards-Version: 3.9.1
>  Homepage: http://xfs.org/
>  
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 126f7e95..66bdbfa2 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -35,6 +35,7 @@ LIBTERMCAP = @libtermcap@
>  LIBEDITLINE = @libeditline@
>  LIBREADLINE = @libreadline@
>  LIBBLKID = @libblkid@
> +LIBDEVMAPPER = @libdevmapper@
>  LIBXFS = $(TOPDIR)/libxfs/libxfs.la
>  LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
>  LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
> @@ -116,6 +117,7 @@ NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  HAVE_GETFSMAP = @have_getfsmap@
>  HAVE_STATFS_FLAGS = @have_statfs_flags@
>  HAVE_MAP_SYNC = @have_map_sync@
> +HAVE_DEVMAPPER = @have_devmapper@
>  
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/io/Makefile b/io/Makefile
> index 2987ee11..b7585a1b 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -107,6 +107,12 @@ ifeq ($(HAVE_MAP_SYNC),yes)
>  LCFLAGS += -DHAVE_MAP_SYNC
>  endif
>  
> +ifeq ($(HAVE_DEVMAPPER),yes)
> +CFILES += log_writes.c
> +LLDLIBS += $(LIBDEVMAPPER)
> +LCFLAGS += -DHAVE_DEVMAPPER
> +endif
> +
>  # On linux we get fsmap from the system or define it ourselves
>  # so include this based on platform type.  If this reverts to only
>  # the autoconf check w/o local definition, change to testing HAVE_GETFSMAP
> diff --git a/io/init.c b/io/init.c
> index 20d5f80d..34d87b5f 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -72,6 +72,7 @@ init_commands(void)
>  	help_init();
>  	imap_init();
>  	inject_init();
> +	log_writes_init();
>  	madvise_init();
>  	mincore_init();
>  	mmap_init();
> diff --git a/io/io.h b/io/io.h
> index 8b2753b3..9349cc75 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -186,3 +186,9 @@ extern void		fsmap_init(void);
>  #else
>  # define fsmap_init()	do { } while (0)
>  #endif
> +
> +#ifdef HAVE_DEVMAPPER
> +extern void		log_writes_init(void);
> +#else
> +#define log_writes_init()	do { } while (0)
> +#endif
> diff --git a/io/log_writes.c b/io/log_writes.c
> new file mode 100644
> index 00000000..c7b7392e
> --- /dev/null
> +++ b/io/log_writes.c
> @@ -0,0 +1,106 @@
> +/*
> + * Copyright (c) 2017 Intel Corporation.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "platform_defs.h"
> +#include <libdevmapper.h>
> +#include "command.h"
> +#include "init.h"
> +
> +static cmdinfo_t log_writes_cmd;
> +
> +static int
> +mark_log(const char *device, const char *mark)
> +{
> +	struct dm_task *dmt;
> +	const int size = 80;
> +	char message[size];
> +	int len, ret = 0;

Indentation?

> +
> +	len = snprintf(message, size, "mark %s", mark);
> +	if (len >= size) {
> +		printf("mark '%s' is too long\n", mark);
> +		return ret;
> +	}
> +
> +	if (!(dmt = dm_task_create(DM_DEVICE_TARGET_MSG)))
> +		return ret;
> +
> +	if (!dm_task_set_name(dmt, device))
> +		goto out;
> +
> +	if (!dm_task_set_sector(dmt, 0))
> +		goto out;
> +
> +	if (!dm_task_set_message(dmt, message))
> +		goto out;
> +
> +	if (dm_task_run(dmt))
> +		ret = 1;
> +out:
> +	dm_task_destroy(dmt);
> +	return ret;
> +}
> +
> +static int
> +log_writes_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	const char *device = NULL;
> +	const char *mark = NULL;

	const char		*device = NULL;
	const char		*mark = NULL;

Yeah, variable declaration indentation in the functions was the only
thing I found to complain about...

Otherwise looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	int c;
> +
> +	exitcode = 1;
> +	while ((c = getopt(argc, argv, "d:m:")) != EOF) {
> +		switch (c) {
> +		case 'd':
> +			device = optarg;
> +			break;
> +		case 'm':
> +			mark = optarg;
> +			break;
> +		default:
> +			return command_usage(&log_writes_cmd);
> +		}
> +	}
> +
> +	if (device == NULL || mark == NULL)
> +		return command_usage(&log_writes_cmd);
> +
> +	if (mark_log(device, mark))
> +		exitcode = 0;
> +
> +	return 0;
> +}
> +
> +void
> +log_writes_init(void)
> +{
> +	log_writes_cmd.name = "log_writes";
> +	log_writes_cmd.altname = "lw";
> +	log_writes_cmd.cfunc = log_writes_f;
> +	log_writes_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK
> +				| CMD_FLAG_ONESHOT;
> +	log_writes_cmd.argmin = 0;
> +	log_writes_cmd.argmax = -1;
> +	log_writes_cmd.args = _("-d device -m mark");
> +	log_writes_cmd.oneline =
> +		_("create mark <mark> in the dm-log-writes log specified by <device>");
> +
> +	add_command(&log_writes_cmd);
> +}
> diff --git a/m4/Makefile b/m4/Makefile
> index 4706121b..77f2edda 100644
> --- a/m4/Makefile
> +++ b/m4/Makefile
> @@ -15,6 +15,7 @@ CONFIGURE = \
>  LSRCFILES = \
>  	manual_format.m4 \
>  	package_blkid.m4 \
> +	package_devmapper.m4 \
>  	package_globals.m4 \
>  	package_libcdev.m4 \
>  	package_pthread.m4 \
> diff --git a/m4/package_devmapper.m4 b/m4/package_devmapper.m4
> new file mode 100644
> index 00000000..821f283c
> --- /dev/null
> +++ b/m4/package_devmapper.m4
> @@ -0,0 +1,11 @@
> +#
> +# See if libdevmapper is available on the system.
> +#
> +AC_DEFUN([AC_HAVE_DEVMAPPER],
> +[ AC_SEARCH_LIBS([dm_task_create], [devmapper],
> +        libdevmapper="-ldevmapper"
> +        have_devmapper=yes,
> +        have_devmapper=no,)
> +    AC_SUBST(have_devmapper)
> +    AC_SUBST(libdevmapper)
> +])
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 1693f7f1..4fce6d39 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1123,7 +1123,27 @@ version of policy structure (numeric)
>  .BR get_encpolicy
>  On filesystems that support encryption, display the encryption policy of the
>  current file.
> +.RE
> +.PD
> +.TP
> +.BI "log_writes \-d " device " \-m "  mark
> +Create a mark named
> +.I mark
> +in the dm-log-writes log specified by
> +.I device.
> +This is intended to be equivalent to the shell command:
>  
> +.B dmsetup message
> +.I device
> +.B 0 mark
> +.I mark
> +.PD
> +.RE
> +.TP
> +.B lw
> +See the
> +.B log_writes
> +command.
>  .SH SEE ALSO
>  .BR mkfs.xfs (8),
>  .BR xfsctl (3),
> @@ -1141,4 +1161,5 @@ current file.
>  .BR open (2),
>  .BR pread (2),
>  .BR pwrite (2),
> -.BR readdir (3).
> +.BR readdir (3),
> +.BR dmsetup (8).
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
