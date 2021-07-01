Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBDF72
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 03:23:36 +0000 (UTC)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GFk1X1lbyzXn1c
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 11:18:08 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 11:23:26 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 1 Jul
 2021 11:23:26 +0800
Subject: Re: [ndctl PATCH 1/2] libndctl: check return value of
 ndctl_pfn_get_namespace
To: Alison Schofield <alison.schofield@intel.com>
CC: <vishal.l.verma@intel.com>, <nvdimm@lists.linux.dev>,
	<linfeilong@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>
References: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
 <b899e8ba-560c-88e6-3b49-2bdf14eab150@huawei.com>
 <20210630174125.GA25123@alison-desk.jf.intel.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <f2132c83-4c95-2847-4125-62043d16f499@huawei.com>
Date: Thu, 1 Jul 2021 11:23:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210630174125.GA25123@alison-desk.jf.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected


On 2021/7/1 1:41, Alison Schofield wrote:
> On Tue, Jun 15, 2021 at 08:38:33PM +0800, Zhiqiang Liu wrote:
>> ndctl_pfn_get_namespace() may return NULL, so callers
>> should check return value of it. Otherwise, it may
>> cause access NULL pointer problem.
>>
> Hi Zhiqiang,
>
> I see you mentioned this was found by Coverity in the cover letter.
> Please repeat that in the commit log here.
>
> What about the call path:
> ndctl_dax_get_namespace() --> ndctl_pfn_get_namespace()
>
> Seems like another place where ndctl_pfn_get_namespace() could
> eventually lead to a NULL ptr dereference.
>
> Alison

Thanks for your reply.

Call path:

namespace_clear_bb

 -> if (dax) dax_clear_badblocks(dax)

     ->ndctl_dax_get_namespace(dax)

        ->ndctl_pfn_get_namespace(&dax->pfn)

            ->ndctl_pfn_get_ctx(pfn)


struct ndctl_dax {
    struct ndctl_pfn pfn;
    struct daxctl_region *region;
};

Here, we have checked that dax is not NULL before calling ndctl_dax_get_namespace(dax).

If dax is not a NULL pointer, the dax->pfn will not be a NULL pointer.

As for ndctl_pfn_get_ctx(pfn), it will access pfn->region->bus without NULL-checking, which

may lead to a NULL ptr dereference as you said. I will correct it in the v2 patch.


Regards,

Zhiqiang Liu

>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> ---
>>  ndctl/namespace.c | 18 ++++++++++++++----
>>  test/libndctl.c   |  4 ++--
>>  util/json.c       |  2 ++
>>  3 files changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
>> index 0c8df9f..21089d7 100644
>> --- a/ndctl/namespace.c
>> +++ b/ndctl/namespace.c
>> @@ -1417,11 +1417,16 @@ static int nstype_clear_badblocks(struct ndctl_namespace *ndns,
>>
>>  static int dax_clear_badblocks(struct ndctl_dax *dax)
>>  {
>> -	struct ndctl_namespace *ndns = ndctl_dax_get_namespace(dax);
>> -	const char *devname = ndctl_dax_get_devname(dax);
>> +	struct ndctl_namespace *ndns;
>> +	const char *devname;
>>  	unsigned long long begin, size;
>>  	int rc;
>>
>> +	ndns = ndctl_dax_get_namespace(dax);
>> +	if (!ndns)
>> +		return -ENXIO;
>> +
>> +	devname = ndctl_dax_get_devname(dax);
>>  	begin = ndctl_dax_get_resource(dax);
>>  	if (begin == ULLONG_MAX)
>>  		return -ENXIO;
>> @@ -1441,11 +1446,16 @@ static int dax_clear_badblocks(struct ndctl_dax *dax)
>>
>>  static int pfn_clear_badblocks(struct ndctl_pfn *pfn)
>>  {
>> -	struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
>> -	const char *devname = ndctl_pfn_get_devname(pfn);
>> +	struct ndctl_namespace *ndns;
>> +	const char *devname;
>>  	unsigned long long begin, size;
>>  	int rc;
>>
>> +	ndns = ndctl_pfn_get_namespace(pfn);
>> +	if (!ndns)
>> +		return -ENXIO;
>> +
>> +	devname = ndctl_pfn_get_devname(pfn);
>>  	begin = ndctl_pfn_get_resource(pfn);
>>  	if (begin == ULLONG_MAX)
>>  		return -ENXIO;
>> diff --git a/test/libndctl.c b/test/libndctl.c
>> index 24d72b3..05e5ff2 100644
>> --- a/test/libndctl.c
>> +++ b/test/libndctl.c
>> @@ -1275,7 +1275,7 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
>>  		if (!ndctl_pfn_is_enabled(pfn))
>>  			continue;
>>  		pfn_ndns = ndctl_pfn_get_namespace(pfn);
>> -		if (strcmp(ndctl_namespace_get_devname(pfn_ndns), devname) != 0)
>> +		if (!pfn_ndns || strcmp(ndctl_namespace_get_devname(pfn_ndns), devname) != 0)
>>  			continue;
>>  		fprintf(stderr, "%s: pfn_ndns: %p ndns: %p\n", __func__,
>>  				pfn_ndns, ndns);
>> @@ -1372,7 +1372,7 @@ static int check_dax_autodetect(struct ndctl_bus *bus,
>>  		if (!ndctl_dax_is_enabled(dax))
>>  			continue;
>>  		dax_ndns = ndctl_dax_get_namespace(dax);
>> -		if (strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
>> +		if (!dax_ndns || strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
>>  			continue;
>>  		fprintf(stderr, "%s: dax_ndns: %p ndns: %p\n", __func__,
>>  				dax_ndns, ndns);
>> diff --git a/util/json.c b/util/json.c
>> index ca0167b..249f021 100644
>> --- a/util/json.c
>> +++ b/util/json.c
>> @@ -1002,6 +1002,8 @@ static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
>>  	pfn_begin = ndctl_pfn_get_resource(pfn);
>>  	if (pfn_begin == ULLONG_MAX) {
>>  		struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
>> +		if (!ndns)
>> +			return NULL;
>>
>>  		return util_namespace_badblocks_to_json(ndns, bb_count, flags);
>>  	}
>> -- 
>> 2.23.0
>>
>>
>>
>>
>> .
>>
>>
>>
> .

