Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1531E72
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 08:12:23 +0000 (UTC)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R89efZ137143;
	Tue, 27 Jul 2021 04:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=z6PTfYfzjWNTh7wYLjjo6ar7FiPlabnsTbeGjxTtB6Q=;
 b=PU4X+I1ko0cVJqrvpVkP6wODTgA4V/pcA8Wz0JwYraDgQFUubnSB8K99ro/m/2fV1/Kt
 CgCaV2WKbL1lR/jzoPq1C7g2eftZTZd0sAnIDkUSf5fPnl9HuBxWHIyZ7dHZo536Nrhl
 k6kxnSGgu8VqXMUn592q67yYZe8BMEClrZPPOZobFeky7agu3PYuJNpLTRV/j4Fw10KD
 xPBoMYTHeb16tzW40c1bdbWppj/J9Xu6/m/ODD53cNknvp0hScNfZZ/buNaBBob3RFu4
 /Id7Zp/P6g7WreX45JyLYIh5P0ECpE64w1GQaMtd60R2Yrq5OJickmAvH53SNBzewaqu jw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3a2dk9t5u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 04:12:21 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16R8473p005459;
	Tue, 27 Jul 2021 08:12:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma06ams.nl.ibm.com with ESMTP id 3a235kg91f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jul 2021 08:12:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16R8CFTQ26476990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jul 2021 08:12:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECD5A4C05A;
	Tue, 27 Jul 2021 08:12:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7D924C058;
	Tue, 27 Jul 2021 08:12:13 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jul 2021 08:12:13 +0000 (GMT)
Subject: [PATCH 2/3] ndtest/ack-shutdown-count: Skip the test on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        santosh@fossix.org, dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 27 Jul 2021 03:12:12 -0500
Message-ID: 
 <162737351799.3944327.7767640373949819444.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: vitR3qU73-NUSA-D4Mdv0hiCpFh6YM-s
X-Proofpoint-GUID: vitR3qU73-NUSA-D4Mdv0hiCpFh6YM-s
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_05:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270046

The PAPR has non-latched dirty shutdown implementation.
The test is enabling/disabling the LSS latch which is
irrelavent from PAPR pov. Skip the test.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 test/ack-shutdown-count-set.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index c561ff34..17c40e88 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -117,6 +117,7 @@ static int test_ack_shutdown_count_set(int loglevel, struct ndctl_test *test,
 
 int main(int argc, char *argv[])
 {
+	char *test_env = getenv("NDCTL_TEST_FAMILY");
 	struct ndctl_test *test = ndctl_test_new(0);
 	struct ndctl_ctx *ctx;
 	int rc;
@@ -126,6 +127,9 @@ int main(int argc, char *argv[])
 		return EXIT_FAILURE;
 	}
 
+	if (test_env && strcmp(test_env, "PAPR") == 0)
+		return ndctl_test_result(test, 77);
+
 	rc = ndctl_new(&ctx);
 	if (rc)
 		return ndctl_test_result(test, rc);


