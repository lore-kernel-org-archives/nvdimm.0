Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794568469;
	b=3wPtydLPh6yURlMXo/619fdJzyPB5pqVuL1zuZer7PcoGVTceCRhn8CUgUsw8YchEP81
	 9IKt428MNwWQlfCTYG98ZNxz2g8RAbUVmGGpwqw54LXJ4JXD+koyh4p4JyVW0p/aOka3H
	 ZvLrNvS8AMHuLfmNH8bTr0FcxHk3LjskPbcF8PBOACwRms96wE98rpFOWKGey6sGlAtJj
	 r9bLLADFJtkFtTbK8baqdvi0Txl6gwbj10XRv20s1otlY8CZYtpJ+lkjnvrxzo44z0efO
	 jLpud3tOJRAKhLgoSoqUFfp4gA4VCiTaKzHmaGiQqTp1nIZcQ+AYQ0uYVEztiZNIC3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794568469;
	h=Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Type:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=LojxpgHWTKlkdcEJ41TOpKmn/6uVf8ABKMcPjnFSOr0=;
	b=KpPjXF/7hHbhmDqMKCHt0tNsQRuB6EWiOCR+Lqaa8Z/kurLnKJPRUx2yAXh6Gj+FFWbn
	 47knGe06iedFS5AgsuXZbuF/V/rCFTE8bzqQc1096m3e5G3FJBIkMkBRLgYTqAt+2hr9r
	 PtcLxt0QTFlNv5vUlZ44ubom7UxtHmH9pfvVmqiLdFz8cUOYFWHVOE5v8xTi2eqbyEdte
	 b9W000I+sKDauRzLVWni6QH9Vd6MZQPsmriol1ZDCb8CDNIRs5IBdR5ngOK68lxtRtLuP
	 6VPrlJtEj+KRjj3QDl24s8KgTU3pEphZxmKuZBoSfHaI/G7/xSv4UCi0Q8Ycgvaf4WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A93BE606A337;
	Fri, 13 Nov 2026 11:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0EC0F1F000CF;
	Fri, 13 Nov 2026 11:14:28 +0000 (UTC)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <ukleinek@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Yauhen Kharuzhy <jekhor@gmail.com>,
	Pawel Zalewski <pzalewski@thegoodpenguin.co.uk>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v1 2/4] ACPI: Drop unused .driver_data initializers in acpi_device_id arrays
Date: Fri, 13 Nov 2026 12:13:58 +0100
Message-ID:  <b7c5533882b5a979a4ba19a87e9ba1b13a24023d.1794567577.git.ukleinek@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1
In-Reply-To: <cover.1794567577.git.ukleinek@kernel.org>
References: <cover.1794567577.git.ukleinek@kernel.org>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=12913; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=J9KeuPS968p9Tv9qdco7cZZuDCVeYtNre8fyicT5dQs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBq9vD6G6FXAOwdcyQ4YWkZt1pqooR6o59WQvYJ3 l1EoJhHRzKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCavbw+gAKCRCPgPtYfRL+ TvfFB/46pQaYualgL0828WgSf6H4V6jd04rgr3cFXdNnEUV/XDoLrIMALjXgEXmu7tUo4b4d6gC 0MB87h2zb49bgJ8qc8TFra/R3RSh+Cjd1RBi+sey7BnIZQEXwDAsStpMoYzfk6jGVf744a+Q8PH Qw2AhXR/kce24OtpdmKq0RW9/mTK4Cfayd8VmGQePaMBGeZINBczDNgsyloGdlDhD9nZYh6ioSW JrUlTwRjxk9Nmqdhy2dUiT1WQQbpkDXLUXJ+4KP2B8vVRs/PMzs6LQLk/jGqU9H3Xn7+Rd1lzUU dqRUfvMD3WHSqy584w5PJNZFbXsL9Kymb0GagmTF7z/lBZTr
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König (The Capable Hub) <ukleinek@kernel.org>

