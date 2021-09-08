Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ECE72
	for <nvdimm@lists.linux.dev>; Wed,  8 Sep 2021 10:46:17 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188AYM8W007749;
	Wed, 8 Sep 2021 06:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=Bf1jLT0XZ2n0j8yKCerL0h64crrSOksW2ucsLj/LGGg=;
 b=tE8QpkXA80ZTCkAmqrc34c+F5IdNNtZ6n/g/pvPmUIvs4+RBZQJfzNcs7Wj6VtrfwtR4
 SHZEBp9/rWnyVCfiM5FObFIXAz1Euy6tUr5U0YNb3h6nr3T2Wz7tBxzTU8Qtr9NkhR62
 pfQMg/N78GyFtr9FllF9krsGtU/vUysaYhomub3gmPu/bR8+xni1OuSJbifqag7bsevl
 9P+sGAQj3WCqZa/jbBNWOyCEGmCB3TDGncEjwFO+Cawg9YVvnbXHgdampJIT+DmuASUQ
 wlp7yrqPa13xiMHtOYPlXp6DK0TErKIjKlSoG2ArAk57YE1wneVKzoR+FLKiDTKl6Qce tw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3axhcendy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Sep 2021 06:46:11 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 188AhPVM025426;
	Wed, 8 Sep 2021 10:46:09 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3axcnp7gh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Sep 2021 10:46:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 188Ak6Z445023498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Sep 2021 10:46:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE942AE05D;
	Wed,  8 Sep 2021 10:46:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D3EAAE051;
	Wed,  8 Sep 2021 10:46:02 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.55.200])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed,  8 Sep 2021 10:46:02 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 08 Sep 2021 16:16:01 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>,
        Shivaprasad G Bhat
 <sbhat@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com,
        dan.j.williams@intel.com
Subject: Re: [RFC PATCH v2] powerpc/papr_scm: Move duplicate definitions to
 common header files
In-Reply-To: <87sfyfmzhh.fsf@mpe.ellerman.id.au>
References: <163092037510.812.12838160593592476913.stgit@82313cf9f602>
 <87sfyfmzhh.fsf@mpe.ellerman.id.au>
Date: Wed, 08 Sep 2021 16:16:00 +0530
Message-ID: <878s07s5uf.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KhecTvEg0T7ZqrdissAhXJUgmvbPa4ZT
X-Proofpoint-ORIG-GUID: KhecTvEg0T7ZqrdissAhXJUgmvbPa4ZT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_05:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080067

Hi Mpe,

Thanks for looking into this patch.

Michael Ellerman <mpe@ellerman.id.au> writes:

> Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:
>> papr_scm and ndtest share common PDSM payload structs like
>> nd_papr_pdsm_health. Presently these structs are duplicated across papr_pdsm.h
>> and ndtest.h header files. Since 'ndtest' is essentially arch independent and can
>> run on platforms other than PPC64, a way needs to be deviced to avoid redundancy
>> and duplication of PDSM structs in future.
>>
>> So the patch proposes moving the PDSM header from arch/powerpc/include/uapi/ to
>> the generic include/uapi/linux directory. Also, there are some #defines common
>> between papr_scm and ndtest which are not exported to the user space. So, move
>> them to a header file which can be shared across ndtest and papr_scm via newly
>> introduced include/linux/papr_scm.h.
>>
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> Suggested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
>> ---
>> Changelog:
>>
>> Since v1:
>> Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/162505488483.72147.12741153746322191381.stgit@56e104a48989/
>> * Removed dependency on this patch for the other patches
>>
>>  MAINTAINERS                               |    2 
>>  arch/powerpc/include/uapi/asm/papr_pdsm.h |  165 -----------------------------
>>  arch/powerpc/platforms/pseries/papr_scm.c |   43 --------
>>  include/linux/papr_scm.h                  |   48 ++++++++
>>  include/uapi/linux/papr_pdsm.h            |  165 +++++++++++++++++++++++++++++
>
> This doesn't make sense to me.
>
> Anything with papr (or PAPR) in the name is fundamentally powerpc
> specific, it doesn't belong in a generic header, or in a generic
> location.
>
> What's the actual problem you're trying to solve?
>
The ndtest module (tools/testing/nvdimm/test/ndtest.c) is implemented in
an arch independed way to enable testing of PAPR PDSMs on non ppc64
platforms like x86_64. It uses the same PDSM structs as used by papr_scm
to communicate with libndctl userspace. 

Since papr_scm is ppc64 arch specific we were so far duplicating the
PDSM structures between ndtest and papr_scm. The patch tries to solve
this duplication by moving the shared structs to arch independent common
include dirs.

Secondly, PDSMs describes how userspace can use NVDIMM_FAMILY_PAPR to
interact with NVDIMMs. So potentially a new NVDIMM beyond powerpc arch
can add its support and would need access to the same structs used by
papr_scm and ndtest. In that context it would make sense to move PDSM
headers to generic include dirs.

> If it's just including papr_scm bits into ndtest.c then that should be
> as simple as:
>
> #ifdef __powerpc__
> #include <asm/papr_scm.h>
> #endif
>
> Shouldn't it?
>
No, as ndtest implements support for NVDIMM_FAMILY_PAPR and would need
access to PDSM related structs which presently are only available for
powerpc.

> cheers
>

-- 
Cheers
~ Vaibhav
