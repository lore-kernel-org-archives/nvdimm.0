Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192E8A29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:15:09 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IF4RVj026791;
	Mon, 18 Apr 2022 17:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AdElIX/VP8uC7o2Bh7lNtVEQZv3EbvUgi2toCabkMfE=;
 b=RAoYFUd28ubS/6z5tO5qBezB8bKfnnacog8AaK4fYPWlpsUrPZEQFTwpbxGic6/ElEdT
 YlYplCDIzyGWf3fAd6tnRxCNa166JTNLd+UHbBcd4Kaj0gp+QbTIAkotuvYjL+c/8wAc
 4z1jN/7lAAJMV3SVpfW3jLZApdrA93dwT3kLgJVPSlucqAhJH87p8TgkqpuHSjyHIaCX
 2YrPDkWYwaur5F1cB+iFzas74L64IZ9lIQHgFHjA/qnjAfSX4bC19nURKrLG3lF0AVNl
 swLV3Xvv4+bQgooIVDHvWTCSWZn5DkGhr/nnIzW3yS4kthwrztpRDq1S7jJm+2mdgks4 lA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3fg791hnb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:15:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IHD5Z2025974;
	Mon, 18 Apr 2022 17:15:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma03ams.nl.ibm.com with ESMTP id 3ffne8k1q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:15:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHF2ML20513160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:15:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C6D552057;
	Mon, 18 Apr 2022 17:15:02 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9468E52051;
	Mon, 18 Apr 2022 17:15:01 +0000 (GMT)
Subject: [ndctl v3 PATCH 7/9] test/libndctl: Enable libndctl tests on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:15:00 -0500
Message-ID: 
 <165030187808.3224737.13924358944848090966.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s5wTJgl3KwaeadcIwLvzUHoOPRaXxxOv
X-Proofpoint-GUID: s5wTJgl3KwaeadcIwLvzUHoOPRaXxxOv
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=979 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The ndtest/papr dsm don't have the smart threshold payloads defined
and various smart fields like media/ctrl temperatures, spares etc.

Test only whats relevant and disable/skip the rest.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

---

Depends on the kernel patch -
https://patchwork.kernel.org/project/linux-nvdimm/patch/165027233876.3035289.4353747702027907365.stgit@lep8c.aus.stglabs.ibm.com/

Changelog:

Since v2:
Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/163102901146.260256.6712219128280188987.stgit@99912bbcb4c7/
* Split the patch into libndctl test specific changes.
* Rebased to use the global ndctl_test_family variable

Since v1:
Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/162737350565.3944327.6662473656483436466.stgit@lep8c.aus.stglabs.ibm.com/
* Updated the commit message description

 test/libndctl.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 test/skip_PAPR.js |    3 +--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index a70c1ed7..15c47211 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2075,6 +2075,46 @@ struct smart {
 		     life_used, shutdown_state, shutdown_count, vendor_size;
 };
 
+static int check_smart_ndtest(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
+			struct check_cmd *check)
+{
+	static const struct smart smart_data = {
+		.flags = ND_SMART_HEALTH_VALID | ND_SMART_SHUTDOWN_VALID
+			| ND_SMART_SHUTDOWN_COUNT_VALID | ND_SMART_USED_VALID,
+		.health = ND_SMART_NON_CRITICAL_HEALTH,
+		.life_used = 5,
+		.shutdown_state = 0,
+		.shutdown_count = 42,
+		.vendor_size = 0,
+	};
+	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart(dimm);
+	int rc;
+
+	if (!cmd) {
+		fprintf(stderr, "%s: dimm: %#x failed to create cmd\n",
+				__func__, ndctl_dimm_get_handle(dimm));
+		return -ENXIO;
+	}
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0) {
+		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
+			__func__, ndctl_dimm_get_handle(dimm), rc);
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	__check_smart(dimm, cmd, flags, -1);
+	__check_smart(dimm, cmd, health, -1);
+	__check_smart(dimm, cmd, life_used, -1);
+	__check_smart(dimm, cmd, shutdown_state, -1);
+	__check_smart(dimm, cmd, shutdown_count, -1);
+	__check_smart(dimm, cmd, vendor_size, -1);
+
+	check->cmd = cmd;
+	return 0;
+}
+
 static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
 {
@@ -2299,6 +2339,11 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 
 	unsigned int i, rc = 0;
 
+	if (ndctl_test_family == NVDIMM_FAMILY_PAPR) {
+		dimm_commands &= ~(1 << ND_CMD_SMART_THRESHOLD);
+		__check_dimm_cmds[ND_CMD_SMART].check_fn = &check_smart_ndtest;
+	}
+
 	/*
 	 * The kernel did not start emulating v1.2 namespace spec smart data
 	 * until 4.9.
diff --git a/test/skip_PAPR.js b/test/skip_PAPR.js
index 367257c4..ec967c98 100644
--- a/test/skip_PAPR.js
+++ b/test/skip_PAPR.js
@@ -26,8 +26,7 @@
  "dm.sh",		//		""
  "mmap.sh",		//		""
  "monitor.sh",		// To be fixed
- "inject-smart.sh",	//    ""
- "libndctl"		//    ""
+ "inject-smart.sh"	//    ""
 ]
 
 // NOTE: The libjson-c doesn't like comments in json files, so keep the file


