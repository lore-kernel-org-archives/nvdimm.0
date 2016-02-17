Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1455711448-124103-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1455711448-124103-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 17 Feb 2016 09:49:35 -0800
Message-ID: <CAPcyv4inMjmt8eH_=bNE_=NMeYGmS75B5LxB=f7Cd762=3UKyQ@mail.gmail.com>
Subject: Re: [PATCH v1 05/10] ACPI: switch to use generic UUID API
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 17, 2016 at 4:17 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Instead of opencoding the existing library functions let's use them directly.
>
> The conversion fixes a potential bug in int340x_thermal as well since we have
> to use memcmp() on binary data.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/acpi/acpi_extlog.c                        |  8 +++---
>  drivers/acpi/bus.c                                | 29 ++-----------------
>  drivers/acpi/nfit.c                               | 34 +++++++++++------------
>  drivers/acpi/nfit.h                               |  3 +-
>  drivers/acpi/utils.c                              |  4 +--
>  drivers/char/tpm/tpm_crb.c                        |  9 +++---
>  drivers/char/tpm/tpm_ppi.c                        | 20 ++++++-------
>  drivers/gpu/drm/i915/intel_acpi.c                 | 14 ++++------
>  drivers/gpu/drm/nouveau/nouveau_acpi.c            | 20 ++++++-------
>  drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c    |  9 +++---
>  drivers/hid/i2c-hid/i2c-hid.c                     |  9 +++---
>  drivers/iommu/dmar.c                              | 11 ++++----
>  drivers/pci/pci-acpi.c                            | 11 ++++----
>  drivers/pci/pci-label.c                           |  4 +--
>  drivers/thermal/int340x_thermal/int3400_thermal.c |  6 ++--
>  drivers/usb/host/xhci-pci.c                       |  9 +++---
>  include/acpi/acpi_bus.h                           | 10 ++++---
>  include/linux/acpi.h                              |  2 +-
>  include/linux/pci-acpi.h                          |  2 +-
>  sound/soc/intel/skylake/skl-nhlt.c                |  7 +++--
>  20 files changed, 92 insertions(+), 129 deletions(-)
>
[..]
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index ad6d8c6..3beb99b 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -43,11 +43,11 @@ struct nfit_table_prev {
>         struct list_head flushes;
>  };
>
> -static u8 nfit_uuid[NFIT_UUID_MAX][16];
> +static uuid_le nfit_uuid[NFIT_UUID_MAX];
>
> -const u8 *to_nfit_uuid(enum nfit_uuids id)
> +const uuid_le *to_nfit_uuid(enum nfit_uuids id)
>  {
> -       return nfit_uuid[id];
> +       return &nfit_uuid[id];
>  }
>  EXPORT_SYMBOL(to_nfit_uuid);
>
> @@ -83,7 +83,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>         const char *cmd_name, * dimm_name;
>         unsigned long dsm_mask;
>         acpi_handle handle;
> -       const u8 *uuid;
> +       const uuid_le *uuid;
>         u32 offset;
>         int rc, i;
>
> @@ -225,7 +225,7 @@ static int nfit_spa_type(struct acpi_nfit_system_address *spa)
>         int i;
>
>         for (i = 0; i < NFIT_UUID_MAX; i++)
> -               if (memcmp(to_nfit_uuid(i), spa->range_guid, 16) == 0)
> +               if (!uuid_le_cmp(*to_nfit_uuid(i), *(uuid_le *)spa->range_guid))
>                         return i;
>         return -1;
>  }
> @@ -829,7 +829,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  {
>         struct acpi_device *adev, *adev_dimm;
>         struct device *dev = acpi_desc->dev;
> -       const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
> +       const uuid_le *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
>         int i;
>
>         nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
> @@ -909,7 +909,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
>  {
>         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
> -       const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
> +       const uuid_le *uuid = to_nfit_uuid(NFIT_DEV_BUS);
>         struct acpi_device *adev;
>         int i;
>
> @@ -2079,16 +2079,16 @@ static __init int nfit_init(void)
>         BUILD_BUG_ON(sizeof(struct acpi_nfit_control_region) != 80);
>         BUILD_BUG_ON(sizeof(struct acpi_nfit_data_region) != 40);
>
> -       acpi_str_to_uuid(UUID_VOLATILE_MEMORY, nfit_uuid[NFIT_SPA_VOLATILE]);
> -       acpi_str_to_uuid(UUID_PERSISTENT_MEMORY, nfit_uuid[NFIT_SPA_PM]);
> -       acpi_str_to_uuid(UUID_CONTROL_REGION, nfit_uuid[NFIT_SPA_DCR]);
> -       acpi_str_to_uuid(UUID_DATA_REGION, nfit_uuid[NFIT_SPA_BDW]);
> -       acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_VDISK]);
> -       acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_CD, nfit_uuid[NFIT_SPA_VCD]);
> -       acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_PDISK]);
> -       acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_CD, nfit_uuid[NFIT_SPA_PCD]);
> -       acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
> -       acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
> +       uuid_le_to_bin(UUID_VOLATILE_MEMORY, &nfit_uuid[NFIT_SPA_VOLATILE]);
> +       uuid_le_to_bin(UUID_PERSISTENT_MEMORY, &nfit_uuid[NFIT_SPA_PM]);
> +       uuid_le_to_bin(UUID_CONTROL_REGION, &nfit_uuid[NFIT_SPA_DCR]);
> +       uuid_le_to_bin(UUID_DATA_REGION, &nfit_uuid[NFIT_SPA_BDW]);
> +       uuid_le_to_bin(UUID_VOLATILE_VIRTUAL_DISK, &nfit_uuid[NFIT_SPA_VDISK]);
> +       uuid_le_to_bin(UUID_VOLATILE_VIRTUAL_CD, &nfit_uuid[NFIT_SPA_VCD]);
> +       uuid_le_to_bin(UUID_PERSISTENT_VIRTUAL_DISK, &nfit_uuid[NFIT_SPA_PDISK]);
> +       uuid_le_to_bin(UUID_PERSISTENT_VIRTUAL_CD, &nfit_uuid[NFIT_SPA_PCD]);
> +       uuid_le_to_bin(UUID_NFIT_BUS, &nfit_uuid[NFIT_DEV_BUS]);
> +       uuid_le_to_bin(UUID_NFIT_DIMM, &nfit_uuid[NFIT_DEV_DIMM]);

I don't see the benefit of this change.  For the NFIT driver we went
through a fire drill trying to make sure the ACPI spec format of a
UUID matched the Linux interpretation, and this change makes that
harder to determine.  ACPI drivers should use ACPICA uuid helper
routines in my opinion.
