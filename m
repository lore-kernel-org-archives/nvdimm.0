Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B69D2582
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 10:41:00 +0000 (UTC)
Received: from frapeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N7w9Z5ZT5z67Zsv;
	Fri, 11 Nov 2022 18:36:34 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:40:58 +0100
Received: from localhost (10.45.151.252) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 10:40:57 +0000
Date: Fri, 11 Nov 2022 10:40:56 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v3 15/18] tools/testing/cxl: add mechanism to lock mem
 device for testing
Message-ID: <20221111104056.00000cf6@Huawei.com>
In-Reply-To: <166792840837.3767969.8013121990529095896.stgit@djiang5-desk3.ch.intel.com>
References: <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
	<166792840837.3767969.8013121990529095896.stgit@djiang5-desk3.ch.intel.com>
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

On Tue, 08 Nov 2022 10:26:48 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> The mock cxl mem devs needs a way to go into "locked" status to simulate
> when the platform is rebooted. Add a sysfs mechanism so the device security
> state is set to "locked" and the frozen state bits are cleared.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  tools/testing/cxl/test/cxl.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index 6dd286a52839..7384573e8b12 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -628,6 +628,45 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
>  #define SZ_512G (SZ_64G * 8)
>  #endif
>  
> +static ssize_t security_lock_show(struct device *dev,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(dev);
> +
> +	return sysfs_emit(buf, "%u\n",
> +			  !!(mdata->security_state & CXL_PMEM_SEC_STATE_LOCKED));
> +}
> +
> +static ssize_t security_lock_store(struct device *dev, struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(dev);
> +	u32 mask = CXL_PMEM_SEC_STATE_FROZEN | CXL_PMEM_SEC_STATE_USER_PLIMIT |
> +		   CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
> +	int val;
> +
> +	if (kstrtoint(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	if (val == 1) {
> +		if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET))
> +			return -ENXIO;
> +		mdata->security_state |= CXL_PMEM_SEC_STATE_LOCKED;
> +		mdata->security_state &= ~mask;
> +	} else {
> +		return -EINVAL;
> +	}
> +	return count;
> +}
> +
> +static DEVICE_ATTR_RW(security_lock);
> +
> +static struct attribute *cxl_mock_mem_attrs[] = {
> +	&dev_attr_security_lock.attr,
> +	NULL
> +};
> +ATTRIBUTE_GROUPS(cxl_mock_mem);
> +
>  static __init int cxl_test_init(void)
>  {
>  	struct cxl_mock_mem_pdata *mem_pdata;
> @@ -752,6 +791,7 @@ static __init int cxl_test_init(void)
>  			goto err_mem;
>  		}
>  
> +		pdev->dev.groups = cxl_mock_mem_groups;
>  		rc = platform_device_add(pdev);
>  		if (rc) {
>  			platform_device_put(pdev);
> 
> 

