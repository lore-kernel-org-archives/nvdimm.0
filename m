Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E56D21D1E2C5
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 17:05:20 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id k77so10810111oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 17:07:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170818134749.8EBF.E1E9C6FF@jp.fujitsu.com>
References: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
 <20170818134749.8EBF.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Aug 2017 17:07:55 -0700
Message-ID: <CAPcyv4hcjSKCH0--kWWGLX+h38MhFdsa8dCXy_Ascv_9dXtnyg@mail.gmail.com>
Subject: Re: [PATCH 1/3] acpi nfit: move definitions which nfit_test will use
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 9:47 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> To use nfit_test.ko can use the definition of NFIT_CMD_TRANSLATE_SPA,
> the defintion is moved from nfit/core.c to ndctl.h.
>
> Probably, other NFIT_CMD_XXX defintions will be used by nfit_test.ko in future.
> move them to ndctl.h at this time.
>
> ---
>  drivers/acpi/nfit/core.c   | 11 -----------
>  include/uapi/linux/ndctl.h | 11 +++++++++++
>  2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 19182d0..00e49c2 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1621,17 +1621,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>                         acpi_desc);
>  }
>
> -/*
> - * These constants are private because there are no kernel consumers of
> - * these commands.
> - */
> -enum nfit_aux_cmds {
> -        NFIT_CMD_TRANSLATE_SPA = 5,
> -        NFIT_CMD_ARS_INJECT_SET = 7,
> -        NFIT_CMD_ARS_INJECT_CLEAR = 8,
> -        NFIT_CMD_ARS_INJECT_GET = 9,
> -};
> -
>  static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>  {
>         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
> index 6d3c542..a359d19 100644
> --- a/include/uapi/linux/ndctl.h
> +++ b/include/uapi/linux/ndctl.h
> @@ -204,6 +204,17 @@ enum {
>         ND_CMD_CALL = 10,
>  };
>
> +/*
> + * Though These constants are mainly used by acpi nfit driver,
> + * they are defined here for nfit_test.ko to be able to use them.
> + */
> +enum nfit_aux_cmds {
> +        NFIT_CMD_TRANSLATE_SPA = 5,
> +        NFIT_CMD_ARS_INJECT_SET = 7,
> +        NFIT_CMD_ARS_INJECT_CLEAR = 8,
> +        NFIT_CMD_ARS_INJECT_GET = 9,

Like I mentioned in the ndctl patches let's instead move these to a
libndctl-nfit.h header. There's no need for the kernel to export these
command numbers since it only passes them through to the acpi device.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
