Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A83520E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:23:45 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lydqs4Bnkz688hM;
	Thu,  4 Aug 2022 01:18:49 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:23:42 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:23:42 +0100
Date: Wed, 3 Aug 2022 18:23:41 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 08/15] cxl/pmem: Add "Freeze Security State"
 security command support
Message-ID: <20220803182341.0000563d@huawei.com>
In-Reply-To: <165791935875.2491387.542348076045531850.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791935875.2491387.542348076045531850.stgit@djiang5-desk3.ch.intel.com>
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

On Fri, 15 Jul 2022 14:09:18 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Create callback function to support the nvdimm_security_ops() ->freeze()
> callback. Translate the operation to send "Freeze Security State" security
> command for CXL memory device.
> 
> See CXL 2.0 spec section 8.2.9.5.6.5 for reference.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/cxlmem.h   |    1 +
>  drivers/cxl/security.c |   10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 70a1eb7720d3..ced85be291f3 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -253,6 +253,7 @@ enum cxl_opcode {
>  	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
>  	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
>  	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
> +	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
>  	CXL_MBOX_OP_MAX			= 0x10000
>  };
>  
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 4aec8e41e167..6399266a5908 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -105,10 +105,20 @@ static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
>  	return rc;
>  }
>  
> +static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
> +{
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +
> +	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
> +}
> +
>  static const struct nvdimm_security_ops __cxl_security_ops = {
>  	.get_flags = cxl_pmem_get_security_flags,
>  	.change_key = cxl_pmem_security_change_key,
>  	.disable = cxl_pmem_security_disable,
> +	.freeze = cxl_pmem_security_freeze,
>  };
>  
>  const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
> 
> 

