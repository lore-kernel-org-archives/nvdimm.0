Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50A41211B1584
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 12:39:16 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 0/2] acpi/nfit: Fix command-supported detection
References: <154751742416.1617064.8252289468130584022.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49tvia80r0.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4htfew=7D_B1QDGTwSkMTx7BK2BZ+Gq+9UL1NTtqtL9FQ@mail.gmail.com>
Date: Tue, 15 Jan 2019 15:39:13 -0500
In-Reply-To: <CAPcyv4htfew=7D_B1QDGTwSkMTx7BK2BZ+Gq+9UL1NTtqtL9FQ@mail.gmail.com>
 (Dan Williams's message of "Tue, 15 Jan 2019 08:48:18 -0800")
Message-ID: <x49k1j57j0u.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Sujith Pandel <sujith_pandel@dell.com>, stuart hayes <stuart.w.hayes@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Tue, Jan 15, 2019 at 6:16 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>> > Changes since v1 [1]:
>> > * Include another patch make sure that function-number zero can be
>> >   safely used as an invalid function number (Jeff)
>> > * Add a comment clarifying why zero is an invalid function number (Jeff)
>> > * Pass nfit_mem to cmd_to_func() (Jeff)
>> > * Collect a Tested-by from Sujith
>> > [1]: https://lists.01.org/pipermail/linux-nvdimm/2019-January/019435.html
>>
>> For the series:
>>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> Thanks, Dan!
>
> Thanks, although I just realized one more change. The ND_CMD_CALL case
> should zero out command after the function translation, otherwise
> userspace can call functions that the kernel is blocking in the
> dsm_mask.
>
> Holler if this invalidates your "Reviewed-by".

AAAAAAAHHHHHHHHHH!!!!

:)

> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 87e02f281e51..d7747aceb7ab 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -463,6 +463,12 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor
> *nd_desc, struct nvdimm *nvdimm,
>                 func = cmd_to_func(nfit_mem, cmd, buf);
>                 if (func < 0)
>                         return func;
> +               /*
> +                * In the ND_CMD_CALL case we're now dependent on 'func'
> +                * being validated by the dimm's dsm_mask
> +                */
> +               if (cmd == ND_CMD_CALL)
> +                       cmd = 0;
>                 dimm_name = nvdimm_name(nvdimm);
>                 cmd_name = nvdimm_cmd_name(cmd);
>                 cmd_mask = nvdimm_cmd_mask(nvdimm);
                dsm_mask = nfit_mem->dsm_mask;
                desc = nd_cmd_dimm_desc(cmd);

That sure doesn't look right.  Now cmd_name and desc will be wrong.

> @@ -477,8 +483,10 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor
> *nd_desc, struct nvdimm *nvdimm,
>                 cmd_name = nvdimm_bus_cmd_name(cmd);
>                 cmd_mask = nd_desc->cmd_mask;
>                 dsm_mask = cmd_mask;
> -               if (cmd == ND_CMD_CALL)
> +               if (cmd == ND_CMD_CALL) {
>                         dsm_mask = nd_desc->bus_dsm_mask;
> +                       cmd = 0;
> +               }
>                 desc = nd_cmd_bus_desc(cmd);

And again here.

We could reorder the zeroing, or you could modify the check for a valid
comand/function.  Something like this?

	/*
         * Check for a valid command.  For ND_CMD_CALL, we also
         * have to make sure that the DSM function is supported.
         */
	if (cmd == ND_CMD_CALL && !test_bit(func, &dsm_mask))
        	return -ENOTTY;
	else if (!test_bit(cmd, &cmd_mask))
		return -ENOTTY;

Which way do you think is cleaner?

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
