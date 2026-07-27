Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FA940A959
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154273; cv=none; b=DcCiuO5+/xO2Tm1WjMhflEHb0acxrQyBxPGgRJbfTIda/r/u/wtfeXXkygggomgXdq1DQzLwjWCDbaOeyCzUm114gMIG6oxxFOKb0NDZqCyo2c5Va4lK7VIIcqWEgwTdix7J2tq4jaqbFxDCymLJ0X67UggJ+c03hfUYQnUW2QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154273; c=relaxed/simple;
	bh=e3kFwrE54qrR7j9hf08X7x7yaGkc04oEEErLkv2k6T8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JyKTGTek7Qp6T7SxqWlyOTAyvaQyOOtBxZWhcguYUJyzENm2GwhYtXU3iN2IaRG0szbZZ27quh6gLEN+o+WSq8joauVpAuXrr1dXH1MMz8UcIf7vENA79ZdkqAA/sVw/bMo5VfsVEvdvOfsnXcP/ycXzJsWnEZmOKnCS1DywfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=cO8Y5xay; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="cO8Y5xay"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495437bb891so24548105e9.1
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154270; x=1785759070; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OYfNO8HaF8EPi01gt07T8qMMcubFMIJKbbLH4YUzSjU=;
        b=cO8Y5xayV5NANm6xe8jHC6L6fVFlyOACAiEuVnXDAXgmC3jBZwOM535IwKO6TsyywF
         n9aDteMW+G6LyH7F12Gm8LetrzMhs1Xui4CFXIJaCN14GLlt9MeEEqfOzbkMHKDVgt7i
         Dh4NyUJ3Tvp2WWAkSJS0PsR0RP3ylTSueKOd5FK1g5DzUlI6GTmfnPNUPRhyk5S5+GhB
         9uGUDibgLuD8qHrsl2lJQOJ5ysdoIFuJqP2oGYI205ExBtgExjf+hLO0LzFsB0QgIAIK
         hksjs9Rh7dPO/R1sZwmqORuogttQTvRFiZtZla4xAk8wVAmIVGUvb2NyNVB/VITuImCH
         vePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154270; x=1785759070;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OYfNO8HaF8EPi01gt07T8qMMcubFMIJKbbLH4YUzSjU=;
        b=oW1+pMfo4NqL0S+zERb/cuUzM34eX/yprFDeRoNGEry9lYkPR0DyjKYoifqTbZ9Xs4
         uZg1hbvsJ70ghZMZjKIThxCs6PvxNG6WQvbb751Lq1sNFmQ3rj5q4jgDrnsGcE9Y0ZDr
         S1f3pbjkcoUogpfAvaCz6em9GRu641K6VJHm0gZvg5KIV9HtkkZQX+aUdvatJffO4bB7
         JA23k/FRuNfoeKBDFl/Ofazp7T9BZsn7kLYigjvmOEXBpASsmUhvGekEJjt+aH7S2Nbe
         p88TqCjfjTf62mCLUWI4bEtYRjAasHLiZW8h79LiEH/Q4wRW8vC0dwRRw5hxhbAeWK6n
         jMpA==
X-Forwarded-Encrypted: i=1; AHgh+RqWgv4gbgPGUZbSPpn/em84zB3QoZPn+Fbovl6xiC+2UHSH6L7pWgaIofDlC2T5jcds8J3paIY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+v95XBKXItgC38wlmulJit4Dmlw4dk9lvTP97HksRLJ/mIdkX
	4f6rHNuFCq99Gwhko0StB4Q7EPMJ7KmiTVvl0MLA8fT/pqgLzh+/SKkPAxo67jBRLvA=
X-Gm-Gg: AR+sD121/mLjQ2OVAPCiNzXJ9jUwCBCjaTQeAq4ErGqYnnKn65sGpBMiXpSNYpPPztU
	QshwA8JLYcRpYY4YRG8MdISEcRFYBQ7xr7pATKvT2FCSbmL3Jh7dW2+TSzAurYxF8D+0DMxr7Xr
	Xz26xBWpHR2I2JN1kogcoyGQEQYCBjH4MtRq7/orYL0M/MaWYurw3W1PMSw0CKFpcl/bSFd7cLy
	/peG4pD5VhLlh6nJcejTzvDhhTttZfh4g3FlvAfedL9ITNWRwtiWZw+gp6Qc/2HKZWS2R4V+Kl+
	qp5WrUJ/Wp4jVEgR/PqDcXK/f9LUH+E7IfNn326ds52BUnwT82Wh1wwJ/On8mlbV+dd+Dyl6nrV
	MHpndStxycGZQiG0SvNmsKDKGqNIul3RZwy97KEu3ZlRact1Ufp3+1Iy/CE/mzo2pPNXqH0vyg0
	Sgf0RL14H5+V0DWA6Jg+TRzclxqh/g2Q==
X-Received: by 2002:a05:600c:4444:b0:495:6b4c:fccc with SMTP id 5b1f17b1804b1-496b5c7182amr98814975e9.10.1785154269911;
        Mon, 27 Jul 2026 05:11:09 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:11:09 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Mon, 27 Jul 2026 13:10:47 +0100
Subject: [PATCH 9/9] ACPI: use a named initializer for acpi_device_id::id
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-acpi-refactor-v1-9-ff900aa326ee@thegoodpenguin.co.uk>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=858;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=e3kFwrE54qrR7j9hf08X7x7yaGkc04oEEErLkv2k6T8=;
 b=wsRNozjg+w8drnieAF7pPxdPTk2dePtttYSw8fmP3QMndGXJ0o823SOn3yUNPQaqnRoaKa8AK
 Jq83mLuCTQUCT2D3wimXdXs1iPMiRgklDO0pAf9DdxAeyLqrdnv2PyD
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a named initializer for the acpi_device_id::id field for
readability and drop setting the list terminator fields
explicitly as well to be consistent with the rest of the kernel
code.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 include/linux/acpi.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 60ab50cb8930..b34b483d99f5 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -805,10 +805,10 @@ int acpi_mrrm_max_mem_region(void);
 #endif
 
 #define ACPI_CMOS_RTC_IDS	\
-	{ "PNP0B00", },		\
-	{ "PNP0B01", },		\
-	{ "PNP0B02", },		\
-	{ "", }
+	{ .id = "PNP0B00" },		\
+	{ .id = "PNP0B01" },		\
+	{ .id = "PNP0B02" },		\
+	{ }
 
 extern bool cmos_rtc_platform_device_present;
 

-- 
2.43.0

