Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9942563
	for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 20:54:52 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id b13so15090799pfv.0
        for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 13:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FDqhi0N/S/cUCLoAuboiyOBP3IQEQ1O6QqcgKgHDMTU=;
        b=x/3PVpLYjRnKwsaey2xougaew21RYo4GEuoyEXNrglvcGPfUh+vqthPJlK8+C2bTgd
         8IMQTz6lp1ZgXncGNdvSlXcRhEcstjb6VorrpPRbOp/t0HyM0LTjRzh5bRyXtvuo433s
         Or1qeAQH7BuLCtaKAaRBbLN0NO1o8aIwh9hcBCiqhksd6QZoCn7M+28UTb00TNrOsW4e
         X96Aj//eZ/TfBgpoel8d1ub+9aJsdZ/fBzuZP5e0dRYyqxdW0GdfkIuE/8uirSGD1dfk
         blTKmQGCEUVBvGIGXqfr4EQXMS/OOPijoAnAYxMAqoyD+VuClv5yU/a7zvGwdYqW7+OE
         Oe2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FDqhi0N/S/cUCLoAuboiyOBP3IQEQ1O6QqcgKgHDMTU=;
        b=v6wj6LlQNCjOVZ1Sb1Zy7ylZhZamCCuRrAptgTp8CrGRpDrG4w8NxbcYKg27U7rTRB
         vLdwii3zd4gYWShMpUNfA0cZvuzdBmwVcEEb1wjh7NJAAfvAqMYptJjsO7hUJO3F22jj
         hUxHxdxLhGIL0FQUqMm4NzKpSqKliX7/2zIs512EQAi7BtQFF0Yvr/EOo06fC+jxFdCw
         juHd63/7SPY+JgDmIo3arxG8f6mYUYWaOVWwdBlYatKkXYrpEGunEIzNhqGIuWARYyB0
         36r6wmDpktayuKOEPPZaTZw3GpCE/sz8b0QzIdx0N1UjYH7D/iShaGk3MVYA5L4zY6Se
         nB1w==
X-Gm-Message-State: AOAM532YTO+bPN+9zUI19rlGSAYE00aFwsR7OciH/KHKWUyzlcsaAaOz
	iUn5XgQtr3PTe56Dy0PTkVQ/WNBw/uQJ8rn0vmld/g==
X-Google-Smtp-Source: ABdhPJwmS9mDmjkje+k3GsHwWgWBckFPeTJrJcGyj7bgk4ha15BJ4lDerfFVoIwXMu5O3fOv2UnxO/USzXRhOvcTnJw=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr3350486pgb.74.1648587292181; Tue, 29
 Mar 2022 13:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Mar 2022 13:54:41 -0700
Message-ID: <CAPcyv4hydiSDFXVVBtYyuUgutTca6eL67s7txkSgzGzW1VGT0A@mail.gmail.com>
Subject: [GIT PULL] LIBNVDIMM update for v5.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.18

...to receive the libnvdimm update for this cycle which includes the
deprecation of block-aperture mode and a new perf events interface for
the papr_scm nvdimm driver. The perf events approach was acked by
PeterZ. You will notice the top commit is less than a week old as
linux-next exposure identified some build failure scenarios. Kajol
turned around a fix and it has appeared in linux-next with no
additional reports. Some other fixups for the removal of
block-aperture mode also generated some follow-on fixes from -next
exposure.

I am not aware of anything else outstanding, please pull.

---

The following changes since commit 754e0b0e35608ed5206d6a67a791563c631cec07:

  Linux 5.17-rc4 (2022-02-13 12:13:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.18

for you to fetch changes up to ada8d8d337ee970860c9844126e634df8076aa11:

  nvdimm/blk: Fix title level (2022-03-23 17:52:33 -0700)

----------------------------------------------------------------
libnvdimm for 5.18

- Add perf support for nvdimm events, initially only for 'papr_scm'
  devices.

- Deprecate the 'block aperture' support in libnvdimm, it only ever
  existed in the specification, not in shipping product.

----------------------------------------------------------------
Dan Williams (6):
      nvdimm/region: Fix default alignment for small regions
      nvdimm/blk: Delete the block-aperture window driver
      nvdimm/namespace: Delete blk namespace consideration in shared paths
      nvdimm/namespace: Delete nd_namespace_blk
      ACPI: NFIT: Remove block aperture support
      nvdimm/region: Delete nd_blk_region infrastructure

Kajol Jain (6):
      drivers/nvdimm: Add nvdimm pmu structure
      drivers/nvdimm: Add perf interface to expose nvdimm performance stats
      powerpc/papr_scm: Add perf interface support
      docs: ABI: sysfs-bus-nvdimm: Document sysfs event format entries
for nvdimm pmu
      drivers/nvdimm: Fix build failure when CONFIG_PERF_EVENTS is not set
      powerpc/papr_scm: Fix build failure when

Lukas Bulwahn (1):
      MAINTAINERS: remove section LIBNVDIMM BLK: MMIO-APERTURE DRIVER

Tom Rix (1):
      nvdimm/blk: Fix title level

 Documentation/ABI/testing/sysfs-bus-nvdimm |  35 ++
 Documentation/driver-api/nvdimm/nvdimm.rst | 406 +++++------------------
 MAINTAINERS                                |  11 -
 arch/powerpc/include/asm/device.h          |   5 +
 arch/powerpc/platforms/pseries/papr_scm.c  | 230 +++++++++++++
 drivers/acpi/nfit/core.c                   | 387 +---------------------
 drivers/acpi/nfit/nfit.h                   |   6 -
 drivers/nvdimm/Kconfig                     |  25 +-
 drivers/nvdimm/Makefile                    |   4 +-
 drivers/nvdimm/blk.c                       | 335 -------------------
 drivers/nvdimm/bus.c                       |   2 -
 drivers/nvdimm/dimm_devs.c                 | 204 +-----------
 drivers/nvdimm/label.c                     | 346 +-------------------
 drivers/nvdimm/label.h                     |   5 +-
 drivers/nvdimm/namespace_devs.c            | 506 ++---------------------------
 drivers/nvdimm/nd-core.h                   |  27 +-
 drivers/nvdimm/nd.h                        |  13 -
 drivers/nvdimm/nd_perf.c                   | 329 +++++++++++++++++++
 drivers/nvdimm/region.c                    |  31 +-
 drivers/nvdimm/region_devs.c               | 157 ++-------
 include/linux/libnvdimm.h                  |  24 --
 include/linux/nd.h                         |  78 +++--
 include/uapi/linux/ndctl.h                 |   2 -
 tools/testing/nvdimm/Kbuild                |   4 -
 tools/testing/nvdimm/config_check.c        |   1 -
 tools/testing/nvdimm/test/ndtest.c         |  67 +---
 tools/testing/nvdimm/test/nfit.c           |  23 --
 27 files changed, 833 insertions(+), 2430 deletions(-)
 delete mode 100644 drivers/nvdimm/blk.c
 create mode 100644 drivers/nvdimm/nd_perf.c
