Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F1028E7
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 09:18:17 +0000 (UTC)
Received: from dggpeml500005.china.huawei.com (unknown [172.30.72.57])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRF9Q3V0QzJp6T;
	Tue,  6 Dec 2022 17:14:34 +0800 (CST)
Received: from [10.174.178.155] (10.174.178.155) by
 dggpeml500005.china.huawei.com (7.185.36.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 17:17:33 +0800
Subject: Re: [PATCH] dax/hmem: Fix refcount leak in dax_hmem_probe()
To: Ira Weiny <ira.weiny@intel.com>
CC: <linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <akpm@linux-foundation.org>,
	<joao.m.martins@oracle.com>, <zhangxiaoxu5@huawei.com>
References: <20221203095858.612027-1-liuyongqiang13@huawei.com>
 <Y4u2TK4yPU9dfiDr@iweiny-mobl>
From: Yongqiang Liu <liuyongqiang13@huawei.com>
Message-ID: <03a5fc74-1b16-a0ee-c0a0-b45943f76bf0@huawei.com>
Date: Tue, 6 Dec 2022 17:17:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y4u2TK4yPU9dfiDr@iweiny-mobl>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.155]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500005.china.huawei.com (7.185.36.59)
X-CFilter-Loop: Reflected


ÔÚ 2022/12/4 4:49, Ira Weiny Ð´µÀ:
> On Sat, Dec 03, 2022 at 09:58:58AM +0000, Yongqiang Liu wrote:
>> We should always call dax_region_put() whenever devm_create_dev_dax()
>> succeed or fail to avoid refcount leak of dax_region. Move the return
>> value check after dax_region_put().
> I think dax_region_put is called from dax_region_unregister() automatically on
> tear down.
Yes, Thanks for your explanation.
>> Fixes: c01044cc8191 ("ACPI: HMAT: refactor hmat_register_target_device to hmem_register_device")
> I'm also not sure how this patch is related to this fix.
>
> Ira
>
>> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
>> ---
>>   drivers/dax/hmem/hmem.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
>> index 1bf040dbc834..09f5cd7b6c8e 100644
>> --- a/drivers/dax/hmem/hmem.c
>> +++ b/drivers/dax/hmem/hmem.c
>> @@ -36,12 +36,11 @@ static int dax_hmem_probe(struct platform_device *pdev)
>>   		.size = region_idle ? 0 : resource_size(res),
>>   	};
>>   	dev_dax = devm_create_dev_dax(&data);
>> -	if (IS_ERR(dev_dax))
>> -		return PTR_ERR(dev_dax);
>>   
>>   	/* child dev_dax instances now own the lifetime of the dax_region */
>>   	dax_region_put(dax_region);
>> -	return 0;
>> +
>> +	return IS_ERR(dev_dax) ? PTR_ERR(dev_dax) : 0;
>>   }
>>   
>>   static int dax_hmem_remove(struct platform_device *pdev)
>> -- 
>> 2.25.1
>>
>>
> .
