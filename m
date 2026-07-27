Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4A940096D
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154263; cv=none; b=fO/BlO590gQL7fx1PFVuF/2AJquTyUvOLj/v4TQM1wSoxogSV6/mu9zM8EsGmQGYgBp7Dx5HiZFIcP6hfQ8R7GsBk2c4yZZq/s+ebamRVJx0BllCORfFGGnu0SeUXPb0J0XVIbrJX8b7y7LKMzNxtnLzspd1P+uQ0o0aIfbQdws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154263; c=relaxed/simple;
	bh=yW0W+s/ODN9UXJw4cH6nRQgB2fiTILyZAnOw5gC9ElM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gEYx0HWuajuBb6dvhWgH7LmbbSX4ZziZDlKfEJLd3YKg0T+ugvOhZwerpkD9FOeJ30saL3Ma9QO8v3WpcAm3s7mIvAdxqPIM9qaIgUFGy2DmB2c9W94GPEUyX3SltH3E2XTKfTYsW2KevloBgI3w2yqZserMqhISXakwsYlgxpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=hYJbDNbD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="hYJbDNbD"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49553515a8bso30990785e9.1
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154257; x=1785759057; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CBfwpYWZGknAk49tg2TJoJhiClH6trZKMQ65EFXSEDI=;
        b=hYJbDNbDBLI+81+U7IDU0lQ3O0vjEj6VcoVc+O823AMfZ1JIPQiypfiP47+acct5XP
         LnxKwKY0U0lF3jRnJoarvU0ESRGijNj5QRl4i8EwADYBh/ZdfdD8NolMTxAOSdhSHWbS
         pPc4/gi7up7deQLp0yQY3JnTUsfP7aW/Knxk6xQsDtsQ0wvY5p94iSS0DEC1iR7ZCRik
         3XnoPGvC3J6FrjDy7MzEhvNsh194sJkDCHFDxK1sTxX/zydroz5bwobb4QUTTD7ZM1VK
         8CgaW3bi/ExdS0OoImwYI8POtT4T+H+F1Tai7E47Ip1vXcusjYmLlgFHhz223oz/AK2y
         mwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154257; x=1785759057;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CBfwpYWZGknAk49tg2TJoJhiClH6trZKMQ65EFXSEDI=;
        b=rtSKVurdzolz73e0CpzXO9vorLorj6smFBtfi4Y4JivKLiVMqpGzRRRCO9iJRH6Aga
         Tqwa7N37kGpxB4Z96FdM9DhKFuwuXtxwa9qGkgdMDCWoSkJtpLK7lFEG1f0yRMIJzxki
         /lbyoud6vvnCsLPaC0a+7dEUVg9AAeBOY31LrO8bLpAKbGhBeZVilVwahP+IZ8OUSV2a
         NK0AfuCOKvkbFsDI11RTpUhgIvyTJ41R0Ho0xFIIBBhFjEuPun5szMEZU7mKuoqMn0mO
         x4twEwM+AAwdb4i8uYwIhrgb0K41E2Xb2BSmW2nQNHjYMrF0PURXPxfXNjU7BvoFREKW
         2OOA==
X-Forwarded-Encrypted: i=1; AHgh+RpUTAWgHnzRmk+wUwrvEUMPAyOoH0NMO6DcgyMcutTX3SJQKOKtH8ckoKB4aiLwEhLE8MnQJJI=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywp7guUOOmgmGy7O5HE+SoqJOF2XdenRXhVF7fpvM14obDaNq+S
	2fSh9NITDWznNxuSnHMNpBQiuZcCZgtwghU7zhIl+1pWwo+A/Y5FHETxmB1B7V+IS88=
X-Gm-Gg: AR+sD123obDKF6M/dhj/4SJHpzRfmG9YX4pnSufBAyOvT+oxS0lXza3tRAGs2ZySrO2
	QrtCFMVXVyhyCMNDZ87h8hxX0Ts3vEqtDZfR1tduqUdzmrcoccJ5QdwaPBnOZ0Fakzs4seUZe1R
	btH3wo8VvvFGpaXoYeIQagIT9Ph8nnz2kT+b5BUnIrjYdisDhlNsC+wYw8x2slLFCnYZOFY+q5h
	dLzHpX3yjfK/xR1n7RgGEiVR/835b7gRR8gNSZHArcWrQLdKq9QESCuNaokcxxSR4K1zcIACiv9
	5Eqk5bPpLuXEQ51+sRqL8IryNWgfYyY2RjYzMwvDGDPhsmYTqAdWUUTYZjddL57suRJbf4FYAOB
	3X8R/QZVKb5Ky0KE0FJPHKH1u1NATgOpnaDgiACc0gq3yJDrLFrNSnUGI/M0inOLDkx5/b4D42i
	ZuUBZbbHSoVbv9n4G0FZ8=
