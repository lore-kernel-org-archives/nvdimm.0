Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 033B321962301
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 13:54:57 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id i20so16115902otl.0
 for <linux-nvdimm@lists.01.org>; Mon, 28 Jan 2019 13:54:57 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB0169DF967C5BAAC8334FCC42BF990@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4gnpn9VBHBoSFn_2sAdvfD85wRffvfYfuurwMxXYSBAZQ@mail.gmail.com>
 <PU1P153MB0169CE6B02AE7D67E25DDD89BF960@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169CE6B02AE7D67E25DDD89BF960@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Jan 2019 13:54:46 -0800
Message-ID: <CAPcyv4hGYFuW901KZ1xCR4TucgRTkqZ=SOsLOK0MpKq0BBCokw@mail.gmail.com>
Subject: Re: [PATCH] nfit: add Hyper-V NVDIMM DSM command set to white list
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 28, 2019 at 1:40 PM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Dan Williams <dan.j.williams@intel.com>
> > Sent: Monday, January 28, 2019 1:01 PM
> >
> > Hi Dexuan,
> > Looks good. Just one update request and a note below...
> >
> > On Wed, Jan 23, 2019 at 12:51 PM Dexuan Cui <decui@microsoft.com> wrote:
> > > ...
> > > --- a/drivers/acpi/nfit/core.c
> > > +++ b/drivers/acpi/nfit/core.c
> > > @@ -1840,7 +1840,7 @@ static int acpi_nfit_add_dimm(struct
> > acpi_nfit_desc *acpi_desc,
> > >         dev_set_drvdata(&adev_dimm->dev, nfit_mem);
> > >
> > >         /*
> > > -        * Until standardization materializes we need to consider 4
> > > +        * Until standardization materializes we need to consider 5
> > >          * different command sets.  Note, that checking for function0
> > (bit0)
> > >          * tells us if any commands are reachable through this GUID.
> > >          */
> >
> > This comment is stale. This "HYPERV" family is the first example of
> > the "right" way to define a new NVDIMM command set. Lets update it to
> > mention the process and considerations for submitting new command sets
> > to UEFI (http://www.uefi.org/RFIC_LIST). The fact that there's now a
> > defined process is a step forward from when this comment was initially
> > written. Also, the fact that the process encourages "adopt" vs
> > "supersede" addresses the main concern about vendor-specific
> > command-set proliferation.
>
> I made the below simple change. Is this enough? Please suggest the proper
> wording/sentence, as I'm relatively new to NVDIMM, and I don't really know the
> history of the standardization process.
>
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1732,8 +1732,10 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>         dev_set_drvdata(&adev_dimm->dev, nfit_mem);
>
>         /*
> -        * Until standardization materializes we need to consider 4
> -        * different command sets.  Note, that checking for function0 (bit0)
> +        * New command sets should be submitted to UEFI
> +        * http://www.uefi.org/RFIC_LIST.
> +        *

How about something a bit more relevant for the code in question:

---

There are 4 "legacy" NVDIMM command sets
(NVDIMM_FAMILY_{INTEL,MSFT,HPE1,HPE2}) that were created before an EFI
working group was established to constrain this proliferation. The
nfit driver probes for the supported command set by GUID. Note, If
you're a platform developer looking to add a new command set to this
probe consider using an existing set, or otherwise seek approval to
publish the command set at http://www.uefi.org/RFIC_LIST.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
