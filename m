Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997332470A
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289621; cv=none; b=d6lJSdqzhzrH/pJkUlt5iO5MWeNEACWq3Gh2ZuXHFIadqenELvkBpmBchWMCwvDu3x26Vyduw2ys3aMBWluMoEdtO3jgJ++TzzBDvQJE1lcmszz7Tozx3eeqgcBYpLWovtikqt8v88pqFQZ/xlFTupAhyZ/LghCMyCt0Eln63Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289621; c=relaxed/simple;
	bh=y9moAdqmvz7D6zSoTFWBxABg1MazcK7d6WPTuhljAyQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFdwzHcG99zbflVK/srb5+6rhVvPKcFE70H+pKqq/fAP0hUf50kt6mlKFTIBKhLqWnBuBn8h9zjX5vppPHr0Y16cSvwMpBNPlY6mT1ZuRfF3WAvkjbbHzOOfIgv5p4xy/wAx6wQng2eeUdHnrgkBRXoMLXD64MRBMi7U8Kfce90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ffhB05JdlzJ467T;
	Tue, 24 Mar 2026 02:13:28 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 59F2440584;
	Tue, 24 Mar 2026 02:13:34 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Mar
 2026 18:13:32 +0000
Date: Mon, 23 Mar 2026 18:13:31 +0000
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
Subject: Re: [PATCH v8 8/9] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
Message-ID: <20260323181331.000018f2@huawei.com>
In-Reply-To: <20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
	<20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Sun, 22 Mar 2026 19:53:41 +0000
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

https://sashiko.dev/#/patchset/20260322195343.206900-1-Smita.KoralahalliChannabasappa%40amd.com
Might be worth a look.  I think the last comment is potentially correct
though unlikely a platform_driver_register() actually fails.

I've not looked too closely at the others. Given this was doing something
unusual I thought I'd see what it found. Looks like some interesting
questions if nothing else.

> ---
>  drivers/dax/bus.h         |  7 ++++
>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/hmem/device.c |  3 ++
>  drivers/dax/hmem/hmem.c   | 74 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 85 insertions(+)
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
> index ca752db03201..9ceda6b5cadf 100644
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
> @@ -58,6 +59,23 @@ static void release_hmem(void *pdev)
>  	platform_device_unregister(pdev);
>  }
>  
> +struct dax_defer_work {
> +	struct platform_device *pdev;
> +	struct work_struct work;
> +};
> +
> +static void process_defer_work(struct work_struct *w);
> +
> +static struct dax_defer_work dax_hmem_work = {
> +	.work = __WORK_INITIALIZER(dax_hmem_work.work, process_defer_work),
> +};
> +
> +void dax_hmem_flush_work(void)
> +{
> +	flush_work(&dax_hmem_work.work);
> +}
> +EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
> +
>  static int __hmem_register_device(struct device *host, int target_nid,
>  				  const struct resource *res)
>  {
> @@ -122,6 +140,11 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>  	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>  			      IORES_DESC_CXL) != REGION_DISJOINT) {
> +		if (!dax_hmem_initial_probe) {
> +			dev_dbg(host, "await CXL initial probe: %pr\n", res);
> +			queue_work(system_long_wq, &dax_hmem_work.work);
> +			return 0;
> +		}
>  		dev_dbg(host, "deferring range to CXL: %pr\n", res);
>  		return 0;
>  	}
> @@ -129,8 +152,54 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	return __hmem_register_device(host, target_nid, res);
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
> +	return __hmem_register_device(host, target_nid, res);
> +}
> +
> +static void process_defer_work(struct work_struct *w)
> +{
> +	struct dax_defer_work *work = container_of(w, typeof(*work), work);
> +	struct platform_device *pdev;
> +
> +	if (!work->pdev)
> +		return;
> +
> +	pdev = work->pdev;
> +
> +	/* Relies on cxl_acpi and cxl_pci having had a chance to load */
> +	wait_for_device_probe();
> +
> +	guard(device)(&pdev->dev);
> +	if (!pdev->dev.driver)
> +		return;
> +
> +	if (!dax_hmem_initial_probe) {
> +		dax_hmem_initial_probe = true;
> +		walk_hmem_resources(&pdev->dev, hmem_register_cxl_device);
> +	}
> +}
> +
>  static int dax_hmem_platform_probe(struct platform_device *pdev)
>  {
> +	if (work_pending(&dax_hmem_work.work))
> +		return -EBUSY;
> +
> +	if (!dax_hmem_work.pdev)
> +		dax_hmem_work.pdev =
> +			to_platform_device(get_device(&pdev->dev));
> +
>  	return walk_hmem_resources(&pdev->dev, hmem_register_device);
>  }
>  
> @@ -168,6 +237,11 @@ static __init int dax_hmem_init(void)
>  
>  static __exit void dax_hmem_exit(void)
>  {
> +	if (dax_hmem_work.pdev) {
> +		flush_work(&dax_hmem_work.work);
> +		put_device(&dax_hmem_work.pdev->dev);
> +	}
> +
>  	platform_driver_unregister(&dax_hmem_driver);
>  	platform_driver_unregister(&dax_hmem_platform_driver);
>  }

