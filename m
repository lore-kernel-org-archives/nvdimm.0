Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B31E3FE35D
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154262; cv=none; b=nMMhYf3nE7sQETcUjSANx8RT6oU2eGiuG56IeY61uKTx3yvxYKnvzkifOtOug18+EjY44Lvj2mRLvDgmUAkDySlaouVRjFSSKPxRTNweNpB+128wYo71/YkRPLcS3kCoTTjtPAUy0Keg0F1FW1E+U/9sae9BBx+ETCz8PYUUJPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154262; c=relaxed/simple;
	bh=36Z945Dybjs49dltSXQdCok5RhuCB/vCWDU7Zp+BSpo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sFzP7YL8WL9G5SEU0O4qrJYsqlSAu9eblzS0TkKSF1MwPAWp7ErcPkLb1U8KeZkPXsVxZRvhqE+Y3xIwIqxIqN6z4FM4eEbInA/3nR95x7ju5gt/RTDow3cdHebwWggN7lkEhh/E/dovoAVDSc37tYsWDwSj/1CWg6s4rodZlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=daH/7FHZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="daH/7FHZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4955de8797cso16107995e9.3
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154256; x=1785759056; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1z0JUSu7qdewCc8/45l50jzVZJhN62j8uNPxdfkwM9c=;
        b=daH/7FHZywYGWj6sM9oQs2chio5IxmumnW5lwYrilR+iSzG0usJLv+0LSfhB30e25n
         CnneATQ+cENPtGZdceANpbS9d2mxV7zkXyP0sotcQfAwvel2GSH6E7iJhNUnCXM5cN/a
         T4z/xiHt/+xI0I1ePazvbmCKDNkLd9CXXEyjMdZqsY9rvHN28Xnh9WMjEmJnSDYzlHdk
         lLncvODgra2tq4EacEusn3U2Om9wsqNa4mcRROEekoWHr+PWzTl9YP02yTyeyaeb0byk
         SE1Nld2RB0GG/lb8KcmbbvKaq4WFEUhKvdmbaUcLDGr/E70IIJ9dNwaom/oLo3A6LeYF
         qOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154256; x=1785759056;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1z0JUSu7qdewCc8/45l50jzVZJhN62j8uNPxdfkwM9c=;
        b=ojiLVMo4E8ZvORuF3OmpJEy2uaQ3d1Mx6MwDI7LqSRiEklBAR3biGnDId5u6KrAheh
         pGi2u08bZxFrRc5tiUICFpBbZiNOL2AX9lORAQQm7NmzgzvyS7b1ZtOiAe317jIrMDoq
         waJoucZzYzMr+KUQYp62gowTD1P/p8/y05zBXcC5kRpZbXB5ZXhXAvTcAseAuLFAHlC3
         jZYjK5qBeTbkEUkuB36fbsPMmcEL6tDy64SoFhuLFDI2dcg/3wbbASBs8IECy0Yqhk72
         nMf/q0GjkhrSb82JcGCKYeL1xvYYgDAftwOC2puV3TbrFcU/uEgps27Xe1Uy1jjNYNFM
         xITA==
X-Forwarded-Encrypted: i=1; AHgh+Rp4pJcFhgs9bZqPnBslc6LZHIlUkBCWRYJfJtcm6Fhz9oRaqy6ZXKbETLjvgdfg6kPhwTH3KWQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwssyDqYmRKjDDj0p7/4nMQYOXp+Xcm0PkwQ1Ub1U4moDDdMGkA
	2VKSKqt/2ZJo/wx+lwn+LMIhdC3jU1UJKO+4WnHmibYw1OTckqhHztKlzKCNCfpo6VQ=
X-Gm-Gg: AR+sD12DPlH0feqYGzvRzx5DNDMsR45l+qy4bBb53+IB50Am/6e9a/bywjY3CNCVZQF
	wYVuuU7vcMTnpbrfVsZen3kQOndmm1RWfc9piPOfaq4x4D3OmeoaTlOZMWsIVIooBZpL4BgrBVB
	7+XP346HTE3ZuTxxwWEbn2hsKVrRbfJ4GHv0S3RezlD+eBM3ZXv3i4mj7WyHlSqElCJlTgAm1z8
	D5v9zuow50pCQP3XnLHlLDECSqWT8YjpBN/oUeWH0xEZAFETb2Y6QHwD+azqXjHOqPrAsK9SSLi
	BuJYitx/Vcvx/1Pf6Ahycs3QwfsJTF7f36HJfMPvMMhy+JLdTFTrSVpTWm40AF0dWdSrX32j3eF
	IH4VeAcXETK5fm01sg0j95zRO20t7dOrU23XZmszpFiW3fU/hsKm5fxFYb/Jy9orcxm76xHwId5
	Xx97JPWYAQWOWcEtv08ts=
X-Received: by 2002:a05:600c:1c07:b0:495:6397:14b1 with SMTP id 5b1f17b1804b1-496b690a9f1mr103806715e9.34.1785154255504;
        Mon, 27 Jul 2026 05:10:55 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:10:55 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:39 +0100
Subject: [PATCH 1/9] ACPI: use a named initializer for acpi_device_id
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-1-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=37208;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=36Z945Dybjs49dltSXQdCok5RhuCB/vCWDU7Zp+BSpo=;
 b=vYwViUbBhKqa/TpGvZQudxWcS6150/8BF+KPVT2l8xH31nUXI8dysAieLN3i2KF8tzqfoUAxa
 Her015PxY3zDdZ+Z9YYSA1IZ+x5ZbLGJd5GqATA6bv2KFgqxHcqI0Gr
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a named initializer for the acpi_device_id fields which
makes the code more readable and consistent with how lists
are initialized in the rest of the kernel code base.

While we are at it - unify the list terminator to have
a single space between the brackets.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/acpi/acpi_apd.c       |  42 ++--
 drivers/acpi/acpi_platform.c  |  13 +-
 drivers/acpi/acpi_pnp.c       | 514 +++++++++++++++++++++---------------------
 drivers/acpi/acpi_processor.c |   8 +-
 drivers/acpi/acpi_video.c     |   2 +-
 drivers/acpi/button.c         |  12 +-
 drivers/acpi/evged.c          |   4 +-
 drivers/acpi/fan_core.c       |   2 +-
 drivers/acpi/pfr_telemetry.c  |   4 +-
 drivers/acpi/pfr_update.c     |   4 +-
 drivers/acpi/scan.c           |  46 ++--
 11 files changed, 325 insertions(+), 326 deletions(-)

diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
index 008bd0552cb7..e649c93129b9 100644
--- a/drivers/acpi/acpi_apd.c
+++ b/drivers/acpi/acpi_apd.c
@@ -242,29 +242,29 @@ static int acpi_apd_create_device(struct acpi_device *adev,
 static const struct acpi_device_id acpi_apd_device_ids[] = {
 	/* Generic apd devices */
 #ifdef CONFIG_X86_AMD_PLATFORM_DEVICE
-	{ "AMD0010", APD_ADDR(cz_i2c_desc) },
-	{ "AMD0020", APD_ADDR(cz_uart_desc) },
-	{ "AMD0030", },
-	{ "AMD0040", APD_ADDR(fch_misc_desc)},
-	{ "AMDI0010", APD_ADDR(wt_i2c_desc) },
-	{ "AMDI0015", APD_ADDR(wt_i3c_desc) },
-	{ "AMDI0019", APD_ADDR(wt_i2c_desc) },
-	{ "AMDI0020", APD_ADDR(cz_uart_desc) },
-	{ "AMDI0022", APD_ADDR(cz_uart_desc) },
-	{ "HYGO0010", APD_ADDR(wt_i2c_desc) },
+	{ .id = "AMD0010",	.driver_data = APD_ADDR(cz_i2c_desc) },
+	{ .id = "AMD0020",	.driver_data = APD_ADDR(cz_uart_desc) },
+	{ .id = "AMD0030" },
+	{ .id = "AMD0040",	.driver_data = APD_ADDR(fch_misc_desc) },
+	{ .id = "AMDI0010",	.driver_data = APD_ADDR(wt_i2c_desc) },
+	{ .id = "AMDI0015",	.driver_data = APD_ADDR(wt_i3c_desc) },
+	{ .id = "AMDI0019",	.driver_data = APD_ADDR(wt_i2c_desc) },
+	{ .id = "AMDI0020",	.driver_data = APD_ADDR(cz_uart_desc) },
+	{ .id = "AMDI0022",	.driver_data = APD_ADDR(cz_uart_desc) },
+	{ .id = "HYGO0010",	.driver_data = APD_ADDR(wt_i2c_desc) },
 #endif
 #ifdef CONFIG_ARM64
-	{ "APMC0D0F", APD_ADDR(xgene_i2c_desc) },
-	{ "BRCM900D", APD_ADDR(vulcan_spi_desc) },
-	{ "CAV900D",  APD_ADDR(vulcan_spi_desc) },
-	{ "CAV9007",  APD_ADDR(thunderx2_i2c_desc) },
-	{ "HISI02A1", APD_ADDR(hip07_i2c_desc) },
-	{ "HISI02A2", APD_ADDR(hip08_i2c_desc) },
-	{ "HISI02A3", APD_ADDR(hip08_lite_i2c_desc) },
-	{ "HISI0173", APD_ADDR(hip08_spi_desc) },
-	{ "LECA0002", APD_ADDR(leca_spi_desc) },
-	{ "LECA0003", APD_ADDR(leca_i2c_desc) },
-	{ "NXP0001", APD_ADDR(nxp_i2c_desc) },
+	{ .id = "APMC0D0F",	.driver_data = APD_ADDR(xgene_i2c_desc) },
+	{ .id = "BRCM900D",	.driver_data = APD_ADDR(vulcan_spi_desc) },
+	{ .id = "CAV900D",	.driver_data = APD_ADDR(vulcan_spi_desc) },
+	{ .id = "CAV9007",	.driver_data = APD_ADDR(thunderx2_i2c_desc) },
+	{ .id = "HISI02A1",	.driver_data = APD_ADDR(hip07_i2c_desc) },
+	{ .id = "HISI02A2",	.driver_data = APD_ADDR(hip08_i2c_desc) },
+	{ .id = "HISI02A3",	.driver_data = APD_ADDR(hip08_lite_i2c_desc) },
+	{ .id = "HISI0173",	.driver_data = APD_ADDR(hip08_spi_desc) },
+	{ .id = "LECA0002",	.driver_data = APD_ADDR(leca_spi_desc) },
+	{ .id = "LECA0003",	.driver_data = APD_ADDR(leca_i2c_desc) },
+	{ .id = "NXP0001",	.driver_data = APD_ADDR(nxp_i2c_desc) },
 #endif
 	{ }
 };
diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index a09636a4168e..cf05b4889157 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -24,12 +24,13 @@
 #define ACPI_ALLOW_WO_RESOURCES		BIT(0)
 
 static const struct acpi_device_id forbidden_id_list[] = {
-	{"ACPI0009", 0},	/* IOxAPIC */
-	{"ACPI000A", 0},	/* IOAPIC */
-	{"PNP0000",  0},	/* PIC */
-	{"PNP0100",  0},	/* Timer */
-	{"PNP0200",  0},	/* AT DMA Controller */
-	{ACPI_SMBUS_MS_HID,  ACPI_ALLOW_WO_RESOURCES},	/* ACPI SMBUS virtual device */
+	{ .id = "ACPI0009" },	/* IOxAPIC */
+	{ .id = "ACPI000A" },	/* IOAPIC */
+	{ .id = "PNP0000" },	/* PIC */
+	{ .id = "PNP0100" },	/* Timer */
+	{ .id = "PNP0200" },	/* AT DMA Controller */
+	{ .id = ACPI_SMBUS_MS_HID, .driver_data = ACPI_ALLOW_WO_RESOURCES },
+							/* ACPI SMBUS virtual device */
 	{ }
 };
 
diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index da886923b008..bbacbd03d06a 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -15,293 +15,293 @@
 
 static const struct acpi_device_id acpi_pnp_device_ids[] = {
 	/* pata_isapnp */
-	{"PNP0600"},		/* Generic ESDI/IDE/ATA compatible hard disk controller */
+	{ .id = "PNP0600" },	/* Generic ESDI/IDE/ATA compatible hard disk controller */
 	/* floppy */
-	{"PNP0700"},
+	{ .id = "PNP0700" },
 	/* tpm_inf_pnp */
-	{"IFX0101"},		/* Infineon TPMs */
-	{"IFX0102"},		/* Infineon TPMs */
+	{ .id = "IFX0101" },	/* Infineon TPMs */
+	{ .id = "IFX0102" },	/* Infineon TPMs */
 	/*tpm_tis */
-	{"PNP0C31"},		/* TPM */
-	{"ATM1200"},		/* Atmel */
-	{"IFX0102"},		/* Infineon */
-	{"BCM0101"},		/* Broadcom */
-	{"BCM0102"},		/* Broadcom */
-	{"NSC1200"},		/* National */
-	{"ICO0102"},		/* Intel */
+	{ .id = "PNP0C31" },	/* TPM */
+	{ .id = "ATM1200" },	/* Atmel */
+	{ .id = "IFX0102" },	/* Infineon */
+	{ .id = "BCM0101" },	/* Broadcom */
+	{ .id = "BCM0102" },	/* Broadcom */
+	{ .id = "NSC1200" },	/* National */
+	{ .id = "ICO0102" },	/* Intel */
 	/* ide   */
-	{"PNP0600"},		/* Generic ESDI/IDE/ATA compatible hard disk controller */
+	{ .id = "PNP0600" },	/* Generic ESDI/IDE/ATA compatible hard disk controller */
 	/* ns558 */
-	{"ASB16fd"},		/* AdLib NSC16 */
-	{"AZT3001"},		/* AZT1008 */
-	{"CDC0001"},		/* Opl3-SAx */
-	{"CSC0001"},		/* CS4232 */
-	{"CSC000f"},		/* CS4236 */
-	{"CSC0101"},		/* CS4327 */
-	{"CTL7001"},		/* SB16 */
-	{"CTL7002"},		/* AWE64 */
-	{"CTL7005"},		/* Vibra16 */
-	{"ENS2020"},		/* SoundscapeVIVO */
-	{"ESS0001"},		/* ES1869 */
-	{"ESS0005"},		/* ES1878 */
-	{"ESS6880"},		/* ES688 */
-	{"IBM0012"},		/* CS4232 */
-	{"OPT0001"},		/* OPTi Audio16 */
-	{"YMH0006"},		/* Opl3-SA */
-	{"YMH0022"},		/* Opl3-SAx */
-	{"PNPb02f"},		/* Generic */
+	{ .id = "ASB16fd" },	/* AdLib NSC16 */
+	{ .id = "AZT3001" },	/* AZT1008 */
+	{ .id = "CDC0001" },	/* Opl3-SAx */
+	{ .id = "CSC0001" },	/* CS4232 */
+	{ .id = "CSC000f" },	/* CS4236 */
+	{ .id = "CSC0101" },	/* CS4327 */
+	{ .id = "CTL7001" },	/* SB16 */
+	{ .id = "CTL7002" },	/* AWE64 */
+	{ .id = "CTL7005" },	/* Vibra16 */
+	{ .id = "ENS2020" },	/* SoundscapeVIVO */
+	{ .id = "ESS0001" },	/* ES1869 */
+	{ .id = "ESS0005" },	/* ES1878 */
+	{ .id = "ESS6880" },	/* ES688 */
+	{ .id = "IBM0012" },	/* CS4232 */
+	{ .id = "OPT0001" },	/* OPTi Audio16 */
+	{ .id = "YMH0006" },	/* Opl3-SA */
+	{ .id = "YMH0022" },	/* Opl3-SAx */
+	{ .id = "PNPb02f" },	/* Generic */
 	/* i8042 kbd */
-	{"PNP0300"},
-	{"PNP0301"},
-	{"PNP0302"},
-	{"PNP0303"},
-	{"PNP0304"},
-	{"PNP0305"},
-	{"PNP0306"},
-	{"PNP0309"},
-	{"PNP030a"},
-	{"PNP030b"},
-	{"PNP0320"},
-	{"PNP0343"},
-	{"PNP0344"},
-	{"PNP0345"},
-	{"CPQA0D7"},
+	{ .id = "PNP0300" },
+	{ .id = "PNP0301" },
+	{ .id = "PNP0302" },
+	{ .id = "PNP0303" },
+	{ .id = "PNP0304" },
+	{ .id = "PNP0305" },
+	{ .id = "PNP0306" },
+	{ .id = "PNP0309" },
+	{ .id = "PNP030a" },
+	{ .id = "PNP030b" },
+	{ .id = "PNP0320" },
+	{ .id = "PNP0343" },
+	{ .id = "PNP0344" },
+	{ .id = "PNP0345" },
+	{ .id = "CPQA0D7" },
 	/* i8042 aux */
-	{"AUI0200"},
-	{"FJC6000"},
-	{"FJC6001"},
-	{"PNP0f03"},
-	{"PNP0f0b"},
-	{"PNP0f0e"},
-	{"PNP0f12"},
-	{"PNP0f13"},
-	{"PNP0f19"},
-	{"PNP0f1c"},
-	{"SYN0801"},
+	{ .id = "AUI0200" },
+	{ .id = "FJC6000" },
+	{ .id = "FJC6001" },
+	{ .id = "PNP0f03" },
+	{ .id = "PNP0f0b" },
+	{ .id = "PNP0f0e" },
+	{ .id = "PNP0f12" },
+	{ .id = "PNP0f13" },
+	{ .id = "PNP0f19" },
+	{ .id = "PNP0f1c" },
+	{ .id = "SYN0801" },
 	/* fcpnp */
-	{"AVM0900"},
+	{ .id = "AVM0900" },
 	/* radio-cadet */
-	{"MSM0c24"},		/* ADS Cadet AM/FM Radio Card */
+	{ .id = "MSM0c24" },	/* ADS Cadet AM/FM Radio Card */
 	/* radio-gemtek */
-	{"ADS7183"},		/* AOpen FX-3D/Pro Radio */
+	{ .id = "ADS7183" },	/* AOpen FX-3D/Pro Radio */
 	/* radio-sf16fmr2 */
-	{"MFRad13"},		/* tuner subdevice of SF16-FMD2 */
+	{ .id = "MFRad13" },	/* tuner subdevice of SF16-FMD2 */
 	/* ene_ir */
-	{"ENE0100"},
-	{"ENE0200"},
-	{"ENE0201"},
-	{"ENE0202"},
+	{ .id = "ENE0100" },
+	{ .id = "ENE0200" },
+	{ .id = "ENE0201" },
+	{ .id = "ENE0202" },
 	/* fintek-cir */
-	{"FIT0002"},		/* CIR */
+	{ .id = "FIT0002" },	/* CIR */
 	/* ite-cir */
-	{"ITE8704"},		/* Default model */
-	{"ITE8713"},		/* CIR found in EEEBox 1501U */
-	{"ITE8708"},		/* Bridged IT8512 */
-	{"ITE8709"},		/* SRAM-Bridged IT8512 */
+	{ .id = "ITE8704" },	/* Default model */
+	{ .id = "ITE8713" },	/* CIR found in EEEBox 1501U */
+	{ .id = "ITE8708" },	/* Bridged IT8512 */
+	{ .id = "ITE8709" },	/* SRAM-Bridged IT8512 */
 	/* nuvoton-cir */
-	{"WEC0530"},		/* CIR */
-	{"NTN0530"},		/* CIR for new chip's pnp id */
+	{ .id = "WEC0530" },	/* CIR */
+	{ .id = "NTN0530" },	/* CIR for new chip's pnp id */
 	/* Winbond CIR */
-	{"WEC1022"},
+	{ .id = "WEC1022" },
 	/* wbsd */
-	{"WEC0517"},
-	{"WEC0518"},
+	{ .id = "WEC0517" },
+	{ .id = "WEC0518" },
 	/* Winbond CIR */
-	{"TCM5090"},		/* 3Com Etherlink III (TP) */
-	{"TCM5091"},		/* 3Com Etherlink III */
-	{"TCM5094"},		/* 3Com Etherlink III (combo) */
-	{"TCM5095"},		/* 3Com Etherlink III (TPO) */
-	{"TCM5098"},		/* 3Com Etherlink III (TPC) */
-	{"PNP80f7"},		/* 3Com Etherlink III compatible */
-	{"PNP80f8"},		/* 3Com Etherlink III compatible */
+	{ .id = "TCM5090" },	/* 3Com Etherlink III (TP) */
+	{ .id = "TCM5091" },	/* 3Com Etherlink III */
+	{ .id = "TCM5094" },	/* 3Com Etherlink III (combo) */
+	{ .id = "TCM5095" },	/* 3Com Etherlink III (TPO) */
+	{ .id = "TCM5098" },	/* 3Com Etherlink III (TPC) */
+	{ .id = "PNP80f7" },	/* 3Com Etherlink III compatible */
+	{ .id = "PNP80f8" },	/* 3Com Etherlink III compatible */
 	/* nsc-ircc */
-	{"NSC6001"},
-	{"HWPC224"},
-	{"IBM0071"},
+	{ .id = "NSC6001" },
+	{ .id = "HWPC224" },
+	{ .id = "IBM0071" },
 	/* smsc-ircc2 */
-	{"SMCf010"},
+	{ .id = "SMCf010" },
 	/* parport_pc */
-	{"PNP0400"},		/* Standard LPT Printer Port */
-	{"PNP0401"},		/* ECP Printer Port */
+	{ .id = "PNP0400" },	/* Standard LPT Printer Port */
+	{ .id = "PNP0401" },	/* ECP Printer Port */
 	/* apple-gmux */
-	{"APP000B"},
+	{ .id = "APP000B" },
 	/* c6xdigio */
-	{"PNP0400"},		/* Standard LPT Printer Port */
-	{"PNP0401"},		/* ECP Printer Port */
+	{ .id = "PNP0400" },	/* Standard LPT Printer Port */
+	{ .id = "PNP0401" },	/* ECP Printer Port */
 	/* ni_atmio.c */
-	{"NIC1900"},
-	{"NIC2400"},
-	{"NIC2500"},
-	{"NIC2600"},
-	{"NIC2700"},
+	{ .id = "NIC1900" },
+	{ .id = "NIC2400" },
+	{ .id = "NIC2500" },
+	{ .id = "NIC2600" },
+	{ .id = "NIC2700" },
 	/* serial */
-	{"AAC000F"},		/* Archtek America Corp. Archtek SmartLink Modem 3334BT Plug & Play */
-	{"ADC0001"},		/* Anchor Datacomm BV. SXPro 144 External Data Fax Modem Plug & Play */
-	{"ADC0002"},		/* SXPro 288 External Data Fax Modem Plug & Play */
-	{"AEI0250"},		/* PROLiNK 1456VH ISA PnP K56flex Fax Modem */
-	{"AEI1240"},		/* Actiontec ISA PNP 56K X2 Fax Modem */
-	{"AKY1021"},		/* Rockwell 56K ACF II Fax+Data+Voice Modem */
-	{"ALI5123"},		/* ALi Fast Infrared Controller */
-	{"AZT4001"},		/* AZT3005 PnP SOUND DEVICE */
-	{"BDP3336"},		/* Best Data Products Inc. Smart One 336F PnP Modem */
-	{"BRI0A49"},		/* Boca Complete Ofc Communicator 14.4 Data-FAX */
-	{"BRI1400"},		/* Boca Research 33,600 ACF Modem */
-	{"BRI3400"},		/* Boca 33.6 Kbps Internal FD34FSVD */
-	{"CPI4050"},		/* Computer Peripherals Inc. EuroViVa CommCenter-33.6 SP PnP */
-	{"CTL3001"},		/* Creative Labs Phone Blaster 28.8 DSVD PnP Voice */
-	{"CTL3011"},		/* Creative Labs Modem Blaster 28.8 DSVD PnP Voice */
-	{"DAV0336"},		/* Davicom ISA 33.6K Modem */
-	{"DMB1032"},		/* Creative Modem Blaster Flash56 DI5601-1 */
-	{"DMB2001"},		/* Creative Modem Blaster V.90 DI5660 */
-	{"ETT0002"},		/* E-Tech CyberBULLET PC56RVP */
-	{"FUJ0202"},		/* Fujitsu 33600 PnP-I2 R Plug & Play */
-	{"FUJ0205"},		/* Fujitsu FMV-FX431 Plug & Play */
-	{"FUJ0206"},		/* Fujitsu 33600 PnP-I4 R Plug & Play */
-	{"FUJ0209"},		/* Fujitsu Fax Voice 33600 PNP-I5 R Plug & Play */
-	{"GVC000F"},		/* Archtek SmartLink Modem 3334BT Plug & Play */
-	{"GVC0303"},		/* Archtek SmartLink Modem 3334BRV 33.6K Data Fax Voice */
-	{"HAY0001"},		/* Hayes Optima 288 V.34-V.FC + FAX + Voice Plug & Play */
-	{"HAY000C"},		/* Hayes Optima 336 V.34 + FAX + Voice PnP */
-	{"HAY000D"},		/* Hayes Optima 336B V.34 + FAX + Voice PnP */
-	{"HAY5670"},		/* Hayes Accura 56K Ext Fax Modem PnP */
-	{"HAY5674"},		/* Hayes Accura 56K Ext Fax Modem PnP */
-	{"HAY5675"},		/* Hayes Accura 56K Fax Modem PnP */
-	{"HAYF000"},		/* Hayes 288, V.34 + FAX */
-	{"HAYF001"},		/* Hayes Optima 288 V.34 + FAX + Voice, Plug & Play */
-	{"IBM0033"},		/* IBM Thinkpad 701 Internal Modem Voice */
-	{"PNP4972"},		/* Intermec CV60 touchscreen port */
-	{"IXDC801"},		/* Intertex 28k8 33k6 Voice EXT PnP */
-	{"IXDC901"},		/* Intertex 33k6 56k Voice EXT PnP */
-	{"IXDD801"},		/* Intertex 28k8 33k6 Voice SP EXT PnP */
-	{"IXDD901"},		/* Intertex 33k6 56k Voice SP EXT PnP */
-	{"IXDF401"},		/* Intertex 28k8 33k6 Voice SP INT PnP */
-	{"IXDF801"},		/* Intertex 28k8 33k6 Voice SP EXT PnP */
-	{"IXDF901"},		/* Intertex 33k6 56k Voice SP EXT PnP */
-	{"KOR4522"},		/* KORTEX 28800 Externe PnP */
-	{"KORF661"},		/* KXPro 33.6 Vocal ASVD PnP */
-	{"LAS4040"},		/* LASAT Internet 33600 PnP */
-	{"LAS4540"},		/* Lasat Safire 560 PnP */
-	{"LAS5440"},		/* Lasat Safire 336  PnP */
-	{"MNP0281"},		/* Microcom TravelPorte FAST V.34 Plug & Play */
-	{"MNP0336"},		/* Microcom DeskPorte V.34 FAST or FAST+ Plug & Play */
-	{"MNP0339"},		/* Microcom DeskPorte FAST EP 28.8 Plug & Play */
-	{"MNP0342"},		/* Microcom DeskPorte 28.8P Plug & Play */
-	{"MNP0500"},		/* Microcom DeskPorte FAST ES 28.8 Plug & Play */
-	{"MNP0501"},		/* Microcom DeskPorte FAST ES 28.8 Plug & Play */
-	{"MNP0502"},		/* Microcom DeskPorte 28.8S Internal Plug & Play */
-	{"MOT1105"},		/* Motorola BitSURFR Plug & Play */
-	{"MOT1111"},		/* Motorola TA210 Plug & Play */
-	{"MOT1114"},		/* Motorola HMTA 200 (ISDN) Plug & Play */
-	{"MOT1115"},		/* Motorola BitSURFR Plug & Play */
-	{"MOT1190"},		/* Motorola Lifestyle 28.8 Internal */
-	{"MOT1501"},		/* Motorola V.3400 Plug & Play */
-	{"MOT1502"},		/* Motorola Lifestyle 28.8 V.34 Plug & Play */
-	{"MOT1505"},		/* Motorola Power 28.8 V.34 Plug & Play */
-	{"MOT1509"},		/* Motorola ModemSURFR External 28.8 Plug & Play */
-	{"MOT150A"},		/* Motorola Premier 33.6 Desktop Plug & Play */
-	{"MOT150F"},		/* Motorola VoiceSURFR 56K External PnP */
-	{"MOT1510"},		/* Motorola ModemSURFR 56K External PnP */
-	{"MOT1550"},		/* Motorola ModemSURFR 56K Internal PnP */
-	{"MOT1560"},		/* Motorola ModemSURFR Internal 28.8 Plug & Play */
-	{"MOT1580"},		/* Motorola Premier 33.6 Internal Plug & Play */
-	{"MOT15B0"},		/* Motorola OnlineSURFR 28.8 Internal Plug & Play */
-	{"MOT15F0"},		/* Motorola VoiceSURFR 56K Internal PnP */
-	{"MVX00A1"},		/*  Deskline K56 Phone System PnP */
-	{"MVX00F2"},		/* PC Rider K56 Phone System PnP */
-	{"nEC8241"},		/* NEC 98NOTE SPEAKER PHONE FAX MODEM(33600bps) */
-	{"PMC2430"},		/* Pace 56 Voice Internal Plug & Play Modem */
-	{"PNP0500"},		/* Generic standard PC COM port     */
-	{"PNP0501"},		/* Generic 16550A-compatible COM port */
-	{"PNPC000"},		/* Compaq 14400 Modem */
-	{"PNPC001"},		/* Compaq 2400/9600 Modem */
-	{"PNPC031"},		/* Dial-Up Networking Serial Cable between 2 PCs */
-	{"PNPC032"},		/* Dial-Up Networking Parallel Cable between 2 PCs */
-	{"PNPC100"},		/* Standard 9600 bps Modem */
-	{"PNPC101"},		/* Standard 14400 bps Modem */
-	{"PNPC102"},		/*  Standard 28800 bps Modem */
-	{"PNPC103"},		/*  Standard Modem */
-	{"PNPC104"},		/*  Standard 9600 bps Modem */
-	{"PNPC105"},		/*  Standard 14400 bps Modem */
-	{"PNPC106"},		/*  Standard 28800 bps Modem */
-	{"PNPC107"},		/*  Standard Modem */
-	{"PNPC108"},		/* Standard 9600 bps Modem */
-	{"PNPC109"},		/* Standard 14400 bps Modem */
-	{"PNPC10A"},		/* Standard 28800 bps Modem */
-	{"PNPC10B"},		/* Standard Modem */
-	{"PNPC10C"},		/* Standard 9600 bps Modem */
-	{"PNPC10D"},		/* Standard 14400 bps Modem */
-	{"PNPC10E"},		/* Standard 28800 bps Modem */
-	{"PNPC10F"},		/* Standard Modem */
-	{"PNP2000"},		/* Standard PCMCIA Card Modem */
-	{"ROK0030"},		/* Rockwell 33.6 DPF Internal PnP, Modular Technology 33.6 Internal PnP */
-	{"ROK0100"},		/* KORTEX 14400 Externe PnP */
-	{"ROK4120"},		/* Rockwell 28.8 */
-	{"ROK4920"},		/* Viking 28.8 INTERNAL Fax+Data+Voice PnP */
-	{"RSS00A0"},		/* Rockwell 33.6 DPF External PnP, BT Prologue 33.6 External PnP, Modular Technology 33.6 External PnP */
-	{"RSS0262"},		/* Viking 56K FAX INT */
-	{"RSS0250"},		/* K56 par,VV,Voice,Speakphone,AudioSpan,PnP */
-	{"SUP1310"},		/* SupraExpress 28.8 Data/Fax PnP modem */
-	{"SUP1381"},		/* SupraExpress 336i PnP Voice Modem */
-	{"SUP1421"},		/* SupraExpress 33.6 Data/Fax PnP modem */
-	{"SUP1590"},		/* SupraExpress 33.6 Data/Fax PnP modem */
-	{"SUP1620"},		/* SupraExpress 336i Sp ASVD */
-	{"SUP1760"},		/* SupraExpress 33.6 Data/Fax PnP modem */
-	{"SUP2171"},		/* SupraExpress 56i Sp Intl */
-	{"TEX0011"},		/* Phoebe Micro 33.6 Data Fax 1433VQH Plug & Play */
-	{"UAC000F"},		/* Archtek SmartLink Modem 3334BT Plug & Play */
-	{"USR0000"},		/* 3Com Corp. Gateway Telepath IIvi 33.6 */
-	{"USR0002"},		/* U.S. Robotics Sporster 33.6K Fax INT PnP */
-	{"USR0004"},		/*  Sportster Vi 14.4 PnP FAX Voicemail */
-	{"USR0006"},		/* U.S. Robotics 33.6K Voice INT PnP */
-	{"USR0007"},		/* U.S. Robotics 33.6K Voice EXT PnP */
-	{"USR0009"},		/* U.S. Robotics Courier V.Everything INT PnP */
-	{"USR2002"},		/* U.S. Robotics 33.6K Voice INT PnP */
-	{"USR2070"},		/* U.S. Robotics 56K Voice INT PnP */
-	{"USR2080"},		/* U.S. Robotics 56K Voice EXT PnP */
-	{"USR3031"},		/* U.S. Robotics 56K FAX INT */
-	{"USR3050"},		/* U.S. Robotics 56K FAX INT */
-	{"USR3070"},		/* U.S. Robotics 56K Voice INT PnP */
-	{"USR3080"},		/* U.S. Robotics 56K Voice EXT PnP */
-	{"USR3090"},		/* U.S. Robotics 56K Voice INT PnP */
-	{"USR9100"},		/* U.S. Robotics 56K Message  */
-	{"USR9160"},		/* U.S. Robotics 56K FAX EXT PnP */
-	{"USR9170"},		/* U.S. Robotics 56K FAX INT PnP */
-	{"USR9180"},		/* U.S. Robotics 56K Voice EXT PnP */
-	{"USR9190"},		/* U.S. Robotics 56K Voice INT PnP */
-	{"WACFXXX"},		/* Wacom tablets */
-	{"FPI2002"},		/* Compaq touchscreen */
-	{"FUJ02B2"},		/* Fujitsu Stylistic touchscreens */
-	{"FUJ02B3"},
-	{"FUJ02B4"},		/* Fujitsu Stylistic LT touchscreens */
-	{"FUJ02B6"},		/* Passive Fujitsu Stylistic touchscreens */
-	{"FUJ02B7"},
-	{"FUJ02B8"},
-	{"FUJ02B9"},
-	{"FUJ02BC"},
-	{"FUJ02E5"},		/* Fujitsu Wacom Tablet PC device */
-	{"FUJ02E6"},		/* Fujitsu P-series tablet PC device */
-	{"FUJ02E7"},		/* Fujitsu Wacom 2FGT Tablet PC device */
-	{"FUJ02E9"},		/* Fujitsu Wacom 1FGT Tablet PC device */
-	{"LTS0001"},		/* LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in disguise) */
-	{"WCI0003"},		/* Rockwell's (PORALiNK) 33600 INT PNP */
-	{"WEC1022"},		/* Winbond CIR port, should not be probed. We should keep track of it to prevent the legacy serial driver from probing it */
+	{ .id = "AAC000F" },	/* Archtek America Corp. Archtek SmartLink Modem 3334BT Plug & Play */
+	{ .id = "ADC0001" },	/* Anchor Datacomm BV. SXPro 144 External Data Fax Modem Plug & Play */
+	{ .id = "ADC0002" },	/* SXPro 288 External Data Fax Modem Plug & Play */
+	{ .id = "AEI0250" },	/* PROLiNK 1456VH ISA PnP K56flex Fax Modem */
+	{ .id = "AEI1240" },	/* Actiontec ISA PNP 56K X2 Fax Modem */
+	{ .id = "AKY1021" },	/* Rockwell 56K ACF II Fax+Data+Voice Modem */
+	{ .id = "ALI5123" },	/* ALi Fast Infrared Controller */
+	{ .id = "AZT4001" },	/* AZT3005 PnP SOUND DEVICE */
+	{ .id = "BDP3336" },	/* Best Data Products Inc. Smart One 336F PnP Modem */
+	{ .id = "BRI0A49" },	/* Boca Complete Ofc Communicator 14.4 Data-FAX */
+	{ .id = "BRI1400" },	/* Boca Research 33,600 ACF Modem */
+	{ .id = "BRI3400" },	/* Boca 33.6 Kbps Internal FD34FSVD */
+	{ .id = "CPI4050" },	/* Computer Peripherals Inc. EuroViVa CommCenter-33.6 SP PnP */
+	{ .id = "CTL3001" },	/* Creative Labs Phone Blaster 28.8 DSVD PnP Voice */
+	{ .id = "CTL3011" },	/* Creative Labs Modem Blaster 28.8 DSVD PnP Voice */
+	{ .id = "DAV0336" },	/* Davicom ISA 33.6K Modem */
+	{ .id = "DMB1032" },	/* Creative Modem Blaster Flash56 DI5601-1 */
+	{ .id = "DMB2001" },	/* Creative Modem Blaster V.90 DI5660 */
+	{ .id = "ETT0002" },	/* E-Tech CyberBULLET PC56RVP */
+	{ .id = "FUJ0202" },	/* Fujitsu 33600 PnP-I2 R Plug & Play */
+	{ .id = "FUJ0205" },	/* Fujitsu FMV-FX431 Plug & Play */
+	{ .id = "FUJ0206" },	/* Fujitsu 33600 PnP-I4 R Plug & Play */
+	{ .id = "FUJ0209" },	/* Fujitsu Fax Voice 33600 PNP-I5 R Plug & Play */
+	{ .id = "GVC000F" },	/* Archtek SmartLink Modem 3334BT Plug & Play */
+	{ .id = "GVC0303" },	/* Archtek SmartLink Modem 3334BRV 33.6K Data Fax Voice */
+	{ .id = "HAY0001" },	/* Hayes Optima 288 V.34-V.FC + FAX + Voice Plug & Play */
+	{ .id = "HAY000C" },	/* Hayes Optima 336 V.34 + FAX + Voice PnP */
+	{ .id = "HAY000D" },	/* Hayes Optima 336B V.34 + FAX + Voice PnP */
+	{ .id = "HAY5670" },	/* Hayes Accura 56K Ext Fax Modem PnP */
+	{ .id = "HAY5674" },	/* Hayes Accura 56K Ext Fax Modem PnP */
+	{ .id = "HAY5675" },	/* Hayes Accura 56K Fax Modem PnP */
+	{ .id = "HAYF000" },	/* Hayes 288, V.34 + FAX */
+	{ .id = "HAYF001" },	/* Hayes Optima 288 V.34 + FAX + Voice, Plug & Play */
+	{ .id = "IBM0033" },	/* IBM Thinkpad 701 Internal Modem Voice */
+	{ .id = "PNP4972" },	/* Intermec CV60 touchscreen port */
+	{ .id = "IXDC801" },	/* Intertex 28k8 33k6 Voice EXT PnP */
+	{ .id = "IXDC901" },	/* Intertex 33k6 56k Voice EXT PnP */
+	{ .id = "IXDD801" },	/* Intertex 28k8 33k6 Voice SP EXT PnP */
+	{ .id = "IXDD901" },	/* Intertex 33k6 56k Voice SP EXT PnP */
+	{ .id = "IXDF401" },	/* Intertex 28k8 33k6 Voice SP INT PnP */
+	{ .id = "IXDF801" },	/* Intertex 28k8 33k6 Voice SP EXT PnP */
+	{ .id = "IXDF901" },	/* Intertex 33k6 56k Voice SP EXT PnP */
+	{ .id = "KOR4522" },	/* KORTEX 28800 Externe PnP */
+	{ .id = "KORF661" },	/* KXPro 33.6 Vocal ASVD PnP */
+	{ .id = "LAS4040" },	/* LASAT Internet 33600 PnP */
+	{ .id = "LAS4540" },	/* Lasat Safire 560 PnP */
+	{ .id = "LAS5440" },	/* Lasat Safire 336  PnP */
+	{ .id = "MNP0281" },	/* Microcom TravelPorte FAST V.34 Plug & Play */
+	{ .id = "MNP0336" },	/* Microcom DeskPorte V.34 FAST or FAST+ Plug & Play */
+	{ .id = "MNP0339" },	/* Microcom DeskPorte FAST EP 28.8 Plug & Play */
+	{ .id = "MNP0342" },	/* Microcom DeskPorte 28.8P Plug & Play */
+	{ .id = "MNP0500" },	/* Microcom DeskPorte FAST ES 28.8 Plug & Play */
+	{ .id = "MNP0501" },	/* Microcom DeskPorte FAST ES 28.8 Plug & Play */
+	{ .id = "MNP0502" },	/* Microcom DeskPorte 28.8S Internal Plug & Play */
+	{ .id = "MOT1105" },	/* Motorola BitSURFR Plug & Play */
+	{ .id = "MOT1111" },	/* Motorola TA210 Plug & Play */
+	{ .id = "MOT1114" },	/* Motorola HMTA 200 (ISDN) Plug & Play */
+	{ .id = "MOT1115" },	/* Motorola BitSURFR Plug & Play */
+	{ .id = "MOT1190" },	/* Motorola Lifestyle 28.8 Internal */
+	{ .id = "MOT1501" },	/* Motorola V.3400 Plug & Play */
+	{ .id = "MOT1502" },	/* Motorola Lifestyle 28.8 V.34 Plug & Play */
+	{ .id = "MOT1505" },	/* Motorola Power 28.8 V.34 Plug & Play */
+	{ .id = "MOT1509" },	/* Motorola ModemSURFR External 28.8 Plug & Play */
+	{ .id = "MOT150A" },	/* Motorola Premier 33.6 Desktop Plug & Play */
+	{ .id = "MOT150F" },	/* Motorola VoiceSURFR 56K External PnP */
+	{ .id = "MOT1510" },	/* Motorola ModemSURFR 56K External PnP */
+	{ .id = "MOT1550" },	/* Motorola ModemSURFR 56K Internal PnP */
+	{ .id = "MOT1560" },	/* Motorola ModemSURFR Internal 28.8 Plug & Play */
+	{ .id = "MOT1580" },	/* Motorola Premier 33.6 Internal Plug & Play */
+	{ .id = "MOT15B0" },	/* Motorola OnlineSURFR 28.8 Internal Plug & Play */
+	{ .id = "MOT15F0" },	/* Motorola VoiceSURFR 56K Internal PnP */
+	{ .id = "MVX00A1" },	/*  Deskline K56 Phone System PnP */
+	{ .id = "MVX00F2" },	/* PC Rider K56 Phone System PnP */
+	{ .id = "nEC8241" },	/* NEC 98NOTE SPEAKER PHONE FAX MODEM(33600bps) */
+	{ .id = "PMC2430" },	/* Pace 56 Voice Internal Plug & Play Modem */
+	{ .id = "PNP0500" },	/* Generic standard PC COM port     */
+	{ .id = "PNP0501" },	/* Generic 16550A-compatible COM port */
+	{ .id = "PNPC000" },	/* Compaq 14400 Modem */
+	{ .id = "PNPC001" },	/* Compaq 2400/9600 Modem */
+	{ .id = "PNPC031" },	/* Dial-Up Networking Serial Cable between 2 PCs */
+	{ .id = "PNPC032" },	/* Dial-Up Networking Parallel Cable between 2 PCs */
+	{ .id = "PNPC100" },	/* Standard 9600 bps Modem */
+	{ .id = "PNPC101" },	/* Standard 14400 bps Modem */
+	{ .id = "PNPC102" },	/*  Standard 28800 bps Modem */
+	{ .id = "PNPC103" },	/*  Standard Modem */
+	{ .id = "PNPC104" },	/*  Standard 9600 bps Modem */
+	{ .id = "PNPC105" },	/*  Standard 14400 bps Modem */
+	{ .id = "PNPC106" },	/*  Standard 28800 bps Modem */
+	{ .id = "PNPC107" },	/*  Standard Modem */
+	{ .id = "PNPC108" },	/* Standard 9600 bps Modem */
+	{ .id = "PNPC109" },	/* Standard 14400 bps Modem */
+	{ .id = "PNPC10A" },	/* Standard 28800 bps Modem */
+	{ .id = "PNPC10B" },	/* Standard Modem */
+	{ .id = "PNPC10C" },	/* Standard 9600 bps Modem */
+	{ .id = "PNPC10D" },	/* Standard 14400 bps Modem */
+	{ .id = "PNPC10E" },	/* Standard 28800 bps Modem */
+	{ .id = "PNPC10F" },	/* Standard Modem */
+	{ .id = "PNP2000" },	/* Standard PCMCIA Card Modem */
+	{ .id = "ROK0030" },	/* Rockwell 33.6 DPF Internal PnP, Modular Technology 33.6 Internal PnP */
+	{ .id = "ROK0100" },	/* KORTEX 14400 Externe PnP */
+	{ .id = "ROK4120" },	/* Rockwell 28.8 */
+	{ .id = "ROK4920" },	/* Viking 28.8 INTERNAL Fax+Data+Voice PnP */
+	{ .id = "RSS00A0" },	/* Rockwell 33.6 DPF External PnP, BT Prologue 33.6 External PnP, Modular Technology 33.6 External PnP */
+	{ .id = "RSS0262" },	/* Viking 56K FAX INT */
+	{ .id = "RSS0250" },	/* K56 par,VV,Voice,Speakphone,AudioSpan,PnP */
+	{ .id = "SUP1310" },	/* SupraExpress 28.8 Data/Fax PnP modem */
+	{ .id = "SUP1381" },	/* SupraExpress 336i PnP Voice Modem */
+	{ .id = "SUP1421" },	/* SupraExpress 33.6 Data/Fax PnP modem */
+	{ .id = "SUP1590" },	/* SupraExpress 33.6 Data/Fax PnP modem */
+	{ .id = "SUP1620" },	/* SupraExpress 336i Sp ASVD */
+	{ .id = "SUP1760" },	/* SupraExpress 33.6 Data/Fax PnP modem */
+	{ .id = "SUP2171" },	/* SupraExpress 56i Sp Intl */
+	{ .id = "TEX0011" },	/* Phoebe Micro 33.6 Data Fax 1433VQH Plug & Play */
+	{ .id = "UAC000F" },	/* Archtek SmartLink Modem 3334BT Plug & Play */
+	{ .id = "USR0000" },	/* 3Com Corp. Gateway Telepath IIvi 33.6 */
+	{ .id = "USR0002" },	/* U.S. Robotics Sporster 33.6K Fax INT PnP */
+	{ .id = "USR0004" },	/*  Sportster Vi 14.4 PnP FAX Voicemail */
+	{ .id = "USR0006" },	/* U.S. Robotics 33.6K Voice INT PnP */
+	{ .id = "USR0007" },	/* U.S. Robotics 33.6K Voice EXT PnP */
+	{ .id = "USR0009" },	/* U.S. Robotics Courier V.Everything INT PnP */
+	{ .id = "USR2002" },	/* U.S. Robotics 33.6K Voice INT PnP */
+	{ .id = "USR2070" },	/* U.S. Robotics 56K Voice INT PnP */
+	{ .id = "USR2080" },	/* U.S. Robotics 56K Voice EXT PnP */
+	{ .id = "USR3031" },	/* U.S. Robotics 56K FAX INT */
+	{ .id = "USR3050" },	/* U.S. Robotics 56K FAX INT */
+	{ .id = "USR3070" },	/* U.S. Robotics 56K Voice INT PnP */
+	{ .id = "USR3080" },	/* U.S. Robotics 56K Voice EXT PnP */
+	{ .id = "USR3090" },	/* U.S. Robotics 56K Voice INT PnP */
+	{ .id = "USR9100" },	/* U.S. Robotics 56K Message  */
+	{ .id = "USR9160" },	/* U.S. Robotics 56K FAX EXT PnP */
+	{ .id = "USR9170" },	/* U.S. Robotics 56K FAX INT PnP */
+	{ .id = "USR9180" },	/* U.S. Robotics 56K Voice EXT PnP */
+	{ .id = "USR9190" },	/* U.S. Robotics 56K Voice INT PnP */
+	{ .id = "WACFXXX" },	/* Wacom tablets */
+	{ .id = "FPI2002" },	/* Compaq touchscreen */
+	{ .id = "FUJ02B2" },	/* Fujitsu Stylistic touchscreens */
+	{ .id = "FUJ02B3" },
+	{ .id = "FUJ02B4" },	/* Fujitsu Stylistic LT touchscreens */
+	{ .id = "FUJ02B6" },	/* Passive Fujitsu Stylistic touchscreens */
+	{ .id = "FUJ02B7" },
+	{ .id = "FUJ02B8" },
+	{ .id = "FUJ02B9" },
+	{ .id = "FUJ02BC" },
+	{ .id = "FUJ02E5" },	/* Fujitsu Wacom Tablet PC device */
+	{ .id = "FUJ02E6" },	/* Fujitsu P-series tablet PC device */
+	{ .id = "FUJ02E7" },	/* Fujitsu Wacom 2FGT Tablet PC device */
+	{ .id = "FUJ02E9" },	/* Fujitsu Wacom 1FGT Tablet PC device */
+	{ .id = "LTS0001" },	/* LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in disguise) */
+	{ .id = "WCI0003" },	/* Rockwell's (PORALiNK) 33600 INT PNP */
+	{ .id = "WEC1022" },	/* Winbond CIR port, should not be probed. We should keep track of it to prevent the legacy serial driver from probing it */
 	/* scl200wdt */
-	{"NSC0800"},		/* National Semiconductor PC87307/PC97307 watchdog component */
+	{ .id = "NSC0800" },	/* National Semiconductor PC87307/PC97307 watchdog component */
 	/* mpu401 */
-	{"PNPb006"},
+	{ .id = "PNPb006" },
 	/* cs423x-pnpbios */
-	{"CSC0100"},
-	{"CSC0103"},
-	{"CSC0110"},
-	{"CSC0000"},
-	{"GIM0100"},		/* Guillemot Turtlebeach something appears to be cs4232 compatible */
+	{ .id = "CSC0100" },
+	{ .id = "CSC0103" },
+	{ .id = "CSC0110" },
+	{ .id = "CSC0000" },
+	{ .id = "GIM0100" },	/* Guillemot Turtlebeach something appears to be cs4232 compatible */
 	/* es18xx-pnpbios */
-	{"ESS1869"},
-	{"ESS1879"},
+	{ .id = "ESS1869" },
+	{ .id = "ESS1879" },
 	/* snd-opl3sa2-pnpbios */
-	{"YMH0021"},
-	{"NMX2210"},		/* Gateway Solo 2500 */
-	{""},
+	{ .id = "YMH0021" },
+	{ .id = "NMX2210" },	/* Gateway Solo 2500 */
+	{ }
 };
 
 static bool matching_id(const char *idstr, const char *list_id)
diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 00775b91bd41..4f206681070e 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -630,10 +630,8 @@ void __init acpi_early_processor_control_setup(void)
  * processor devices.
  */
 static const struct acpi_device_id processor_device_ids[] = {
-
-	{ ACPI_PROCESSOR_OBJECT_HID, },
-	{ ACPI_PROCESSOR_DEVICE_HID, },
-
+	{ .id = ACPI_PROCESSOR_OBJECT_HID },
+	{ .id = ACPI_PROCESSOR_DEVICE_HID },
 	{ }
 };
 
@@ -655,7 +653,7 @@ static int acpi_processor_container_attach(struct acpi_device *dev,
 }
 
 static const struct acpi_device_id processor_container_ids[] = {
-	{ ACPI_PROCESSOR_CONTAINER_HID, },
+	{ .id = ACPI_PROCESSOR_CONTAINER_HID },
 	{ }
 };
 
diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index f93e877f87f6..c10f07ac8d61 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -92,7 +92,7 @@ enum acpi_video_level_idx {
 
 static const struct auxiliary_device_id video_bus_auxiliary_id_table[] = {
 	{ .name = "acpi.video_bus" },
-	{},
+	{ }
 };
 MODULE_DEVICE_TABLE(auxiliary, video_bus_auxiliary_id_table);
 
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 3836ee75dd66..4b3b2dbf0d27 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -60,12 +60,12 @@ MODULE_DESCRIPTION("ACPI Button Driver");
 MODULE_LICENSE("GPL");
 
 static const struct acpi_device_id button_device_ids[] = {
-	{ACPI_BUTTON_HID_LID, ACPI_BUTTON_TYPE_LID},
-	{ACPI_BUTTON_HID_SLEEP, ACPI_BUTTON_TYPE_SLEEP},
-	{ACPI_BUTTON_HID_SLEEPF, ACPI_BUTTON_TYPE_SLEEP},
-	{ACPI_BUTTON_HID_POWER, ACPI_BUTTON_TYPE_POWER},
-	{ACPI_BUTTON_HID_POWERF, ACPI_BUTTON_TYPE_POWER},
-	{"", 0},
+	{ .id = ACPI_BUTTON_HID_LID,	.driver_data = ACPI_BUTTON_TYPE_LID },
+	{ .id = ACPI_BUTTON_HID_SLEEP,	.driver_data = ACPI_BUTTON_TYPE_SLEEP },
+	{ .id = ACPI_BUTTON_HID_SLEEPF,	.driver_data = ACPI_BUTTON_TYPE_SLEEP },
+	{ .id = ACPI_BUTTON_HID_POWER,	.driver_data = ACPI_BUTTON_TYPE_POWER },
+	{ .id = ACPI_BUTTON_HID_POWERF,	.driver_data = ACPI_BUTTON_TYPE_POWER },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, button_device_ids);
 
diff --git a/drivers/acpi/evged.c b/drivers/acpi/evged.c
index 5c35cbc7f6ff..c7a00dc62247 100644
--- a/drivers/acpi/evged.c
+++ b/drivers/acpi/evged.c
@@ -179,8 +179,8 @@ static void ged_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id ged_acpi_ids[] = {
-	{"ACPI0013"},
-	{},
+	{ .id = "ACPI0013" },
+	{ }
 };
 
 static struct platform_driver ged_driver = {
diff --git a/drivers/acpi/fan_core.c b/drivers/acpi/fan_core.c
index fb08b8549ed7..5f42cb487206 100644
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -46,7 +46,7 @@ MODULE_PARM_DESC(min_trip_distance, "Minimum distance between fan speed trip poi
 
 static const struct acpi_device_id fan_device_ids[] = {
 	ACPI_FAN_DEVICE_IDS,
-	{"", 0},
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, fan_device_ids);
 
diff --git a/drivers/acpi/pfr_telemetry.c b/drivers/acpi/pfr_telemetry.c
index 2387376832a1..ea6db4be4deb 100644
--- a/drivers/acpi/pfr_telemetry.c
+++ b/drivers/acpi/pfr_telemetry.c
@@ -415,8 +415,8 @@ static int acpi_pfrt_log_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id acpi_pfrt_log_ids[] = {
-	{"INTC1081"},
-	{}
+	{ .id = "INTC1081" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_pfrt_log_ids);
 
diff --git a/drivers/acpi/pfr_update.c b/drivers/acpi/pfr_update.c
index 6283105bb0e8..80bef3af35c5 100644
--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -591,8 +591,8 @@ static int acpi_pfru_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id acpi_pfru_ids[] = {
-	{"INTC1080"},
-	{}
+	{ .id = "INTC1080" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_pfru_ids);
 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 9a7ac2eb9ce0..e92473bcd586 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1005,9 +1005,9 @@ static int acpi_bus_extract_wakeup_device_power_package(struct acpi_device *dev)
 static bool acpi_wakeup_gpe_init(struct acpi_device *device)
 {
 	static const struct acpi_device_id button_device_ids[] = {
-		{"PNP0C0D", 0},	/* Lid */
-		{"PNP0C0E", 0},	/* Sleep button */
-		{"", 0},
+		{ .id = "PNP0C0D" },	/* Lid */
+		{ .id = "PNP0C0E" },	/* Sleep button */
+		{ }
 	};
 	struct acpi_device_wakeup *wakeup = &device->wakeup;
 	const struct acpi_device_id *match;
@@ -1731,8 +1731,8 @@ static bool acpi_is_indirect_io_slave(struct acpi_device *device)
 {
 	struct acpi_device *parent = acpi_dev_parent(device);
 	static const struct acpi_device_id indirect_io_hosts[] = {
-		{"HISI0191", 0},
-		{}
+		{ .id = "HISI0191" },
+		{ }
 	};
 
 	return parent && !acpi_match_device_ids(parent, indirect_io_hosts);
@@ -1752,33 +1752,33 @@ static bool acpi_device_enumeration_by_parent(struct acpi_device *device)
 	 * by the drivers/platform/x86/serial-multi-instantiate.c driver, which
 	 * knows which client device id to use for each resource.
 	 */
-		{"BSG1160", },
-		{"BSG2150", },
-		{"CSC3551", },
-		{"CSC3554", },
-		{"CSC3556", },
-		{"CSC3557", },
-		{"INT33FE", },
-		{"INT3515", },
-		{"TXNW2781", },
+		{ .id = "BSG1160" },
+		{ .id = "BSG2150" },
+		{ .id = "CSC3551" },
+		{ .id = "CSC3554" },
+		{ .id = "CSC3556" },
+		{ .id = "CSC3557" },
+		{ .id = "INT33FE" },
+		{ .id = "INT3515" },
+		{ .id = "TXNW2781" },
 		/* Non-conforming _HID for Cirrus Logic already released */
-		{"CLSA0100", },
-		{"CLSA0101", },
+		{ .id = "CLSA0100" },
+		{ .id = "CLSA0101" },
 	/*
 	 * Some ACPI devs contain SerialBus resources even though they are not
 	 * attached to a serial bus at all.
 	 */
-		{ACPI_VIDEO_HID, },
-		{"MSHW0028", },
+		{ .id = ACPI_VIDEO_HID },
+		{ .id = "MSHW0028" },
 	/*
 	 * HIDs of device with an UartSerialBusV2 resource for which userspace
 	 * expects a regular tty cdev to be created (instead of the in kernel
 	 * serdev) and which have a kernel driver which expects a platform_dev
 	 * such as the rfkill-gpio driver.
 	 */
-		{"BCM4752", },
-		{"LNV4752", },
-		{}
+		{ .id = "BCM4752", },
+		{ .id = "LNV4752", },
+		{ }
 	};
 
 	if (acpi_is_indirect_io_slave(device))
@@ -2284,8 +2284,8 @@ static void acpi_default_enumeration(struct acpi_device *device)
 }
 
 static const struct acpi_device_id generic_device_ids[] = {
-	{ACPI_DT_NAMESPACE_HID, },
-	{"", },
+	{ .id = ACPI_DT_NAMESPACE_HID },
+	{ }
 };
 
 static int acpi_generic_device_attach(struct acpi_device *adev,

-- 
2.43.0

