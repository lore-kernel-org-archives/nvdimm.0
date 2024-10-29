Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F3E8BE8
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 02:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730167863; cv=none; b=uPfloJHzw0t3f6z0BRoRPW2Eyr9oDOleZWzLTd51JBl1IS1jsuIiM+wN01gcVyOgZmlTGMvIqJ0V2DrT7UZVemN6Wib4u758VCUdFlhHFFyw2+dPL+HZnbeeB9B80yC4iEgPCB+o+r5YVKnxbTQdEMgaFixSVujP96Asj9fU1uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730167863; c=relaxed/simple;
	bh=McqEDinxh+CEPUAks2pZouEGP2ByOcz6+M7eiCHV3HI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dH3jQro3zhpc64fP6y7N6fKETrAATMwnG3WqbtJgzV5SbOrcb5z7Fgtix2AsjNtW9IXhMeJd6HsoOYibqtQ9eKMjBvPI/6fIWBoIapLBEZrpzT5PTaxIa9nVr6pVBfvdffZYLuT51lIHKsinZHwdijOJCogCSDJ19t4wrElmz4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Xctwp6tD8zyTvc
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 10:09:14 +0800 (CST)
Received: from kwepemk200016.china.huawei.com (unknown [7.202.194.82])
	by mail.maildlp.com (Postfix) with ESMTPS id 9370C1402CC
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 10:10:52 +0800 (CST)
Received: from [10.67.108.122] (10.67.108.122) by
 kwepemk200016.china.huawei.com (7.202.194.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 29 Oct 2024 10:10:52 +0800
Subject: Re: [PATCH] nvdimm: fix possible null-ptr-deref in nd_dax_probe()
To: Ira Weiny <ira.weiny@intel.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <wangweiyang2@huawei.com>
References: <20241026010622.2641355-1-yiyang13@huawei.com>
 <671f9cee9a07f_23f01e2949f@iweiny-mobl.notmuch>
From: "yiyang (D)" <yiyang13@huawei.com>
Message-ID: <675e145f-499f-87ae-c735-fc4970ea9e20@huawei.com>
Date: Tue, 29 Oct 2024 10:10:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <671f9cee9a07f_23f01e2949f@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemk200016.china.huawei.com (7.202.194.82)


On 2024/10/28 22:17, Ira Weiny wrote:
> Yi Yang wrote:
>> It will cause null-ptr-deref when nd_dax_alloc() returns NULL, fix it by
>> add check for nd_dax_alloc().
> 
> Was this found with a real workload or just by inspection?
> 
> Ira
> 

I just found the problem by reading the code.

Regards,
Yiyang
>>
>> Fixes: c5ed9268643c ("libnvdimm, dax: autodetect support")
>> Signed-off-by: Yi Yang <yiyang13@huawei.com>
>> ---
>>   drivers/nvdimm/dax_devs.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
>> index 6b4922de3047..70a7e401f90d 100644
>> --- a/drivers/nvdimm/dax_devs.c
>> +++ b/drivers/nvdimm/dax_devs.c
>> @@ -106,6 +106,10 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>>   
>>   	nvdimm_bus_lock(&ndns->dev);
>>   	nd_dax = nd_dax_alloc(nd_region);
>> +	if (!nd_dax) {
>> +		nvdimm_bus_unlock(&ndns->dev);
>> +		return -ENOMEM;
>> +	}
>>   	nd_pfn = &nd_dax->nd_pfn;
>>   	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
>>   	nvdimm_bus_unlock(&ndns->dev);
>> -- 
>> 2.25.1
>>
>>
> 
> 
> 
> .
> 
