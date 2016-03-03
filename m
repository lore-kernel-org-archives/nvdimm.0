Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 864B41A1ED2
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 13:27:43 -0800 (PST)
Received: by mail-oi0-x22d.google.com with SMTP id d205so24904241oia.0
 for <linux-nvdimm@lists.01.org>; Thu, 03 Mar 2016 13:27:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457040097-10038-1-git-send-email-vishal.l.verma@intel.com>
References: <1457040097-10038-1-git-send-email-vishal.l.verma@intel.com>
Date: Thu, 3 Mar 2016 13:27:32 -0800
Message-ID: <CAPcyv4gZjaAGD_W-oWN7x+QpgEVzDcoXFCxxQAa70C19yuUOYQ@mail.gmail.com>
Subject: Re: [PATCH] nfit: Continue init even if ARS_CAP is unimplemented
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 3, 2016 at 1:21 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> If firmware doesn't implement any of the ARS commands, take that to
> mean that ARS is unsupported, and continue to initialize regions without
> bad block lists. We cannot make the assumption that ARS commands will be
> unconditionally supported on all NVDIMMs.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index fb53db1..df99e33 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1590,14 +1590,21 @@ static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
>         start = ndr_desc->res->start;
>         len = ndr_desc->res->end - ndr_desc->res->start + 1;
>
> +       /*
> +        * If ARS is unimplemented, unsupported, or if the 'Persistent Memory
> +        * Scrub' flag in extended status is not set, skip this but continue
> +        * initialization
> +        */
>         rc = ars_get_cap(nd_desc, ars_cap, start, len);
> +       if (rc == -ENOTTY) {
> +               dev_warn(acpi_desc->dev,
> +                       "ARS_CAP is not implemented, won't create an error list\n");

s/ARS_CAP/Address range scrub/

Also, let's make this dev_dbg(), since it's not a requirement that a
bus provider implement scrub commands.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
