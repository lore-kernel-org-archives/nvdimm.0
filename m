Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07B13D77
	for <nvdimm@lists.linux.dev>; Sun, 24 Apr 2022 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650843008; x=1682379008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0CAbJtUc7XDbq6Yn9U3wpzXeAjyQ4oUgrOuSSEHobxQ=;
  b=kn1Zkul8gMl0R4H0Y13YGAqqikg56bBCNBNJVADpcapiOmR1olzyWgX5
   LTKYa9TrMip+CNd70NtYs6sVTggZ/zpRQp49Et5mH52B7lZe4VClWiJG8
   fT0YLZyRt3S0w9i6rY4H7uLDaMQy0Fnf7uGtVgwStbmPMp/ePgdjZBriB
   RhYd82WzFdnTEajZlYTxyWnPpfmUM0i85nuWcv1gO0KIiJv8XjjTbhRT4
   HxQ+qrXrJvGWk8th8on3AqJl6hpYP3Ch4xmnpeea7XxMXsRqR1XAe2b86
   O6r2o2E7c9vsk/FRPJkrPipsDp9Jk1wJxs0E2bjiQ3KQPOYZTOiaevQT7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="245663390"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="245663390"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 16:30:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="531836478"
Received: from hungyuan-mobl.amr.corp.intel.com (HELO localhost) ([10.212.88.155])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 16:30:07 -0700
Date: Sun, 24 Apr 2022 16:30:07 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH v4 8/8] nvdimm: Fix firmware activation deadlock scenarios
Message-ID: <YmXdf2zGuzNdOoPI@iweiny-desk3>
References: <165055523099.3745911.9091010720291846249.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165074883800.4116052.10737040861825806582.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165074883800.4116052.10737040861825806582.stgit@dwillia2-desk3.amr.corp.intel.com>

On Sat, Apr 23, 2022 at 02:22:18PM -0700, Dan Williams wrote:
> Lockdep reports the following deadlock scenarios for CXL root device
> power-management, device_prepare(), operations, and device_shutdown()
> operations for 'nd_region' devices:
> 
> ---
>  Chain exists of:
>    &nvdimm_region_key --> &nvdimm_bus->reconfig_mutex --> system_transition_mutex
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(system_transition_mutex);
>                                 lock(&nvdimm_bus->reconfig_mutex);
>                                 lock(system_transition_mutex);
>    lock(&nvdimm_region_key);
> 
> --
> 
>  Chain exists of:
>    &cxl_nvdimm_bridge_key --> acpi_scan_lock --> &cxl_root_key
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    lock(&cxl_root_key);
>                                 lock(acpi_scan_lock);
>                                 lock(&cxl_root_key);
>    lock(&cxl_nvdimm_bridge_key);
> 
> ---
> 
> These stem from holding nvdimm_bus_lock() over hibernate_quiet_exec()
> which walks the entire system device topology taking device_lock() along
> the way. The nvdimm_bus_lock() is protecting against unregistration,
> multiple simultaneous ops callers, and preventing activate_show() from
> racing activate_store(). For the first 2, the lock is redundant.
> Unregistration already flushes all ops users, and sysfs already prevents
> multiple threads to be active in an ops handler at the same time. For
> the last userspace should already be waiting for its last
> activate_store() to complete, and does not need activate_show() to flush
> the write side, so this lock usage can be deleted in these attributes.
> 
> Fixes: 48001ea50d17 ("PM, libnvdimm: Add runtime firmware activation support")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
> Changes since v3:
> - Remove nvdimm_bus_lock() from all ->capability() invocations (Ira)
> 
>  drivers/nvdimm/core.c |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 144926b7451c..d91799b71d23 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -368,9 +368,7 @@ static ssize_t capability_show(struct device *dev,
>  	if (!nd_desc->fw_ops)
>  		return -EOPNOTSUPP;
>  
> -	nvdimm_bus_lock(dev);
>  	cap = nd_desc->fw_ops->capability(nd_desc);
> -	nvdimm_bus_unlock(dev);
>  
>  	switch (cap) {
>  	case NVDIMM_FWA_CAP_QUIESCE:
> @@ -395,10 +393,8 @@ static ssize_t activate_show(struct device *dev,
>  	if (!nd_desc->fw_ops)
>  		return -EOPNOTSUPP;
>  
> -	nvdimm_bus_lock(dev);
>  	cap = nd_desc->fw_ops->capability(nd_desc);
>  	state = nd_desc->fw_ops->activate_state(nd_desc);
> -	nvdimm_bus_unlock(dev);
>  
>  	if (cap < NVDIMM_FWA_CAP_QUIESCE)
>  		return -EOPNOTSUPP;
> @@ -443,7 +439,6 @@ static ssize_t activate_store(struct device *dev,
>  	else
>  		return -EINVAL;
>  
> -	nvdimm_bus_lock(dev);
>  	state = nd_desc->fw_ops->activate_state(nd_desc);
>  
>  	switch (state) {
> @@ -461,7 +456,6 @@ static ssize_t activate_store(struct device *dev,
>  	default:
>  		rc = -ENXIO;
>  	}
> -	nvdimm_bus_unlock(dev);
>  
>  	if (rc == 0)
>  		rc = len;
> @@ -484,10 +478,7 @@ static umode_t nvdimm_bus_firmware_visible(struct kobject *kobj, struct attribut
>  	if (!nd_desc->fw_ops)
>  		return 0;
>  
> -	nvdimm_bus_lock(dev);
>  	cap = nd_desc->fw_ops->capability(nd_desc);
> -	nvdimm_bus_unlock(dev);
> -
>  	if (cap < NVDIMM_FWA_CAP_QUIESCE)
>  		return 0;
>  
> 
