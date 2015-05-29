Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1432852553-24865-5-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
	<1432852553-24865-5-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 29 May 2015 07:11:16 -0700
Message-ID: <CAPcyv4g+hX2NCdH6HdjUBVP-k8_qPe5Z1FRJsp=ciz3NPsySnQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] pmem, nd_blk: update I/O paths to use PMEM API
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 28, 2015 at 3:35 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Update the PMEM and ND_BLK I/O paths to use the new PMEM API and to
> adhere to the read/write flows outlined in the "NVDIMM Block Window
> Driver Writer's Guide":
>
> http://pmem.io/documents/NVDIMM_Driver_Writers_Guide.pdf
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/nfit.c     | 10 ++++++++--
>  drivers/block/nd/pmem.c | 15 +++++++++++----
>  2 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index df14652ea13e..22df61968c1c 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -18,6 +18,7 @@
>  #include <linux/list.h>
>  #include <linux/acpi.h>
>  #include <linux/sort.h>
> +#include <linux/pmem.h>
>  #include <linux/io.h>
>  #include "nfit.h"
>
> @@ -926,7 +927,9 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
>         if (mmio->num_lines)
>                 offset = to_interleave_offset(offset, mmio);
>
> +       /* mmio->base must be mapped uncacheable */
>         writeq(cmd, mmio->base + offset);
> +       persistent_sync();
>         /* FIXME: conditionally perform read-back if mandated by firmware */
>  }
>
> @@ -940,7 +943,6 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk, void *iobuf,
>         int rc;
>
>         base_offset = nfit_blk->bdw_offset + dpa % L1_CACHE_BYTES + bw * mmio->size;
> -       /* TODO: non-temporal access, flush hints, cache management etc... */
>         write_blk_ctl(nfit_blk, bw, dpa, len, write);
>         while (len) {
>                 unsigned int c;
> @@ -959,13 +961,17 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk, void *iobuf,
>                 }
>
>                 if (write)
> -                       memcpy(mmio->aperture + offset, iobuf + copied, c);
> +                       persistent_copy(mmio->aperture + offset, iobuf + copied, c);
>                 else
>                         memcpy(iobuf + copied, mmio->aperture + offset, c);
>
>                 copied += c;
>                 len -= c;
>         }
> +
> +       if (write)
> +               persistent_sync();
> +
>         rc = read_blk_stat(nfit_blk, bw) ? -EIO : 0;
>         return rc;
>  }
> diff --git a/drivers/block/nd/pmem.c b/drivers/block/nd/pmem.c
> index a8712e41e7f5..1a447c351aef 100644
> --- a/drivers/block/nd/pmem.c
> +++ b/drivers/block/nd/pmem.c
> @@ -15,15 +15,16 @@
>   * more details.
>   */
>
> -#include <asm/cacheflush.h>
>  #include <linux/blkdev.h>
>  #include <linux/hdreg.h>
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
> +#include <linux/pmem.h>
>  #include <linux/slab.h>
>  #include <linux/nd.h>
> +#include <asm/cacheflush.h>
>  #include "nd.h"
>
>  struct pmem_device {
> @@ -51,7 +52,7 @@ static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
>                 flush_dcache_page(page);
>         } else {
>                 flush_dcache_page(page);
> -               memcpy(pmem->virt_addr + pmem_off, mem + off, len);
> +               persistent_copy(pmem->virt_addr + pmem_off, mem + off, len);
>         }
>
>         kunmap_atomic(mem);
> @@ -82,6 +83,8 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
>                 sector += bvec.bv_len >> 9;
>         }
>
> +       if (rw & WRITE)
> +               persistent_sync();
>  out:
>         bio_endio(bio, err);
>  }
> @@ -92,6 +95,8 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>         struct pmem_device *pmem = bdev->bd_disk->private_data;
>
>         pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
> +       if (rw & WRITE)
> +               persistent_sync();
>         page_endio(page, rw & WRITE, 0);
>
>         return 0;
> @@ -111,8 +116,10 @@ static int pmem_rw_bytes(struct nd_io *ndio, void *buf, size_t offset,
>
>         if (rw == READ)
>                 memcpy(buf, pmem->virt_addr + offset, n);
> -       else
> -               memcpy(pmem->virt_addr + offset, buf, n);
> +       else {
> +               persistent_copy(pmem->virt_addr + offset, buf, n);
> +               persistent_sync();
> +       }
>

It bothers me that persistent_sync() is a lie for almost every system
on the planet.  Even though uncached mappings are not sufficient for
guaranteeing persistence the potential damage is minimized.   To me it
seems the driver should have separate I/O paths for the persistent and
non-persistent case determined and notified at init time.  I.e.
arrange to never call persistent_sync() when it is known to be a nop
and tell the user "btw, your data is at risk".
