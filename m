Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 106AD2128D875
 for <linux-nvdimm@lists.01.org>; Tue, 23 Jul 2019 08:02:51 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x6NEsnXE133905
 for <linux-nvdimm@lists.01.org>; Tue, 23 Jul 2019 11:00:24 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2tx2vdd1u5-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 23 Jul 2019 11:00:23 -0400
Received: from localhost
 by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 23 Jul 2019 16:00:16 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: Picking 0th namespace if it is idle
In-Reply-To: <877ea85p64.fsf@linux.ibm.com>
References: <87a7f45qik.fsf@linux.ibm.com> <877ea85p64.fsf@linux.ibm.com>
Date: Tue, 23 Jul 2019 20:30:09 +0530
MIME-Version: 1.0
Message-Id: <8736iwkd8m.fsf@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

Can you help with this question?

-aneesh

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com> writes:

> aneesh.kumar@linux.ibm.com (Aneesh Kumar K.V) writes:
>
>> Hi Dan,
>>
>> With the patch series to mark the namespace disabled if we have mismatch
>> in pfn superblock, we can endup with namespace0 marked idle/disabled.
>>
>> I am wondering why do do the below in ndctl.
>>
>>
>> static struct ndctl_namespace *region_get_namespace(struct ndctl_region *region)
>> {
>> 	struct ndctl_namespace *ndns;
>>
>> 	/* prefer the 0th namespace if it is idle */
>> 	ndctl_namespace_foreach(region, ndns)
>> 		if (ndctl_namespace_get_id(ndns) == 0
>> 				&& !is_namespace_active(ndns))
>> 			return ndns;
>> 	return ndctl_region_get_namespace_seed(region);
>> }
>>
>> I have a kernel patch that will create a namespace_seed even if we fail
>> to ename a pfn backing device. Something like below
>>  
>> @@ -747,12 +752,23 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
>>  		}
>>  	}
>>  	if (dev->parent && is_nd_region(dev->parent) && probe) {
>>  		nd_region = to_nd_region(dev->parent);
>>  		nvdimm_bus_lock(dev);
>>  		if (nd_region->ns_seed == dev)
>>  			nd_region_create_ns_seed(nd_region);
>>  		nvdimm_bus_unlock(dev);
>>  	}
>> +
>> +	if (dev->parent && is_nd_region(dev->parent) && !probe && (ret == -EOPNOTSUPP)) {
>> +		nd_region = to_nd_region(dev->parent);
>> +		nvdimm_bus_lock(dev);
>> +		if (nd_region->ns_seed == dev)
>> +			nd_region_create_ns_seed(nd_region);
>> +		nvdimm_bus_unlock(dev);
>> +	}
>> +
>>
>> With that we can end up with something like the below after boot.
>> :/sys/bus/nd/devices/region0$ sudo ndctl list -Ni        
>> [                                                                          
>>   {                                                                                                                                                    
>>     "dev":"namespace0.1",                                                  
>>     "mode":"fsdax",                                                        
>>     "map":"mem",                                                           
>>     "size":0,                                                              
>>     "uuid":"00000000-0000-0000-0000-000000000000",                                                                                                     
>>     "state":"disabled"                                                     
>>   },                                                                       
>>   {                                                                        
>>     "dev":"namespace0.0",                                                  
>>     "mode":"fsdax",                  
>>     "map":"mem",                                                           
>>     "size":2147483648,               
>>     "uuid":"094e703b-4bf8-4078-ad42-50bebc03e538",                                                                                                     
>>     "state":"disabled"                                                                                                                                 
>>   }                                                                        
>> ]                                             
>>
>> namespace0.0 is the one we failed to initialize due to PAGE_SIZE
>> mismatch. 
>>
>> We do have namespace_seed pointing to namespacece0.1 correct. But a ndtl
>> create-namespace will pick namespace0.0 even if we have seed file
>> pointing to namespacec0.1.
>>
>>
>> I am trying to resolve the issues related to creation of new namespaces
>> when we have some namespace marked disabled due to pfn_sb setting
>> mismatch.
>>
>> -aneesh
>
> With that ndctl namespace0.0 selection commented out, we do get pick the
> right idle namespace.
>
> #ndctl list -Ni
> [                         
>   {                
>     "dev":"namespace0.1",
>     "mode":"fsdax",                                                        
>     "map":"mem",      
>     "size":0,
>     "uuid":"00000000-0000-0000-0000-000000000000",
>     "state":"disabled"   
>   },               
>   {             
>     "dev":"namespace0.0",
>     "mode":"fsdax",                                                        
>     "map":"mem",  
>     "size":2147483648,   
>     "uuid":"0c31ae4b-b053-43c7-82ff-88574e2585b0",
>     "state":"disabled"
>   }  
> ]   
>
> after ndctl create-namespace -s 2G -r region0                   
>
>
> # ndctl list -Ni                                           
> [                     
>   {                    
>     "dev":"namespace0.2",
>     "mode":"fsdax",       
>     "map":"mem",   
>     "size":0,   
>     "uuid":"00000000-0000-0000-0000-000000000000",
>     "state":"disabled"
>   },
>   {
>     "dev":"namespace0.1",
>     "mode":"fsdax",
>     "map":"dev",
>     "size":2130706432,
>     "uuid":"60970059-9412-4eeb-9e7a-b314585a4da3",
>     "align":65536,
>     "blockdev":"pmem0.1",
>     "supported_alignments":[
>       65536
>     ]
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"fsdax",
>     "map":"mem",
>     "size":2147483648,
>     "uuid":"0c31ae4b-b053-43c7-82ff-88574e2585b0",
>     "state":"disabled"
>   }
> ]

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
