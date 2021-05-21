Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB40870
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 20:01:03 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LJYOgQ172049;
	Fri, 21 May 2021 16:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=79TpDzgalUZOITLCLytxGgsMqzs9yz2K5e3cRv+Yt+M=;
 b=C/OK1E3rOvJgsgbdJIwMK7bTgHbqIkIBn8fSaYfhgjNYJFARpkZHYOLNHgjPbGU/WGyL
 T8ycGpQi3qIHkPEVfHiN9ZDp/cCLmR5fKH753S2Y0CjKGp8m9o2csctut9cf4iXwZlui
 n8jK806K+i6IKVDn06aSDizy1cpafJgjcJP0F+11Ewzwtp49mI91I0Jo3vOX3kHaISAF
 g8uNvBX10Us9B/gj6EIs0wutKwEpXPjpYjULdU2YeasddpegPCU3DU9juppM6qoR36bj
 CApiiPpESZag/nYX1UwTYeM2eYfO7EbfLuvrVyo2BQnwPvmRPTaQdkgAkZ3ROlqPH0x6 9Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 38pjy3rpra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 May 2021 16:00:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14LJxxx4027651;
	Fri, 21 May 2021 20:00:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04ams.nl.ibm.com with ESMTP id 38j5x8baf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 May 2021 20:00:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14LK0LAZ35979750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 May 2021 20:00:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA7D5A4066;
	Fri, 21 May 2021 20:00:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51664A405B;
	Fri, 21 May 2021 20:00:47 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.72.229])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Fri, 21 May 2021 20:00:47 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Sat, 22 May 2021 01:30:45 +0530
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
In-Reply-To: <b7aa19188447306e649bb05f04fb4deeaee3e92d.camel@intel.com>
References: <20210521112649.417210-1-vaibhav@linux.ibm.com>
 <b7aa19188447306e649bb05f04fb4deeaee3e92d.camel@intel.com>
Date: Sat, 22 May 2021 01:30:45 +0530
Message-ID: <87tumvkgb6.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XWAZ4vZmfY244qhaTIlv2mBiwQSa_BgI
X-Proofpoint-ORIG-GUID: XWAZ4vZmfY244qhaTIlv2mBiwQSa_BgI
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_08:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210103

Hi Vishal,

Thanks for looking into this patch.

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Fri, 2021-05-21 at 16:56 +0530, Vaibhav Jain wrote:
>> Add support for reporting dirty-shutdown-count (DSC) for PAPR based
>> NVDIMMs. The sysfs attribute exposing this value is located at
>> nmemX/papr/dirty_shutdown.
>> 
>> This counter is also returned in payload for PAPR_PDSM_HEALTH as newly
>> introduced member 'dimm_dsc' in 'struct nd_papr_pdsm_health'. Presence
>> of 'DSC' is indicated by the PDSM_DIMM_DSC_VALID extension flag.
>> 
>> The patch implements 'ndctl_dimm_ops.smart_get_shutdown_count'
>> callback in implemented as papr_smart_get_shutdown_count().
>> 
>> Kernel side changes to support reporting DSC have been proposed at
>> [1]. With updated kernel 'ndctl list -DH' reports following output on
>> PPC64:
>> 
>> $ sudo ndctl list -DH
>> [
>>   {
>>     "dev":"nmem0",
>>     "health":{
>>       "health_state":"ok",
>>       "life_used_percentage":50,
>>       "shutdown_state":"clean",
>>       "shutdown_count":10
>>     }
>>   }
>> ]
>> 
>> Link: https://lore.kernel.org/nvdimm/20210521111023.413732-1-vaibhav@linux.ibm.com
>
> I'd suggest just using '[1]: <https://lore....'  for this. The Link:
> trailer is added by 'b4' when I apply this patch, and points to this
> patch on lore. It would be confusing to have two Link: trailers
> pointing to different things.
>
Thanks for pointing this out. Will use your suggested format going
forward.

>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>>  ndctl/lib/libndctl.c  |  6 +++++-
>>  ndctl/lib/papr.c      | 23 +++++++++++++++++++++++
>>  ndctl/lib/papr_pdsm.h |  6 ++++++
>>  3 files changed, 34 insertions(+), 1 deletion(-)
>
> The patch looks okay to me - but I assume it depends on the kernel
> interfaces not changing in the patch referenced above. Should I put
> this on hold until the kernel side is accepted?
>
Yes, it will be better to hold this until the corroponding kernel patch
is merged.

