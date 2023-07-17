Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA28465
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 06:26:36 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230717062634epoutp036933e767f9625fbf484642074fe92736~yk7AmKdqv0705207052epoutp038
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 06:26:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230717062634epoutp036933e767f9625fbf484642074fe92736~yk7AmKdqv0705207052epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1689575195;
	bh=FOuFAPtD9D4ZvNiRTsQvEk28ooi0o+1F6WOqazOptTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3VANfnFWWZUQtI/wRKv2mS582m7qWD6LRpb7aFTXhRxqaSEyV91v7VRNxPvBeQPz
	 t7C5NgebG6izIKzY3yNVdI6H9tj5hs0Qp4HKYNoCIbjdHsxkj8CBVqo46XekMfYwwq
	 QbSZJffGYdnyvHHaXexro87HTShYWTMxX1S9mnJ8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20230717062634epcas2p31fd2ad017fb5f54d42205e3ce6af3f58~yk7AHE46Q0111201112epcas2p3i;
	Mon, 17 Jul 2023 06:26:34 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.98]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4R4Btd6X2kz4x9Q7; Mon, 17 Jul
	2023 06:26:33 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.A7.49913.91FD4B46; Mon, 17 Jul 2023 15:26:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230717062633epcas2p44517748291e35d023f19cf00b4f85788~yk6__UDPM1632216322epcas2p4G;
	Mon, 17 Jul 2023 06:26:33 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230717062633epsmtrp2a17248c0f7681fc22f5e4ec697379735~yk6_9ce0d0871408714epsmtrp2p;
	Mon, 17 Jul 2023 06:26:33 +0000 (GMT)
X-AuditID: b6c32a45-5cfff7000000c2f9-c0-64b4df19297d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E2.41.14748.91FD4B46; Mon, 17 Jul 2023 15:26:33 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230717062632epsmtip23b96c6a6a6df2e863e268c747d90bc46~yk6_uTAmT1582615826epsmtip2P;
	Mon, 17 Jul 2023 06:26:32 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH RESEND 2/2] libcxl: Fix accessors for temperature
 field to support negative value
Date: Mon, 17 Jul 2023 15:29:08 +0900
Message-Id: <20230717062908.8292-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230717062908.8292-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmha7k/S0pBhPeGljcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiism0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgE5UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnrD16jrnguHTF5X0/mRoY/4p1MXJw
	SAiYSPRO4u5i5OIQEtjBKHH58h82COcTo8TGbZ/ZIZxvjBK/vj5i6WLkBOv4sOYSE0RiL6PE
	33kdYAkhgV4miScrTUBsNgFtifvbN7CB2CICshLN6x6ANTALbGaWWLbzHFhCWCBTonnBKnYQ
	m0VAVaJt5lomEJtXwFpi6b17bBDb5CVWbzjADGJzCthIzJj+lRFkkITAV3aJHQ+nMEEUuUhc
	aJvJCGELS7w6voUdwpaS+PxuL9SgfImfJ2+xQtgFEp++fIB6x1ji3c3nrKDAYBbQlFi/Sx8S
	LsoSR26BVTAL8El0HP7LDhHmlehoE4JoVJXoOv4Baqm0xOErR5khbA+JmVtmMUPCp59R4sen
	vcwTGOVmISxYwMi4ilEstaA4Nz212KjAEB5hyfm5mxjBKVDLdQfj5Lcf9A4xMnEwHmKU4GBW
	EuH9vmpTihBvSmJlVWpRfnxRaU5q8SFGU2DYTWSWEk3OBybhvJJ4QxNLAxMzM0NzI1MDcyVx
	3nutc1OEBNITS1KzU1MLUotg+pg4OKUamJTyHlpG6HDNMAoqWHPlgirLrtnnLG2uXWq2ZvwR
	+HnPy8nhLhJuVinuMwUCthzb0NHpn7ygXEDiAy+LWIdv0p9N2Unp9mJ5865sUnvzQnmxstwq
	xtVdy/t1nSYdKu/MXvHg/EWjdyoGZ8691tq17MEWGUmxS35v55VnNZ5xlQ5YeV84/Er/jrjU
	sycMpszpVPP69XJJV3JO2ZemLw1Pw5b2RMTznJp11y1zVpOmhFndppeRiqu4XZ2mXWcPmhF/
	l196j/5PnWOh/VYHvY6sOljnvDxIz7Hjy5yHqmtX6Oxffangb6OP0gmN7xKKeizmafpJBXOW
	nfsjI+v2eHr3MikfjdVPJ6zeELxwn/SJSiWW4oxEQy3mouJEAKmfDTUKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvK7k/S0pBv27WS3uPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBlrj55jLjgu
	XXF530+mBsa/Yl2MnBwSAiYSH9ZcYupi5OIQEtjNKPHh7k5GiIS0xL3mK+wQtrDE/ZYjrBBF
	3UwSN3dNAStiE9CWuL99AxuILSIgK9G87gHYJGaBvcwSHTPPs4IkhAXSJd49mwrWwCKgKtE2
	cy0TiM0rYC2x9N49NogN8hKrNxxgBrE5BWwkZkz/ClYvBFTz4MVv5gmMfAsYGVYxSqYWFOem
	5yYbFhjmpZbrFSfmFpfmpesl5+duYgQHrJbGDsZ78//pHWJk4mA8xCjBwawkwvt91aYUId6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4ryGM2anCAmkJ5akZqemFqQWwWSZODilGpjs5sYteDnzcmt4
	fM4Ot4yrB99Ldj95Z5PPMuO5Osv09DvnM3Zv2X97v9ytQnfLAqbDd+t9vtd/t/y6LHBbF9Mv
	yasLDs2apNLRyJNxaUKJR7k3o6/MTDn+WpU7H3+IGpm23xJ8tdt388edR1Oc76eqzTjvneWT
	dV9TbeeVyDCLmBytR1rO0s9C67pm2i+XNC58ZLTOJrvx5NWz66O6nrDe+non94NuYHPkg05l
	8+r/zS+8tsiLzxV6p/M3K/SNW52E81kzOwaZR6r6YbslvB4u3qX0gfcwc9DpidE6DKUzt9xw
	0TvnvcBqpv8Fjfxr1U4/2WY9PnvDfkvGvNbdOztPxhxieDDt5Gc5z6uvNqxVYinOSDTUYi4q
	TgQA1KI5xMcCAAA=
