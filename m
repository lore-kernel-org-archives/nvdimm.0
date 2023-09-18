Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D42A1FD0
	for <nvdimm@lists.linux.dev>; Mon, 18 Sep 2023 04:52:32 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230918045230epoutp049c5d11ec120433ecc39449dd74beecf4~F5R211BVu1511115111epoutp04N
	for <nvdimm@lists.linux.dev>; Mon, 18 Sep 2023 04:52:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230918045230epoutp049c5d11ec120433ecc39449dd74beecf4~F5R211BVu1511115111epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1695012750;
	bh=VsARZCtt5z0Xn/NQ6GQt/qNib87TQ8PCvQlxdwxxoNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPiTvCZqqLwqOkqATT1bj0o/UjyN5X94XAvK8JwyEEPGaHsSgiRvTAlDe7AW0gSCI
	 KEZLxV0cOASEFhOLtIKUzPc7P0Le7exydyaEEzSkmnjsSXMmQYzBK+i2a9rCF41kR0
	 2dNFh0nVKiLxkCTUnETqsjHBdpznl0tMg1jOQRZQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230918045229epcas2p14cff0d8b5726bba995e4e79e519ff1c4~F5R2RU61o1889518895epcas2p1X;
	Mon, 18 Sep 2023 04:52:29 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Rpsq12XSKz4x9Pr; Mon, 18 Sep
	2023 04:52:29 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	3B.EC.09660.D87D7056; Mon, 18 Sep 2023 13:52:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20230918045228epcas2p181e537fc166c04d371f09cba921751b4~F5R1L8sju1889518895epcas2p1S;
	Mon, 18 Sep 2023 04:52:28 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230918045228epsmtrp1d68e19fbd1d3b893696dfb0f249e34bc~F5R1K7ZzX1969519695epsmtrp1h;
	Mon, 18 Sep 2023 04:52:28 +0000 (GMT)
X-AuditID: b6c32a47-afdff700000025bc-ff-6507d78d97b0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	91.12.08649.C87D7056; Mon, 18 Sep 2023 13:52:28 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230918045228epsmtip1ee9da9d57948a3f8d13a0079ad7d03c3~F5R07d_e51803018030epsmtip1m;
	Mon, 18 Sep 2023 04:52:28 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 2/2] cxl: add 'set-alert-config' command to cxl
 tool
