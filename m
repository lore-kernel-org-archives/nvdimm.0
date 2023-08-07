Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E117F7
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:40:00 +0000 (UTC)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230807063202epoutp021c6231c9c6dd2e5499d0fca86597b4d8~5BixtE-td2586525865epoutp02m
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:32:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230807063202epoutp021c6231c9c6dd2e5499d0fca86597b4d8~5BixtE-td2586525865epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691389922;
	bh=i1NwokQPzv5a5ofSquoEuMmwvXrFjsYyHaJfgflzWAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0r9i38hMUHnoBC46UOVZ8jgvUHtrpGXYlFFPuB2Ob0L0evhNUaGWGAcj4+M9Cf8S
	 giS9aS+qmplJCONfBIU69dC21gLwvD4HbKmejqoZccd3Av1qKPCAZ7V3m8cEGVdnVJ
	 zYug3SV9mShgKrdmyPuhoBjnfGdlV+K32MiJHPnE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20230807063202epcas2p40c39b5cfbdedcd29cc8514129ab6f3de~5Biw2-zK50229202292epcas2p4Y;
	Mon,  7 Aug 2023 06:32:02 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.92]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RK61F2wNMz4x9Q3; Mon,  7 Aug
	2023 06:32:01 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	D8.84.32393.1EF80D46; Mon,  7 Aug 2023 15:32:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a~5Bivy86ZK2048820488epcas2p2b;
	Mon,  7 Aug 2023 06:32:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230807063200epsmtrp1f4e4bfccc62e629ecef79b386af00035~5BivyMEO12568225682epsmtrp1C;
	Mon,  7 Aug 2023 06:32:00 +0000 (GMT)
X-AuditID: b6c32a48-adffa70000007e89-17-64d08fe1cb4b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	35.FE.34491.0EF80D46; Mon,  7 Aug 2023 15:32:00 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230807063200epsmtip1dd04c9f481a0cd703c512acbe9a754ae~5Bivjy4b41186011860epsmtip1G;
	Mon,  7 Aug 2023 06:32:00 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 2/2] cxl: add 'set-alert-config' command to cxl
 tool
