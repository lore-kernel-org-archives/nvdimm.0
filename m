Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FC9681F29
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 17:46:32 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id b126so400352991oia.2
 for <linux-nvdimm@lists.01.org>; Tue, 06 Dec 2016 17:46:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <148107118149.25138.14111118284998590831.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148107115997.25138.3445497812509173966.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148107118149.25138.14111118284998590831.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Dec 2016 17:46:31 -0800
Message-ID: <CAPcyv4h2c+CCHcdQ6h282n=iDJZXF6piPuWDSVvHxXp8EVs5DQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] acpi, nfit: fix bus vs dimm confusion in xlat_status
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 6, 2016 at 4:39 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Given dimms and bus commands share the same command number space we need
> to be careful that we are translating status in the correct context.
> Otherwise we can, for example, fail an ND_CMD_GET_CONFIG_SIZE command
> because max_xfer is zero. It fails because that condition erroneously
> correlates with the 'cleared == 0' failure of ND_CMD_CLEAR_ERROR.
>
> Cc: <stable@vger.kernel.org>
> Fixes: aef253382266 ("libnvdimm, nfit: centralize command status translation")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 4b8b4f520d76..9690b28f0da7 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -94,7 +94,7 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
>         return to_acpi_device(acpi_desc->dev);
>  }
>
> -static int xlat_status(void *buf, unsigned int cmd, u32 status)
> +static int xlat_bus_status(void *buf, unsigned int cmd, u32 status)
>  {
>         struct nd_cmd_clear_error *clear_err;
>         struct nd_cmd_ars_status *ars_status;
> @@ -175,6 +175,15 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
>         return 0;
>  }
>
> +static int xlat_status(struct nvdimm *nvdimm, void *buf, unsigned int cmd,
> +               u32 status)
> +{
> +       if (!nvdimm)
> +               return xlat_bus_status(buf, cmd, status);
> +       if (status)
> +               return -EIO;

Here comes a 0day report:

drivers/acpi/nfit/core.c:185:1: warning: control reaches end of
non-void function [-Wreturn-type]

...fixed up the patch to add a return 0;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
