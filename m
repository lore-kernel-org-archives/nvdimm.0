Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E583F1AD7
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154535; cv=none; b=OqKQ639EgP02AMblhI9hp3VUrduuYQe8aHR9xHXU55mmmA/IZjumrnsGUxtCF1tfIVlCXpK31r7qHLiVmWSpZ1o/V5LZJCvg/KrDhqu6WpGluumqLtvLL+nPNGU64DCAvEpQGLmA/ksX0wopaWmYhsO2lsGD0O8PC7JJyHhYxC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154535; c=relaxed/simple;
	bh=Bty6MctYT120Ze3HON+htllG50ccpvJj+ZxHK02dZ3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WF9kwli3ACpcpqla5zID7RDXlhcud5MVwpMCIn+QXX10ZWgEiRibWV1OrrjLFs6CZUJDKb9nWKr3mBVBf9eR1elgfdfpMKGE/GFPUtc6W+cPjoH177iduMqEcfhSIGA34Smk34gcz5Js3VV0T038Sdpuwg6nf6Ts4NoXEUkU8A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWNby+HG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWNby+HG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778111F00A3E
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 12:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785154520;
	bh=Zg3XpQecv0mXXRMsDgxjkw4kFjHnoHcsHChO/11NzsA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OWNby+HGAepxfSKuvxBG+TQEypvr39SSAUxEEu2K9UoUkXYZVRipxktclrFqgDuDp
	 /cwncd5mau4QL/VEKj5R0c1tqZoN0Ly2Aw2PkpNnWnfQDorOcgYi1SW0CB7fsKaCn/
	 OV/xjYY8x7KM1nmeFChGO6NBUDi92HS59SxLzHJ1OGtYtH+3NYFpqttkpO+xKjIxd2
	 vdtBHdSJw921f1kqEzyfWzxXEW3EZXJNqna7/k7yHPi79JocorcYqah/9AoLO765D2
	 /uiCVl3l1DDCumqddowDWlllssex/5BsGmMKNRA5xFmjnHLeH8HzWg9QE1LCWQ6Km0
	 jRyrxaI3iB9Yg==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39c86945164so20595451fa.1
        for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 05:15:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrR+23UTlemhkOBzXwSrFjITTikQDyxPcJCkH0GTS71mkYFDTmsvvzEWbqLn4ckiz6g/3rMEv4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9wP+fCuN/N1qaT7o03l8FNIxxl9etg8roX3ct+TMLIsVvLiqU
	6S4cwyDEBn7idcmBn1fhGVJeW0Iav06lulg+0d2rqqQ9dae0madfVc5v1mb6naus6wdGmozNwGc
	crIiD4TacuxYrG0gahNJGA5yM6ZoEc8k=
X-Received: by 2002:a05:651c:1504:b0:39e:b3b2:e95f with SMTP id
 38308e7fff4ca-39f2879f23dmr13514141fa.18.1785154518609; Mon, 27 Jul 2026
 05:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
In-Reply-To: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Mon, 27 Jul 2026 14:15:00 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0iVareeeAj-hECFasHtVKvZfFZXb6vqTz_BGQQVzSDk7A@mail.gmail.com>
X-Gm-Features: AUfX_mwnO5VxOfQHtV3WXK2XDax9MNHWMK_aInuBMDBRO8AF87-O7Mc0F0MkYFQ
Message-ID: <CAJZ5v0iVareeeAj-hECFasHtVKvZfFZXb6vqTz_BGQQVzSDk7A@mail.gmail.com>
Subject: Re: [PATCH 0/9] ACPI: use named initializers for acpi_device_id
To: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>, 
	Kai-Heng Feng <kaihengf@nvidia.com>, Tony Luck <tony.luck@intel.com>, 
	Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 2:10=E2=80=AFPM Pawel Zalewski (The Capable Hub)
