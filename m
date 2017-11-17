Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 51B2621B00DC1
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:31:33 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id t79so3072248ota.3
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:35:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171117202524.24696-2-ross.zwisler@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Nov 2017 12:35:43 -0800
Message-ID: <CAPcyv4g+3Drmpwva1Cxpq0SNsR0SJwT1vZGmXt-NGgL_2Zt48Q@mail.gmail.com>
Subject: Re: [xfsprogs PATCH 1/2] xfs_io: add MAP_SYNC support to mmap()
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
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, fstests <fstests@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 17, 2017 at 12:25 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add support for a new -S flag to xfs_io's mmap command.  This opens the
> mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> standard MAP_SHARED flag.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>
> ---
>  configure.ac          |  1 +
>  include/builddefs.in  |  1 +
>  include/linux.h       |  5 +++++
>  io/io.h               |  1 +
>  io/mmap.c             | 19 ++++++++++++++-----
>  m4/package_libcdev.m4 | 16 ++++++++++++++++
>  man/man8/xfs_io.8     |  6 +++++-
>  7 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index cb23fb8..7153c9f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -162,6 +162,7 @@ AC_HAVE_FSETXATTR
>  AC_HAVE_MREMAP
>  AC_NEED_INTERNAL_FSXATTR
>  AC_HAVE_GETFSMAP
> +AC_HAVE_MAP_SYNC
>
>  if test "$enable_blkid" = yes; then
>  AC_HAVE_BLKID_TOPO
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 1d454b6..78b71fe 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -114,6 +114,7 @@ HAVE_FSETXATTR = @have_fsetxattr@
>  HAVE_MREMAP = @have_mremap@
>  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
>  HAVE_GETFSMAP = @have_getfsmap@
> +HAVE_MAP_SYNC = @have_map_sync@
>
>  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>  #         -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/include/linux.h b/include/linux.h
> index 6ce344c..4ee03ed 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -327,4 +327,9 @@ fsmap_advance(
>  #define HAVE_GETFSMAP
>  #endif /* HAVE_GETFSMAP */
>
> +#ifndef HAVE_MAP_SYNC
> +#define MAP_SYNC 0x80000

Hmm, this is the x86 specific value of MAP_SYNC. I think it would be
better to define MAP_SYNC to zero in this case and check for MAP_SYNC
== 0 at run time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
