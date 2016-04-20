Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F6911A2170
 for <linux-nvdimm@lists.01.org>; Wed, 20 Apr 2016 15:55:48 -0700 (PDT)
Date: Wed, 20 Apr 2016 16:55:45 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 1/5] nvdimm: Add IOCTL pass thru functions
Message-ID: <20160420225545.GD29474@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <3e5bf78e359a066ae18debe3921d2f585060785e.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4i4hh3PYjDk823u4rnqHB-Xh=1V19pxLUXAF0JyJiyvLA@mail.gmail.com>
 <20160420164647.GA29474@tevye.fc.hp.com>
 <CAPcyv4hM6QRth5t=Sqmo7qGZuoO0_hpFBvcp6GpYoqgS8Hdq2A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hM6QRth5t=Sqmo7qGZuoO0_hpFBvcp6GpYoqgS8Hdq2A@mail.gmail.com>
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

On Wed, Apr 20, 2016 at 01:08:05PM -0700, Dan Williams wrote:
> On Wed, Apr 20, 2016 at 9:46 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Mon, Apr 18, 2016 at 07:15:24PM -0700, Dan Williams wrote:
> >> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> > Add ioctl command ND_CMD_CALL_DSM to acpi_nfit_ctl and __nd_ioctl which
> >> > allow kernel to call a nvdimm's _DSM as a passthru without using the
> >> > marshaling code of the nd_cmd_desc.
> >> >
> >> > This supports DSM as defined in:
> >> >
> >> >     http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> >> >     https://github.com/HewlettPackard/hpe-nvm/tree/master/Documentation
> >> >
> >> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> >> > ---
> >> >  drivers/acpi/nfit.c  | 108 +++++++++++++++++++++++++++++++++++++++++++++------
> >> >  drivers/nvdimm/bus.c |  43 +++++++++++++++++++-
> >> >  2 files changed, 139 insertions(+), 12 deletions(-)
> >> >
> >> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> >> > index d0f35e6..7dffcb5 100644
> >> > --- a/drivers/acpi/nfit.c
> >> > +++ b/drivers/acpi/nfit.c
> >> > @@ -56,6 +56,24 @@ struct nfit_table_prev {
> >> >         struct list_head flushes;
> >> >  };
> >> >
> >> > +struct cmd_family_tbl {
> >> > +       enum nfit_uuids key_uuid;       /* Internal handle              */
> >> > +       int             key_type;       /* Exported handle              */
> >> > +       int             rev;            /* _DSM rev                     */
> >> > +};
> >> > +
> >> > +/*
> >> > + * If adding new cmd family, determine maximum function index
> >> > + */
> >> > +#define ND_MAX_CMD     20
> >> > +
> >> > +struct cmd_family_tbl nfit_cmd_family_tbl[] = {
> >>
> >> Should be 'static', probably 'const' as well.
> >
> >   Yes.
> >
> >
> >>
> >> > +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1},
> >> > +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1},
> >> > +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1},
> >> > +       { -1, -1, -1},
> >> > +};
> >> > +
> >
> >   ...
> >
> >
> >> >
> >> > +       if (call_dsm) {
> >> > +               call_dsm->nd_fw_size = out_obj->buffer.length;
> >> > +               memcpy(call_dsm->nd_payload + call_dsm->nd_size_in,
> >> > +                       out_obj->buffer.pointer,
> >> > +                       min(call_dsm->nd_fw_size, call_dsm->nd_size_out));
> >>
> >> Hmm, further down in this routine we return -ENXIO if the output
> >> payload is too small, 0 if the output payload exactly matches the size
> >> of the BIOS output, and a positive number of remaining bytes if the
> >> output payload is larger than the BIOS output.  Yes, we can calculate
> >> this same result ourselves from the contents of the nd_cmd_pkg
> >> structure, but lets make the return value common for all the ioctls.
> >> Especially for the error case where we shouldn't successfully complete
> >> the ioctl if userspace failed to provide enough buffer space.
> >> +
> >> +               ACPI_FREE(out_obj);
> >> +               return 0;
> >> +       }
> >
> >
> > Disagree.  We've discussed this previously.  The passthru interface needs
> > to handle the case where the caller doesn't know in advance the size
> > of the return.  These cases are not errors, just a different semantic.
> 
> I don't think the passthru interface deserves a different semantic.
> It does handle the case that the caller does not know the size, it
> returns -errno on too small, 0 on just right, and postive number on
> too big.

I was using semantic in context of the underlying FW call.
HPE fw has different semantics from Intel's fw.

-ENXIO is overloaded.  More than one type of calling "error" could
produce that return code.  As such, user can't rely upon the contents of
of payload to determine what correct size should be as user doesn't know
why -ENXIO was returned.

Even if ENXIO wasn't overloaded, it doesn't seem like the correct
error status.  POSIX defines ENXIO as:

	No such device or address.

	Input or output on a special file referred to a device that did not exist,
	or made a request beyond the limits of the device.
	This error may also occur when, for example, a tape drive is not online
	or a disk pack is not loaded on a device.

This isn't our case.

Did you pattern the return for nd_ioctl from somewhere?
It might be useful to have some context.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
