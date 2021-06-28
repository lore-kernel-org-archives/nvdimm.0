Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11C670
	for <nvdimm@lists.linux.dev>; Mon, 28 Jun 2021 09:22:06 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15S93vxA116858;
	Mon, 28 Jun 2021 05:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=UQv1bqF2xmW2ZErVw96UdohTKOiCVv9DQKuoPToYvL4=;
 b=FOLZhqSyDBkZ+71UodzbZHeFhX+OJ38KW6nyGnYhC1YDUql/nxODzdj7UntMz8p/Uzv8
 xh3KaKMrXieRjFQU8U4xvXf3W09/Msm2EELS1a316q+eQVu4ZoLOD+1nJcgYS2BmHlfZ
 LxBD00dbxN6DzMmGZH0LXskJdG5qK5ghXUSAs75uO7gGN69hCUwQ6QqSO7etKLhITNDx
 C4ydBvupK6mNmYVLyKDEdMPE5xXqjLwJ1cq3WfwXP4WHEHjwkJETjPvMGkpF3YCuhV9V
 VqaMbXlnwlSI1gFVCjypm/4h+jn/nQ/gORgJeY8+6ELySDC6jf07abeALa18th19A/bh wQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0b-001b2d01.pphosted.com with ESMTP id 39fag99nvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jun 2021 05:06:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15S8w1x7016304;
	Mon, 28 Jun 2021 09:06:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma06ams.nl.ibm.com with ESMTP id 39dughgpkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jun 2021 09:06:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15S960D027394544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jun 2021 09:06:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2EEFAE13C;
	Mon, 28 Jun 2021 09:05:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEDA0AE074;
	Mon, 28 Jun 2021 09:05:57 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.95.70])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 28 Jun 2021 09:05:57 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 28 Jun 2021 14:35:56 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "nvdimm@lists.linux.dev"
 <nvdimm@lists.linux.dev>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "Weiny, Ira"
 <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH] libndctl/papr: Add support for reporting
 shutdown-count
In-Reply-To: <87tumvkgb6.fsf@vajain21.in.ibm.com>
References: <20210521112649.417210-1-vaibhav@linux.ibm.com>
 <b7aa19188447306e649bb05f04fb4deeaee3e92d.camel@intel.com>
 <87tumvkgb6.fsf@vajain21.in.ibm.com>
Date: Mon, 28 Jun 2021 14:35:56 +0530
Message-ID: <87eecmjr4b.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d4hEBDeL3MnoxFalRnuNtIoQ1fF8LY04
X-Proofpoint-GUID: d4hEBDeL3MnoxFalRnuNtIoQ1fF8LY04
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_07:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106280063

Hi Vishal,

The corrosponding kernel patch for the functionality has been merged
into upstream ppc-next tree via following commit:

de21e1377c4f("powerpc/papr_scm: Add support for reporting dirty-shutdown-count")

[Link] https://git.kernel.org/powerpc/c/de21e1377c4fe65bfd8d31e446482c1bc2232997

So the corrosponding ndctl patch can now be merged.

