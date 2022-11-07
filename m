Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9367D531
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 15:57:02 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4N5bQs0Xgfz6HJTs;
	Mon,  7 Nov 2022 23:55:01 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Mon, 7 Nov 2022 16:56:59 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 7 Nov
 2022 15:56:59 +0000
Date: Mon, 7 Nov 2022 15:56:58 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH v2 16/19] tools/testing/cxl: add mechanism to lock mem
 device for testing
Message-ID: <20221107155658.000048d0@Huawei.com>
In-Reply-To: <166377438336.430546.14222889528313880160.stgit@djiang5-desk3.ch.intel.com>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
	<166377438336.430546.14222889528313880160.stgit@djiang5-desk3.ch.intel.com>
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
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Wed, 21 Sep 2022 08:33:03 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> The mock cxl mem devs needs a way to go into "locked" status to simulate
> when the platform is rebooted. Add a sysfs mechanism so the device security
> state is set to "locked" and the frozen state bits are cleared.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Hi Dave

A few minor comments below.

> ---
>  tools/testing/cxl/test/cxl.c |   52 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index 6dd286a52839..7f76f494a0d4 100644
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
> +	return sysfs_emit(buf, "%s\n", mdata->security_state & CXL_PMEM_SEC_STATE_LOCKED ?
> +			  "locked" : "unlocked");

It's called lock. So 1 or 0 seems sufficient to me rather than needing strings.
Particularly when you use an int to lock it.

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
> @@ -757,6 +796,11 @@ static __init int cxl_test_init(void)
>  			platform_device_put(pdev);
>  			goto err_mem;
>  		}
> +
> +		rc = device_add_groups(&pdev->dev, cxl_mock_mem_groups);

Can we just set pdev->dev.groups? and avoid dynamic part of this or need to
remove them manually?   I can't immediately find an example of this for
a platform_device but it's done for lots of other types.


> +		if (rc)
> +			goto err_mem;
> +
>  		cxl_mem[i] = pdev;
>  	}
>  
> @@ -811,8 +855,12 @@ static __exit void cxl_test_exit(void)
>  	int i;
>  
>  	platform_device_unregister(cxl_acpi);
> -	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--)
> -		platform_device_unregister(cxl_mem[i]);
> +	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_mem[i];
> +
> +		device_remove_groups(&pdev->dev, cxl_mock_mem_groups);
> +		platform_device_unregister(pdev);
> +	}
>  	for (i = ARRAY_SIZE(cxl_switch_dport) - 1; i >= 0; i--)
>  		platform_device_unregister(cxl_switch_dport[i]);
>  	for (i = ARRAY_SIZE(cxl_switch_uport) - 1; i >= 0; i--)
> 
> 

