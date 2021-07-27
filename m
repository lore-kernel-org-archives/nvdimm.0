Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187AA72
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 08:12:33 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R86nmY013776;
	Tue, 27 Jul 2021 04:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Nc0ifOUYXrvadp9KTM5lZlE0jzf8qOn7WyUVTeD+9QM=;
 b=N+LTdPCJAdo8s6bLwYa2fhFHrUkVt2PeoMjzfrFKwq6YoT+bOeKn1q1lsiUZJVN+NdPV
 17/lPT3EMm+bmCJ1dPwtMc2D4XxU86TiuVJ6LSzlzWCSNVTz1Ck+Ix27Kiy+Gr30zdWH
 BbMqxfYozRhSSzFLPH7X3m5M1IUDPJJRzBt1exodkY+EvfV+IZhnyfprYRNmNVghKlMF
 BI5MxZsmu2v/Uap/iju1x4Q/ziUu1LDn+5SfCvHGJlTMFLySN6u/HcnU2UDb9J7xxkIm
 b3gGdZMAn4V62e6YKFE9iGaPW+DXgV1b0YPtSGKj4894yL1/D6FPS9oWI7j6aGpjm0Tu +A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a2d542vfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 04:12:30 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R83mXp016919;
	Tue, 27 Jul 2021 08:12:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma03ams.nl.ibm.com with ESMTP id 3a235yg8ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 08:12:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R8CP2G28639686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 08:12:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0647111C066;
	Tue, 27 Jul 2021 08:12:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C259D11C04A;
	Tue, 27 Jul 2021 08:12:23 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jul 2021 08:12:23 +0000 (GMT)
Subject: [PATCH 3/3] test/monitor.sh: Partially skip monitor test on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        santosh@fossix.org, dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 27 Jul 2021 03:12:22 -0500
Message-ID: 
 <162737354018.3944327.1169429056790170660.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <162737349828.3944327.12958894438783947695.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: XjyCxs7IElDdCqlFJFHtVZCmTdNcFjaA
X-Proofpoint-GUID: XjyCxs7IElDdCqlFJFHtVZCmTdNcFjaA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_05:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270046

The ndtest/papr pdsm has the unclean shutdown inject support.
Rest of the tests in monitor.sh are injecting temperature,
spares with thresholds and monitoring on them. These test cases
are irrelavent on ndtest, skip them.

Reorders the code to call the dimm events test first for
cleanliness.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 test/monitor.sh |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/test/monitor.sh b/test/monitor.sh
index 28c55415..b78ed093 100755
--- a/test/monitor.sh
+++ b/test/monitor.sh
@@ -143,6 +143,10 @@ test_filter_dimmevent()
 	check_result "$monitor_dimms"
 	stop_monitor
 
+	if [ $NDCTL_TEST_FAMILY == "PAPR" ]; then
+		return
+	fi
+
 	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."spares_threshold")
 	inject_value=$((inject_value - 1))
 	start_monitor "-d $monitor_dimms -D dimm-spares-remaining"
@@ -160,12 +164,17 @@ test_filter_dimmevent()
 
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
 
 modprobe nfit_test