Many drivers explicitly initialize the .driver_data member in their
acpi_device_id arrays without actually using that value. Drop these
assignments and while touching these lines use named initializers for
.id and use consistent spacing.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/acpi/ac.c                 |  2 +-
 drivers/acpi/acpi_memhotplug.c    |  2 +-
 drivers/acpi/acpi_pad.c           |  2 +-
 drivers/acpi/acpi_tad.c           |  2 +-
 drivers/acpi/arm64/amba.c         |  4 ++--
 drivers/acpi/battery.c            |  4 ++--
 drivers/acpi/container.c          |  6 +++---
 drivers/acpi/dptf/dptf_pch_fivr.c | 12 +++++------
 drivers/acpi/dptf/dptf_power.c    | 36 +++++++++++++++----------------
 drivers/acpi/ec.c                 |  4 ++--
 drivers/acpi/hed.c                |  2 +-
 drivers/acpi/nfit/core.c          |  2 +-
 drivers/acpi/pci_link.c           |  2 +-
 drivers/acpi/pci_root.c           |  2 +-
 drivers/acpi/processor_driver.c   |  4 ++--
 drivers/acpi/sbs.c                |  2 +-
 drivers/acpi/sbshc.c              |  4 ++--
 drivers/acpi/scan.c               |  6 +++---
 drivers/acpi/thermal.c            |  2 +-
 drivers/acpi/tiny-power-button.c  |  4 ++--
 drivers/acpi/x86/utils.c          | 14 ++++++------
 21 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index f629fcd662f9..168e1d495b7b 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -32,7 +32,7 @@ MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
 static const struct acpi_device_id ac_device_ids[] = {
-	{"ACPI0003", 0},
+	{ .id = "ACPI0003" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, ac_device_ids);
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index bb1c380b1ffb..cf27765ed4d7 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -21,7 +21,7 @@
 #define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
 
 static const struct acpi_device_id memory_device_ids[] = {
-	{ACPI_MEMORY_DEVICE_HID, 0},
+	{ .id = ACPI_MEMORY_DEVICE_HID },
 	{ }
 };
 
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index edd4226a353e..9af3b8bce686 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -438,7 +438,7 @@ static void acpi_pad_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id pad_device_ids[] = {
-	{"ACPI000C", 0},
+	{ .id = "ACPI000C" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, pad_device_ids);
diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
index bd8bdf7b1a4f..15fe05cd7514 100644
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -895,7 +895,7 @@ static int acpi_tad_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id acpi_tad_ids[] = {
-	{"ACPI000E", 0},
+	{ .id = "ACPI000E" },
 	{ }
 };
 
diff --git a/drivers/acpi/arm64/amba.c b/drivers/acpi/arm64/amba.c
index 34381ca72add..0e037f0ebc62 100644
--- a/drivers/acpi/arm64/amba.c
+++ b/drivers/acpi/arm64/amba.c
@@ -20,8 +20,8 @@
 #include "init.h"
 
 static const struct acpi_device_id amba_id_list[] = {
-	{"ARMH0061", 0}, /* PL061 GPIO Device */
-	{"ARMH0330", 0}, /* ARM DMA Controller DMA-330 */
+	{ .id = "ARMH0061" }, /* PL061 GPIO Device */
+	{ .id = "ARMH0330" }, /* ARM DMA Controller DMA-330 */
 	{ }
 };
 
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 29432de93fc6..8b1b66cf5369 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -63,10 +63,10 @@ module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
 static const struct acpi_device_id battery_device_ids[] = {
-	{"PNP0C0A", 0},
+	{ .id = "PNP0C0A" },
 
 	/* Microsoft Surface Go 3 */
-	{"MSHW0146", 0},
+	{ .id = "MSHW0146" },
 
 	{ }
 };
diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index 3a3b18d62a93..9997915233e1 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -15,9 +15,9 @@
 #include "internal.h"
 
 static const struct acpi_device_id container_device_ids[] = {
-	{"ACPI0004", 0},
-	{"PNP0A05", 0},
-	{"PNP0A06", 0},
+	{ .id = "ACPI0004" },
+	{ .id = "PNP0A05" },
+	{ .id = "PNP0A06" },
 	{ }
 };
 
diff --git a/drivers/acpi/dptf/dptf_pch_fivr.c b/drivers/acpi/dptf/dptf_pch_fivr.c
index 1e41bea6e00d..d23867f70b28 100644
--- a/drivers/acpi/dptf/dptf_pch_fivr.c
+++ b/drivers/acpi/dptf/dptf_pch_fivr.c
@@ -147,12 +147,12 @@ static void pch_fivr_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id pch_fivr_device_ids[] = {
-	{"INTC1045", 0},
-	{"INTC1049", 0},
-	{"INTC1064", 0},
-	{"INTC106B", 0},
-	{"INTC10A3", 0},
-	{"INTC10D7", 0},
+	{ .id = "INTC1045" },
+	{ .id = "INTC1049" },
+	{ .id = "INTC1064" },
+	{ .id = "INTC106B" },
+	{ .id = "INTC10A3" },
+	{ .id = "INTC10D7" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, pch_fivr_device_ids);
diff --git a/drivers/acpi/dptf/dptf_power.c b/drivers/acpi/dptf/dptf_power.c
index 5b2f2cf13b5b..065831bce8c0 100644
--- a/drivers/acpi/dptf/dptf_power.c
+++ b/drivers/acpi/dptf/dptf_power.c
@@ -224,24 +224,24 @@ static void dptf_power_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id int3407_device_ids[] = {
-	{"INT3407", 0},
-	{"INT3532", 0},
-	{"INTC1047", 0},
-	{"INTC1050", 0},
-	{"INTC1060", 0},
-	{"INTC1061", 0},
-	{"INTC1065", 0},
-	{"INTC1066", 0},
-	{"INTC106C", 0},
-	{"INTC106D", 0},
-	{"INTC10A4", 0},
-	{"INTC10A5", 0},
-	{"INTC10D8", 0},
-	{"INTC10D9", 0},
-	{"INTC1100", 0},
-	{"INTC1101", 0},
-	{"INTC10F7", 0},
-	{"INTC10F8", 0},
+	{ .id = "INT3407" },
+	{ .id = "INT3532" },
+	{ .id = "INTC1047" },
+	{ .id = "INTC1050" },
+	{ .id = "INTC1060" },
+	{ .id = "INTC1061" },
+	{ .id = "INTC1065" },
+	{ .id = "INTC1066" },
+	{ .id = "INTC106C" },
+	{ .id = "INTC106D" },
+	{ .id = "INTC10A4" },
+	{ .id = "INTC10A5" },
+	{ .id = "INTC10D8" },
+	{ .id = "INTC10D9" },
+	{ .id = "INTC1100" },
+	{ .id = "INTC1101" },
+	{ .id = "INTC10F7" },
+	{ .id = "INTC10F8" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, int3407_device_ids);
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 611c616f4927..d947118657a8 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1806,8 +1806,8 @@ ec_parse_io_ports(struct acpi_resource *resource, void *context)
 }
 
 static const struct acpi_device_id ec_device_ids[] = {
-	{"PNP0C09", 0},
-	{ACPI_ECDT_HID, 0},
+	{ .id = "PNP0C09" },
+	{ .id = ACPI_ECDT_HID },
 	{ }
 };
 
diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index e5de7980c866..6789ec567d21 100644
--- a/drivers/acpi/hed.c
+++ b/drivers/acpi/hed.c
@@ -17,7 +17,7 @@
 #include <acpi/hed.h>
 
 static const struct acpi_device_id acpi_hed_ids[] = {
-	{"PNP0C33", 0},
+	{ .id = "PNP0C33" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_hed_ids);
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e62274b0ff38..81f6a825f5df 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3513,7 +3513,7 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
 static const struct acpi_device_id acpi_nfit_ids[] = {
-	{ "ACPI0012", 0 },
+	{ .id = "ACPI0012" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index 71ff2269e218..492c7dd2d5de 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -36,7 +36,7 @@ static int acpi_pci_link_add(struct acpi_device *device,
 static void acpi_pci_link_remove(struct acpi_device *device);
 
 static const struct acpi_device_id link_device_ids[] = {
-	{"PNP0C0F", 0},
+	{ .id = "PNP0C0F" },
 	{ }
 };
 
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 5ca57f6c9ea8..bb862c89daee 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -41,7 +41,7 @@ static int acpi_pci_root_scan_dependent(struct acpi_device *adev)
 				| OSC_PCI_MSI_SUPPORT)
 
 static const struct acpi_device_id root_device_ids[] = {
-	{"PNP0A03", 0},
+	{ .id = "PNP0A03" },
 	{ }
 };
 
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index adde2a441373..87197ba7976b 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -36,8 +36,8 @@ MODULE_LICENSE("GPL");
 static int acpi_processor_stop(struct device *dev);
 
 static const struct acpi_device_id processor_device_ids[] = {
-	{ACPI_PROCESSOR_OBJECT_HID, 0},
-	{ACPI_PROCESSOR_DEVICE_HID, 0},
+	{ .id = ACPI_PROCESSOR_OBJECT_HID },
+	{ .id = ACPI_PROCESSOR_DEVICE_HID },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index d528ae5606a6..5f3eb26b133a 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 #define ACPI_SBS_BLOCK_MAX		32
 
 static const struct acpi_device_id sbs_device_ids[] = {
-	{"ACPI0002", 0},
+	{ .id = "ACPI0002" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, sbs_device_ids);
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index bfc6098b5fed..ac628212c048 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -33,8 +33,8 @@ static int acpi_smbus_hc_probe(struct platform_device *pdev);
 static void acpi_smbus_hc_remove(struct platform_device *pdev);
 
 static const struct acpi_device_id sbs_device_ids[] = {
-	{"ACPI0001", 0},
-	{"ACPI0005", 0},
+	{ .id = "ACPI0001" },
+	{ .id = "ACPI0005" },
 	{ }
 };
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7cd13e77497e..913da04062b7 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1075,8 +1075,8 @@ static int acpi_bus_extract_wakeup_device_power_package(struct acpi_device *dev)
 static bool acpi_wakeup_gpe_init(struct acpi_device *device)
 {
 	static const struct acpi_device_id button_device_ids[] = {
-		{"PNP0C0D", 0},	/* Lid */
-		{"PNP0C0E", 0},	/* Sleep button */
+		{ .id = "PNP0C0D" },	/* Lid */
+		{ .id = "PNP0C0E" },	/* Sleep button */
 		{ }
 	};
 	struct acpi_device_wakeup *wakeup = &device->wakeup;
@@ -1800,7 +1800,7 @@ static bool acpi_is_indirect_io_slave(struct acpi_device *device)
 {
 	struct acpi_device *parent = acpi_dev_parent(device);
 	static const struct acpi_device_id indirect_io_hosts[] = {
-		{"HISI0191", 0},
+		{ .id = "HISI0191" },
 		{ }
 	};
 
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index b6808eee1e69..da631bbe8ea2 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -925,7 +925,7 @@ static const struct dev_pm_ops acpi_thermal_pm_ops = {
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct acpi_device_id  thermal_device_ids[] = {
-	{ACPI_THERMAL_HID, 0},
+	{ .id = ACPI_THERMAL_HID },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, thermal_device_ids);
diff --git a/drivers/acpi/tiny-power-button.c b/drivers/acpi/tiny-power-button.c
index 4dcaf6a96f84..5acb53090ff3 100644
--- a/drivers/acpi/tiny-power-button.c
+++ b/drivers/acpi/tiny-power-button.c
@@ -14,8 +14,8 @@ module_param(power_signal, int, 0644);
 MODULE_PARM_DESC(power_signal, "Power button sends this signal to init");
 
 static const struct acpi_device_id tiny_power_button_device_ids[] = {
-	{ ACPI_BUTTON_HID_POWER, 0 },
-	{ ACPI_BUTTON_HID_POWERF, 0 },
+	{ .id = ACPI_BUTTON_HID_POWER },
+	{ .id = ACPI_BUTTON_HID_POWERF },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, tiny_power_button_device_ids);
diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 3444b96a2c20..32c74864226f 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -463,13 +463,13 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
 static const struct acpi_device_id i2c_acpi_known_good_ids[] = {
-	{ "10EC5640", 0 }, /* RealTek ALC5640 audio codec */
-	{ "10EC5651", 0 }, /* RealTek ALC5651 audio codec */
-	{ "INT33F4", 0 },  /* X-Powers AXP288 PMIC */
-	{ "INT33F5", 0 },  /* TI Dollar Cove PMIC */
-	{ "INT33FD", 0 },  /* Intel Crystal Cove PMIC */
-	{ "INT34D3", 0 },  /* Intel Whiskey Cove PMIC */
-	{ "NPCE69A", 0 },  /* Asus Transformer keyboard dock */
+	{ .id = "10EC5640" }, /* RealTek ALC5640 audio codec */
+	{ .id = "10EC5651" }, /* RealTek ALC5651 audio codec */
+	{ .id = "INT33F4" },  /* X-Powers AXP288 PMIC */
+	{ .id = "INT33F5" },  /* TI Dollar Cove PMIC */
+	{ .id = "INT33FD" },  /* Intel Crystal Cove PMIC */
+	{ .id = "INT34D3" },  /* Intel Whiskey Cove PMIC */
+	{ .id = "NPCE69A" },  /* Asus Transformer keyboard dock */
 	{ }
 };
 
-- 
2.56.0.rc1

