Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x231.google.com (mail-yb0-x231.google.com
 [IPv6:2607:f8b0:4002:c09::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD3F321C943C4
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:24:46 -0700 (PDT)
Received: by mail-yb0-x231.google.com with SMTP id v197so8160166ybv.3
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:26:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170629232627.GE6065@anatevka.americas.hpqcorp.net>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
 <f332778c416d01fd76ce8e474acd583e1b787c29.1498754314.git.jerry.hoemann@hpe.com>
 <CAPcyv4hjw50P2YsqQxzBMhVesj7rxXJ-PdxNw6Gan3Wj7UMMeQ@mail.gmail.com>
 <20170629214735.GC6065@anatevka.americas.hpqcorp.net>
 <CAPcyv4j+t542u_VWA6_WANtW8q3tSumo2Ui9z+XSSAvvENPu8Q@mail.gmail.com>
 <20170629232627.GE6065@anatevka.americas.hpqcorp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 18:26:18 -0700
Message-ID: <CAPcyv4iibEPerTokfKKrCZubZg6pov+-PwSwMgA5CMmtnpBBhQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] acpi, nfit: Use bus_dsm_mask for passthru
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 4:26 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Thu, Jun 29, 2017 at 02:55:55PM -0700, Dan Williams wrote:
>> On Thu, Jun 29, 2017 at 2:47 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Thu, Jun 29, 2017 at 02:35:14PM -0700, Dan Williams wrote:
>> >> On Thu, Jun 29, 2017 at 9:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> > Populate bus_dsm_mask and use it to filter dsm calls that user can
>> >> > make through the pass thru interface.
>> >> >
>> >> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
>> >> > ---
>> >> >  drivers/acpi/nfit/core.c | 5 +++++
>> >> >  1 file changed, 5 insertions(+)
>> >> >
>> >> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>> >> > index b46fca2..971002b 100644
>> >> > --- a/drivers/acpi/nfit/core.c
>> >> > +++ b/drivers/acpi/nfit/core.c
>> >> > @@ -253,6 +253,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>> >> >                 cmd_name = nvdimm_bus_cmd_name(cmd);
>> >> >                 cmd_mask = nd_desc->cmd_mask;
>> >> >                 dsm_mask = cmd_mask;
>> >> > +               if (cmd == ND_CMD_CALL)
>> >> > +                       dsm_mask = nd_desc->bus_dsm_mask;
>> >> >                 desc = nd_cmd_bus_desc(cmd);
>> >> >                 uuid = to_nfit_uuid(NFIT_DEV_BUS);
>> >> >                 handle = adev->handle;
>> >> > @@ -1624,6 +1626,9 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>> >> >                 if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
>> >> >                         set_bit(i, &nd_desc->cmd_mask);
>> >> >         set_bit(ND_CMD_CALL, &nd_desc->cmd_mask);
>> >> > +       for (i = 0; i < ND_CMD_CALL; i++)
>> >> > +               if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
>> >> > +                       set_bit(i, &nd_desc->bus_dsm_mask);
>> >> >  }
>> >>
>> >> This loop checks for function 6 which is specified as reserved. Lets
>> >> explicitly test for the known good function numbers with something
>> >> like this:
>> >>
>> >> /* this should be private in drivers/acpi/nfit/nfit.h */
>> >> enum nfit_aux_cmds {
>> >>         NFIT_CMD_TRANSLATE_SPA = 5,
>> >>         NFIT_CMD_ARS_INJECT_SET = 7,
>> >>         NFIT_CMD_ARS_INJECT_CLEAR = 8,
>> >>         NFIT_CMD_ARS_INJECT_GET = 9,
>> >> };
>> >>
>> >> bus_dsm_mask =
>> >>         (1 << ND_CMD_ARS_CAP) |
>> >>         (1 << ND_CMD_ARS_START) |
>> >>         (1 << ND_CMD_ARS_STATUS) |
>> >>         (1 << ND_CMD_CLEAR_ERROR) |
>> >>         (1 << NFIT_CMD_TRANSLATE_SPA) |
>> >>         (1 << NFIT_CMD_ARS_INJECT_SET) |
>> >>         (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
>> >>         (1 << NFIT_CMD_ARS_INJECT_GET);
>> >>
>> >> for_each_set_bit(i, &bus_dsm_mask...
>> >
>> >
>> >   I added the for_each_set_bit check in patch 7 of the series.
>>
>> True, but in a patch series we shouldn't introduce a bug in one patch
>> and fix it later in the same series. Also, if patch7 goes away we
>> would need to fold that enabling in here.
>>
>
> A bug?   What bad thing happens?
>

Ok, yes, not a bug, but in general terms if the review feedback is
"patch4 has an issue" the answer (usually) can't be "but I I fix it in
patch7". That instead means the fix in patch7 needs to move to patch4.
So this is purely a Linux patch-review / process comment.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
