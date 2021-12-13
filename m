Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6DC173
	for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 05:34:29 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BD1bxQr030820;
	Mon, 13 Dec 2021 05:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=tUVZqQDPqHh0MU5CX38wNIixFeamFPIezBNeXEMAxrM=;
 b=OccxOX/WXy27KBMCxIJzmfbWfPzP8n8Fv+BiiD8uSMNoVOX/m1mvDm2YL9G+qwGiqez5
 BYjv3jZV2HINpouqGdi6oXypaMaEc3xes9+xlMeZXF5UzgDnX6sigt1yPv5J0b47nZSt
 4IzNr6gHZ/carryKaudN1LF0RUy5JcEWfF+x/5ZKeRe4xWvpNwJ30g2gBmGMSXt6z/I1
 sxJK2YZoKpDR3GJU19RcGkpwEIFHa6c7lnwToEiypUpVjTjW8BSAVFu5R1GdUnYQK/LK
 n2sLi3t5pi7WTkAsdpVmvI6Lzbb2+uKTAq5Pp68CQLWkRq3ASHOsqilYKSeWMkxA3inH Ww== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3cwunckv1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Dec 2021 05:34:21 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BD5N3EE026383;
	Mon, 13 Dec 2021 05:34:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma01fra.de.ibm.com with ESMTP id 3cvkm90dmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Dec 2021 05:34:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BD5QMJv16580870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Dec 2021 05:26:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 615C1AE045;
	Mon, 13 Dec 2021 05:34:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 47C27AE055;
	Mon, 13 Dec 2021 05:34:11 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.58.203])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 13 Dec 2021 05:34:10 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Mon, 13 Dec 2021 11:04:08 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com,
        Shivaprasad G Bhat
 <sbhat@linux.ibm.com>, nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 0/2] papr: Implement initial support for injecting
 smart errors
In-Reply-To: <163638167629.400685.8268507373653839032.stgit@lep8c.aus.stglabs.ibm.com>
References: <163638167629.400685.8268507373653839032.stgit@lep8c.aus.stglabs.ibm.com>
Date: Mon, 13 Dec 2021 11:04:08 +0530
Message-ID: <87lf0p9igf.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xRNmfVkZAX-hBywTtKiaDH5dZwmYs3q0
X-Proofpoint-GUID: xRNmfVkZAX-hBywTtKiaDH5dZwmYs3q0
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-13_01,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112130034


Hi Dan, Ira and Vishal,


Gentle reminder about this patch series. If there are any objections to
this please let us know.

Thanks,
~ Vaibhav

Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:

> From: Vaibhav Jain <vaibhav@linux.ibm.com>
>
> Changes since v2:
> Link: https://lore.kernel.org/nvdimm/163102311841.258999.14260383111577082134.stgit@99912bbcb4c7/
> * Removed redundant comments as suggested by Ira.
> * Added the Reviewed-by: Ira tag
>
> Changes since v1:
> Link: https://patchwork.kernel.org/project/linux-nvdimm/cover/20210712173132.1205192-1-vaibhav@linux.ibm.com/
> * Minor update to patch description
> * The changes are based on the new kernel patch [1]
>
> The patch series implements limited support for injecting smart errors for PAPR
> NVDIMMs via ndctl-inject-smart(1) command. SMART errors are emulating in
> papr_scm module as presently PAPR doesn't support injecting smart errors on an
> NVDIMM. Currently support for injecting 'fatal' health state and 'dirty'
> shutdown state is implemented. With the proposed ndctl patched and with
> corresponding kernel patch [1] following command flow is expected:
>
> $ sudo ndctl list -DH -d nmem0
> ...
>       "health_state":"ok",
>       "shutdown_state":"clean",
> ...
>  # inject unsafe shutdown and fatal health error
> $ sudo ndctl inject-smart nmem0 -Uf
> ...
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
> ...
>  # uninject all errors
> $ sudo ndctl inject-smart nmem0 -N
> ...
>       "health_state":"ok",
>       "shutdown_state":"clean",
> ...
>
> Structure of the patch series
> =============================
>
> * First patch updates 'inject-smart' code to not always assume support for
>   injecting all smart-errors. It also updates 'intel.c' to explicitly indicate
>   the type of smart-inject errors supported.
>
> * Update 'papr.c' to add support for injecting smart 'fatal' health and
>   'dirty-shutdown' errors.
>
> [1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
> ---
>
> Vaibhav Jain (2):
>       libndctl, intel: Indicate supported smart-inject types
>       libndctl/papr: Add limited support for inject-smart
>
>
>  ndctl/inject-smart.c  | 33 ++++++++++++++++++-----
>  ndctl/lib/intel.c     |  7 ++++-
>  ndctl/lib/papr.c      | 61 +++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/papr_pdsm.h | 17 ++++++++++++
>  ndctl/libndctl.h      |  8 ++++++
>  5 files changed, 118 insertions(+), 8 deletions(-)
>
> --
> Signature
>
>
>

-- 
Cheers
~ Vaibhav
