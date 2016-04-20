Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70C451A2305
 for <linux-nvdimm@lists.01.org>; Wed, 20 Apr 2016 09:46:50 -0700 (PDT)
Date: Wed, 20 Apr 2016 10:46:47 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 1/5] nvdimm: Add IOCTL pass thru functions
Message-ID: <20160420164647.GA29474@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <3e5bf78e359a066ae18debe3921d2f585060785e.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4i4hh3PYjDk823u4rnqHB-Xh=1V19pxLUXAF0JyJiyvLA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i4hh3PYjDk823u4rnqHB-Xh=1V19pxLUXAF0JyJiyvLA@mail.gmail.com>
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

On Mon, Apr 18, 2016 at 07:15:24PM -0700, Dan Williams wrote:
> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
> > allow kernel to call a nvdimm's _DSM as a passthru without using the
> > marshaling code of the nd_cmd_desc.
> >
> > This supports DSM as defined in:
> >
> >     http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> >     https://github.com/HewlettPackard/hpe-nvm/tree/master/Documentation
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/acpi/nfit.c  | 108 +++++++++++++++++++++++++++++++++++++++++++++------
> >  drivers/nvdimm/bus.c |  43 +++++++++++++++++++-
> >  2 files changed, 139 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> > index d0f35e6..7dffcb5 100644
> > --- a/drivers/acpi/nfit.c
> > +++ b/drivers/acpi/nfit.c
> > @@ -56,6 +56,24 @@ struct nfit_table_prev {
> >         struct list_head flushes;
> >  };
> >
> > +struct cmd_family_tbl {
> > +       enum nfit_uuids key_uuid;       /* Internal handle              */
> > +       int             key_type;       /* Exported handle              */
> > +       int             rev;            /* _DSM rev                     */
> > +};
> > +
> > +/*
> > + * If adding new cmd family, determine maximum function index
> > + */
> > +#define ND_MAX_CMD     20
> > +
> > +struct cmd_family_tbl nfit_cmd_family_tbl[] = {
> 
> Should be 'static', probably 'const' as well.

  Yes.


> 
> > +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1},
> > +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1},
> > +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1},
> > +       { -1, -1, -1},
> > +};
> > +

  ...


> >
> > +       if (call_dsm) {
> > +               call_dsm->nd_fw_size = out_obj->buffer.length;
> > +               memcpy(call_dsm->nd_payload + call_dsm->nd_size_in,
> > +                       out_obj->buffer.pointer,
> > +                       min(call_dsm->nd_fw_size, call_dsm->nd_size_out));
> 
> Hmm, further down in this routine we return -ENXIO if the output
> payload is too small, 0 if the output payload exactly matches the size
> of the BIOS output, and a positive number of remaining bytes if the
> output payload is larger than the BIOS output.  Yes, we can calculate
> this same result ourselves from the contents of the nd_cmd_pkg
> structure, but lets make the return value common for all the ioctls.
> Especially for the error case where we shouldn't successfully complete
> the ioctl if userspace failed to provide enough buffer space.
> +        	  
> +	          ACPI_FREE(out_obj);
> +               return 0;
> +       }


Disagree.  We've discussed this previously.  The passthru interface needs
to handle the case where the caller doesn't know in advance the size
of the return.  These cases are not errors, just a different semantic.


 ....


> > diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> > index 19f822d..0c1c4ab 100644
> > --- a/drivers/nvdimm/bus.c
> > +++ b/drivers/nvdimm/bus.c
> > @@ -439,6 +439,12 @@ static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
> >                 .out_num = 3,
> >                 .out_sizes = { 4, 4, UINT_MAX, },
> >         },
> > +       [ND_CMD_CALL] = {
> > +               .in_num = 2,
> > +               .in_sizes = {sizeof(struct nd_cmd_pkg), UINT_MAX, },
> 
> This caught my eye, and I'm not sure if checkpatch catches it, but
> lets have a space between the '{' and 'sizeof' to match the style of
> the other initializations in this array.


  Fine.


> 
> > +               .out_num = 1,
> > +               .out_sizes = { UINT_MAX, },
> > +       },
> >  };
> >
> >  const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd)
> > @@ -473,6 +479,12 @@ static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
> >                 .out_num = 3,
> >                 .out_sizes = { 4, 4, 8, },
> >         },
> > +       [ND_CMD_CALL] = {
> > +               .in_num = 2,
> > +               .in_sizes = {sizeof(struct nd_cmd_pkg), UINT_MAX, },
> 
> Ditto.

  Fine.

  ..

> > @@ -522,6 +538,12 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
> >                 return out_field[1];
> >         else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 2)
> >                 return out_field[1] - 8;
> > +       else if (cmd == ND_CMD_CALL) {
> > +               struct nd_cmd_pkg *pkg =
> > +                               (struct nd_cmd_pkg *) in_field;
> 
> checkpatch should warn about a missing newline between declarations
> and code here.

  struct nd_cmd_pkg had a longer named in past, hence breaking line not to
  exceed 80 characters.

  Will make one line and add \n.

> 
> > +               return pkg->nd_size_out;
> > +       }
> > +
> >
> >         return UINT_MAX;
> >  }
> > @@ -588,7 +610,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
> >         unsigned int cmd = _IOC_NR(ioctl_cmd);
> >         void __user *p = (void __user *) arg;
> >         struct device *dev = &nvdimm_bus->dev;
> > +       struct nd_cmd_pkg call_dsm;
> 
> Sometimes this patch uses 'call_dsm' as the local variable name of a
> struct nd_cmd_pkg, and sometimes 'pkg'.  Lets just use 'pkg'
> everywhere.

  Fine.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
