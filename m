Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D8213CFA6
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 01:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730167046; cv=none; b=DVuXNWoYb8HttfAazj/Vuatbn+RabpkQRnyX7m3LwSn60f00mafniJ18GjRznFTMZJtK8LRjfkDs0QQg3fr9jubLhH2gUCpr3O9XfBHKHHOK4vYtmeqJTKGolyG9WYs+h8R53ztEUJ+McQu39ho75Jg0zig+rk1XQ7ubm05pgWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730167046; c=relaxed/simple;
	bh=yQKSTOTK21IgwBphq5xelilf/8XpmsGha18vwYTcsVA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=sdTCfyzkw338xr9ey1rA3SlhMbW8Y1nNPrgGaLjyn4YXE/cUCv5yPUJ6vsQGn1uEObL8GrZ6VLwDkDtKhGlgYYVrOVMcltmPDTH5gcL59IYqAtZ/Xh5fjeL08f55mw+qOg5pDGqExh0x7QAW4rFa6TLFEFYfWXxSaIHNnAhiSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XctdJ1mwdz2Df1k
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 09:55:48 +0800 (CST)
Received: from kwepemk200016.china.huawei.com (unknown [7.202.194.82])
	by mail.maildlp.com (Postfix) with ESMTPS id 95FAD1401F1
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 09:57:18 +0800 (CST)
Received: from [10.67.108.122] (10.67.108.122) by
 kwepemk200016.china.huawei.com (7.202.194.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 29 Oct 2024 09:57:18 +0800
Subject: Re: [PATCH] nvdimm: fix possible null-ptr-deref in nd_dax_probe()
To: Dan Williams <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <wangweiyang2@huawei.com>
References: <20241026010622.2641355-1-yiyang13@huawei.com>
 <671fbb33ee9ef_bc69d29447@dwillia2-xfh.jf.intel.com.notmuch>
From: "yiyang (D)" <yiyang13@huawei.com>
Message-ID: <289710c8-c500-21e7-debf-d71b15679d93@huawei.com>
Date: Tue, 29 Oct 2024 09:57:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <671fbb33ee9ef_bc69d29447@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemk200016.china.huawei.com (7.202.194.82)


On 2024/10/29 0:26, Dan Williams wrote:
> Yi Yang wrote:
>> It will cause null-ptr-deref when nd_dax_alloc() returns NULL, fix it by
>> add check for nd_dax_alloc().
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
> 
> No, this isn't a NULL pointer de-reference, but it is indeed
> unreasonably subtle.
> 
> If nd_dax is NULL, then nd_pfn is NULL because nd_dax is just a
> type-wrapper around nd_pfn.
> 
> When nd_pfn is NULL then nd_pfn_devinit will fail.
> 
> What I think this needs to make this clear is something like this:
> 
> ---
> 
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index 6b4922de3047..37b743acbb7b 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -106,12 +106,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>   
>   	nvdimm_bus_lock(&ndns->dev);
>   	nd_dax = nd_dax_alloc(nd_region);
> -	nd_pfn = &nd_dax->nd_pfn;
> -	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
> +	dax_dev = nd_dax_devinit(nd_dax, ndns);
>   	nvdimm_bus_unlock(&ndns->dev);
>   	if (!dax_dev)
>   		return -ENOMEM;
>   	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	nd_pfn = &nd_dax->nd_pfn;
>   	nd_pfn->pfn_sb = pfn_sb;
>   	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
>   	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 2dbb1dca17b5..5ca06e9a2d29 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -600,6 +600,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
>   int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
>   bool is_nd_dax(const struct device *dev);
>   struct device *nd_dax_create(struct nd_region *nd_region);
> +static inline struct device *nd_dax_devinit(struct nd_dax *nd_dax,
> +					    struct nd_namespace_common *ndns)
> +{
> +	if (!nd_dax)
> +		return NULL;
> +	return nd_pfn_devinit(&nd_dax->nd_pfn, ndns);
> +}
>   #else
>   static inline int nd_dax_probe(struct device *dev,
>   		struct nd_namespace_common *ndns)
> 
> .
> 

LGTM,.
Your code is better.

Best regards,
Yiyang

-- 

