Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C07023CC
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 16:47:05 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FGNvoJ028770;
	Tue, 15 Mar 2022 16:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=dgg1+x2vsqxBlHwsXFOcWxt6pCUkEGG/7j+Knk6/VIk=;
 b=G6BMfBoWXdMknqM7C7XGfpkIhot6NlFohZAbeM1KMFMsFjNod76T7+3Poyn+mXCqpsmB
 r0fU5XMRtPXsW9pQhzYf8twv8w38AyxJojUpuZxQG7EB4uiL0mRhmO1TpMYQJG7J9waD
 0Rs8EnLEV1eLWholRnBwdk+Gn3LP+9UM6/4Xqotl4/8KN4ew7FLAo3/M3SCwWWQpFAYk
 nGIBKFO8TU+/wjGLEmcvTYLhmlpzEqU4w5eD76Q4WG638Ca9Orj+cGbBY6xD5ORzkle8
 waJpobiNnN5vH+PisN786vKwsWuSBJmzJlFz2mb3X79VnvV/Xp8acFHF7ytywI3rUoRI yg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3etru2rv41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 16:47:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FGRin4020297;
	Tue, 15 Mar 2022 16:47:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04ams.nl.ibm.com with ESMTP id 3erk58y34r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 16:47:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FGZX0n20578808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Mar 2022 16:35:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 174E15204E;
	Tue, 15 Mar 2022 16:46:59 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.211.32.147])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id E40845204F;
	Tue, 15 Mar 2022 16:46:55 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 15 Mar 2022 22:16:53 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] util/parse: Fix build error on ubuntu
In-Reply-To: <87v8wfcyht.fsf@linux.ibm.com>
References: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
 <874k3zd27b.fsf@vajain21.in.ibm.com> <87v8wfcyht.fsf@linux.ibm.com>
Date: Tue, 15 Mar 2022 22:16:53 +0530
Message-ID: <87zglrb1tu.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 65utecPOshpWkZHe9zMKclai8T6-oICJ
X-Proofpoint-GUID: 65utecPOshpWkZHe9zMKclai8T6-oICJ
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150103

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> Vaibhav Jain <vaibhav@linux.ibm.com> writes:
>
>> Second hunk of this diff seems to be a revert of [1]  which might
>> break the ndctl build on Arch Linux.
>>
>> AFAIS for Centos/Fedora/RHEL etc the iniparser.h file is present in the
>> default include path('/usr/include') as a softlink to
>> '/usr/include/iniparser/iniparser.h' . Ubuntu/Debian seems to an
>> exception where path '/usr/include/iniparser.h' is not present.
>>
>> I guess thats primarily due to no 'make install' target available in
>> iniparser makefiles [1] that fixes a single include patch. This may have led
>> to differences across distros where to place these header files.
>>
>> I would suggest changing to this in meson.build to atleast catch if the
>> iniparser.h is not present at the expected path during meson setup:
>>
>>     iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser.h')
>>
>> [1] addc5fd8511('Fix iniparser.h include')
>> [2] https://github.com/ndevilla/iniparser/blob/master/Makefile
>
>
> We can do this.
>
> diff --git a/config.h.meson b/config.h.meson
> index 2852f1e9cd8b..b070df96cf4a 100644
> --- a/config.h.meson
> +++ b/config.h.meson
> @@ -82,6 +82,9 @@
>  /* Define to 1 if you have the <unistd.h> header file. */
>  #mesondefine HAVE_UNISTD_H
>  
> +/* Define to 1 if you have the <iniparser/iniparser.h> header file. */
> +#mesondefine HAVE_INIPARSER_INCLUDE_H
> +
>  /* Define to 1 if using libuuid */
>  #mesondefine HAVE_UUID
>  
> diff --git a/meson.build b/meson.build
> index 42e11aa25cba..893f70c22270 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -176,6 +176,7 @@ check_headers = [
>    ['HAVE_SYS_STAT_H', 'sys/stat.h'],
>    ['HAVE_SYS_TYPES_H', 'sys/types.h'],
>    ['HAVE_UNISTD_H', 'unistd.h'],
> +  ['HAVE_INIPARSER_INCLUDE_H', 'iniparser/iniparser.h'],
>  ]
>  
>  foreach h : check_headers
> diff --git a/util/parse-configs.c b/util/parse-configs.c
> index c834a07011e5..8bdc9d18cbf3 100644
> --- a/util/parse-configs.c
> +++ b/util/parse-configs.c
> @@ -4,7 +4,11 @@
>  #include <dirent.h>
>  #include <errno.h>
>  #include <fcntl.h>
> +#ifdef HAVE_INIPARSER_INCLUDE_H
> +#include <iniparser/iniparser.h>
> +#else
>  #include <iniparser.h>
> +#endif
>  #include <sys/stat.h>
>  #include <util/parse-configs.h>
>  #include <util/strbuf.h>

Agree, above patch can fix this issue. Though I really wanted to avoid
trickling changes to the parse-configs.c since the real problem is with
non consistent location for iniparser.h header across distros.

I gave it some thought and came up with this patch to meson.build that can
pick up appropriate '/usr/include' or '/usr/include/iniparser' directory
as include path to the compiler.

Also since there seems to be no standard location for this header file
I have included a meson build option named 'iniparser-includedir' that
can point to the dir where 'iniparser.h' can be found.

diff --git a/meson.build b/meson.build
index 42e11aa25cba..8c347e64ca2d 100644
--- a/meson.build
+++ b/meson.build
@@ -158,9 +158,27 @@ endif
 
 cc = meson.get_compiler('c')
 
-# keyutils and iniparser lack pkgconfig
+# keyutils lack pkgconfig
 keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
-iniparser = cc.find_library('iniparser', required : true)
+
+# iniparser lacks pkgconfig and its header files are either at '/usr/include' or '/usr/include/iniparser'
+# First use the path provided by user via meson configure -Diniparser-includedir=<somepath>
+# if thats not provided than try searching for 'iniparser.h' in default system include path
+# and if that not found than as a last resort try looking at '/usr/include/iniparser'
+
+if get_option('iniparser-includedir') == ''
+  iniparser = cc.find_library('iniparser', required : false, has_headers : 'iniparser.h')
+  # if not available at the default path try '/usr/include/iniparser'
+  if not iniparser.found()
+    iniparser = cc.find_library('iniparser', required : true, has_headers : 'iniparser/iniparser.h')
+    iniparser = declare_dependency(include_directories:'/usr/include/iniparser', dependencies:iniparser)
+  endif
+else
+  iniparser_incdir = include_directories(get_option('iniparser-includedir'))
+  iniparser = cc.find_library('iniparser', required : true, has_headers : 'iniparser.h',
+                                            header_include_directories:iniparser_incdir)
+  iniparser = declare_dependency(include_directories:iniparser_incdir, dependencies:iniparser)
+endif
 
 conf = configuration_data()
 check_headers = [
diff --git a/meson_options.txt b/meson_options.txt
index aa4a6dc8e12a..d08151691553 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -23,3 +23,5 @@ option('pkgconfiglibdir', type : 'string', value : '',
        description : 'directory for standard pkg-config files')
 option('bashcompletiondir', type : 'string',
        description : '''${datadir}/bash-completion/completions''')
+option('iniparser-includedir', type : 'string',
+       description : '''Path containing the iniparser header files''')


-- 
Cheers
~ Vaibhav
