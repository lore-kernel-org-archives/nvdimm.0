Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A2128DDE;
	Sun, 26 May 2024 17:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716743258; cv=none; b=kYT4upp5X9u4IpodQ8l/m0MBaZQwa4wIvudD3kzSjZjSvxzLS+6CjJ7HKOad6n95+Ew7igNg4Kl6Q816mJrpvhWA8+aaD3Ej1GOCaRzcpaeWc2Fv2ZSVn7vqC9gIBh0popzR7P+s8icDicucAGIN9ZpxieGUI+94ypo9Jt6ZEtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716743258; c=relaxed/simple;
	bh=hxoW3Kn3MKnBimztu85BpWWg9u80itLmHJRcJL6h2l0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=aO2kJpTJ6CowpMUTN1rkoXucB1nQagjs9mBGlOfQOvGzjgF+lmg5mZUY99YrzMfM9cUeCrFpJGawfFFm147kom+D+9xBJjtWkBLeFpDU8vWplIcf4nauqx3kQdwUtH5uuXRL/OukN1AUPJpwS04wuJUp41AqU6UU/TUrjYVj3lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=HES0OK7M; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="HES0OK7M"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44QFjBD6022281;
	Sun, 26 May 2024 17:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=V4fX5gJh5P/aHniROdlCAZ
	7TnAdEiZ5wFqy4XPPe5lg=; b=HES0OK7MnY70VHiSDJ6EiayJwij6b9MUdYDY1w
	tiPLVUGx3SmOOVrkH0vSkcXza2A3QeRl99VPrrO1GWDlxfPTEqYFQXofAdyFYHyR
	YkVE7jX/sNMeJe0IhrBkDyrmvIa1GQSaE7XY1H8GovlEyf3O1re1NnYhAICGZxIc
	eLfyslLS53r6G9vXssTD69RF3bnn5jhj62HjgOo+5GZtqyNJbK3wKiyzr8mC05ei
	gAYs/+fP0yGlSlQZdoc/w0rnNj7Whei8YjcSvoeCx+pnjkwnH04wm2TjxHTLObot
	roh52r3B1FdlwLEz5JCAs4NbJWyJeLpeQ8SLLGfMLWD7YXgg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yb9yj1y26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 May 2024 17:07:31 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44QH7UYq027234
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 May 2024 17:07:30 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 26 May
 2024 10:07:29 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 26 May 2024 10:07:14 -0700
Subject: [PATCH RESEND] nvdimm: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240526-md-drivers-nvdimm-v1-1-9e583677e80f@quicinc.com>
To: Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams
	<dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        "Oliver
 O'Halloran" <oohall@gmail.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux.dev>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: pwAobQ48h3riGq2VnMimZ0bXkfsvRBqd
X-Proofpoint-ORIG-GUID: pwAobQ48h3riGq2VnMimZ0bXkfsvRBqd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-26_09,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405260143

Fix the 'make W=1' warnings:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/libnvdimm.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_pmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_btt.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_e820.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/of_pmem.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_virtio.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/nvdimm/btt.c       | 1 +
 drivers/nvdimm/core.c      | 1 +
 drivers/nvdimm/e820.c      | 1 +
 drivers/nvdimm/nd_virtio.c | 1 +
 drivers/nvdimm/of_pmem.c   | 1 +
 drivers/nvdimm/pmem.c      | 1 +
 6 files changed, 6 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 1e5aedaf8c7b..a47acc5d05df 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1721,6 +1721,7 @@ static void __exit nd_btt_exit(void)
 
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_BTT);
 MODULE_AUTHOR("Vishal Verma <vishal.l.verma@linux.intel.com>");
+MODULE_DESCRIPTION("NVDIMM Block Translation Table");
 MODULE_LICENSE("GPL v2");
 module_init(nd_btt_init);
 module_exit(nd_btt_exit);
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 2023a661bbb0..f4b6fb4b9828 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -540,6 +540,7 @@ static __exit void libnvdimm_exit(void)
 	nvdimm_devs_exit();
 }
 
+MODULE_DESCRIPTION("NVDIMM (Non-Volatile Memory Device) core module");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
 subsys_initcall(libnvdimm_init);
diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 4cd18be9d0e9..008b9aae74ff 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -69,5 +69,6 @@ static struct platform_driver e820_pmem_driver = {
 module_platform_driver(e820_pmem_driver);
 
 MODULE_ALIAS("platform:e820_pmem*");
+MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 1f8c667c6f1e..35c8fbbba10e 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -123,4 +123,5 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 	return 0;
 };
 EXPORT_SYMBOL_GPL(async_pmem_flush);
+MODULE_DESCRIPTION("Virtio Persistent Memory Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index d3fca0ab6290..5134a8d08bf9 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -111,5 +111,6 @@ static struct platform_driver of_pmem_region_driver = {
 
 module_platform_driver(of_pmem_region_driver);
 MODULE_DEVICE_TABLE(of, of_pmem_region_match);
+MODULE_DESCRIPTION("NVDIMM Device Tree support");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("IBM Corporation");
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 598fe2e89bda..57cb30f8a3b8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -768,4 +768,5 @@ static struct nd_device_driver nd_pmem_driver = {
 module_nd_driver(nd_pmem_driver);
 
 MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
+MODULE_DESCRIPTION("NVDIMM Persistent Memory Driver");
 MODULE_LICENSE("GPL v2");

---
base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
change-id: 20240526-md-drivers-nvdimm-121215a4b93f
-- 
Jeff Johnson <quic_jjohnson@quicinc.com>

