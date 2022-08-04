Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD362570
	for <nvdimm@lists.linux.dev>; Thu,  4 Aug 2022 13:19:07 +0000 (UTC)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lz8Mt3WyGz67HRc;
	Thu,  4 Aug 2022 21:14:50 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 15:19:03 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 4 Aug
 2022 14:19:02 +0100
Date: Thu, 4 Aug 2022 14:19:01 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 11/15] cxl/pmem: Add "Unlock" security command
 support
Message-ID: <20220804141901.00005a2a@huawei.com>
In-Reply-To: <165791937639.2491387.6281906434880014077.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791937639.2491387.6281906434880014077.stgit@djiang5-desk3.ch.intel.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 15 Jul 2022 14:09:36 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Create callback function to support the nvdimm_security_ops() ->unlock()
> callback. Translate the operation to send "Unlock" security command for CXL
> mem device.
> 
> When the mem device is unlocked, arch_invalidate_nvdimm_cache() is called
> in order to invalidate all CPU caches before attempting to access the mem
> device.
> 
> See CXL 2.0 spec section 8.2.9.5.6.4 for reference.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Hi Dave,

One trivial thing inline.

Thanks,

Jonathan

> ---
>  drivers/cxl/cxlmem.h   |    1 +
>  drivers/cxl/security.c |   21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index ced85be291f3..ae8ccd484491 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -253,6 +253,7 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
>  	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
>  	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
> +	CXL_MBOX_OP_UNLOCK		= 0x4503,
>  	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 6399266a5908..d15520f280f0 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -114,11 +114,32 @@ static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
>  	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
>  }
>  
> +static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
> +				    const struct nvdimm_key_data *key_data)
> +{
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	u8 pass[NVDIMM_PASSPHRASE_LEN];
> +	int rc;
> +
> +	memcpy(pass, key_data->data, NVDIMM_PASSPHRASE_LEN);

Why do we need a local copy?  I'd have thought we could just
pass keydata->data in as the payload for cxl_mbox_send_cmd()
There might be some value in making it easier to check by
having a structure defined for this payload (obviously trivial)
but given we are using an array of length defined by a non CXL
define, I'm not sure there is any point in the copy.

> +	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_UNLOCK,
> +			       pass, NVDIMM_PASSPHRASE_LEN, NULL, 0);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* DIMM unlocked, invalidate all CPU caches before we read it */
> +	arch_invalidate_nvdimm_cache();
> +	return 0;
> +}
> +
>  static const struct nvdimm_security_ops __cxl_security_ops = {
>  	.get_flags = cxl_pmem_get_security_flags,
>  	.change_key = cxl_pmem_security_change_key,
>  	.disable = cxl_pmem_security_disable,
>  	.freeze = cxl_pmem_security_freeze,
> +	.unlock = cxl_pmem_security_unlock,
>  };
>  
>  const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
> 
> 