Date: Mon,  7 Aug 2023 15:33:35 +0900
Message-Id: <20230807063335.5891-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807063335.5891-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmme7D/gspBuubeS3uPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCcqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
	S2yVUgtScgrMC/SKE3OLS/PS9fJSS6wMDQyMTIEKE7Iz+hZPZi/oras4tfAkWwPj5aguRk4O
	CQETiX9vT7J2MXJxCAnsYJRoeDSTBSQhJPCJUeLmTQ+IxDdGia1TnjPDdBy8uZoJIrGXUWL7
	ja9sEE4vk8TOyyeYQKrYBLQl7m/fwAZiiwjISjSvewDWwSywmVli2c5zYAlhAX+Jk6vms4LY
	LAKqEs2XLoDZvALWEu//P2WBWCcvsXrDAbDVnAI2Ek/PXWAHGSQh8JVd4sHJHewQRS4SJz89
	Z4SwhSVeHd8CFZeSeNnfBmXnS/w8eYsVwi6Q+PTlA9QCY4l3N58DxTmArtOUWL9LH8SUEFCW
	OHILrIJZgE+i4/Bfdogwr0RHmxBEo6pE1/EPUEulJQ5fOQoNIA+J4+tbGSFh0s8ocbXzIeME
	RrlZCAsWMDKuYhRLLSjOTU8tNiowgcdYcn7uJkZwEtTy2ME4++0HvUOMTByMhxglOJiVRHjn
	PTmfIsSbklhZlVqUH19UmpNafIjRFBh2E5mlRJPzgWk4ryTe0MTSwMTMzNDcyNTAXEmc917r
	3BQhgfTEktTs1NSC1CKYPiYOTqkGJrE/om6PJjtq53q+tZH3ldJZk+7GUXIirlz1w5a79/fk
	HrB2vHbjU4BX2e3LCd4pR5riLc7U9K92P6M+W2Zud739Gf0JXz4bW8tPE4kTUzc+f2C9+UWJ
	Gf8fvDbacdLcPHRadsabLz4FjvU7NSsVlyasizvutm/1k8DvF14ldgq+LX9Qqsrdb7W8pzW9
	yPx0eYBU/4Lq/WtWsf/Xas96c9T4rIBsQpc0o1abUtblC5MPcdcHn1p/9v58jir/vW6Xvy06
	kSwuZT1ZRmXWOV/2u/I1K312f4qXdqlYfrd/15l4n3OV/T/Wse7PURRa0F7joWv8uuTB4wnX
	u7WrS85GRF/X3xnPsU3w3v/ZsRe/K7EUZyQaajEXFScCAB4+l9gLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSnO6D/gspBr/P61ncfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiiuGxSUnMyy1KL9O0SuDL6Fk9mL+it
	qzi18CRbA+PlqC5GTg4JAROJgzdXM3UxcnEICexmlDj1fAELREJa4l7zFXYIW1jifssRVoii
	biaJG88PsYEk2AS0Je5v3wBmiwjISjSvewA2iVlgL7NEx8zzrCAJYQFfibmrP4HZLAKqEs2X
	LoDZvALWEu//P4XaJi+xesMBZhCbU8BG4um5C2CbhYBqFk7YzjqBkW8BI8MqRsnUguLc9Nxi
	wwLDvNRyveLE3OLSvHS95PzcTYzggNXS3MG4fdUHvUOMTByMhxglOJiVRHjnPTmfIsSbklhZ
	lVqUH19UmpNafIhRmoNFSZxX/EVvipBAemJJanZqakFqEUyWiYNTqoFpv9mlhLsq71T60ucv
	TTa5NaeQgSf2pLXFM4eS7QdvLbghccnrbfdzLpG09RbBOzSnKNmXL9Ln00+LW/dsl6o/+6w4
	W5usyhsi82umBF2JvcW+eZX1t5B0o99pirP2Bm7flbQsJW4D4+3GE51neOzCLS7y2h2zOr9/
	dtSUe9v+f5OwYq2fs7Flk3OK0I5T92ySNxzfu39GwaJrkTvWyDH8CbQ5ON/03daaTzN0HTKX
	qtS/u6/JOGVqd4iIRiLzbEH53oMXH6Zwtby6skrvipLGza6YRYsPfL29a8nn1kO3Tf+WfF/S
	Pv2MWLjegjvCF/ZNEksVPL7v55dq9g1rFs5Um8S7Sel26Nq0pw+qn0bn/1ViKc5INNRiLipO
	BAAGu2x4xwIAAA==
X-CMS-MailID: 20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a
References: <20230807063335.5891-1-jehoon.park@samsung.com>
	<CGME20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Add a new command: 'set-alert-config', which configures device's warning alert.

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 Documentation/cxl/cxl-set-alert-config.txt |  96 +++++++++
 Documentation/cxl/meson.build              |   1 +
 cxl/builtin.h                              |   1 +
 cxl/cxl.c                                  |   1 +
 cxl/memdev.c                               | 220 ++++++++++++++++++++-
 5 files changed, 318 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-set-alert-config.txt

