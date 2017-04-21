Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09B8E2195406E
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 12:21:03 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id y11so76573859oie.0
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 12:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170420221818.23522-1-vishal.l.verma@intel.com>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Apr 2017 12:21:01 -0700
Message-ID: <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: fix the memory error check in nfit_handle_mce
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Tony Luck <tony.luck@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 20, 2017 at 3:18 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The check for an MCE being a memory error in the NFIT mce handler was
> bogus. Fix it to check for the correct MCA status compound error code.
>
> Reported-by: Tony Luck <tony.luck@intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit/mce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/mce.c b/drivers/acpi/nfit/mce.c
> index 3ba1c34..23e12a0 100644
> --- a/drivers/acpi/nfit/mce.c
> +++ b/drivers/acpi/nfit/mce.c
> @@ -26,7 +26,7 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
>         struct nfit_spa *nfit_spa;
>
>         /* We only care about memory errors */
> -       if (!(mce->status & MCACOD))
> +       if (!(mce->status & 0xef80) == BIT(7))

Can we get a define for this, or a comment explaining all the magic
that's happening on that one line?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
