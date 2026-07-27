Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EC240A921
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154271; cv=none; b=NooW0ZYu38Cwbj0zT0y0muwrSs/KtEED8rG6DAzEFfr+bNcBz0IgpAmysBv6akRIeW4MNj9f8JGSQPRcUTb302mb7fg1J35Nwwlf79zI2t9LGlkFjtGSLinJwRI1qH8Xh/CHPxIZul7/azmNQ1yqxCXdDWsHb2yQ0qYTRYhdbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154271; c=relaxed/simple;
	bh=q1sapSQQK4AuvJxhLybez7xMW8BCU+2x792Tr/WVaBo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e9QM7DW2+BWxc1J1+FMLBTHdOk1uTiVr2uuSchxOwjwfAPKcMpbo0uh6Drsvg8HBAIUIl0pscYzqr+dbBRSZCsJgFN1recnbx/RiKtKpDKCFeuz6iaabJ3/kox8RmjcKBsRg1ZEVTQnE5nzApjVQAgySqD5az152ALpzLSb07ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=QVV0VC0m; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="QVV0VC0m"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso17931255e9.1
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154267; x=1785759067; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2/U7VrTEi0vsV9VceOwFXfFqZdMwqeaVHPjJeSjzlTw=;
        b=QVV0VC0m+BGSN7wCK0I/udttq2dEhFL45jEwPUzNfLO2krgahZzId8ifwk7Ye32mBw
         rDADgquHTkabe2SYefq82fkrkNPe38x5of0zEk0vEYSMTrJAM3+Bfd/9UVAb5i+D3pc6
         ZcXzu4YqX14/8OicvxJysg2I3tffXRNxiDE53d7N88DDUBRoIHzpuIvrJxGuNDH1ea8s
         U38A2gWk+kZNrlp+Sz0+TKh3hfUJMYG8Ai1e+b100pOOcfU2g9C/qtuMw9jXIiPv4k45
         k5OIzBnWFGKcVURYfjDIHrDM1RGFwkgaan6ft6xcs4T63uXlCQuqVuv5077JevQehTby
         1cGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154267; x=1785759067;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2/U7VrTEi0vsV9VceOwFXfFqZdMwqeaVHPjJeSjzlTw=;
        b=mkuEybmz6loNaukIfmr/EE/uYIbyvnDA3mBELgxmySiBP5bMTQ3fnaYCj7hVZU0b7g
         8JiDFW6XVd0QBdoRF9PJiGXlpfw9V7U1EnjUYjs5DpmqnNkfJFYtegdx3VUEIlnQVQLX
         AHCrQ4gbxZjfmDZR0GjpouFLTfyyzWzyR1PlHcaP/MR6YI1qfN34qyQe2AfW2SkpQCbe
         ocG5wzRKoqyUumewHnUDTy8+SXs2FQ7Rhg3kwg4Mv65640RAKVM+hHjp+gHXG1pyeeSK
         HMPaDrc2OF1qLYweyqOZYUdc33g9H5qbEMILppL0XqlIKttnC4POTzCY5XedcR5nmvvi
         Q4dQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/59cXSFcMZs0nHK8v46VmsgpAL4lardxn0zWfEZNEy0ch9c+cn7Z99klOb9pLxLcAfpV3mEs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyD6XoPwdN7/dY3k92x2NUZytF1exFYT4RiSYIyFYRwdUryYLo+
	FWr7J5ILxCwQVO5BaZJCbFRml4iJbd1/oDBJXl6RehZYPxIDqL0YBm/pyNWo0sD5dK0=
