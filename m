Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230381FA1
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 10:16:10 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F9LCg0013864;
	Tue, 15 Mar 2022 10:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=m/oBcVhsBdIrS2ml7mPfQczPhjBj1bEzCVSf88Pufpw=;
 b=tj0R+R59CNRA+46kSdOGMZ8oBFIFJ9OH2XqzXbq3TQgpuo6XpOeiO1yDEiHXK6iAAK9K
 fyP4QbJa+/AlKaSIVQgG1Rj8U749UTd5iiXsNgJzfjuZV8ovEwj5LSl0nQxMePkSGTPT
 nfqVY6vKXqibmsnK20imO051sPo8t72i+g/wWGl8bCY6C7E6a6VDerQUwoSO2v9Zm247
 fLzkYY57/p90rtAdRb3ct3Yh5bVyrwUMmssSpjvI1zHbgro2C+gvTi52DY1PVwVrkPAK
 I6rkeQDeyttQT0+i2qXZCo98M+955+NGG86sEkvDWOnT3FRwwYa3+Hlgj7tbGxZflTQC GA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3etmvfcs6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 10:16:08 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
	by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FA5Gja001561;
	Tue, 15 Mar 2022 10:16:07 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by ppma04wdc.us.ibm.com with ESMTP id 3erk59mc4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 10:16:07 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FAG6DS14942676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Mar 2022 10:16:06 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DD35C6055;
	Tue, 15 Mar 2022 10:16:06 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21B4EC605D;
	Tue, 15 Mar 2022 10:16:04 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.43.0.220])
	by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
	Tue, 15 Mar 2022 10:16:03 +0000 (GMT)
X-Mailer: emacs 29.0.50 (via feedmail 11-beta-1 I)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] util/parse: Fix build error on ubuntu
In-Reply-To: <874k3zd27b.fsf@vajain21.in.ibm.com>
References: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
 <874k3zd27b.fsf@vajain21.in.ibm.com>
Date: Tue, 15 Mar 2022 15:45:58 +0530
Message-ID: <87v8wfcyht.fsf@linux.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v8s8E6_gMD2WsP3CU1Y-ELuUPDPs01fU
X-Proofpoint-ORIG-GUID: v8s8E6_gMD2WsP3CU1Y-ELuUPDPs01fU
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_01,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=893 bulkscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150066

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Second hunk of this diff seems to be a revert of [1]  which might
> break the ndctl build on Arch Linux.
>
> AFAIS for Centos/Fedora/RHEL etc the iniparser.h file is present in the
> default include path('/usr/include') as a softlink to
> '/usr/include/iniparser/iniparser.h' . Ubuntu/Debian seems to an
> exception where path '/usr/include/iniparser.h' is not present.
>
> I guess thats primarily due to no 'make install' target available in
> iniparser makefiles [1] that fixes a single include patch. This may have led
> to differences across distros where to place these header files.
>
> I would suggest changing to this in meson.build to atleast catch if the
> iniparser.h is not present at the expected path during meson setup:
>
>     iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser.h')
>
> [1] addc5fd8511('Fix iniparser.h include')
> [2] https://github.com/ndevilla/iniparser/blob/master/Makefile


We can do this.

diff --git a/config.h.meson b/config.h.meson
index 2852f1e9cd8b..b070df96cf4a 100644
--- a/config.h.meson
+++ b/config.h.meson
@@ -82,6 +82,9 @@
 /* Define to 1 if you have the <unistd.h> header file. */
 #mesondefine HAVE_UNISTD_H
 
+/* Define to 1 if you have the <iniparser/iniparser.h> header file. */
+#mesondefine HAVE_INIPARSER_INCLUDE_H
+
 /* Define to 1 if using libuuid */
 #mesondefine HAVE_UUID
 
diff --git a/meson.build b/meson.build
index 42e11aa25cba..893f70c22270 100644
--- a/meson.build
+++ b/meson.build
@@ -176,6 +176,7 @@ check_headers = [
   ['HAVE_SYS_STAT_H', 'sys/stat.h'],
   ['HAVE_SYS_TYPES_H', 'sys/types.h'],
   ['HAVE_UNISTD_H', 'unistd.h'],
+  ['HAVE_INIPARSER_INCLUDE_H', 'iniparser/iniparser.h'],
 ]
 
 foreach h : check_headers
diff --git a/util/parse-configs.c b/util/parse-configs.c
index c834a07011e5..8bdc9d18cbf3 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -4,7 +4,11 @@
 #include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
+#ifdef HAVE_INIPARSER_INCLUDE_H
+#include <iniparser/iniparser.h>
+#else
 #include <iniparser.h>
+#endif
 #include <sys/stat.h>
 #include <util/parse-configs.h>
 #include <util/strbuf.h>
