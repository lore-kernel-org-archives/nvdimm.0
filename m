Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495672
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 15:37:40 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187FXG3H068951;
	Tue, 7 Sep 2021 11:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=z6PTfYfzjWNTh7wYLjjo6ar7FiPlabnsTbeGjxTtB6Q=;
 b=guDSeM5AJvNFVCien4y1tlswZ+MigF96JBjigcl4x41HJugTfGEDWFed7vo4t4dpOcdk
 N1lW1+OwXU3tzREd5cqHdwYhtK8OBXIO/B+980yf+pM0S/A5XdEpvVg+fAA2XqFRa5Ar
 3HNlfF41pVFqnwIwTdWiUmjis/bljAWNSRu2JQvLTvNJsp8gHSfF9DpIIo8GoIi0A0eB
 Fn9GimaXmVzdjNtjik1Nq9Sf21IQEM+5N9TPcDX2MBA1BT78FYjiKdIM1Sca+gCyARG7
 rkpThp0sAnUNEpyPdhhjPJgeLsBaFZh8Y+ivhqxnqTG2qb+0nUPJNTDxBO9cBZxH3Ad7 +Q== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3awx3eag98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 11:37:37 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 187FS6lW004021;
	Tue, 7 Sep 2021 15:37:36 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 3av0e9hncq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Sep 2021 15:37:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187FbW9Z53543324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Sep 2021 15:37:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DC77AE045;
	Tue,  7 Sep 2021 15:37:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 898F9AE05A;
	Tue,  7 Sep 2021 15:37:31 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.40.192.207])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  7 Sep 2021 15:37:31 +0000 (GMT)
Subject: [PATCH v2 2/3] ndtest/ack-shutdown-count: Skip the test on ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 07 Sep 2021 15:37:30 +0000
Message-ID: <163102903696.260256.10931405414411762002.stgit@99912bbcb4c7>
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
X-Proofpoint-GUID: nB0cdpCUk-idq4T1illbTr4J3kmGSRsv
X-Proofpoint-ORIG-GUID: nB0cdpCUk-idq4T1illbTr4J3kmGSRsv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_05:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070101

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