X-Received: by 2002:a05:600c:190c:b0:495:782e:8faf with SMTP id 5b1f17b1804b1-496b6a34b4cmr94039855e9.30.1785154257234;
        Mon, 27 Jul 2026 05:10:57 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:10:56 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:40 +0100
Subject: [PATCH 2/9] ACPI: drop unused assignment of
 acpi_device_id::driver_data
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-2-ff900aa326ee@thegoodpenguin.co.uk>
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
In-Reply-To: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
To: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
 Kai-Heng Feng <kaihengf@nvidia.com>, Tony Luck <tony.luck@intel.com>, 
 Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Shuai Xue <xueshuai@linux.alibaba.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, 
 Sudeep Holla <sudeep.holla@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 nvdimm@lists.linux.dev, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=7765;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=yW0W+s/ODN9UXJw4cH6nRQgB2fiTILyZAnOw5gC9ElM=;
 b=F77XH8skjSecNPgsac0uUAbdIshHQTUalezlaATvg61TJSN+3b5lvu5y5IkcFviCOrZ8aThyT
 kfHvPkzro09DzhsaPmbL8LD0p+22fLezrVHzyuWLcCqaY5QZCZ6mQ5E
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

These modules set the acpi_device_id::driver_data to 0 but
the field is not actually used within the module, we can
just drop it from the table.

