Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7561773D;
	Sun, 26 May 2024 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716738771; cv=none; b=oI/Fg5uTONfktlRmx5ahAhcoMSixfUb4n1ZR7uWoIpKSTmZ8Mk/mdgq6syqG0ZJ9mSvfntwSjlP+0N3Fm7/+azJRzpuiuoP5j9UQd5KwsNevTj4PR87pnJWxLzpK6Sh6PRbKFEzsSu+2BB4ObspOQXiQVZ2N5hMxOrru6u3B66Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716738771; c=relaxed/simple;
	bh=UpVOttyA/UnQTEE5Cc1EgmophjwkU+XEArMRL6occfA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=gua4Gn6Vb3GjNby7AvqdVHIpy0EDwvw4pXuUKaXp90fqGar6IpfkbPWeTu/UUHMmC9XFJpq8+UNxTFLHm+HPBMc4G/4prI8j2riwPSUSCxsMrHeXiClcEEtlnEeTpbURsUTp09YQoWL+GOSOnzE9NL1RbXq8E5D27VJX10pwzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=D/6+JF2c; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="D/6+JF2c"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44QFhG6P026382;
	Sun, 26 May 2024 15:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=oS6Fr4nqr96rPUiETgcOjA
	Wzr7B2lqg1ufTni7x5aIs=; b=D/6+JF2crLdd/oVHsI+WrPzjngdmFyQn6rzxzs
	kcUs/WJ7ZZdbmiR6yljILG6EJd22g3Qkgrswfx+VTtZcSiEGd6uhz2ZJoRKM8Wpk
	32r5aaBCakg2tuN4bhQjGLaPSs7ymnOW3Yq6F4BftImq1MOT9jBw5/IvVmxqdV7w
	twPaauSjbF5o/0R/ZX5Z6ZPp+28TEjHls6CX4GyVqUlqSe53CVahnSFFAoeuTXDb
	HbQ5BxxbdQe6ns5SsGsywgBtPpy7EPukoxfEEfI3gooy0eBcrTCyjttX85+uzl9U
	WcYWGNMgHp8sr7lggblrwmyPajw8+lTXosd5pTJuhjln7xkg==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba0q9vna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 May 2024 15:52:39 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44QFqbAK006008
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 26 May 2024 15:52:37 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 26 May
 2024 08:52:37 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 26 May 2024 08:52:36 -0700
Subject: [PATCH] testing: nvdimm: iomap: add MODULE_DESCRIPTION()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240526-md-testing-nvdimm-v1-1-f8b617bb28e1@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAMNaU2YC/x3MQQqDMBCF4avIrDuQBhtpr1K6SMyoA81UMlEs4
 t2buvzgvX8Hpcyk8Gh2yLSy8kcqrpcG+snLSMixGqyxrblZhyliIS0sI8oaOSU0NtxbY13XeQf
 1N2caeDubz1d18EoYspd++pfeLMuGyWuhjPO3TuE4fhl5c86IAAAA
To: Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny
	<ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: TMT595saEGXmjn2yA6wAmQlln5f7iZTU
X-Proofpoint-ORIG-GUID: TMT595saEGXmjn2yA6wAmQlln5f7iZTU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-26_09,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405260132

Fix the 'make W=1' warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/../../tools/testing/nvdimm/test/iomap.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 tools/testing/nvdimm/test/iomap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index ea956082e6a4..e4313726fae3 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -407,4 +407,5 @@ union acpi_object * __wrap_acpi_evaluate_dsm(acpi_handle handle, const guid_t *g
 }
 EXPORT_SYMBOL(__wrap_acpi_evaluate_dsm);
 
+MODULE_DESCRIPTION("NVDIMM unit test");
 MODULE_LICENSE("GPL v2");

---
base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
change-id: 20240526-md-testing-nvdimm-02b9402677a6

