Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9063FC0
	for <nvdimm@lists.linux.dev>; Sat,  4 Sep 2021 06:40:14 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1846X6Re014723;
	Sat, 4 Sep 2021 02:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kZXD9B6xUv7acCyuCRcCCWQ3Pfwqm+EWA1wklly46BQ=;
 b=DPjRErowGW6iiDSQMyaUmOtViV+uD4bfPE7+98mlssKQJCG2eStcqlQnrcHOJb1m3Uyn
 hyo4p7WGH4e3Lwc+J5euq1/Z9AKdbPW+UEKDTF532b07qyDUoEXsB8jrkr0axA3AVADM
 fv0HDRCfcXZ9qqQs1SueLR29SRu1g4nC3+kY2NxsNTFdfbSjR2hS96pnIXIbpStEMuN/
 KKMoVj4myYPSaUz4lvPA3g+xx7SZZJpFOWqv2W9rzhY/Lzfo5g4GcwQKMr5dkw75lJ/Q
 Tx2+AFK6kEd/ZRo8uPqHiTwmLUsJ7MccU5THuZHxQOoTin5l6n89uX0TZlxK/z0mj8+d ww== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3auxrs47gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 04 Sep 2021 02:40:06 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
	by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1846VxbG012306;
	Sat, 4 Sep 2021 06:40:05 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
	by ppma04wdc.us.ibm.com with ESMTP id 3av0e8j0pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 04 Sep 2021 06:40:05 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
	by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1846e4JW19792192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 4 Sep 2021 06:40:04 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B95A5136061;
	Sat,  4 Sep 2021 06:40:04 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C906313605E;
	Sat,  4 Sep 2021 06:40:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.43.55.112])
	by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
	Sat,  4 Sep 2021 06:40:00 +0000 (GMT)
Subject: Re: [RFC PATCH] drivers/nvdimm: nvdimm_pmu_free_hotplug_memory() can
 be static
To: kernel test robot <lkp@intel.com>, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Cc: kbuild-all@lists.01.org, maddy@linux.ibm.com, santosh@fossix.org
References: <20210903050914.273525-3-kjain@linux.ibm.com>
 <20210903151941.GA23182@a0af9ae1a611>
From: kajoljain <kjain@linux.ibm.com>
Message-ID: <2d314a25-8972-3a01-9402-d43e41177a8f@linux.ibm.com>
Date: Sat, 4 Sep 2021 12:09:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210903151941.GA23182@a0af9ae1a611>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6RyJYml7VDTkn-7nypCDcvBAxAMsZnon
X-Proofpoint-ORIG-GUID: 6RyJYml7VDTkn-7nypCDcvBAxAMsZnon
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-04_02:2021-09-03,2021-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109040044



On 9/3/21 8:49 PM, kernel test robot wrote:
> drivers/nvdimm/nd_perf.c:159:6: warning: symbol 'nvdimm_pmu_free_hotplug_memory' was not declared. Should it be static?
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
> ---
>  nd_perf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
> index 4c49d1bc2a3c6..b129e5e702d59 100644
> --- a/drivers/nvdimm/nd_perf.c
> +++ b/drivers/nvdimm/nd_perf.c
> @@ -156,7 +156,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
>  	return 0;
>  }
>  
> -void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
> +static void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
>  {
>  	cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
>  	cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
> 

Hi,
   Thanks for reporting this issue, I will merge it in my followup patchset.

Thanks,
Kajol Jain
