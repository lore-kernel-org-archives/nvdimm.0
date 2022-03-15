Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2441FA1
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 09:23:13 +0000 (UTC)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F8JsxN030599;
	Tue, 15 Mar 2022 08:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=ahBFhmLZvFLDFTz8Iw8Oeeye0KhytFveVGf4jLSJdew=;
 b=KRD7Ltd5RZmSypILlYH794+/N1wsn4uiOnF46/awdjd/FzXPOiyn9gKuH7WLm6SagVeN
 TZUl6/Gt2hBCFSRgLNvZqDc1WMdGF8HRVFQRrPwjDMgv8f7KOavAo5LnH2eGv0sRataX
 sM+qinZOQDUPm+/WlIl/WUyeY+3LB+uGh6R8LldST+XQ7+I+QK1iLSH+18q/IALgIY7p
 BDhc9qWsdTeL2oOnCfYjqbOBTJeBSAN6dbNhLJyb/io7iZLOaDIo/iH2X2cgEvCeBHC4
 Mt/s9oSv2FvA/0atj7i27BGivDfvwk5lY5uf/0es9qw0+iLghye1rwPfJ7437vAzwFs6 Vg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3etq6s8kus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 08:56:02 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22F8rDLD015018;
	Tue, 15 Mar 2022 08:56:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3erk58x3sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 08:56:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22F8u0BI32637426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Mar 2022 08:56:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8964C11C050;
	Tue, 15 Mar 2022 08:55:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF7BB11C04C;
	Tue, 15 Mar 2022 08:55:54 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.211.32.147])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Tue, 15 Mar 2022 08:55:54 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 15 Mar 2022 14:25:52 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] util/parse: Fix build error on ubuntu
In-Reply-To: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
References: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
Date: Tue, 15 Mar 2022 14:25:52 +0530
Message-ID: <874k3zd27b.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xnXI4dRnu9VE3_sc-c5Hv9JYN7gwV22r
X-Proofpoint-ORIG-GUID: xnXI4dRnu9VE3_sc-c5Hv9JYN7gwV22r
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150055


Second hunk of this diff seems to be a revert of [1]  which might
break the ndctl build on Arch Linux.

AFAIS for Centos/Fedora/RHEL etc the iniparser.h file is present in the
default include path('/usr/include') as a softlink to
'/usr/include/iniparser/iniparser.h' . Ubuntu/Debian seems to an
exception where path '/usr/include/iniparser.h' is not present.

I guess thats primarily due to no 'make install' target available in
iniparser makefiles [1] that fixes a single include patch. This may have led
to differences across distros where to place these header files.

I would suggest changing to this in meson.build to atleast catch if the
iniparser.h is not present at the expected path during meson setup:

    iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser.h')

[1] addc5fd8511('Fix iniparser.h include')
[2] https://github.com/ndevilla/iniparser/blob/master/Makefile

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> Fix the below build error on ubuntu:
> ../util/parse-configs.c:7:10: fatal error: iniparser.h: No such file or directory
>     7 | #include <iniparser.h>
>       |          ^~~~~~~~~~~~~
>
> The same error is not observed on other OS because they do create symlinks as
> below
>
> lrwxrwxrwx. 1 root root 21 Jul 22  2021 /usr/include/iniparser.h -> iniparser/iniparser.h
>
> the error can be avoided by using the correct include path. Also, catch the error
> during setup instead of the build by adding the check for meson.build
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  meson.build          | 2 +-
>  util/parse-configs.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/meson.build b/meson.build
> index 42e11aa25cba..a4c4c1cd3df3 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -160,7 +160,7 @@ cc = meson.get_compiler('c')
>  
>  # keyutils and iniparser lack pkgconfig
>  keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
> -iniparser = cc.find_library('iniparser', required : true)
> +iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser/iniparser.h')
>  
>  conf = configuration_data()
>  check_headers = [
> diff --git a/util/parse-configs.c b/util/parse-configs.c
> index c834a07011e5..1b7ffa69f05f 100644
> --- a/util/parse-configs.c
> +++ b/util/parse-configs.c
> @@ -4,7 +4,7 @@
>  #include <dirent.h>
>  #include <errno.h>
>  #include <fcntl.h>
> -#include <iniparser.h>
> +#include <iniparser/iniparser.h>
>  #include <sys/stat.h>
>  #include <util/parse-configs.h>
>  #include <util/strbuf.h>
> -- 
> 2.35.1
>
>

-- 
Cheers
~ Vaibhav
