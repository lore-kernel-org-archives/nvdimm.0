Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x236.google.com (mail-vk0-x236.google.com
 [IPv6:2607:f8b0:400c:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADFB721E1DAFE
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 16:07:07 -0700 (PDT)
Received: by mail-vk0-x236.google.com with SMTP id g189so10856989vke.5
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 16:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804180655.27BF.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
 <20170804180655.27BF.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 16:09:19 -0700
Message-ID: <CAPcyv4g7cWsUESUg__RmTGQoV4L+ePM=fzbZdcpiaTEH_bhM0w@mail.gmail.com>
Subject: Re: [RFC/Patch 1/5] Remove old enum definition of "Translate Spa"
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

On Fri, Aug 4, 2017 at 2:06 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Remove old enum definition of "Translate Spa".
>
> Translate SPA becomes standard specification on ACPI 6.2,
> but current definition is likely temporary.
> So it is removed.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
>
> ---
>  drivers/acpi/nfit/core.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 19182d0..5334755 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1626,7 +1626,6 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>   * these commands.
>   */
>  enum nfit_aux_cmds {
> -        NFIT_CMD_TRANSLATE_SPA = 5,
>          NFIT_CMD_ARS_INJECT_SET = 7,
>          NFIT_CMD_ARS_INJECT_CLEAR = 8,
>          NFIT_CMD_ARS_INJECT_GET = 9,
> @@ -1655,7 +1654,6 @@ static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>                 (1 << ND_CMD_ARS_START) |
>                 (1 << ND_CMD_ARS_STATUS) |
>                 (1 << ND_CMD_CLEAR_ERROR) |
> -               (1 << NFIT_CMD_TRANSLATE_SPA) |
>                 (1 << NFIT_CMD_ARS_INJECT_SET) |
>                 (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
>                 (1 << NFIT_CMD_ARS_INJECT_GET);

Hmm, those definitions are brand new as of the 4.13 kernel, see commit
7db5bb33add5 "libnvdimm, acpi, nfit: Add bus level dsm mask for pass
thru". What's going on here is that we stopped defining new ND_CMD
numbers for each new DSM that is added to the specification. Instead,
we use the ND_CMD_CALL mechanism to wrap these new command payloads
and pass them through to the BIOS. So, these definitions are needed to
allow that passthrough mechanism to work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
