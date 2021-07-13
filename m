Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DA270
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 07:51:37 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D7bof7138653;
	Tue, 13 Jul 2021 03:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=H30zpMOJl7CC2JfCaBnurhdjR5IzeUtD59DShwsm1d8=;
 b=OgPg0DcSCt6ox2eBQXYVhTW+FkqbDqLcQkw/hWyF/qiAU3njhK3fgiRrOYvI903cAeyc
 uWChNep8AuDxn7pwgCjBRa5S50G2jMG5/yCFUPCRVKHF+38WHYjCYV+0NchDwW0BOY8B
 MKYHNyp57WNHItD4CGQX6PWPuFv8A24CtbNtWmZQ6IbrAmLAXfz79f9SIj8M04CKbisZ
 bLm8BHBhy+mnBO3lcO0lr0GoTA/gPJ2J8vYHzioZhYRRXnRCg+IVMhe5ZXr0DWNxIJ4j
 eUFooJgHOWdaHeMwXBsOreM6U6yzHsanAoqWwoCCpTtUgp+sfbiw3dCrHuWLiBPsbQeB jQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39qrkwhhdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 03:51:35 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16D7nY4K014567;
	Tue, 13 Jul 2021 07:51:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 39q2th95fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 07:51:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16D7nL1j28967352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 07:49:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 367FBAE045;
	Tue, 13 Jul 2021 07:51:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED777AE058;
	Tue, 13 Jul 2021 07:51:26 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.199.40.58])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Tue, 13 Jul 2021 07:51:26 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 13 Jul 2021 13:21:26 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma
 <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G
 Bhat <sbhat@linux.ibm.com>
Subject: Re: [ndctl PATCH 2/2] libndctl/papr: Add limited support for
 inject-smart
In-Reply-To: <527107a5-c124-6e85-2364-499d9bb0913e@linux.ibm.com>
References: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
 <20210712173132.1205192-3-vaibhav@linux.ibm.com>
 <527107a5-c124-6e85-2364-499d9bb0913e@linux.ibm.com>
Date: Tue, 13 Jul 2021 13:21:26 +0530
Message-ID: <87k0lups75.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UdbmOffbkhtaYZhsGv-fx0-yARAyqKiK
X-Proofpoint-ORIG-GUID: UdbmOffbkhtaYZhsGv-fx0-yARAyqKiK
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-13_03:2021-07-13,2021-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130047

Thanks Aneesh for looking into this patch

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> On 7/12/21 11:01 PM, Vaibhav Jain wrote:
>> Implements support for ndctl inject-smart command by providing an
>> implementation of 'smart_inject*' dimm-ops callbacks. Presently only
>> support for injecting unsafe-shutdown and fatal-health states is
>> available.
>> 
>> The patch also introduce various PAPR PDSM structures that are used to
>> communicate the inject-smart errors to the papr_scm kernel
>> module. This is done via SMART_INJECT PDSM which sends a payload of
>> type 'struct nd_papr_pdsm_smart_inject'.
>> 
>> The patch depends on the kernel PAPR PDSM implementation for
>> PDSM_SMART_INJECT posted at [1].
>> 
>> [1] : https://lore.kernel.org/nvdimm/20210712084819.1150350-1-vaibhav@linux.ibm.com
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>>   ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
>>   ndctl/lib/papr_pdsm.h | 17 ++++++++++++
>>   2 files changed, 78 insertions(+)
>> 
>> diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
>> index 42ff200dc588..b797e1e5fe8b 100644
>> --- a/ndctl/lib/papr.c
>> +++ b/ndctl/lib/papr.c
>> @@ -221,6 +221,41 @@ static unsigned int papr_smart_get_shutdown_state(struct ndctl_cmd *cmd)
>>   	return health.dimm_bad_shutdown;
>>   }
>>   
>> +static int papr_smart_inject_supported(struct ndctl_dimm *dimm)
>> +{
>> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (!test_dimm_dsm(dimm, PAPR_PDSM_SMART_INJECT))
>> +		return -EIO;
>> +
>> +	return ND_SMART_INJECT_HEALTH_STATE | ND_SMART_INJECT_UNCLEAN_SHUTDOWN;
>> +}
>> +
>
> with ndtest PAPR_SCM_FAMILY driver, should we test more inject types?

Presently a commmon PDSM structure 'struct nd_papr_pdsm_smart_inject'
used between ndtest and papr_scm. If we want to add support for more
inject types in ndtest then that structure would need to be extended.

