Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7608421B00DC1
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 13:29:31 -0800 (PST)
Date: Fri, 17 Nov 2017 14:33:40 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH 1/2] xfs_io: add MAP_SYNC support to mmap()
Message-ID: <20171117213340.GA3910@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-2-ross.zwisler@linux.intel.com>
 <CAPcyv4g+3Drmpwva1Cxpq0SNsR0SJwT1vZGmXt-NGgL_2Zt48Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g+3Drmpwva1Cxpq0SNsR0SJwT1vZGmXt-NGgL_2Zt48Q@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 17, 2017 at 12:35:43PM -0800, Dan Williams wrote:
> On Fri, Nov 17, 2017 at 12:25 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > Add support for a new -S flag to xfs_io's mmap command.  This opens the
> > mapping with the (MAP_SYNC | MAP_SHARED_VALIDATE) flags instead of the
> > standard MAP_SHARED flag.
> >
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  configure.ac          |  1 +
> >  include/builddefs.in  |  1 +
> >  include/linux.h       |  5 +++++
> >  io/io.h               |  1 +
> >  io/mmap.c             | 19 ++++++++++++++-----
> >  m4/package_libcdev.m4 | 16 ++++++++++++++++
> >  man/man8/xfs_io.8     |  6 +++++-
> >  7 files changed, 43 insertions(+), 6 deletions(-)
> >
> > diff --git a/configure.ac b/configure.ac
> > index cb23fb8..7153c9f 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -162,6 +162,7 @@ AC_HAVE_FSETXATTR
> >  AC_HAVE_MREMAP
> >  AC_NEED_INTERNAL_FSXATTR
> >  AC_HAVE_GETFSMAP
> > +AC_HAVE_MAP_SYNC
> >
> >  if test "$enable_blkid" = yes; then
> >  AC_HAVE_BLKID_TOPO
> > diff --git a/include/builddefs.in b/include/builddefs.in
> > index 1d454b6..78b71fe 100644
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -114,6 +114,7 @@ HAVE_FSETXATTR = @have_fsetxattr@
> >  HAVE_MREMAP = @have_mremap@
> >  NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
> >  HAVE_GETFSMAP = @have_getfsmap@
> > +HAVE_MAP_SYNC = @have_map_sync@
> >
> >  GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
> >  #         -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> > diff --git a/include/linux.h b/include/linux.h
> > index 6ce344c..4ee03ed 100644
> > --- a/include/linux.h
> > +++ b/include/linux.h
> > @@ -327,4 +327,9 @@ fsmap_advance(
> >  #define HAVE_GETFSMAP
> >  #endif /* HAVE_GETFSMAP */
> >
> > +#ifndef HAVE_MAP_SYNC
> > +#define MAP_SYNC 0x80000
> 
> Hmm, this is the x86 specific value of MAP_SYNC. I think it would be
> better to define MAP_SYNC to zero in this case and check for MAP_SYNC
> == 0 at run time.

Ah, so instead of defining MAP_SYNC if the proper headers aren't installed,
set to 0 and disallow the -S option?  Fair enough.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
