Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EA018F
	for <nvdimm@lists.linux.dev>; Wed,  6 Apr 2022 08:38:56 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2367sFr7001207;
	Wed, 6 Apr 2022 08:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2JzUK1yRApnPbpKT6p/KCvk5qwBqZRov4pLINJwJxvM=;
 b=qQSY1FOi3ew2VJjOr6/sz5A02pu/5JOtdWWFZWyzed4mi+1SM2Ove9gSw0YODMuBlLMS
 d08QFlac45EHjZQg7aPawLV0QDeaCqKNsNZb0GsuTVqJdViTdxVngAWhEPy091Jta2XC
 +jMsDqE/ek+O5+wyfOIWCwn4vMbM6FUVQ3FZjj1ZrfTfFLmRuBgBOMk6hfvl7vXlm+g9
 738lzz9BU5unByOxK+ooX4aJJD5XI4SbjhhfEjCMQV7hRTqbOot1mXVlGMyKVtzBHsd/
 SG4VJ0yiXBNMipoadNWAJiNCUO4ubI8qiO+N97g65IONq86MrKTAvLOfVYdqNApcO9SN /Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3f8w3f31dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Apr 2022 08:38:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2368bHeM014315;
	Wed, 6 Apr 2022 08:38:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma06ams.nl.ibm.com with ESMTP id 3f6drhqcrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Apr 2022 08:38:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2368co4B54985062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Apr 2022 08:38:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A883DA405F;
	Wed,  6 Apr 2022 08:38:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C860EA405B;
	Wed,  6 Apr 2022 08:38:49 +0000 (GMT)
Received: from [9.43.96.28] (unknown [9.43.96.28])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed,  6 Apr 2022 08:38:49 +0000 (GMT)
Message-ID: <10e0964e-49f7-39e5-8250-6b88713d30c8@linux.ibm.com>
Date: Wed, 6 Apr 2022 14:08:48 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] tools/testing/nvdimm: Fix security_init() symbol
 collision
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev
References: <164904238610.1330275.1889212115373993727.stgit@dwillia2-desk3.amr.corp.intel.com>
From: kajoljain <kjain@linux.ibm.com>
In-Reply-To: <164904238610.1330275.1889212115373993727.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3AxkKICYYwAUvkMMaTGKPY3CQbnq8CUR
X-Proofpoint-ORIG-GUID: 3AxkKICYYwAUvkMMaTGKPY3CQbnq8CUR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_03,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060040



On 4/4/22 08:49, Dan Williams wrote:
> Starting with the new perf-event support in the nvdimm core, the
> nfit_test mock module stops compiling. Rename its security_init() to
> nfit_security_init().
> 
> tools/testing/nvdimm/test/nfit.c:1845:13: error: conflicting types for ‘security_init’; have ‘void(struct nfit_test *)’
>  1845 | static void security_init(struct nfit_test *t)
>       |             ^~~~~~~~~~~~~
> In file included from ./include/linux/perf_event.h:61,
>                  from ./include/linux/nd.h:11,
>                  from ./drivers/nvdimm/nd-core.h:11,
>                  from tools/testing/nvdimm/test/nfit.c:19:
> 
> Fixes: 9a61d0838cd0 ("drivers/nvdimm: Add nvdimm pmu structure")
> Cc: Kajol Jain <kjain@linux.ibm.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me.

Reviewed-by: Kajol Jain <kjain@linux.ibm.com>

Thanks,
Kajol Jain

> ---
>  tools/testing/nvdimm/test/nfit.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 65dbdda3a054..1da76ccde448 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1842,7 +1842,7 @@ static int nfit_test_dimm_init(struct nfit_test *t)
>  	return 0;
>  }
>  
> -static void security_init(struct nfit_test *t)
> +static void nfit_security_init(struct nfit_test *t)
>  {
>  	int i;
>  
> @@ -1938,7 +1938,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
>  	if (nfit_test_dimm_init(t))
>  		return -ENOMEM;
>  	smart_init(t);
> -	security_init(t);
> +	nfit_security_init(t);
>  	return ars_state_init(&t->pdev.dev, &t->ars_state);
>  }
>  
> 
