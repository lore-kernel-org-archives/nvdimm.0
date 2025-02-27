Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2D21A429
	for <nvdimm@lists.linux.dev>; Thu, 27 Feb 2025 06:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740636841; cv=none; b=LEYT6DBnseffo/rR3TeMvRJCbpQzPBdlt66GhjeSQwQXWPm99nOILXTFvGAlIJLK5S2wUzUavQIVpMgc8gsyB97ETjUdguvpIlRj/MThQo7nWQ/ngpghSVYr1oJLz8etXC4TztBpMWW+mfwDaK5yJLNuQ29y/uNkB6pRezlLKTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740636841; c=relaxed/simple;
	bh=X5gmS739t+HwLxsKWtIp0u53oJS62TO54IFMnYtooBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSeds2Sz0ssV2O55rXyXPyG/oAE4wzCKt9itJupVTv38qzy8l1jJnGdW1F4YGzsG6TKzFJW2sk4YnRusPyVTudACRHve3GCa6X3x5cNkG0sqANMImJXAYtJKSU9WyE349aWNiUBdGkNU7I8PixsIWHgNzZZbkLuaHc2JHBcM5+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bXuwYFml; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bXuwYFml"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R18Q42027956;
	Thu, 27 Feb 2025 06:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=E0chFZ
	S8id9N9i78myVHG1x372YST/rTZmtQ3FV6hno=; b=bXuwYFmlYro7pplDQdWsAv
	md8C3ZiRBphTKasdgjOajY2Eec8gSwG3NXx+wB/M/tZPdBxwoDnM2Ysy0zNbUhUa
	k+GRn0yF5YpjUH9MjhNRiMXy0X3KvBgETeCpXSnkY3yjvDODUmy8VfhizTWjPmNn
	PKgILjFJigL/TBu4283elSiIqIYJu5/LygHXArcrIiYjgF+XH+f659+QNgRir35/
	TdYQO1KhEg41EySE6OSBUJonDUVbhOiyxgGN6ocGKtoz9CxIpHSsMkJI+hChe3P0
	1992HrYYuJs4NJSlODuG05SqJhVTHr/j2AVxWE179TC4SqPXz/Bd+mtcaS5d3NVA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452e4a10kr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 06:13:50 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51R6DoaT027427;
	Thu, 27 Feb 2025 06:13:50 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 452e4a10kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 06:13:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51R3GN22027344;
	Thu, 27 Feb 2025 06:13:49 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yum26kpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 06:13:49 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51R6DmUR32178730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 06:13:48 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B85535805C;
	Thu, 27 Feb 2025 06:13:48 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7909058051;
	Thu, 27 Feb 2025 06:13:46 +0000 (GMT)
Received: from [9.124.214.50] (unknown [9.124.214.50])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Feb 2025 06:13:46 +0000 (GMT)
Message-ID: <9e538d6d-a570-482d-be30-0e0e3aec2a10@linux.ibm.com>
Date: Thu, 27 Feb 2025 11:43:45 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Donet Tom <donettom@linux.vnet.ibm.com>,
        Alison Schofield <alison.schofield@intel.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>
References: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
 <x49y0y0oi1g.fsf@segfault.usersys.redhat.com>
 <6f43cf6e-a3b7-4746-be15-d354cc6dd699@linux.ibm.com>
 <2db38698-dda7-4aa0-b540-44b1c3f7c9df@fujitsu.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <2db38698-dda7-4aa0-b540-44b1c3f7c9df@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JA-wmXvlMSpY73pXyZhHm3o0IyEL7x9y
X-Proofpoint-GUID: 3t9bgHR-QXzyVMtcB9aQFUHpm2iBVH-S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_03,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502270044


On 2/26/25 12:30, Zhijian Li (Fujitsu) wrote:
>
> On 26/02/2025 14:02, Donet Tom wrote:
>> On 2/20/25 19:05, Jeff Moyer wrote:
>>>> diff --git a/ndctl/json.c b/ndctl/json.c
>>>> index 23bad7f..7646882 100644
>>>> --- a/ndctl/json.c
>>>> +++ b/ndctl/json.c
>>>> @@ -381,7 +381,7 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>>>>        struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
>>>>        struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
>>>> -    if (!btt || !pfn || !dax)
>>>> +    if (!btt && !pfn && !dax)
>>>>            return NULL;
>>>>        jcaps = json_object_new_array();
>>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>>>
>> Thanks Jeff
>>
>>
>> Hi Alison
>>
>> Should I send a v3 with Reviewed-by tag
> Generally speaking, there is no need for you to do this.
>
> A small tip might be helpful if you send a patch next time.
>
>>> v1 -> v2:
>>> Addressed the review comments from Jeff and Alison.
>>>
>>> v1:
>>> https://lore.kernel.org/all/20250219094049.5156-1-donettom@linux.ibm.com/
> Commit messages that are not intended to appear in the upstream git tree
> should be placed after the '---' marker. [0]
>

Thanks Zhijian. I will take care of this from now on.

Thanks
Donet


>
> [0] https://docs.kernel.org/process/submitting-patches.html#commentary
>
> Thanks
> Zhijian
>
>> or will you take the patch with the tag?
>>
>> Thanks
>> Donet
>>
