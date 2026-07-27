Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5983FF8A4
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154266; cv=none; b=W+QHKjGH3T3m2Ufx5Ud3U84rYhdgNvQdGQBiYPUeeoordTbAgZ2TLL+XVyGff3C+lWZjZOyLu8lEgq0DwwDpNZEQ2lgOepzBcYPkSjaQNHrf/+n95HoMw2n2RBLlFV6TnkHHZYJxZgyM1QP5FD62cyiq1uYsegtNK+X0sPupb5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154266; c=relaxed/simple;
	bh=Lbvh7ljIparNEO5uJ2mabx3TClqFF5XzLm3/VRCVAl8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tkcTDjx10nzUvgH6AFTMx8T8RzM5rgDjCnPQCmRx56JO7eZ0lRhVdM0C0tc96d74F8aNI3gyzG5yJKBZZaPffSLvrajkUMqp5aQ8QprFtQ+Sohr444LyuxPvzb8nvLQWmVYJ26Hwx4uaAHWDcKa6h4Z8DJKc955vw1D6H1Qn3Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=sylrRjet; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="sylrRjet"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so29353435e9.2
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154262; x=1785759062; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=34/3xpWJfuscYnym0h0qM9v01c2NqgtLDv6AlT7mmYc=;
        b=sylrRjetTteG/xcKv6YBaoC0Ds4PmchXXp6Rz95KKdjdvP/ig1u0/3hZV9s5FW2GHW
         lTYR/fvyET9QdXzGupZrBh+fN28notWnJ/vINfxKPhllLns1nZsnhVM3TVkNUN2mZXvg
         FyddCQcrKSRF2G4PhOTVM2Ct8fCb/mVvKp9YWURmGnnPvYmRaeafhlISzI4DJnUeY8O3
         tKNBByD6Rznv4Du7PePXAKDbXQEQC0U95KCxmH3AraOJsdtnsIDRSQAvxAhmgyk6AF3S
         a+eKTOFcvxC2cIalVeZ7bZG8a45TNvZshcDO/2ZWsmA84NuPrWjmEWAW+HaZ/dbEmNCq
         bNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154262; x=1785759062;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=34/3xpWJfuscYnym0h0qM9v01c2NqgtLDv6AlT7mmYc=;
        b=RfICnkwgsSpef+UHxIXt7TQrD9w6jz6VR5iuFzb6R3ffeJsPguPf1XgoYBVk2+N7CT
         yFoZCkbqBrI3Cmp5teindgjV0i50sD2s4BwAzEOVb7m9U5DqE5ZGoEAGQsMFAUZkLTid
         u/XMVi26pYCSZNum3MSyopC1VNOCne/P81Y7limz0jY/mmCUhmO7SYd8excXnUwGPq25
         024XPweMYx7l3L8S9EdybXPUI/DOaw7/luBO9Tvw70A5Fs31gH537O8/S+zdOoJ0dEsc
         a8T9iHHUeRxvCjY2b9qQgmfi1YiHTHdMUkxSpvFbrZXGGMYhYYOSA55ySZdS3UtSyvfw
         +y+A==
X-Forwarded-Encrypted: i=1; AHgh+RpWcrBwti/e/QGd5lqE+eqskLBFLY7NaUTV/fM29y+bs5/FRsuvcms9BNQAkHd3rvySSq4albU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcBZVJxg7GHjW8K+Qb/bhatVDPZs0K48Xuz+1i1ROMGD7HqWbo
	T0Tw01l7UeIdnINUnzVyPcWz1/Rlb+dxwwBWTniaNYCzlRcGLNWK/DQyz9drFFCL2RE=
X-Gm-Gg: AR+sD13pwVBsBy/nzmjZSsn/XUc9pEqca/NuNMDqqXEStB13HCiTE21eDPuk3XDPpm4
	JoZBv6Bu4WIR4gGbUCvyXmasbSi6JboAeGfgVExM5SiBv/LXxUhnANN96DoBFGpTHO4uNnFqaGX
	dP2cjdntdCNLCeKpFm8uNz2EKlSRinnMogs6pUjaxbc4/LE3qu57xH+dRWar+cPIcvuZtDNIpBn
	Y/esJpq/vkjkuMCzxTgPJ3dLH4dSbQntaBcoVSmnUHjwr4uWHZXpMH0AslbBvNLLFxAqOnc+XnH
	XD/WaBsvgjjMQ0pK0xym3Bx1NEbf2kNKJVguUb5bNZ/K6PlHtS2ntatyv9wdw1pPm8enk3ZEIkQ
	5yh+shSa7/gfZcP+eapMbbT1rlibxdvJZeD4GvP+Jcgm1nlNJG3Zt5Rk8UKir9MqqmZ6kc4nlkw
	a1EVmeaJE1SkpaWWUADx2qmg64yo3WdrhEOTJpBkGuA/bD2gD3EjoOit5jju0qzYKG2pRCQCyEi
	jt2RBh8SKLTo890
X-Received: by 2002:a05:600c:3ba0:b0:496:bba5:33a9 with SMTP id 5b1f17b1804b1-496bba535fdmr82232185e9.34.1785154262149;
        Mon, 27 Jul 2026 05:11:02 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:11:01 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:43 +0100
Subject: [PATCH 5/9] ACPI: amba: drop unused assignment of
 acpi_device_id::driver_data
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-5-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=1054;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=Lbvh7ljIparNEO5uJ2mabx3TClqFF5XzLm3/VRCVAl8=;
 b=judU8sVVfRgrI+5ADeNtDthotqk9x8BTWf+Syrfpzb+YAyTvlO80HNFr3Ji8L5bsisVb/rkxu
 cQqASkV+g7XBfSqQvy8iMLH8daT2jimlaAqGe1JXLVIWuI6rYuSAZe+
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
 drivers/acpi/arm64/amba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/arm64/amba.c b/drivers/acpi/arm64/amba.c
index 1350083bce5f..e32b37a2126d 100644
--- a/drivers/acpi/arm64/amba.c
+++ b/drivers/acpi/arm64/amba.c
@@ -20,9 +20,9 @@
 #include "init.h"
 
 static const struct acpi_device_id amba_id_list[] = {
-	{"ARMH0061", 0}, /* PL061 GPIO Device */
-	{"ARMH0330", 0}, /* ARM DMA Controller DMA-330 */
-	{"", 0},
+	{ .id = "ARMH0061" }, /* PL061 GPIO Device */
+	{ .id = "ARMH0330" }, /* ARM DMA Controller DMA-330 */
+	{ }
 };
 
 static void amba_register_dummy_clk(void)

-- 
2.43.0