Thanks,
~ Vaibhav

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Hi Vishal,
>
> Thanks for looking into this patch.
>
> "Verma, Vishal L" <vishal.l.verma@intel.com> writes:
>
>> On Fri, 2021-05-21 at 16:56 +0530, Vaibhav Jain wrote:
>>> Add support for reporting dirty-shutdown-count (DSC) for PAPR based
>>> NVDIMMs. The sysfs attribute exposing this value is located at
>>> nmemX/papr/dirty_shutdown.
>>> 
>>> This counter is also returned in payload for PAPR_PDSM_HEALTH as newly
>>> introduced member 'dimm_dsc' in 'struct nd_papr_pdsm_health'. Presence
>>> of 'DSC' is indicated by the PDSM_DIMM_DSC_VALID extension flag.
>>> 
>>> The patch implements 'ndctl_dimm_ops.smart_get_shutdown_count'
>>> callback in implemented as papr_smart_get_shutdown_count().
>>> 
>>> Kernel side changes to support reporting DSC have been proposed at
>>> [1]. With updated kernel 'ndctl list -DH' reports following output on
>>> PPC64:
>>> 
>>> $ sudo ndctl list -DH
>>> [
>>>   {
>>>     "dev":"nmem0",
>>>     "health":{
>>>       "health_state":"ok",
>>>       "life_used_percentage":50,
>>>       "shutdown_state":"clean",
>>>       "shutdown_count":10
>>>     }
>>>   }
>>> ]
>>> 
>>> Link: https://lore.kernel.org/nvdimm/20210521111023.413732-1-vaibhav@linux.ibm.com
>>
>> I'd suggest just using '[1]: <https://lore....'  for this. The Link:
>> trailer is added by 'b4' when I apply this patch, and points to this
>> patch on lore. It would be confusing to have two Link: trailers
>> pointing to different things.
>>
> Thanks for pointing this out. Will use your suggested format going
> forward.
>
>>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>>> ---
>>>  ndctl/lib/libndctl.c  |  6 +++++-
>>>  ndctl/lib/papr.c      | 23 +++++++++++++++++++++++
>>>  ndctl/lib/papr_pdsm.h |  6 ++++++
>>>  3 files changed, 34 insertions(+), 1 deletion(-)
>>
>> The patch looks okay to me - but I assume it depends on the kernel
>> interfaces not changing in the patch referenced above. Should I put
>> this on hold until the kernel side is accepted?
>>
> Yes, it will be better to hold this until the corroponding kernel patch
> is merged.
>
>>> 
>>> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>>> index aa36a3c87c57..6ee426ae30e1 100644
>>> --- a/ndctl/lib/libndctl.c
>>> +++ b/ndctl/lib/libndctl.c
>>> @@ -1795,8 +1795,12 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
>>>  
>>>  		/* Allocate monitor mode fd */
>>>  		dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
>>> -		rc = 0;
>>> +		/* Get the dirty shutdown counter value */
>>> +		sprintf(path, "%s/papr/dirty_shutdown", dimm_base);
>>> +		if (sysfs_read_attr(ctx, path, buf) == 0)
>>> +			dimm->dirty_shutdown = strtoll(buf, NULL, 0);
>>>  
>>> +		rc = 0;
>>>  	} else if (strcmp(buf, "nvdimm_test") == 0) {
>>>  		/* probe via common populate_dimm_attributes() */
>>>  		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
>>> diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
>>> index 9c6f2f045fc2..42ff200dc588 100644
>>> --- a/ndctl/lib/papr.c
>>> +++ b/ndctl/lib/papr.c
>>> @@ -165,6 +165,9 @@ static unsigned int papr_smart_get_flags(struct ndctl_cmd *cmd)
>>>  		if (health.extension_flags & PDSM_DIMM_HEALTH_RUN_GAUGE_VALID)
>>>  			flags |= ND_SMART_USED_VALID;
>>>  
>>> +		if (health.extension_flags &  PDSM_DIMM_DSC_VALID)
>>> +			flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
>>> +
>>>  		return flags;
>>>  	}
>>>  
>>> @@ -236,6 +239,25 @@ static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
>>>  		(100 - health.dimm_fuel_gauge) : 0;
>>>  }
>>>  
>>> +static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
>>> +{
>>> +
>>> +	struct nd_papr_pdsm_health health;
>>> +
>>> +	/* Ignore in case of error or invalid pdsm */
>>> +	if (!cmd_is_valid(cmd) ||
>>> +	    to_pdsm(cmd)->cmd_status != 0 ||
>>> +	    to_pdsm_cmd(cmd) != PAPR_PDSM_HEALTH)
>>> +		return 0;
>>> +
>>> +	/* get the payload from command */
>>> +	health = to_payload(cmd)->health;
>>> +
>>> +	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
>>> +		(health.dimm_dsc) : 0;
>>> +
>>> +}
>>> +
>>>  struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>>>  	.cmd_is_supported = papr_cmd_is_supported,
>>>  	.smart_get_flags = papr_smart_get_flags,
>>> @@ -245,4 +267,5 @@ struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>>>  	.smart_get_health = papr_smart_get_health,
>>>  	.smart_get_shutdown_state = papr_smart_get_shutdown_state,
>>>  	.smart_get_life_used = papr_smart_get_life_used,
>>> +	.smart_get_shutdown_count = papr_smart_get_shutdown_count,
>>>  };
>>> diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
>>> index 1bac8a7fc933..f45b1e40c075 100644
>>> --- a/ndctl/lib/papr_pdsm.h
>>> +++ b/ndctl/lib/papr_pdsm.h
>>> @@ -75,6 +75,9 @@
>>>  /* Indicate that the 'dimm_fuel_gauge' field is valid */
>>>  #define PDSM_DIMM_HEALTH_RUN_GAUGE_VALID 1
>>>  
>>> +/* Indicate that the 'dimm_dsc' field is valid */
>>> +#define PDSM_DIMM_DSC_VALID 2
>>> +
>>>  /*
>>>   * Struct exchanged between kernel & ndctl in for PAPR_PDSM_HEALTH
>>>   * Various flags indicate the health status of the dimm.
>>> @@ -103,6 +106,9 @@ struct nd_papr_pdsm_health {
>>>  
>>>  			/* Extension flag PDSM_DIMM_HEALTH_RUN_GAUGE_VALID */
>>>  			__u16 dimm_fuel_gauge;
>>> +
>>> +			/* Extension flag PDSM_DIMM_DSC_VALID */
>>> +			__u64 dimm_dsc;
>>>  		};
>>>  		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>>>  	};
>>
