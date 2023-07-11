Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91215171BB
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 07:15:47 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230711070822epoutp03b8d954537421303a6939ebe3398ac966~wvnx07UJC0509105091epoutp03M
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 07:08:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230711070822epoutp03b8d954537421303a6939ebe3398ac966~wvnx07UJC0509105091epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1689059302;
	bh=PeznLp+QChb8GZyUlzCUDTlSHKy7b9Tl1ojTFn1Xi+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2ATooyp/VikA/1U0ChUCXu//6aSfaWvW6YDo9s9p3yonJvqZZR4h97tEBXicaBSI
	 SEMiBU/tXhVdyHyJuSV7k5mhJx0pUbTD+ZHtx0Q/rBL8canB6lzNHUAeEwvTSzn1/U
	 onoegTy9ikF4JkN9/Co5zqIk29KjYMONgATL56Eg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230711070821epcas2p1a80b602222eb41debd894f4d59e1728f~wvnxUG74O0398103981epcas2p1Y;
	Tue, 11 Jul 2023 07:08:21 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.101]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4R0X5c5qBPz4x9Q5; Tue, 11 Jul
	2023 07:08:20 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	BE.09.40133.4EFFCA46; Tue, 11 Jul 2023 16:08:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230711070820epcas2p4ec4884b434c9cb748d5ebda4dd385955~wvnwUOcAa3251032510epcas2p44;
	Tue, 11 Jul 2023 07:08:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230711070820epsmtrp2b886fb7a724153bf191883d1e81a38d0~wvnwTMt8x1113611136epsmtrp2X;
	Tue, 11 Jul 2023 07:08:20 +0000 (GMT)
X-AuditID: b6c32a46-4edb870000009cc5-23-64acffe42e36
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	20.63.34491.4EFFCA46; Tue, 11 Jul 2023 16:08:20 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230711070820epsmtip1ce4740f21a573ec6415b11f1a3dce6ff~wvnwBkeoc1608916089epsmtip1r;
	Tue, 11 Jul 2023 07:08:20 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH 2/2] cxl: add 'set-alert-config' command to cxl tool
Date: Tue, 11 Jul 2023 16:10:19 +0900
Message-Id: <20230711071019.7151-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230711071019.7151-1-jehoon.park@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmue6T/2tSDBY06ljcfXyBzaJ58mJG
	i+lTLzBanLjZyGax/+lzFosDrxvYLRYfncFscXQPh8X5WadYLFb++MNqcWvCMSYHbo/Fe14y
	eWxa1cnm8WLzTEaPvi2rGD0+b5ILYI3KtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2Be
	oFecmFtcmpeul5daYmVoYGBkClSYkJ3RfYyl4EULY8WbNa3MDYyz47oYOTkkBEwkvk1YwtzF
	yMUhJLCDUeJT/x8o5xOjxMfL71kgnG+MEnfPv2eCaTm4ayOYLSSwl1Hi/xdhiKJeJonHbzax
	gCTYBLQl7m/fwAZiiwjISjSve8AEUsQs0MAs8W7VVaAEB4ewgJfEuQZHkBoWAVWJtXMXgA3l
	FbCW+LjsETvEMnmJ1RsOMIPYnAI2Ek/mLAO7SELgJbvE3ZWbmEDmSAi4SJw9YQFRLyzx6vgW
	qF4pic/v9rJB2PkSP0/eYoWwCyQ+ffnAAmEbS7y7+ZwVZAyzgKbE+l36EBOVJY7cAqtgFuCT
	6Dj8lx0izCvR0SYE0agq0XX8AyOELS1x+MpRZgjbQ6K9cRoTJET6GSWuLd/KOIFRbhbCggWM
	jKsYxVILinPTU4uNCozg8ZWcn7uJEZzutNx2ME55+0HvECMTB+MhRgkOZiUR3oKDq1KEeFMS
	K6tSi/Lji0pzUosPMZoCg24is5Rocj4w4eaVxBuaWBqYmJkZmhuZGpgrifPea52bIiSQnliS
	mp2aWpBaBNPHxMEp1cBkffkk59zi7zrixc9Mvt+VLQt+I/Z+52kmm22TkxS3majs7JT9/+e0
	403ll0f1/nzqllp8RGnbLvZbLFJCQmHvL6qwBuZfCH+l2fMk4MXHXRwKP9f6PM7a7SNrHXzA
	pOrVrtl75rbeudOgd+hGZf6WDzN+Wv3beHDB3KzsyoxeGd2/cffUe87w99xcszt73bWJTxxO
	X/zsevFYruO/i/+PBUT/c3dM1NrqZvbDSJu7pJ7h6IucC1ym3A89AtmAWSTRxmzzx9cCm8Pr
	l7TIb130UevMTVuR3x2Tzlyo2Pdmz6zkW5e/pk1cvUFummCRLcMePpsfjMYblBv+9rnJTc7r
	VlYVnDC9+Ghb/6nGyoA2JZbijERDLeai4kQAxVTU1wAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsWy7bCSnO6T/2tSDJqn81jcfXyBzaJ58mJG
	i+lTLzBanLjZyGax/+lzFosDrxvYLRYfncFscXQPh8X5WadYLFb++MNqcWvCMSYHbo/Fe14y
	eWxa1cnm8WLzTEaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyug+xlLwooWx4s2aVuYGxtlx
	XYycHBICJhIHd21k6mLk4hAS2M0osXBlGwtEQlriXvMVdghbWOJ+yxFWEFtIoJtJ4sA8TxCb
	TUBb4v72DWwgtoiArETzugdgg5gFupglDu7/DZTg4BAW8JI41+AIUsMioCqxdu4CJhCbV8Ba
	4uOyR1Dz5SVWbzjADGJzCthIPJmzjAVil7XElRMXWCYw8i1gZFjFKJlaUJybnltsWGCYl1qu
	V5yYW1yal66XnJ+7iREcmlqaOxi3r/qgd4iRiYPxEKMEB7OSCG/BwVUpQrwpiZVVqUX58UWl
	OanFhxilOViUxHnFX/SmCAmkJ5akZqemFqQWwWSZODilGpjiG0+vn7bsnJCVwtYLzQn5WkKn
	nvPzXxXwmeQzU/sj9xLuLat/7rm9w1L0VPzzW+3banec+ehV8yZ+Eusj5agIHdlpFRnLn3Xy
	btIvXF909+l7661Xj71d92taSNybHRa/Gf52v/WbIXbQ1HfN7EedrQ7h+7h26M5/ffbz7Z6k
	CRu23cq+tOHqvtndMxbMUmm9FHDrood5sIXC308HDu6X+HYr1vuFhnJgutxmRSkhf9uPvUsb
	nkjoBirOW3dEJUJjXcZ0gcdMDo8586TcF0qtWr5e4ISN04sJ7hyst71sHoWnd3gyu6X4zXso
	a5WZvH3Lp6ful09XmdTO3TKjPajY/0r/Go1vM131Hi47I85opMRSnJFoqMVcVJwIAIN3CuK8
	AgAA
