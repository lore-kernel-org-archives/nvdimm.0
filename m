Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C48D211A3216
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 08:43:24 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id s5so19851134oth.7
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 08:43:24 -0800 (PST)
MIME-Version: 1.0
References: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49sgxvclmu.fsf@redhat.com>
In-Reply-To: <x49sgxvclmu.fsf@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 08:43:12 -0800
Message-ID: <CAPcyv4hLGB-=UcHykgAO5X3Oakp_erw_62_gpUD2cqXLXKpJVQ@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: Fix command-supported detection
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Sujith Pandel <sujith_pandel@dell.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 14, 2019 at 7:19 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > The _DSM function number validation only happens to succeed when the
> > generic Linux command number translation corresponds with a
> > DSM-family-specific function number. This breaks NVDIMM-N
> > implementations that correctly implement _LSR, _LSW, and _LSI, but do
> > not happen to publish support for DSM function numbers 4, 5, and 6.
> >
> > Recall that the support for _LS{I,R,W} family of methods results in the
> > DIMM being marked as supporting those command numbers at
> > acpi_nfit_register_dimms() time. The DSM function mask is only used for
> > ND_CMD_CALL support of non-NVDIMM_FAMILY_INTEL devices.
> >
> > Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command...")
> > Cc: <stable@vger.kernel.org>
> > Link: https://github.com/pmem/ndctl/issues/78
> > Reported-by: Sujith Pandel <sujith_pandel@dell.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > Sujith, this is a larger change than what you originally tested, but it
> > should behave the same. I wanted to consolidate all the code that
> > handles Linux command number to DIMM _DSM function number translation.
> >
> > If you have a chance to re-test with this it would be much appreciated.
> >
> > Thanks for the report!
> >
> >  drivers/acpi/nfit/core.c |   43 +++++++++++++++++++++++++++++--------------
> >  1 file changed, 29 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index 790691d9a982..d5d64e90ae71 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -409,6 +409,29 @@ static bool payload_dumpable(struct nvdimm *nvdimm, unsigned int func)
> >       return true;
> >  }
> >
> > +static int cmd_to_func(struct nvdimm *nvdimm, unsigned int cmd,
> > +             struct nd_cmd_pkg *call_pkg)
> > +{
> > +     struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>
> Minor nit: Seems like the function could take an nfit_mem parameter instead of an nvdimm.

I was making it symmetric with payload_dumpable()... but not for any
good reason, will change.

>
> > +
> > +     if (cmd == ND_CMD_CALL) {
> > +             int i;
> > +
> > +             if (call_pkg && nfit_mem->family != call_pkg->nd_family)
> > +                     return -ENOTTY;
> > +
> > +             for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
> > +                     if (call_pkg->nd_reserved2[i])
> > +                             return -EINVAL;
> > +             return call_pkg->nd_command;
> > +     }
> > +
> > +     /* Linux ND commands == NVDIMM_FAMILY_INTEL function numbers */
> > +     if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
> > +             return cmd;
> > +     return 0;
>
> Function zero?  Is that really the right thing to return here?

Yes, function zero is never set in n
>
> Cheers,
> Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