X-Gm-Gg: AR+sD13zu9wxNF7TWzoZMqZ5Rb17ejg7SPHJPwxu2rClmG1VzTpL0EeMWFVykrMdU3O
	ldSBqiUfpA7alFqVqNNDpfTQuT2YHByD0mjb5dWUTBUaEcP92fKAqm3xjfDnVWG01Ck7z2y0gft
	aPqa9cIOw4gczHERKmrWa4M13jsilkwEGP4LsX/9/06M/pvtX8aYYEjcCBpYWuaQJZWBM8C2cOZ
	coW79fjY1g/Oi88kKse/WnyO6WWAy+OxgWAYcYL+Z3Q3vZHSG1PIUXYnOrCmVwqW81cbrvC1eV9
	qP3Yybg3XDCq6DQjhCNPLJhbyYcDq15sEyK8EAYRR7jGVf8/E7nks6lanTV6lsa7nqKx3WCJv8W
	hoChUgq5Tsrid0A0S2PG7gnM8yPWp+EkcCbMjxPGrQzf0ldyGMyEi+KjsRhrIZU26UynhRIAYrt
	VLF4nSNNzBzPDo8UeuoHZdjvSQiFo+DYe2MWASXphw
X-Received: by 2002:a05:600c:8214:b0:495:5e07:649b with SMTP id 5b1f17b1804b1-496b570dbbemr101595295e9.24.1785154267469;
        Mon, 27 Jul 2026 05:11:07 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:11:06 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:46 +0100
Subject: [PATCH 8/9] ACPI: x86: use a named initializer for
 acpi_device_id::id
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-8-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=7104;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=q1sapSQQK4AuvJxhLybez7xMW8BCU+2x792Tr/WVaBo=;
 b=MI5X6Mq6pkzQ8U1kUgUHv2AZNnfgYLmN5i9MXfb/oyE4NgRZdijr8KOymitKFXx58Yvd4fvNy
 4eACf5fvIPzBeGp1ZRG6myj6dMucjYGNloAWtUlNTlQatAqcwImBgN6
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a named initializer for the acpi_device_id::id field for
readability. Also drop setting the list terminator fields
explicitly and unify the type of the list terminator to be
a single space between the brackets.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/acpi/x86/cmos_rtc.c |  2 +-
 drivers/acpi/x86/lpss.c     | 54 ++++++++++++++++++++++-----------------------
 drivers/acpi/x86/s2idle.c   | 14 ++++++------
 drivers/acpi/x86/utils.c    | 16 +++++++-------
 4 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/acpi/x86/cmos_rtc.c b/drivers/acpi/x86/cmos_rtc.c
index ced334e19896..d9891b00d090 100644
--- a/drivers/acpi/x86/cmos_rtc.c
+++ b/drivers/acpi/x86/cmos_rtc.c
@@ -18,7 +18,7 @@
 #include "../internal.h"
 
 static const struct acpi_device_id acpi_cmos_rtc_ids[] = {
-	{ "ACPI000E", 1 }, /* ACPI Time and Alarm Device (TAD) */
+	{ .id = "ACPI000E", .driver_data = 1 }, /* ACPI Time and Alarm Device (TAD) */
 	ACPI_CMOS_RTC_IDS
 };
 
