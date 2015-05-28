Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1432852553-24865-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
	<1432852553-24865-2-git-send-email-ross.zwisler@linux.intel.com>
Date: Thu, 28 May 2015 15:47:16 -0700
Message-ID: <CAPcyv4iY5DSw-wf5kaKOXZk0qx9CZttU9X35i+gGwd6EYB=hbw@mail.gmail.com>
Subject: Re: [PATCH 1/6] pmem: add force casts to avoid __iomem annotation
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 28, 2015 at 3:35 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Even though we use ioremap_nocache() to map our persistent memory in the
> pmem driver, the memory we are mapping behaves like normal memory and
> not I/O memory in that it can be accessed using regular memcpy()
> operations and doesn't need to go through memcpy_toio() and
> memcpy_fromio().  Force casting the pointers received from
> ioremap_nocache() and given to iounmap() gives us the correct behavior
> and makes sparse happy.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-nvdimm@lists.01.org
> ---
>  drivers/block/nd/pmem.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/nd/pmem.c b/drivers/block/nd/pmem.c
> index 5e8c9c629f22..a8712e41e7f5 100644
> --- a/drivers/block/nd/pmem.c
> +++ b/drivers/block/nd/pmem.c
> @@ -163,7 +163,8 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res,
>          * of the CPU caches in case of a crash.
>          */
>         err = -ENOMEM;
> -       pmem->virt_addr = ioremap_nocache(pmem->phys_addr, pmem->size);
> +       pmem->virt_addr = (__force void *)ioremap_nocache(pmem->phys_addr,
> +                       pmem->size);

I think I'd rather see casting when ->virt_addr is used (the
__io_virt() helper can be used to make this a tad cleaner), or provide
ioremap apis that don't attach __iomem to their return value.  Because
in this and other cases ioremap() is being on non "i/o" memory.
