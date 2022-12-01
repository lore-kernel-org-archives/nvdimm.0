Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE04111A
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 11:12:10 +0000 (UTC)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNCy26jWSz6H710;
	Thu,  1 Dec 2022 19:09:14 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Dec 2022 12:12:01 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 11:12:00 +0000
Date: Thu, 1 Dec 2022 11:11:59 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v7 18/20] cxl: bypass cpu_cache_invalidate_memregion()
 when in test config
Message-ID: <20221201111159.00002ce5@Huawei.com>
In-Reply-To: <166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
	<166983619332.2734609.2800078343178136915.stgit@djiang5-desk3.ch.intel.com>
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

On Wed, 30 Nov 2022 12:23:13 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Bypass cpu_cache_invalidate_memregion() and checks when doing testing
> using CONFIG_NVDIMM_SECURITY_TEST flag. The bypass allows testing on
> QEMU where cpu_cache_has_invalidate_memregion() fails. Usage of
> cpu_cache_invalidate_memregion() is not needed for cxl_test security
> testing.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Subject to naming discussion resolving, this looks good to me..

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/security.c |   35 ++++++++++++++++++++++++++++++-----
>  1 file changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index cbd005ceb091..2b5088af8fc4 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -111,6 +111,31 @@ static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
>  	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
>  }
>  
> +static bool cxl_has_invalidate_memregion(struct cxl_nvdimm *cxl_nvd)
> +{
> +	if (!cpu_cache_has_invalidate_memregion()) {
> +		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
> +			dev_warn_once(&cxl_nvd->dev,
> +				      "Bypassing cpu_cache_has_invalidate_memregion() check for testing!\n");
> +			return true;
> +		}
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void cxl_invalidate_memregion(struct cxl_nvdimm *cxl_nvd)
> +{
> +	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
> +		dev_warn_once(&cxl_nvd->dev,
> +			      "Bypassing cpu_cache_invalidate_memergion() for testing!\n");
> +		return;
> +	}
> +
> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +}
> +
>  static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
>  				    const struct nvdimm_key_data *key_data)
>  {
> @@ -120,7 +145,7 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
>  	u8 pass[NVDIMM_PASSPHRASE_LEN];
>  	int rc;
>  
> -	if (!cpu_cache_has_invalidate_memregion())
> +	if (!cxl_has_invalidate_memregion(cxl_nvd))
>  		return -EINVAL;
>  
>  	memcpy(pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
> @@ -130,7 +155,7 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
>  		return rc;
>  
>  	/* DIMM unlocked, invalidate all CPU caches before we read it */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	cxl_invalidate_memregion(cxl_nvd);
>  	return 0;
>  }
>  
> @@ -144,21 +169,21 @@ static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
>  	struct cxl_pass_erase erase;
>  	int rc;
>  
> -	if (!cpu_cache_has_invalidate_memregion())
> +	if (!cxl_has_invalidate_memregion(cxl_nvd))
>  		return -EINVAL;
>  
>  	erase.type = ptype == NVDIMM_MASTER ?
>  		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
>  	memcpy(erase.pass, key->data, NVDIMM_PASSPHRASE_LEN);
>  	/* Flush all cache before we erase mem device */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	cxl_invalidate_memregion(cxl_nvd);
>  	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE,
>  			       &erase, sizeof(erase), NULL, 0);
>  	if (rc < 0)
>  		return rc;
>  
>  	/* mem device erased, invalidate all CPU caches before data is read */
> -	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	cxl_invalidate_memregion(cxl_nvd);
>  	return 0;
>  }
>  
> 
> 

