Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E65C7F
	for <nvdimm@lists.linux.dev>; Fri, 17 Feb 2023 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676652634; x=1708188634;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ORiZEj/iq8gQ9lcsDH2bLAOwWhIkUjpxs0KW9we0RcE=;
  b=MsEfhHzGKwuw5y2xbTHEmCjU7//FLRPO4qm/yHANIHfayb3/NTNEtMqE
   XNfCzy30jwx7v0BuSBeb2CHCh5xVWWt7kznUATktRXoqFPNWh9W2StM3z
   C2K/txg/DHTl+dM1hBGlB3FZRJfA23VJcCnV5ckyHQ8qdL9M6ihEDawqd
   mBwA08gms83YRdvv7sIPcZuJ43L385ISWtNNUfxAvmWeW2WGNTV0f713s
   8pVNPQehjyHrMbRP+JntoCLCO5+VKFPRGCO3KsJLEtLDBB/7W/+o7CEnK
   GxlA8Z8t0kr8n2F+zz8mC1lJkmTlfBRWqkMVPynzvRN1B4ahzNPc5RAa9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="333386129"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="333386129"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 08:50:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="813436833"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="813436833"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.187.252]) ([10.213.187.252])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 08:50:32 -0800
Message-ID: <897e58f2-b7db-9aa2-26dd-db90bd73e315@intel.com>
Date: Fri, 17 Feb 2023 09:50:32 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.0
Subject: Re: [PATCH] cxl/pmem: Fix nvdimm registration races
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: stable@vger.kernel.org, nvdimm@lists.linux.dev
References: <167641090468.954904.2931923185712477447.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <167641090468.954904.2931923185712477447.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/14/23 2:41 PM, Dan Williams wrote:
> A loop of the form:
> 
>      while true; do modprobe cxl_pci; modprobe -r cxl_pci; done
> 
> ...fails with the following crash signature:
> 
>      BUG: kernel NULL pointer dereference, address: 0000000000000040
>      [..]
>      RIP: 0010:cxl_internal_send_cmd+0x5/0xb0 [cxl_core]
>      [..]
>      Call Trace:
>       <TASK>
>       cxl_pmem_ctl+0x121/0x240 [cxl_pmem]
>       nvdimm_get_config_data+0xd6/0x1a0 [libnvdimm]
>       nd_label_data_init+0x135/0x7e0 [libnvdimm]
>       nvdimm_probe+0xd6/0x1c0 [libnvdimm]
>       nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
>       really_probe+0xde/0x380
>       __driver_probe_device+0x78/0x170
>       driver_probe_device+0x1f/0x90
>       __device_attach_driver+0x85/0x110
>       bus_for_each_drv+0x7d/0xc0
>       __device_attach+0xb4/0x1e0
>       bus_probe_device+0x9f/0xc0
>       device_add+0x445/0x9c0
>       nd_async_device_register+0xe/0x40 [libnvdimm]
>       async_run_entry_fn+0x30/0x130
> 
> ...namely that the bottom half of async nvdimm device registration runs
> after cxlmd_release_nvdimm() has already torn down the context that
> cxl_pmem_ctl() needs. Unlike the ACPI NFIT case that benefits from
> launching multiple nvdimm device registrations in parallel from those
> listed in the table, CXL is already marked PROBE_PREFER_ASYNCHRONOUS. So
> provide for a synchronous registration path to preclude this scenario.
> 
> Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
> Cc: <stable@vger.kernel.org>
> Reported-by: Dave Jiang <dave.jiang@intel.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/pmem.c         |    1 +
>   drivers/nvdimm/bus.c       |   19 ++++++++++++++++---
>   drivers/nvdimm/dimm_devs.c |    5 ++++-
>   drivers/nvdimm/nd-core.h   |    1 +
>   include/linux/libnvdimm.h  |    3 +++
>   5 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 08bbbac9a6d0..71cfa1fdf902 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -76,6 +76,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>   		return rc;
>   
>   	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_REGISTER_SYNC, &flags);
>   	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>   	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>   	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index b38d0355b0ac..5ad49056921b 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -508,7 +508,7 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
>   	put_device(dev);
>   }
>   
> -void nd_device_register(struct device *dev)
> +static void __nd_device_register(struct device *dev, bool sync)
>   {
>   	if (!dev)
>   		return;
> @@ -531,11 +531,24 @@ void nd_device_register(struct device *dev)
>   	}
>   	get_device(dev);
>   
> -	async_schedule_dev_domain(nd_async_device_register, dev,
> -				  &nd_async_domain);
> +	if (sync)
> +		nd_async_device_register(dev, 0);
> +	else
> +		async_schedule_dev_domain(nd_async_device_register, dev,
> +					  &nd_async_domain);
> +}
> +
> +void nd_device_register(struct device *dev)
> +{
> +	__nd_device_register(dev, false);
>   }
>   EXPORT_SYMBOL(nd_device_register);
>   
> +void nd_device_register_sync(struct device *dev)
> +{
> +	__nd_device_register(dev, true);
> +}
> +
>   void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
>   {
>   	bool killed;
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 1fc081dcf631..6d3b03a9fa02 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -624,7 +624,10 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>   	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
>   	device_initialize(dev);
>   	lockdep_set_class(&dev->mutex, &nvdimm_key);
> -	nd_device_register(dev);
> +	if (test_bit(NDD_REGISTER_SYNC, &flags))
> +		nd_device_register_sync(dev);
> +	else
> +		nd_device_register(dev);
>   
>   	return nvdimm;
>   }
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index cc86ee09d7c0..845408f10655 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -107,6 +107,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
>   void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
>   void nd_synchronize(void);
>   void nd_device_register(struct device *dev);
> +void nd_device_register_sync(struct device *dev);
>   struct nd_label_id;
>   char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
>   		      u32 flags);
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index af38252ad704..e772aae71843 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -41,6 +41,9 @@ enum {
>   	 */
>   	NDD_INCOHERENT = 7,
>   
> +	/* dimm provider wants synchronous registration by __nvdimm_create() */
> +	NDD_REGISTER_SYNC = 8,
> +
>   	/* need to set a limit somewhere, but yes, this is likely overkill */
>   	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>   	ND_CMD_MAX_ELEM = 5,
> 
