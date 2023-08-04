Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9441963DB
	for <nvdimm@lists.linux.dev>; Fri,  4 Aug 2023 08:50:01 +0000 (UTC)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3748fA9Z023383;
	Fri, 4 Aug 2023 08:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6cQt1j/lXj2ULGOQTV0S9uWLPgxg4utyOKcgzJ5dPqA=;
 b=XJSZ0J9FqM4OW6uP4h1G+AjOt+jDKCso+Ke2Vv91CeUto174DBCjjVebT9pXZPv6ab6t
 NHsimzlLmcGnnkXf+r12fdWLVByZHlDJIfw4KBsEBG+oLQRKGTGSo0MCeTGB1TQKY5Ls
 WMDf59bsM1yQB7/W/F1i7IlCkI9hyRrWPykaHlVG7Ld/PoejnyXR14YNZOX7DLyJ2a8N
 U2n7EvkuqdbwRdx68UsfOmvgFDGckDJu+M4enLjJddHlBj4s+qOwqnKkGxJHJK/wfe5Q
 lJ4Pug5ehesH3QcTqc2kDamJT2s0914WnczgxC10Olg3wTcMHu7KpA9LNfZr5Y35Q/Bv xg== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s8w9n99af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Aug 2023 08:49:52 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3746wtDJ027816;
	Fri, 4 Aug 2023 08:49:51 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s8kp2v4d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Aug 2023 08:49:51 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3748np1d31064662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Aug 2023 08:49:51 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42E5E58059;
	Fri,  4 Aug 2023 08:49:51 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D59A58058;
	Fri,  4 Aug 2023 08:49:49 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.43.22.158])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  4 Aug 2023 08:49:49 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH 2/2] nvdimm/pfn_dev: Avoid unnecessary endian conversion
Date: Fri,  4 Aug 2023 14:19:34 +0530
Message-ID: <20230804084934.171056-2-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230804084934.171056-1-aneesh.kumar@linux.ibm.com>
References: <20230804084934.171056-1-aneesh.kumar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HJYOjxvfbgoqgKA9BsTO-ULD0XeRiFoy
X-Proofpoint-GUID: HJYOjxvfbgoqgKA9BsTO-ULD0XeRiFoy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-04_06,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=967 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308040075

use the local variable that already have the converted values.

No functional change in this patch.
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/pfn_devs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 36b904a129b9..8b7342517895 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -599,14 +599,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EOPNOTSUPP;
 	}
 
-	if (!IS_ALIGNED(res->start + le32_to_cpu(pfn_sb->start_pad),
-				memremap_compat_align())) {
+	if (!IS_ALIGNED(res->start + start_pad, memremap_compat_align())) {
 		dev_err(&nd_pfn->dev, "resource start misaligned\n");
 		return -EOPNOTSUPP;
 	}
 
-	if (!IS_ALIGNED(res->end + 1 - le32_to_cpu(pfn_sb->end_trunc),
-				memremap_compat_align())) {
+	if (!IS_ALIGNED(res->end + 1 - end_trunc, memremap_compat_align())) {
 		dev_err(&nd_pfn->dev, "resource end misaligned\n");
 		return -EOPNOTSUPP;
 	}
-- 
2.41.0

