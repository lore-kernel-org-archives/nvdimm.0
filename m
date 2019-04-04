Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 917E4211EABC2
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 14:02:42 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 103so3672295otd.9
 for <linux-nvdimm@lists.01.org>; Thu, 04 Apr 2019 14:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155440491849.3190322.17551464505265122881.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190404193211.GK22763@bombadil.infradead.org>
In-Reply-To: <20190404193211.GK22763@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Apr 2019 14:02:30 -0700
Message-ID: <CAPcyv4hruLHWpEq_fT=_uFeO8X6KLjLsR2=s577iXey+NUFz4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] lib/memregion: Uplevel the pmem "region" ida to a
 global allocator
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 4, 2019 at 12:32 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Apr 04, 2019 at 12:08:38PM -0700, Dan Williams wrote:
> > +++ b/lib/Kconfig
> > @@ -318,6 +318,12 @@ config DECOMPRESS_LZ4
> >  config GENERIC_ALLOCATOR
> >       bool
> >
> > +#
> > +# Generic IDA for memory regions
> > +#
>
> Leaky abstraction -- nobody needs know that it's implemented as an IDA.
> Suggest:
>
> # Memory region ID allocation
>

Looks good to me.

> ...
>
> > +++ b/lib/memregion.c
> > @@ -0,0 +1,22 @@
> > +#include <linux/idr.h>
> > +#include <linux/module.h>
> > +
> > +static DEFINE_IDA(region_ida);
> > +
> > +int memregion_alloc(void)
> > +{
> > +     return ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
> > +}
> > +EXPORT_SYMBOL(memregion_alloc);
> > +
> > +void memregion_free(int id)
> > +{
> > +     ida_simple_remove(&region_ida, id);
> > +}
> > +EXPORT_SYMBOL(memregion_free);
> > +
> > +static void __exit memregion_exit(void)
> > +{
> > +     ida_destroy(&region_ida);
> > +}
> > +module_exit(memregion_exit);
>
>  - Should these be EXPORT_SYMBOL_GPL?

I don't see the need. These are simple wrappers around existing
EXPORT_SYMBOL() exports, and there's little concern that these
interfaces might disappear in the future causing us pain with out of
tree modules as these don't touch anything in the core.

>  - Can we use the new interface, ida_alloc() and ida_free()?

Sure.

>  - Do we really want memregion_exit() to happen while there are still IDs
>    allocated in the IDA?  I think this might well be better as:
>
>         BUG_ON(!ida_empty(&region_ida));

True, or just delete the module_exit because this functionality can't
be built as a module, so the exit path is already dead code.

> Also, do we really want to call the structure the region_ida?  Why not
> region_ids?

Sure, sounds good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
