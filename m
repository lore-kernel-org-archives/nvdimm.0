Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962921D6DB4;
	Thu, 17 Oct 2024 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729159950; cv=none; b=YgmCzkUKn9YkAVpcL2WyOFGAwvCU4ApXliBZvCvkXlrGCujP6f7BWx5my3RAWImnl8zkaalr9fVulgREW5a+2OdotUUpN1NacciOHAr8M40AjghOJpFDOKDkQw+R9XKIlM4kvpoFJb4hyymKq3QHi2jRRUBI7B75fcNUAUc+3pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729159950; c=relaxed/simple;
	bh=HRwTtXBd0rzPza1sOBwcwZwIzJbAJOaolyGxwN914LU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nacPl0QdVtv8ujQ7Sp2O27b9fuuM+ejRihZPsS5qHWbh8aEbE+3NiZuIAkzDbv4i0Fm94JbYKo28diyuS1vzeZSUBAY/qnqZypLbo0Mw7vEGsBar9La4Wwwn8ovMqeZk0FVaFpNasUZ5YkWHQnVpmkiK1gpeY2DlOyVavmvfPm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eQ23cedV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQ23cedV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49H9Mc2w014197;
	Thu, 17 Oct 2024 10:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=s73tJ0hyFkkOF9n4p1lw99E67Ld2g
	Qx79AxiNligKP0=; b=eQ23cedVlEBkvEzpFsNmitpCWFoXzgjV23ToDRuDbMiTJ
	zbR5f008KfzPnHYGCwwXE8q5Z6g4YH7Rb+0ewhpNwePUbP/3yyqndczgBzywELbq
	1rWPUUp15nILrpxmtg/IygO9Q7j495QSsg6Genfn2YI9L4bQSc1NXctCU9toicK6
	Jb3pQ7irJEix5wiCU3hByLbJ0dOxgqm2s5ynRzwkJtxUbXu8mCCN6pnNLPI3oMTR
	wgdV+humexZiw9AopMBR3cqra9gRvEnOylJNa+qd2PFiSFEU2rViMOU/J8MtlBdR
	idFfoJ4ttxsyASUJ4AEw1bzD/yEls74/7r+jtBboQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gqt5yb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 10:12:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49H9GDII026244;
	Thu, 17 Oct 2024 10:12:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fja0xaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 10:12:22 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49HACLkq007628;
	Thu, 17 Oct 2024 10:12:22 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 427fja0x9p-1;
	Thu, 17 Oct 2024 10:12:21 +0000
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jane Chu <jane.chu@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] dax: delete a stale directory pmem
Date: Thu, 17 Oct 2024 03:11:25 -0700
Message-ID: <20241017101144.1654085-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_10,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410170069
X-Proofpoint-GUID: GMXc2AHCPDCEDU_DzcNQNZ8IV7STjcWq
X-Proofpoint-ORIG-GUID: GMXc2AHCPDCEDU_DzcNQNZ8IV7STjcWq

After commit: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT") the pmem/
directory is not needed anymore and Makefile changes were made
accordingly in this commit, but there is a Makefile and pmem.c in pmem/
which are now stale and pmem.c is empty, remove them.

Fixes: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT")
Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
 drivers/dax/pmem/Makefile |  7 -------
 drivers/dax/pmem/pmem.c   | 10 ----------
 2 files changed, 17 deletions(-)
 delete mode 100644 drivers/dax/pmem/Makefile
 delete mode 100644 drivers/dax/pmem/pmem.c

diff --git a/drivers/dax/pmem/Makefile b/drivers/dax/pmem/Makefile
deleted file mode 100644
index 191c31f0d4f0..000000000000
--- a/drivers/dax/pmem/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
-obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem_core.o
-
-dax_pmem-y := pmem.o
-dax_pmem_core-y := core.o
-dax_pmem_compat-y := compat.o
diff --git a/drivers/dax/pmem/pmem.c b/drivers/dax/pmem/pmem.c
deleted file mode 100644
index dfe91a2990fe..000000000000
--- a/drivers/dax/pmem/pmem.c
+++ /dev/null
@@ -1,10 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
-#include <linux/percpu-refcount.h>
-#include <linux/memremap.h>
-#include <linux/module.h>
-#include <linux/pfn_t.h>
-#include <linux/nd.h>
-#include "../bus.h"
-
-
-- 
2.46.0

