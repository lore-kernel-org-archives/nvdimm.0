Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702B211C
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 23:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748994365; cv=none; b=srzKMv7Xp7greJ3lnZVBmglSK5bljFRKLVaNfAxvOoMUZnOs3vHCLvq9DI+eJx29X0plkMP/5/a86ny2dPE+ieQS0z9HM31UNinP6x0QUm6WhrQDcWTKDgDgf2GMGZyOIowiJ+wFxtX4WRBTgEOKC0nfg+S5Y1BCs3tm7LNb2w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748994365; c=relaxed/simple;
	bh=hWWpMUvDb6toLCS0hdHRob1Q0A+Js+9lzm2MfMkdnK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdqpk5Vvknxa+pINIfUuaUtRckiGbq84BcsJJXsvEFa0Km5ljC04znq3alRwso09fdbFw5XcqpN3pka0+MFa0yae9ckNiGxGkSoT2LMx54KqOk/XMxyqWNatBVVxjX/dx2WZhoaFS1l+6njr/xSQcc5TLJ3K1mZbe5HeUxAtMoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jjwb9hcc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jjwb9hcc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748994364; x=1780530364;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hWWpMUvDb6toLCS0hdHRob1Q0A+Js+9lzm2MfMkdnK4=;
  b=Jjwb9hccybRjJR2Alawxj0QMKeVFgKRuWjYZQ1w48XqNKLDJqKcGWT1f
   9nEzQ4ZzeLMuwFtTgkshdVY5IM7jgVvGN/V6HUyF886ujsZz63w+D+vCj
   fs9mbkVwRvC/pEP5iG74tu3v0vI1aLYmqMYTq878/aYLq1Blp3spCs6kA
   /KZ4TfirpT/71TTQ19J65+aPNxLf1yoX0AmKNORQKXRWhOYyhNTqsXdFk
   HU9sqdieb67m3jWkbSgNjwSZURcZM6OSKHK8MYti6zvJzHweUwM6CHTFU
   9ku8dqXQNo4LIq2sdb8Xlc29jUaB/pkKPyoFwy0FLbt5kRPFWuHW+sclg
   g==;
X-CSE-ConnectionGUID: KseHzJUGRBadPZh6mQHPhQ==
X-CSE-MsgGUID: QTOx5AeVQVSnk6F48+QPAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="54846572"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="54846572"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 16:46:03 -0700
X-CSE-ConnectionGUID: MLAtfLerR4SDyGyLL661vw==
X-CSE-MsgGUID: gaYgkeulTGSxHFyWpRQaMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="144894636"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO [10.125.110.198]) ([10.125.110.198])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 16:46:01 -0700
Message-ID: <d9435456-9ae8-4fbe-a67b-e557e2787b0c@intel.com>
Date: Tue, 3 Jun 2025 16:45:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] cxl/acpi: Add background worker to wait for
 cxl_pci and cxl_mem probe
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 PradeepVineshReddy Kodamati <PradeepVineshReddy.Kodamati@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>
References: <20250603221949.53272-1-Smita.KoralahalliChannabasappa@amd.com>
 <20250603221949.53272-5-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250603221949.53272-5-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/25 3:19 PM, Smita Koralahalli wrote:
