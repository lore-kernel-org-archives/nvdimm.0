Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH v3 18/21] nd_btt: atomic sector updates
Date: Fri, 22 May 2015 21:16:21 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A91FF1A@G9W0745.americas.hpqcorp.net>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150520205749.32249.9040.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150520205749.32249.9040.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "neilb@suse.de" <neilb@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Wednesday, May 20, 2015 3:58 PM
> To: axboe@kernel.dk
> Cc: mingo@kernel.org; linux-nvdimm@lists.01.org; neilb@suse.de;
> gregkh@linuxfoundation.org; Dave Chinner; linux-kernel@vger.kernel.org; Andy
> Lutomirski; Jens Axboe; linux-acpi@vger.kernel.org; H. Peter Anvin;
> hch@lst.de
> Subject: [PATCH v3 18/21] nd_btt: atomic sector updates
> 
> From: Vishal Verma <vishal.l.verma@linux.intel.com>
> 
...
> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
> index 00d9afe9475e..2b169806eac5 100644
> --- a/drivers/block/nd/Kconfig
> +++ b/drivers/block/nd/Kconfig
> @@ -32,9 +32,25 @@ config BLK_DEV_PMEM
>  	  capable of DAX (direct-access) file system mappings.  See
>  	  Documentation/blockdev/nd.txt for more details.
> 
> -	  Say Y if you want to use a NVDIMM described by NFIT
> +	  Say Y if you want to use a NVDIMM described by ACPI, E820, etc...
> 
>  config ND_BTT_DEVS
> -	def_bool y
> +	bool
> +
> +config ND_BTT
> +	tristate "BTT: Block Translation Table (atomic sector updates)"
> +	depends on LIBND
> +	default LIBND
> +	select ND_BTT_DEVS

The ND_BTT option, which is presented during a kernel build,
is missing help text. So is E820_PMEM in patch 3/21.

---
Robert Elliott, HP Server Storage