diff --git a/Documentation/cxl/cxl-set-alert-config.txt b/Documentation/cxl/cxl-set-alert-config.txt
new file mode 100644
index 0000000..c905f7c
--- /dev/null
+++ b/Documentation/cxl/cxl-set-alert-config.txt
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-set-alert-config(1)
+=======================
+
+NAME
+----
+cxl-set-alert-config - set the warning alert threshold on a CXL memdev
+
+SYNOPSIS
+--------
+[verse]
+'cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]'
+
+DESCRIPTION
+-----------
+CXL device raises an alert when its health status is changed. Critical alert
+shall automatically be configured by the device after a device reset.
+If supported, programmable warning thresholds also be initialized to vendor
+recommended defaults, then could be configured by the user.
+
+Use this command to configure warning alert thresholds of a device.
+Having issued this command, the newly requested warning thresholds would
+override the previously programmed warning thresholds.
+
+To enable warning alert, set both 'threshold=value' and 'alert=on'. To disable
+warning alert, set only 'alert=off'. Other cases would cause errors.
+
+Use "cxl list -m <memdev> -A" to examine the programming warning threshold
+capabilities of a device.
+
+EXAMPLES
+--------
+Set warning threshold to 30 and enable alert for life used.
+[verse]
+cxl set-alert-config mem0 -L 30 --life-used-alert=on
+
+Disable warning alert for device over temperature.
+[verse]
+cxl set-alert-config mem0 --over-temperature-alert=off
+
+OPTIONS
+-------
+<memory device(s)>::
+include::memdev-option.txt[]
+
+-v::
+--verbose=::
+        Turn on verbose debug messages in the library (if libcxl was built with
+        logging and debug enabled).
+
+-L::
+--life-used-threshold=::
+	Set <value> for the life used warning alert threshold.
+
+--life-used-alert=::
+	Enable or disable the life used warning alert.
+	Options are 'on' or 'off'.
+
+-O::
+--over-temperature-threshold=::
+	Set <value> for the device over temperature warning alert threshold.
+
+--over-temperature-alert=::
+	Enable or disable the device over temperature warning alert.
+	Options are 'on' or 'off'.
+
+-U::
+--under-temperature-threshold=::
+	Set <value> for the device under temperature warning alert threshold.
+
+--under-temperature-alert=::
+	Enable or disable the device under temperature warning alert.
+	Options are 'on' or 'off'.
+
+-V::
+--volatile-mem-err-threshold=::
+	Set <value> for the corrected volatile memory error warning alert
+	threshold.
+
+--volatile-mem-err-alert=::
+	Enable or disable the corrected volatile memory error warning alert.
+	Options are 'on' or 'off'.
+
+-P::
+--pmem-err-threshold=::
+	Set <value> for the corrected persistent memory error warning alert
+	threshold.
+
+--pmem-err-alert=::
+	Enable or disable the corrected persistent memory error warning alert.
+	Options are 'on' or 'off'.
+
+SEE ALSO
+--------
+CXL-3.0 8.2.9.8.3.3
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index c553357..865aad5 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -47,6 +47,7 @@ cxl_manpages = [
   'cxl-destroy-region.txt',
   'cxl-monitor.txt',
   'cxl-update-firmware.txt',
+  'cxl-set-alert-config.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 3ec6c6c..2c46a82 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -15,6 +15,7 @@ int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
diff --git a/cxl/cxl.c b/cxl/cxl.c
index e1524b8..bf4822f 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -69,6 +69,7 @@ static struct cmd_struct commands[] = {
 	{ "reserve-dpa", .c_fn = cmd_reserve_dpa },
 	{ "free-dpa", .c_fn = cmd_free_dpa },
 	{ "update-firmware", .c_fn = cmd_update_fw },
+	{ "set-alert-config", .c_fn = cmd_set_alert_config },
 	{ "disable-port", .c_fn = cmd_disable_port },
 	{ "enable-port", .c_fn = cmd_enable_port },
 	{ "set-partition", .c_fn = cmd_set_partition },
diff --git a/cxl/memdev.c b/cxl/memdev.c
index f6a2d3f..2dd2e7f 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -38,10 +38,38 @@ static struct parameters {
 	const char *type;
 	const char *size;
 	const char *decoder_filter;
+	const char *life_used_threshold;
+	const char *dev_over_temperature_threshold;
+	const char *dev_under_temperature_threshold;
+	const char *corrected_volatile_mem_err_threshold;
+	const char *corrected_pmem_err_threshold;
+	const char *life_used_alert;
+	const char *dev_over_temperature_alert;
+	const char *dev_under_temperature_alert;
+	const char *corrected_volatile_mem_err_alert;
+	const char *corrected_pmem_err_alert;
 } param;
 
 static struct log_ctx ml;
 
+struct alert_context {
+	int valid_alert_actions;
+	int enable_alert_actions;
+	int life_used_threshold;
+	int dev_over_temperature_threshold;
+	int dev_under_temperature_threshold;
+	int corrected_volatile_mem_err_threshold;
+	int corrected_pmem_err_threshold;
+};
+
+enum cxl_setalert_event {
+	CXL_SETALERT_LIFE_USED,
+	CXL_SETALERT_OVER_TEMP,
+	CXL_SETALERT_UNDER_TEMP,
+	CXL_SETALERT_VOLATILE_MEM_ERROR,
+	CXL_SETALERT_PMEM_ERROR,
+};
+
 enum cxl_setpart_type {
 	CXL_SETPART_PMEM,
 	CXL_SETPART_VOLATILE,
@@ -99,6 +127,36 @@ OPT_BOOLEAN('c', "cancel", &param.cancel,                            \
 OPT_BOOLEAN('w', "wait", &param.wait,                                \
 	    "wait for firmware update to complete before returning")
 
+#define SET_ALERT_OPTIONS()                                                   \
+OPT_STRING('L', "life-used-threshold", &param.life_used_threshold,            \
+	   "threshold", "threshold value for life used warning alert"),       \
+OPT_STRING('\0', "life-used-alert", &param.life_used_alert,                   \
+	   "'on' or 'off'", "enable or disable life used warning alert"),     \
+OPT_STRING('O', "over-temperature-threshold",                                 \
+	   &param.dev_over_temperature_threshold, "threshold",                \
+	   "threshold value for device over temperature warning alert"),      \
+OPT_STRING('\0', "over-temperature-alert",                                    \
+	   &param.dev_over_temperature_alert, "'on' or 'off'",                \
+	   "enable or disable device over temperature warning alert"),        \
+OPT_STRING('U', "under-temperature-threshold",                                \
+	   &param.dev_under_temperature_threshold, "threshold",               \
+	   "threshold value for device under temperature warning alert"),     \
+OPT_STRING('\0', "under-temperature-alert",                                   \
+	   &param.dev_under_temperature_alert, "'on' or 'off'",               \
+	   "enable or disable device under temperature warning alert"),       \
+OPT_STRING('V', "volatile-mem-err-threshold",                                 \
+	   &param.corrected_volatile_mem_err_threshold, "threshold",          \
+	   "threshold value for corrected volatile mem error warning alert"), \
+OPT_STRING('\0', "volatile-mem-err-alert",                                    \
+	   &param.corrected_volatile_mem_err_alert, "'on' or 'off'",          \
+	   "enable or disable corrected volatile mem error warning alert"),   \
+OPT_STRING('P', "pmem-err-threshold",                                         \
+	   &param.corrected_pmem_err_threshold, "threshold",                  \
+	   "threshold value for corrected pmem error warning alert"),         \
+OPT_STRING('\0', "pmem-err-alert",                                            \
+	   &param.corrected_pmem_err_alert, "'on' or 'off'",                  \
+	   "enable or disable corrected pmem error warning alert")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	LABEL_OPTIONS(),
@@ -155,6 +213,12 @@ static const struct option update_fw_options[] = {
 	OPT_END(),
 };
 
+static const struct option set_alert_options[] = {
+	BASE_OPTIONS(),
+	SET_ALERT_OPTIONS(),
+	OPT_END(),
+};
+
 enum reserve_dpa_mode {
 	DPA_ALLOC,
 	DPA_FREE,
@@ -706,6 +770,148 @@ static int action_update_fw(struct cxl_memdev *memdev,
 	return rc;
 }
 
+static int validate_alert_threshold(enum cxl_setalert_event event,
+				    int threshold)
+{
+	if (event == CXL_SETALERT_LIFE_USED) {
+		if (threshold < 0 || threshold > 100) {
+			log_err(&ml, "Invalid life used threshold: %d\n",
+				threshold);
+			return -EINVAL;
+		}
+	} else if (event == CXL_SETALERT_OVER_TEMP ||
+		   event == CXL_SETALERT_UNDER_TEMP) {
+		if (threshold < SHRT_MIN || threshold > SHRT_MAX) {
+			log_err(&ml,
+				"Invalid device temperature threshold: %d\n",
+				threshold);
+			return -EINVAL;
+		}
+	} else {
+		if (threshold < 0 || threshold > USHRT_MAX) {
+			log_err(&ml,
+				"Invalid corrected mem error threshold: %d\n",
+				threshold);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+#define alert_param_set_threshold(arg, alert_event)                           \
+{                                                                             \
+	if (!param.arg##_alert) {                                             \
+		if (param.arg##_threshold) {                                  \
+			log_err(&ml, "Action not specified\n");               \
+			return -EINVAL;                                       \
+		}                                                             \
+	} else if (strcmp(param.arg##_alert, "on") == 0) {                    \
+		if (param.arg##_threshold) {                                  \
+			char *endptr;                                         \
+			alertctx.arg##_threshold =                            \
+				strtol(param.arg##_threshold, &endptr, 10);   \
+			if (endptr[0] != '\0') {                              \
+				log_err(&ml, "Invalid threshold: %s\n",       \
+					param.arg##_threshold);               \
+				return -EINVAL;                               \
+			}                                                     \
+			rc = validate_alert_threshold(                        \
+				alert_event, alertctx.arg##_threshold);       \
+			if (rc != 0)                                          \
+				return rc;                                    \
+			alertctx.valid_alert_actions |= 1 << alert_event;     \
+			alertctx.enable_alert_actions |= 1 << alert_event;    \
+		} else {                                                      \
+			log_err(&ml, "Threshold not specified\n");            \
+			return -EINVAL;                                       \
+		}                                                             \
+	} else if (strcmp(param.arg##_alert, "off") == 0) {                   \
+		if (!param.arg##_threshold) {                                 \
+			alertctx.valid_alert_actions |= 1 << alert_event;     \
+			alertctx.enable_alert_actions &= ~(1 << alert_event); \
+		} else {                                                      \
+			log_err(&ml, "Disable not require threshold\n");      \
+			return -EINVAL;                                       \
+		}                                                             \
+	} else {                                                              \
+		log_err(&ml, "Invalid action: %s\n", param.arg##_alert);      \
+		return -EINVAL;                                               \
+	}                                                                     \
+}
+
+#define setup_threshold_field(arg)                                            \
+{                                                                             \
+	if (param.arg##_threshold)                                            \
+		cxl_cmd_alert_config_set_##arg##_prog_warn_threshold(         \
+			cmd, alertctx.arg##_threshold);                       \
+}
+
+static int action_set_alert_config(struct cxl_memdev *memdev,
+				   struct action_context *actx)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_cmd *cmd;
+	struct alert_context alertctx = { 0 };
+	struct json_object *jmemdev;
+	unsigned long flags;
+	int rc = 0;
+
+	alert_param_set_threshold(life_used, CXL_SETALERT_LIFE_USED)
+	alert_param_set_threshold(dev_over_temperature, CXL_SETALERT_OVER_TEMP)
+	alert_param_set_threshold(dev_under_temperature,
+				  CXL_SETALERT_UNDER_TEMP)
+	alert_param_set_threshold(corrected_volatile_mem_err,
+				  CXL_SETALERT_VOLATILE_MEM_ERROR)
+	alert_param_set_threshold(corrected_pmem_err, CXL_SETALERT_PMEM_ERROR)
+	if (alertctx.valid_alert_actions == 0) {
+		log_err(&ml, "No action specified\n");
+		return -EINVAL;
+	}
+
+	cmd = cxl_cmd_new_set_alert_config(memdev);
+	if (!cmd) {
+		rc = -ENXIO;
+		goto out_err;
+	}
+
+	setup_threshold_field(life_used)
+	setup_threshold_field(dev_over_temperature)
+	setup_threshold_field(dev_under_temperature)
+	setup_threshold_field(corrected_volatile_mem_err)
+	setup_threshold_field(corrected_pmem_err)
+	cxl_cmd_alert_config_set_valid_alert_actions(
+		cmd, alertctx.valid_alert_actions);
+	cxl_cmd_alert_config_set_enable_alert_actions(
+		cmd, alertctx.enable_alert_actions);
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0) {
+		log_err(&ml, "cmd submission failed: %s\n", strerror(-rc));
+		goto out_cmd;
+	}
+
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0) {
+		log_err(&ml, "%s: mbox status: %d\n", __func__, rc);
+		rc = -ENXIO;
+	}
+
+out_cmd:
+	cxl_cmd_unref(cmd);
+out_err:
+	if (rc)
+		log_err(&ml, "%s error: %s\n", devname, strerror(-rc));
+
+	flags = UTIL_JSON_ALERT_CONFIG;
+	if (actx->f_out == stdout && isatty(1))
+		flags |= UTIL_JSON_HUMAN;
+	jmemdev = util_cxl_memdev_to_json(memdev, flags);
+	if (actx->jdevs && jmemdev)
+		json_object_array_add(actx->jdevs, jmemdev);
+
+	return rc;
+}
+
 static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			 int (*action)(struct cxl_memdev *memdev,
 				       struct action_context *actx),
@@ -749,7 +955,8 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	}
 
 	if (action == action_setpartition || action == action_reserve_dpa ||
-	    action == action_free_dpa || action == action_update_fw)
+	    action == action_free_dpa || action == action_update_fw ||
+	    action == action_set_alert_config)
 		actx.jdevs = json_object_new_array();
 
 	if (err == argc) {
@@ -968,3 +1175,14 @@ int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx)
 
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(
+		argc, argv, ctx, action_set_alert_config, set_alert_options,
+		"cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]");
+	log_info(&ml, "set alert configuration for %d mem%s\n",
+		 count >= 0 ? count : 0, count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
-- 
2.17.1

