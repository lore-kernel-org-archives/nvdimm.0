Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B998202E60FC
 for <linux-nvdimm@lists.01.org>; Sat, 14 Oct 2017 20:32:24 -0700 (PDT)
Message-ID: <1508038556.31494.2.camel@kernel.org>
Subject: Re: [ndctl PATCH v2 2/6] libndctl: add error injection related
 interfaces
From: Vishal Verma <vishal@kernel.org>
Date: Sat, 14 Oct 2017 21:35:56 -0600
In-Reply-To: <CAPcyv4g3YK--W1dmnA=J-FkS7RALTRNz1rgGDXpUgSz13ALnDg@mail.gmail.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
 <20171013001004.14963-3-vishal.l.verma@intel.com>
 <CAPcyv4g3YK--W1dmnA=J-FkS7RALTRNz1rgGDXpUgSz13ALnDg@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2017-10-13 at 16:07 -0700, Dan Williams wrote:
> On Thu, Oct 12, 2017 at 5:10 PM, Vishal Verma <vishal.l.verma@intel.c
> om> wrote:
> > Add interfaces to enable error injection commands. Add nfit
> > specific
> > error injection helpers in ndctl/lib/nfit.c, and generic wrappers
> > for
> > them in libndctl.
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  ndctl/lib/Makefile.am  |   1 +
> >  ndctl/lib/inject.c     | 391
> > +++++++++++++++++++++++++++++++++++++++++++++++++
> >  ndctl/lib/libndctl.c   |  47 +-----
> >  ndctl/lib/libndctl.sym |   9 ++
> >  ndctl/lib/nfit.c       |  89 +++++++++++
> >  ndctl/lib/private.h    |  53 +++++++
> >  ndctl/libndctl-nfit.h  |   2 +
> >  ndctl/libndctl.h.in    |  23 +++
> >  8 files changed, 573 insertions(+), 42 deletions(-)
> >  create mode 100644 ndctl/lib/inject.c
> > 
> > diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> > index 9a7734d..3a6024e 100644
> > --- a/ndctl/lib/Makefile.am
> > +++ b/ndctl/lib/Makefile.am
> > @@ -18,6 +18,7 @@ libndctl_la_SOURCES =\
> >         ../../util/sysfs.c \
> >         ../../util/sysfs.h \
> >         dimm.c \
> > +       inject.c \
> >         libndctl.c
> > 
> >  libndctl_la_LIBADD =\
> > diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
> > new file mode 100644
> > index 0000000..2660384
> > --- /dev/null
> > +++ b/ndctl/lib/inject.c
> > @@ -0,0 +1,391 @@
> > +/*
> > + * Copyright (c) 2014-2017, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > modify it
> > + * under the terms and conditions of the GNU Lesser General Public
> > License,
> > + * version 2.1, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but
> > WITHOUT ANY
> > + * WARRANTY; without even the implied warranty of MERCHANTABILITY
> > or FITNESS
> > + * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
> > License for
> > + * more details.
> > + */
> > +#include <stdlib.h>
> > +#include <limits.h>
> > +#include <util/list.h>
> > +#include <util/size.h>
> > +#include <ndctl/libndctl.h>
> > +#include <ccan/list/list.h>
> > +#include <ndctl/libndctl-nfit.h>
> > +#include <ccan/short_types/short_types.h>
> > +#include "private.h"
> > +
> > +NDCTL_EXPORT int ndctl_bus_has_error_injection(struct ndctl_bus
> > *bus)
> > +{
> > +       /* Currently, only nfit buses have error injection */
> > +       if (!bus || !ndctl_bus_has_nfit(bus))
> > +               return 0;
> > +
> > +       if (ndctl_bus_is_nfit_cmd_supported(bus,
> > NFIT_CMD_ARS_INJECT_SET) &&
> > +               ndctl_bus_is_nfit_cmd_supported(bus,
> > NFIT_CMD_ARS_INJECT_GET) &&
> > +               ndctl_bus_is_nfit_cmd_supported(bus,
> > NFIT_CMD_ARS_INJECT_CLEAR))
> > +               return 1;
> > +
> > +       return 0;
> > +}
> > +
> > +NDCTL_EXPORT void ndctl_namespace_get_injection_bounds(
> > +               struct ndctl_namespace *ndns, unsigned long long
> > *ns_offset,
> > +               unsigned long long *ns_size)
> > +{
> 
> This routine should have an error code because the resource values
> are
> root-only, but I think a better solution is to just not NDCTL_EXPORT
> it since it's only used internally in the library. In fact, if you
> didn't find a use case for a new library call in the error injection
> command then we should make it internal-only until an external user
> shows up.
> 
> Are there any other commands like this?

Agreed that we should just remove the NDCTL_EXPORT for this. I was
using it from the inject-error code, but in the last round of
refactoring, that usage disappeared, and the export lingered..
Can you fix it while applying or shall I resend?

I don't think there are other exported functions like this that aren't
used outside the library.

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
