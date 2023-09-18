Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234593FDB
	for <nvdimm@lists.linux.dev>; Mon, 18 Sep 2023 05:01:31 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230918045217epoutp04dca45aa07adcbc83f24f6232545fdf48~F5Rq5i0J01167411674epoutp04j
	for <nvdimm@lists.linux.dev>; Mon, 18 Sep 2023 04:52:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230918045217epoutp04dca45aa07adcbc83f24f6232545fdf48~F5Rq5i0J01167411674epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1695012737;
	bh=WITSivzty1sutl7GsE3AZ5XfJxUWoQ6qwVT9A5qu4jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czn1cYrF9VBjEPPhkHWbW8MiglnkF0spMKrlR04mvymBnyyxV4tNjlZ4Ns7Ktdm7y
	 41r73DyYcxlZO3aeVN71rvUZSEsqoOfrggCpF8uMMem6xmmlsQ+CJCgP0oN795an0Y
	 EzUU2C/3yPzrjqBMVmurNvtQi2JcEntL74UGDe7M=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230918045217epcas2p26ac191c79afaaff47f61c6534a208442~F5Rqa8XvX0464604646epcas2p2i;
	Mon, 18 Sep 2023 04:52:17 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.100]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Rpspm69Llz4x9Q7; Mon, 18 Sep
	2023 04:52:16 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	D4.B6.09765.087D7056; Mon, 18 Sep 2023 13:52:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230918045216epcas2p4a7e7cb5aeb67c0547f6af87ba1e48f20~F5Rpr6F7A1285412854epcas2p4l;
	Mon, 18 Sep 2023 04:52:16 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230918045216epsmtrp23f918a469a41efd2467128bd4da27280~F5RprNnF62553425534epsmtrp2j;
	Mon, 18 Sep 2023 04:52:16 +0000 (GMT)
X-AuditID: b6c32a48-66ffa70000002625-1e-6507d78059ab
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.02.08649.087D7056; Mon, 18 Sep 2023 13:52:16 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230918045216epsmtip1645f896986b741844b093bd464b9f974~F5RpfbkbD1531615316epsmtip16;
	Mon, 18 Sep 2023 04:52:16 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 1/2] libcxl: add support for Set Alert
 Configuration mailbox command
