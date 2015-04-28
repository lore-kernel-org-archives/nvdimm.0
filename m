Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150428182602.35812.78599.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150428182602.35812.78599.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Apr 2015 14:10:08 -0700
Message-ID: <CALCETrX22LRX0p+xP0hPFEa+jV-pxkNMXyLfahq6f=Pt-LOKGg@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] libnd, nd_acpi, nd_blk: driver for BLK-mode
 access persistent memory
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 11:26 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> The libnd implementation handles allocating dimm address space (DPA)
> between PMEM and BLK mode interfaces.  After DPA has been allocated from
> a BLK-region to a BLK-namespace the nd_blk driver attaches to handle I/O
> as a struct bio based block device. Unlike PMEM, BLK is required to
> handle platform specific details like mmio register formats and memory
> controller interleave.  For this reason the libnd generic nd_blk driver
> calls back into the bus provider to carry out the I/O.
>
> This initial implementation handles the BLK interface defined by the
> ACPI 6 NFIT [1] and the NVDIMM DSM Interface Example [2] composed from
> DCR (dimm control region), BDW (block data window), IDT (interleave
> descriptor) NFIT structures and the hardware register format.
> [1]: http://www.uefi.org/sites/default/files/resources/ACPI_6.0.pdf
> [2]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/block/nd/Kconfig          |   12 +
>  drivers/block/nd/Makefile         |    3
>  drivers/block/nd/acpi.c           |  422 +++++++++++++++++++++++++++++++++++--
>  drivers/block/nd/acpi_nfit.h      |   47 ++++
>  drivers/block/nd/blk.c            |  264 +++++++++++++++++++++++
>  drivers/block/nd/libnd.h          |   11 +
>  drivers/block/nd/namespace_devs.c |   47 ++++
>  drivers/block/nd/nd-private.h     |    3
>  drivers/block/nd/nd.h             |   16 +
>  drivers/block/nd/region.c         |    8 +
>  drivers/block/nd/region_devs.c    |   65 +++++-
>  drivers/block/nd/test/nfit.c      |   29 +++
>  drivers/block/nd/test/nfit_test.h |    2
>  13 files changed, 891 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/block/nd/blk.c
>
> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
> index 612bf2b14283..bac4290129fc 100644
> --- a/drivers/block/nd/Kconfig
> +++ b/drivers/block/nd/Kconfig
> @@ -95,6 +95,18 @@ config BLK_DEV_PMEM
>
>           Say Y if you want to use a NVDIMM described by ACPI, E820, etc...
>
> +config ND_BLK
> +       tristate "BLK: Block data window (aperture) device support"
> +       depends on LIBND
> +       default ND_ACPI
> +       help
> +         This driver performs I/O using a set of mmio windows on a
> +         dimm.  The set of apertures will all access the one DIMM.
> +         Multiple windows allow multiple threads to have a different
> +         portions of the dimm open at one time.
> +
> +         Say Y if you want to use a NVDIMM with BLK-mode capability
> +

This describes how it works, not what it is.  How about:

This driver exposes NVDIMM BLK regions as block devices.  BLK regions
are regions of NVDIMM storage that are sector-addressable, not
byte-addressible, and do not support DAX.

Say Y if you want to...

--Andy
