Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 2/4] pmem: Add support for getgeo()
Date: Sun, 2 Nov 2014 03:27:40 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593548D4@G9W0745.americas.hpqcorp.net>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <1409173922-7484-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1409173922-7484-3-git-send-email-ross.zwisler@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Knippers, Linda" <linda.knippers@hp.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Ross Zwisler
> Sent: Wednesday, 27 August, 2014 4:12 PM
> To: Jens Axboe; Matthew Wilcox; Boaz Harrosh; Nick Piggin; linux-
> fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> nvdimm@lists.01.org
> Cc: Ross Zwisler
> Subject: [PATCH 2/4] pmem: Add support for getgeo()
> 
> Some programs require HDIO_GETGEO work, which requires we implement
> getgeo.  Based off of the work done to the NVMe driver in this
> commit:
> 
> commit 4cc09e2dc4cb ("NVMe: Add getgeo to block ops")
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  drivers/block/pmem.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> index d366b9b..60bbe0d 100644
> --- a/drivers/block/pmem.c
> +++ b/drivers/block/pmem.c
> @@ -50,6 +50,15 @@ struct pmem_device {
>  	size_t			size;
>  };
> 
> +static int pmem_getgeo(struct block_device *bd, struct hd_geometry
> *geo)
> +{
> +	/* some standard values */
> +	geo->heads = 1 << 6;
> +	geo->sectors = 1 << 5;
> +	geo->cylinders = get_capacity(bd->bd_disk) >> 11;

Just stuffing the result of get_capacity into the 16-bit 
cylinders field will overflow/wrap on large capacities.
0xFFFF << 11 = 0x7FF_F800 = 64 GiB (68.7 GB)

How many programs still need these meaningless fields?
Could the bogus information be created elsewhere so
each block driver doesn't need to do this?


> +	return 0;
> +}
> +
>  /*
>   * direct translation from (pmem,sector) => void*
>   * We do not require that sector be page aligned.
> @@ -176,6 +185,7 @@ out:
> 
>  static const struct block_device_operations pmem_fops = {
>  	.owner =		THIS_MODULE,
> +	.getgeo =		pmem_getgeo,
>  };
> 
>  /* Kernel module stuff */
> --


---
Rob Elliott    HP Server Storage



