Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D812582
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 10:39:57 +0000 (UTC)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N7wBn4tP4z67x9N;
	Fri, 11 Nov 2022 18:37:37 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:39:54 +0100
Received: from localhost (10.45.151.252) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 10:39:54 +0000
Date: Fri, 11 Nov 2022 10:39:52 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v3 14/18] cxl/pmem: add id attribute to CXL based nvdimm
Message-ID: <20221111103952.00005560@Huawei.com>
In-Reply-To: <166792840255.3767969.7931186352678182941.stgit@djiang5-desk3.ch.intel.com>
References: <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
	<166792840255.3767969.7931186352678182941.stgit@djiang5-desk3.ch.intel.com>
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
X-Originating-IP: [10.45.151.252]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 08 Nov 2022 10:26:42 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> Add an id group attribute for CXL based nvdimm object. The addition allows
> ndctl to display the "unique id" for the nvdimm. The serial number for the
> CXL memory device will be used for this id.
> 
> [
>   {
>       "dev":"nmem10",
>       "id":"0x4",
>       "security":"disabled"
>   },
> ]
> 
> The id attribute is needed by the ndctl security key management to setup a
> keyblob with a unique file name tied to the mem device.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  Documentation/ABI/testing/sysfs-bus-nvdimm |    6 ++++++
>  drivers/cxl/pmem.c                         |   28 +++++++++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-nvdimm b/Documentation/ABI/testing/sysfs-bus-nvdimm
> index 1c1f5acbf53d..91945211e53b 100644
> --- a/Documentation/ABI/testing/sysfs-bus-nvdimm
> +++ b/Documentation/ABI/testing/sysfs-bus-nvdimm
> @@ -41,3 +41,9 @@ KernelVersion:  5.18
>  Contact:        Kajol Jain <kjain@linux.ibm.com>
>  Description:	(RO) This sysfs file exposes the cpumask which is designated to
>  		to retrieve nvdimm pmu event counter data.
> +
> +What:		/sys/bus/nd/devices/nmemX/id
> +Date:		November 2022
> +KernelVersion:	6.2
> +Contact:	Dave Jiang <dave.jiang@intel.com>
> +Description:	(RO) Show the id (serial) of the device.
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 24bec4ca3866..9209c7dd72d0 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -48,6 +48,31 @@ static void unregister_nvdimm(void *nvdimm)
>  	cxl_nvd->bridge = NULL;
>  }
>  
> +static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> +	struct cxl_dev_state *cxlds = cxl_nvd->cxlmd->cxlds;
> +
> +	return sysfs_emit(buf, "%lld\n", cxlds->serial);
> +}
> +static DEVICE_ATTR_RO(id);
> +
> +static struct attribute *cxl_dimm_attributes[] = {
> +	&dev_attr_id.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group cxl_dimm_attribute_group = {
> +	.name = "cxl",
> +	.attrs = cxl_dimm_attributes,
> +};
> +
> +static const struct attribute_group *cxl_dimm_attribute_groups[] = {
> +	&cxl_dimm_attribute_group,
> +	NULL
> +};
> +
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> @@ -77,7 +102,8 @@ static int cxl_nvdimm_probe(struct device *dev)
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>  	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> -	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
> +	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd,
> +				 cxl_dimm_attribute_groups, flags,
>  				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
>  	if (!nvdimm) {
>  		rc = -ENOMEM;
> 
> 