Date: Mon, 18 Sep 2023 13:55:14 +0900
Message-Id: <20230918045514.6709-3-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230918045514.6709-1-jehoon.park@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmqW7vdfZUg41d/BZ3H19gs5g+9QKj
	xYmbjWwWq2+uYbTY//Q5i8WB1w3sFqsWXmOzWHx0BrPF0T0cFudnnWKxWPnjD6vFrQnHmBx4
	PFqOvGX1WLznJZPHi80zGT36tqxi9Jg6u97j8ya5ALaobJuM1MSU1CKF1Lzk/JTMvHRbJe/g
	eOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoBOVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnF
	JbZKqQUpOQXmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ359mFHyZylhx++MP5gbG9oIuRk4O
	CQETid1LF7B0MXJxCAnsYJTYdmASM4TziVHi5unTrBDON0aJ+8vfsMC0fN+/iBEisZdR4tH9
	Tiinl0ni2N8jrCBVbALaEve3b2ADsUUEZCWa1z1gAiliFtjMLLFs5zmwhLCAv8TnNT/BxrII
	qEqsm3SLHcTmFbCW2PxnIdQ6eYnVGw4wg9icAjYSt/b0MEPUCEqcnPkErIYZqKZ562ywwyUE
	FnJItH9byAbR7CIx7eY6ZghbWOLV8S3sELaUxMv+Nig7X+LnyVusEHaBxKcvH6AWG0u8u/kc
	KM4BtEBTYv0ufRBTQkBZ4sgtqLV8Eh2H/7JDhHklOtqEIBpVJbqOf2CEsKUlDl85CnWAh0Rf
	7yl2SFj1M0p0zrrNPIFRYRaSb2Yh+WYWwuIFjMyrGMVSC4pz01OLjQqM4VGcnJ+7iRGcZrXc
	dzDOePtB7xAjEwfjIUYJDmYlEd6ZhmypQrwpiZVVqUX58UWlOanFhxhNgWE9kVlKNDkfmOjz
	SuINTSwNTMzMDM2NTA3MlcR577XOTRESSE8sSc1OTS1ILYLpY+LglGpgWmXnsvCjjNLxLVvk
	/avSbZnX6B+xf/Q2PGHd8vlvjhyeb3Kga+ojh31Nj1ZJR4X/ZJ/6bpJl76/kXcv//nD3P3xq
	p+MR1yWXbm8866k2a72CTlTDqt3f4zdMSln4d0fp9fWv5obcCqqNdHotdzUjQ1Zepid6Zeem
	ILYjWV+2HDOdr7daW7LWucDs+Jbw9F71BJGZYtPOvls45+GOOQ56H28zdpg5X3k9w35hwCsN
	9dl8fxrXKrrc+xAV/Spv82yHJL5eq5Nnb198L8/26ISWTXXnE7kWrZ+vI18dO7vncuiUPbec
	UkTY1y6vjW1gCjombTip5ePxwI2pB5ftsLE9y/HI7nJ0UsUBntL3LXe/6JxWYinOSDTUYi4q
	TgQAfMzDtzwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSnG7PdfZUg2m3NSzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBnfn2YUfJnK
	WHH74w/mBsb2gi5GTg4JAROJ7/sXMYLYQgK7GSU+3M6EiEtL3Gu+wg5hC0vcbznC2sXIBVTT
	zSTxf99JZpAEm4C2xP3tG9hAbBEBWYnmdQ+YQIqYBfYyS3TMPM8KkhAW8JV4fnsD2CQWAVWJ
	dZNugdm8AtYSm/8sZIHYIC+xesMBsKGcAjYSt/b0MENcZC3xq/01VL2gxMmZT4DqOYAWqEus
	nycEEmYGam3eOpt5AqPgLCRVsxCqZiGpWsDIvIpRMrWgODc9N9mwwDAvtVyvODG3uDQvXS85
	P3cTIzh2tDR2MN6b/0/vECMTB+MhRgkOZiUR3pmGbKlCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eQ1nzE4REkhPLEnNTk0tSC2CyTJxcEo1MMk4nzm8LHXu8l1rVqc6lNUk8hV8MHmTm8bomVZX
	cPVY9xEvk9vd6gtPBsZ3tC7eePJySmjkFdUD6plcfqfe+/jumFR+4Y5Xdehh1kk6Ac3+Si8W
	mdy3z+4/NelKj3LYZHl33cr9C87+u161gqGP8eWPC1tZQvT4zs+7wMS1bfmRk1ONfadlzbkp
	/mXG4q+p787NVNv3cFpXRvGjUr/dPSy6uiwdQtHrbetFBfJ69hX5KKYZLT5/+9cRkXyevQ55
	cc83SrvWGm6+Jax0R6p4Wutpdt2gYk0eoypmhevG15d9n7lwRovJQ8FXxo+9nfbLBZ3iFTys
	f9syOuzSVxe2DR7svtOdeS9mO3z5b63GrMRSnJFoqMVcVJwIADqNeXUMAwAA
X-CMS-MailID: 20230918045228epcas2p181e537fc166c04d371f09cba921751b4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230918045228epcas2p181e537fc166c04d371f09cba921751b4
References: <20230918045514.6709-1-jehoon.park@samsung.com>
	<CGME20230918045228epcas2p181e537fc166c04d371f09cba921751b4@epcas2p1.samsung.com>

Add a new command: 'cxl-set-alert-config', which configures device's warning
alerts. Device's warning alert programmability and current state can be
optained via 'cxl-list' command with '-A' option.

Example:
{
  "memdev":"mem0",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "alert_config":{
    "life_used_prog_warn_threshold_valid":true,
     ...
    "life_used_crit_alert_threshold":75,
    "life_used_prog_warn_threshold":30,
    ...
  },
  "serial":"0",
  "host":"0000:0d:00.0"
}
cxl memdev: cmd_set_alert_config: set alert configuration 1 mem

Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
---
 Documentation/cxl/cxl-set-alert-config.txt | 152 ++++++++++++++
 Documentation/cxl/meson.build              |   1 +
 cxl/builtin.h                              |   1 +
 cxl/cxl.c                                  |   1 +
 cxl/memdev.c                               | 220 ++++++++++++++++++++-
 5 files changed, 374 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-set-alert-config.txt

