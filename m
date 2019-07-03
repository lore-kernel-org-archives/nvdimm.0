Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
 [209.85.210.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3AE2212ACEAE
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 04:12:48 -0700 (PDT)
Received: by mail-ot1-f66.google.com with SMTP id b7so1887599otl.11
 for <linux-nvdimm@lists.01.org>; Wed, 03 Jul 2019 04:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <156140036490.2951909.1837804994781523185.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156140042119.2951909.7727308817426477621.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156140042119.2951909.7727308817426477621.stgit@dwillia2-desk3.amr.corp.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 3 Jul 2019 13:12:36 +0200
Message-ID: <CAJZ5v0gzRar8oowUSw0Z9_uofcbZCirmaYFmbjBvDrDAp4W5SA@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] acpi/numa/hmat: Register HMAT at device_initcall
 level
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
Cc: the arch/x86 maintainers <x86@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 24, 2019 at 8:34 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> In preparation for registering device-dax instances for accessing EFI
> specific-purpose memory, arrange for the HMAT registration to occur
> later in the init process. Critically HMAT initialization needs to occur
> after e820__reserve_resources_late() which is the point at which the
> iomem resource tree is populated with "Application Reserved"
> (IORES_DESC_APPLICATION_RESERVED). e820__reserve_resources_late()
> happens at subsys_initcall time.
>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/numa/hmat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> index 2c220cb7b620..1d329c4af3bf 100644
> --- a/drivers/acpi/numa/hmat.c
> +++ b/drivers/acpi/numa/hmat.c
> @@ -671,4 +671,4 @@ static __init int hmat_init(void)
>         acpi_put_table(tbl);
>         return 0;
>  }
> -subsys_initcall(hmat_init);
> +device_initcall(hmat_init);
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
