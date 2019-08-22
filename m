Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A02C202110D0
 for <linux-nvdimm@lists.01.org>; Thu, 22 Aug 2019 11:57:03 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/2] drivers/dax/kmem: give a warning if
 CONFIG_DEV_DAX_PMEM_COMPAT is enabled
References: <20190816111844.87442-1-justin.he@arm.com>
 <20190816111844.87442-3-justin.he@arm.com>
Date: Thu, 22 Aug 2019 14:55:59 -0400
In-Reply-To: <20190816111844.87442-3-justin.he@arm.com> (Jia He's message of
 "Fri, 16 Aug 2019 19:18:44 +0800")
Message-ID: <x49tva9ni68.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jia He <justin.he@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Jia He <justin.he@arm.com> writes:

> commit c221c0b0308f ("device-dax: "Hotplug" persistent memory for use
> like normal RAM") helps to add persistent memory as normal RAM blocks.
> But this driver doesn't work if CONFIG_DEV_DAX_PMEM_COMPAT is enabled.
>
> Here is the debugging call trace when CONFIG_DEV_DAX_PMEM_COMPAT is
> enabled.
> [    4.443730]  devm_memremap_pages+0x4b9/0x540
> [    4.443733]  dev_dax_probe+0x112/0x220 [device_dax]
> [    4.443735]  dax_pmem_compat_probe+0x58/0x92 [dax_pmem_compat]
> [    4.443737]  nvdimm_bus_probe+0x6b/0x150
> [    4.443739]  really_probe+0xf5/0x3d0
> [    4.443740]  driver_probe_device+0x11b/0x130
> [    4.443741]  device_driver_attach+0x58/0x60
> [    4.443742]  __driver_attach+0xa3/0x140
>
> Then the dax0.0 device will be registered as "nd" bus instead of
> "dax" bus. This causes the error as follows:
> root@ubuntu:~# echo dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
> -bash: echo: write error: No such device
>
> This gives a warning to notify the user.
>
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  drivers/dax/kmem.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index ad62d551d94e..b77f0e880598 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -93,6 +93,11 @@ static struct dax_device_driver device_dax_kmem_driver = {
>  
>  static int __init dax_kmem_init(void)
>  {
> +	if (IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)) {
> +		pr_warn("CONFIG_DEV_DAX_PMEM_COMPAT is not compatible\n");
> +		pr_warn("kmem dax driver might not be workable\n");
> +	}
> +
>  	return dax_driver_register(&device_dax_kmem_driver);
>  }

This logic is wrong (and the error message is *very* confusing).  You
can have the driver configured, but not loaded.  In that case, the kmem
driver will load and work properly.

When using daxctl to online memory, you already get the following
message:

libdaxctl: daxctl_dev_disable: dax0.0: error: device model is dax-class

That's still not very helpful.  It would be better if the message
suggested a fix (like using migrate-device-model).  Vishal?

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
