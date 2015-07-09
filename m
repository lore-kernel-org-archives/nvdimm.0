Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1436371221-30296-4-git-send-email-ross.zwisler@linux.intel.com>
References: <1436371221-30296-1-git-send-email-ross.zwisler@linux.intel.com>
	<1436371221-30296-4-git-send-email-ross.zwisler@linux.intel.com>
Date: Wed, 8 Jul 2015 18:32:55 -0700
Message-ID: <CAPcyv4hCvQv5zO9Tfnqq+wZ1djZM8-4N2nXqnLVzsPmP7ur1sw@mail.gmail.com>
Subject: Re: [PATCH 3/3] nfit: add support for NVDIMM "latch" flag
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 8, 2015 at 9:00 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add support in the NFIT BLK I/O path for the "latch" flag
> defined in the "Get Block NVDIMM Flags" _DSM function:
>
> http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
>
> This flag requires the driver to read back the command register after it
> is written in the block I/O path.  This ensures that the hardware has
> fully processed the new command and moved the aperture appropriately.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-acpi@vger.kernel.org
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/nfit.c | 33 ++++++++++++++++++++++++++++++++-
>  drivers/acpi/nfit.h |  6 ++++++
>  2 files changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index b3c446412f61..9062c11c1062 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1059,7 +1059,9 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
>
>         writeq(cmd, mmio->base + offset);
>         wmb_blk(nfit_blk);
> -       /* FIXME: conditionally perform read-back if mandated by firmware */
> +
> +       if (nfit_blk->dimm_flags & ND_BLK_DCR_LATCH)
> +               readq(mmio->base + offset);
>  }
>
>  static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
> @@ -1258,6 +1260,28 @@ static int nfit_blk_init_interleave(struct nfit_blk_mmio *mmio,
>         return 0;
>  }
>
> +static int acpi_nfit_blk_get_flags(struct nvdimm_bus_descriptor *nd_desc,
> +               struct nvdimm *nvdimm, struct nfit_blk *nfit_blk)
> +{
> +       struct nd_cmd_dimm_flags flags;
> +       int rc;
> +
> +       memset(&flags, 0, sizeof(flags));
> +       rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_DIMM_FLAGS, &flags,
> +                       sizeof(flags));
> +
> +       if (rc >= 0) {
> +               if (!flags.status)
> +                       nfit_blk->dimm_flags = flags.flags;

Subjective nit, I tend to prefer the form (flags.status == 0) for
positive cases.  (!flags.status) reads like an error handling case to
me.

> +               else if (flags.status == ND_DSM_STATUS_NOT_SUPPORTED)
> +                       nfit_blk->dimm_flags = 0; /* as per the _DSM spec */

The spec says if command is "not implemented", I would treat "not
supported" like any other non-zero flags.status value and return a
failure.

> +               else
> +                       rc = -EINVAL;

s/EINVAL/ENXIO/ as it is a failure to run the command, not necessarily
bad parameters.

> +       }
> +
> +       return rc;

This ends up treating -ENOTTY as an error when it is really just an
indication that the flags DSM is not implemented.  We should return
zero in that case.

> +}
> +
>  static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
>                 struct device *dev)
>  {
> @@ -1333,6 +1357,13 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
>                 return rc;
>         }
>
> +       rc = acpi_nfit_blk_get_flags(nd_desc, nvdimm, nfit_blk);
> +       if (rc < 0) {
> +               dev_dbg(dev, "%s: %s failed get DIMM flags\n",
> +                               __func__, nvdimm_name(nvdimm));
> +               return rc;
> +       }
> +
>         nfit_flush = nfit_mem->nfit_flush;
>         if (nfit_flush && nfit_flush->flush->hint_count != 0) {
>                 struct acpi_nfit_flush_address *flush = nfit_flush->flush;
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index d284729cc37c..98e36ca0dfc2 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -40,6 +40,11 @@ enum nfit_uuids {
>         NFIT_UUID_MAX,
>  };
>
> +enum {
> +       ND_BLK_DCR_LATCH = 2,
> +       ND_DSM_STATUS_NOT_SUPPORTED = 1,

Unless it becomes clear that we need this for debug I'd prefer to not
implement the error status flags at this point and just treat non-zero
status flags generically as -ENXIO.

> +};
> +
>  struct nfit_spa {
>         struct acpi_nfit_system_address *spa;
>         struct list_head list;
> @@ -131,6 +136,7 @@ struct nfit_blk {
>         u64 stat_offset;
>         u64 cmd_offset;
>         void __iomem *nvdimm_flush;
> +       u32 dimm_flags;
>  };
>
>  struct nfit_spa_mapping {
> --
> 1.9.3
>