While we are at it - use a named initializer for the
acpi_device_id fields and drop setting the list
terminator fields explicitly as well.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/acpi/ac.c                | 4 ++--
 drivers/acpi/acpi_memhotplug.c   | 4 ++--
 drivers/acpi/acpi_pad.c          | 4 ++--
 drivers/acpi/acpi_tad.c          | 4 ++--
 drivers/acpi/battery.c           | 8 +++-----
 drivers/acpi/container.c         | 8 ++++----
 drivers/acpi/ec.c                | 6 +++---
 drivers/acpi/hed.c               | 4 ++--
 drivers/acpi/processor_driver.c  | 6 +++---
 drivers/acpi/sbs.c               | 4 ++--
 drivers/acpi/sbshc.c             | 6 +++---
 drivers/acpi/thermal.c           | 4 ++--
 drivers/acpi/tiny-power-button.c | 6 +++---
 drivers/acpi/video_detect.c      | 4 ++--
 14 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index f19d6dd43473..d6f162fe7ea4 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -32,8 +32,8 @@ MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
 static const struct acpi_device_id ac_device_ids[] = {
-	{"ACPI0003", 0},
-	{"", 0},
+	{.id = "ACPI0003" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, ac_device_ids);
 
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 1d7dfe4ee9a6..cf27765ed4d7 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -21,8 +21,8 @@
 #define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
 
 static const struct acpi_device_id memory_device_ids[] = {
-	{ACPI_MEMORY_DEVICE_HID, 0},
-	{"", 0},
+	{ .id = ACPI_MEMORY_DEVICE_HID },
+	{ }
 };
 
 #ifdef CONFIG_ACPI_HOTPLUG_MEMORY
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index dc6d0091d17c..9af3b8bce686 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -438,8 +438,8 @@ static void acpi_pad_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id pad_device_ids[] = {
-	{"ACPI000C", 0},
-	{"", 0},
+	{ .id = "ACPI000C" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, pad_device_ids);
 
diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
index fc43df083738..7a2a5167e8ec 100644
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -885,8 +885,8 @@ static int acpi_tad_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id acpi_tad_ids[] = {
-	{"ACPI000E", 0},
-	{}
+	{ .id = "ACPI000E" },
+	{ }
 };
 
 static struct platform_driver acpi_tad_driver = {
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index f5e0eb299610..30b42967e625 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -56,12 +56,10 @@ module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
 static const struct acpi_device_id battery_device_ids[] = {
-	{"PNP0C0A", 0},
-
+	{ .id = "PNP0C0A"},
 	/* Microsoft Surface Go 3 */
-	{"MSHW0146", 0},
-
-	{"", 0},
+	{ .id = "MSHW0146"},
+	{ }
 };
 
 MODULE_DEVICE_TABLE(acpi, battery_device_ids);
diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
index f138a433554a..9997915233e1 100644
--- a/drivers/acpi/container.c
+++ b/drivers/acpi/container.c
@@ -15,10 +15,10 @@
 #include "internal.h"
 
 static const struct acpi_device_id container_device_ids[] = {
-	{"ACPI0004", 0},
-	{"PNP0A05", 0},
-	{"PNP0A06", 0},
-	{"", 0},
+	{ .id = "ACPI0004" },
+	{ .id = "PNP0A05" },
+	{ .id = "PNP0A06" },
+	{ }
 };
 
 #ifdef CONFIG_ACPI_CONTAINER
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 64ad4cfa6208..fd62a455db2a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1794,9 +1794,9 @@ ec_parse_io_ports(struct acpi_resource *resource, void *context)
 }
 
 static const struct acpi_device_id ec_device_ids[] = {
-	{"PNP0C09", 0},
-	{ACPI_ECDT_HID, 0},
-	{"", 0},
+	{ .id = "PNP0C09" },
+	{ .id = ACPI_ECDT_HID },
+	{ }
 };
 
 /*
diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index 48562f53d3ab..6789ec567d21 100644
--- a/drivers/acpi/hed.c
+++ b/drivers/acpi/hed.c
@@ -17,8 +17,8 @@
 #include <acpi/hed.h>
 
 static const struct acpi_device_id acpi_hed_ids[] = {
-	{"PNP0C33", 0},
-	{"", 0},
+	{ .id = "PNP0C33" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_hed_ids);
 
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index cda8fd720000..c11cd0e3367f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -36,9 +36,9 @@ MODULE_LICENSE("GPL");
 static int acpi_processor_stop(struct device *dev);
 
 static const struct acpi_device_id processor_device_ids[] = {
-	{ACPI_PROCESSOR_OBJECT_HID, 0},
-	{ACPI_PROCESSOR_DEVICE_HID, 0},
-	{"", 0},
+	{ .id = ACPI_PROCESSOR_OBJECT_HID },
+	{ .id = ACPI_PROCESSOR_DEVICE_HID },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
 
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 86b7c7975852..354304c2c307 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -45,8 +45,8 @@ MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 #define ACPI_SBS_BLOCK_MAX		32
 
 static const struct acpi_device_id sbs_device_ids[] = {
-	{"ACPI0002", 0},
-	{"", 0},
+	{ .id = "ACPI0002" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, sbs_device_ids);
 
diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index c0ffa267f96c..ac628212c048 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -33,9 +33,9 @@ static int acpi_smbus_hc_probe(struct platform_device *pdev);
 static void acpi_smbus_hc_remove(struct platform_device *pdev);
 
 static const struct acpi_device_id sbs_device_ids[] = {
-	{"ACPI0001", 0},
-	{"ACPI0005", 0},
-	{"", 0},
+	{ .id = "ACPI0001" },
+	{ .id = "ACPI0005" },
+	{ }
 };
 
 MODULE_DEVICE_TABLE(acpi, sbs_device_ids);
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index dd7666c176a0..189011733956 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -920,8 +920,8 @@ static const struct dev_pm_ops acpi_thermal_pm_ops = {
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct acpi_device_id  thermal_device_ids[] = {
-	{ACPI_THERMAL_HID, 0},
-	{"", 0},
+	{ .id = ACPI_THERMAL_HID },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, thermal_device_ids);
 
diff --git a/drivers/acpi/tiny-power-button.c b/drivers/acpi/tiny-power-button.c
index 92516ef84b02..5acb53090ff3 100644
--- a/drivers/acpi/tiny-power-button.c
+++ b/drivers/acpi/tiny-power-button.c
@@ -14,9 +14,9 @@ module_param(power_signal, int, 0644);
 MODULE_PARM_DESC(power_signal, "Power button sends this signal to init");
 
 static const struct acpi_device_id tiny_power_button_device_ids[] = {
-	{ ACPI_BUTTON_HID_POWER, 0 },
-	{ ACPI_BUTTON_HID_POWERF, 0 },
-	{ "", 0 },
+	{ .id = ACPI_BUTTON_HID_POWER },
+	{ .id = ACPI_BUTTON_HID_POWERF },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, tiny_power_button_device_ids);
 
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 458efa4fe9d4..e135f29d4093 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -68,8 +68,8 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 	struct pci_dev *dev;
 
 	static const struct acpi_device_id video_ids[] = {
-		{ACPI_VIDEO_HID, 0},
-		{"", 0},
+		{ .id = ACPI_VIDEO_HID },
+		{ }
 	};
 
 	if (acpi_dev && !acpi_match_device_ids(acpi_dev, video_ids)) {

-- 
2.43.0

