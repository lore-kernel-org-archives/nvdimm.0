Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 537881A1E46
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 14:49:37 -0800 (PST)
Received: by mail-oi0-x236.google.com with SMTP id r187so26143944oih.3
 for <linux-nvdimm@lists.01.org>; Thu, 03 Mar 2016 14:49:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456959056-12316-5-git-send-email-toshi.kani@hpe.com>
References: <1456959056-12316-1-git-send-email-toshi.kani@hpe.com>
 <1456959056-12316-5-git-send-email-toshi.kani@hpe.com>
Date: Thu, 3 Mar 2016 14:49:26 -0800
Message-ID: <CAPcyv4ibLoKSe06P4WTHiQ6x=hoTfEmCvVKGv9hJ4Z7++2PN-w@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ACPI: Change NFIT driver to insert new resource
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 2, 2016 at 2:50 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> ACPI 6.0 defines persistent memory (PMEM) ranges in multiple
> firmware interfaces, e820, EFI, and ACPI NFIT table.  This EFI
> change, however, leads to hit a bug in the grub bootloader, which
> treats EFI_PERSISTENT_MEMORY type as regular memory and corrupts
> stored user data [1].
>
> Therefore, BIOS may set generic reserved type in e820 and EFI
> to cover PMEM ranges.  The kernel can initialize PMEM ranges
> from ACPI NFIT table alone.
>
> This scheme causes a problem in the iomem table, though.  On x86,
> for instance, e820_reserve_resources() initializes top-level entries
> (iomem_resource.child) from the e820 table at early boot-time.
> This creates "reserved" entry for a PMEM range, which does not allow
> region_intersects() to check with PMEM type.
>
> Change acpi_nfit_register_region() to call acpi_nfit_insert_resource(),
> which calls devm_insert_resource() to insert a PMEM entry from NFIT
> when the iomem table does not have a PMEM entry already.  That is,
> when a PMEM range is marked as reserved type in e820, it inserts
> "Persistent Memory" entry, which results as follows.
>
>  + "Persistent Memory"
>     + "reserved"
>
> This allows the EINJ driver, which calls region_intersects() to
> check PMEM ranges, to work continuously even if BIOS sets reserved
> type (or sets nothing) to PMEM ranges in e820 and EFI.
>
> [1]: https://lists.gnu.org/archive/html/grub-devel/2015-11/msg00209.html
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/acpi/nfit.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index fb53db1..d97b53f 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1571,6 +1571,30 @@ static int ars_status_process_records(struct nvdimm_bus *nvdimm_bus,
>         return 0;
>  }
>
> +static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
> +               struct nd_region_desc *ndr_desc)
> +{
> +       struct resource *res, *nd_res = ndr_desc->res;
> +       size_t size = nd_res->end - nd_res->start + 1;
> +
> +       /* No operation if the region is already registered as PMEM */
> +       if (region_intersects(nd_res->start, size, IORESOURCE_MEM,
> +                       IORES_DESC_PERSISTENT_MEMORY) == REGION_INTERSECTS)
> +               return 0;
> +
> +       res = devm_kzalloc(acpi_desc->dev, sizeof(*res), GFP_KERNEL);

How about allocating this resource on the stack and then have
devm_insert_resource handle the dynamic allocation (memdup) so we have
one less failure point to handle in the driver.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
