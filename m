Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967F0A920
	for <nvdimm@lists.linux.dev>; Sat,  5 Aug 2023 10:58:05 +0000 (UTC)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 375Aop6S023542;
	Sat, 5 Aug 2023 10:57:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WEKj0J25C7s64pNt0TPYGUvhYDI8HHD3UegrQrjxbks=;
 b=qbzE4ZWg19trFNq+RJoxnIEYZxXgC4AwQaUn1mtmkr7h1QeJ51RSP6jEyXUwgrvinj30
 GNeNzMSX1SPp+FuS9MSomXivNEc3x8H35cPwn043DpTMY/Ve9bNwggd+qy9B2EzSpfis
 iGdJtJtxtYzswD+aMB7pFS1bxITVbkVbQBxxCKIk/MJFkXaZAABHfnvmv7rkqJ9X9xsm
 Tkcm7gTDwA23OdHDZtyrC7Z7QAv1Jur77unZawlRlkhpy073V5eYvtD7OTBHO4nBRsMc
 kvCD/dG7NQb4If4IuI6SCmuKE+OSRFhzew0sPqWuRVt8lt5KzM7STo2gIThBBOhCPHd9 bg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s9mqug9m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 05 Aug 2023 10:57:58 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 375AvvES011088;
	Sat, 5 Aug 2023 10:57:57 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s9mqug9kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 05 Aug 2023 10:57:57 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3759dbru027809;
	Sat, 5 Aug 2023 10:57:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s8kp35k6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 05 Aug 2023 10:57:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 375Avs8a37618016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 5 Aug 2023 10:57:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 573CB20043;
	Sat,  5 Aug 2023 10:57:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71C8B20040;
	Sat,  5 Aug 2023 10:57:53 +0000 (GMT)
Received: from [9.43.27.99] (unknown [9.43.27.99])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat,  5 Aug 2023 10:57:53 +0000 (GMT)
Message-ID: <51a193f7-f7cb-fc65-1761-1551ecc67159@linux.ibm.com>
Date: Sat, 5 Aug 2023 16:27:52 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] nvdimm/pfn_dev: Prevent the creation of zero-sized
 namespaces
To: Jeff Moyer <jmoyer@redhat.com>
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
References: <20230804084934.171056-1-aneesh.kumar@linux.ibm.com>
 <x49bkfmu2a4.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
From: Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
In-Reply-To: <x49bkfmu2a4.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1lpy-grkQkynUrjAghzysVE6znNhMFiW
X-Proofpoint-ORIG-GUID: Uc6xLgeS1TI6dA0iaFsvAZZsZGZS5fZ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-05_09,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308050099

On 8/4/23 11:18 PM, Jeff Moyer wrote:
> Hi, Aneesh,
> 
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
> 
>> On architectures that have different page size values used for kernel
>> direct mapping and userspace mappings, the user can end up creating zero-sized
>> namespaces as shown below
>>
>> :/sys/bus/nd/devices/region1# cat align
>> 0x1000000
>> /sys/bus/nd/devices/region1# echo 0x200000 > align
>> /sys/bus/nd/devices/region1/dax1.0# cat supported_alignments
>> 65536 16777216
>>  $ ndctl create-namespace -r region1 -m devdax -s 18M --align 64K
>> {
>>   "dev":"namespace1.0",
>>   "mode":"devdax",
>>   "map":"dev",
>>   "size":0,
>>   "uuid":"3094329a-0c66-4905-847e-357223e56ab0",
>>   "daxregion":{
>>     "id":1,
>>     "size":0,
>>     "align":65536
>>   },
>>   "align":65536
>> }
>> similarily for fsdax
>>
>>  $ ndctl create-namespace -r region1 -m fsdax  -s 18M --align 64K
>> {
>>   "dev":"namespace1.0",
>>   "mode":"fsdax",
>>   "map":"dev",
>>   "size":0,
>>   "uuid":"45538a6f-dec7-405d-b1da-2a4075e06232",
>>   "sector_size":512,
>>   "align":65536,
>>   "blockdev":"pmem1"
>> }
> 
> Just curious, but have you seen this in practice?  It seems like an odd
> thing to do.
> 