X-CMS-MailID: 20230711070820epcas2p4ec4884b434c9cb748d5ebda4dd385955
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711070820epcas2p4ec4884b434c9cb748d5ebda4dd385955
References: <20230711071019.7151-1-jehoon.park@samsung.com>
	<CGME20230711070820epcas2p4ec4884b434c9cb748d5ebda4dd385955@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Add a new command: 'set-alert-config', which configures device's warning alert

 usage: cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]

    -v, --verbose         turn on debug
    -S, --serial          use serial numbers to id memdevs
    -L, --life-used-threshold <threshold>
                          threshold value for life used warning alert
        --life-used-alert <'on' or 'off'>
                          enable or disable life used warning alert
    -O, --over-temperature-threshold <threshold>
                          threshold value for device over temperature warning alert
        --over-temperature-alert <'on' or 'off'>
                          enable or disable device over temperature warning alert
    -U, --under-temperature-threshold <threshold>
                          threshold value for device under temperature warning alert
        --under-temperature-alert <'on' or 'off'>
                          enable or disable device under temperature warning alert
    -V, --volatile-mem-err-threshold <threshold>
                          threshold value for corrected volatile mem error warning alert
        --volatile-mem-err-alert <'on' or 'off'>
                          enable or disable corrected volatile mem error warning alert
    -P, --pmem-err-threshold <threshold>
                          threshold value for corrected pmem error warning alert
        --pmem-err-alert <'on' or 'off'>
                          enable or disable corrected pmem error warning alert

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 Documentation/cxl/cxl-set-alert-config.txt |  96 +++++++++
 Documentation/cxl/meson.build              |   1 +
 cxl/builtin.h                              |   1 +
 cxl/cxl.c                                  |   1 +
 cxl/memdev.c                               | 219 ++++++++++++++++++++-
 5 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-set-alert-config.txt

diff --git a/Documentation/cxl/cxl-set-alert-config.txt b/Documentation/cxl/cxl-set-alert-config.txt
new file mode 100644
index 0000000..a291c09
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
+recommended defaults, then could be configured by the host.
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
index a6d77ab..3ea412d 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -46,6 +46,7 @@ cxl_manpages = [
   'cxl-enable-region.txt',
   'cxl-destroy-region.txt',
   'cxl-monitor.txt',
+  'cxl-set-alert-config.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 9baa43b..7b2274c 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -32,4 +32,5 @@ static inline int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	return EXIT_FAILURE;
 }
 #endif
+int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 3be7026..15eb1e6 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -77,6 +77,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
+	{ "set-alert-config", .c_fn = cmd_set_alert_config },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 0b3ad02..2587189 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -34,10 +34,38 @@ static struct parameters {
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
@@ -85,6 +113,36 @@ OPT_STRING('t', "type", &param.type, "type",                   \
 OPT_BOOLEAN('f', "force", &param.force,                        \
 	    "Attempt 'expected to fail' operations")
 
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
@@ -135,6 +193,12 @@ static const struct option free_dpa_options[] = {
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
@@ -653,6 +717,148 @@ out_err:
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
+	} else if (strncmp(param.arg##_alert, "on", 2) == 0) {                \
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
+	} else if (strncmp(param.arg##_alert, "off", 3) == 0) {               \
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
@@ -696,7 +902,7 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	}
 
 	if (action == action_setpartition || action == action_reserve_dpa ||
-	    action == action_free_dpa)
+	    action == action_free_dpa || action == action_set_alert_config)
 		actx.jdevs = json_object_new_array();
 
 	if (err == argc) {
@@ -893,3 +1099,14 @@ int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx)
 
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_set_alert_config(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(
+		argc, argv, ctx, action_set_alert_config, set_alert_options,
+		"cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]");
+	log_info(&ml, "set alert configuration %d mem%s\n",
+		 count >= 0 ? count : 0, count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
-- 
2.17.1

