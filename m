Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E28D2095A6CD
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 14:46:03 -0700 (PDT)
Date: Thu, 29 Jun 2017 15:47:35 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v3 4/7] acpi, nfit: Use bus_dsm_mask for passthru
Message-ID: <20170629214735.GC6065@anatevka.americas.hpqcorp.net>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
 <f332778c416d01fd76ce8e474acd583e1b787c29.1498754314.git.jerry.hoemann@hpe.com>
 <CAPcyv4hjw50P2YsqQxzBMhVesj7rxXJ-PdxNw6Gan3Wj7UMMeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hjw50P2YsqQxzBMhVesj7rxXJ-PdxNw6Gan3Wj7UMMeQ@mail.gmail.com>
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

On Thu, Jun 29, 2017 at 02:35:14PM -0700, Dan Williams wrote:
> On Thu, Jun 29, 2017 at 9:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Populate bus_dsm_mask and use it to filter dsm calls that user can
> > make through the pass thru interface.
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/acpi/nfit/core.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index b46fca2..971002b 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -253,6 +253,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
> >                 cmd_name = nvdimm_bus_cmd_name(cmd);
> >                 cmd_mask = nd_desc->cmd_mask;
> >                 dsm_mask = cmd_mask;
> > +               if (cmd == ND_CMD_CALL)
> > +                       dsm_mask = nd_desc->bus_dsm_mask;
> >                 desc = nd_cmd_bus_desc(cmd);
> >                 uuid = to_nfit_uuid(NFIT_DEV_BUS);
> >                 handle = adev->handle;
> > @@ -1624,6 +1626,9 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> >                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
> >                         set_bit(i, &nd_desc->cmd_mask);
> >         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
> > +       for (i = 0; i < ND_CMD_CALL; i++)
> > +               if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
> > +                       set_bit(i, &nd_desc->bus_dsm_mask);
> >  }
> 
> This loop checks for function 6 which is specified as reserved. Lets
> explicitly test for the known good function numbers with something
> like this:
> 
> /* this should be private in drivers/acpi/nfit/nfit.h */
> enum nfit_aux_cmds {
>         NFIT_CMD_TRANSLATE_SPA = 5,
>         NFIT_CMD_ARS_INJECT_SET = 7,
>         NFIT_CMD_ARS_INJECT_CLEAR = 8,
>         NFIT_CMD_ARS_INJECT_GET = 9,
> };
> 
> bus_dsm_mask =
>         (1 << ND_CMD_ARS_CAP) |
>         (1 << ND_CMD_ARS_START) |
>         (1 << ND_CMD_ARS_STATUS) |
>         (1 << ND_CMD_CLEAR_ERROR) |
>         (1 << NFIT_CMD_TRANSLATE_SPA) |
>         (1 << NFIT_CMD_ARS_INJECT_SET) |
>         (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
>         (1 << NFIT_CMD_ARS_INJECT_GET);
> 
> for_each_set_bit(i, &bus_dsm_mask...


  I added the for_each_set_bit check in patch 7 of the series.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
