Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84BC7C
	for <nvdimm@lists.linux.dev>; Tue, 24 May 2022 05:47:24 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O4CEJD031722;
	Tue, 24 May 2022 05:47:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aOBPBtrs9WcD+8kt95yIuQXFONcT3pMEw9kvqpj9Hfs=;
 b=thiFluw/REThn9z7Zj0JMUv2bT2idkXegZcnNWFWG8Vp+1rTtKkyEcrEH+3KOCUEFsS5
 QVqHvet0UBi225JvWGC0ylr+vLLqu7WzSez+cYxJQ6psBndiEouMEliTvGqAcasckHl9
 Six2j0Z0nm9k9Rrgw3vprNS0AtmOCw8Bw1FVWoVdv1bn2nNprIEpbQCoiOKReKfzCirZ
 wpunClgVZj/Qcwe99TjF8ubs4gmgwzPLoZqxS39MnpH+UGYvmwWzklgzZSSYmB842i5f
 IOjvZ4oylMKFV/vV5EC28uxgCfwctsLgBKZmA7orTw8JT3SgCM8UvMQtn+bRxSLc0J35 pQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8r4d1jdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 May 2022 05:47:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O5gQgO008450;
	Tue, 24 May 2022 05:47:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9bt97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 May 2022 05:47:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O5lHaW26411328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 May 2022 05:47:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 96FCB11C04C;
	Tue, 24 May 2022 05:47:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EBB011C04A;
	Tue, 24 May 2022 05:47:15 +0000 (GMT)
Received: from [9.43.92.147] (unknown [9.43.92.147])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 24 May 2022 05:47:15 +0000 (GMT)
Message-ID: <e1a9cf32-0628-1e2d-83f8-c2946a6298aa@linux.ibm.com>
Date: Tue, 24 May 2022 11:17:14 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 1/2] ndctl/namespace:Fix multiple issues with
 write-infoblock
Content-Language: en-US
To: Tarun Sahu <tsahu@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com
References: <20220426172056.122789-1-tsahu@linux.ibm.com>
 <20220426172056.122789-2-tsahu@linux.ibm.com>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20220426172056.122789-2-tsahu@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wje1R1XUlgoOPU3lF6sYxG67XcOjFS8k
X-Proofpoint-ORIG-GUID: wje1R1XUlgoOPU3lF6sYxG67XcOjFS8k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_01,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240033



On 4/26/22 22:50, Tarun Sahu wrote:
> Write-infoblock command has the below issues,
> 1 - Oerwriting the existing alignment value with the default value when
>        not passed as parameter.
> 2 - Changing the mode of the namespace to fsdax when -m not specified
> 3 - Incorrectly updating the uuid and parent_uuid if corresponding
> parameter is not specified

<snip>

> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 257b58c..cca9a51 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c

<snip>

> @@ -2026,12 +2105,10 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
>   		struct read_infoblock_ctx *ri_ctx, int write)
>   {
>   	int rc;
> -	uuid_t uuid;
> -	char str[40];
>   	char path[50];
> -	const char *save;
>   	const char *cmd = write ? "write-infoblock" : "read-infoblock";
>   	const char *devname = ndctl_namespace_get_devname(ndns);
> +	struct ns_info ns_info;
>   
>   	if (ndctl_namespace_is_active(ndns)) {
>   		pr_verbose("%s: %s enabled, must be disabled\n", cmd, devname);
> @@ -2045,21 +2122,22 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
>   		goto out;

This would lead to calling ns_info_destroy() on uninitialized ns_info, 
and ns_info->ns_sb_buf would have junk value.

With that fixed,

Reviewed-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>

>   	}
>   
> -	save = param.parent_uuid;
> -	if (!param.parent_uuid) {
> -		ndctl_namespace_get_uuid(ndns, uuid);
> -		uuid_unparse(uuid, str);
> -		param.parent_uuid = str;
> -	}
> -
>   	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
> -	if (write) {
> +	if (ns_info_init(&ns_info) != 0)
> +		goto out;
> +
> +	rc = file_read_infoblock(path, ndns, ri_ctx, &ns_info);
> +	if (!rc && write) {
>   		unsigned long long align;
>   		bool align_provided = true;
>   
>   		if (!param.align) {
>   			align = ndctl_get_default_alignment(ndns);
> -
> +			if (ns_info.mode == NDCTL_NS_MODE_FSDAX ||
> +					ns_info.mode == NDCTL_NS_MODE_DEVDAX) {
> +				align = ((struct pfn_sb *)(ns_info.ns_sb_buf + ns_info.offset))->
> +					align;
> +			}
>   			if (asprintf((char **)&param.align, "%llu", align) < 0) {
>   				rc = -EINVAL;
>   				goto out;
> @@ -2078,18 +2156,16 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
>   				rc = -EINVAL;
>   			}
>   		}
> -
>   		if (!rc)
> -			rc = file_write_infoblock(path);
> +			rc = file_write_infoblock(path, &ns_info);
>   
>   		if (!align_provided) {
>   			free((char *)param.align);
>   			param.align = NULL;
>   		}
> -	} else
> -		rc = file_read_infoblock(path, ndns, ri_ctx);
> -	param.parent_uuid = save;
> +	}
>   out:
> +	ns_info_destroy(&ns_info);
>   	ndctl_namespace_set_raw_mode(ndns, 0);
>   	ndctl_namespace_disable_invalidate(ndns);
>   	return rc;
