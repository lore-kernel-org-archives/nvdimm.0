Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B746870
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 07:58:11 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E7XfM1026411;
	Wed, 14 Jul 2021 03:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=Q755q2fk5ahXRImTKBNQGzQGgSAQU0w7tQbMfjnsRI8=;
 b=Bkq4IwEV+NmXpc/tv4+Oq2MwTvEYbSJ66ewyWgAT0UN7Eq12GXEcJWM972v9KgaYTyQn
 e0PFX3adL0D35slbQeQsYh3bgf2D8EZN/pWBFAIvldXpDHDfNRCfQr/ekGUF32OXWJj1
 nVMpvcwbTnrKOlegXY32f2Ro/p+6c6C/EM6EJ9nCBhvDVTbdSjJkCU3f3LjOf5ICWVQc
 TBwgAuErcUXC7UL2B8k8gu3jpm+Heq6Z1S5lbkrTdkDvkSX6ji8UuO40mZQGg31FHVCl
 qXeM+DRGpKQ7uWzOYGUksNeOatxpSPkRwzwR66j9wPoaNPcYLvQ6BfzutqEENlfmItF3 jA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39sc8ju3n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jul 2021 03:58:09 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16E7s8r1009364;
	Wed, 14 Jul 2021 07:58:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 39q3689n9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jul 2021 07:58:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16E7w4Kl16646536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jul 2021 07:58:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EA8F42041;
	Wed, 14 Jul 2021 07:58:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02A614204B;
	Wed, 14 Jul 2021 07:58:02 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.50.125])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed, 14 Jul 2021 07:58:01 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 14 Jul 2021 13:28:00 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
        Vishal Verma
 <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad
 G Bhat <sbhat@linux.ibm.com>
Subject: Re: [ndctl PATCH] libndctl: Update nvdimm flags after inject-smart
In-Reply-To: <CAPcyv4hnZSzcG3uc0BLWBjhbqBwJLsCeUPiAALwubHoXge58NQ@mail.gmail.com>
References: <20210713202523.190113-1-vaibhav@linux.ibm.com>
 <CAPcyv4hnZSzcG3uc0BLWBjhbqBwJLsCeUPiAALwubHoXge58NQ@mail.gmail.com>
Date: Wed, 14 Jul 2021 13:28:00 +0530
Message-ID: <87r1g15nuf.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uLL8g6Iyj59CIAjTwN1_OQ4zDfeaj2Gs
X-Proofpoint-ORIG-GUID: uLL8g6Iyj59CIAjTwN1_OQ4zDfeaj2Gs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-14_03:2021-07-14,2021-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140047


Thanks for looking into this patch Dan

Dan Williams <dan.j.williams@intel.com> writes:

> On Tue, Jul 13, 2021 at 1:25 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>>
>> Presently after performing a inject-smart the nvdimm flags reported are out
>> of date as shown below where no 'smart_notify' or 'flush_fail' flags were
>> reported even though they are set after injecting the smart error:
>>
>> $ sudo inject-smart -fU nmem0
>> [
>>   {
>>     "dev":"nmem0",
>>     "health":{
>>       "health_state":"fatal",
>>       "shutdown_state":"dirty",
>>       "shutdown_count":0
>>     }
>>   }
>> ]
>> $ sudo cat /sys/class/nd/ndctl0/device/nmem0/papr/flags
>> flush_fail smart_notify
>>
>> This happens because nvdimm flags are only parsed once during its probe and
>> not refreshed even after a inject-smart operation makes them out of
>> date. To fix this the patch adds a new export from libndctl named as
>> ndctl_refresh_dimm_flags() that can be called after inject-smart that
>> forces a refresh of nvdimm flags. This ensures that correct nvdimm flags
>> are reported after the inject-smart operation as shown below:
>>
>> $ sudo ndctl inject-smart -fU nmem0
>> [
>>   {
>>     "dev":"nmem0",
>>     "flag_failed_flush":true,
>>     "flag_smart_event":true,
>>     "health":{
>>       "health_state":"fatal",
>>       "shutdown_state":"dirty",
>>       "shutdown_count":0
>>     }
>>   }
>> ]
>>
>> The patch refactors populate_dimm_attributes() to move the nvdimm flags
>> parsing code to the newly introduced ndctl_refresh_dimm_flags()
>> export. Since reading nvdimm flags requires constructing path using
>> 'bus_prefix' which is only available during add_dimm(), the patch
>> introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
>> value. During ndctl_refresh_dimm_flags() the cached bus_prefix is used to
>> read the contents of the nvdimm flag file and pass it on to the appropriate
>> flag parsing function.
>
> I think this can be handled without needing an explicit
> ndctl_refresh_dimm_flags() api. Teach all the flag retrieval apis to
> check if the cached value has been invalidated and re-parse the flags.
> Then teach the inject-smart path to invalidate the cached copy of the
> flags.
>
Thanks for the suggestion. On the same line I think refreshing nvdimm
flags can also be done implicitly after a successful ndctl_cmd_submit()
call as that point we have interacted with the kernel_module which may
have triggered a nvdimm flags change.

Such a changeset would also be smaller compared to updating all flags
retrieval api's to invalidate and refresh nvdimm flags.

-- 
Cheers
~ Vaibhav
