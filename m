Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52BFF211B6C11
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 14:21:21 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id w25so14487477otm.13
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 14:21:21 -0800 (PST)
MIME-Version: 1.0
References: <47b0eaaa-ad49-5062-5f1f-fb6f79b2448d@oracle.com>
 <3908561D78D1C84285E8C5FCA982C28F7D4C4F61@ORSMSX110.amr.corp.intel.com>
 <ca4e6f85-9bf1-9421-5207-ac855882c245@oracle.com>
 <CAPcyv4jo8-Mgoa0=2bD9uTUy17VJGVZvj-Pf_RszPmv=Q_GQpQ@mail.gmail.com>
 <20190111221245.GA6231@agluck-desk>
In-Reply-To: <20190111221245.GA6231@agluck-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 14:21:09 -0800
Message-ID: <CAPcyv4iv5GdmdoCmz4QNz9r6e-GxOPBK-tekJkio_AzhoFKErQ@mail.gmail.com>
Subject: Re: 23222f8f8dce6: acpi, nfit: Add function to look up nvdimm device
 and provide SMBIOS handle
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 11, 2019 at 2:12 PM Luck, Tony <tony.luck@intel.com> wrote:
>
> On Fri, Jan 11, 2019 at 02:07:00PM -0800, Dan Williams wrote:
> > No harm in fixing it up, I'd take that patch if you wrote it up.
>
> Something like this?
>
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 011d3db19c80..22945bf803c8 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -721,6 +721,7 @@ int nfit_get_smbios_id(u32 device_handle, u16 *flags)
>         struct acpi_nfit_memory_map *memdev;
>         struct acpi_nfit_desc *acpi_desc;
>         struct nfit_mem *nfit_mem;
> +       u16 physical_id;
>
>         mutex_lock(&acpi_desc_lock);
>         list_for_each_entry(acpi_desc, &acpi_descs, list) {
> @@ -728,10 +729,11 @@ int nfit_get_smbios_id(u32 device_handle, u16 *flags)
>                 list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
>                         memdev = __to_nfit_memdev(nfit_mem);
>                         if (memdev->device_handle == device_handle) {
> +                               *flags = memdev->flags;
> +                               physical_id = memdev->physical_id;
>                                 mutex_unlock(&acpi_desc->init_mutex);
>                                 mutex_unlock(&acpi_desc_lock);
> -                               *flags = memdev->flags;
> -                               return memdev->physical_id;
> +                               return physical_id;
>                         }
>                 }
>                 mutex_unlock(&acpi_desc->init_mutex);

Yup, looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
