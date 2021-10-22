Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FB872
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 17:47:37 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MGIF5d018205;
	Fri, 22 Oct 2021 13:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=z6PTfYfzjWNTh7wYLjjo6ar7FiPlabnsTbeGjxTtB6Q=;
 b=DB27pn/kPOh1fIKoOrc71VyR1zJYu6UYTRefQJIvMbcps2y3uMN/ylXOfwSNPytm+mOm
 +I4IN8pNMdAwe8Jnspwa4Y6VBou2x3mEoubHDlrnCU7UBr0Ge5Y669jmKSJo33e20Wy1
 spU7YYLmYHFSPointoRJtebSc8TRtlykdYcgxn1NaairvuSkC3kzL/EwT8yn5CltqTl/
 r5oeSxe5e3WqQhk9mWUB+HRY+9y++WBpS5T8cpkzt/DfIOZdpkZBHMbUuShkOqSXtZ0c
 fsRU8gbXg7ki126sgIuduN/odSCuOwFwpto2dMtnMNnpIcxOccnyAJXM+Fv7B4BtiUMy bg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3bv0q0sjv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 13:47:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MHgQTD024756;
	Fri, 22 Oct 2021 17:47:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma04ams.nl.ibm.com with ESMTP id 3bqpcbjjqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Oct 2021 17:47:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MHlUtA56623466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Oct 2021 17:47:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DA88A4062;
	Fri, 22 Oct 2021 17:47:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 492F0A4060;
	Fri, 22 Oct 2021 17:47:29 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 22 Oct 2021 17:47:29 +0000 (GMT)
Subject: [REPOST PATCH v2 2/3] ndtest/ack-shutdown-count: Skip the test on
 ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Fri, 22 Oct 2021 12:47:28 -0500
Message-ID: 
 <163492484311.1652625.9312602046612226571.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: 
 <163492481743.1652625.4203942321686969839.stgit@lep8c.aus.stglabs.ibm.com>
References: 
 <163492481743.1652625.4203942321686969839.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: 59ofJdn36BsN9672GXzm4wcExljjBmy2
X-Proofpoint-GUID: 59ofJdn36BsN9672GXzm4wcExljjBmy2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_04,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220101

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


