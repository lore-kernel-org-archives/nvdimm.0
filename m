Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB9846AB
	for <nvdimm@lists.linux.dev>; Wed, 16 Mar 2022 03:43:07 +0000 (UTC)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22G2tOpS029133;
	Wed, 16 Mar 2022 03:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YCH0sgojhqkYaZFJmKjhVuCtGejBbAlU/yqsabvjeVc=;
 b=oPeg2Qt13PVEzbVKDk5gKw9A5vMJmYNga9ymSkhgVpxJ0PbNZkJqkPSQKGxtXO6ItSMp
 t8xsCm93yRfbDMZrDrgGwmVMxPaw6GltKDEdPmsf6xgwA9lHOGPB7Qk8z+GSYp0w5mDY
 y6Fyvtg1+7pyA2GCucPcg8Q2Iih3yFvtG9ySDYmJxYWOuDkOTPhShY2bBhO+M0lW4Wum
 QEW5w6WpkHHWv7NJsCmJSnoGU3zo8Y+fFZ1iXKGErJWVJlJC0w/xswDuWXXl1n9LYtY9
 72/5KFXUE6s4HcCSqx9FNkTVIDUUR9d4ixSLRO211M+igL2UHJji/XObgu0INQ+12Iqv +Q== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3eu7hnrn72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 03:43:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22G3XkHP017439;
	Wed, 16 Mar 2022 03:43:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma05fra.de.ibm.com with ESMTP id 3erk58pr1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Mar 2022 03:43:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22G3gwLI24248828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Mar 2022 03:42:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66CE6AE055;
	Wed, 16 Mar 2022 03:42:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBE80AE04D;
	Wed, 16 Mar 2022 03:42:53 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.163.24.100])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Wed, 16 Mar 2022 03:42:53 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Wed, 16 Mar 2022 09:12:51 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH v2] ndctl,daxctl,util/build: Reconcile 'iniparser' dependency
Date: Wed, 16 Mar 2022 09:12:50 +0530
Message-Id: <20220316034250.2792732-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YM5InEwkyewHlrD5YBmnojQdD4P40JJD
X-Proofpoint-ORIG-GUID: YM5InEwkyewHlrD5YBmnojQdD4P40JJD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_01,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 mlxlogscore=986 spamscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160021

This trivial patch updates 'meson.build' files for daxctl, ndctl to remove
explicit dependency on 'iniparser'. Instead util/meson.build is updated to add a
dependency to 'iniparser' which than gets trickled to daxctl, ndctl via 'util_dep'
dependency.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog:

v2..v1:
- Spell fix in patch description [ Vishal ]
---
 daxctl/meson.build | 1 -
 ndctl/meson.build  | 1 -
 util/meson.build   | 1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/daxctl/meson.build b/daxctl/meson.build
index ec2e2b648d40..8474d02f2c0d 100644
--- a/daxctl/meson.build
+++ b/daxctl/meson.build
@@ -15,7 +15,6 @@ daxctl_tool = executable('daxctl',
   dependencies : [
     daxctl_dep,
     ndctl_dep,
-    iniparser,
     util_dep,
     uuid,
     kmod,
diff --git a/ndctl/meson.build b/ndctl/meson.build
index 6a3d0e5348c2..c7889af36084 100644
--- a/ndctl/meson.build
+++ b/ndctl/meson.build
@@ -27,7 +27,6 @@ deps = [
   uuid,
   kmod,
   json,
-  iniparser,
   versiondep,
 ]
 
diff --git a/util/meson.build b/util/meson.build
index 784b27915649..695037a924b9 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -11,6 +11,7 @@ util = static_library('util', [
   'abspath.c',
   'iomem.c',
   ],
+  dependencies: iniparser,
   include_directories : root_inc,
 )
 util_dep = declare_dependency(link_with : util)

base-commit: dd58d43458943d20ff063850670bf54a5242c9c5
-- 
2.35.1

