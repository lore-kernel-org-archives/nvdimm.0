Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 112F621BADAD5
 for <linux-nvdimm@lists.01.org>; Sat,  1 Jul 2017 13:36:40 -0700 (PDT)
Date: Sat, 1 Jul 2017 14:38:13 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v4 3/6] libnvdimm, acpi, nfit: Add bus level dsm mask for
 pass thru.
Message-ID: <20170701203813.GA13574@anatevka.americas.hpqcorp.net>
References: <cover.1498810220.git.jerry.hoemann@hpe.com>
 <293ee143dcabb386ca06b384a384171c256a2ecc.1498810220.git.jerry.hoemann@hpe.com>
 <CAPcyv4gcpmmr9LdX3DBtdX_ncwoBmCdC7yVPpGdO6EP7N9NOKw@mail.gmail.com>
 <20170701195805.GA13259@anatevka.americas.hpqcorp.net>
 <CAPcyv4hAMHzi7OK-z-B9LpT83Q1evH2-B-NXUMB2ebtVbjOdsg@mail.gmail.com>
 <CAPcyv4hP0zuZ0bdcQ5R3K2p5CRfHKXMSC_ov1D4qGXsXAQen=A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hP0zuZ0bdcQ5R3K2p5CRfHKXMSC_ov1D4qGXsXAQen=A@mail.gmail.com>
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

On Sat, Jul 01, 2017 at 01:10:31PM -0700, Dan Williams wrote:
> On Sat, Jul 1, 2017 at 1:08 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Sat, Jul 1, 2017 at 12:58 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> On Fri, Jun 30, 2017 at 08:55:22PM -0700, Dan Williams wrote:
> >>
> >> ...
> >>
> >>> On Fri, Jun 30, 2017 at 9:09 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >>> > +               if (cmd == ND_CMD_CALL)
> >>> > +                       dsm_mask = nd_desc->bus_dsm_mask;
> >>> >                 desc = nd_cmd_bus_desc(cmd);
> >>> >                 uuid = to_nfit_uuid(NFIT_DEV_BUS);
> >>> >                 handle = adev->handle;
> >>> > @@ -1613,6 +1615,7 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> >>> >         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
> >>> >         const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
> >>> >         struct acpi_device *adev;
> >>> > +       unsigned long dsm_mask;
> >>> >         int i;
> >>> >
> >>> >         nd_desc->cmd_mask = acpi_desc->bus_cmd_force_en;
> >>> > @@ -1624,6 +1627,11 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> >>> >                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
> >>> >                         set_bit(i, &nd_desc->cmd_mask);
> >>> >         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
> >>> > +
> >>> > +       dsm_mask = 0x3bf;
> >>>
> >>> I went ahead and fixed this up to use dsm_mask defined like this:
> >>>
> >>> +       dsm_mask =
> >>> +               (1 << ND_CMD_ARS_CAP) |
> >>> +               (1 << ND_CMD_ARS_START) |
> >>> +               (1 << ND_CMD_ARS_STATUS) |
> >>> +               (1 << ND_CMD_CLEAR_ERROR) |
> >>> +               (1 << NFIT_CMD_TRANSLATE_SPA) |
> >>> +               (1 << NFIT_CMD_ARS_INJECT_SET) |
> >>> +               (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
> >>> +               (1 << NFIT_CMD_ARS_INJECT_GET);
> >>>
> >>> This drops function number 0 which userspace has no need to call.
> >>
> >> Actually I like to call function 0.  Its an excellent test when
> >> modifying the code path as its a no side effects function whose output
> >> is known in advance and instantly recognizable.  I also use it when
> >> testing new firmware.
> >>
> >> What is the downside to allowing it?  What bad things happen?
> >
> > It allows implementations to bypass the standardization process and
> > ship new root DSMs. It's always possible to patch the kernel locally
> > for development, so I see no reason to ship this capability globally.

I don't understand this comment, but I think your next comment 
essentially says to disregard this comment?

> 
> Actually, just the discovery portion does not lead to this leak, but
> it's redundant when we have the 'dsm_mask' sysfs attribute.

No.  The generation of the mask in sysfs is not done by
executing the code in acpi_nfit_ctl.  One of the reasons I call
function 0 to test changes I am making to the ioctl path itself.
The sysfs has nothing to do with that path and cannot be used
to serve this purpose.

And since the content of sysfs has been edited it also can not be
used as a basic test of firmware.

What is the downside to allowing the calling of function 0?



-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
