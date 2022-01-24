Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99F92CA7
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 21:04:42 +0000 (UTC)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OIkaQv025979;
	Mon, 24 Jan 2022 21:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=WEYnjKp2w4TqBOtXwuEATRIV5ljzvk0vb909l45q5n8=;
 b=KuL08OTZjPySKxJGO5t3eI4QjepC9kt7gWo2I4/bz0TJ42PYMSJ+GJCjaT/fK5ccUpvo
 F3i/cu7bnhlhEtbauHtrVFUfO0ZJKIiMyK2S/dBdFp2YR3Kmqhf2siM+5F6oEYFfPL0e
 /5xD7w8/uTeWcToCxUDBjCGm0113eMYsXlxWe9ZgxM96JNJ6JPP72GiSI9vrEvJFTH73
 KNV3JMhVxJV0D/DL5jbaWQkLNrY/m2QHP+xdaKLO8t6ibINapYoXkIzsdAil0sX/0Ywc
 XWwZT+S1810QnnSVDE2RDSWB9qpK+w+cl4Io0+nbNqF9oaHEZPgYLO09zrC+7OCNUEfY gQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dt1pjanp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 21:04:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OKmInl009866;
	Mon, 24 Jan 2022 21:04:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma06ams.nl.ibm.com with ESMTP id 3dr96j84a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jan 2022 21:04:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OL4UNh42664310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jan 2022 21:04:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BD125204E;
	Mon, 24 Jan 2022 21:04:30 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.98.202])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 6083F52059;
	Mon, 24 Jan 2022 21:04:27 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 25 Jan 2022 02:34:26 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH v3] ndtest/ack-shutdown-count: Skip the test on ndtest
Date: Tue, 25 Jan 2022 02:34:25 +0530
Message-Id: <20220124210425.1493410-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qh6p9NiMGlToOgj7wEPjj_PBTH7lsy9W
X-Proofpoint-ORIG-GUID: Qh6p9NiMGlToOgj7wEPjj_PBTH7lsy9W
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_09,2022-01-24_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240137

From: Shivaprasad G Bhat <sbhat@linux.ibm.com>

The PAPR has non-latched dirty shutdown implementation.
The test is enabling/disabling the LSS latch which is
irrelavent from PAPR pov. Skip the test.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
Changelog:

Since v2-Resend:
https://lore.kernel.org/nvdimm/164009775299.743652.17082679043242402916.stgit@lep8c.aus.stglabs.ibm.com/
* Rebased this on top of latest ndctl-pending tree that includes changes to
switch to meson build system.
---
 test/ack-shutdown-count-set.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index a9e95c63b76c..f091a404bf9c 100644
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
-- 
2.34.1

