Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1435193949.11808.319.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7 00/16] libnvdimm: non-volatile memory devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Wed, 24 Jun 2015 18:59:09 -0600
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, rafael@kernel.org, neilb@suse.de, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, sfr@canb.auug.org.au, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, mingo@kernel.org, linux-acpi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-06-17 at 19:13 -0400, Dan Williams wrote:
> A new sub-system in support of non-volatile memory storage devices.
> 
> Stephen, please add libnvdimm-for-next to -next:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm libnvdimm-for-next
> 
> Changes since v6 [1]:
> 
> 1/ Deferred the patches dependent on ->rw_bytes() (BTT - stacked block
>    driver, BLK - mmio aperture windows driver, NFIT_TEST - unit test
>    infrastructure for all libnvdimm + nfit components) to their own
>    patchset. Make the ->rw_bytes() implementation the first patch in
>    that series (Christoph)
> 
> 2/ Collected acks from Christoph and Rafael!
> 
> 3/ Add a HAS_IOMEM dependency to CONFIG_BLK_DEV_PMEM following commit
>    b6f2098fb708 "block: pmem: Add dependency on HAS_IOMEM" in 4.1-rc8.
> 
> 4/ Move libnvdimm to subsys_initcall() and move arch/x86/kernel/pmem.c
>    back to device_initcall().  This allows ACPI_NFIT to be built-in.
>    (Linda)
> 
> 5/ Drop the ACPI_DRIVER_ALL_NOTIFY_EVENTS flag in the nfit driver.
>    (Rafael)
> 
> 6/ Reference count the nvdimm_drvdata object.  This fixes a bug that was
>    found when the unit tests were extended to test disabling an nvdimm
>    while a region device still had references to label data.
> 
 :
> Dan Williams (16):
>       e820, efi: add ACPI 6.0 persistent memory types
>       libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support
>       libnvdimm: control character device and nvdimm_bus sysfs attributes
>       libnvdimm, nfit: dimm/memory-devices
>       libnvdimm: control (ioctl) messages for nvdimm_bus and nvdimm devices
>       libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure
>       libnvdimm, nfit: regions (block-data-window, persistent memory, volatile memory)
>       libnvdimm: support for legacy (non-aliasing) nvdimms
>       libnvdimm, pmem: move pmem to drivers/nvdimm/
>       libnvdimm, pmem: add libnvdimm support to the pmem driver
>       libnvdimm, nfit: add interleave-set state-tracking infrastructure
>       libnvdimm: namespace indices: read and validate
>       libnvdimm: pmem label sets and namespace instantiation.
>       libnvdimm: blk labels and namespace instantiation
>       libnvdimm: write pmem label set
>       libnvdimm: write blk label set

We have been successfully running this patchset on our NFIT-enabled
prototype systems with pmem.  (Intel example _DSM, label, blk are not
available for testing.)

So for patch 1/16 to 4/15, and 6/16 to 10/16. 

Tested-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

