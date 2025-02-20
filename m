Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF141632DF;
	Thu, 20 Feb 2025 06:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740032439; cv=none; b=SjgtsTjkieWpkDaA2NcKQ3Edlrte5XDBPdd9zK4q1Cu4Kt9ME5UC+67hKyy/6/bkLoHywQfcEnypoyXaRUenC+ARhae9VWKUdpohD/IoEQbfLIa4Li8c1S0fXsLX0cygNzfApAgD4c59kEG02aTNE+oM4SZdWjmO8aiTqYxhx0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740032439; c=relaxed/simple;
	bh=mSRfcUWtRjglJlQacGQSe7niVM8J1Nx9QxfyXOl9XtY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uHYG6ct3pTkGQnQHUAdycGtwxUPWcmzK9ab+eNWucQmjZFqD3KFTE1LOq2NwX4Z3QHJiBjXCX/CH0fPmKha/lXzErOtFOpjhMrxwZQdjjI1whPV0xspI0svZMS2A9ZEVTPyjg3y8j+G/P099sQIMFTzz8LRk8ODhD56k/x1xmbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o1lS+tMz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o1lS+tMz"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51K20lHs023117;
	Thu, 20 Feb 2025 06:20:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=d1+umES4xqbrDmuY9a+rMVO1nOlI+3TyprKLj3pI0
	58=; b=o1lS+tMzfrmmV3zQWhO8pjgOli3wWFMDXEiAyZIVMUeZ1vLqlqpSE7A7Z
	sPPXYTQu81JiF0FizjBZdlqLTp1l285/Dwi2HvVJHwNWfdRviIKF56is6iVPZUoG
	JlYfKHHixUvf+H9wc5kmPG3LHAKUJ/wcFmN7tpXaFBnAG2bsHECWA4OyGmr9ZBzm
	v11uSwilEP94OSeISm2xR/8kksody3kgx9heE9yTLLHUqvHvmrHrgEO4PrpORtA1
	UKbNtzmXA+og4tsgmpfLQqzvmQwRaxKhTQTJDT5oNxMSmjR53D7eY5ziwVAoCv94
	e1iEq1p+L0AqQZacgp9GdUCeij7Uw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44wu808x6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 06:20:34 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51K6KYb3027772;
	Thu, 20 Feb 2025 06:20:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44wu808x6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 06:20:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51K4T2Jq029314;
	Thu, 20 Feb 2025 06:20:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44w024gdms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Feb 2025 06:20:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51K6KVx439584212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 06:20:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 652DE2004E;
	Thu, 20 Feb 2025 06:20:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CCEE20040;
	Thu, 20 Feb 2025 06:20:30 +0000 (GMT)
Received: from ltcden14-lp2.aus.stglabs.ibm.com (unknown [9.53.174.194])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Feb 2025 06:20:30 +0000 (GMT)
From: Donet Tom <donettom@linux.vnet.ibm.com>
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Li Zhijian Jeff Moyer <"lizhijian@fujitsu.comjmoyer"@redhat.com>
Subject: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any of BTT, PFN, DAX
Date: Thu, 20 Feb 2025 00:20:29 -0600
Message-ID: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kvfvqjvUeRagRFlqTL_v2Ph-A_UjVWts
X-Proofpoint-ORIG-GUID: xk61zBy4zFeOAwt0xajqhm6UNYKE8PQZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_02,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502200041

If any one of BTT, PFN, or DAX is not present, but the other two
are, then the region capabilities are not displayed in the
ndctl list -R -C command.

This is because util_region_capabilities_to_json() returns NULL
if any one of BTT, PFN, or DAX is not present.

In this patch, we have changed the logic to display all the region
capabilities that are present.

Test Results with CONFIG_BTT disabled
=====================================
Without this patch
------------------
 # ./ndctl list -R -C
 [
  {
    "dev":"region1",
    "size":12884901888,
    "align":16777216,
    "available_size":11257511936,
    "max_available_extent":9630121984,
    "type":"pmem",
    "iset_id":14748366918514061582,
    "persistence_domain":"unknown"
  },

With this patch
---------------
 # ./ndctl list -R -C
 [
  {
    "dev":"region1",
    "size":12884901888,
    "align":16777216,
    "available_size":11257511936,
    "max_available_extent":9630121984,
    "type":"pmem",
    "iset_id":14748366918514061582,
    "capabilities":[
      {
        "mode":"fsdax",
        "alignments":[
          65536,
          2097152,
          1073741824
        ]
      },
      {
        "mode":"devdax",
        "alignments":[
          65536,
          2097152,
          1073741824
        ]
      }
    ],
    "persistence_domain":"unknown"
  },

v1 -> v2:
Addressed the review comments from Jeff and Alison.

v1:
https://lore.kernel.org/all/20250219094049.5156-1-donettom@linux.ibm.com/

Fixes: 965fa02e372f ("util: Distribute 'filter' and 'json' helpers to per-tool objects")
Signed-off-by: Donet Tom <donettom@linux.vnet.ibm.com>
---
 ndctl/json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/json.c b/ndctl/json.c
index 23bad7f..7646882 100644
--- a/ndctl/json.c
+++ b/ndctl/json.c
@@ -381,7 +381,7 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
 	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
 
-	if (!btt || !pfn || !dax)
+	if (!btt && !pfn && !dax)
 		return NULL;
 
 	jcaps = json_object_new_array();
-- 
2.47.1

