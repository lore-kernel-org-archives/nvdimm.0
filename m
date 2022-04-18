Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794FBA29
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 17:19:37 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IFTjca029938;
	Mon, 18 Apr 2022 17:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Y2lrYGiJZJ4T/KOxbN/w0LFjWIn2VAB+XKuT+3drux0=;
 b=QnJZT4RNZ/fhgA0BvKNmfMGFYz/UFTSapXUGKW4hK1VlEcbI/kHOnjzCS7gk3Ctiaumi
 M20hGXKw98xwrqgRx8PMsvlO+6SK+M1keZI5lBjeCnv9P3xdi3GshSfWKZ1zRpmd7TR0
 XEzM3DgVvOu2YGq/DAVJ44xsjOs013l8x3vPTEh5m0jpBzoASR5YVeMthpn/V+aFRcXh
 iQC+iGyxGMC/kMhs0IFA3EeyiVQgpXwfVOCE71odjah4VEb6WpnsKTcKE/X4N5Pc4qJp
 JdjqcaK4kRo6H30OnxY1Jd0XFFM5UidpI/d8KZH2i0wrQZNpDqEXrMRnaxJQmFhiorin 9w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3fg7fjsusb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:19:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23IHCrGa025948;
	Mon, 18 Apr 2022 17:19:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03ams.nl.ibm.com with ESMTP id 3ffne8k1tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Apr 2022 17:19:32 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23IHJOeX55837060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Apr 2022 17:19:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B9F25204F;
	Mon, 18 Apr 2022 17:19:24 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6BDD85204E;
	Mon, 18 Apr 2022 17:19:23 +0000 (GMT)
Subject: [ndctl v3 PATCH 9/9] test/monitor.sh: Partially skip monitor test on
 ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com
Date: Mon, 18 Apr 2022 12:19:22 -0500
Message-ID: 
 <165030225848.3224737.13035309277759398287.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <165030175745.3224737.6985015146263991065.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/1.1+40.g1b20
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TpzcVgjtApFEEEcR_KsQ4sswlJBv9EbL
X-Proofpoint-ORIG-GUID: TpzcVgjtApFEEEcR_KsQ4sswlJBv9EbL
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 impostorscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180101

The ndtest/papr pdsm has the unclean shutdown inject support.
Rest of the tests in monitor.sh are injecting temperature,
spares with thresholds and monitoring on them. These test cases
are irrelevant on papr, skip them.

Its convenient/cleaner to reorder the tests than selectively
adding test environment checks for each of the tests. So,
reordering to call the dimm events test first.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>

---

Depends on the kernel patch posted at -
https://patchwork.kernel.org/project/linux-nvdimm/patch/165027233876.3035289.4353747702027907365.stgit@lep8c.aus.stglabs.ibm.com/
Depends on the ndctl monitor regression fix patch posted at -
https://patchwork.kernel.org/project/linux-nvdimm/patch/164750955519.2000193.16903542741359443926.stgit@LAPTOP-TBQTPII8/

Changelog:

Since v2:
Link: https://patchwork.kernel.org/project/linux-nvdimm/patch/163102905777.260256.5004593912307267155.stgit@99912bbcb4c7/
* Removing the entry from skip file as the test works on ndtest with the
  patch

 test/monitor.sh   |   11 ++++++++++-
 test/skip_PAPR.js |    3 +--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index 10e65374..7c5d316d 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -136,6 +136,10 @@ test_filter_dimmevent()
 	check_result "$monitor_dimms"
 	stop_monitor
 
+	if [ $NDCTL_TEST_FAMILY == "PAPR" ]; then
+		return
+	fi
+
 	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."spares_threshold")
 	inject_value=$((inject_value - 1))
 	start_monitor "-d $monitor_dimms -D dimm-spares-remaining"
@@ -153,12 +157,17 @@ test_filter_dimmevent()
 
 do_tests()
 {
+	test_filter_dimmevent
+
+	if [ $NDCTL_TEST_FAMILY == "PAPR" ]; then
+		return
+	fi
+
 	test_filter_dimm
 	test_filter_bus
 	test_filter_region
 	test_filter_namespace
 	test_conf_file
-	test_filter_dimmevent
 }
 
 _init
diff --git a/test/skip_PAPR.js b/test/skip_PAPR.js
index 97ceda82..52bb5f33 100644
--- a/test/skip_PAPR.js
+++ b/test/skip_PAPR.js
@@ -24,8 +24,7 @@
  "revoke_devmem",	//		""
  "align.sh",		//		""
  "dm.sh",		//		""
- "mmap.sh",		//		""
- "monitor.sh"		// To be fixed
+ "mmap.sh"		//		""
 ]
 
 // NOTE: The libjson-c doesn't like comments in json files, so keep the file


