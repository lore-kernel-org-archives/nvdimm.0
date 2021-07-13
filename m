Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A080A168
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 04:43:22 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D4XOpP018058;
	Tue, 13 Jul 2021 00:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XCxDF3GqQChWbI52Xp2dfWhiS/q36wl2avHheVJzhXw=;
 b=qPQS+AaTqIbh6FC7h9GT/Yu13m9viGwTfitZUnbZ4/tIgmyHJ0P/N1BQmXr3dBDg3BRh
 nwWYv1uwUxYVTshxmbaVhMB/f9ThgDGUi+q5FguIagkIAEodcmLvfhmlVgBIAaGe0jVg
 SRBWWOIXwVl1y2DbWAVC8qKHm3N69Hptwj9k7bFmxd1ICdi/7gi9EU0iFncKuchFrYDM
 GK21D3SEhgEOOjB2ZQweI+1Sb7gr3vZ1BxYUeB9IeiI4lgyeZoFTJWe6kOy91qPEuuCR
 m/tpoSkEPA+LycVqASvXrtc0rWeAXJZShJCO9okk1T+LHZZxJgiDTAVOnjVAv1LOcWdj fQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 39qrud6u3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 00:43:19 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16D4d2ca020091;
	Tue, 13 Jul 2021 04:43:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 39q2th92h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Jul 2021 04:43:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16D4f7TO36176202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jul 2021 04:41:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2DDBA4057;
	Tue, 13 Jul 2021 04:43:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 912C8A4055;
	Tue, 13 Jul 2021 04:43:13 +0000 (GMT)
Received: from [9.85.92.56] (unknown [9.85.92.56])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 13 Jul 2021 04:43:13 +0000 (GMT)
Subject: Re: [ndctl PATCH 2/2] libndctl/papr: Add limited support for
 inject-smart
To: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
References: <20210712173132.1205192-1-vaibhav@linux.ibm.com>
 <20210712173132.1205192-3-vaibhav@linux.ibm.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <527107a5-c124-6e85-2364-499d9bb0913e@linux.ibm.com>
Date: Tue, 13 Jul 2021 10:13:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210712173132.1205192-3-vaibhav@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2tuaPHvVsljW5N9Xff4Y-bj9sZhr4FtE
X-Proofpoint-ORIG-GUID: 2tuaPHvVsljW5N9Xff4Y-bj9sZhr4FtE
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
 clxscore=1011 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130022

On 7/12/21 11:01 PM, Vaibhav Jain wrote:
> Implements support for ndctl inject-smart command by providing an
> implementation of 'smart_inject*' dimm-ops callbacks. Presently only
> support for injecting unsafe-shutdown and fatal-health states is
> available.
> 
> The patch also introduce various PAPR PDSM structures that are used to
> communicate the inject-smart errors to the papr_scm kernel
> module. This is done via SMART_INJECT PDSM which sends a payload of
> type 'struct nd_papr_pdsm_smart_inject'.
> 
> The patch depends on the kernel PAPR PDSM implementation for
> PDSM_SMART_INJECT posted at [1].
> 
> [1] : https://lore.kernel.org/nvdimm/20210712084819.1150350-1-vaibhav@linux.ibm.com
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>   ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
>   ndctl/lib/papr_pdsm.h | 17 ++++++++++++
>   2 files changed, 78 insertions(+)
> 
> diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
> index 42ff200dc588..b797e1e5fe8b 100644
> --- a/ndctl/lib/papr.c
> +++ b/ndctl/lib/papr.c
> @@ -221,6 +221,41 @@ static unsigned int papr_smart_get_shutdown_state(struct ndctl_cmd *cmd)
>   	return health.dimm_bad_shutdown;
>   }
>   
> +static int papr_smart_inject_supported(struct ndctl_dimm *dimm)
> +{
> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL))
> +		return -EOPNOTSUPP;
> +
> +	if (!test_dimm_dsm(dimm, PAPR_PDSM_SMART_INJECT))
> +		return -EIO;
> +
> +	return ND_SMART_INJECT_HEALTH_STATE | ND_SMART_INJECT_UNCLEAN_SHUTDOWN;
> +}
> +