This was identified while writing new test cases for region alignment update.


>> In commit 9ffc1d19fc4a ("mm/memremap_pages: Introduce memremap_compat_align()")
>> memremap_compat_align was added to make sure the kernel always creates
>> namespaces with 16MB alignment. But the user can still override the
>> region alignment and no input validation is done in the region alignment
>> values to retain the flexibility user had before. However, the kernel
>> ensures that only part of the namespace that can be mapped via kernel
>> direct mapping page size is enabled. This is achieved by tracking the
>> unmapped part of the namespace in pfn_sb->end_trunc. The kernel also
>> ensures that the start address of the namespace is also aligned to the
>> kernel direct mapping page size.
>>
>> Depending on the user request, the kernel implements userspace mapping
>> alignment by updating pfn device alignment attribute and this value is
>> used to adjust the start address for userspace mappings. This is tracked
>> in pfn_sb->dataoff. Hence the available size for userspace mapping is:
>>
>> usermapping_size = size of the namespace - pfn_sb->end_trun - pfn_sb->dataoff
>>
>> If the kernel finds the user mapping size zero then don't allow the
>> creation of namespace.
>>
>> After fix:
>> $ ndctl create-namespace -f  -r region1 -m devdax  -s 18M --align 64K
>> libndctl: ndctl_dax_enable: dax1.1: failed to enable
>>   Error: namespace1.2: failed to enable
>>
>> failed to create namespace: No such device or address
>>
>> And existing zero sized namespace will be marked disabled.
>> root@ltczz75-lp2:/home/kvaneesh# ndctl  list -N -r region1 -i
>> [
>>   {
>>     "dev":"namespace1.0",
>>     "mode":"raw",
>>     "size":18874368,
>>     "uuid":"94a90fb0-8e78-4fb6-a759-ffc62f9fa181",
>>     "sector_size":512,
>>     "state":"disabled"
>>   },
> 
> Thank you for providing examples of the command output before and after
> the change.  I appreciate that.
> 
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>  drivers/nvdimm/pfn_devs.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
>> index af7d9301520c..36b904a129b9 100644
>> --- a/drivers/nvdimm/pfn_devs.c
>> +++ b/drivers/nvdimm/pfn_devs.c
>> @@ -453,7 +453,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>>  	struct resource *res;
>>  	enum nd_pfn_mode mode;
>>  	struct nd_namespace_io *nsio;
>> -	unsigned long align, start_pad;
>> +	unsigned long align, start_pad, end_trunc;
>>  	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
>>  	struct nd_namespace_common *ndns = nd_pfn->ndns;
>>  	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
>> @@ -503,6 +503,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>>  	align = le32_to_cpu(pfn_sb->align);
>>  	offset = le64_to_cpu(pfn_sb->dataoff);
>>  	start_pad = le32_to_cpu(pfn_sb->start_pad);
>> +	end_trunc = le32_to_cpu(pfn_sb->end_trunc);
>>  	if (align == 0)
>>  		align = 1UL << ilog2(offset);
>>  	mode = le32_to_cpu(pfn_sb->mode);
>> @@ -610,6 +611,10 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>>  		return -EOPNOTSUPP;
>>  	}
>>  
>> +	if (offset >= (res->end - res->start + 1 - start_pad - end_trunc)) {
>                        ^^^^^^^^^^^^^^^^^^^^^^^^^ That's what
> resource_size(res) does.  It might be better to create a local variable
> 'size' to hold that, as there are now two instances of that in the
> function.


Will update. 

> 
>> +		dev_err(&nd_pfn->dev, "bad offset with small namespace\n");
>> +		return -EOPNOTSUPP;
>> +	}
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(nd_pfn_validate);
>> @@ -810,7 +815,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>>  	else
>>  		return -ENXIO;
>>  
>> -	if (offset >= size) {
>> +	if (offset >= (size - end_trunc)) {
>> +		/* This implies we result in zero size devices */
>>  		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
>>  				dev_name(&ndns->dev));
>>  		return -ENXIO;
> 
> Functionally, this looks good to me.
> 
> Cheers,
> Jeff
> 

Thanks for reviewing the patch.
-aneesh
