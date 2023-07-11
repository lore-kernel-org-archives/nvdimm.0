Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC77171BB
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 07:14:09 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230711070812epoutp0120660e1e4301ec23efc2cb4c33092146~wvnpFb53I1546315463epoutp01Q
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 07:08:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230711070812epoutp0120660e1e4301ec23efc2cb4c33092146~wvnpFb53I1546315463epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1689059292;
	bh=hWWV/CYz9PEFgUzb2vw2IElLf62KvNvLaJjeuRHOgIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERYs2aGvSdh7qulv7rV4OT+pf4J+jNLIq2UMOSUGl4WG92tkC7lH0u3D64yxgHWoZ
	 u/uKfNgVSYF2+SaRcSuF4WUHD0n0akeFNJtDfoA5H5iwjzGvjDsGr37Xqu0x5m2/OZ
	 rGmPuwBs/BpR1CaLAYFNUpt+K49S3SiY+EZLvcuo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20230711070812epcas2p3d765feeb1bdfd5947fd2c4de4412f130~wvnokpyUf2574425744epcas2p37;
	Tue, 11 Jul 2023 07:08:12 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.99]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4R0X5N4Y4jz4x9Q1; Tue, 11 Jul
	2023 07:08:08 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	94.F8.40133.8DFFCA46; Tue, 11 Jul 2023 16:08:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20230711070808epcas2p327adc8a7b29b653af17244d49eb38318~wvnk4mryt2804428044epcas2p3g;
	Tue, 11 Jul 2023 07:08:08 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230711070808epsmtrp1cb14709a3f3fd3530a0a6b7bf23edd70~wvnk2KJxz2535025350epsmtrp16;
	Tue, 11 Jul 2023 07:08:08 +0000 (GMT)
X-AuditID: b6c32a46-4edb870000009cc5-ea-64acffd8cb9e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D9.D3.30535.7DFFCA46; Tue, 11 Jul 2023 16:08:07 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230711070807epsmtip10e7e1fac12adad48df1945062f854d44~wvnknuVDU1618416184epsmtip12;
	Tue, 11 Jul 2023 07:08:07 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH 1/2] libcxl: add support for Set Alert Configuration
 mailbox command
