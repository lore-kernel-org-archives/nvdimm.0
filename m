Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A936E220D4BF6
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:40:08 -0800 (PST)
Date: Fri, 17 Nov 2017 12:44:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfsprogs PATCH 2/2] xfs_io: add a new 'log_writes' command
Message-ID: <20171117204413.GP5119@magnolia>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171117202524.24696-3-ross.zwisler@linux.intel.com>
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

On Fri, Nov 17, 2017 at 01:25:24PM -0700, Ross Zwisler wrote:
> Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> log marks via the external 'dmsetup' executable.  It's helpful to allow
> users of xfs_io to adds these marks from within xfs_io instead of waiting
> until after xfs_io exits because then they are able to replay the
> dm-log-writes log up to immediately after another xfs_io operation such as
> mwrite.  This isolates the log replay from other operations that happen as
> part of xfs_io exiting (file handles being closed, mmaps being torn down,
> etc.).  This also allows users to insert multiple marks between different
> xfs_io commands.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> ---
>  io/Makefile       |  5 ++--
>  io/init.c         |  1 +
>  io/io.h           |  1 +
>  io/log_writes.c   | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_io.8 | 19 ++++++++++++++
>  5 files changed, 102 insertions(+), 2 deletions(-)
>  create mode 100644 io/log_writes.c
> 
> diff --git a/io/Makefile b/io/Makefile
> index 050d6bd..51b2eae 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -10,8 +10,9 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
>  HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c cowextsize.c encrypt.c file.c freeze.c fsync.c \
> -	getrusage.c imap.c link.c mmap.c open.c parent.c pread.c prealloc.c \
> -	pwrite.c reflink.c seek.c shutdown.c stat.c sync.c truncate.c utimes.c
> +	getrusage.c imap.c link.c log_writes.c mmap.c open.c parent.c pread.c \
> +	prealloc.c pwrite.c reflink.c seek.c shutdown.c stat.c sync.c \
> +	truncate.c utimes.c
>  
>  LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBPTHREAD)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
> diff --git a/io/init.c b/io/init.c
> index 20d5f80..34d87b5 100644
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
> index 8b2753b..d62034a 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -109,6 +109,7 @@ extern void		getrusage_init(void);
>  extern void		help_init(void);
>  extern void		imap_init(void);
>  extern void		inject_init(void);
> +extern void		log_writes_init(void);
>  extern void		mmap_init(void);
>  extern void		open_init(void);
>  extern void		parent_init(void);
> diff --git a/io/log_writes.c b/io/log_writes.c
> new file mode 100644
> index 0000000..bc3952c
> --- /dev/null
> +++ b/io/log_writes.c
> @@ -0,0 +1,78 @@
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
> +#include "command.h"
> +#include "init.h"
> +
> +static cmdinfo_t log_writes_cmd;
> +
> +static int
> +mark_log(char *device, char *mark)
> +{
> +	char command[256];
> +
> +	snprintf(command, 256, "dmsetup message %s 0 mark %s",
> +			device, mark);
> +
> +	return system(command);

I want to call my mark "bobby'; DROP TABLES;"... ;)

Maybe we should check snprintf return value just in case someone feeds
us an overlong string?

--D

> +}
> +
> +static int
> +log_writes_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	char *device = NULL;
> +	char *mark = NULL;
> +	int c;
> +
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
> +	return mark_log(device, mark);
> +}
> +
> +void
> +log_writes_init(void)
> +{
> +	log_writes_cmd.name = "log_writes";
> +	log_writes_cmd.altname = "lw";
> +	log_writes_cmd.cfunc = log_writes_f;
> +	log_writes_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
> +	log_writes_cmd.argmin = 0;
> +	log_writes_cmd.argmax = -1;
> +	log_writes_cmd.args = _("-d device -m mark");
> +	log_writes_cmd.oneline =
> +		_("uses dmsetup to interact with the dm-log-writes module");
> +
> +	add_command(&log_writes_cmd);
> +}
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 1693f7f..f18af99 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1123,7 +1123,25 @@ version of policy structure (numeric)
>  .BR get_encpolicy
>  On filesystems that support encryption, display the encryption policy of the
>  current file.
> +.RE
> +.PD
> +.TP
> +.BI "log_writes \-d " device " \-m "  mark
> +Use
> +.B dmsetup
> +to interact with the
> +.B dm-log-writes
> +kernel module.  Currently the only operation
> +supported is the creation of a mark in the log by executing the shell command:
>  
> +.B dmsetup message <device> 0 mark <mark>
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
> @@ -1142,3 +1160,4 @@ current file.
>  .BR pread (2),
>  .BR pwrite (2),
>  .BR readdir (3).
> +.BR dmsetup (8).
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
