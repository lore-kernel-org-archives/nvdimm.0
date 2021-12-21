Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F7F2C82
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 14:43:23 +0000 (UTC)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BLDrThr024828;
	Tue, 21 Dec 2021 14:43:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=z6PTfYfzjWNTh7wYLjjo6ar7FiPlabnsTbeGjxTtB6Q=;
 b=kFRkq6pmPpW9bdmiMBIc3529MouMefUSVRmtEEWO2QRvH+TfmopykVRiLT5XHKy4pqKc
 J7cYez0CmKY3OrJi28r7zTNlNmnHzuUV8OKwYgPZqpnXzIiOGcA7nLm5IWT0tYF5H5DP
 BSjuXrn9s05DdurgFs3qOyahBMtfb68uN5ao/PHtvd6ayc98Imz5PDw6txkKBF5gxW1D
 Ez2VSBUajnRL2D3aCd/ZpqjZoG3SeNkv2I4KNSr8yad7WS9TCN/mSXFQNbjh687xuifn
 +A5J42mRHIWe+xZF/crLF4uNPlCuSWPRc1Tgyd6kGZ995FMP9mW9j5GKkYh5k/zPT+wh /Q== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3d3g6w13p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:43:21 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BLEgZ2V029536;
	Tue, 21 Dec 2021 14:43:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma04fra.de.ibm.com with ESMTP id 3d179a5ed1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Dec 2021 14:43:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BLEYmqR48562582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Dec 2021 14:34:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80C894C044;
	Tue, 21 Dec 2021 14:43:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 861A44C059;
	Tue, 21 Dec 2021 14:42:59 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 21 Dec 2021 14:42:59 +0000 (GMT)
Subject: [ndctl REPOST PATCH v2] ndtest/ack-shutdown-count: Skip the test on
 ndtest
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: aneesh.kumar@linux.ibm.com, sbhat@linux.ibm.com, vaibhav@linux.ibm.com,
        dan.j.williams@intel.com, ira.weiny@intel.com,
        vishal.l.verma@intel.com
Date: Tue, 21 Dec 2021 08:42:58 -0600
Message-ID: 
 <164009775299.743652.17082679043242402916.stgit@lep8c.aus.stglabs.ibm.com>
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
X-Proofpoint-ORIG-GUID: Z4cGM5efoTaXXborF7JiC6jqHnvaofiB
X-Proofpoint-GUID: Z4cGM5efoTaXXborF7JiC6jqHnvaofiB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210068

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


