Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3C0188CAA;
	Wed,  5 Jun 2024 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717609772; cv=none; b=gaPllh5kZbJ70w9fMqVadp5T1X9zp8zozhTXNNxrcP8ftBaShH89lu1kq1rygydepBjqwbMt2VXNExoXn7rlYOeYzc3ZhmDGl/GmB7nCtQ3jgSbq68Wv8ewl4NYiS6KgjavUc+MUul0F/qFBmDtsjGwzfgp/SOroidTR177VRao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717609772; c=relaxed/simple;
	bh=6+pLjpWz258QiGPov/ARDn7yccoD9CoZe6XpvSTOwX8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=QVQZQXqq7d5r4kikVNPdseEcUyYB2Iev89hY2iSaDJ7S6qaRGNZZvrEXu+JSP5972Bt5W/gEmygiz4Jlf1HhVB7OSKIWH5obKzhR1PBMBAK93I3VJYA6cxyFxixAEzxyIR8ZkuCeu6cbb7qWCUfvQagtWPx0s61JbR6r5HQ6B1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=cjgV9GMg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="cjgV9GMg"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 455B1MEV031665;
	Wed, 5 Jun 2024 17:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=AXhQBKojD6PKBV7uF/cgH/
	f6O4FOFdKrLiFVfvtSdWk=; b=cjgV9GMgaquBHhkOl2Aq4x+AOkF8HhzmkujxwE
	1hJ5sIX/4J5c5OKUS9DQHpjH8pytnRuYYZS+K2fH2lpvRcNgxd0m5tF38oQgiPwM
	TmQJ/1IQEZ4D+4rJphZfOHuN/Pr34enTrlWdv5ZwoJ/Xb8hN9tX7hlJ5ejjFxCTi
	Hl95dimhSo+/UsOUHKjM/XALWI9P3BZItDKqrqWxYNe1456W7zVSu6uJvOtgQ5HC
	xGAnqPOcfX50iv9JpWHSjqwuZXxgdCuGffavJA01b4FH2jYxeXtqKapt59vmpZ2T
	jR6d/571tBjWDRRqQjmZ6mx6k7eAF+g7JYVVUkCWyrYl1pNg==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yjk899jdx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 17:49:26 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 455HnO03001113
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 5 Jun 2024 17:49:24 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 5 Jun 2024
 10:49:24 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Wed, 5 Jun 2024 10:49:24 -0700
Subject: [PATCH] dax: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240605-md-drivers-dax-v1-1-3d448f3368b4@quicinc.com>
X-B4-Tracking: v=1; b=H4sIACOlYGYC/x3MQQ6CQAxA0auQrm0ygwLRqxgXhVZoAqNpkUxCu
 Lujy7f4fwcXU3G4VTuYbOr6SgXxVMEwURoFlYuhDvUltKHBhZFNNzFHpowcqYuRr3xuBEr0Nnl
 q/g/vj+KeXLA3SsP028yaPhkX8lUMjuMLfgbFuX8AAAA=
To: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: fJoPla1dG5T-u7kKaXEMNt9N01JInV7j
X-Proofpoint-ORIG-GUID: fJoPla1dG5T-u7kKaXEMNt9N01JInV7j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406050134

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/hmem/dax_hmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/device_dax.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/kmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/dax_pmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/dax/dax_cxl.o

Add all missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/dax/cxl.c       | 1 +
 drivers/dax/device.c    | 1 +
 drivers/dax/hmem/hmem.c | 1 +
 drivers/dax/kmem.c      | 1 +
 drivers/dax/pmem.c      | 1 +
 drivers/dax/super.c     | 1 +
 6 files changed, 6 insertions(+)

diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index c696837ab23c..89abcfe902fc 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -43,6 +43,7 @@ static struct cxl_driver cxl_dax_region_driver = {
 
 module_cxl_driver(cxl_dax_region_driver);
 MODULE_ALIAS_CXL(CXL_DEVICE_DAX_REGION);
+MODULE_DESCRIPTION("CXL DAX: direct access to CXL RAM regions");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
 MODULE_IMPORT_NS(CXL);
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index eb61598247a9..0ad27bce0d26 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -482,6 +482,7 @@ static void __exit dax_exit(void)
 }
 
 MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Device DAX: direct access mapping device");
 MODULE_LICENSE("GPL v2");
 module_init(dax_init);
 module_exit(dax_exit);
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index b9da69f92697..5e7c53f18491 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -168,5 +168,6 @@ MODULE_SOFTDEP("pre: cxl_acpi");
 
 MODULE_ALIAS("platform:hmem*");
 MODULE_ALIAS("platform:hmem_platform*");
+MODULE_DESCRIPTION("HMEM DAX: direct access to 'specific purpose' memory");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 4fe9d040e375..e97d47f42ee2 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -299,6 +299,7 @@ static void __exit dax_kmem_exit(void)
 }
 
 MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("KMEM DAX: map dax-devices as System-RAM");
 MODULE_LICENSE("GPL v2");
 module_init(dax_kmem_init);
 module_exit(dax_kmem_exit);
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index f3c6c67b8412..c8ebf4e281f2 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -94,6 +94,7 @@ static void __exit dax_pmem_exit(void)
 }
 module_exit(dax_pmem_exit);
 
+MODULE_DESCRIPTION("PMEM DAX: direct access to persistent memory");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_DAX_PMEM);
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index aca71d7fccc1..e16d1d40d773 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -606,6 +606,7 @@ static void __exit dax_core_exit(void)
 }
 
 MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("DAX: direct access to differentiated memory");
 MODULE_LICENSE("GPL v2");
 subsys_initcall(dax_core_init);
 module_exit(dax_core_exit);

---
base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
change-id: 20240605-md-drivers-dax-d1a711d9d35e

