Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AAB36CDEF
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773930560; cv=none; b=eADbLgRAZj9TxRhhTVnD864/HKIY+SsVXiDmdjj5IUHIHTptyl1YC2eKxdhmw3WEj0OBgUIKjOx8H+FhHTDiQOwiBf7ISte0nBcD4x0pNGpAmkH/45PJ5IAR6WRb4995X2BHwDjyuQaeyR1wurvOvlrPBu8idqIaeNU/paymVug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773930560; c=relaxed/simple;
	bh=HsUflFa/KdBTD4m+DVDNlymj5Z233GZp9biJt1RyHT0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNUyDXT4oEfOdDh8llsxirHfseOi35DS/FG7J9+KBRmNBfMDqdqlFZ4uyfqmlLGTOpiEbte5aSQRHVDLrMgRAWegnOm/oJC9yoPeJn0pix+42y9qrIw7m1TKnHrgBmUL2XmxGwoscviUaIBmlFjn8BnzptxNLJ1z6Nz158jz65g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc7Nd2wpZzHnGgg;
	Thu, 19 Mar 2026 22:28:49 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 0BBDE4056E;
	Thu, 19 Mar 2026 22:29:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 14:29:11 +0000
Date: Thu, 19 Mar 2026 14:29:10 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Dan Williams
	<dan.j.williams@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Matthew
 Wilcox" <willy@infradead.org>, Jan Kara <jack@suse.cz>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Len Brown <len.brown@intel.com>, Pavel Machek
	<pavel@kernel.org>, Li Ming <ming.li@zohomail.com>, Jeff Johnson
	<jeff.johnson@oss.qualcomm.com>, Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>, "Peter Zijlstra"
	<peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>, Terry Bowman
	<terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>, Benjamin Cheatham
	<benjamin.cheatham@amd.com>, Zhijian Li <lizhijian@fujitsu.com>, Borislav
 Petkov <bp@alien8.de>, Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v7 6/7] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
Message-ID: <20260319142910.0000113d@huawei.com>
In-Reply-To: <20260319011500.241426-7-Smita.KoralahalliChannabasappa@amd.com>
References: <20260319011500.241426-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260319011500.241426-7-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 19 Mar 2026 01:14:59 +0000
Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com> wrote:

> The current probe time ownership check for Soft Reserved memory based
> solely on CXL window intersection is insufficient. dax_hmem probing is not
> always guaranteed to run after CXL enumeration and region assembly, which
> can lead to incorrect ownership decisions before the CXL stack has
> finished publishing windows and assembling committed regions.
> 
> Introduce deferred ownership handling for Soft Reserved ranges that
> intersect CXL windows. When such a range is encountered during the
> initial dax_hmem probe, schedule deferred work to wait for the CXL stack
> to complete enumeration and region assembly before deciding ownership.
> 
> Once the deferred work runs, evaluate each Soft Reserved range
> individually: if a CXL region fully contains the range, skip it and let
> dax_cxl bind. Otherwise, register it with dax_hmem. This per-range
> ownership model avoids the need for CXL region teardown and
> alloc_dax_region() resource exclusion prevents double claiming.
> 
> Introduce a boolean flag dax_hmem_initial_probe to live inside device.c
> so it survives module reload. Ensure dax_cxl defers driver registration
> until dax_hmem has completed ownership resolution. dax_cxl calls
> dax_hmem_flush_work() before cxl_driver_register(), which both waits for
> the deferred work to complete and creates a module symbol dependency that
> forces dax_hmem.ko to load before dax_cxl.
> 
> Co-developed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Hi Smita,

I think this is very likely to be what is causing the bug Alison
saw in cxl_test.

It looks to be possible to flush work before the work structure has
been configured.  Even though it's not on a work queue and there is
nothing to do, there are early sanity checks that fail giving the warning
Alison reported.

A couple of ways to fix that inline.  I'd be tempted to both initialize
the function statically and gate against flushing if the whole thing isn't
set up yet.

Jonathan

