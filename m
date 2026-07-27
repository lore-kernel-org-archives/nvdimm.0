Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44963F4DF8
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154257; cv=none; b=fOG42ukCbOSpgREzBfRG76mkXxn99mV1049tS5mP8bjYLxs8z+XxBMnyaZdqYhLjfh9GPybZS1TGyiIo4llDi/6G/g6tjvpJnsO5sLocxTnQUVawk2Jgonhhx76hd8NfTGtQMJ9j7WkNEFewaaGnTYjfDtbSGw3osskOk/53DPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154257; c=relaxed/simple;
	bh=hDpi+mS6ZesLKap0n94a9xm6h6ixQ5Klrug46U51A7M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HuWEvT3ntXU9mplgINGZpW2qR913cHFwFNCkTP9cwdM8zl1u03aXglEwlElGfzHREyWDBQsNW3c8DfHWCNkdirKV8bGtrbI3qGNHCD5NeBtPzdUTMBGcxokF7CXm5k6Uu8O9rDsBs6u6TRDcDGNObUL7tSBKVqHM372avn0wf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=vvswhofi; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="vvswhofi"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so24347205e9.2
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1785154254; x=1785759054; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OICCS3yLJZnEdkP0xlPeHb8B7fyLwNgxSSOf4ztj6D8=;
        b=vvswhofiCTvAot4CDLT9MOQiTC1KCCMF3R/XRQCXSa+1R8YL9f+1xXvNY/FmabmCeN
         gVQyt3Iw+IWPcjVd6BadawuqMPLR0rB9gRr96UnqfZ08SewcLV/nWKctzyLTi3oDUZnw
         4mwBWTCF0e571MZfhA0+NG47yJenFPcU/HUghfmIQJloTmLmpCvk3ylFXAqSBbb2HZOG
         IcwmnibQhJR5A1JbLRQrBFmVaWvBOiykv4cwKGhY3LVuctXeoRajnx/W/H3gVF2Ze6YS
         yOI4/JXpeScNX2lHvPIgTMzXbc5ShkHFBvwKcuX6dpo3IYmp+t6YJTYWTdCD8e6UPhwA
         07uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154254; x=1785759054;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OICCS3yLJZnEdkP0xlPeHb8B7fyLwNgxSSOf4ztj6D8=;
        b=M9yKxK9H9btFpFU6FIlhwAD6rmA1THXKYGoR215E7QQikDKFCpgzag4l3N0PmnGYFU
         JgMrs1v4Y8+k5upEAGnwc8gDt8+sKVyJh+kuqP+9cKjZHBA/4N1CKLu8TWp9g1e4ulVP
         r5elPpVAnVuplOAnKphUFQ3bI7wHBBicnIAsaCg8rjJtGSAxn5qzuiMtMwV6qzhUufJS
         /z0EsDSGUzAeBzbz6Q4lwvE28W78zTBS6M0Vo2yVc+NCISC/uZdMHVcA+znwGI6Iw5El
         rYTd8HPMSQV1dlVHjAzYREPV+Fm36q0LEBs72mxTrcyd+uLlfUt3oWwFcfJTi+WV3esY
         1f+g==
X-Forwarded-Encrypted: i=1; AHgh+Rrm7fSLh4Y7bjtdpelKL7Lg68eDGbL01pOKtqWf/x0J6IMIYVZpogyq1XwifAWUXhBQw6N0cug=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMxubVJDUo9RFaTDpjxMZAoRiPN2rU4AO8JWncc0LgAnyOePVJ
	85KiMd6Zl9j7jgXuIXrYJleSd8TM6wFixpKymLaL0MZc6X7AZQ5PqBmLBeG5B7joZ/E=
X-Gm-Gg: AR+sD106SCWYGcGrIjStBiSW0e9rOSEx/Y28GU7zZ02xiYCSo+0vhMN4X9GVJNE+0wl
	XQ9nlWkx8AoN1eMaswtXktKOz8fpjRYJS9etTnwp0Zs9LQzBlhxiNX3aELxQiGYF3mWTk0bksDb
	T/zRUIazfF4O2Q3IMXZlGMobi0sL1OzeFaCbp/2oXTLLJnLdOqJxaUIdlk2H0f7kklInvsDNuIU
	RNfbXbef+pMcXNv4eSSKl3sMzdL1vsNG6ulizML5cu4Ujx+wzMGf/V52HLf5ACcYasVfLal6r2r
	dzazFfYQFaFePDKdP1fZovTpaCDdCUeq1hW8eeZ+/iYG5FPr4WGcTSfxgGf41XH3PwneaKRZHix
	MYeBe13FY7Qbn4FrMIrl0aa3kQYz2jFUxL72XjBcilkkbI6YIGUKJUc5g+vRJzqV2pnHrCWmvi+
	lR1sPiQsORiSNHSLZffxw=
X-Received: by 2002:a05:600c:1d0d:b0:493:c47f:3c55 with SMTP id 5b1f17b1804b1-496b56bbc2fmr104042095e9.5.1785154253954;
        Mon, 27 Jul 2026 05:10:53 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:7aab:bc55:e039:4aac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4f302f8sm211778055e9.12.2026.07.27.05.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 05:10:53 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Subject: [PATCH 0/9] ACPI: use named initializers for acpi_device_id
