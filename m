Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422215C2
	for <nvdimm@lists.linux.dev>; Tue,  9 Aug 2022 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660077007; x=1691613007;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=71gXcCiIrRqrAMZqZLiditzGyBcKnr9ngpE/U5wN+kA=;
  b=LYfY3+mLRM1bovhcxMXjjr5w9zwxeby85OvN17PwM/ABYDfV0yzSvhib
   AYdx3EE3X2jVqdCf5Cimy96JxxVFu8g9vzHX1z27fjoXVmIzGo6Dbh9DM
   NaGMDupaZGy4+mNvk6JPC0PrZtmeEbs+v+GpIRpu9+oMl3168DwHnoXic
   Yr9z7mLXF7oQslNpIl1JXusGwFa5NgfCeh9LxvfqaXJ3A8EjdZleSlCq0
   4JItJkOlGZgv1RVrBGn1B4zBogndFMPgoxk8+Ta+ZkbexnxKALxIkHnFT
   Ar3soCbiYEjkQRKWy+ynYYygTO68IwU8X0nmMDK+qFI6cw/E7djJiuVeJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="352660829"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="352660829"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 13:30:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="664582603"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.24.249]) ([10.212.24.249])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 13:30:06 -0700
Message-ID: <6d8481db-6b74-7319-21d5-203f983eb811@intel.com>
Date: Tue, 9 Aug 2022 13:30:05 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH RFC 02/15] tools/testing/cxl: Create context for cxl mock
 device
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791932409.2491387.9065856569307593223.stgit@djiang5-desk3.ch.intel.com>
 <20220803173619.00002da7@huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220803173619.00002da7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/3/2022 9:36 AM, Jonathan Cameron wrote:
> On Fri, 15 Jul 2022 14:08:44 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
>
>> Add context struct for mock device and move lsa under the context. This
>> allows additional information such as security status and other persistent
>> security data such as passphrase to be added for the emulated test device.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   tools/testing/cxl/test/mem.c |   29 +++++++++++++++++++++++------
>>   1 file changed, 23 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>> index 6b9239b2afd4..723378248321 100644
>> --- a/tools/testing/cxl/test/mem.c
>> +++ b/tools/testing/cxl/test/mem.c
>> @@ -9,6 +9,10 @@
>>   #include <linux/bits.h>
>>   #include <cxlmem.h>
>>   
>> +struct mock_mdev_data {
>> +	void *lsa;
>> +};
>> +
>>   #define LSA_SIZE SZ_128K
>>   #define EFFECT(x) (1U << x)
>>   
>> @@ -140,7 +144,8 @@ static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>>   static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>>   {
>>   	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
>> -	void *lsa = dev_get_drvdata(cxlds->dev);
>> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
>> +	void *lsa = mdata->lsa;
>>   	u32 offset, length;
>>   
>>   	if (sizeof(*get_lsa) > cmd->size_in)
>> @@ -159,7 +164,8 @@ static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>>   static int mock_set_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>>   {
>>   	struct cxl_mbox_set_lsa *set_lsa = cmd->payload_in;
>> -	void *lsa = dev_get_drvdata(cxlds->dev);
>> +	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
>> +	void *lsa = mdata->lsa;
>>   	u32 offset, length;
>>   
>>   	if (sizeof(*set_lsa) > cmd->size_in)
>> @@ -237,9 +243,12 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>>   	return rc;
>>   }
>>   
>> -static void label_area_release(void *lsa)
>> +static void cxl_mock_drvdata_release(void *data)
>>   {
>> -	vfree(lsa);
>> +	struct mock_mdev_data *mdata = data;
>> +
>> +	vfree(mdata->lsa);
>> +	vfree(mdata);
>>   }
>>   
>>   static int cxl_mock_mem_probe(struct platform_device *pdev)
>> @@ -247,13 +256,21 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>>   	struct device *dev = &pdev->dev;
>>   	struct cxl_memdev *cxlmd;
>>   	struct cxl_dev_state *cxlds;
>> +	struct mock_mdev_data *mdata;
>>   	void *lsa;
>>   	int rc;
>>   
>> +	mdata = vmalloc(sizeof(*mdata));
> It's tiny so why vmalloc?  I guess that might become apparent later.
> devm_kzalloc() should be fine and lead to simpler error handling.
In my testing I actually realized that this needs to be part of platform 
data in order for the contents to be "persistent" even the driver is 
unloaded. So this allocation has moved to cxl_test_init() and managed 
via platform_device_add_data(). And the function makes a copy of the 
passed in data rather than taking it as is and that is managed with the 
platform device lifetime.
>
>> +	if (!mdata)
>> +		return -ENOMEM;
>> +
>>   	lsa = vmalloc(LSA_SIZE);
>> -	if (!lsa)
>> +	if (!lsa) {
>> +		vfree(mdata);
> In general doing this just makes things fragile in the long term. Better to
> register one devm_add_action_or_reset() for each thing set up (or standard
> allcoation).
>
>>   		return -ENOMEM;
>> -	rc = devm_add_action_or_reset(dev, label_area_release, lsa);
>> +	}
>> +
>> +	rc = devm_add_action_or_reset(dev, cxl_mock_drvdata_release, mdata);
>>   	if (rc)
>>   		return rc;
>>   	dev_set_drvdata(dev, lsa);
>>
>>
