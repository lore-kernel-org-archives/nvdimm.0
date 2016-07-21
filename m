Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 853CF1A1E24
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 11:09:04 -0700 (PDT)
Date: Thu, 21 Jul 2016 12:07:44 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 2/3] nfit, libnvdimm: allow an ARS scrub to be
 triggered on demand
Message-ID: <20160721180742.GG12960@omniknight.lm.intel.com>
References: <1469065850-32401-1-git-send-email-vishal.l.verma@intel.com>
 <1469065850-32401-3-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4jpmnGf6e_Akot4fuvckVZQAAnQmSLs8Ytd3sqHLj6UrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jpmnGf6e_Akot4fuvckVZQAAnQmSLs8Ytd3sqHLj6UrQ@mail.gmail.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/21, Dan Williams wrote:
> On Wed, Jul 20, 2016 at 6:50 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > Normally, an ARS (Address Range Scrub) only happens at
> > boot/initialization time. There can however arise situations where a
> > bus-wide rescan is needed - notably, in the case of discovering a latent
> > media error, we should do a full rescan to figure out what other sectors
> > are bad, and thus potentially avoid triggering an mce on them in the
> > future. Also provide a sysfs trigger to start a bus-wide scrub.
> >
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Cc: <linux-acpi@vger.kernel.org>
> > Cc: <linux-nvdimm@lists.01.org>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  drivers/acpi/nfit.c              | 123 +++++++++++++++++++++++++++++++++------
> >  drivers/acpi/nfit.h              |   4 +-
> >  drivers/nvdimm/core.c            |   7 +++
> >  include/linux/libnvdimm.h        |   1 +
> >  tools/testing/nvdimm/test/nfit.c |  16 +++++
> >  5 files changed, 131 insertions(+), 20 deletions(-)
> >
> 
> Looks good, just a couple nits:
> 
> [..]
> > @@ -2138,7 +2172,7 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
> >         unsigned int tmo = scrub_timeout;
> >         int rc;
> >
> > -       if (nfit_spa->ars_done || !nfit_spa->nd_region)
> > +       if (!(nfit_spa->ars_required && nfit_spa->nd_region))
> >                 return;
> 
> Why is nd_region part of this check?  Can't this just be:
> 
>     if (!nfit_spa->ars_requested)
>         return;
> 
> [..]

This was there previously too - I think we should always have nd_region
when we get here, and if we don't that's a kernel bug. So we could just
BUG_ON if that happens.. If we don't have a valid nd_region, it will
cause an oops when we go to call nvdimm_region_notify..

I'll change it to a BUG_ON.

> >
> > +static struct acpi_nfit_desc *acpi_nfit_desc_alloc_register(struct device *dev)
> > +{
> > +       struct acpi_nfit_desc *acpi_desc;
> > +       struct kernfs_node *nfit;
> > +       struct device *bus_dev;
> > +
> > +       acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
> > +       if (!acpi_desc)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       acpi_nfit_desc_init(acpi_desc, dev);
> > +
> > +       acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
> > +       if (!acpi_desc->nvdimm_bus)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
> > +       nfit = sysfs_get_dirent(bus_dev->kobj.sd, "nfit");
> > +       if (!nfit) {
> > +               dev_err(dev, "sysfs_get_dirent 'nfit' failed\n");
> > +               return ERR_PTR(-ENODEV);
> > +       }
> > +       acpi_desc->scrub_count_state = sysfs_get_dirent(nfit, "scrub");
> 
> Missing sysfs_put(nfit) here?

Yes, good catch! I'll fixup.
> 
> > +       if (!acpi_desc->scrub_count_state) {
> > +               dev_err(dev, "sysfs_get_dirent 'scrub' failed\n");
> > +               return ERR_PTR(-ENODEV);
> > +       }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
