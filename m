Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4EB23B5
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 16:27:00 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FGESTK022694;
	Tue, 15 Mar 2022 16:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=y7x4qs4U11z99k32oj4GsRV50ijDNEA0rG5lQp44qcA=;
 b=eCOVXPG4wE5ltbrnIqKeT3KY/uG6qmnKQgtSe1b9REBzia6xkwmbSt9uZEe8eGsl4dxv
 nAobxOgpnnMKxeSD0qgBGcp0BJGBdXrP693wLRONoMNtHRFnA+DECV+o1d61ItmduaTx
 kIqcN5JY4HSFONdtSoEpRt/Qneai2eiuOsoVOHO42TWdWus7bdsVsbmvf6R4da+uXCtw
 ws3AVonwMSE8N3cLZm5OkNDKbXxEO05pJjtU1UxsJKUK+3GP+XVjXzxfnnc9bfKG6GPV
 avurNrA03JgyxZU2XRLE875GPoOdlgXWpJsXyKo1UImigkN1YrT4YcPP9PyLzIfOKlws IQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajna29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 16:26:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FGNGpb015270;
	Tue, 15 Mar 2022 16:26:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma06ams.nl.ibm.com with ESMTP id 3erjshq2px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Mar 2022 16:26:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FGQqWP42270980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Mar 2022 16:26:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0284A5204E;
	Tue, 15 Mar 2022 16:26:52 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.211.32.147])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 8B3E652050;
	Tue, 15 Mar 2022 16:26:47 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 15 Mar 2022 21:56:45 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Subject: [ndctl PATCH] ndctl,daxctl,util/build: Reconcile 'iniparser' dependency
Date: Tue, 15 Mar 2022 21:56:41 +0530
Message-Id: <20220315162641.2778960-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kmUkj05b-H4L4G5sEn49M8EdmkbOUsYf
X-Proofpoint-GUID: kmUkj05b-H4L4G5sEn49M8EdmkbOUsYf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=785 impostorscore=0 adultscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150102

This trivial patch updates 'meson.build' files for daxctl, ndctl to remove
explicit dependency on 'iniparser'. Instead util/meson.build is updated to add a
dependency to 'iniparser' which than get tricked to daxctl, ndctl via 'util_dep'
dependency.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
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