However even with that, libndctl still shares common dimm-ops
callback for papr_scm & ndtest which only supports injecting smart fatal
health and dirty-shutdown at the moment. So with only ndtest supporting an inject
type for example temprature-threshold, not sure which libndctl code
patch we will be testing.

> if 
> so should the supported inject types be fetched from the driver?
>
Good suggestion.
Surely that can be a implemented in future once papr_scm and ndtest
starts supporting more smart inject types.

>> +static int papr_smart_inject_valid(struct ndctl_cmd *cmd)
>> +{
>> +	if (cmd->type != ND_CMD_CALL ||
>> +	    to_pdsm(cmd)->cmd_status != 0 ||
>> +	    to_pdsm_cmd(cmd) != PAPR_PDSM_SMART_INJECT)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct ndctl_cmd *papr_new_smart_inject(struct ndctl_dimm *dimm)
>> +{
>> +	struct ndctl_cmd *cmd;
>> +
>> +	cmd = allocate_cmd(dimm, PAPR_PDSM_SMART_INJECT,
>> +			sizeof(struct nd_papr_pdsm_smart_inject));
>> +	if (!cmd)
>> +		return NULL;
>> +	/* Set the input payload size */
>> +	to_ndcmd(cmd)->nd_size_in = ND_PDSM_HDR_SIZE +
>> +		sizeof(struct nd_papr_pdsm_smart_inject);
>> +	return cmd;
>> +}
>> +
>>   static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
>>   {
>>   	struct nd_papr_pdsm_health health;
>> @@ -255,11 +290,37 @@ static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
>>   
>>   	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
>>   		(health.dimm_dsc) : 0;
>> +}
>> +
>> +static int papr_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable)
>> +{
>> +	if (papr_smart_inject_valid(cmd) < 0)
>> +		return -EINVAL;
>> +
>> +	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
>> +	to_payload(cmd)->inject.fatal_enable = enable;
>>   
>> +	return 0;
>> +}
>> +
>> +static int papr_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd,
>> +						 bool enable)
>> +{
>> +	if (papr_smart_inject_valid(cmd) < 0)
>> +		return -EINVAL;
>> +
>> +	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
>> +	to_payload(cmd)->inject.unsafe_shutdown_enable = enable;
>> +
>> +	return 0;
>>   }
>>   
>>   struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>>   	.cmd_is_supported = papr_cmd_is_supported,
>> +	.new_smart_inject = papr_new_smart_inject,
>> +	.smart_inject_supported = papr_smart_inject_supported,
>> +	.smart_inject_fatal = papr_cmd_smart_inject_fatal,
>> +	.smart_inject_unsafe_shutdown = papr_cmd_smart_inject_unsafe_shutdown,
>>   	.smart_get_flags = papr_smart_get_flags,
>>   	.get_firmware_status =  papr_get_firmware_status,
>>   	.xlat_firmware_status = papr_xlat_firmware_status,
>> diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
>> index f45b1e40c075..20ac20f89acd 100644
>> --- a/ndctl/lib/papr_pdsm.h
>> +++ b/ndctl/lib/papr_pdsm.h
>> @@ -121,12 +121,29 @@ struct nd_papr_pdsm_health {
>>   enum papr_pdsm {
>>   	PAPR_PDSM_MIN = 0x0,
>>   	PAPR_PDSM_HEALTH,
>> +	PAPR_PDSM_SMART_INJECT,
>>   	PAPR_PDSM_MAX,
>>   };
>> +/* Flags for injecting specific smart errors */
>> +#define PDSM_SMART_INJECT_HEALTH_FATAL		(1 << 0)
>> +#define PDSM_SMART_INJECT_BAD_SHUTDOWN		(1 << 1)
>> +
>> +struct nd_papr_pdsm_smart_inject {
>> +	union {
>> +		struct {
>> +			/* One or more of PDSM_SMART_INJECT_ */
>> +			__u32 flags;
>> +			__u8 fatal_enable;
>> +			__u8 unsafe_shutdown_enable;
>> +		};
>> +		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>> +	};
>> +};
>>   
>>   /* Maximal union that can hold all possible payload types */
>>   union nd_pdsm_payload {
>>   	struct nd_papr_pdsm_health health;
>> +	struct nd_papr_pdsm_smart_inject inject;
>>   	__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>>   } __attribute__((packed));
>>   
>> 
>
>
> -aneesh
>
>

-- 
Cheers
~ Vaibhav
