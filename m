Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238410798
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 23:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669935628; x=1701471628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5PPaafeME2gnNtdkFkBCHZhfy0JrZKvhOUDagZMuGGA=;
  b=bLyAub1fUC9Z2C5fJn1H3tq9CABo+sOqK8UIXTijrYhx41i/+BSL19Qg
   71RTfN61Lvlu4v8kRidO51LpMyKN0Xsqg0RD2Xy2LHi90KetpZH6l/lsc
   xk6+0+o2f5Hc7drzuN+j/acVWU88w6PGpA30i3///rubdi182QZ7GT3dk
   /ZqWhRsm1zG7IxciFb81gwxWl9NIfs1kA1GFrbSLwgXl0jHiqxPXIq3F4
   jvNCuD16nQ2Hq6g2n/+CnP/F6vQNQcmDrJuMLO8uOiuOEA+Z8jRfod1xE
   zgSU5N55ewqwMyZDN2zF/4KNspi6zmZCTf4N75DJEpQrChghMMRXKsK6N
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="402098397"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="402098397"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 15:00:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="646940259"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="646940259"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.66.184]) ([10.212.66.184])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 15:00:26 -0800
Message-ID: <22c63a9c-5ea3-46c5-f22a-e15ad1686b3c@intel.com>
Date: Thu, 1 Dec 2022 16:00:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH 4/5] nvdimm/region: Move cache management to the region
 driver
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, nvdimm@lists.linux.dev, dave@stgolabs.net
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993221550.1995348.16843505129579060258.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166993221550.1995348.16843505129579060258.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/1/2022 3:03 PM, Dan Williams wrote:
> Now that cpu_cache_invalidate_memregion() is generically available, use
> it to centralize CPU cache management in the nvdimm region driver.
> 
> This trades off removing redundant per-dimm CPU cache flushing with an
> opportunistic flush on every region disable event to cover the case of
> sensitive dirty data in the cache being written back to media after a
> secure erase / overwrite event.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

