Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD677FF
	for <nvdimm@lists.linux.dev>; Fri,  5 Aug 2022 01:48:56 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2751kguU020048;
	Fri, 5 Aug 2022 01:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=ol4G0vmzMSnL9B09OphGbj7QoMZ9cfy6iw3gE7vRes0=;
 b=fQR1znifp0QguvsSxyu2lECrfthPgcHa8+5Uxp5khHVPf9Z0uxAhj+XmNXzGtaC4J9Ez
 ZkIn89oTi5tQ1O1a/loUbCcvvHx9+OUX60sXhQ5lAZPTG2XAClx8IbjrybgtyarPozCT
 /sru6YJ5qXsGKjCnfVjXuxiCyHviswhNS4915MFpExWlULYVkafsupIUYgqi33jCGx7b
 9zBr6yd4aH8/B9fMSOg65dYqTA1NFuDI7oQYCrh0+Ao3chb0yRBGWOQqWgqne6IKLoPo
 ee6bwjlSYSj20MOvZ9r89A61BWChrdfzMlgsijqHjBiel9MPlxYV1ZPl6TV2+nuReTvX 0Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrsuer0vk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Aug 2022 01:48:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2751anf0014144;
	Fri, 5 Aug 2022 01:48:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3hmv98ptty-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Aug 2022 01:48:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2751miBf25231686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Aug 2022 01:48:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55916A4089;
	Fri,  5 Aug 2022 01:48:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C35C2A4082;
	Fri,  5 Aug 2022 01:48:40 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.113.245])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Fri,  5 Aug 2022 01:48:40 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Fri, 05 Aug 2022 07:18:39 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Kajol Jain <kjain@linux.ibm.com>, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org
Cc: nvdimm@lists.linux.dev, atrajeev@linux.vnet.ibm.com,
        rnsastry@linux.ibm.com, kjain@linux.ibm.com, maddy@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com,
        disgoel@linux.vnet.ibm.com
Subject: Re: [PATCH v3] powerpc/papr_scm: Fix nvdimm event mappings
In-Reply-To: <20220804074852.55157-1-kjain@linux.ibm.com>
References: <20220804074852.55157-1-kjain@linux.ibm.com>
Date: Fri, 05 Aug 2022 07:18:39 +0530
Message-ID: <87wnbne9zc.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ry3k1osunR8MCvRB6SUqtA6h0_0Iqtb4
X-Proofpoint-ORIG-GUID: ry3k1osunR8MCvRB6SUqtA6h0_0Iqtb4
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_06,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2208050007


Kajol Jain <kjain@linux.ibm.com> writes:

> Commit 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
> added performance monitoring support for papr-scm nvdimm devices via
> perf interface. Commit also added an array in papr_scm_priv
> structure called "nvdimm_events_map", which got filled based on the
> result of H_SCM_PERFORMANCE_STATS hcall.
>
> Currently there is an assumption that the order of events in the
> stats buffer, returned by the hypervisor is same. And order also
> happens to matches with the events specified in nvdimm driver code.
> But this assumption is not documented in Power Architecture
> Platform Requirements (PAPR) document. Although the order
> of events happens to be same on current generation od system, but
> it might not be true in future generation systems. Fix the issue, by
> adding a static mapping for nvdimm events to corresponding stat-id,
> and removing the dynamic map from papr_scm_priv structure. Also
> remove the function papr_scm_pmu_check_events from papr_scm.c file,
> as we no longer need to copy stat-ids dynamically.
>
> Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
> Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/papr_scm.c | 88 +++++++----------------
>  1 file changed, 27 insertions(+), 61 deletions(-)
>
> ---
> Changelog:
> v2 -> v3
> - Remove function papr_scm_pmu_check_events() and replace the
>   event checks in papr_scm_pmu_register() function with p->stat_buffer_len
>   as suggested by Vaibhav Jain
>   Link to the patch v2: https://lore.kernel.org/all/20220711034605.212683-1-kjain@linux.ibm.com/

V3 patch looks good to me.

Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
-- 
Cheers
~ Vaibhav