Date: Tue, 11 Jul 2023 16:10:18 +0900
Message-Id: <20230711071019.7151-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230711071019.7151-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7bCmme6N/2tSDNZfU7S4+/gCm0Xz5MWM
	FtOnXmC0OHGzkc1i/9PnLBYHXjewWyw+OoPZ4ugeDovzs06xWKz88YfV4taEY0wO3B6L97xk
	8ti0qpPN48XmmYwefVtWMXp83iQXwBqVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDdJmSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8C8
	QK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj7zudggdaFee+HWBsYHyg3MXIySEhYCLx8UY3cxcj
	F4eQwA5GifOvPrFDOJ8YJZZcmM8C4XxjlGh4v5INpqVr52UWEFtIYC+jxKNzhhBFvUwSu9Z/
	ZwVJsAloS9zfvgGsQURAVqJ53QMmkCJmgQZmiXerroIlhAViJO6ueMYMYrMIqEo0znkENpVX
	wFpi2s0lrBDb5CVWbzgAVsMpYCPxZM4ysJMkBB6xA933mxmiyEXi984pULawxKvjW9ghbCmJ
	l/1tUHa+xM+Tt6CGFkh8+vKBBcI2lnh38zlQnAPoOk2J9bv0QUwJAWWJI7fAKpgF+CQ6Dv9l
	hwjzSnS0CUE0qkp0Hf/ACGFLSxy+chTqAA+JW18PsUHCpJ9R4suXN6wTGOVmISxYwMi4ilEs
	taA4Nz212KjACB5hyfm5mxjBCU/LbQfjlLcf9A4xMnEwHmKU4GBWEuEtOLgqRYg3JbGyKrUo
	P76oNCe1+BCjKTDsJjJLiSbnA1NuXkm8oYmlgYmZmaG5kamBuZI4773WuSlCAumJJanZqakF
	qUUwfUwcnFINTGXLJXZv6jiUN/d2bFuTFCurhlbYq87i1p3cpbfyORLsduzeMKtFsEOr13CH
	HMcb9aVbt5yT/nnr3aaHtUslLpbd72TYuEpY8aDZ4/sV5Wuan+acLc+4k8sTNqfr9hqD1l/V
	lbucs/z9P83adWzSMaOq9oj7ERYtyVwBpzVaLgc8ZjPb3etoI2t181jwj4NLjkh6/mL16Ll/
	6uITsz4zM5aiyCR1WWm1FO74ux/Duhvtr6WYrmO5lpXwKWarSLbPw8gb3S5B5yTyG1evKJ0R
	/E+tZu4uXR/txCR13veuG23r927ZWrwy2e7XkSuHN2WaHLlnU+r1zLJrU4OPQq3Yb53HwgkK
	oane7foxMqeVWIozEg21mIuKEwGvf4lZAQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsWy7bCSnO71/2tSDF7vt7a4+/gCm0Xz5MWM
	FtOnXmC0OHGzkc1i/9PnLBYHXjewWyw+OoPZ4ugeDovzs06xWKz88YfV4taEY0wO3B6L97xk
	8ti0qpPN48XmmYwefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlfH3nU7BA62Kc98OMDYwPlDu
	YuTkkBAwkejaeZmli5GLQ0hgN6PEvl0rmCAS0hL3mq+wQ9jCEvdbjrBCFHUzSdz80cwCkmAT
	0Ja4v30DG4gtIiAr0bzuARNIEbNAF7PEwf2/wRLCAlESiyZ/BJvEIqAq0TjnEVgzr4C1xLSb
	S1ghNshLrN5wgBnE5hSwkXgyZxlYjRBQzZUTF1gmMPItYGRYxSiZWlCcm55bbFhglJdarlec
	mFtcmpeul5yfu4kRHJxaWjsY96z6oHeIkYmD8RCjBAezkghvwcFVKUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5v73uTRESSE8sSc1OTS1ILYLJMnFwSjUwZXsrH2ta+Llz6STepYF9TupaXt0v
	fvv+OH3x+PNpfhEJR4pey+ys3PVw5sfr084f/PBo1o9q6RctT467m0yKsJ/wv6flfVeC/fO7
	UwNVFk58fNOtXtNamud6Y+OOlukzO++3G2tYMU/lXGf48b+7nY70hz8d6147c039OD1kxXyD
	dyc0fsRmsrC012sVRuvUdnQqlC3pS5XM1b4gMsFn7fETS29fLTsUMXWzgkhC5/81e7bpdm6d
	ntomZH49wWr9qY5bBha6i7TzZkfoZp86rrn2CfuHpKk9qj2C9tWlU0y2SFmbRTDUF7dLLWj/
	uKWUr/LeGbU1ajrqn/JMkvzjPP7zqSWzxot/u2IYEH5AiaU4I9FQi7moOBEA7QGPyr0CAAA=
X-CMS-MailID: 20230711070808epcas2p327adc8a7b29b653af17244d49eb38318
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711070808epcas2p327adc8a7b29b653af17244d49eb38318
References: <20230711071019.7151-1-jehoon.park@samsung.com>
	<CGME20230711070808epcas2p327adc8a7b29b653af17244d49eb38318@epcas2p3.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

CXL 3.0 Spec 8.2.9.8.3.3 defines Set Alert Configuration mailbox command which
allows a CXL host to configure programmable warning thresholds optionally.

Add methods to issue the command and set fields.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 Documentation/cxl/lib/libcxl.txt |  1 +
 cxl/lib/libcxl.c                 | 21 +++++++++++++++++++++
 cxl/lib/libcxl.sym               | 12 ++++++++++++
 cxl/lib/private.h                | 12 ++++++++++++
 cxl/libcxl.h                     | 16 ++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 31bc855..bcb8928 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -122,6 +122,7 @@ struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);
 struct cxl_cmd *cxl_cmd_new_identify(struct cxl_memdev *memdev);
 struct cxl_cmd *cxl_cmd_new_get_health_info(struct cxl_memdev *memdev);
 struct cxl_cmd *cxl_cmd_new_get_alert_config(struct cxl_memdev *memdev);
+struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev);
 struct cxl_cmd *cxl_cmd_new_read_label(struct cxl_memdev *memdev,
 					unsigned int offset, unsigned int length);
 struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev, void *buf,
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 769cd8a..a70b064 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -4166,3 +4166,24 @@ CXL_EXPORT int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf,
 {
 	return lsa_op(memdev, LSA_OP_GET, buf, length, offset);
 }
