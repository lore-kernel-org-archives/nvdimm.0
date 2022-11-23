Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B477E
	for <nvdimm@lists.linux.dev>; Wed, 23 Nov 2022 15:09:23 +0000 (UTC)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NHPZB65Z9zqScT;
	Wed, 23 Nov 2022 23:05:22 +0800 (CST)
Received: from [10.67.110.112] (10.67.110.112) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 23:09:18 +0800
Subject: Re: [PATCH] libnvdimm/of_pmem: Fix memory leak in
 of_pmem_region_probe()
To: Tarun Sahu <tsahu@linux.ibm.com>
CC: <oohall@gmail.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<aneesh.kumar@linux.ibm.com>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20221123134527.119441-1-xiujianfeng@huawei.com>
 <20221123145349.yrjo53cz7ez5i36o@tarunpc.in.ibm.com>
From: xiujianfeng <xiujianfeng@huawei.com>
Message-ID: <52fdcd0b-67e4-2889-59bf-1889164e157f@huawei.com>
Date: Wed, 23 Nov 2022 23:09:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221123145349.yrjo53cz7ez5i36o@tarunpc.in.ibm.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.112]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected

Hi,

ÔÚ 2022/11/23 22:53, Tarun Sahu Ð´µÀ:
> Hi,
> Thanks for resolving it.
> 
> All looks good. Except a thing, there is no check for return status of
> ksrdup too. that can also be part of this patch.

Thanks for review, already sent v2.

> 
> On Nov 23 2022, Xiu Jianfeng wrote:
>> After changes in commit 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique
>> name for bus provider"), @priv->bus_desc.provider_name is no longer a
>> const string, but a dynamic string allocated by kstrdup(), it should be
>> freed on the error path, and when driver is removed.
>>
>> Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
>> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
>> ---
>>   drivers/nvdimm/of_pmem.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
>> index 10dbdcdfb9ce..1292ffca7b2e 100644
>> --- a/drivers/nvdimm/of_pmem.c
>> +++ b/drivers/nvdimm/of_pmem.c
>> @@ -36,6 +36,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>>   
>>   	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
>>   	if (!bus) {
>> +		kfree(priv->bus_desc.provider_name);
>>   		kfree(priv);
>>   		return -ENODEV;
>>   	}
>> @@ -83,6 +84,7 @@ static int of_pmem_region_remove(struct platform_device *pdev)
>>   	struct of_pmem_private *priv = platform_get_drvdata(pdev);
>>   
>>   	nvdimm_bus_unregister(priv->bus);
>> +	kfree(priv->bus_desc.provider_name);
>>   	kfree(priv);
>>   
>>   	return 0;
>> -- 
>> 2.17.1
>>
> .
> 
