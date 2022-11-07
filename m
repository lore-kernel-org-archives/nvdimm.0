Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7102CA5
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 22:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667860408; x=1699396408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m5rfha3Wok8RrZKJ/vcZCl8d8m+xE9I6IXlmncR30Io=;
  b=UJXuKudcKCIGwC0yQXeG8cTLJKA2SJj0MqEV8M7/rfo3KoAYZUyJDVQU
   wX0yu0kUH1XLYAw7LTx0HJDzInpZazY8Fh1pNLdgPODJjBvmi+fVZ0ibC
   Mwi8iFwq0hC3ikydoqTsqtVjyjVspfWk5lcpAbvYOm/6MaxlCZSTrS+ul
   cBh+Q/RpeFQrj8qsPvwK5f/zRwBjC2msoiP6Pfw9vm2TNAGopVJBUxda8
   hiUM8eai0dfrRUdO91oTMk3gZCFT4hfpyjdQmvxqsnYQFlyukXqDbNMi7
   KmW7Ej+GQSyjw2+DzrcKTzdQ9N9yADKesBODmRxXGMrroZk+zRzeJbJD4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="298054551"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="298054551"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:33:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="741685652"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="741685652"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.213.168.235]) ([10.213.168.235])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:33:26 -0800
Message-ID: <cd657e82-393b-2762-09f4-ae9497e26537@intel.com>
Date: Mon, 7 Nov 2022 14:33:26 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2 16/19] tools/testing/cxl: add mechanism to lock mem
 device for testing
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377438336.430546.14222889528313880160.stgit@djiang5-desk3.ch.intel.com>
 <20221107155658.000048d0@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221107155658.000048d0@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2022 7:56 AM, Jonathan Cameron wrote:
> On Wed, 21 Sep 2022 08:33:03 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> The mock cxl mem devs needs a way to go into "locked" status to simulate
>> when the platform is rebooted. Add a sysfs mechanism so the device security
>> state is set to "locked" and the frozen state bits are cleared.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Hi Dave
> 
> A few minor comments below.
> 
>> ---
>>   tools/testing/cxl/test/cxl.c |   52 ++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 50 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
>> index 6dd286a52839..7f76f494a0d4 100644
>> --- a/tools/testing/cxl/test/cxl.c
>> +++ b/tools/testing/cxl/test/cxl.c
>> @@ -628,6 +628,45 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
>>   #define SZ_512G (SZ_64G * 8)
>>   #endif
>>   
>> +static ssize_t security_lock_show(struct device *dev,
>> +				  struct device_attribute *attr, char *buf)
>> +{
>> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(dev);
>> +
>> +	return sysfs_emit(buf, "%s\n", mdata->security_state & CXL_PMEM_SEC_STATE_LOCKED ?
>> +			  "locked" : "unlocked");
> 
> It's called lock. So 1 or 0 seems sufficient to me rather than needing strings.
> Particularly when you use an int to lock it.

ok

> 
>> +}
>> +
>> +static ssize_t security_lock_store(struct device *dev, struct device_attribute *attr,
>> +				   const char *buf, size_t count)
>> +{
>> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(dev);
>> +	u32 mask = CXL_PMEM_SEC_STATE_FROZEN | CXL_PMEM_SEC_STATE_USER_PLIMIT |
>> +		   CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
>> +	int val;
>> +
>> +	if (kstrtoint(buf, 0, &val) < 0)
>> +		return -EINVAL;
>> +
>> +	if (val == 1) {
>> +		if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET))
>> +			return -ENXIO;
>> +		mdata->security_state |= CXL_PMEM_SEC_STATE_LOCKED;
>> +		mdata->security_state &= ~mask;
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +	return count;
>> +}
>> +
>> +static DEVICE_ATTR_RW(security_lock);
>> +
>> +static struct attribute *cxl_mock_mem_attrs[] = {
>> +	&dev_attr_security_lock.attr,
>> +	NULL
>> +};
>> +ATTRIBUTE_GROUPS(cxl_mock_mem);
>> +
>>   static __init int cxl_test_init(void)
>>   {
>>   	struct cxl_mock_mem_pdata *mem_pdata;
>> @@ -757,6 +796,11 @@ static __init int cxl_test_init(void)
>>   			platform_device_put(pdev);
>>   			goto err_mem;
>>   		}
>> +
>> +		rc = device_add_groups(&pdev->dev, cxl_mock_mem_groups);
> 
> Can we just set pdev->dev.groups? and avoid dynamic part of this or need to
> remove them manually?   I can't immediately find an example of this for
> a platform_device but it's done for lots of other types.

ok

> 
> 
>> +		if (rc)
>> +			goto err_mem;
>> +
>>   		cxl_mem[i] = pdev;
>>   	}
>>   
>> @@ -811,8 +855,12 @@ static __exit void cxl_test_exit(void)
>>   	int i;
>>   
>>   	platform_device_unregister(cxl_acpi);
>> -	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--)
>> -		platform_device_unregister(cxl_mem[i]);
>> +	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--) {
>> +		struct platform_device *pdev = cxl_mem[i];
>> +
>> +		device_remove_groups(&pdev->dev, cxl_mock_mem_groups);
>> +		platform_device_unregister(pdev);
>> +	}
>>   	for (i = ARRAY_SIZE(cxl_switch_dport) - 1; i >= 0; i--)
>>   		platform_device_unregister(cxl_switch_dport[i]);
>>   	for (i = ARRAY_SIZE(cxl_switch_uport) - 1; i >= 0; i--)
>>
>>
> 
> 
