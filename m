Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FF4408606
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154269; cv=none; b=Vy5tptQ+z97laYr2tvoUqXwFx+xoABQMWxVEdTruMPHHes8cNbe0dMBh7HnyTEbuJDAEyKg8KFqcP7tdRhO3QSTRft45KZijMsQGj4+lL/MXi+qQ1g3XdUFGS17lykXzamcxN6Mu/mlN2D5O+LhZ1AcB3cJB7wMeEnUiBYGeSek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154269; c=relaxed/simple;
	bh=f5yWEycCLmhwNgNs+7yltFCigM8U2L0qmiC75nRPZPg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g/odQylw9IKO27BhLDnvl5GmG5D82g7EDuIoEjcAiSTlNPt1JMv0zCmE2ANwZ851K8/D7LnJH1r5x6LzDaI1XMXDokVeszU1MKvlX00erfkDUsedAg8qpffuJEixNLdtI6yflpztmu/ABnbARXwypUNQ8rUeG/g8/Carc1kkqxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=RfvbKVVO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="RfvbKVVO"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so12583755e9.2
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154266; x=1785759066; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yngGEtXt8XdvhkSci47p7H95S2e1zfXfAmsSjMJsNNY=;
        b=RfvbKVVOIPRm6HsWouH35ls0XKRZ31gxUqS21o2PqUEOh26P0/bYPLJHs8rCJVWHEQ
         J7/myeuEAAG2+lnJiy/77HB2iIubg6//cR9EaiJy7P1YkrA7JeKH9fxIB2YG5CkSqM9x
         ITt39HWa2sCTyzsK9uV9/hyVNgKxXRB9bTziu5Xc4aVs43TJ+Rj5KiWo6wjlb6TxJJRe
         nw53b8RI01wIESUjSLnK/JS+B6AD/o/qIUgUSIbo9CzAw/DbBfOgOes4s/YEt/ZPF0Ry
         ruuk8b2xIt8QyQLwSsLko0VjLlBtR91zbqe4yMhb1RHlQVvXDmGnGX3FHZzs0A/Y5kRa
         oTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154266; x=1785759066;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yngGEtXt8XdvhkSci47p7H95S2e1zfXfAmsSjMJsNNY=;
        b=LtUBPLVxM2D1kyuJT/kHzzgz9kHCqew5EaPCyJKrdu/67nQO2pjQM4rvHkOvTYmQF9
         BP1DiAEqiOGGBpYVmExxtg2t1W41/sj2H4Vqan25ax/usHiGNDc+YuqeAYZIMNRUEkWa
         unPEgrcuTTdegNb0U8bsn+6U6Eb7mKWHXud/eGqHGcz8Z904DycO4Ldx5iN99OpQ7W8a
         Vl8sfLMh4xctxANgzEyXhH9mVzQeYvYYfIx9q3fM4P7mHxNWaOhCAR/yaXNxGR4HmiCu
         VQlO70pmLjEJ2T9JuNSjPQcBlEhRIEtsj+yrLcgAnapu9Pb6knLrNtm1Wz/HURF2e549
         tw9w==
X-Forwarded-Encrypted: i=1; AHgh+RplvZhiliSiHQTbAOuf/pSx3n0b+qh0XjMk2u9udQdVt0YMTXLLuh8immU3pXMjrFT1FH8FsY4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6uypw4e10YdvjfMFrnlQA60Cdjhm+i8qrN/uyA3Q5eP4GtYmr
	k1tBm4Xog9iGwYDO87oQuCzirXlsyZk9T8NNdaRENVARz9G06hBGFhsCTDv6l6iL0WM=
X-Gm-Gg: AR+sD13RB3eIPJak4+vcHUgkisgQ9WmZn2KFzqpdmQYaJrq2urXYZvIv+C3zsDs1VSd
	W2nQxKNyQDDkQGyEIGkkDMBKPPUiD45eg2NvaAm/u34gopMDaF5yBKjNdk7qaGDoKW99Iwo0g7Y
	h/PWnpaJwugk/JCI8hR7T2rLlQqs3LHLvxPeXFblbOiNn4FJ4Oz+Io4OnZI9191pQftQgNS4FBb
	U7kaSev4d1+Ysjf5ho+3I7W8+3yD+UatnRKM6b3aIoKnY2tyDqDCLVHxYu4VHu/6ASYvUFP2ME0
	cQJB3bl0/TU9VghPPdVNitMFTWMPI1znJj3OnTqsmR5OemNBTkPL8cynDeh7Nx8cGJrMOyEgPl+
	tEtvzESAujz2s+cwkKq/NPPSYaMIvSVyiTTBZhfgdLQ6h1ef3RGW6ITvdafWjFoi6aR8eQBGG8c
	T9CgJ4GlurLBY7SVHMEBA=
X-Received: by 2002:a05:600c:5492:b0:495:7eab:3abd with SMTP id 5b1f17b1804b1-496b5736f4fmr117417715e9.33.1785154265733;
        Mon, 27 Jul 2026 05:11:05 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:11:05 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:45 +0100
Subject: [PATCH 7/9] ACPI: nfit: core: drop unused assignment of
 acpi_device_id::driver_data
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-7-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=993;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=f5yWEycCLmhwNgNs+7yltFCigM8U2L0qmiC75nRPZPg=;
 b=FPBuwEoNc0FwTPiW1OLmoke/+L0vL95t8jlgufvJHvdNH2cU9i9jhCZ2SIOLvvfU3dElEbK4X
 ffdwTvMsuVIB49CLJL8HnAYzDHIg3Q2vmuDwUv6QV0kEAdHSx50UKZC
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

This module sets the acpi_device_id::driver_data to 0 but
the field is not actually used within the module, we can
just drop it from the table.

While we are at it - used a named initializer for the
acpi_device_id::id field to increase readability and
drop explicitly setting the list terminator fields.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/acpi/nfit/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index cb771d9cadb2..5732df5d53f0 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3515,8 +3515,8 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
 
 static const struct acpi_device_id acpi_nfit_ids[] = {
-	{ "ACPI0012", 0 },
-	{ "", 0 },
+	{ .id = "ACPI0012" },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
 

-- 
2.43.0

