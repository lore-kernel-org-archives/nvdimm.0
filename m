Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C97C
	for <nvdimm@lists.linux.dev>; Tue, 24 May 2022 06:09:24 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24O4LtGi018667;
	Tue, 24 May 2022 06:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wM8Fkb1KCGWm3IX7LDNv7pxnkXgpblI/5kgFTUdnsRU=;
 b=JctKCqB/z1XYr9xYqdYxOFX4slsmXwg2TKbE3lf4K55ZxwRcPPifvGyID1f0SyZ8OKN8
 PRbdV84jbcP0zJVwHeRCnhPxtCf/dWIniAWsWMxSOKPIoBQEqo8MtiR1dpUCes+LFf1U
 9/o0QLEGqvmK0K9HWLErkuarRf9/SQAy9RRRdyHg5YzqMpcLm4OcSM8MWXqoKDSDqXUR
 fKUr4Qy57W8sZwAuCIQEj6DraRWrY+bOQSiu4kkBE8AatEO3zwUXQxmP7pQ+PY/HVYfk
 RbhM/LwpHURN9jofEC0up+GR485i2WshT3iv5IJCIhjOlAIhGYwLSITrgiELbnnEzVmY Bw== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8r971te0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 May 2022 06:09:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24O681qp028604;
	Tue, 24 May 2022 06:09:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03fra.de.ibm.com with ESMTP id 3g6qq9b6n8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 May 2022 06:09:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24O69H6j47841680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 May 2022 06:09:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49A1552057;
	Tue, 24 May 2022 06:09:17 +0000 (GMT)
Received: from [9.43.92.147] (unknown [9.43.92.147])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 417075204F;
	Tue, 24 May 2022 06:09:13 +0000 (GMT)
Message-ID: <d845a6a5-2924-9e10-ead8-bc05e7965c26@linux.ibm.com>
Date: Tue, 24 May 2022 11:39:12 +0530
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
X-Proofpoint-GUID: vE2b91XUZCRddcX8H6A5p2wgIevqr-Pe
X-Proofpoint-ORIG-GUID: vE2b91XUZCRddcX8H6A5p2wgIevqr-Pe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_01,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240035

One more comment..

On 4/26/22 22:50, Tarun Sahu wrote:
> Write-infoblock command has the below issues,
> 1 - Oerwriting the existing alignment value with the default value when
>        not passed as parameter.
> 2 - Changing the mode of the namespace to fsdax when -m not specified
> 3 - Incorrectly updating the uuid and parent_uuid if corresponding

<snip>
> ---
>   ndctl/namespace.c | 253 +++++++++++++++++++++++++++++++---------------
>   1 file changed, 170 insertions(+), 83 deletions(-)
<snip>
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 257b58c..cca9a51 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c

<snip>

> @@ -2121,11 +2197,17 @@ static int do_xaction_namespace(const char *namespace,
>   		}
>   
>   		if (param.infile || !namespace) {
> -			rc = file_read_infoblock(param.infile, NULL, &ri_ctx);
> -			if (ri_ctx.jblocks)
> -				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
> -			if (rc >= 0)
> -				(*processed)++;
> +			struct ns_info ns_info;

Move this to the beginning of the block.

> +
> +			rc = ns_info_init(&ns_info);
> +			if (!rc) {
> +				rc = file_read_infoblock(param.infile, NULL, &ri_ctx, &ns_info);
> +				if (ri_ctx.jblocks)
> +					util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
> +				if (rc >= 0)
> +					(*processed)++;
> +			}
> +			ns_info_destroy(&ns_info);
>   			return rc;
>   		}
>   	}

Thanks,
Shivaprasad