> Introduce a waitqueue mechanism to coordinate initialization between the
> cxl_pci and cxl_mem drivers.
> 
> Launch a background worker from cxl_acpi_probe() that waits for both
> drivers to complete initialization before invoking wait_for_device_probe().
> Without this, the probe completion wait could begin prematurely, before
> the drivers are present, leading to missed updates.
> 
> Co-developed-by: Nathan Fontenot <Nathan.Fontenot@amd.com>
> Signed-off-by: Nathan Fontenot <Nathan.Fontenot@amd.com>
> Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> ---
>  drivers/cxl/acpi.c         | 23 +++++++++++++++++++++++
>  drivers/cxl/core/suspend.c | 21 +++++++++++++++++++++
>  drivers/cxl/cxl.h          |  2 ++
>  3 files changed, 46 insertions(+)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index cb14829bb9be..978f63b32b41 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -813,6 +813,24 @@ static int pair_cxl_resource(struct device *dev, void *data)
>  	return 0;
>  }
>  
> +static void cxl_softreserv_mem_work_fn(struct work_struct *work)
> +{
> +	/* Wait for cxl_pci and cxl_mem drivers to load */
> +	cxl_wait_for_pci_mem();
> +
> +	/*
> +	 * Wait for the driver probe routines to complete after cxl_pci
> +	 * and cxl_mem drivers are loaded.
> +	 */
> +	wait_for_device_probe();
> +}
> +static DECLARE_WORK(cxl_sr_work, cxl_softreserv_mem_work_fn);
> +
> +static void cxl_softreserv_mem_update(void)
> +{
> +	schedule_work(&cxl_sr_work);
> +}
> +
>  static int cxl_acpi_probe(struct platform_device *pdev)
>  {
>  	int rc;
> @@ -887,6 +905,10 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  
>  	/* In case PCI is scanned before ACPI re-trigger memdev attach */
>  	cxl_bus_rescan();
> +
> +	/* Update SOFT RESERVE resources that intersect with CXL regions */
> +	cxl_softreserv_mem_update();
> +
>  	return 0;
>  }
>  
> @@ -918,6 +940,7 @@ static int __init cxl_acpi_init(void)
>  
>  static void __exit cxl_acpi_exit(void)
>  {
> +	cancel_work_sync(&cxl_sr_work);
>  	platform_driver_unregister(&cxl_acpi_driver);
>  	cxl_bus_drain();
>  }
> diff --git a/drivers/cxl/core/suspend.c b/drivers/cxl/core/suspend.c
> index 72818a2c8ec8..c0d8f70aed56 100644
> --- a/drivers/cxl/core/suspend.c
> +++ b/drivers/cxl/core/suspend.c
> @@ -2,12 +2,15 @@
>  /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
>  #include <linux/atomic.h>
>  #include <linux/export.h>
> +#include <linux/wait.h>
>  #include "cxlmem.h"
>  #include "cxlpci.h"
>  
>  static atomic_t mem_active;
>  static atomic_t pci_loaded;
>  
> +static DECLARE_WAIT_QUEUE_HEAD(cxl_wait_queue);
> +
>  bool cxl_mem_active(void)
>  {
>  	if (IS_ENABLED(CONFIG_CXL_MEM))
> @@ -19,6 +22,7 @@ bool cxl_mem_active(void)
>  void cxl_mem_active_inc(void)
>  {
>  	atomic_inc(&mem_active);
> +	wake_up(&cxl_wait_queue);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_mem_active_inc, "CXL");
>  
> @@ -28,8 +32,25 @@ void cxl_mem_active_dec(void)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_mem_active_dec, "CXL");
>  
> +static bool cxl_pci_loaded(void)
> +{
> +	if (IS_ENABLED(CONFIG_CXL_PCI))
> +		return atomic_read(&pci_loaded) != 0;
> +
> +	return false;
> +}
> +
>  void mark_cxl_pci_loaded(void)
>  {
>  	atomic_inc(&pci_loaded);
> +	wake_up(&cxl_wait_queue);
>  }
>  EXPORT_SYMBOL_NS_GPL(mark_cxl_pci_loaded, "CXL");
> +
> +void cxl_wait_for_pci_mem(void)
> +{
> +	if (!wait_event_timeout(cxl_wait_queue, cxl_pci_loaded() &&
> +				cxl_mem_active(), 30 * HZ))

I'm trying to understand why cxl_pci_loaded() is needed. cxl_mem_active() goes above 0 when a cxl_mem_probe() instance succeeds. cxl_mem_probe() being triggered implies that an instance of cxl_pci_probe() has been called since cxl_mem_probe() is triggered from devm_cxl_add_memdev() with memdev being added and cxl_mem driver also have been loaded. So does cxl_mem_active() not imply cxl_pci_loaded() and makes it unnecessary?

DJ


> +		pr_debug("Timeout waiting for cxl_pci or cxl_mem probing\n");
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_wait_for_pci_mem, "CXL");
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index a9ab46eb0610..1ba7d39c2991 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -902,6 +902,8 @@ void cxl_coordinates_combine(struct access_coordinate *out,
>  
>  bool cxl_endpoint_decoder_reset_detected(struct cxl_port *port);
>  
> +void cxl_wait_for_pci_mem(void);
> +
>  /*
>   * Unit test builds overrides this to __weak, find the 'strong' version
>   * of these symbols in tools/testing/cxl/.

