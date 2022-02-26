Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6363B21
	for <nvdimm@lists.linux.dev>; Sat, 26 Feb 2022 11:40:14 +0000 (UTC)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q9Egq8010619;
	Sat, 26 Feb 2022 11:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=jB7a9kCbVK8WlYyUgMntxx6G2BrHntEpAWGJRG8Ofyk=;
 b=hY1HGaV+sKmLhnTabX5zAEmGD830lLfPanZuzuH46LB3QjXd6VKvGnuk3xLsSawfONp1
 3hMuVQSUMmJZSQk3QuB45v1LJMqSbDnhAc3k84wD24KcrdpBCHsr4MG9637azkuGvaLE
 PZpzyAQsIcR9+MjsfQy2tlufRTfVjgVBMN8vXHEBiOnifWNiDVTw5N01li+QttH2TbRZ
 Xg2u1k9gC5x7HagXlvpE8MifK00l0kthRlHUWH2cNF31Po2g5EmFBRMuEOPxGTyWTjT7
 UfVi+jEVycnl5ffZQTZmfv9/yvQOsNqB14cj7tAPhfhBoVlv2D+MfQkW55dL/uS2G5Q+ Dw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3efhdb25f5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 26 Feb 2022 11:40:06 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21QBbIvZ003208;
	Sat, 26 Feb 2022 11:40:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma04fra.de.ibm.com with ESMTP id 3efbu8hg1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 26 Feb 2022 11:40:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21QBe1ao27656582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Feb 2022 11:40:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 405375204F;
	Sat, 26 Feb 2022 11:40:01 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.43.43.241])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 5B6DC52052;
	Sat, 26 Feb 2022 11:39:58 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Sat, 26 Feb 2022 17:09:57 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: nvdimm@lists.linux.dev
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Tarun Sahu <tsahu@linux.ibm.com>
Subject: [ndctl PATCH] util/size.h: Fix build error for GCC < 10
Date: Sat, 26 Feb 2022 17:09:55 +0530
Message-Id: <20220226113955.526036-1-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gjSihoyzvsVfHobnovhCxGlY5HpMRcvW
X-Proofpoint-ORIG-GUID: gjSihoyzvsVfHobnovhCxGlY5HpMRcvW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_11,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=657 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202260081

Building with GCC 8.4.1 results in following build error for 'util/size.c':

../util/size.h:57:16: error: missing binary operator before token "("
   __has_builtin(__builtin_mul_overflow) && \

This is caused due to missing '__has_builtin' preprocessor operator in GCC
versions < 10.0.0. The patch updates the check for CLANG's availability of
__builtin_{mul,add}_overflow to prevent preprocessor from evaluating the
expression "___has_builtin(__builtin_mul_overflow) &&
__has_builtin(__builtin_add_overflow)".

Fixes:10653a171bc0("util/size.h: fix build for older compilers")
Reported-by: Tarun Sahu <tsahu@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 util/size.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/util/size.h b/util/size.h
index 1cb06690261b..02baa77fe649 100644
--- a/util/size.h
+++ b/util/size.h
@@ -53,11 +53,12 @@ static inline bool is_power_of_2(unsigned long long v)
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
 
-#if __clang__ && \
-    __has_builtin(__builtin_mul_overflow) && \
+#if __clang__
+#if __has_builtin(__builtin_mul_overflow) && \
     __has_builtin(__builtin_add_overflow)
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #endif
+#endif
 
 #if COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
 
-- 
2.35.1

