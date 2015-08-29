Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1440807366-31223-1-git-send-email-toshi.kani@hp.com>
References: <1440807366-31223-1-git-send-email-toshi.kani@hp.com>
Date: Fri, 28 Aug 2015 20:34:11 -0700
Message-ID: <CAPcyv4jQyTM2CcC8emoWf5uiO-LtC99sPZ_vHBKDN5ckBpsTWA@mail.gmail.com>
Subject: Re: [PATCH] pmem, nfit: Fix ARCH_MEMREMAP_PMEM handling on x86_32
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 28, 2015 at 5:16 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> ARCH_MEMREMAP_PMEM is defined on x86_64 only per ARCH_HAS_PMEM_API.
> The following compile error in __nfit_spa_map() was observed on
> x86_32 as it refers ARCH_MEMREMAP_PMEM without #ifdef.
>
>   drivers/acpi/nfit.c:1205:8: error: 'ARCH_MEMREMAP_PMEM'
>   undeclared (first use in this function)
>
> Fix it by defining ARCH_MEMREMAP_PMEM to MEMREMAP_WT in <linux/pmem.h>
> when CONFIG_ARCH_HAS_PMEM_API is not set, i.e. x86_32.
>
> Remove '#ifdef ARCH_MEMREMAP_PMEM's that are no longer necessary
> with this change.
>
> Also remove the redundant definition of ARCH_MEMREMAP_PMEM in
> <asm/pmem.h>.
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ----
> Apply on top of libnvdimm-for-next of the nvdimm tree.

Thanks Toshi, I'll fold this in to prevent bisection breakage.
