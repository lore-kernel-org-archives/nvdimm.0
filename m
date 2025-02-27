Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B849217668
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 06:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740636872; cv=none; b=WZ9VbFjQaz6sg5S9U/bU2M1B0Y0FYMI6sOPVFcP3ZdzWd+3qjT3kTlALcvMsFPwmCtFCVTSKLzChTB2BtJut7CkzTilz2dZ0JBqG0EhHcCQxkjr8ffLeC5DNHHw+LRBGaeqOzMNCw5hDzZi0vOFhqIaBbTdaQJNLkLcTq+fj0IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740636872; c=relaxed/simple;
	bh=n3IW3rgTRU/z88cGxNJpDxyDTMotV6ebg+Hmt3yvmlI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EYUOD3EVnIDOFmsBxV1IQ9kgmcjNNcna4eydB8shRVWQWQRudkO29gkY277qPS8OHTr1+Ah9xvs9YaCsoawUizhbp9578Ha+HaSUfEYCDvlM7ipQW0MK/flqqaEqTUkIBfuYvV5bqsYig807iMosNCvNxB3bFhI6ysGhERfLYas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZiIzV8Yr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZiIzV8Yr"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R5O0vE019699;
	Thu, 27 Feb 2025 06:14:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wEkq2+
	JwOpj8+0rjQtyfBmpqgDEWLm1nSYiuGkbpClE=; b=ZiIzV8Yrj08y89+hvrAUL+
	S3fwP5QckSNMXsvYRp/xOSHohdBJBDknHnLIQHHJJrlKiNzBtjnFMMs0rx3H4xTI
	u6B3aHeRFB+SrxljdqMIAlSVm3fB8V9WdOChVeO7tOqtvaX8fjt9lKZbEsqCnJ3c
	MIzB8NQ/cdXhNAgAWoiMqF1UpCvVQDSL5ue+fwB9Bto7R8yYpjMW6UOAlGuqkRJ8
	W/Lk30HXG7GihaRoqTkECKAnsTLlBOtEuenYDKfiKlL0+sakFkPyzgip2bjtK01E
	sL1iA+vjDmhDfwXBX8vuC570XAzKXfWsfH7Z74+fZ1P9oTUlr2Y1t7Py/YVkAcmw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452hv8r5rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 06:14:29 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51R6ETCt027472;
	Thu, 27 Feb 2025 06:14:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452hv8r5re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 06:14:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51R33pSN002545;
	Thu, 27 Feb 2025 06:14:28 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yu4jxq85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 06:14:28 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51R6ERFu28574252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 06:14:27 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA21F5805E;
	Thu, 27 Feb 2025 06:14:27 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95CEC5805C;
	Thu, 27 Feb 2025 06:14:25 +0000 (GMT)
Received: from [9.124.214.50] (unknown [9.124.214.50])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Feb 2025 06:14:25 +0000 (GMT)
Message-ID: <3483e769-c8ac-4ffb-a49e-dd14bccb92d4@linux.ibm.com>
Date: Thu, 27 Feb 2025 11:44:23 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
To: Alison Schofield <alison.schofield@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Donet Tom <donettom@linux.vnet.ibm.com>,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
References: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
 <x49y0y0oi1g.fsf@segfault.usersys.redhat.com>
 <6f43cf6e-a3b7-4746-be15-d354cc6dd699@linux.ibm.com>
 <Z79u2ZEkbO5DNnMC@aschofie-mobl2.lan>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <Z79u2ZEkbO5DNnMC@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YBBj3OAwWuvtQMZaimvjkhd4bT7wKE9C
X-Proofpoint-GUID: pLKRTG9qm8UVKmMTUeX2a4pNmecSTh18
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_03,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=975 priorityscore=1501 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2502100000
 definitions=main-2502270044


On 2/27/25 01:13, Alison Schofield wrote:
> On Wed, Feb 26, 2025 at 11:32:30AM +0530, Donet Tom wrote:
>> On 2/20/25 19:05, Jeff Moyer wrote:
>>>> diff --git a/ndctl/json.c b/ndctl/json.c
>>>> index 23bad7f..7646882 100644
>>>> --- a/ndctl/json.c
>>>> +++ b/ndctl/json.c
>>>> @@ -381,7 +381,7 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>>>>    	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
>>>>    	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
>>>> -	if (!btt || !pfn || !dax)
>>>> +	if (!btt && !pfn && !dax)
>>>>    		return NULL;
>>>>    	jcaps = json_object_new_array();
>>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>>>
>> Thanks Jeff
>>
>>
>> Hi Alison
>>
>> Should I send a v3 with Reviewed-by tag or will you take the patch with the
>> tag?
> No need. The tags with gather automagically upon applying.
> I'll also rm the text meant for below the --- like Zhijian noted.


Thank you.


>
> Thanks for the patch!
>
>
>> Thanks
>> Donet
>>
