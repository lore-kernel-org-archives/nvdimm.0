Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1734D72
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 04:14:19 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D441Df055433;
	Tue, 13 Jul 2021 00:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Nl9tUJdaQ+ChCZg7GKGLRyB7Bmmqt2HLADEjbIZY+gA=;
 b=l5hEpn5tir1Ctk+Cwb6jTQmm839U+L2qGlBmETR2dyQ79ecbBQCIndzLjmCBhtaIgiBO
 iAemsC2xP3NdHGlMXFDNePJztBcUiAJgkheSvJSgsH9A3u4rGbSbn4aKkvaDPxORN6sz
 Ob1xY5rguSqc+Or4N3qeolq6WBvN05nxF0h/18ycZDEAmHJZIDqZynJCCXNcXrtE16np
 iuDEwxfnRr8q2wy1fiqhsQFR1jUcS5HEInsclleRwS3WJKpvSyCmmWgQntybmKz1qJ8P
 Qppu9CUWw/Nw2fmZzM0bCKooGJQ0GoCfSwXUcn/5sARz3hSUxfrl0FyTFcYb9FszPjfx eA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 39qs3bpa5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 00:14:10 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16D444uD055702;
	Tue, 13 Jul 2021 00:14:10 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
	by mx0b-001b2d01.pphosted.com with ESMTP id 39qs3bpa4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 00:14:10 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16D3v5gO013323;
	Tue, 13 Jul 2021 04:14:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06fra.de.ibm.com with ESMTP id 39q2th8j5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 04:14:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16D4BwkW35783002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 04:11:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B28DA4059;
	Tue, 13 Jul 2021 04:14:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B9D3A4053;
	Tue, 13 Jul 2021 04:14:04 +0000 (GMT)
Received: from [9.85.92.56] (unknown [9.85.92.56])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 13 Jul 2021 04:14:04 +0000 (GMT)
Subject: Re: [PATCH] ndctl: Avoid confusing error message when operating on
 all the namespaces
To: Yi Zhang <yi.zhang@redhat.com>
Cc: nvdimm@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>
References: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com>
 <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <6ece565f-e866-4a48-3a08-bf4f94f738e9@linux.ibm.com>
Date: Tue, 13 Jul 2021 09:44:03 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GqrbKxuqHaffd1c0OQhjzGYMwvSZpRYs
X-Proofpoint-ORIG-GUID: TXBjikA70UaC3UR00uOMkokbi7RApa9A
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_14:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130021

On 7/13/21 5:49 AM, Yi Zhang wrote:
> Jeff had posted one patch to fix similar issue
> https://lore.kernel.org/linux-nvdimm/x49r1lohpty.fsf@segfault.boston.devel.redhat.com/T/#u
> 

I missed that patch. I am wondering whether that would result in ndctl 
not reporting error when we use the seed namespace name directly with 
destroy-namespace command

> Hi Dan/Visha
> Could we make some progress on this issue?
> 
> 
> On Thu, Jul 8, 2021 at 6:41 PM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:
>>
>> With only seed namespace present, ndctl results in confusing error messages as
>> below.
>>
>> ndctl# ./ndctl/ndctl  enable-namespace all
>> error enabling namespaces: No such device or address
>> enabled 0 namespaces
>>
>> ndctl# ./ndctl/ndctl  disable-namespace all
>> disabled 3 namespaces
>>
>> ndctl# ./ndctl/ndctl  destroy-namespace all -f
>>    Error: destroy namespace: namespace1.0 failed to enable for zeroing, continuing
>>
>>    Error: destroy namespace: namespace1.1 failed to enable for zeroing, continuing
>>
>>    Error: destroy namespace: namespace0.0 failed to enable for zeroing, continuing
>>
>> destroyed 0 namespaces
>> ndctl#
>>
>> With the patch we get
>> ndctl# ./ndctl/ndctl  disable-namespace all
>> disabled 0 namespaces
>>
>> ndctl# ./ndctl/ndctl  enable-namespace all
>> enabled 0 namespaces
>>
>> ndctl# ./ndctl/ndctl  destroy-namespace all -f
>> destroyed 0 namespaces
>> ndctl#
>>
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> ---
>>   ndctl/namespace.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
>> index 0c8df9fa8b47..c52daeae562a 100644
>> --- a/ndctl/namespace.c
>> +++ b/ndctl/namespace.c
>> @@ -2205,8 +2205,15 @@ static int do_xaction_namespace(const char *namespace,
>>                                  return rc;
>>                          }
>>                          ndctl_namespace_foreach_safe(region, ndns, _n) {
>> -                               ndns_name = ndctl_namespace_get_devname(ndns);
>>
>> +                               if (!strcmp(namespace, "all")
>> +                                               && !ndctl_namespace_get_size(ndns)) {
>> +                                       if (!*processed && rc)
>> +                                               rc  = 0;
>> +                                       continue;
>> +                               }
>> +
>> +                               ndns_name = ndctl_namespace_get_devname(ndns);
>>                                  if (strcmp(namespace, "all") != 0
>>                                                  && strcmp(namespace, ndns_name) != 0)
>>                                          continue;
>> --
>> 2.31.1
>>
>>
> 
> 

