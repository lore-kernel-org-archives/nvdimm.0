Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C941A3FF8A4
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154263; cv=none; b=ALS54JnuBwO09qdUAHT7T+kvR3K2BHSf7bAKyso1v/Qc13DS0/wiDWjIYEKhlV8g0RkkkCyNMm/hWhlfHK4MeI8ZMxOM3zIRM4VP77+Vm4UaV6CVEjU3WfTdPho8L3QVnc6x+ojNW5lkuczuXJpGBRxXYicD+awAb3qTnGAaPxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154263; c=relaxed/simple;
	bh=P0xjQiLQXAgoqUkWLKYp5IthAsIDgkug16mJm0ZMeDg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZSDJ1D7l50TlAWccuGJPGJ4VF5NCK4rVN6sapoqyegO9kZjiICF/5/frsaRHKy3wEDMTT0S66sCmUmuNAgP5JfJxU1mLGobTvhvL0VVpaVQzH3MPrh7hlReSN5hu6bXZNJJJvTOEkj0QTtpQRlc15d2kTibucuCg9iWsnyTbI24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=F3wUer2k; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="F3wUer2k"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49557167508so25964265e9.1
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154259; x=1785759059; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDrB+Cex1z4J7gYLaCt9VWCfPXHJCTTUZUhkbLnsi7U=;
        b=F3wUer2k/SnFLGOU+RXQqlJA2ygGPj8XEWHEefoRgwOgqaWZLrXHFUxK99UW0A3b+I
         MBXDIGa2DMpgG0Ft19BXacNWW2fisAXNjmZIEXGdflfWO2ps3H5AdL2/CCEJaAGW+myy
         rgZCI56M6x8YbE4pyF7U0uQPBFd57Q80J/Iv2WbeHJHdJVxQjRapyuLhRVGXzqOVFc1r
         rVhO1MnlPmjnzuO4qP+2b0R1gRYtsrO2pTxbCMmZNPhgnV0M3WNgy/l2/rnO+0ssCbl4
         DysDYTyQep8iIRB2abbUEYPzeEhgGMOYKbifmpOaFkhgh9NTqItvSkd8NjctVLKXlj09
         5lZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154259; x=1785759059;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDrB+Cex1z4J7gYLaCt9VWCfPXHJCTTUZUhkbLnsi7U=;
        b=gtDwiJkG8XuADsjs8t9ild4x51DDLk3NE6jYlkY2JlPYND+5aFGvEJLlHYeJ8/SUJB
         Tw3uNGCZYW9jdu9UulYhC2acmD4D99fme22JMidhOb3l9cBs7qTPo3wROmmGno8twhWg
         fOpuFsxRfBGx6l3h03p6H/BzHO3kFkpZPJQYHOlfybZbfGM885+3QPfeuA4qDvi+HCes
         +vt6MqGtF0xrd8UdIPK/lA8muGvkNlf3WsCV5Ath+Wq2wTT9rK7NveoFYqzGgfqnIhC3
         W09vF3Ntjyk/XwX1jroI7BWWS73uZt97ChUkOC875XrmjtnxzC2DzY0HydTv3aDPKgCv
         lLMw==
X-Forwarded-Encrypted: i=1; AHgh+Rp7iR/cfAvZ4Iuo/j+aPTiikhMI2D9EnI3t51rksb0EPiSmbQvSq0xPUMzvoFg0KKaZ2vTcZiU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxefObF2ROU4ZvzeI11WTTebJAcrPaJqnvRLwTdJ7g4ZW0Jv2BU
	5QLdUX7bsRyyQnPHUT+ZYvkzZi/vdqSWpfWGo6PV+GFgaTB54XeyvJRn+Wbd6NBYFQw=
X-Gm-Gg: AR+sD11KQP3M+9H3+gxUvwSud410KHSoBtUCjhTdiUuTSSP/Z1xbS6bvynZroLIyjFc
	66i3golSFeu1oPMESeoiywRlQoWxbQ38bZz/WvdmXIyR2tG+4saKzICJ81umdpttrYRnNxaopbO
	K07X8cbq7F+d9NdHG7iMuJb6W8zFucStu1L1N53rQJjJlWoWgbQS6TXqe48L+xgefhEBdNOvHlM
	czZt5Yb8YbtigCh7o5Ps6YcWoYdK0P9cuSCIEKBj/r6FXVlZ06eKl60PZ0NXnkfvMvg21jSTPHB
	ULfXt4JFVqmI6b1wFjjDY0i/tCdNcSstI938DsYZ8kD/0cOxEuY6m/sIGov2UiEX9UqRgFyJx+5
	YgmFa9VPVyQ+t0okrj/yR+fuhbaPKkf46WC976afoYWz5Wf8b81MJ1jTr64Au4501KxPbHz8ram
	gYwoElwBTS/kmQ8/9Jf5Q=
X-Received: by 2002:a05:600c:8b4c:b0:495:67b8:d97e with SMTP id 5b1f17b1804b1-496b57081c7mr107464815e9.30.1785154258767;
        Mon, 27 Jul 2026 05:10:58 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:10:58 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:41 +0100
Subject: [PATCH 3/9] ACPI: pci: drop unused assignment of
 acpi_device_id::driver_data
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-3-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=1501;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=P0xjQiLQXAgoqUkWLKYp5IthAsIDgkug16mJm0ZMeDg=;
 b=PNFz3+JEcuHTQLycUVytg5ZW5oWUuiIlRW2Ta2z8sj1QeOuxPAHaLQUtnCCOg9lGVoNYFi7nQ
 NZeOOGrRDxRBKbRpZ1rCkozuEsM743rRRDZUOoTKiqtbhh9ZdcPagk0
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
 drivers/acpi/pci_link.c | 4 ++--
 drivers/acpi/pci_root.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index e6ed13aee48d..276dd36aaf23 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -36,8 +36,8 @@ static int acpi_pci_link_add(struct acpi_device *device,
 static void acpi_pci_link_remove(struct acpi_device *device);
 
 static const struct acpi_device_id link_device_ids[] = {
-	{"PNP0C0F", 0},
-	{"", 0},
+	{ .id = "PNP0C0F" },
+	{ }
 };
 
 static struct acpi_scan_handler pci_link_handler = {
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 4c06c3ffd0cb..a129cb0c0a36 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -40,8 +40,8 @@ static int acpi_pci_root_scan_dependent(struct acpi_device *adev)
 				| OSC_PCI_MSI_SUPPORT)
 
 static const struct acpi_device_id root_device_ids[] = {
-	{"PNP0A03", 0},
-	{"", 0},
+	{ .id = "PNP0A03" },
+	{ }
 };
 
 static struct acpi_scan_handler pci_root_handler = {

-- 
2.43.0

