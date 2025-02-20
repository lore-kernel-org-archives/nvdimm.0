Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDEA8488
	for <nvdimm@lists.linux.dev>; Thu, 20 Feb 2025 05:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740027956; cv=none; b=gUjEH3k6RFaFDZqlCUkTUvr/DvKghxPW+LaSQR0Nh6izLYR/8OEChyAgbjVoMLraHG7EHA/CAViDhJvOEYjBl9bA/67Gv/dYkxXzVYSJ8kJWhXrhhYSBt7A3JqrvR1l4bPXuTj8kb4izHLEVw0/pcBuGpNOQEHLD84Yi3gw29Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740027956; c=relaxed/simple;
	bh=me2wlBZokS2lJdfdzkF0naNrcnUGGpgLGv6ViKpHTqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=svxoNldUv5DF/INMadPXS1S32zgmtnZWjs8zkQr1Z/8zatxXRru/KircJ7W6w5KEOsxt2J+XVUGEhN4Cym32Ujhl3R598w9FhfqtPWpx4Obwikz3IK7eVp5sYwo/RKmHSXeY8Wqd47yJwV8MGPjGAalxbgGKFZtI8Mt33x/A6hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ap/JTq2/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ap/JTq2/"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JNr6rg022236;
	Thu, 20 Feb 2025 05:05:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DKA3gW
	yp6j0xehF8IDp31eW3i/PhGjdOqTi9pDRccLU=; b=ap/JTq2/eWlaH2IUV506Uz
	RSnxSrYwxgjuCPUfLlvIoGtfLh8h0wbWTHX89R3lCHWo5yneSdSK1SFoY90JPu0H
	N8rY/XLN3uwEafp7iZ3lW9HaWuZ4OxpJmD3GSXniXdq0UdzaceHJd5uNOi+x7qlw
	Gz7njTc3CEncyxllhohmzPsSl5emS5cuzxJLiL7TCbqY5r1RT7VlNkyz9h5znUCx
	slClbCZZ1PIst43lWs7J8lk17s0HQSbHmkGUkR9LQOKbCQB5xxOeJPQbP5cd7Ilq
	R9CKggwxBE+VXf+0RyZyYUSnsMv9KEShtT+tpV9ejdn8tLLfEAFgvFEwDuVki6zg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44wahjwtcm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 05:05:50 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51K50tCH010071;
	Thu, 20 Feb 2025 05:05:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44wahjwtcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 05:05:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51K4dOjQ005817;
	Thu, 20 Feb 2025 05:05:49 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44w02xg38m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 05:05:49 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51K55mwa25887410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 05:05:48 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C6D458052;
	Thu, 20 Feb 2025 05:05:48 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE55458050;
	Thu, 20 Feb 2025 05:05:45 +0000 (GMT)
Received: from [9.109.211.20] (unknown [9.109.211.20])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Feb 2025 05:05:45 +0000 (GMT)
Message-ID: <60b8ee2a-a3c5-4904-bdb0-a0e2ebef5ff2@linux.ibm.com>
Date: Thu, 20 Feb 2025 10:35:42 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ndctl: json: Region capabilities are not displayed if any
 of the BTT, PFN, or DAX are not present
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Li Zhijian <lizhijian@fujitsu.com>, Jeff Moyer <jmoyer@redhat.com>
References: <20250219094049.5156-1-donettom@linux.ibm.com>
 <Z7YQnXuIMcw-wPMg@aschofie-mobl2.lan>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <Z7YQnXuIMcw-wPMg@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a48eF_mVPlKoaADzhnSugVCS65bKGL6_
X-Proofpoint-ORIG-GUID: fHy3ClR393h_24Gc8t2eWfV9-QGgzpz0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_11,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502200032


On 2/19/25 22:40, Alison Schofield wrote:
> On Wed, Feb 19, 2025 at 03:40:49AM -0600, Donet Tom wrote:
>
>
> Thanks Tom!
>
> Please v2 with patch prefix and commit msg of:
> [ndctl PATCH v2] ndctl/list: display region caps for any of BTT, PFN, DAX
Sure.
>
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
> Please add a formatted fixes tag.
> Double check, but I believe this was introduced with commit 965fa02e372f,
> util: Distribute 'filter' and 'json' helpers to per-tool objects
> It seems we broke it in ndctl release v73.
Sure. I will add.
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
> How about a one line change that avoids getting the jcaps array
> needlessly:
>
> 	if (!btt && !pfn && !dax)
> 		return NULL;
Yes . This is the correct fix. I will add it and send V2.
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
>> -- 
>> 2.43.5
>>