with ndtest PAPR_SCM_FAMILY driver, should we test more inject types? if 
so should the supported inject types be fetched from the driver?

> +static int papr_smart_inject_valid(struct ndctl_cmd *cmd)
> +{
> +	if (cmd->type != ND_CMD_CALL ||
> +	    to_pdsm(cmd)->cmd_status != 0 ||
> +	    to_pdsm_cmd(cmd) != PAPR_PDSM_SMART_INJECT)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static struct ndctl_cmd *papr_new_smart_inject(struct ndctl_dimm *dimm)
> +{
> +	struct ndctl_cmd *cmd;
> +
> +	cmd = allocate_cmd(dimm, PAPR_PDSM_SMART_INJECT,
> +			sizeof(struct nd_papr_pdsm_smart_inject));
> +	if (!cmd)
> +		return NULL;
> +	/* Set the input payload size */
> +	to_ndcmd(cmd)->nd_size_in = ND_PDSM_HDR_SIZE +
> +		sizeof(struct nd_papr_pdsm_smart_inject);
> +	return cmd;
> +}
> +
>   static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
>   {
>   	struct nd_papr_pdsm_health health;
> @@ -255,11 +290,37 @@ static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
>   
>   	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
>   		(health.dimm_dsc) : 0;
> +}
> +
> +static int papr_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable)
> +{
> +	if (papr_smart_inject_valid(cmd) < 0)
> +		return -EINVAL;
> +
> +	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
> +	to_payload(cmd)->inject.fatal_enable = enable;
>   
> +	return 0;
> +}
> +
> +static int papr_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd,
> +						 bool enable)
> +{
> +	if (papr_smart_inject_valid(cmd) < 0)
> +		return -EINVAL;
> +
> +	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
> +	to_payload(cmd)->inject.unsafe_shutdown_enable = enable;
> +
> +	return 0;
>   }
>   
>   struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>   	.cmd_is_supported = papr_cmd_is_supported,
> +	.new_smart_inject = papr_new_smart_inject,
> +	.smart_inject_supported = papr_smart_inject_supported,
> +	.smart_inject_fatal = papr_cmd_smart_inject_fatal,
> +	.smart_inject_unsafe_shutdown = papr_cmd_smart_inject_unsafe_shutdown,
>   	.smart_get_flags = papr_smart_get_flags,
>   	.get_firmware_status =  papr_get_firmware_status,
>   	.xlat_firmware_status = papr_xlat_firmware_status,
> diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
> index f45b1e40c075..20ac20f89acd 100644
> --- a/ndctl/lib/papr_pdsm.h
> +++ b/ndctl/lib/papr_pdsm.h
> @@ -121,12 +121,29 @@ struct nd_papr_pdsm_health {
>   enum papr_pdsm {
>   	PAPR_PDSM_MIN = 0x0,
>   	PAPR_PDSM_HEALTH,
> +	PAPR_PDSM_SMART_INJECT,
>   	PAPR_PDSM_MAX,
>   };
> +/* Flags for injecting specific smart errors */
> +#define PDSM_SMART_INJECT_HEALTH_FATAL		(1 << 0)
> +#define PDSM_SMART_INJECT_BAD_SHUTDOWN		(1 << 1)
> +
> +struct nd_papr_pdsm_smart_inject {
> +	union {
> +		struct {
> +			/* One or more of PDSM_SMART_INJECT_ */
> +			__u32 flags;
> +			__u8 fatal_enable;
> +			__u8 unsafe_shutdown_enable;
> +		};
> +		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
> +	};
> +};
>   
>   /* Maximal union that can hold all possible payload types */
>   union nd_pdsm_payload {
>   	struct nd_papr_pdsm_health health;
> +	struct nd_papr_pdsm_smart_inject inject;
>   	__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>   } __attribute__((packed));
>   
> 


-aneesh

