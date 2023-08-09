Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDE420EC
	for <nvdimm@lists.linux.dev>; Wed,  9 Aug 2023 05:35:50 +0000 (UTC)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3795X9Uc021796;
	Wed, 9 Aug 2023 05:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=foxs+xgIwnTey4WoQHkKbMwNtpvRwbdLKbrIncTEKmw=;
 b=TbU53ZQtLFs02YfUyn+yEH0tHu1pze9nFIZAILf11wLRVu3SH7gbhMlaPwRE44lqV5+e
 9cPcfTT3/oYN1I5gaG+lix8/ycDdVKLJ2RcAyckpWQCfJ1hlibx+PjFWtnxPAUqstyID
 DZZmJ9yJK3nEIgjbMkz/s7X344+Sh7F8ZCeI/Y/6QX8I+ceUiBxOoqiAaPM94wZEEGLS
 KUKba5Q8VsoxIF1BYj5X4uK7sTZYdLXlaJJvtbYg7Wu240Xe95zzM5PhgSsvOs3gxQBQ
 g3QYAJ9/ukabcS8tmXtrYRUtXLVDAZ1OjkDgX/Fv3yAz6gnLAzp0b3JvmsBxUhjKXj4u 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc4rm85p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Aug 2023 05:35:41 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3795XISI022431;
	Wed, 9 Aug 2023 05:35:41 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sc4rm8549-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Aug 2023 05:35:40 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3794P8Eh030766;
	Wed, 9 Aug 2023 05:35:28 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sa1rndb8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Aug 2023 05:35:28 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3795ZRRA8323588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Aug 2023 05:35:27 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 57E305805D;
	Wed,  9 Aug 2023 05:35:27 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B5E45805B;
	Wed,  9 Aug 2023 05:35:25 +0000 (GMT)
Received: from skywalker.in.ibm.com (unknown [9.109.212.144])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  9 Aug 2023 05:35:24 +0000 (GMT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To: nvdimm@lists.linux.dev, dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 2/2] nvdimm/pfn_dev: Avoid unnecessary endian conversion
Date: Wed,  9 Aug 2023 11:05:12 +0530
Message-ID: <20230809053512.350660-2-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809053512.350660-1-aneesh.kumar@linux.ibm.com>
References: <20230809053512.350660-1-aneesh.kumar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cNbgNNw8pW9jWw2TtNIuu5rcJ8JBQChh
X-Proofpoint-ORIG-GUID: _mQRvs8fFpL8R_-gx5ShExa8oy8sbdVc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_03,2023-08-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308090049

use the local variable that already have the converted values.

No functional change in this patch.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/pfn_devs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 0777b1626f6c..c662d8964802 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -601,14 +601,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
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

