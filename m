Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9848C258ED4
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771437141; cv=none; b=HCPYjc+CcU3g4D099k7bqDtphX9axcNF/K33onKch1OGIgaePlEEcOrtNeHvZEwt13JcpWYBtpsaMnFxYvc9qLhJ/kuc0Bk4TloBxv0yuJ43fPeLDvMH0tvlIGEpUCblMvCeGeoBOT2EUk2Wdq6NYju1aMjNToVn+c9RrYRo1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771437141; c=relaxed/simple;
	bh=jkbcKySE2q3+0d2eltPFSdGhKmAGT605iAc5M4pcycM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eBRqdCAHA5rAskxoIaoXDX1AcaymhqUmCeNAQY2k2AJP4MzLsGrjp5cWFVYoiIJpGhSd3/TWfqSWWoIZ3vjHdTAzTop1KgHRYg94YrN/kANzDYXTuxrKEeSoxJhoWdFe1tUv86VdN5BK7OC1zQZuo3QFXR/g1YZPXsqzPavNhe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dR7+gJAU; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dR7+gJAU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771437139; x=1802973139;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jkbcKySE2q3+0d2eltPFSdGhKmAGT605iAc5M4pcycM=;
  b=dR7+gJAUV47+1f0466303UcxFqShOrEK/R8m4uzePGj53vmL1OPZcEcf
   RzSQTD1UxupeSHWsMwIRsno4c/pARkD3TUw+G4sco/30nIJH+rA3r8ZIq
   pr/9gSnc7IiU1Ve8T/g203wJBVrSLSrmhG6kheVOP1Rnyf4JQ9k8RnHjo
   8EF1mJdA5/60D1z1wvE4/VYr20C0KOC0tt4vwf9xt43y2FVKJ7woIQOcQ
   O5dGMLw9uR0jXpCRmLGMyetW4NrbpTNaQ59oBkM41q6WL+50pZQpcOsRa
   9KrOCBE4GKB+kzUGqBe5kAtSzuZKZR4OGwmDd0cadDC66ksJWbuQGIJ4/
   Q==;
X-CSE-ConnectionGUID: 3+N51YR9Sn+jh2spZAVsFQ==
X-CSE-MsgGUID: CeLXx/FBT/6pvw4eRstUlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="89929874"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="89929874"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 09:52:18 -0800
X-CSE-ConnectionGUID: HzoCbuYnQ8+MIIwJFgzx7A==
X-CSE-MsgGUID: 4bh8jUgXQXu+7QS562yTFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="212329200"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.212]) ([10.125.109.212])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 09:52:15 -0800
Message-ID: <0c464a2c-3722-45e5-9023-5a2fce8aa096@intel.com>
Date: Wed, 18 Feb 2026 10:52:14 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/9] dax: Add deferred-work helpers for dax_hmem and
 dax_cxl coordination
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
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-8-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260210064501.157591-8-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/9/26 11:44 PM, Smita Koralahalli wrote:
> Add helpers to register, queue and flush the deferred work.
> 
> These helpers allow dax_hmem to execute ownership resolution outside the
> probe context before dax_cxl binds.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> ---
>  drivers/dax/bus.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dax/bus.h |  7 ++++++
>  2 files changed, 65 insertions(+)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 5f387feb95f0..92b88952ede1 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -25,6 +25,64 @@ DECLARE_RWSEM(dax_region_rwsem);
>   */
>  DECLARE_RWSEM(dax_dev_rwsem);
>  
> +static DEFINE_MUTEX(dax_hmem_lock);
> +static dax_hmem_deferred_fn hmem_deferred_fn;
> +static void *dax_hmem_data;
> +
> +static void hmem_deferred_work(struct work_struct *work)
> +{
> +	dax_hmem_deferred_fn fn;
> +	void *data;
> +
> +	scoped_guard(mutex, &dax_hmem_lock) {
> +		fn = hmem_deferred_fn;
> +		data = dax_hmem_data;
> +	}
> +
> +	if (fn)
> +		fn(data);
> +}

Instead of having a global lock and dealing with all the global variables, why not just do this with the typical work_struct usage pattern and allocate a work item when queuing work?

DJ

> +
> +static DECLARE_WORK(dax_hmem_work, hmem_deferred_work);
> +
> +int dax_hmem_register_work(dax_hmem_deferred_fn fn, void *data)
> +{
> +	guard(mutex)(&dax_hmem_lock);
> +
> +	if (hmem_deferred_fn)
> +		return -EINVAL;
> +
> +	hmem_deferred_fn = fn;
> +	dax_hmem_data = data;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_hmem_register_work);
> +
> +int dax_hmem_unregister_work(dax_hmem_deferred_fn fn, void *data)
> +{
> +	guard(mutex)(&dax_hmem_lock);
> +
> +	if (hmem_deferred_fn != fn || dax_hmem_data != data)
> +		return -EINVAL;
> +
> +	hmem_deferred_fn = NULL;
> +	dax_hmem_data = NULL;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dax_hmem_unregister_work);
> +
> +void dax_hmem_queue_work(void)
> +{
> +	queue_work(system_long_wq, &dax_hmem_work);
> +}
> +EXPORT_SYMBOL_GPL(dax_hmem_queue_work);
> +
> +void dax_hmem_flush_work(void)
> +{
> +	flush_work(&dax_hmem_work);
> +}
> +EXPORT_SYMBOL_GPL(dax_hmem_flush_work);
> +
>  #define DAX_NAME_LEN 30
>  struct dax_id {
>  	struct list_head list;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index cbbf64443098..b58a88e8089c 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -41,6 +41,13 @@ struct dax_device_driver {
>  	void (*remove)(struct dev_dax *dev);
>  };
>  
> +typedef void (*dax_hmem_deferred_fn)(void *data);
> +
> +int dax_hmem_register_work(dax_hmem_deferred_fn fn, void *data);
> +int dax_hmem_unregister_work(dax_hmem_deferred_fn fn, void *data);
> +void dax_hmem_queue_work(void);
> +void dax_hmem_flush_work(void);
> +
>  int __dax_driver_register(struct dax_device_driver *dax_drv,
>  		struct module *module, const char *mod_name);
>  #define dax_driver_register(driver) \