+
+#define cxl_alert_config_set_field(field)                                     \
+CXL_EXPORT int cxl_cmd_alert_config_set_##field(struct cxl_cmd *cmd, int val) \
+{                                                                             \
+	struct cxl_cmd_set_alert_config *setalert = cmd->input_payload;       \
+	setalert->field = val;                                                \
+	return 0;                                                             \
+}
+
+cxl_alert_config_set_field(life_used_prog_warn_threshold)
+cxl_alert_config_set_field(dev_over_temperature_prog_warn_threshold)
+cxl_alert_config_set_field(dev_under_temperature_prog_warn_threshold)
+cxl_alert_config_set_field(corrected_volatile_mem_err_prog_warn_threshold)
+cxl_alert_config_set_field(corrected_pmem_err_prog_warn_threshold)
+cxl_alert_config_set_field(valid_alert_actions)
+cxl_alert_config_set_field(enable_alert_actions)
+
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev)
+{
+	return cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_ALERT_CONFIG);
+}
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index c6545c7..334f01f 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -250,3 +250,15 @@ global:
 	cxl_region_get_daxctl_region;
 	cxl_port_get_parent_dport;
 } LIBCXL_4;
+
+LIBCXL_6 {
+global:
+	cxl_cmd_alert_config_set_life_used_prog_warn_threshold;
+	cxl_cmd_alert_config_set_dev_over_temperature_prog_warn_threshold;
+	cxl_cmd_alert_config_set_dev_under_temperature_prog_warn_threshold;
+	cxl_cmd_alert_config_set_corrected_volatile_mem_err_prog_warn_threshold;
+	cxl_cmd_alert_config_set_corrected_pmem_err_prog_warn_threshold;
+	cxl_cmd_alert_config_set_valid_alert_actions;
+	cxl_cmd_alert_config_set_enable_alert_actions;
+	cxl_cmd_new_set_alert_config;
+} LIBCXL_5;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index d49b560..43bf1d7 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -273,6 +273,18 @@ struct cxl_cmd_get_alert_config {
 #define CXL_CMD_ALERT_CONFIG_PROG_ALERTS_CORRECTED_PMEM_ERR_PROG_WARN_THRESHOLD_MASK \
 	BIT(4)
 
+/* CXL 3.0 8.2.9.8.3.3 Set Alert Configuration */
+struct cxl_cmd_set_alert_config {
+	u8 valid_alert_actions;
+	u8 enable_alert_actions;
+	u8 life_used_prog_warn_threshold;
+	u8 rsvd;
+	le16 dev_over_temperature_prog_warn_threshold;
+	le16 dev_under_temperature_prog_warn_threshold;
+	le16 corrected_volatile_mem_err_prog_warn_threshold;
+	le16 corrected_pmem_err_prog_warn_threshold;
+} __attribute__((packed));
+
 struct cxl_cmd_get_partition {
 	le64 active_volatile;
 	le64 active_persistent;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0218d73..c981683 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -425,6 +425,22 @@ enum cxl_setpartition_mode {
 int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
 		enum cxl_setpartition_mode mode);
 
+int cxl_cmd_alert_config_set_life_used_prog_warn_threshold(struct cxl_cmd *cmd,
+							   int threshold);
+int cxl_cmd_alert_config_set_dev_over_temperature_prog_warn_threshold(
+	struct cxl_cmd *cmd, int threshold);
+int cxl_cmd_alert_config_set_dev_under_temperature_prog_warn_threshold(
+	struct cxl_cmd *cmd, int threshold);
+int cxl_cmd_alert_config_set_corrected_volatile_mem_err_prog_warn_threshold(
+	struct cxl_cmd *cmd, int threshold);
+int cxl_cmd_alert_config_set_corrected_pmem_err_prog_warn_threshold(
+	struct cxl_cmd *cmd, int threshold);
+int cxl_cmd_alert_config_set_valid_alert_actions(struct cxl_cmd *cmd,
+						 int action);
+int cxl_cmd_alert_config_set_enable_alert_actions(struct cxl_cmd *cmd,
+						  int enable);
+struct cxl_cmd *cxl_cmd_new_set_alert_config(struct cxl_memdev *memdev);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.17.1