One minor bit below, otherwise
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   drivers/acpi/nfit/intel.c    |   25 ---------------------
>   drivers/nvdimm/region.c      |   11 +++++++++
>   drivers/nvdimm/region_devs.c |   49 +++++++++++++++++++++++++++++++++++++++++-
>   drivers/nvdimm/security.c    |    6 +++++
>   include/linux/libnvdimm.h    |    5 ++++
>   5 files changed, 70 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index fa0e57e35162..3902759abcba 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -212,9 +212,6 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
>   	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
>   		return -ENOTTY;
>   
> -	if (!cpu_cache_has_invalidate_memregion())
> -		return -EINVAL;
> -
>   	memcpy(nd_cmd.cmd.passphrase, key_data->data,
>   			sizeof(nd_cmd.cmd.passphrase));
>   	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> @@ -229,9 +226,6 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
>   		return -EIO;
>   	}
>   
> -	/* DIMM unlocked, invalidate all CPU caches before we read it */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> -
>   	return 0;
>   }
>   
> @@ -299,11 +293,6 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
>   	if (!test_bit(cmd, &nfit_mem->dsm_mask))
>   		return -ENOTTY;
>   
> -	if (!cpu_cache_has_invalidate_memregion())
> -		return -EINVAL;
> -
> -	/* flush all cache before we erase DIMM */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>   	memcpy(nd_cmd.cmd.passphrase, key->data,
>   			sizeof(nd_cmd.cmd.passphrase));
>   	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> @@ -322,8 +311,6 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
>   		return -ENXIO;
>   	}
>   
> -	/* DIMM erased, invalidate all CPU caches before we read it */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>   	return 0;
>   }
>   
> @@ -346,9 +333,6 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
>   	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
>   		return -ENOTTY;
>   
> -	if (!cpu_cache_has_invalidate_memregion())
> -		return -EINVAL;
> -
>   	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
>   	if (rc < 0)
>   		return rc;
> @@ -362,8 +346,6 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
>   		return -ENXIO;
>   	}
>   
> -	/* flush all cache before we make the nvdimms available */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>   	return 0;
>   }
>   
> @@ -388,11 +370,6 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
>   	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
>   		return -ENOTTY;
>   
> -	if (!cpu_cache_has_invalidate_memregion())
> -		return -EINVAL;
> -
> -	/* flush all cache before we erase DIMM */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>   	memcpy(nd_cmd.cmd.passphrase, nkey->data,
>   			sizeof(nd_cmd.cmd.passphrase));
>   	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> @@ -770,5 +747,3 @@ static const struct nvdimm_fw_ops __intel_fw_ops = {
>   };
>   
>   const struct nvdimm_fw_ops *intel_fw_ops = &__intel_fw_ops;
> -
> -MODULE_IMPORT_NS(DEVMEM);
> diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
> index 390123d293ea..88dc062af5f8 100644
> --- a/drivers/nvdimm/region.c
> +++ b/drivers/nvdimm/region.c
> @@ -2,6 +2,7 @@
>   /*
>    * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
>    */
> +#include <linux/memregion.h>
>   #include <linux/cpumask.h>
>   #include <linux/module.h>
>   #include <linux/device.h>
> @@ -100,6 +101,16 @@ static void nd_region_remove(struct device *dev)
>   	 */
>   	sysfs_put(nd_region->bb_state);
>   	nd_region->bb_state = NULL;
> +
> +	/*
> +	 * Try to flush caches here since a disabled region may be subject to
> +	 * secure erase while disabled, and previous dirty data should not be
> +	 * written back to a new instance of the region. This only matters on
> +	 * bare metal where security commands are available, so silent failure
> +	 * here is ok.
> +	 */
> +	if (cpu_cache_has_invalidate_memregion())
> +		cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>   }
>   
>   static int child_notify(struct device *dev, void *data)
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e0875d369762..c73e3b1fd0a6 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -59,13 +59,57 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
>   	return 0;
>   }
>   
> +static int nd_region_invalidate_memregion(struct nd_region *nd_region)
> +{
> +	int i, incoherent = 0;
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm *nvdimm = nd_mapping->nvdimm;
> +
> +		if (test_bit(NDD_INCOHERENT, &nvdimm->flags))
> +			incoherent++;
> +	}
> +
> +	if (!incoherent)
> +		return 0;
> +
> +	if (!cpu_cache_has_invalidate_memregion()) {
> +		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
> +			dev_warn(
> +				&nd_region->dev,
> +				"Bypassing cpu_cache_invalidate_memergion() for testing!\n");
> +			goto out;
> +		} else {
> +			dev_err(&nd_region->dev,
> +				"Failed to synchronize CPU cache state\n");
> +			return -ENXIO;
> +		}
> +	}
> +
> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +out:
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm *nvdimm = nd_mapping->nvdimm;
> +
> +		clear_bit(NDD_INCOHERENT, &nvdimm->flags);
> +	}
> +
> +	return 0;
> +}
> +
>   int nd_region_activate(struct nd_region *nd_region)
>   {
> -	int i, j, num_flush = 0;
> +	int i, j, rc, num_flush = 0;
>   	struct nd_region_data *ndrd;
>   	struct device *dev = &nd_region->dev;
>   	size_t flush_data_size = sizeof(void *);
>   
> +	rc = nd_region_invalidate_memregion(nd_region);
> +	if (rc)
> +		return rc;
> +
>   	nvdimm_bus_lock(&nd_region->dev);
>   	for (i = 0; i < nd_region->ndr_mappings; i++) {
>   		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> @@ -85,6 +129,7 @@ int nd_region_activate(struct nd_region *nd_region)
>   	}
>   	nvdimm_bus_unlock(&nd_region->dev);
>   
> +

Extraneous blankline

DJ

>   	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
>   	if (!ndrd)
>   		return -ENOMEM;
> @@ -1222,3 +1267,5 @@ int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
>   
>   	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
>   }
> +
> +MODULE_IMPORT_NS(DEVMEM);
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 6814339b3dab..a03e3c45f297 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -208,6 +208,8 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
>   	rc = nvdimm->sec.ops->unlock(nvdimm, data);
>   	dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
>   			rc == 0 ? "success" : "fail");
> +	if (rc == 0)
> +		set_bit(NDD_INCOHERENT, &nvdimm->flags);
>   
>   	nvdimm_put_key(key);
>   	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> @@ -374,6 +376,8 @@ static int security_erase(struct nvdimm *nvdimm, unsigned int keyid,
>   		return -ENOKEY;
>   
>   	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
> +	if (rc == 0)
> +		set_bit(NDD_INCOHERENT, &nvdimm->flags);
>   	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
>   			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
>   			rc == 0 ? "success" : "fail");
> @@ -408,6 +412,8 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
>   		return -ENOKEY;
>   
>   	rc = nvdimm->sec.ops->overwrite(nvdimm, data);
> +	if (rc == 0)
> +		set_bit(NDD_INCOHERENT, &nvdimm->flags);
>   	dev_dbg(dev, "key: %d overwrite submission: %s\n", key_serial(key),
>   			rc == 0 ? "success" : "fail");
>   
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 3bf658a74ccb..af38252ad704 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -35,6 +35,11 @@ enum {
>   	NDD_WORK_PENDING = 4,
>   	/* dimm supports namespace labels */
>   	NDD_LABELING = 6,
> +	/*
> +	 * dimm contents have changed requiring invalidation of CPU caches prior
> +	 * to activation of a region that includes this device
> +	 */
> +	NDD_INCOHERENT = 7,
>   
>   	/* need to set a limit somewhere, but yes, this is likely overkill */
>   	ND_IOCTL_MAX_BUFLEN = SZ_4M,
> 