> ---
>  drivers/dax/bus.h         |  7 +++++
>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/hmem/device.c |  3 ++
>  drivers/dax/hmem/hmem.c   | 66 +++++++++++++++++++++++++++++++++++++--
>  4 files changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index cbbf64443098..ebbfe2d6da14 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -49,6 +49,13 @@ void dax_driver_unregister(struct dax_device_driver *dax_drv);
>  void kill_dev_dax(struct dev_dax *dev_dax);
>  bool static_dev_dax(struct dev_dax *dev_dax);
>  
> +#if IS_ENABLED(CONFIG_DEV_DAX_HMEM)
> +extern bool dax_hmem_initial_probe;
> +void dax_hmem_flush_work(void);
> +#else
> +static inline void dax_hmem_flush_work(void) { }
> +#endif
> +
>  #define MODULE_ALIAS_DAX_DEVICE(type) \
>  	MODULE_ALIAS("dax:t" __stringify(type) "*")
>  #define DAX_DEVICE_MODALIAS_FMT "dax:t%d"
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index a2136adfa186..3ab39b77843d 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -44,6 +44,7 @@ static struct cxl_driver cxl_dax_region_driver = {
>  
>  static void cxl_dax_region_driver_register(struct work_struct *work)
>  {
> +	dax_hmem_flush_work();
>  	cxl_driver_register(&cxl_dax_region_driver);
>  }
>  
> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
> index 56e3cbd181b5..991a4bf7d969 100644
> --- a/drivers/dax/hmem/device.c
> +++ b/drivers/dax/hmem/device.c
> @@ -8,6 +8,9 @@
>  static bool nohmem;
>  module_param_named(disable, nohmem, bool, 0444);
>  
> +bool dax_hmem_initial_probe;
> +EXPORT_SYMBOL_GPL(dax_hmem_initial_probe);
> +
>  static bool platform_initialized;
>  static DEFINE_MUTEX(hmem_resource_lock);
>  static struct resource hmem_active = {
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 1e3424358490..8c574123bd3b 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -3,6 +3,7 @@
>  #include <linux/memregion.h>
>  #include <linux/module.h>
>  #include <linux/dax.h>
> +#include <cxl/cxl.h>
>  #include "../bus.h"
>  
>  static bool region_idle;
> @@ -58,6 +59,19 @@ static void release_hmem(void *pdev)
>  	platform_device_unregister(pdev);
>  }
>  
> +struct dax_defer_work {
> +	struct platform_device *pdev;
> +	struct work_struct work;
> +};
> +
> +static struct dax_defer_work dax_hmem_work;

static struct dax_defer_work dax_hmem_work = {
	.work = __WORK_INITIALIZER(&dax_hmem_work.work,
				   process_defer_work),
};
or something similar.


> +
> +void dax_hmem_flush_work(void)
> +{
> +	flush_work(&dax_hmem_work.work);
> +}
> +EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
> +
>  static int hmem_register_device(struct device *host, int target_nid,
>  				const struct resource *res)
>  {
> @@ -69,8 +83,11 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>  	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>  			      IORES_DESC_CXL) != REGION_DISJOINT) {
> -		dev_dbg(host, "deferring range to CXL: %pr\n", res);
> -		return 0;
> +		if (!dax_hmem_initial_probe) {
> +			dev_dbg(host, "deferring range to CXL: %pr\n", res);
> +			queue_work(system_long_wq, &dax_hmem_work.work);
> +			return 0;
> +		}
>  	}
>  
>  	rc = region_intersects_soft_reserve(res->start, resource_size(res));
> @@ -123,8 +140,48 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	return rc;
>  }
>  
> +static int hmem_register_cxl_device(struct device *host, int target_nid,
> +				    const struct resource *res)
> +{
> +	if (region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
> +			      IORES_DESC_CXL) == REGION_DISJOINT)
> +		return 0;
> +
> +	if (cxl_region_contains_resource((struct resource *)res)) {
> +		dev_dbg(host, "CXL claims resource, dropping: %pr\n", res);
> +		return 0;
> +	}
> +
> +	dev_dbg(host, "CXL did not claim resource, registering: %pr\n", res);
> +	return hmem_register_device(host, target_nid, res);
> +}
> +
> +static void process_defer_work(struct work_struct *w)
> +{
> +	struct dax_defer_work *work = container_of(w, typeof(*work), work);
> +	struct platform_device *pdev = work->pdev;
If you do the suggested __INITIALIZE_WORK() then I'd add
a paranoid

	if (!work->pdev)
		return;
We don't actually queue the work before pdev is set, but that might
be obvious once we spilt up assigning the function and the data
it uses.

> +
> +	wait_for_device_probe();
> +
> +	guard(device)(&pdev->dev);
> +	if (!pdev->dev.driver)
> +		return;
> +
> +	dax_hmem_initial_probe = true;
> +	walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
> +}
> +
>  static int dax_hmem_platform_probe(struct platform_device *pdev)
>  {
> +	if (work_pending(&dax_hmem_work.work))
> +		return -EBUSY;
> +
> +	if (!dax_hmem_work.pdev) {
> +		get_device(&pdev->dev);
> +		dax_hmem_work.pdev = pdev;

Using the pdev rather than dev breaks the pattern of doing a get_device()
and assigning in one line. This is a bit ugly.

		dax_hmem_work.pdev = to_pci_dev(get_device(&pdev->dev));

but perhaps makes the association tighter than current code.

> +		INIT_WORK(&dax_hmem_work.work, process_defer_work);

See above. I think assigning the work function should be static
which should resolve the issue Alison was seeing as then it should
be fine to call flush_work() on the item that isn't on a work queue
yet but is initialized.

> +	}
> +
>  	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>  }
>  
> @@ -162,6 +219,11 @@ static __init int dax_hmem_init(void)
>  
>  static __exit void dax_hmem_exit(void)
>  {
> +	flush_work(&dax_hmem_work.work);

I think this needs to be under the if (dax_hmem_work.pdev) 
Not sure there is any guarantee dax_hmem_platform_probe() has run
before we get here otherwise.  Alternative is to assign
the work function statically.



> +
> +	if (dax_hmem_work.pdev)
> +		put_device(&dax_hmem_work.pdev->dev);
> +
>  	platform_driver_unregister(&dax_hmem_driver);
>  	platform_driver_unregister(&dax_hmem_platform_driver);
>  }

