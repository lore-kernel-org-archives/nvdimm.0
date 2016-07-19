Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE3371A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 08:53:53 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id j185so31625569oih.0
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 08:53:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468889100-30698-2-git-send-email-vishal.l.verma@intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
 <1468889100-30698-2-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Jul 2016 08:53:02 -0700
Message-ID: <CAPcyv4gpRGJLVfoC3o-rVypQtppkAKg1hObr=1EhcT3Y3g8KUw@mail.gmail.com>
Subject: Re: [PATCH 1/3] pmem: clarify a debug print in pmem_clear_poison
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 18, 2016 at 5:44 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Prefix the sector number being cleared with a '0x' to make it clear that
> this is a hex value.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 608fc44..29ab25b 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -57,7 +57,7 @@ static void pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
>         cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
>
>         if (cleared > 0 && cleared / 512) {
> -               dev_dbg(dev, "%s: %llx clear %ld sector%s\n",
> +               dev_dbg(dev, "%s: 0x%llx clear %ld sector%s\n",

%#llx is a bit smaller / more readable.  Shall I just fix this up on applying?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
