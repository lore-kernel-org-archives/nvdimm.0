Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E537C
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 00:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650673512; x=1682209512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u2Z9Otj6c1AajGxO+LEqR2cmO3Esb9Gfsf32sjGWGjw=;
  b=b6WySz1SSNM/CkEU62hHKB4FanoiY10kaTZb194W7K8AYLdjn2S6ousf
   XlmXy1SyjdVIa+sapZeQsCPY6wumf0Stpm3Hj06LKo9h9nBT4qGaN3CGn
   GF4HaCRINVgEYNf+xnefFmJNbhrIRjaZZDHEdHbB+lV3R+ja4F2hVKr1l
   Ax1MI7kS6TDNLIlSbmYjcNFBfslJHH0yT7U5+UlAid0Uk84kI+nGGr69H
   In2FXMPvVMkxO1oFDmPshpftd8xvQMj6D14OIT9k7Fhuy/fVjhsIWHsGu
   /JuyjJIIdGdHDKAgQ1D9r2jVN1HJ/IZfORmFePExXgERuQaCO0O/KMcen
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="252151468"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="252151468"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 17:25:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="534715134"
Received: from hltravis-mobl1.amr.corp.intel.com (HELO localhost) ([10.213.166.215])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 17:25:11 -0700
Date: Fri, 22 Apr 2022 17:25:10 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, vishal.l.verma@intel.com,
	alison.schofield@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] device-core: Kill the lockdep_mutex
Message-ID: <YmNHZlRczSH6hRJ5@iweiny-desk3>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055522548.3745911.14298368286915484086.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165055522548.3745911.14298368286915484086.stgit@dwillia2-desk3.amr.corp.intel.com>

On Thu, Apr 21, 2022 at 08:33:45AM -0700, Dan Williams wrote:
> Per Peter [1], the lockdep API has native support for all the use cases
> lockdep_mutex was attempting to enable. Now that all lockdep_mutex users
> have been converted to those APIs, drop this lock.
> 
> Link: https://lore.kernel.org/r/Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net [1]
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/base/core.c    |    3 ---
>  include/linux/device.h |    5 -----
>  2 files changed, 8 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 3d6430eb0c6a..2eede2ec3d64 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -2864,9 +2864,6 @@ void device_initialize(struct device *dev)
>  	kobject_init(&dev->kobj, &device_ktype);
>  	INIT_LIST_HEAD(&dev->dma_pools);
>  	mutex_init(&dev->mutex);
> -#ifdef CONFIG_PROVE_LOCKING
> -	mutex_init(&dev->lockdep_mutex);
> -#endif
>  	lockdep_set_novalidate_class(&dev->mutex);
>  	spin_lock_init(&dev->devres_lock);
>  	INIT_LIST_HEAD(&dev->devres_head);
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 82c9d307e7bd..c00ab223da50 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -400,8 +400,6 @@ struct dev_msi_info {
>   * 		This identifies the device type and carries type-specific
>   * 		information.
>   * @mutex:	Mutex to synchronize calls to its driver.
> - * @lockdep_mutex: An optional debug lock that a subsystem can use as a
> - * 		peer lock to gain localized lockdep coverage of the device_lock.
>   * @bus:	Type of bus device is on.
>   * @driver:	Which driver has allocated this
>   * @platform_data: Platform data specific to the device.
> @@ -499,9 +497,6 @@ struct device {
>  					   core doesn't touch it */
>  	void		*driver_data;	/* Driver data, set and get with
>  					   dev_set_drvdata/dev_get_drvdata */
> -#ifdef CONFIG_PROVE_LOCKING
> -	struct mutex		lockdep_mutex;
> -#endif
>  	struct mutex		mutex;	/* mutex to synchronize calls to
>  					 * its driver.
>  					 */
> 
> 
