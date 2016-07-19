Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 284241A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 11:33:23 -0700 (PDT)
Date: Tue, 19 Jul 2016 12:32:04 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/3] nfit, libnvdimm: allow an ARS rescan to be triggered
 on demand
Message-ID: <20160719183204.GF12960@omniknight.lm.intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
 <1468889100-30698-3-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4guVe2Mm_EaBMMRqpfCahR_E0xbhtE30VoDAb+sqvK=AQ@mail.gmail.com>
 <20160719174540.GC12960@omniknight.lm.intel.com>
 <CAPcyv4gdbB7=qT=5Q=aQqJrgoYaKsZDX9mrkAA8D0XVZbb9sbA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gdbB7=qT=5Q=aQqJrgoYaKsZDX9mrkAA8D0XVZbb9sbA@mail.gmail.com>
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/19, Dan Williams wrote:
> On Tue, Jul 19, 2016 at 10:45 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > On 07/19, Dan Williams wrote:
> >> On Mon, Jul 18, 2016 at 5:44 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> >> > Normally, an ARS (Address Range Scrub) only happens at
> >> > boot/initialization time. There can however arise situations where a
> >> > bus-wide rescan is needed - notably, in the case of discovering a latent
> >> > media error, we should do a full rescan to figure out what other sectors
> >> > are bad, and thus potentially avoid triggering an mce on them in the
> >> > future. Also provide a sysfs trigger to start a bus-wide rescan.
> >> >
> >> > Cc: Dan Williams <dan.j.williams@intel.com>
> >> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> > Cc: <linux-acpi@vger.kernel.org>
> >> > Cc: <linux-nvdimm@lists.01.org>
> >> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> >> > ---
> >> >  drivers/acpi/nfit.c       | 36 ++++++++++++++++++++++++++++++++----
> >> >  drivers/acpi/nfit.h       |  1 +
> >> >  drivers/nvdimm/core.c     | 17 +++++++++++++++++
> >> >  include/linux/libnvdimm.h |  1 +
> >> >  4 files changed, 51 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> >> > index ac6ddcc0..def9505 100644
> >> > --- a/drivers/acpi/nfit.c
> >> > +++ b/drivers/acpi/nfit.c
> >> > @@ -2138,8 +2138,9 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
> >> >         unsigned int tmo = scrub_timeout;
> >> >         int rc;
> >> >
> >> > -       if (nfit_spa->ars_done || !nfit_spa->nd_region)
> >> > -               return;
> >> > +       if (!nfit_spa->ars_rescan)
> >> > +               if (nfit_spa->ars_done || !nfit_spa->nd_region)
> >> > +                       return;
> >>
> >> Do we need a new flag? Why not just clear ->ars_done?
> >
> > This is what I had started out with - clearing the done flag, but the
> > done flag gets set at the end of acpi_nfit_scrub if a region has been
> > registered for that SPA. In the rescan case, we'll almost always have
> > our regions registered, so the done flag will get set here, and
> > acpi_nfit_async_scrub won't look at it at all..
> 
> Maybe just flip the polarity of ->ars_done to ->ars_do?  Seems we
> should be able to get away with not adding a new flag.

Will it make a difference? We essentially use the do/done flag to decide
which SPAs need further ARS work, i.e. ars_nfit_async_scrub. When we're
running at init time, the SPAs that need to go into _async_scrub can be
a subset of all SPAs because for some of them, the scrub may be complete,
and we may have valid results. For the rescan case, _all_ SPAs need to be
_async_scrub 'ed.

Unless we change the initilization case to also start ARS for all SPAs
irrespective of whether we found good results or not, I'm not sure I see
how we can reuse the same flag?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
