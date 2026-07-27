Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851343FE347
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154268; cv=none; b=o2jtUv5BGDPQ394fd3Hx1/8R0avGA9PPH7TmTUHWp4TkXCEnjal10Id1AicCHZRGzO4x5HD7QhfBDINEJ9fkJG+OWzAwzi/XQoEPNXiqYlr//B0aRNcqCO1c2Wn/u3pECx7YfVcjnzZz+Y6orzgBFiwAfk1WmYTthNde957Ld6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154268; c=relaxed/simple;
	bh=iy90S821r7vCDS/x2YS8oV7bzZLylqWa3kEXWERJwVk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L5dR5+4pyo/dAMcjQ0hvOr1oaey43Y9uZUK+1bnjwXMVAOk3HR/6Iav7/zDmaHcen8MrjBUUwZs2Im5O+l23AxhGsOHPyWkiumCZd52G38LJHWiZlmZNPs5mBcDLuEGpzpiMn9PGgqHPVBlXSOYgNXLQvMxtMQYzEXdA0rGykqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=VsRhn7qS; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="VsRhn7qS"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954afac04bso31110735e9.0
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154264; x=1785759064; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eP95ZPeS8Uq3g1fOmw+bjaH0iUiNCmHgM7HcfPKHBbU=;
        b=VsRhn7qS0fjGIpCQpGmD+IKfEGkUwslKaK3zxlhvtXdRm9IiwQV9R8qM1t4x5FNTqU
         LoUcRYtY2Ps4RKE6s2GDFN7S/cKXTEJ//s96XqrSb6lMs792W/i6VOKAbh5pBnpP7fql
         iUZ9Y9zZV4Mi1Oj/mRgDYfyazEVXHtysnFICqfHw5iU+r1aUyqhRafTzSItPr4LYsevi
         HC9Z0vfidl9wW0v4k98XqRc1dhRRF/Sfu390HT1akX5rV6dE0PwvuY83Q1+3Eo7qEHik
         riwytqvJAWtF/XKPjQovYBFwmKjrgkr7Vc8YqfMLH1YYDA17Ev55tvsGexrWtoPV2q62
         717A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154264; x=1785759064;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eP95ZPeS8Uq3g1fOmw+bjaH0iUiNCmHgM7HcfPKHBbU=;
        b=SHXi02oRB6s0epxxoU75XdwC5URL9TX7WLHl/FFQZkC7WMq/d23rpGseG8hZAQtjWQ
         ozg1IniersJLiCdLj+lYeV/kjZDQzAbQWF6AyDbedIft9bnLQA1zUJX4cQCSkCsyPnE9
         q2RHeucsxoyeoCgUyOBq3xThBEgCrf6rB7p2G/BfaeplFbynRrrUOwH3BKe2KaL42xc1
         uWeg2e20og1HAdY8KbQWAomg0cx8F4Hs8lvLsJXAbLPVtmH5S1NLhkNLnTknRcwhvKKI
         xjk+C6QPqRTpfSdCZyeIkpteOPGuOMzmtylXJNK+ugN4eGBLCfOmoLdLQnJYoYOOiEZm
         ngvw==
X-Forwarded-Encrypted: i=1; AHgh+RpHhiMQUDKKf22B02f58RXMjuRyZN6jrY1lO+CHn/2kcFdryb9BdXG53sP+Y9z5Rzrn8S9Vvvc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqobAJl3ONeUSpqb5L62U/aQ9nLZLR9s/L6iFU5zrcnwVbhNFP
	dHjxNeEaqvoIUrQfZUkWRRLUTOyqVjjAcVSFPfzzZNwfIfaiQRioE5VKrLXWcnjW8jg=
X-Gm-Gg: AR+sD116VuWSgKoZt29env1Xdk6M8zzjoYSj9sDR2ASp/O7qR0TC93No8T2vvwYPRHN
	4ayzghyBDU+3MuSxxxJurtlLeBPKIcwe3McHkRPWwhvCRCU0sEW/7P5JOG9/V6kQdxgQkLemOe9
	llgHMQUJOuiCuHZRJhecwhsN7aF4kxW0WQNCNeiqKM5XX0DIajluwSuxXJArgKZrnIdalWJZWUM
	swZzV/FMVgcGPROq6UCeLgwbAnr0qiHpxogCJuVtN/hk2g0WH1UW7700PVeJQDqKvKryl3Vnse3
	+SxNoCKFfTRWCbzQ5KThXYgh7XYqQK8B9JEIvAK4Lv+MyJHz3z0B2DDm0ng085AUm/KF6CPvWr3
	feCQDSNDNtPhiZIT9A3eANhwyRvpIpR1AtHbb5wtQU0Ih8qHTkel8JL8S2LaAvm3kKUcAqvr7Tq
	Hp/phQD+qTuLKbVEbIJ3U=
X-Received: by 2002:a05:600c:c16d:b0:493:f822:ac5e with SMTP id 5b1f17b1804b1-496b56f1308mr96598005e9.23.1785154264182;
        Mon, 27 Jul 2026 05:11:04 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:11:03 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:44 +0100
Subject: [PATCH 6/9] ACPI: dptf: drop unused assignment of
 acpi_device_id::driver_data
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-6-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=2541;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=iy90S821r7vCDS/x2YS8oV7bzZLylqWa3kEXWERJwVk=;
 b=xtjCUJ6GoOgZ2wQg74HHYnEspaLZYECRG9U7Vj6yWa7RCTMDKR/PPofo9LHHFL+JQcluuW2hy
 eZmvz7mleUPCfxpwOQK6HZOn8zKRUipnuMO2pGX8LYu72eHBr9MdCzM
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

These modules set the acpi_device_id::driver_data to 0 but
the field is not actually used within the module, we can
just drop it from the table.

While we are at it - used a named initializer for the
acpi_device_id::id field to increase readability and
drop explicitly setting the list terminator fields.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/acpi/dptf/dptf_pch_fivr.c | 14 +++++++-------
 drivers/acpi/dptf/dptf_power.c    | 38 +++++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/dptf/dptf_pch_fivr.c b/drivers/acpi/dptf/dptf_pch_fivr.c
index 8d7e555929d3..d23867f70b28 100644
--- a/drivers/acpi/dptf/dptf_pch_fivr.c
+++ b/drivers/acpi/dptf/dptf_pch_fivr.c
@@ -147,13 +147,13 @@ static void pch_fivr_remove(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id pch_fivr_device_ids[] = {
-	{"INTC1045", 0},
-	{"INTC1049", 0},
-	{"INTC1064", 0},
-	{"INTC106B", 0},
-	{"INTC10A3", 0},
-	{"INTC10D7", 0},
-	{"", 0},
+	{ .id = "INTC1045" },
+	{ .id = "INTC1049" },
+	{ .id = "INTC1064" },
+	{ .id = "INTC106B" },
+	{ .id = "INTC10A3" },
+	{ .id = "INTC10D7" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, pch_fivr_device_ids);
 
diff --git a/drivers/acpi/dptf/dptf_power.c b/drivers/acpi/dptf/dptf_power.c
index 55ccbb8ddbe3..065831bce8c0 100644
--- a/drivers/acpi/dptf/dptf_power.c
+++ b/drivers/acpi/dptf/dptf_power.c
@@ -224,25 +224,25 @@ static void dptf_power_remove(struct platform_device *pdev)
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
-	{"", 0},
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
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, int3407_device_ids);
 

-- 
2.43.0

