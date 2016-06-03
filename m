Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81F5E1A1DFD
 for <linux-nvdimm@lists.01.org>; Fri,  3 Jun 2016 12:27:52 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id e72so142271845oib.1
 for <linux-nvdimm@lists.01.org>; Fri, 03 Jun 2016 12:27:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464938015-5489-1-git-send-email-jlee@suse.com>
References: <1464938015-5489-1-git-send-email-jlee@suse.com>
Date: Fri, 3 Jun 2016 12:27:34 -0700
Message-ID: <CAPcyv4iLb9qzXZTLL5z-RH_CRObnRfzx=vGTvVvieJUEwNvtRw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, nfit: treat volatile virtual CD region as
 read-only pmem
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
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi  <jlee@suse.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Gary Lin" <GLin@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 3, 2016 at 12:13 AM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> This patch adds codes to treat a volatile virtual CD region as a
> read-only pmem region, then read-only /dev/pmem* device can be mounted
> with iso9660.
>
> It's useful to work with the httpboot in EFI firmware to pull a remote
> ISO file to the local memory region for booting and installation.
>
> Wiki page of UEFI HTTPBoot with OVMF:
>         https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF
>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> Cc: Gary Lin <GLin@suse.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> ---
>  drivers/acpi/nfit.c          |  8 +++++++-
>  drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
>  include/linux/libnvdimm.h    |  2 ++
>  3 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 2215fc8..b100a17 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1949,6 +1949,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
>         switch (nfit_spa_type(spa)) {
>         case NFIT_SPA_PM:
>         case NFIT_SPA_VOLATILE:
> +       case NFIT_SPA_VCD:
>                 nd_mapping->start = memdev->address;
>                 nd_mapping->size = memdev->region_size;
>                 break;

Why do we need to distinguish NFIT_SPA_VOLATILE vs NFIT_SPA_VCD, i.e.
what happens if something writes to a VCD device?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
