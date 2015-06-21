Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150621100535.GB5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235508.12943.25057.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621100535.GB5915@lst.de>
Date: Sun, 21 Jun 2015 06:31:38 -0700
Message-ID: <CAPcyv4hBQy4syM=kAKX8ekNQRiAmCt3e+GbcHi=_Bht96f6FJw@mail.gmail.com>
Subject: Re: [PATCH 04/15] libnvdimm, nfit, nd_blk: driver for BLK-mode access
 persistent memory
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 3:05 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +#include <asm-generic/io-64-nonatomic-hi-lo.h>
>
> As mentioned last time only arch asm/ headers may include asm-generic
> headers.

No, not in this case, there's no other way to define readq()/writeq()
on 32-bit builds.  See:

drivers/block/nvme-core.c:43:#include <asm-generic/io-64-nonatomic-lo-hi.h>
drivers/edac/i3200_edac.c:18:#include <asm-generic/io-64-nonatomic-lo-hi.h>
drivers/edac/ie31200_edac.c:42:#include <asm-generic/io-64-nonatomic-lo-hi.h>
drivers/edac/x38_edac.c:18:#include <asm-generic/io-64-nonatomic-lo-hi.h>
drivers/i2c/busses/i2c-ismt.c:70:#include <asm-generic/io-64-nonatomic-lo-hi.h>
drivers/net/ethernet/intel/i40e/i40e_osdep.h:38:#include
<asm-generic/io-64-nonatomic-lo-hi.h>
drivers/net/ethernet/intel/i40evf/i40e_osdep.h:37:#include
<asm-generic/io-64-nonatomic-lo-hi.h>
drivers/net/ethernet/rocker/rocker.c:39:#include
<asm-generic/io-64-nonatomic-lo-hi.h>
drivers/platform/x86/ibm_rtl.c:36:#include <asm-generic/io-64-nonatomic-lo-hi.h>
drivers/platform/x86/intel_ips.c:81:#include
<asm-generic/io-64-nonatomic-lo-hi.h>
drivers/scsi/qla4xxx/ql4_nx.c:15:#include <asm-generic/io-64-nonatomic-lo-hi.h>

The only other option is to open code multiple readl() + writel() calls.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
