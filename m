Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F020E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:21:23 +0000 (UTC)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lydny2JpVz67btc;
	Thu,  4 Aug 2022 01:17:10 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:21:20 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:21:20 +0100
Date: Wed, 3 Aug 2022 18:21:17 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 06/15] cxl/pmem: Add Disable Passphrase security
 command support
Message-ID: <20220803182117.0000220b@huawei.com>
In-Reply-To: <165791934720.2491387.11236603584810515256.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791934720.2491387.11236603584810515256.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 15 Jul 2022 14:09:07 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Create callback function to support the nvdimm_security_ops ->disable()
> callback. Translate the operation to send "Disable Passphrase" security
> command for CXL memory device. The operation supports disabling a
> passphrase for the CXL persistent memory device. In the original
> implementation of nvdimm_security_ops, this operation only supports
> disabling of the user passphrase. This is due to the NFIT version of
> disable passphrase only supported disabling of user passphrase. The CXL
> spec allows disabling of the master passphrase as well which
> nvidmm_security_ops does not support yet. In this commit, the callback
nvdimm...
> function will only support user passphrase.
> 
> See CXL 2.0 spec section 8.2.9.5.6.3 for reference.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Trivial comment inline otherwise lgtm

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/cxlmem.h   |    8 ++++++++
>  drivers/cxl/security.c |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 1e76d22f4fd2..70a1eb7720d3 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -252,6 +252,7 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
>  	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
>  	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
> +	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  
> @@ -359,6 +360,13 @@ struct cxl_set_pass {
>  	u8 new_pass[NVDIMM_PASSPHRASE_LEN];
>  } __packed;
>  
> +/* disable passphrase input payload */
> +struct cxl_disable_pass {
> +	u8 type;
> +	u8 reserved[31];
> +	u8 pass[NVDIMM_PASSPHRASE_LEN];
> +} __packed;
> +
>  enum {
>  	CXL_PMEM_SEC_PASS_MASTER = 0,
>  	CXL_PMEM_SEC_PASS_USER,
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 76ec5087f966..4aec8e41e167 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -76,9 +76,39 @@ static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
>  	return rc;
>  }
>  
> +static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
> +				     const struct nvdimm_key_data *key_data)
> +{
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct cxl_disable_pass *dis_pass;
> +	int rc;
> +
> +	dis_pass = kzalloc(sizeof(*dis_pass), GFP_KERNEL);

Another fairly small structure. Maybe just put it on the stack...

> +	if (!dis_pass)
> +		return -ENOMEM;
> +
> +	/*
> +	 * While the CXL spec defines the ability to erase the master passphrase,
> +	 * the original nvdimm security ops does not provide that capability.
> +	 * In order to preserve backward compatibility, this callback will
> +	 * only support disable of user passphrase. The disable master passphrase
> +	 * ability will need to be added as a new callback.

Curious. Why is that callback set in stone? If this is exposed directly to userspace
perhaps call that out here.


> +	 */
> +	dis_pass->type = CXL_PMEM_SEC_PASS_USER;
> +	memcpy(dis_pass->pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
> +
> +	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_DISABLE_PASSPHRASE,
> +			       dis_pass, sizeof(*dis_pass), NULL, 0);
> +	kfree(dis_pass);
> +	return rc;
> +}
> +
>  static const struct nvdimm_security_ops __cxl_security_ops = {
>  	.get_flags = cxl_pmem_get_security_flags,
>  	.change_key = cxl_pmem_security_change_key,
> +	.disable = cxl_pmem_security_disable,
>  };
>  
>  const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
> 
> 

