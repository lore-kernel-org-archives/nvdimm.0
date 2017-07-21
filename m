Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E9CAF2095D9CA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 12:24:35 -0700 (PDT)
Subject: Re: [ndctl PATCH] ndctl, list: always show 'name' if it is available
References: <150066239948.20775.13756890159711008729.stgit@dwillia2-desk3.amr.corp.intel.com>
 <2d2a6fc2-e497-4dd6-a3c4-d8b905cc9240@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <83b4c87e-655f-aeed-460a-8abf9ec30613@intel.com>
Date: Fri, 21 Jul 2017 12:26:22 -0700
MIME-Version: 1.0
In-Reply-To: <2d2a6fc2-e497-4dd6-a3c4-d8b905cc9240@hpe.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linda Knippers <linda.knippers@hpe.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 07/21/2017 12:15 PM, Linda Knippers wrote:
> 
> 
> On 07/21/2017 02:39 PM, Dan Williams wrote:
>> The user-friendly name of a namespace should always be emitted.
> 
> Thanks!
> 
> When running your master branch I was getting this:
> 
>   {
>     "dev":"namespace1.12",
>     "mode":"memory",
>     "size":10567548928,
>     "uuid":"aee879c1-4da9-4ea4-98d9-d2afa0ef294a",
>     "blockdev":"pmem1.12"
>   },
> 
> and now after applying this patch, along with your previous
> dax chardev patch set, to your pending branch, I get this:
> 
>   {
>     "dev":"namespace1.12",
>     "mode":"memory",
>     "size":10567548928,
>     "uuid":"aee879c1-4da9-4ea4-98d9-d2afa0ef294a",
>     "blockdev":"pmem1.12",
>     "name":"number9",
>     "numa_node":0,
>     "badblock_count":24815632
>   },
> 
> The name is there but I'm also seeing a badblock_count. I don't
> see the badblock_count if I build your master branch, but I don't
> see anything here that would cause it to appear.  Still looking
> if I missed something...

You have this commit right?
076e4f77db5fbabb2bc1d179919f6792f350d49e ndctl: fix uninitialized
bb_count in list command

> 
> -- ljk
>>
>> Reported-by: Linda Knippers <linda.knippers@hpe.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  util/json.c |   21 +++++++++------------
>>  1 file changed, 9 insertions(+), 12 deletions(-)
>>
>> diff --git a/util/json.c b/util/json.c
>> index 559a022ae405..2b2b5af16504 100644
>> --- a/util/json.c
>> +++ b/util/json.c
>> @@ -558,7 +558,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>>  	struct json_object *jobj, *jbbs = NULL;
>>  	unsigned long long size = ULLONG_MAX;
>>  	enum ndctl_namespace_mode mode;
>> -	const char *bdev = NULL;
>> +	const char *bdev = NULL, *name;
>>  	unsigned int bb_count;
>>  	struct ndctl_btt *btt;
>>  	struct ndctl_pfn *pfn;
>> @@ -654,7 +654,6 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>>  				json_object_object_add(jndns, "daxregion", jobj);
>>  		} else if (dax_region) {
>>  			struct daxctl_dev *dev;
>> -			const char *name;
>>  
>>  			dev = daxctl_dev_get_first(dax_region);
>>  			name = daxctl_dev_get_devname(dev);
>> @@ -664,22 +663,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>>  			json_object_object_add(jndns, "chardev", jobj);
>>  		}
>>  	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
>> -		const char *name;
>> -
>>  		ndctl_namespace_get_uuid(ndns, uuid);
>>  		uuid_unparse(uuid, buf);
>>  		jobj = json_object_new_string(buf);
>>  		if (!jobj)
>>  			goto err;
>>  		json_object_object_add(jndns, "uuid", jobj);
>> -
>> -		name = ndctl_namespace_get_alt_name(ndns);
>> -		if (name[0]) {
>> -			jobj = json_object_new_string(name);
>> -			if (!jobj)
>> -				goto err;
>> -			json_object_object_add(jndns, "name", jobj);
>> -		}
>>  		bdev = ndctl_namespace_get_block_device(ndns);
>>  	} else
>>  		bdev = ndctl_namespace_get_block_device(ndns);
>> @@ -698,6 +687,14 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>>  		json_object_object_add(jndns, "state", jobj);
>>  	}
>>  
>> +	name = ndctl_namespace_get_alt_name(ndns);
>> +	if (name && name[0]) {
>> +		jobj = json_object_new_string(name);
>> +		if (!jobj)
>> +			goto err;
>> +		json_object_object_add(jndns, "name", jobj);
>> +	}
>> +
>>  	numa = ndctl_namespace_get_numa_node(ndns);
>>  	if (numa >= 0) {
>>  		jobj = json_object_new_int(numa);
>>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
