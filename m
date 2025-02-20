Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0B219007D
	for <nvdimm@lists.linux.dev>; Thu, 20 Feb 2025 05:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740028037; cv=none; b=iHlVUO0QeMEnB8TRb3r3buSgCKBpIBcqdkMAgjojH6Ha9OIKNYC6CvChZeopTsQnFB8rX4a+X9gPhDerHR/4TKBnbuXqjy+eUCf3GZBtEMPwhcBJmHXCfgUAa8cNUlCb6jtnrqI42T7vzOznDJhl6OOaZ+VqCoPLoDHAkFyhT1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740028037; c=relaxed/simple;
	bh=+zGT9HMfLBKh3wm+v5YZoofF1vQky54kXeBcJo25lKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ElcujYyimIWNXcNvhYdH9vEvcciclADPzquYAYR46jP7kfZ2XFeRUfUBQxuaWXT2H9+EPvfY/KewA3spyWEK2DPDM6WvEH6WnUBSw5vGjEHjIKjwqet9hOdiC3w7vlDdQupP4bUGG8+hJpGxU71idaIcVg98AhjVy1q4y3dJJf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gEOn0vJW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gEOn0vJW"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51K20aGH022914;
	Thu, 20 Feb 2025 05:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rFJU0Q
	zHYdII9CLhrJj36qLKvQhtQdbRpo+DZAgAMrI=; b=gEOn0vJW9sclpRhE9BXC2G
	e2FOCEVS7noyzQ4JR0q2KFpSQlE3ayEsWJj8RNuHFsHVmfwoVh3PSPixRut0Va1p
	aRFV1SWnF+4HIrDhYLXCvbJU5rPiH28DmDFn29677v/ufpA/UIzbBgycHAWNIufP
	KGdR322K2ggGUH/WPb/UAWBE7zj7yLtI+is6TFI2EJJM58ipvHtiHp4DMv8t6Nqe
	+JDOCQ8kJXoiR2env8VKNjYLh+tZQRQvQqTFhTxvZd2Cs/m7eip/zBCbdvwj+xHr
	JEhOLb5+VfIaGfljun/V4mqQBKr2peItbZ2Zk7BU1bmAteQ6l5xHQoT+qRVsFnKA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44wu808msa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 05:07:11 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51K56uw7001240;
	Thu, 20 Feb 2025 05:07:11 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44wu808ms8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 05:07:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51K48bGK009772;
	Thu, 20 Feb 2025 05:07:09 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44w03y84vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 05:07:09 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51K578mM32047806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 05:07:08 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62C0E58052;
	Thu, 20 Feb 2025 05:07:08 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22C9058045;
	Thu, 20 Feb 2025 05:07:06 +0000 (GMT)
Received: from [9.109.211.20] (unknown [9.109.211.20])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Feb 2025 05:07:05 +0000 (GMT)
Message-ID: <e2379e35-68cc-4f39-b16b-4c605c753f7d@linux.ibm.com>
Date: Thu, 20 Feb 2025 10:37:04 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ndctl: json: Region capabilities are not displayed if any
 of the BTT, PFN, or DAX are not present
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20250219094049.5156-1-donettom@linux.ibm.com>
 <x494j0pj3ar.fsf@segfault.usersys.redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <x494j0pj3ar.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7yQ3eL-WICp1Z_u1zDBE9-FGi7I9sumK
X-Proofpoint-ORIG-GUID: BrIPKKV2bf4jbXBN4MFA1bPfPUMAhMLV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_11,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502200032


On 2/19/25 22:10, Jeff Moyer wrote:
> Donet Tom <donettom@linux.ibm.com> writes:
>
>> If any one of BTT, PFN, or DAX is not present, but the other two
>> are, then the region capabilities are not displayed in the
>> ndctl list -R -C command.
>>
>> This is because util_region_capabilities_to_json() returns NULL
>> if any one of BTT, PFN, or DAX is not present.
>>
>> In this patch, we have changed the logic to display all the region
>> capabilities that are present.
>>
>> Test Results with CONFIG_BTT disabled
>> =====================================
>> Without this patch
>> ------------------
>>   # ./build/ndctl/ndctl  list -R -C
>>   [
>>    {
>>      "dev":"region1",
>>      "size":549755813888,
>>      "align":16777216,
>>      "available_size":549755813888,
>>      "max_available_extent":549755813888,
>>      "type":"pmem",
>>      "iset_id":11510624209454722969,
>>      "persistence_domain":"memory_controller"
>>    },
>>
>> With this patch
>> ---------------
>>   # ./build/ndctl/ndctl  list -R -C
>>   [
>>    {
>>      "dev":"region1",
>>      "size":549755813888,
>>      "align":16777216,
>>      "available_size":549755813888,
>>      "max_available_extent":549755813888,
>>      "type":"pmem",
>>      "iset_id":11510624209454722969,
>>      "capabilities":[
>>        {
>>          "mode":"fsdax",
>>          "alignments":[
>>            65536,
>>            16777216
>>          ]
>>        },
>>        {
>>          "mode":"devdax",
>>          "alignments":[
>>            65536,
>>            16777216
>>          ]
>>        }
>>      ],
>>      "persistence_domain":"memory_controller"
>>    },
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   ndctl/json.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/ndctl/json.c b/ndctl/json.c
>> index 23bad7f..3df3bc4 100644
>> --- a/ndctl/json.c
>> +++ b/ndctl/json.c
>> @@ -381,9 +381,6 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>>   	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
>>   	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
>>   
>> -	if (!btt || !pfn || !dax)
>> -		return NULL;
>> -
> I think this was meant to be:
>
> 	if (!btt && !pfn && !dax)
> 		return NULL;
>
> I think that would be the more appropriate fix.
Yes. I will add it and send V2.
>
> Cheers,
> Jeff
>
>>   	jcaps = json_object_new_array();
>>   	if (!jcaps)
>>   		return NULL;
>> @@ -436,7 +433,8 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>>   		json_object_object_add(jcap, "alignments", jobj);
>>   	}
>>   
>> -	return jcaps;
>> +	if (btt || pfn || dax)
>> +		return jcaps;
>>   err:
>>   	json_object_put(jcaps);
>>   	return NULL;