Date: Mon, 18 Sep 2023 13:55:13 +0900
Message-Id: <20230918045514.6709-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230918045514.6709-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmhW7DdfZUg0ftBhZ3H19gs5g+9QKj
	xYmbjWwWq2+uYbTY//Q5i8WB1w3sFqsWXmOzWHx0BrPF0T0cFudnnWKxWPnjD6vFrQnHmBx4
	PFqOvGX1WLznJZPHi80zGT36tqxi9Jg6u97j8ya5ALaobJuM1MSU1CKF1Lzk/JTMvHRbJe/g
	eOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoBOVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQXmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZz1dEFdzSqnhz5h1TA+Mt5S5GTg4J
	AROJabsPM3UxcnEICexglHjX85QZwvnEKHG2eTc7hPONUWLGvWUsMC1tLydDtexllPi+9whU
	VS+TRNfO5cwgVWwC2hL3t29gA7FFBGQlmtc9AOtgFtjMLLFs5zmwhLBAvMTbl/fBbBYBVYmf
	x/cydjFycPAKWEts+8IIsU1eYvWGA2AzOQVsJG7t6QG7T0LgI7vE75V/mCGKXCQmXP3IBmEL
	S7w6voUdwpaS+PxuL1Q8X+LnyVusEHaBxKcvH6DeMZZ4d/M5K8heZgFNifW79EFMCQFliSO3
	wCqYBfgkOg7/ZYcI80p0tAlBNKpKdB3/AHWltMThK0ehjvGQOHTtCiMkSPoZJf7e28I4gVFu
	FsKCBYyMqxjFUguKc9NTi40KTOARlpyfu4kRnAK1PHYwzn77Qe8QIxMH4yFGCQ5mJRHemYZs
	qUK8KYmVValF+fFFpTmpxYcYTYFBN5FZSjQ5H5iE80riDU0sDUzMzAzNjUwNzJXEee+1zk0R
	EkhPLEnNTk0tSC2C6WPi4JRqYKpukwgtv6J9NI/PX03gmwNnTcSmNWsnqHM/ceSZZzN58avM
	7gPm0n5NgrX7XH7cn3qMMe2LnsDL5PU7V1h+vl7e4vxs/jljxZs53/02HBc15Ly0o3KLPKtg
	si8HT3nV5/UnHWR5LjKwbux+lzgpy/TzLoHIktiDky7y3fi7YX3+9g+f5XMarsRdr3zr/km5
	9oBDa0+q/M8FhmtFampWKtw4WnvinYhV9evdklcjs3wz+W+9rY/7pyiRcfVZeJLFmjyVu1fr
	TlUfyNudZ+5fEVjYIcztqHdn87KNpopvfH/Z3FfzZLh9/NGPANEG4V19yhOn25fGy5a9ZZUR
	DmAvOhCXPv2aU6zvREtbXadtSizFGYmGWsxFxYkA+49F9woEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSnG7DdfZUg5ffRSzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBnPV0QV3NKq
	eHPmHVMD4y3lLkZODgkBE4m2l5OZuhi5OIQEdjNKzH7wkx0iIS1xr/kKlC0scb/lCCtEUTeT
	xLxzqxhBEmwC2hL3t29gA7FFBGQlmtc9AJvELLCXWaJj5nmgDg4OYYFYiUfvi0BqWARUJX4e
	38sIEuYVsJbY9oURYr68xOoNB5hBbE4BG4lbe3rAbCGgkl/tr9knMPItYGRYxSiZWlCcm56b
	bFhgmJdarlecmFtcmpeul5yfu4kRHKpaGjsY783/p3eIkYmD8RCjBAezkgjvTEO2VCHelMTK
	qtSi/Pii0pzU4kOM0hwsSuK8hjNmpwgJpCeWpGanphakFsFkmTg4pRqYjm2d6XuZ6/TLaRdi
	DsRG3ptuvdnwJ6fYeoGS/nKjs2vnfjXLvGUTdpCLsZthr5Q0h/XNTXNfL0ouirtx/sEh32Nm
	B5dKPTk57XjdD8P7qY/XBfGqz13k+tzVvWRfce3lJy/yP/8y4p6a++bEkbash5f267g6euSG
	b7Z4eu/mqm3tG8RV6+5yxj4K+jaFeUOr2n5z/fDeU3yhE1a75M7/ujOiYrK0jMFXM9lu910r
	Yxqln/CIfuiaZPL6T/DdxWyLb63XcxIwfZ0sZC2ldWaqxNFbx1z3KUtbZV5xsXf+evqM6jn/
	GOU9sn0WOwUWXGI6/uJK+V22qxme5n+dlA8kuHa9a7wqtdBBRGpiOdsLSyWW4oxEQy3mouJE
	AFAYoCnEAgAA
X-CMS-MailID: 20230918045216epcas2p4a7e7cb5aeb67c0547f6af87ba1e48f20
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230918045216epcas2p4a7e7cb5aeb67c0547f6af87ba1e48f20
References: <20230918045514.6709-1-jehoon.park@samsung.com>
	<CGME20230918045216epcas2p4a7e7cb5aeb67c0547f6af87ba1e48f20@epcas2p4.samsung.com>
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
index af4ca44..c781566 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -4465,3 +4465,24 @@ CXL_EXPORT int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf,
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
index 8fa1cca..6beca52 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -264,3 +264,15 @@ global:
 	cxl_memdev_update_fw;
 	cxl_memdev_cancel_fw_update;
 } LIBCXL_5;
+
+LIBCXL_7 {
+global:
+	cxl_cmd_alert_config_set_life_used_prog_warn_threshold;
+	cxl_cmd_alert_config_set_dev_over_temperature_prog_warn_threshold;
+	cxl_cmd_alert_config_set_dev_under_temperature_prog_warn_threshold;
+	cxl_cmd_alert_config_set_corrected_volatile_mem_err_prog_warn_threshold;
+	cxl_cmd_alert_config_set_corrected_pmem_err_prog_warn_threshold;
+	cxl_cmd_alert_config_set_valid_alert_actions;
+	cxl_cmd_alert_config_set_enable_alert_actions;
+	cxl_cmd_new_set_alert_config;
+} LIBCXL_6;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index a641727..b26a862 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -309,6 +309,18 @@ struct cxl_cmd_get_alert_config {
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
index 0f4f4b2..b0ec369 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -461,6 +461,22 @@ enum cxl_setpartition_mode {
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

