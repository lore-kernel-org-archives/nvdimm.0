Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20CB51A1F88
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 16:43:44 -0700 (PDT)
Date: Mon, 11 Apr 2016 17:43:41 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v8 05/10] nvdimm: Add IOCTL pass thru functions
Message-ID: <20160411234341.GC119165@tevye.fc.hp.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
 <e228edeeaa2f6527af89f10089e4bb6939de2532.1458583367.git.jerry.hoemann@hpe.com>
 <CAPcyv4jZf0udsY3aPCGxqLFi6Dvrn14oV0C8UBMX6VhOzEuk2w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jZf0udsY3aPCGxqLFi6Dvrn14oV0C8UBMX6VhOzEuk2w@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 11, 2016 at 12:15:14PM -0700, Dan Williams wrote:
> On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
> > allow kernel to call a nvdimm's _DSM as a passthru without using the
> > marshaling code of the nd_cmd_desc.
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/acpi/nfit.c  | 141 ++++++++++++++++++++++++++++++++++++++++++++-------
> >  drivers/nvdimm/bus.c |  43 +++++++++++++++-
> >  2 files changed, 166 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> > index d0f35e6..9511ab4 100644
> > --- a/drivers/acpi/nfit.c
> > +++ b/drivers/acpi/nfit.c
> > @@ -56,6 +56,21 @@ struct nfit_table_prev {
> >         struct list_head flushes;
> >  };
> >
> > +struct cmd_family_tbl {
> > +       enum nfit_uuids key_uuid;       /* Internal handle              */
> > +       int             key_type;       /* Exported handle              */
> > +       int             rev;            /* _DSM rev                     */
> > +       u64             mask;           /* 0 bit excludes underlying func.*/
> > +};
> > +
> > +struct cmd_family_tbl nfit_cmd_family_tbl[] = {
> > +       { NFIT_DEV_BUS,         ND_TYPE_BUS,            1, ~0UL},
> 
> Per the comment on patch2 lets kill this for now.
> 
> > +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1, ~0UL},
> > +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1, ~0UL},
> > +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1, ~0UL},
> 
> Why does the mask default to all supported?  I assume this should be
> the known-valid mask for each type, i.e. 0x3fe for
> ND_TYPE_DIMM_INTEL1.


innocent until proven guilty.

This mask is bit and'd with mask returned by firmware, so mask
returned by firmware limits callers to those function firmware
supports.

My having this extra mask, it allows kernel a way to prevent user space
application from calling a certain function totally. e.g. if we
found that a function is dangerous or something that couldn't be
coordinated with the kernel's use of the function.

By not restricting it to currently defined functions, it allow testing
firmware that might be implemented a new function w/o having to give
firmware team a special kernel.



> >
> > +
> > +/*
> > + * determine if the _DSM specified by UUID is supported and return
> > + * mask of supported functions in nd_cmd_mask.
> > + */
> > +
> > +static int acpi_nfit_sup_func(acpi_handle handle, const u8 *uuid,
> > +               int rev, unsigned long *nd_cmd_mask)
> > +{
> > +       int i;
> > +       u64 mask = 0;
> > +       union acpi_object *obj;
> > +
> > +       obj = acpi_evaluate_dsm(handle, uuid, rev, 0, NULL);
> > +       if (!obj)
> > +               return 0;
> > +       /* For compatibility, old BIOSes may return an integer */
> > +       if (obj->type == ACPI_TYPE_INTEGER)
> > +               mask = obj->integer.value;
> > +       else if (obj->type == ACPI_TYPE_BUFFER)
> > +               for (i = 0; i < obj->buffer.length && i < 8; i++)
> > +                       mask |= (((u8)obj->buffer.pointer[i]) << (i * 8));
> > +       ACPI_FREE(obj);
> > +
> > +       *nd_cmd_mask = mask;
> > +
> > +       return !!mask;
> > +}
> > +
> > +
> > +static inline void
> > +to_nfit_uuid_msk(acpi_handle handle, struct cmd_family_tbl *tbl,
> > +               u8 const **cmd_uuid, unsigned long *cmd_mask)
> > +{
> > +       unsigned long mask = 0;
> > +       int i;
> > +
> > +       for (i = 0;  tbl[i].key_uuid >= 0 ; i++) {
> > +               const u8 *uuid = to_nfit_uuid(tbl[i].key_uuid);
> > +               int rev = tbl[i].rev;
> > +
> > +               if (acpi_nfit_sup_func(handle, uuid, rev, &mask)) {
> > +                       *cmd_mask = mask & tbl[i].mask;
> > +                       *cmd_uuid = uuid;
> > +                       break;
> > +               }
> > +       }
> > +}
> > +
> >  static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
> >                 struct nfit_mem *nfit_mem, u32 device_handle)
> >  {
> >         struct acpi_device *adev, *adev_dimm;
> >         struct device *dev = acpi_desc->dev;
> > -       const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
> > -       int i;
> >
> >         nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
> >         adev = to_acpi_dev(acpi_desc);
> > @@ -939,9 +1045,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
> >                 return force_enable_dimms ? 0 : -ENODEV;
> >         }
> >
> > -       for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
> > -               if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
> > -                       set_bit(i, &nfit_mem->dsm_mask);
> > +       to_nfit_uuid_msk(adev_dimm->handle, nfit_cmd_family_tbl,
> > +                       &nfit_mem->dsm_uuid, &nfit_mem->dsm_mask);
> 
> Why is this replacing acpi_check_dsm() with an open-coded implementation?


Not sure of the question.

Is it why acpi_nfit_sup_func?  or why to_nfit_uuid_msk?

if why to_nfit_uuid_msk?   We need to determine both mask and uuid
(previously uuid was assumed.)

if why acpi_nfit_sup_func?  A few reasons.

Want to allow user space to get mask.  This is a "safe" way to know
that calls are being made to/returned from firmware.

Didn't want to hard code upper limit on function (at least not less
than having function 0 .. 63 which the acpi layer is doing.)

Finally didn't want to call acpi_check_dsm 64 times per nvdimm.  :)
But, we can go back to iterating over 0..63, both work.

Question, if non-root nodes are changed from DSM to LSM, won't
we need to add a function for that?


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