<pzalewski@thegoodpenguin.co.uk> wrote:
>
> This series is converting lists that contain the acpi_device_id
> struct, which is defined in the include/linux/device-id/acpi.h
> to makes use of named initializers (which they do not use currently).
> This work is part of the on going effort in the kernel associated
> with device-ids [1]
>
> The plan is to convert acpi_device_id::driver_data to have an anonymous
> union, similarly to what was introduced for PCI and I2C device ID tables.
> The goal is to increase type-safety (as most of the existing casts are go=
ne),
> to improve readability and to make use intent a bit more clear:
>
> ```
> union {
>         kernel_ulong_t driver_data;
>         const void *driver_data_ptr;
> }
> ```
>
> But for that to work all lists containing the structs need to use named
> initializers first. I already have patches that implement this and touchi=
ng
> a lot of kernel subsystmes that use the acpi_device_id struct and that li=
st
> keeps on growing. Therefore, I have decided to split the series per every
> subsystem into:
> - pre-clean-ups that convert the lists to use named initializers
> - actual implementations that make some of the modules use the new driver=
_data_ptr
>
> That way the task can be fragmented into manageable and independent
> chunks of work and makes this effort easier to review.
>
> Tested builds on arm64 and x86-64 in Yocto on 7.2-rc5
>
> [1] https://lore.kernel.org/all/cover.1780048925.git.u.kleine-koenig@bayl=
ibre.com/
>
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin=
.co.uk>
> ---
> Pawel Zalewski (The Capable Hub) (9):
>       ACPI: use a named initializer for acpi_device_id
>       ACPI: drop unused assignment of acpi_device_id::driver_data
>       ACPI: pci: drop unused assignment of acpi_device_id::driver_data
>       ACPI: ghes-nvidia: use a named initializer for acpi_device_id::id
>       ACPI: amba: drop unused assignment of acpi_device_id::driver_data
>       ACPI: dptf: drop unused assignment of acpi_device_id::driver_data
>       ACPI: nfit: core: drop unused assignment of acpi_device_id::driver_=
data
>       ACPI: x86: use a named initializer for acpi_device_id::id
>       ACPI: use a named initializer for acpi_device_id::id
>
>  drivers/acpi/ac.c                 |   4 +-
>  drivers/acpi/acpi_apd.c           |  42 ++--
>  drivers/acpi/acpi_memhotplug.c    |   4 +-
>  drivers/acpi/acpi_pad.c           |   4 +-
>  drivers/acpi/acpi_platform.c      |  13 +-
>  drivers/acpi/acpi_pnp.c           | 514 +++++++++++++++++++-------------=
------
>  drivers/acpi/acpi_processor.c     |   8 +-
>  drivers/acpi/acpi_tad.c           |   4 +-
>  drivers/acpi/acpi_video.c         |   2 +-
>  drivers/acpi/apei/ghes-nvidia.c   |   2 +-
>  drivers/acpi/arm64/amba.c         |   6 +-
>  drivers/acpi/battery.c            |   8 +-
>  drivers/acpi/button.c             |  12 +-
>  drivers/acpi/container.c          |   8 +-
>  drivers/acpi/dptf/dptf_pch_fivr.c |  14 +-
>  drivers/acpi/dptf/dptf_power.c    |  38 +--
>  drivers/acpi/ec.c                 |   6 +-
>  drivers/acpi/evged.c              |   4 +-
>  drivers/acpi/fan_core.c           |   2 +-
>  drivers/acpi/hed.c                |   4 +-
>  drivers/acpi/nfit/core.c          |   4 +-
>  drivers/acpi/pci_link.c           |   4 +-
>  drivers/acpi/pci_root.c           |   4 +-
>  drivers/acpi/pfr_telemetry.c      |   4 +-
>  drivers/acpi/pfr_update.c         |   4 +-
>  drivers/acpi/processor_driver.c   |   6 +-
>  drivers/acpi/sbs.c                |   4 +-
>  drivers/acpi/sbshc.c              |   6 +-
>  drivers/acpi/scan.c               |  46 ++--
>  drivers/acpi/thermal.c            |   4 +-
>  drivers/acpi/tiny-power-button.c  |   6 +-
>  drivers/acpi/video_detect.c       |   4 +-
>  drivers/acpi/x86/cmos_rtc.c       |   2 +-
>  drivers/acpi/x86/lpss.c           |  54 ++--
>  drivers/acpi/x86/s2idle.c         |  14 +-
>  drivers/acpi/x86/utils.c          |  16 +-
>  include/linux/acpi.h              |   8 +-
>  37 files changed, 443 insertions(+), 446 deletions(-)
> ---

So we can talk about this after 7.3-rc1 is out.

Thanks!
