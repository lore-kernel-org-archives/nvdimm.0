Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1440811124-1634-1-git-send-email-toshi.kani@hp.com>
References: <1440811124-1634-1-git-send-email-toshi.kani@hp.com>
Date: Fri, 28 Aug 2015 20:31:35 -0700
Message-ID: <CAPcyv4hr1eVvYr2c9ngmYhuBjd96aNOAtC2kTSSXWXQ8_2xKvQ@mail.gmail.com>
Subject: Re: [PATCH] nfit: Fix undefined mmio_flush_range on x86_32
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 28, 2015 at 6:18 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> The following compile error was observed on x86_32 since nfit.c
> relies on <asm/pmem.h> to include <asm/cacheflush.h>, which only
> works when CONFIG_ARCH_HAS_PMEM_API is set on x86_64.
>
>   drivers/acpi/nfit.c:1085:5: error: implicit declaration of
>   function 'mmio_flush_range' [-Werror=implicit-function-declaration]
>
> Change nfit.c to include <asm/cacheflush.h> directly for now.
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
> Apply on top of libnvdimm-for-next of the nvdimm tree.
> This is a temporary fix and please feel free to replace it with
> a better solution.

This looks correct to me, I'm going to fold it in to where the breakage occurs.

Thanks Toshi!
