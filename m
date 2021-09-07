Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187DC72
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 15:38:05 +0000 (UTC)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187FYcTY182850;
	Tue, 7 Sep 2021 11:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=b2V2wcDU65RED1OelQ+XajOZAmLDefrZ082+h5fwr10=;
 b=dTzwNlJJFR5HyXx5wJq7YP2B4YoMGkSkpUU7N8wG3/Lb7ILhHHdrp1MoEdQiU3jL1xw4
 5K1rDdMHdDMueA+WjSMquKcr39dScoG7P4GNynz04sCVmenzMvYpQKw5aAhY74gyuv1O
 TZSh9W6yuK++VWWckYT8pyvAVRAFwzrqCF8U3sdbEIpAnLLsgUKCPr0D3arXl5Sr6091
 Xw8XMWui3oAkd5sagonqeakZ1M6lL3mZFUihMduPUlCa9YRnH8YBVfnaJ3w1BxV1oTTT
 1afvRMjiz3tWHVEVwwr46BiIMICRIZWA6LwvQGYa00Fg4TVR3zxO59jiiJHps+7l8oPp Xw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3aww7auqd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 11:38:03 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187FS35F026991;
	Tue, 7 Sep 2021 15:38:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma05fra.de.ibm.com with ESMTP id 3av0e98gg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 15:38:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187FbwPO41419250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 15:37:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAA43A4066;
	Tue,  7 Sep 2021 15:37:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC8CFA4054;
	Tue,  7 Sep 2021 15:37:56 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 15:37:56 +0000 (GMT)
Subject: [PATCH v2 3/3] test/monitor.sh: Partially skip monitor test on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 15:37:55 +0000
Message-ID: <163102905777.260256.5004593912307267155.stgit@99912bbcb4c7>
In-Reply-To: <163102900429.260256.4127745415928272196.stgit@99912bbcb4c7>
References: <163102900429.260256.4127745415928272196.stgit@99912bbcb4c7>
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
X-Proofpoint-ORIG-GUID: oqUT6UQLD40WQpwdq7MMqEJP-3tmf09O
X-Proofpoint-GUID: oqUT6UQLD40WQpwdq7MMqEJP-3tmf09O
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_05:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070099

The ndtest/papr pdsm has the unclean shutdown inject support.
Rest of the tests in monitor.sh are injecting temperature,
spares with thresholds and monitoring on them. These test cases
are irrelavent on papr, skip them.

Its convenient/cleaner to reorder the tests than selectively
adding test environment checks for each of the tests. So,
reordering to call the dimm events test first.

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


