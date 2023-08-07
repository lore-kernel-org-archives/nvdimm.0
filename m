Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A97800
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:41:31 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230807063156epoutp041b188b6766cf3aa265c096b8cfba8bff~5BirZR6mO2894628946epoutp04Q
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:31:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230807063156epoutp041b188b6766cf3aa265c096b8cfba8bff~5BirZR6mO2894628946epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691389916;
	bh=WITSivzty1sutl7GsE3AZ5XfJxUWoQ6qwVT9A5qu4jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9bEUxM547kyK0BQU5qF/CxBtBkV7B57sADFGziOzBfvEblMzl3ROzi8nvnJ+uUJp
	 ErDVXa2TLI08z/yyXPemS9kiyBJ/43DvKg8mKJcntntY2mWpSpHSZOkpx5wMrhD4Q/
	 asIaJ4OgWqUFxWf643iW6ojn+/LjH/1w724q4O7c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230807063155epcas2p140fc2207f550440fc0be5747e757b193~5Biqzeg2Y3109831098epcas2p1q;
	Mon,  7 Aug 2023 06:31:55 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.100]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4RK61718rzz4x9QJ; Mon,  7 Aug
	2023 06:31:55 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	52.0F.49913.BDF80D46; Mon,  7 Aug 2023 15:31:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230807063154epcas2p474cf88b864ca6c87f656853546256416~5BiqBUQGz0228502285epcas2p46;
	Mon,  7 Aug 2023 06:31:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230807063154epsmtrp11b86cbb9a69e1a34e3ccde927ce62f4d~5BiqAZ2G22561925619epsmtrp1J;
	Mon,  7 Aug 2023 06:31:54 +0000 (GMT)
X-AuditID: b6c32a45-5cfff7000000c2f9-a2-64d08fdbcca7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.FE.34491.ADF80D46; Mon,  7 Aug 2023 15:31:54 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230807063154epsmtip17f4f34303d414ea2830f50827b27d3f4~5BipxKLmz1457214572epsmtip1D;
	Mon,  7 Aug 2023 06:31:54 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 1/2] libcxl: add support for Set Alert
 Configuration mailbox command
Date: Mon,  7 Aug 2023 15:33:34 +0900
Message-Id: <20230807063335.5891-2-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807063335.5891-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmqe7t/gspBttesljcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiism0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgE5UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnPF8RVXBLq+LNmXdMDYy3lLsYOTkk
	BEwkbi37zdbFyMUhJLCDUWLytanMEM4nRondq55DZb4xSux4N4cNpmXygyZ2iMReRolZF24z
	gSSEBHqZJDbO4QSx2QS0Je5v3wDWICIgK9G87gETSAOzwGZmiWU7z4ElhAXiJRb1XWUGsVkE
	VCWmfp4KFucVsJa4uXoXC8Q2eYnVGw6A1XAK2Eg8PXcBbLOEwFd2iZvtB5khilwk5u18yQph
	C0u8Or6FHcKWknjZ3wZl50v8PHkLqqZA4tOXD1ALjCXe3XwOFOcAuk5TYv0ufRBTQkBZ4sgt
	sApmAT6JjsN/2SHCvBIdbUIQjaoSXcc/MELY0hKHrxyFOsZD4lT7GlZI+PQzSszvWMc6gVFu
	FsKCBYyMqxjFUguKc9NTi40KDOERlpyfu4kRnAK1XHcwTn77Qe8QIxMH4yFGCQ5mJRHeeU/O
	pwjxpiRWVqUW5ccXleakFh9iNAWG3URmKdHkfGASziuJNzSxNDAxMzM0NzI1MFcS573XOjdF
	SCA9sSQ1OzW1ILUIpo+Jg1Oqgcn46H2xl72PNLPOBPvJxXgEzHLvroi5upBpSb/MZg9t7Zux
	37wP93A+Z9EUeJwrOV1F88OxrQcWHNq/e2vm69gJWRsz+KbtUF4p/KPrutmBrpKWWevfFhsp
	WkTLHQ40v7lpS6ZKn0zd41fHmG9xbQneGDhrntIltVm/8x9MMIhOiYu8uOLd5knxt5Zx3jy8
	6/euM3+emu/pOqRyfyvbxYeJU/2ven1SXDXP9szvYxrx7mfU3uvXbvyfF/e8J8Y1qVPkf26b
	8SmGi6mPhbQn3FefLCspNelm90Xnbb/2dU290j4p+/Hr3+JZoVI/Myf86ZqxIqJjksjLrWsE
	bszf8nD26k3rbL0jhdfsPNSRlMNWqsRSnJFoqMVcVJwIAM4edoMKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWy7bCSnO6t/gspBu33FCzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBnPV0QV3NKq
	eHPmHVMD4y3lLkZODgkBE4nJD5rYuxg5OIQEdjNKLDeDCEtL3Gu+wg5hC0vcbznC2sXIBVTS
	zSTxZ34TC0iCTUBb4v72DWwgtoiArETzugdMIEXMAnuZJTpmnmcFSQgLxEr8ed8M1sAioCox
	9fNUsAZeAWuJm6t3sUBskJdYveEAM4jNKWAj8fTcBbDNQkA1CydsZ53AyLeAkWEVo2RqQXFu
	em6xYYFhXmq5XnFibnFpXrpecn7uJkZwqGpp7mDcvuqD3iFGJg7GQ4wSHMxKIrzznpxPEeJN
	SaysSi3Kjy8qzUktPsQozcGiJM4r/qI3RUggPbEkNTs1tSC1CCbLxMEp1cBk2OLvt1bcbOu8
	td/OfJhxdPevBbx/qqJZViboLpZ/VaKsu8V27tNl38+w66SWlHybeMtxx7eQ+X9nSq7MtG6R
	MAhL/y1bysun1q9QsE1oYrHqzrgZz05snSPWvsr06sI982xbDwd4Rc9UzymXCvU/YbaJ6bns
	hKsveuXFdneHZ6rZPd7eNqtHbMkxh5sXD4Q7PNt58+fhhtLjG/jn75EOiSzf9tl0xrzVXy4W
	HY58W7hWt5KPqXe7gu60qQx1u+a9b+E00l3jF1i7M9agecvUsAJfk7xrtr0aC598O8Lh2fNN
	KUTFYW0Qlwxbj6LHy5ppbhMs+bInHlq9Sbvz+szcwJ2ML/QzM/sC1/hwsV9WYinOSDTUYi4q
	TgQAt1lJlcQCAAA=
X-CMS-MailID: 20230807063154epcas2p474cf88b864ca6c87f656853546256416
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063154epcas2p474cf88b864ca6c87f656853546256416
References: <20230807063335.5891-1-jehoon.park@samsung.com>
	<CGME20230807063154epcas2p474cf88b864ca6c87f656853546256416@epcas2p4.samsung.com>
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

