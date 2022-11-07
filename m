Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07EAD527
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 15:25:47 +0000 (UTC)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N5ZhF2hZcz67MQj;
	Mon,  7 Nov 2022 23:21:33 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 16:25:44 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 15:25:44 +0000
Date: Mon, 7 Nov 2022 15:25:43 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 12/19] cxl/pmem: Add "Passphrase Secure Erase"
 security command support
Message-ID: <20221107152543.00001128@Huawei.com>
In-Reply-To: <166377436014.430546.12077333298585882653.stgit@djiang5-desk3.ch.intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377436014.430546.12077333298585882653.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 21 Sep 2022 08:32:40 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Create callback function to support the nvdimm_security_ops() ->erase()
> callback. Translate the operation to send "Passphrase Secure Erase"
> security command for CXL memory device.
> 
> When the mem device is secure erased, arch_invalidate_nvdimm_cache() is
> called in order to invalidate all CPU caches before attempting to access
> the mem device again.
> 
> See CXL 2.0 spec section 8.2.9.5.6.6 for reference.
Update references now 3.0 is out.

> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
A few minor things inline.

> ---
>  drivers/cxl/core/mbox.c      |    1 +
>  drivers/cxl/cxlmem.h         |    8 ++++++++
>  drivers/cxl/security.c       |   29 +++++++++++++++++++++++++++++
>  include/uapi/linux/cxl_mem.h |    1 +
>  4 files changed, 39 insertions(+)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 243b01e2de85..88538a7ccc83 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -70,6 +70,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
>  	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
>  	CXL_CMD(FREEZE_SECURITY, 0, 0, 0),
>  	CXL_CMD(UNLOCK, 0x20, 0, 0),
> +	CXL_CMD(PASSPHRASE_ERASE, 0x40, 0, 0),
>  };
>  
>  /*
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 4e6897e8eb7d..1266df3b2d3d 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -278,6 +278,7 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
>  	CXL_MBOX_OP_UNLOCK		= 0x4503,
>  	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
> +	CXL_MBOX_OP_PASSPHRASE_ERASE	= 0x4505,
Hmm. Name is a bit ambiguous. Is it erasing the passphrase or the data?
Perhaps full
	CXL_MBOX_O_PASSPHRASE_SECURE_ERASE is a little better?

>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  
> @@ -400,6 +401,13 @@ struct cxl_disable_pass {
>  	u8 pass[NVDIMM_PASSPHRASE_LEN];
>  } __packed;
>  
> +/* passphrase erase payload */
Same here.

> +struct cxl_pass_erase {
> +	u8 type;
> +	u8 reserved[31];
> +	u8 pass[NVDIMM_PASSPHRASE_LEN];
> +} __packed;
> +
>  enum {
>  	CXL_PMEM_SEC_PASS_MASTER = 0,
>  	CXL_PMEM_SEC_PASS_USER,
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 8bfdcb58d381..df4cf26e366a 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -128,12 +128,41 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
>  	return 0;
>  }
>  
> +static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
> +					      const struct nvdimm_key_data *key,
> +					      enum nvdimm_passphrase_type ptype)
> +{
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct cxl_pass_erase erase;
> +	int rc;
> +
> +	if (!cpu_cache_has_invalidate_memregion())
> +		return -EOPNOTSUPP;
> +
> +	erase.type = ptype == NVDIMM_MASTER ?
> +		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
> +	memcpy(erase.pass, key->data, NVDIMM_PASSPHRASE_LEN);
> +	/* Flush all cache before we erase mem device */
> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	rc =  cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_PASSPHRASE_ERASE,

extra space.

> +				&erase, sizeof(erase), NULL, 0);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* mem device erased, invalidate all CPU caches before data is read */
> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
> +	return 0;
> +}
> +
>  static const struct nvdimm_security_ops __cxl_security_ops = {
>  	.get_flags = cxl_pmem_get_security_flags,
>  	.change_key = cxl_pmem_security_change_key,
>  	.disable = cxl_pmem_security_disable,
>  	.freeze = cxl_pmem_security_freeze,
>  	.unlock = cxl_pmem_security_unlock,
> +	.erase = cxl_pmem_security_passphrase_erase,
>  };
>  
>  const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
> diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
> index 95dca8d4584f..6da25f2e1bf9 100644
> --- a/include/uapi/linux/cxl_mem.h
> +++ b/include/uapi/linux/cxl_mem.h
> @@ -46,6 +46,7 @@
>  	___C(DISABLE_PASSPHRASE, "Disable Passphrase"),			  \
>  	___C(FREEZE_SECURITY, "Freeze Security"),			  \
>  	___C(UNLOCK, "Unlock"),						  \
> +	___C(PASSPHRASE_ERASE, "Passphrase Secure Erase"),		  \
>  	___C(MAX, "invalid / last command")
>  
>  #define ___C(a, b) CXL_MEM_COMMAND_ID_##a
> 
> 