Date: Mon, 27 Jul 2026 13:10:38 +0100
Message-Id: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL5KZ2oC/yXMQQ5AMBCF4avIrDWp0ZC4iljUmDIWSItIpHdXL
 L+8vP+GwF44QJPd4PmUIOuSUOQZ0GSXkZUMyYAaK12jUZY2UZ6dpX31yhl2hM4Y1CWkz5YWub5
 e2/0ORz8z7W8EYnwAYK3YLnEAAAA=
X-Change-ID: 20260724-acpi-refactor-f4efc2f44203
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785154252; l=4122;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=hDpi+mS6ZesLKap0n94a9xm6h6ixQ5Klrug46U51A7M=;
 b=1200lUbaXeYWmclYJpq+b23CZR3Ejwn2Uth0/1cJecdaSViFrJz967y3swrowZIlhRNa0QRbk
 uGqRtfo1UCABz+VPUBqhAMuHJcnRcILUfp89Qu2pEPZ37OLyiygqmoj
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

This series is converting lists that contain the acpi_device_id 
struct, which is defined in the include/linux/device-id/acpi.h 
to makes use of named initializers (which they do not use currently).
This work is part of the on going effort in the kernel associated
with device-ids [1]

The plan is to convert acpi_device_id::driver_data to have an anonymous 
union, similarly to what was introduced for PCI and I2C device ID tables.
The goal is to increase type-safety (as most of the existing casts are gone), 
to improve readability and to make use intent a bit more clear:

```
union {
	kernel_ulong_t driver_data;
	const void *driver_data_ptr;
}
```

But for that to work all lists containing the structs need to use named
initializers first. I already have patches that implement this and touching
a lot of kernel subsystmes that use the acpi_device_id struct and that list
keeps on growing. Therefore, I have decided to split the series per every
subsystem into:
- pre-clean-ups that convert the lists to use named initializers
- actual implementations that make some of the modules use the new driver_data_ptr

That way the task can be fragmented into manageable and independent
chunks of work and makes this effort easier to review.

Tested builds on arm64 and x86-64 in Yocto on 7.2-rc5

[1] https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@baylibre.com/

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
Pawel Zalewski (The Capable Hub) (9):
      ACPI: use a named initializer for acpi_device_id
      ACPI: drop unused assignment of acpi_device_id::driver_data
      ACPI: pci: drop unused assignment of acpi_device_id::driver_data
      ACPI: ghes-nvidia: use a named initializer for acpi_device_id::id
      ACPI: amba: drop unused assignment of acpi_device_id::driver_data
      ACPI: dptf: drop unused assignment of acpi_device_id::driver_data
      ACPI: nfit: core: drop unused assignment of acpi_device_id::driver_data
      ACPI: x86: use a named initializer for acpi_device_id::id
      ACPI: use a named initializer for acpi_device_id::id

 drivers/acpi/ac.c                 |   4 +-
 drivers/acpi/acpi_apd.c           |  42 ++--
 drivers/acpi/acpi_memhotplug.c    |   4 +-
 drivers/acpi/acpi_pad.c           |   4 +-
 drivers/acpi/acpi_platform.c      |  13 +-
 drivers/acpi/acpi_pnp.c           | 514 +++++++++++++++++++-------------------
 drivers/acpi/acpi_processor.c     |   8 +-
 drivers/acpi/acpi_tad.c           |   4 +-
 drivers/acpi/acpi_video.c         |   2 +-
 drivers/acpi/apei/ghes-nvidia.c   |   2 +-
 drivers/acpi/arm64/amba.c         |   6 +-
 drivers/acpi/battery.c            |   8 +-
 drivers/acpi/button.c             |  12 +-
 drivers/acpi/container.c          |   8 +-
 drivers/acpi/dptf/dptf_pch_fivr.c |  14 +-
 drivers/acpi/dptf/dptf_power.c    |  38 +--
 drivers/acpi/ec.c                 |   6 +-
 drivers/acpi/evged.c              |   4 +-
 drivers/acpi/fan_core.c           |   2 +-
 drivers/acpi/hed.c                |   4 +-
 drivers/acpi/nfit/core.c          |   4 +-
 drivers/acpi/pci_link.c           |   4 +-
 drivers/acpi/pci_root.c           |   4 +-
 drivers/acpi/pfr_telemetry.c      |   4 +-
 drivers/acpi/pfr_update.c         |   4 +-
 drivers/acpi/processor_driver.c   |   6 +-
 drivers/acpi/sbs.c                |   4 +-
 drivers/acpi/sbshc.c              |   6 +-
 drivers/acpi/scan.c               |  46 ++--
 drivers/acpi/thermal.c            |   4 +-
 drivers/acpi/tiny-power-button.c  |   6 +-
 drivers/acpi/video_detect.c       |   4 +-
 drivers/acpi/x86/cmos_rtc.c       |   2 +-
 drivers/acpi/x86/lpss.c           |  54 ++--
 drivers/acpi/x86/s2idle.c         |  14 +-
 drivers/acpi/x86/utils.c          |  16 +-
 include/linux/acpi.h              |   8 +-
 37 files changed, 443 insertions(+), 446 deletions(-)
---
base-commit: 48a5a7ab8d6ab7090564339e039c421f315de912
change-id: 20260724-acpi-refactor-f4efc2f44203

Best regards,
--  
Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>

