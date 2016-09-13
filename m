Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96E5D1A1E1D
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 17:33:51 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id q188so231749066oia.3
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 17:33:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160912161507.24311-1-ross.zwisler@linux.intel.com>
References: <CAPcyv4g-KQDpxduXTokJMKvqKTDUnx4X3Ashiq02Cc6xhTc+DA@mail.gmail.com>
 <20160912161507.24311-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Sep 2016 17:33:50 -0700
Message-ID: <CAPcyv4j9q=Bs3bLR9GTHjW9G_iQmmh2BneuzWcxFUO9awrFSkw@mail.gmail.com>
Subject: Re: [PATCH v2] /dev/dax: fix Kconfig dependency build breakage
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 12, 2016 at 9:15 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> The function dax_pmem_probe() in drivers/dax/pmem.c is compiled under the
> CONFIG_DEV_DAX_PMEM tri-state config option.  This config option currently
> only depends on CONFIG_NVDIMM_DAX, a bool, which means that the following
> configuration is possible:
>
> CONFIG_LIBNVDIMM=m
> ...
> CONFIG_NVDIMM_DAX=y
> CONFIG_DEV_DAX=y
> CONFIG_DEV_DAX_PMEM=y
>
> With this config LIBNVDIMM is compiled as a module with NVDIMM_DAX=y just
> meaning that we will compile drivers/nvdimm/dax_devs.c into that module.
> However, dax_pmem_probe() depends on several symbols defined in
> drivers/nvdimm/dax_devs.c, which results in the following build errors:
>
> drivers/built-in.o: In function `dax_pmem_probe':
> linux/drivers/dax/pmem.c:70: undefined reference to `to_nd_dax'
> linux/drivers/dax/pmem.c:74: undefined reference to
> `nvdimm_namespace_common_probe'
> linux/drivers/dax/pmem.c:80: undefined reference to `devm_nsio_enable'
> linux/drivers/dax/pmem.c:81: undefined reference to `nvdimm_setup_pfn'
> linux/drivers/dax/pmem.c:84: undefined reference to `devm_nsio_disable'
> linux/drivers/dax/pmem.c:122: undefined reference to `to_nd_region'
> drivers/built-in.o: In function `dax_pmem_init':
> linux/drivers/dax/pmem.c:147: undefined reference to `__nd_driver_register'
>
> Fix this by making NVDIMM_DAX a tristate.  DEV_DAX_PMEM depends on
> NVDIMM_DAX which depends on LIBNVDIMM.  Since they are all now tristates,
> if LIBNVDIMM is built as a kernel module DEV_DAX_PMEM will be as well.
> This prevents dax_devs.c from being built as a built-in while its
> dependencies are in the libnvdimm.ko module.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> ---
>
> Change from v1:
>  - Made NVDIMM_DAX a tristate instead of adding an extra dependency. (djbw)

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
