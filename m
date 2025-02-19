Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE91B4F0C
	for <nvdimm@lists.linux.dev>; Wed, 19 Feb 2025 09:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739958070; cv=none; b=EfAHxU4IFX8ghIn4T/SfutYUBbm/OnKzKZDzFx9WeLw23rfigibaINE7MKTjXxYx3HBJ/IaHu+VG4A7UHduc5rRHWh+QNhVdn5fQHuaSOqBHHy9Wodl8V2fivREQUlJW78arFSGG/HmsHljIKg3J9o1RSCPExzMTpWmwbPM+UIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739958070; c=relaxed/simple;
	bh=p0Gv5YRKoWgBOFBnWFnu8pOY8x0xX0O8cjOnADN1BzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DUcDRUiPxvteO/8hXFnKO1cjTzUbApJTeyDSWutTpBbFjik5TczI/2pyjokh+1luRyc9Q/KVl69fy/g7+hh8il5ydKoIMdfrvttFML/ff27Oi1mdScMTAHXOyMJDhSRRWlj1riY1X0Eys0HL6OrA4TZGImnXSeqtYQPXTE340Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dhVTErY5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dhVTErY5"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51J75DpC011713;
	Wed, 19 Feb 2025 09:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=CxwNQZ8FKXO6aBmyX5pT5a0uXGbQzshlh0nmwjbVK
	GM=; b=dhVTErY50+fBFhbSxNheYi+wIv4NS506Tv6o9Y5keDnaFjbrdnmDlOHha
	edzGJlkLciZnALZrAPq9MsMnxPTeqXlzQsjClY/iQz00tRbbxu75NzmEdRDveYOa
	PslOpf/X/25aiOVCNUT9n1102b3GmzCyhrRiVrSM8Bw0Qc3zA1SKNEQ+uotUp1aB
	/p6x0qJWoDakKFIxMnnyypuyTwebjI+C6wmxX4TQXdvvx2Ttc6vSgHC85XMmSEai
	C7ajhYj+h/ZHSroMr6YK1d0C7kxuPgurcznz6fViWa2gc8cuZmBtgNowVaFRx6sx
	cGI3c94INq/RLG6cADcJfglj9mFYA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44w5c99wkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 09:41:05 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51J9f5or007026;
	Wed, 19 Feb 2025 09:41:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44w5c99wkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 09:41:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51J6n4C9029363;
	Wed, 19 Feb 2025 09:41:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44w024bapv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Feb 2025 09:41:03 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51J9f1Ys33096280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 09:41:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A326A20040;
	Wed, 19 Feb 2025 09:41:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 745BD2004B;
	Wed, 19 Feb 2025 09:41:00 +0000 (GMT)
Received: from ltczz402-lp1.aus.stglabs.ibm.com (unknown [9.40.194.31])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Feb 2025 09:41:00 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Li Zhijian <lizhijian@fujitsu.com>,
        Jeff Moyer <jmoyer@redhat.com>, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH] ndctl: json: Region capabilities are not displayed if any of the BTT, PFN, or DAX are not present
Date: Wed, 19 Feb 2025 03:40:49 -0600
Message-ID: <20250219094049.5156-1-donettom@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4lct2R_Ov6xlNraAudS-TLeYRPxn_OoG
X-Proofpoint-GUID: xOvNa4tkabbHsNqL9XYz6ZNo3ju0FIMH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_04,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1011 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=923 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502190075

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
 # ./build/ndctl/ndctl  list -R -C
 [
  {
    "dev":"region1",
    "size":549755813888,
    "align":16777216,
    "available_size":549755813888,
    "max_available_extent":549755813888,
    "type":"pmem",
    "iset_id":11510624209454722969,
    "persistence_domain":"memory_controller"
  },

With this patch
---------------
 # ./build/ndctl/ndctl  list -R -C
 [
  {
    "dev":"region1",
    "size":549755813888,
    "align":16777216,
    "available_size":549755813888,
    "max_available_extent":549755813888,
    "type":"pmem",
    "iset_id":11510624209454722969,
    "capabilities":[
      {
        "mode":"fsdax",
        "alignments":[
          65536,
          16777216
        ]
      },
      {
        "mode":"devdax",
        "alignments":[
          65536,
          16777216
        ]
      }
    ],
    "persistence_domain":"memory_controller"
  },

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 ndctl/json.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/ndctl/json.c b/ndctl/json.c
index 23bad7f..3df3bc4 100644
--- a/ndctl/json.c
+++ b/ndctl/json.c
@@ -381,9 +381,6 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
 	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
 
-	if (!btt || !pfn || !dax)
-		return NULL;
-
 	jcaps = json_object_new_array();
 	if (!jcaps)
 		return NULL;
@@ -436,7 +433,8 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
 		json_object_object_add(jcap, "alignments", jobj);
 	}
 
-	return jcaps;
+	if (btt || pfn || dax)
+		return jcaps;
 err:
 	json_object_put(jcaps);
 	return NULL;
-- 
2.43.5

