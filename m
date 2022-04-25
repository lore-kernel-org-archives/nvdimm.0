Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0DB7C
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 12:37:20 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PBtmvd011979;
	Mon, 25 Apr 2022 12:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=119hjzVKI/YGKxeboy6v0GhSp/4n5KnfzVaPmvlY7oE=;
 b=EOOQoOSFWQob+/J/pw8re0TTm3Lop2QuQy/vqQmIrQX0HwD4x/FPu/K4Pk6lZvO0XL6m
 2+hokHrW9dstFxxD4wyuakHSDN/RD2BRRQImr5zECqVfXafJNOmfVSBZERye6RnvJjF0
 TI69F/6xT78qRzwTr/eKYo8hqsVZAFdpvPKqx/B6evCsGaC2dv2tx3WPtRHiQn8rmUcq
 pgZHUXN+KaUIBOSodkQprUgPFw2hKS8CNyi7HiF80A0NlhUEYoaplvkbJoP4vLXlbq4s
 Ch/0XfqCnTfPtPHxLkLU1BpC4c1kiWM2JjzxyKaBTic3EescICChxf8KrIRRaqbykSmB 8Q== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fnu708wq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 12:37:13 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PCKf0g008071;
	Mon, 25 Apr 2022 12:37:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04fra.de.ibm.com with ESMTP id 3fm938sy5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Apr 2022 12:37:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PCbJKt6881812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Apr 2022 12:37:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B58F42042;
	Mon, 25 Apr 2022 12:37:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC97E4203F;
	Mon, 25 Apr 2022 12:37:02 +0000 (GMT)
Received: from [9.43.33.161] (unknown [9.43.33.161])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 25 Apr 2022 12:37:02 +0000 (GMT)
Message-ID: <9eb7c528-3a7c-4e60-822a-57f7f673e215@linux.ibm.com>
Date: Mon, 25 Apr 2022 18:07:00 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] ndctl/namespace:Fix multiple issues with
 write-infoblock
Content-Language: en-US
To: Tarun Sahu <tsahu@linux.ibm.com>, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
        aneesh.kumar@linux.ibm.com, vaibhav@linux.ibm.com
References: <20220413035252.161527-1-tsahu@linux.ibm.com>
 <20220413035252.161527-2-tsahu@linux.ibm.com>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <20220413035252.161527-2-tsahu@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3cBIDzlsiMixBcIC8_VWDZOfaURyI4Is
X-Proofpoint-ORIG-GUID: 3cBIDzlsiMixBcIC8_VWDZOfaURyI4Is
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_08,2022-04-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250055



On 4/13/22 09:22, Tarun Sahu wrote:
> Write-infoblock command-
> 1. update the alignment to default value if not passed as parameter
> 2. convert any type of namespace to fsdax if parameter -m is not
> specified
> 3. Incorrectly updating the uuid and parent_uuid if corresponding
> parameter is not specified
> 

May be rephrased to,

Write-infoblock command has the below issues,
1 - Oerwriting the existing alignment value with the default value when 
      not passed as parameter.
2 - Changing the mode of the namespace to fsdax when -m not specified
3 - Incorrectly updating the uuid and parent_uuid if corresponding 
parameter is not specified

> Considering the above three issues, we first needed to read the
> original infoblock if available, and update the align, uuid, parent_uuid
> to its original value while writing the infoblock if corresponding
> parameter is not passed.
> 

<snip>

> 
> This patch change the declaration of following functions to pass
> ns_info,
> 
> file_read_infoblock()
> file_write_infoblock()
> parse_namespace_infoblock()
> write_pfn_sb()
> 
> Before and after the patch results:

The test results bloat up the commit log, just keep the "after" OR may 
be move it below "---". Few of the implementation explanations from the 
  description summary can be moved down too. The commit log that way 
will have crisp summary, and details being moved to the bottom of "---".


<snip>
> +		ns_info_destroy(&ns_info);
>   		return rc;
>   	}
>   
> @@ -2447,3 +2530,5 @@ int cmd_write_infoblock(int argc, const char **argv, struct ndctl_ctx *ctx)
>   	fprintf(stderr, "wrote %d infoblock%s\n", write, write == 1 ? "" : "s");
>   	return rc;
>   }
> +
> +

Blank line insertions

> diff --git a/ndctl/namespace.h b/ndctl/namespace.h
> index 57735eb..a406c18 100644
> --- a/ndctl/namespace.h
> +++ b/ndctl/namespace.h
> @@ -8,6 +8,7 @@
>   #include <util/fletcher.h>
>   #include <ccan/endian/endian.h>
>   #include <ccan/short_types/short_types.h>
> +#include <ndctl/libndctl.h>
>   
>   enum {
>   	NSINDEX_SIG_LEN = 16,
> @@ -233,6 +234,12 @@ union info_block {
>   	struct btt_sb btt_sb;
>   };
>   
> +struct ns_info {
> +	void *ns_sb_buf;
> +	enum ndctl_namespace_mode mode;
> +	size_t offset;
> +};
> +

This structure is used only inside the namespace.c. Can be defined
in the namaespace.c itself instead of the header.

>   static inline bool verify_infoblock_checksum(union info_block *sb)
>   {
>   	uint64_t sum;
