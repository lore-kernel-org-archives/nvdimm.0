Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CEC1844
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 06:04:51 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F4K3Hl017225;
	Tue, 15 Mar 2022 06:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rKSVNCaYuOZgV2y3GRkelYT+BqWq1qZRharLoaang8I=;
 b=kaZJ9GdTiVNx9rNRmkRyQtM9ES6p1GVc3SQn5nLgAAWYpgsmOWEjv8aFagarAYTUdy40
 kgj8Jf3oSAVDs4dkByLdIO9LiDx0rVwTU5UD87DZYQ1lQSTMTwgicKU8QZjaOmkeXeb4
 kXlJLxvb4abeDo576+aywDBI+6Z2+wdk0jstAllYZSzabmwneJ3b8H4OvTQes8YLSGNM
 EFjTeAxD4aB/v5Mv0LaT2cip8TP0Kb6uQCH8OcFI8C+q/84wuXifXV3J/+ceS0r440wW
 H11FT6Y0luSCenu+AN+qBPa7Oqk5jWgly5C1r213rgJpWPXeyXzLPmWb7FzvebmZhQMN RA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3etkp89mew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 06:04:44 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
	by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22F5v7Tq004475;
	Tue, 15 Mar 2022 06:04:42 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by ppma02wdc.us.ibm.com with ESMTP id 3erk59k415-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 06:04:42 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22F64fKJ24117604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Mar 2022 06:04:41 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCC56AE06A;
	Tue, 15 Mar 2022 06:04:41 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 918C6AE064;
	Tue, 15 Mar 2022 06:04:38 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.43.0.220])
	by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
	Tue, 15 Mar 2022 06:04:38 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH] util/parse: Fix build error on ubuntu
Date: Tue, 15 Mar 2022 11:34:26 +0530
Message-Id: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rn2R7ATVa4_34nAPCbKfrt5whBbRR4sy
X-Proofpoint-GUID: rn2R7ATVa4_34nAPCbKfrt5whBbRR4sy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150039

Fix the below build error on ubuntu:
../util/parse-configs.c:7:10: fatal error: iniparser.h: No such file or directory
    7 | #include <iniparser.h>
      |          ^~~~~~~~~~~~~

The same error is not observed on other OS because they do create symlinks as
below

lrwxrwxrwx. 1 root root 21 Jul 22  2021 /usr/include/iniparser.h -> iniparser/iniparser.h

the error can be avoided by using the correct include path. Also, catch the error
during setup instead of the build by adding the check for meson.build

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 meson.build          | 2 +-
 util/parse-configs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/meson.build b/meson.build
index 42e11aa25cba..a4c4c1cd3df3 100644
--- a/meson.build
+++ b/meson.build
@@ -160,7 +160,7 @@ cc = meson.get_compiler('c')
 
 # keyutils and iniparser lack pkgconfig
 keyutils = cc.find_library('keyutils', required : get_option('keyutils'))
-iniparser = cc.find_library('iniparser', required : true)
+iniparser = cc.find_library('iniparser', required : true, has_headers: 'iniparser/iniparser.h')
 
 conf = configuration_data()
 check_headers = [
diff --git a/util/parse-configs.c b/util/parse-configs.c
index c834a07011e5..1b7ffa69f05f 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -4,7 +4,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
-#include <iniparser.h>
+#include <iniparser/iniparser.h>
 #include <sys/stat.h>
 #include <util/parse-configs.h>
 #include <util/strbuf.h>
-- 
2.35.1

