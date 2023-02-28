Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13FF3D9F
	for <nvdimm@lists.linux.dev>; Tue, 28 Feb 2023 15:28:22 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PR0y94zN1z6J7dy;
	Tue, 28 Feb 2023 23:04:17 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 28 Feb
 2023 15:09:12 +0000
Date: Tue, 28 Feb 2023 15:09:11 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v7 01/20] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
Message-ID: <20230228150911.00002535@Huawei.com>
In-Reply-To: <166983609611.2734609.13231854299523325319.stgit@djiang5-desk3.ch.intel.com>
References: <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
	<166983609611.2734609.13231854299523325319.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 30 Nov 2022 12:21:36 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add nvdimm_security_ops support for CXL memory device with the introduction
> of the ->get_flags() callback function. This is part of the "Persistent
> Memory Data-at-rest Security" command set for CXL memory device support.
> The ->get_flags() function provides the security state of the persistent
> memory device defined by the CXL 3.0 spec section 8.2.9.8.6.1.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Link: https://lore.kernel.org/r/166863346914.80269.2104235260504076729.stgit@djiang5-desk3.ch.intel.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Hi Dave / Dan,

Just looking at build warnings with current upstream with W=1 C=1 and it highlights
and oddity with this patch.


> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 4c627d67281a..efffc731c2ec 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -11,6 +11,8 @@
>  #include "cxlmem.h"
>  #include "cxl.h"
>  
> +extern const struct nvdimm_security_ops *cxl_security_ops;
Why not push this into a header as...
> +
>  /*
>   * Ordered workqueue for cxl nvdimm device arrival and departure
>   * to coordinate bus rescans when a bridge arrives and trigger remove
> @@ -78,8 +80,8 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>  	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> -	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
> -			       cmd_mask, 0, NULL);
> +	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
> +				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
>  	if (!nvdimm) {
>  		rc = -ENOMEM;
>  		goto out;
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> new file mode 100644
> index 000000000000..806173084216
> --- /dev/null
> +++ b/drivers/cxl/security.c

> +
> +static const struct nvdimm_security_ops __cxl_security_ops = {
> +	.get_flags = cxl_pmem_get_security_flags,
> +};
> +
> +const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;

otherwise this triggers a should static warning as the compiler can't see the extern
definition.

Jonathan
