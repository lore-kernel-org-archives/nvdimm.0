Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7ECC81FE6
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 13:37:03 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id b126so356674933oia.2
 for <linux-nvdimm@lists.01.org>; Mon, 05 Dec 2016 13:37:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480973246-32078-1-git-send-email-vishal.l.verma@intel.com>
References: <1480973246-32078-1-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Dec 2016 13:37:02 -0800
Message-ID: <CAPcyv4hMB3GnphdfRqmoda6ZuxtPvPZM65ksM6tHc-WVBkwDSw@mail.gmail.com>
Subject: Re: [PATCH] nfit: Fix extended status translations for ACPI DSMs
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 5, 2016 at 1:27 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> ACPI DSMs can have an 'extended' status which can be non-zero to convey
> additional information about the command. In the xlat_status routine,
> where we translate the command statuses, we were returning an error for
> a non-zero extended status, even if the primary status indicated success.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 71a7d07..d14f09b 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -169,7 +169,7 @@ static int xlat_status(void *buf, unsigned int cmd, u32 status)
>         }
>
>         /* all other non-zero status results in an error */
> -       if (status)
> +       if (status & 0xffff)
>                 return -EIO;

I don't think this is right, because we have no idea at this point
whether extended status is fatal or not.

Each 'case' statement in that 'switch' should be returning 0 if it
does not see any errors. Because that's the only part of the function
with per-command knowledge of extended being benign / informational vs
fatal.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