X-CMS-MailID: 20230717062633epcas2p44517748291e35d023f19cf00b4f85788
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230717062633epcas2p44517748291e35d023f19cf00b4f85788
References: <20230717062908.8292-1-jehoon.park@samsung.com>
	<CGME20230717062633epcas2p44517748291e35d023f19cf00b4f85788@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Add a new macro function to retrieve a signed value such as a temperature.
Replace indistinguishable error numbers with debug message.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 cxl/lib/libcxl.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 769cd8a..fca7faa 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -3452,11 +3452,21 @@ cxl_cmd_alert_config_get_life_used_prog_warn_threshold(struct cxl_cmd *cmd)
 			 life_used_prog_warn_threshold);
 }
 
+#define cmd_get_field_s16(cmd, n, N, field)				\
+do {									\
+	struct cxl_cmd_##n *c =						\
+		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
+	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
+	if (rc)								\
+		return 0xffff;						\
+	return (int16_t)le16_to_cpu(c->field);					\
+} while(0)
+
 CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_over_temperature_crit_alert_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_over_temperature_crit_alert_threshold);
 }
 
@@ -3464,7 +3474,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_under_temperature_crit_alert_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_under_temperature_crit_alert_threshold);
 }
 
@@ -3472,7 +3482,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_over_temperature_prog_warn_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_over_temperature_prog_warn_threshold);
 }
 
@@ -3480,7 +3490,7 @@ CXL_EXPORT int
 cxl_cmd_alert_config_get_dev_under_temperature_prog_warn_threshold(
 	struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
+	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
 			  dev_under_temperature_prog_warn_threshold);
 }
 
@@ -3695,28 +3705,34 @@ static int health_info_get_life_used_raw(struct cxl_cmd *cmd)
 CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
 {
 	int rc = health_info_get_life_used_raw(cmd);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
 
 	if (rc < 0)
-		return rc;
+		dbg(ctx, "%s: Invalid command status\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
-		return -EOPNOTSUPP;
+		dbg(ctx, "%s: Life Used not implemented\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	return rc;
 }
 
 static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
 {
-	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
+	cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
 				 temperature);
 }
 
 CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
 {
 	int rc = health_info_get_temperature_raw(cmd);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
 
-	if (rc < 0)
-		return rc;
+	if (rc == 0xffff)
+		dbg(ctx, "%s: Invalid command status\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
-		return -EOPNOTSUPP;
+		dbg(ctx, "%s: Device Temperature not implemented\n",
+		    cxl_memdev_get_devname(cmd->memdev));
 	return rc;
 }
 
-- 
2.17.1