diff --git a/drivers/acpi/x86/lpss.c b/drivers/acpi/x86/lpss.c
index 0171eef00484..50b6db40bb18 100644
--- a/drivers/acpi/x86/lpss.c
+++ b/drivers/acpi/x86/lpss.c
@@ -351,41 +351,41 @@ static const struct x86_cpu_id lpss_cpu_ids[] = {
 
 static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	/* Generic LPSS devices */
-	{ "INTL9C60", LPSS_ADDR(lpss_dma_desc) },
+	{ .id = "INTL9C60", .driver_data = LPSS_ADDR(lpss_dma_desc) },
 
 	/* Lynxpoint LPSS devices */
-	{ "INT33C0", LPSS_ADDR(lpt_spi_dev_desc) },
-	{ "INT33C1", LPSS_ADDR(lpt_spi_dev_desc) },
-	{ "INT33C2", LPSS_ADDR(lpt_i2c_dev_desc) },
-	{ "INT33C3", LPSS_ADDR(lpt_i2c_dev_desc) },
-	{ "INT33C4", LPSS_ADDR(lpt_uart_dev_desc) },
-	{ "INT33C5", LPSS_ADDR(lpt_uart_dev_desc) },
-	{ "INT33C6", LPSS_ADDR(lpt_sdio_dev_desc) },
+	{ .id = "INT33C0", .driver_data = LPSS_ADDR(lpt_spi_dev_desc) },
+	{ .id = "INT33C1", .driver_data = LPSS_ADDR(lpt_spi_dev_desc) },
+	{ .id = "INT33C2", .driver_data = LPSS_ADDR(lpt_i2c_dev_desc) },
+	{ .id = "INT33C3", .driver_data = LPSS_ADDR(lpt_i2c_dev_desc) },
+	{ .id = "INT33C4", .driver_data = LPSS_ADDR(lpt_uart_dev_desc) },
+	{ .id = "INT33C5", .driver_data = LPSS_ADDR(lpt_uart_dev_desc) },
+	{ .id = "INT33C6", .driver_data = LPSS_ADDR(lpt_sdio_dev_desc) },
 
 	/* BayTrail LPSS devices */
-	{ "80860F09", LPSS_ADDR(byt_pwm_dev_desc) },
-	{ "80860F0A", LPSS_ADDR(byt_uart_dev_desc) },
-	{ "80860F0E", LPSS_ADDR(byt_spi_dev_desc) },
-	{ "80860F14", LPSS_ADDR(byt_sdio_dev_desc) },
-	{ "80860F41", LPSS_ADDR(byt_i2c_dev_desc) },
+	{ .id = "80860F09", .driver_data = LPSS_ADDR(byt_pwm_dev_desc) },
+	{ .id = "80860F0A", .driver_data = LPSS_ADDR(byt_uart_dev_desc) },
+	{ .id = "80860F0E", .driver_data = LPSS_ADDR(byt_spi_dev_desc) },
+	{ .id = "80860F14", .driver_data = LPSS_ADDR(byt_sdio_dev_desc) },
+	{ .id = "80860F41", .driver_data = LPSS_ADDR(byt_i2c_dev_desc) },
 
 	/* Braswell LPSS devices */
-	{ "80862286", LPSS_ADDR(lpss_dma_desc) },
-	{ "80862288", LPSS_ADDR(bsw_pwm_dev_desc) },
-	{ "80862289", LPSS_ADDR(bsw_pwm2_dev_desc) },
-	{ "8086228A", LPSS_ADDR(bsw_uart_dev_desc) },
-	{ "8086228E", LPSS_ADDR(bsw_spi_dev_desc) },
-	{ "808622C0", LPSS_ADDR(lpss_dma_desc) },
-	{ "808622C1", LPSS_ADDR(bsw_i2c_dev_desc) },
+	{ .id = "80862286", .driver_data = LPSS_ADDR(lpss_dma_desc) },
+	{ .id = "80862288", .driver_data = LPSS_ADDR(bsw_pwm_dev_desc) },
+	{ .id = "80862289", .driver_data = LPSS_ADDR(bsw_pwm2_dev_desc) },
+	{ .id = "8086228A", .driver_data = LPSS_ADDR(bsw_uart_dev_desc) },
+	{ .id = "8086228E", .driver_data = LPSS_ADDR(bsw_spi_dev_desc) },
+	{ .id = "808622C0", .driver_data = LPSS_ADDR(lpss_dma_desc) },
+	{ .id = "808622C1", .driver_data = LPSS_ADDR(bsw_i2c_dev_desc) },
 
 	/* Broadwell LPSS devices */
-	{ "INT3430", LPSS_ADDR(lpt_spi_dev_desc) },
-	{ "INT3431", LPSS_ADDR(lpt_spi_dev_desc) },
-	{ "INT3432", LPSS_ADDR(lpt_i2c_dev_desc) },
-	{ "INT3433", LPSS_ADDR(lpt_i2c_dev_desc) },
-	{ "INT3434", LPSS_ADDR(lpt_uart_dev_desc) },
-	{ "INT3435", LPSS_ADDR(lpt_uart_dev_desc) },
-	{ "INT3436", LPSS_ADDR(lpt_sdio_dev_desc) },
+	{ .id = "INT3430", .driver_data = LPSS_ADDR(lpt_spi_dev_desc) },
+	{ .id = "INT3431", .driver_data = LPSS_ADDR(lpt_spi_dev_desc) },
+	{ .id = "INT3432", .driver_data = LPSS_ADDR(lpt_i2c_dev_desc) },
+	{ .id = "INT3433", .driver_data = LPSS_ADDR(lpt_i2c_dev_desc) },
+	{ .id = "INT3434", .driver_data = LPSS_ADDR(lpt_uart_dev_desc) },
+	{ .id = "INT3435", .driver_data = LPSS_ADDR(lpt_uart_dev_desc) },
+	{ .id = "INT3436", .driver_data = LPSS_ADDR(lpt_sdio_dev_desc) },
 
 	{ }
 };
diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index b6b1dd76a06b..64c4e10e71a1 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -33,8 +33,8 @@ module_param(check_lps0_constraints, bool, 0644);
 MODULE_PARM_DESC(check_lps0_constraints, "Check LPS0 device constraints");
 
 static const struct acpi_device_id lps0_device_ids[] = {
-	{"PNP0D80", },
-	{"", },
+	{ .id = "PNP0D80" },
+	{ }
 };
 
 /* Microsoft platform agnostic UUID */
@@ -431,11 +431,11 @@ static const struct amd_lps0_hid_device_data amd_cezanne = {
 };
 
 static const struct acpi_device_id amd_hid_ids[] = {
-	{"AMD0004",	(kernel_ulong_t)&amd_picasso,	},
-	{"AMD0005",	(kernel_ulong_t)&amd_picasso,	},
-	{"AMDI0005",	(kernel_ulong_t)&amd_picasso,	},
-	{"AMDI0006",	(kernel_ulong_t)&amd_cezanne,	},
-	{}
+	{ .id = "AMD0004",	.driver_data = (kernel_ulong_t)&amd_picasso },
+	{ .id = "AMD0005",	.driver_data = (kernel_ulong_t)&amd_picasso },
+	{ .id = "AMDI0005",	.driver_data = (kernel_ulong_t)&amd_picasso },
+	{ .id = "AMDI0006",	.driver_data = (kernel_ulong_t)&amd_cezanne },
+	{ }
 };
 
 static int lps0_device_attach(struct acpi_device *adev,
diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 418951639f51..35580d77d8af 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -463,14 +463,14 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
 static const struct acpi_device_id i2c_acpi_known_good_ids[] = {
-	{ "10EC5640", 0 }, /* RealTek ALC5640 audio codec */
-	{ "10EC5651", 0 }, /* RealTek ALC5651 audio codec */
-	{ "INT33F4", 0 },  /* X-Powers AXP288 PMIC */
-	{ "INT33F5", 0 },  /* TI Dollar Cove PMIC */
-	{ "INT33FD", 0 },  /* Intel Crystal Cove PMIC */
-	{ "INT34D3", 0 },  /* Intel Whiskey Cove PMIC */
-	{ "NPCE69A", 0 },  /* Asus Transformer keyboard dock */
-	{}
+	{ .id = "10EC5640" }, /* RealTek ALC5640 audio codec */
+	{ .id = "10EC5651" }, /* RealTek ALC5651 audio codec */
+	{ .id = "INT33F4" },  /* X-Powers AXP288 PMIC */
+	{ .id = "INT33F5" },  /* TI Dollar Cove PMIC */
+	{ .id = "INT33FD" },  /* Intel Crystal Cove PMIC */
+	{ .id = "INT34D3" },  /* Intel Whiskey Cove PMIC */
+	{ .id = "NPCE69A" },  /* Asus Transformer keyboard dock */
+	{ }
 };
 
 bool acpi_quirk_skip_i2c_client_enumeration(struct acpi_device *adev)

-- 
2.43.0

