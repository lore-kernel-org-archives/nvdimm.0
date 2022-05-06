Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED17F4
	for <nvdimm@lists.linux.dev>; Fri,  6 May 2022 09:38:52 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2469VNCh018289;
	Fri, 6 May 2022 09:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=mC97+9MPTlTt7PAQdZC8XdfWx83kYZtBBSB6RgHiDtI=;
 b=GWyO41TFGghYohyUdzqSuvU+VNk3kFAr0Mc+g2u9KO9OatYOOshQdfnoVl1eg1O/uDVz
 /o/0texTdSejOTQa+aBhRxy4nES+P/N/5Lz7Ne10XOJbSQk7l4U1kZYHZK1OUi+ZJwSu
 Fvc9ur9aDrVFEUB10UxmZddhc3BbaslptwkJTAc1bYhKhrkemt00oCC4FTQVLjkJn7HL
 xlB6VML1DNi9UXPudmI8eeB5CkpLGtvrNcQRy73oDbErFFd3Ol5QVwxqvxna+RerwwEy
 8ipl9GuvXU2wojDkHhDX49dMbDEUgWpfZ85yl8WrY4pZtDMKvl5SmYf2T391nRBK+BgI wg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw14a0514-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 May 2022 09:38:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2469WcTp027910;
	Fri, 6 May 2022 09:33:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma06ams.nl.ibm.com with ESMTP id 3fvg6112wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 May 2022 09:33:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2469XbOE58524132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 May 2022 09:33:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCB5652052;
	Fri,  6 May 2022 09:33:37 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.13.105])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 2AB935204F;
	Fri,  6 May 2022 09:33:33 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Fri, 06 May 2022 15:03:33 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Kajol Jain <kjain@linux.ibm.com>, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, dan.j.williams@intel.com
Cc: nvdimm@lists.linux.dev, atrajeev@linux.vnet.ibm.com,
        rnsastry@linux.ibm.com, kjain@linux.ibm.com, maddy@linux.ibm.com,
        disgoel@linux.vnet.ibm.com
Subject: Re: [PATCH] powerpc/papr_scm: Fix buffer overflow issue with
 CONFIG_FORTIFY_SOURCE
In-Reply-To: <20220505153451.35503-1-kjain@linux.ibm.com>
References: <20220505153451.35503-1-kjain@linux.ibm.com>
Date: Fri, 06 May 2022 15:03:32 +0530
Message-ID: <87levfvwcz.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IBPAOpfzwjqfJS37lIvNqvfDUHiF-vLW
X-Proofpoint-GUID: IBPAOpfzwjqfJS37lIvNqvfDUHiF-vLW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060052

Hi Kajol,

Thanks for the patch. Minor review comment below:

Kajol Jain <kjain@linux.ibm.com> writes:

> With CONFIG_FORTIFY_SOURCE enabled, string functions will also perform
> dynamic checks for string size which can panic the kernel,
> like incase of overflow detection.
>
> In papr_scm, papr_scm_pmu_check_events function uses stat->stat_id
> with string operations, to populate the nvdimm_events_map array.
> Since stat_id variable is not NULL terminated, the kernel panics
> with CONFIG_FORTIFY_SOURCE enabled at boot time.
>
> Below are the logs of kernel panic:
>
> [    0.090221][    T1] detected buffer overflow in __fortify_strlen
> [    0.090241][    T1] ------------[ cut here ]------------
> [    0.090246][    T1] kernel BUG at lib/string_helpers.c:980!
> [    0.090253][    T1] Oops: Exception in kernel mode, sig: 5 [#1]
> ........
> [    0.090375][    T1] NIP [c00000000077dad0] fortify_panic+0x28/0x38
> [    0.090382][    T1] LR [c00000000077dacc] fortify_panic+0x24/0x38
> [    0.090387][    T1] Call Trace:
> [    0.090390][    T1] [c0000022d77836e0] [c00000000077dacc] fortify_panic+0x24/0x38 (unreliable)
> [    9.297707] [    T1] [c00800000deb2660] papr_scm_pmu_check_events.constprop.0+0x118/0x220 [papr_scm]
> [    9.297721] [    T1] [c00800000deb2cb0] papr_scm_probe+0x288/0x62c [papr_scm]
> [    9.297732] [    T1] [c0000000009b46a8] platform_probe+0x98/0x150
>
> Fix this issue by using kmemdup_nul function to copy the content of
> stat->stat_id directly to the nvdimm_events_map array.
>
> Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/papr_scm.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> index f58728d5f10d..39962c905542 100644
> --- a/arch/powerpc/platforms/pseries/papr_scm.c
> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> @@ -462,7 +462,6 @@ static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu
>  {
>  	struct papr_scm_perf_stat *stat;
>  	struct papr_scm_perf_stats *stats;
> -	char *statid;
>  	int index, rc, count;
>  	u32 available_events;
>  
> @@ -493,14 +492,12 @@ static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu
>  
>  	for (index = 0, stat = stats->scm_statistic, count = 0;
>  		     index < available_events; index++, ++stat) {
> -		statid = kzalloc(strlen(stat->stat_id) + 1, GFP_KERNEL);
> -		if (!statid) {
> +		p->nvdimm_events_map[count] = kmemdup_nul(stat->stat_id,
>  	8, GFP_KERNEL);
s/8/sizeof(stat->stat_id)/

> +		if (!p->nvdimm_events_map[count]) {
>  			rc = -ENOMEM;
>  			goto out_nvdimm_events_map;
>  		}
>  
> -		strcpy(statid, stat->stat_id);
> -		p->nvdimm_events_map[count] = statid;
>  		count++;
>  	}
>  	p->nvdimm_events_map[count] = NULL;
> -- 
> 2.31.1
>

-- 
Cheers
~ Vaibhav
