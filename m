Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7DB1116
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 11:22:30 +0000 (UTC)
Received: from frapeml100006.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NND9j51Xbz6HJV2;
	Thu,  1 Dec 2022 19:19:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100006.china.huawei.com (7.182.85.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 12:22:27 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 11:22:27 +0000
Date: Thu, 1 Dec 2022 11:22:26 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v7 19/20] acpi/nfit: bypass
 cpu_cache_invalidate_memregion() when in test config
Message-ID: <20221201112226.000069fe@Huawei.com>
In-Reply-To: <166983619896.2734609.7192339006218947870.stgit@djiang5-desk3.ch.intel.com>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
	<166983619896.2734609.7192339006218947870.stgit@djiang5-desk3.ch.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 30 Nov 2022 12:23:18 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Bypass cpu_cache_invalidate_memregion() and checks when doing testing
> using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
> QEMU where cpu_cache_has_invalidate_memregion() fails. 

We should probably look at what is required to get that to not fail on QEMU
at least when running fully emulated on x86.

Longer term we'll figure out other architecture solutions for this...

FWIW this looks consistent with what you are aiming to do so.
So subject to the usual I've no idea how this intel specific code works in
general, so only focusing on the corner this patch touches...

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


Jonathan


> Usage of
> cpu_cache_invalidate_memregion() is not needed for nfit_test security
> testing.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/intel.c |   51 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 42 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index fa0e57e35162..38069f10c316 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -191,6 +191,39 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
>  	}
>  }
>  
> +static bool intel_has_invalidate_memregion(struct nvdimm *nvdimm)
> +{
> +	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +	struct acpi_nfit_desc *acpi_desc = nfit_mem->acpi_desc;
> +	struct device *dev = acpi_desc->dev;
> +
> +	if (!cpu_cache_has_invalidate_memregion()) {
> +		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
> +			dev_warn_once(dev,
> +				      "Bypassing cpu_cache_has_invalidate_memregion() check for testing!\n");
> +			return true;
> +		}
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void intel_invalidate_memregion(struct nvdimm *nvdimm)
> +{
> +	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +	struct acpi_nfit_desc *acpi_desc = nfit_mem->acpi_desc;
> +	struct device *dev = acpi_desc->dev;
> +
> +	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
> +		dev_warn_once(dev,
> +			      "Bypassing cpu_cache_invalidate_memergion() for testing!\n");
> +		return;
> +	}
> +
> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +}
> +
>  static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
>  		const struct nvdimm_key_data *key_data)
>  {
> @@ -212,7 +245,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
>  	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
>  		return -ENOTTY;
>  
> -	if (!cpu_cache_has_invalidate_memregion())
> +	if (!intel_has_invalidate_memregion(nvdimm))
>  		return -EINVAL;
>  
>  	memcpy(nd_cmd.cmd.passphrase, key_data->data,
> @@ -230,7 +263,7 @@ static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
>  	}
>  
>  	/* DIMM unlocked, invalidate all CPU caches before we read it */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	intel_invalidate_memregion(nvdimm);
>  
>  	return 0;
>  }
> @@ -299,11 +332,11 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
>  	if (!test_bit(cmd, &nfit_mem->dsm_mask))
>  		return -ENOTTY;
>  
> -	if (!cpu_cache_has_invalidate_memregion())
> +	if (!intel_has_invalidate_memregion(nvdimm))
>  		return -EINVAL;
>  
>  	/* flush all cache before we erase DIMM */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	intel_invalidate_memregion(nvdimm);
>  	memcpy(nd_cmd.cmd.passphrase, key->data,
>  			sizeof(nd_cmd.cmd.passphrase));
>  	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> @@ -323,7 +356,7 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
>  	}
>  
>  	/* DIMM erased, invalidate all CPU caches before we read it */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	intel_invalidate_memregion(nvdimm);
>  	return 0;
>  }
>  
> @@ -346,7 +379,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
>  	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
>  		return -ENOTTY;
>  
> -	if (!cpu_cache_has_invalidate_memregion())
> +	if (!intel_has_invalidate_memregion(nvdimm))
>  		return -EINVAL;
>  
>  	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> @@ -363,7 +396,7 @@ static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
>  	}
>  
>  	/* flush all cache before we make the nvdimms available */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	intel_invalidate_memregion(nvdimm);
>  	return 0;
>  }
>  
> @@ -388,11 +421,11 @@ static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
>  	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
>  		return -ENOTTY;
>  
> -	if (!cpu_cache_has_invalidate_memregion())
> +	if (!intel_has_invalidate_memregion(nvdimm))
>  		return -EINVAL;
>  
>  	/* flush all cache before we erase DIMM */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	intel_invalidate_memregion(nvdimm);
>  	memcpy(nd_cmd.cmd.passphrase, nkey->data,
>  			sizeof(nd_cmd.cmd.passphrase));
>  	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
> 
> 