>> 
>> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>> index aa36a3c87c57..6ee426ae30e1 100644
>> --- a/ndctl/lib/libndctl.c
>> +++ b/ndctl/lib/libndctl.c
>> @@ -1795,8 +1795,12 @@ static int add_papr_dimm(struct ndctl_dimm *dimm, const char *dimm_base)
>>  
>>  		/* Allocate monitor mode fd */
>>  		dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
>> -		rc = 0;
>> +		/* Get the dirty shutdown counter value */
>> +		sprintf(path, "%s/papr/dirty_shutdown", dimm_base);
>> +		if (sysfs_read_attr(ctx, path, buf) == 0)
>> +			dimm->dirty_shutdown = strtoll(buf, NULL, 0);
>>  
>> +		rc = 0;
>>  	} else if (strcmp(buf, "nvdimm_test") == 0) {
>>  		/* probe via common populate_dimm_attributes() */
>>  		rc = populate_dimm_attributes(dimm, dimm_base, "papr");
>> diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
>> index 9c6f2f045fc2..42ff200dc588 100644
>> --- a/ndctl/lib/papr.c
>> +++ b/ndctl/lib/papr.c
>> @@ -165,6 +165,9 @@ static unsigned int papr_smart_get_flags(struct ndctl_cmd *cmd)
>>  		if (health.extension_flags & PDSM_DIMM_HEALTH_RUN_GAUGE_VALID)
>>  			flags |= ND_SMART_USED_VALID;
>>  
>> +		if (health.extension_flags &  PDSM_DIMM_DSC_VALID)
>> +			flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
>> +
>>  		return flags;
>>  	}
>>  
>> @@ -236,6 +239,25 @@ static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
>>  		(100 - health.dimm_fuel_gauge) : 0;
>>  }
>>  
>> +static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
>> +{
>> +
>> +	struct nd_papr_pdsm_health health;
>> +
>> +	/* Ignore in case of error or invalid pdsm */
>> +	if (!cmd_is_valid(cmd) ||
>> +	    to_pdsm(cmd)->cmd_status != 0 ||
>> +	    to_pdsm_cmd(cmd) != PAPR_PDSM_HEALTH)
>> +		return 0;
>> +
>> +	/* get the payload from command */
>> +	health = to_payload(cmd)->health;
>> +
>> +	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
>> +		(health.dimm_dsc) : 0;
>> +
>> +}
>> +
>>  struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>>  	.cmd_is_supported = papr_cmd_is_supported,
>>  	.smart_get_flags = papr_smart_get_flags,
>> @@ -245,4 +267,5 @@ struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>>  	.smart_get_health = papr_smart_get_health,
>>  	.smart_get_shutdown_state = papr_smart_get_shutdown_state,
>>  	.smart_get_life_used = papr_smart_get_life_used,
>> +	.smart_get_shutdown_count = papr_smart_get_shutdown_count,
>>  };
>> diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
>> index 1bac8a7fc933..f45b1e40c075 100644
>> --- a/ndctl/lib/papr_pdsm.h
>> +++ b/ndctl/lib/papr_pdsm.h
>> @@ -75,6 +75,9 @@
>>  /* Indicate that the 'dimm_fuel_gauge' field is valid */
>>  #define PDSM_DIMM_HEALTH_RUN_GAUGE_VALID 1
>>  
>> +/* Indicate that the 'dimm_dsc' field is valid */
>> +#define PDSM_DIMM_DSC_VALID 2
>> +
>>  /*
>>   * Struct exchanged between kernel & ndctl in for PAPR_PDSM_HEALTH
>>   * Various flags indicate the health status of the dimm.
>> @@ -103,6 +106,9 @@ struct nd_papr_pdsm_health {
>>  
>>  			/* Extension flag PDSM_DIMM_HEALTH_RUN_GAUGE_VALID */
>>  			__u16 dimm_fuel_gauge;
>> +
>> +			/* Extension flag PDSM_DIMM_DSC_VALID */
>> +			__u64 dimm_dsc;
>>  		};
>>  		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>>  	};
>

-- 
Cheers
~ Vaibhav