diff --git a/Documentation/cxl/cxl-set-alert-config.txt b/Documentation/cxl/cxl-set-alert-config.txt
new file mode 100644
index 0000000..2ccb024
--- /dev/null
+++ b/Documentation/cxl/cxl-set-alert-config.txt
@@ -0,0 +1,152 @@
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
+----
+# cxl set-alert-config mem0 --life-used-threshold=30 --life-used-alert=on
+{
+  "memdev":"mem0",
+  "ram_size":"1024.00 MiB (1073.74 MB)",
+  "alert_config":{
+    "life_used_prog_warn_threshold_valid":true,
+    "dev_over_temperature_prog_warn_threshold_valid":false,
+    "dev_under_temperature_prog_warn_threshold_valid":false,
+    "corrected_volatile_mem_err_prog_warn_threshold_valid":false,
+    "corrected_pmem_err_prog_warn_threshold_valid":false,
+    "life_used_prog_warn_threshold_writable":true,
+    "dev_over_temperature_prog_warn_threshold_writable":true,
+    "dev_under_temperature_prog_warn_threshold_writable":true,
+    "corrected_volatile_mem_err_prog_warn_threshold_writable":true,
+    "corrected_pmem_err_prog_warn_threshold_writable":true,
+    "life_used_crit_alert_threshold":75,
+    "life_used_prog_warn_threshold":30,
+    "dev_over_temperature_crit_alert_threshold":0,
+    "dev_under_temperature_crit_alert_threshold":0,
+    "dev_over_temperature_prog_warn_threshold":0,
+    "dev_under_temperature_prog_warn_threshold":0,
+    "corrected_volatile_mem_err_prog_warn_threshold":0,
+    "corrected_pmem_err_prog_warn_threshold":0
+  },
+  "serial":"0",
+  "host":"0000:0d:00.0"
+}
+cxl memdev: cmd_set_alert_config: set alert configuration 1 mem
+----
+
+Disable warning alert for life_used.
+----
+# cxl set-alert-config mem0 --life-used-alert=off
+{
+  "memdev":"mem0",
+  "ram_size":"1024.00 MiB (1073.74 MB)",
+  "alert_config":{
+    "life_used_prog_warn_threshold_valid":false,
+    "dev_over_temperature_prog_warn_threshold_valid":false,
+    "dev_under_temperature_prog_warn_threshold_valid":false,
+    "corrected_volatile_mem_err_prog_warn_threshold_valid":false,
+    "corrected_pmem_err_prog_warn_threshold_valid":false,
+    "life_used_prog_warn_threshold_writable":true,
+    "dev_over_temperature_prog_warn_threshold_writable":true,
+    "dev_under_temperature_prog_warn_threshold_writable":true,
+    "corrected_volatile_mem_err_prog_warn_threshold_writable":true,
+    "corrected_pmem_err_prog_warn_threshold_writable":true,
+    "life_used_crit_alert_threshold":75,
+    "life_used_prog_warn_threshold":30,
+    "dev_over_temperature_crit_alert_threshold":0,
+    "dev_under_temperature_crit_alert_threshold":0,
+    "dev_over_temperature_prog_warn_threshold":0,
+    "dev_under_temperature_prog_warn_threshold":0,
+    "corrected_volatile_mem_err_prog_warn_threshold":0,
+    "corrected_pmem_err_prog_warn_threshold":0
+  },
+  "serial":"0",
+  "host":"0000:0d:00.0"
+}
+cxl memdev: cmd_set_alert_config: set alert configuration 1 mem
+----
+
+OPTIONS
+-------
+<memory device(s)>::
+include::memdev-option.txt[]
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
+-v::
+--verbose::
+        Turn on verbose debug messages in the library (if libcxl was built with
+        logging and debug enabled).
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

