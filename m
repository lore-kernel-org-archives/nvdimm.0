Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E937821C8F625
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 15:16:48 -0700 (PDT)
Date: Thu, 29 Jun 2017 16:18:20 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v3 7/7] acpi, nfit: override mask
Message-ID: <20170629221820.GD6065@anatevka.americas.hpqcorp.net>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
 <4dfd04a55324c2bdb6c9e8e65adf3cd8c0f324c9.1498754314.git.jerry.hoemann@hpe.com>
 <CAPcyv4jDNB4+Z-T6L3hBErjp+N00pRWU3Axv0L_F+ahLr4LEpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jDNB4+Z-T6L3hBErjp+N00pRWU3Axv0L_F+ahLr4LEpQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 02:16:17PM -0700, Dan Williams wrote:
> On Thu, Jun 29, 2017 at 9:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Have module parameter override_dsm_mask override the dsm_mask for
> > root calls like it does for non-root dsm calls.
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/acpi/nfit/core.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index 7d2f1a0..87acaf2 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -1627,6 +1627,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> >         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
> >         const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
> >         struct acpi_device *adev;
> > +       unsigned long dsm_mask;
> >         int i;
> >
> >         nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
> > @@ -1638,7 +1639,11 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> >                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
> >                         set_bit(i, &nd_desc->cmd_mask);
> >         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
> > -       for (i = 0; i < ND_CMD_CALL; i++)
> > +
> > +       dsm_mask = 0x3bf;
> > +       if (override_dsm_mask)
> > +               dsm_mask = override_dsm_mask;
> > +       for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
> >                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
> >                         set_bit(i, &nd_desc->bus_dsm_mask);
> >  }
> 
> I don't think we need this patch. 'override_dsm_mask' is there to make
> it easier for vendor-specific DSM testing and debug for DIMM-level
> DSMs. The root bus is not vendor specific and the command set is not
> evolving at the same rate we are seeing change at DIMM-level DSMs.

Override_dsm_mask is there to allow using old kernels with new
firmware/hardware.

It takes a long time to get even simple changes upstreamed, backported
to distros, released, distributed to customers, installed.

In testing, for months we have had to work around the inability to call
these functions from linux.  A waste of effort.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
