Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31FC2C82
	for <nvdimm@lists.linux.dev>; Wed, 19 Jan 2022 15:05:31 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JDwSoa005618;
	Wed, 19 Jan 2022 15:05:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=k4RDsZfUlHh8Rt0M02e2isw9g3KmCjxqMe8EoXeQ/p8=;
 b=tIm2CG0CIK3SATx5NAlEE1pZ8DqqC4/tHltcrddumcYLu6tCjhCrIa2QnOMjhkLEqgEm
 6x+VSP0pjflJhUd23+a/eh3DPcmQitkXN3cn7PeQcoRRZ82eh3ynAUIs2Tfhc/dg0/J8
 fim1yFbQc6sP8rGsKDnqOKIw91c4ThP3xjnI3kIoF4e99dkW44WXrcSxkj4TgtOJ7M3r
 cC0YW+FJ/0G+VRaFVbou4+EjyPeYJMj84lQkaJfJBL1Q1Wln4z/ZXyjAHFMyQQLL/vQe
 bJhoV25fe6S9gQFLxRhfq7NM0G2LBrzjuLfJVqejuIs2rQZA3Iby6Z5m3/HbtQBMXLuG uA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dpm0g9qwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jan 2022 15:05:22 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JEw39T008140;
	Wed, 19 Jan 2022 15:05:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3dknw9yb22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jan 2022 15:05:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JF5GCV24838510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jan 2022 15:05:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFBBE5205F;
	Wed, 19 Jan 2022 15:05:16 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.0.186])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 12FC25204F;
	Wed, 19 Jan 2022 15:05:13 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 19 Jan 2022 20:35:12 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        Dan Williams
 <dan.j.williams@intel.com>,
        "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: Re: [PATCH v3] powerpc/papr_scm: Implement initial support for
 injecting smart errors
In-Reply-To: <20220118175915.GB209936@iweiny-DESK2.sc.intel.com>
References: <20220113120252.1145671-1-vaibhav@linux.ibm.com>
 <20220118175915.GB209936@iweiny-DESK2.sc.intel.com>
Date: Wed, 19 Jan 2022 20:35:12 +0530
Message-ID: <87czknkbpz.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TL9zcTBvVWhoeWlo6VxzBOYLNCmAXd6j
X-Proofpoint-GUID: TL9zcTBvVWhoeWlo6VxzBOYLNCmAXd6j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_08,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190086


Hi Ira, Thanks for reviewing this patch.

Ira Weiny <ira.weiny@intel.com> writes:

> On Thu, Jan 13, 2022 at 05:32:52PM +0530, Vaibhav Jain wrote:
> [snip]
>
>>  
>> +/* Inject a smart error Add the dirty-shutdown-counter value to the pdsm */
>> +static int papr_pdsm_smart_inject(struct papr_scm_priv *p,
>> +				  union nd_pdsm_payload *payload)
>> +{
>> +	int rc;
>> +	u32 supported_flags = 0;
>> +	u64 mask = 0, override = 0;
>> +
>> +	/* Check for individual smart error flags and update mask and override */
>> +	if (payload->smart_inject.flags & PDSM_SMART_INJECT_HEALTH_FATAL) {
>> +		supported_flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
>> +		mask |= PAPR_PMEM_HEALTH_FATAL;
>> +		override |= payload->smart_inject.fatal_enable ?
>> +			PAPR_PMEM_HEALTH_FATAL : 0;
>> +	}
>> +
>> +	if (payload->smart_inject.flags & PDSM_SMART_INJECT_BAD_SHUTDOWN) {
>> +		supported_flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
>> +		mask |= PAPR_PMEM_SHUTDOWN_DIRTY;
>> +		override |= payload->smart_inject.unsafe_shutdown_enable ?
>> +			PAPR_PMEM_SHUTDOWN_DIRTY : 0;
>> +	}
>> +
>
> I'm struggling to see why there is a need for both a flag and an 8 bit 'enable'
> value?
>
This is to enable the inject/uninject error usecase with ndctl which
lets user select individual error conditions like bad_shutdown or
fatal-health state.

The nd_papr_pdsm_smart_inject.flag field indicates which error
conditions needs to be tweaked and individual __u8 fields like
'fatal_enable' are boolean values to indicate the inject/uninject state
of that error condition.

For e.g to uninject fatal-health and inject unsafe-shutdown following
nd_papr_pdsm_smart_inject payload can be sent:

{
.flags = PDSM_SMART_INJECT_HEALTH_FATAL |
       PDSM_SMART_INJECT_BAD_SHUTDOWN,
.fatal_enable = 0,
.unsafe_shutdown_enable = 1,
}


To just to inject fatal-health following nd_papr_pdsm_smart_inject
payload can be sent:

{
.flags = PDSM_SMART_INJECT_HEALTH_FATAL,
.fatal_enable = 1,
.unsafe_shutdown_enable = <dont-care>,
}


> Ira
>

-- 
Cheers
~ Vaibhav
