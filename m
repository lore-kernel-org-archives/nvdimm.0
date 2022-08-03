Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1369F20E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:01:41 +0000 (UTC)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LydLP6VPDz682vm;
	Thu,  4 Aug 2022 00:56:45 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:01:39 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:01:38 +0100
Date: Wed, 3 Aug 2022 18:01:36 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 04/15] cxl/pmem: Add "Set Passphrase" security
 command support
Message-ID: <20220803180136.00001526@huawei.com>
In-Reply-To: <165791933557.2491387.2141316283759403219.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791933557.2491387.2141316283759403219.stgit@djiang5-desk3.ch.intel.com>
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

On Fri, 15 Jul 2022 14:08:55 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Create callback function to support the nvdimm_security_ops ->change_key()
> callback. Translate the operation to send "Set Passphrase" security command
> for CXL memory device. The operation supports setting a passphrase for the
> CXL persistent memory device. It also supports the changing of the
> currently set passphrase. The operation allows manipulation of a user
> passphrase or a master passphrase.
> 
> See CXL 2.0 spec section 8.2.9.5.6.2 for reference.
> 
> However, the spec leaves a gap WRT master passphrase usages. The spec does
> not define any ways to retrieve the status of if the support of master
> passphrase is available for the device, nor does the commands that utilize
> master passphrase will return a specific error that indicates master
> passphrase is not supported. If using a device does not support master
> passphrase and a command is issued with a master passphrase, the error
> message returned by the device will be ambiguos.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
A couple of trivial comments all of which I'm fine with you ignoring if you like

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/cxlmem.h   |   14 ++++++++++++++
>  drivers/cxl/security.c |   27 +++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 35de2889aac3..1e76d22f4fd2 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -251,6 +251,7 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
>  	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
>  	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
> +	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  
> @@ -350,6 +351,19 @@ struct cxl_mem_command {
>  #define CXL_PMEM_SEC_STATE_USER_PLIMIT		0x10
>  #define CXL_PMEM_SEC_STATE_MASTER_PLIMIT	0x20
>  
> +/* set passphrase input payload */
> +struct cxl_set_pass {
> +	u8 type;
> +	u8 reserved[31];
> +	u8 old_pass[NVDIMM_PASSPHRASE_LEN];

Obviously same length, but maybe a comment to that effect as
the is a CXL structure using an NVIDMM define.

> +	u8 new_pass[NVDIMM_PASSPHRASE_LEN];
> +} __packed;
> +
> +enum {
> +	CXL_PMEM_SEC_PASS_MASTER = 0,
> +	CXL_PMEM_SEC_PASS_USER,
> +};
> +
>  int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
>  		      size_t in_size, void *out, size_t out_size);
>  int cxl_dev_state_identify(struct cxl_dev_state *cxlds);
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 5b830ae621db..76ec5087f966 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -50,8 +50,35 @@ static unsigned long cxl_pmem_get_security_flags(struct nvdimm *nvdimm,
>  	return security_flags;
>  }
>  
> +static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
> +					const struct nvdimm_key_data *old_data,
> +					const struct nvdimm_key_data *new_data,
> +					enum nvdimm_passphrase_type ptype)
> +{
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct cxl_set_pass *set_pass;
> +	int rc;
> +
> +	set_pass = kzalloc(sizeof(*set_pass), GFP_KERNEL);

It's not huge.  Maybe just have it on the stack? I'm fine either way.

> +	if (!set_pass)
> +		return -ENOMEM;
> +
> +	set_pass->type = ptype == NVDIMM_MASTER ?
> +		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
> +	memcpy(set_pass->old_pass, old_data->data, NVDIMM_PASSPHRASE_LEN);
> +	memcpy(set_pass->new_pass, new_data->data, NVDIMM_PASSPHRASE_LEN);
> +
> +	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_SET_PASSPHRASE,
> +			       set_pass, sizeof(*set_pass), NULL, 0);
> +	kfree(set_pass);
> +	return rc;
> +}
> +
>  static const struct nvdimm_security_ops __cxl_security_ops = {
>  	.get_flags = cxl_pmem_get_security_flags,
> +	.change_key = cxl_pmem_security_change_key,
>  };
>  
>  const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
> 
> 

