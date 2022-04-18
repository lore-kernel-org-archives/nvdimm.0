Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48B2A29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:10:40 +0000 (UTC)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IE6bCc031025;
	Mon, 18 Apr 2022 17:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=F2nWhvq2+3uzn1bXyzy+0hpw7AESjVQ/xhUoZ7gi6bM=;
 b=loye6H+HZXjGBTogLXZ5+fU26VoglnORQpd27bqu8nXrmp4+yq7xJ8exsWQ+pTuwv4Os
 /s4ODVCVto+IQICLwkojqkZUzvNbzimHi9tUm/kc8JnbHHSDBC1INfhhuTmGahcbgrv6
 X34GfyMshpdjWfC/pgpURzgMuGoMhb3kDHmdtiQpCqm4I1+jD9H/5zrE51aHyChbw7o1
 Qdk5Cx373VJ810pECh0KNyO4Gip3PJqpced3Vl79mdeFp53xz/RB5mvHlpEJLGHbXt/O
 q+z2d/N1ndf7NWB9vczhwHTd3SXV6EX14Zxfjb6ErsfxW4x6ldrUdf6T/YWseFF6Apcl 5A== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3ffpdxq2k7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IH33DY002629;
	Mon, 18 Apr 2022 17:10:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04ams.nl.ibm.com with ESMTP id 3ffne931d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:10:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IGvnpk54133042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 16:57:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4CDAAE056;
	Mon, 18 Apr 2022 17:10:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0932AAE045;
	Mon, 18 Apr 2022 17:10:32 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 18 Apr 2022 17:10:31 +0000 (GMT)
Subject: [RFC ndctl PATCH 3/9] test: Unload the nfit module during cleanup
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:10:31 -0500
Message-ID: 
 <165030182353.3224737.2306830041576864838.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YJtVsudiLCO04prmBEFDaO43fRiQnuxD
X-Proofpoint-GUID: YJtVsudiLCO04prmBEFDaO43fRiQnuxD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The nfit module which is needed for nfit_test is probed and is never
unloaded. The future patches attempt to load the ndtest modules and
continue the tests for PAPR family. Let there be clean state, so
unload it.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 test/common |    7 +++++++
 test/core.c |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/test/common b/test/common
index d3216a0c..d2cb3f73 100644
--- a/test/common
+++ b/test/common
@@ -31,6 +31,10 @@ if [ -z $TEST_PATH ]; then
 	export TEST_PATH=.
 fi
 
+if [ ! -v NDCTL_TEST_FAMILY ]; then
+	export NDCTL_TEST_FAMILY=INTEL
+fi
+
 # NFIT_TEST_BUS[01]
 #
 NFIT_TEST_BUS0="nfit_test.0"
@@ -111,6 +115,9 @@ _cleanup()
 	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
 	$NDCTL disable-region -b $NFIT_TEST_BUS1 all
 	modprobe -r nfit_test
+	if [ $NDCTL_TEST_FAMILY == "INTEL" ]; then
+		modprobe -r nfit
+	fi
 }
 
 _init()
diff --git a/test/core.c b/test/core.c
index 7b23e258..bc7542aa 100644
--- a/test/core.c
+++ b/test/core.c
@@ -130,8 +130,22 @@ void ndctl_test_module_remove(struct kmod_ctx **ctx, struct kmod_module **mod,
 	if (rc < 0 && rc != -ENOENT) {
 		fprintf(stderr, "couldn't remove module %s\n",
 				    strerror(-rc));
+		kmod_unref(*ctx);
+		return;
 	}
 
+	rc = kmod_module_new_from_name(*ctx, "nfit", mod);
+	if (rc == 0) {
+		int state = kmod_module_get_initstate(*mod);
+
+		if (state > 0) {
+			rc = kmod_module_remove_module(*mod, 0);
+			if (rc < 0) {
+				fprintf(stderr, "couldn't remove module %s\n",
+				    strerror(-rc));
+			}
+		}
+	}
 	kmod_unref(*ctx);
 }
 


