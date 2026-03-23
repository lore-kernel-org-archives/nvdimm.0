Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E758C3BE140
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289874; cv=none; b=jU8j4rOAFN6ECDVZ7ap6pNgCBddT2XHmT3yuyPxq00R02aVfQX6AixmeU8zKpad/T83hAx1S9681lxUUJUCrgUHgRC0VKYjI9x2UiXzqb144k+iQRr2WYCquy647tue8CMi/OjQ5AzaCx7lbE/A0cIcXJv4FjJkruu65jzyUD/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289874; c=relaxed/simple;
	bh=LxkiTLjGw6kEzMe0rrNlGTA4mnuY6KWKI1O/JC5XLLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uiKM6+P5hO8lkPeF9t+sXUzE8R/yr5PxQzjRPKcGvJONg/K72fDtGO4G3enk+sIiqo8N1Z7wOhI1DlLwldawX9avr079ep3wZ3Hvi6y0GbKFlIbnkRW8DZi2jIWgqZi7b4Fv3esXCwIhkB6G1s6lzJYM4n9XQm1mWK+FXoxie4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxL5mzFs; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxL5mzFs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774289869; x=1805825869;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LxkiTLjGw6kEzMe0rrNlGTA4mnuY6KWKI1O/JC5XLLM=;
  b=OxL5mzFsgc0PQXtdrJyH+Sz9hFfogNBhazduLARpI+sE+QsGlc7kTqji
   pWFBCHsLYus9wYRcE+GDuiAJgxlDs8tLG749SaWgjlX7ieZDI6VBjyvVs
   2MHoXazeX9jc5AFVBs+HhlJCOBExpHuZAr0JzwUIv56pPpJRz1UHGpD2C
   y5WBmwpG0AeaXG75bX8eQmfyeEBHgI/FhTz5Z/f4IidKV1wls7XwAdIC4
   q4GGTpeqbU/7CzKvaTBRwCMXQ/gJTQ4r6O+Gal+08arLX0iEKGZ7Mo9vU
   xImoPYa06oyqTvtu/nhZvsZOx/B4emIrS6oOtHJirX64N8sIGzTeuXEMU
   g==;
X-CSE-ConnectionGUID: 6p30N6nAS9SKMDPqEcFh5A==
X-CSE-MsgGUID: 1NmShRm9QU25BNtaautxhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="97916855"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="97916855"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 11:17:47 -0700
X-CSE-ConnectionGUID: pbA5y5KDR7KI3mjV0IsahQ==
X-CSE-MsgGUID: uWJsxxAdTcOH32D+1vKinA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="224076025"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.109.216]) ([10.125.109.216])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 11:17:46 -0700
Message-ID: <462b0061-5fed-49a0-84d3-e1918a7e481d@intel.com>
Date: Mon, 23 Mar 2026 11:17:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/9] dax/hmem, cxl: Defer and resolve Soft Reserved
 ownership
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260322195343.206900-9-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/22/26 12:53 PM, Smita Koralahalli wrote:
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


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

