Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10B970
	for <nvdimm@lists.linux.dev>; Sat,  3 Jul 2021 15:08:39 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id o18so12367698pgu.10
        for <nvdimm@lists.linux.dev>; Sat, 03 Jul 2021 08:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AQbbf2RGKiyGMgVgSD04t3IAjg5pazcXA5ZylcTtDAs=;
        b=lZlsYYdVrFJhStYN9NB1Ujjd09m4N3akhoTQPZXEqZZabLevXrE/q9cEbf8aPgY2so
         lwCQsNyX0MyFbq9LmEZZ6trNOm72MBNPc6nyYxzw7CE6Y2TN7xRAWdpgFD6J0Faxbetr
         QuXgzdP222zRH5sezXz3WN5yuYgh6ENNXc4WlHq7u3fwUoDj0osHwwMmUSC0kRV5jmm7
         V75LPVlcZD5aHngJnUNwhlLgE1SMpAR2l2vvXh7zR8Ew75gOA4vaShhfaRPht9XMGDrI
         eAHdtSHnbNq1trv0+UaSKUBQY0mCDt1P4XNl1DgzZDzQyt2xJLp7iB3LminZj8/hLWgi
         5Zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AQbbf2RGKiyGMgVgSD04t3IAjg5pazcXA5ZylcTtDAs=;
        b=TQrXOd1pVHg/p1TsYBNwUYKbpg51QeH0sv7/D2i3u9McgxwbuREWZ4njaG4fkVamUo
         o9Y+JfBZGm4HMNIulvsVfj9qiIfhQ1nA+mfFi4u0lma0oijvND2iOJkrj2SB0oornYVO
         LotVyPjxoLY79daAFa5rdg8K1u8CJ2am30hpx4xwIe8S2wSEytqyYEUb3/54EnzTK33h
         WkE/Vd+To0ppXqgrO9xuITrgDG9z9EZ1ZqSibL6tED5rPBwZG5XHzQSpmKBAQXgZ4WR1
         EDDvPZ7WifELiILZDD0DzGDInZARzZHFCGz6gWBK9NULKE8pOdyS+n/W4PVRiLngnknF
         7QGw==
X-Gm-Message-State: AOAM530usqsMSyFIzeDGq24zQPf2nGhUnzWj6BIsSrYxUUtyHJeAeTEA
	pNapUw+LlJRy1UB/M2MPtIfv7wzP7dQWVmZ9KIrGYQ==
X-Google-Smtp-Source: ABdhPJwQze6TSTvDkgVEt9LlRIIJk9HNWrAOVf4x2epaG1/v9U+n4k6Glvi+ELRuBd3xk1p1GrxNqxTB2D2pxVXFkGs=
X-Received: by 2002:a63:195b:: with SMTP id 27mr5686983pgz.450.1625324919360;
 Sat, 03 Jul 2021 08:08:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 3 Jul 2021 08:08:28 -0700
Message-ID: <CAPcyv4haJdFPBdUJDwVwMvR4Ezij7Osn-+H0JApF=9fM2AM5wA@mail.gmail.com>
Subject: [GIT PULL] Compute Express Link (CXL) update for v5.14
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.14

...to receive the CXL update for v5.14. This subsystem is still in the
build-out phase as the bulk of the update is improvements to
enumeration and fleshing out the device model. In terms of new
features, more mailbox commands have been added to the allowed-list in
support of persistent memory provisioning support targeting v5.15. The
critical update from an enumeration perspective is support for the CXL
Fixed Memory Window Structure that indicates to Linux which system
physical address ranges decode to the CXL Host Bridges in the system.
This allows the driver to detect which address ranges have been mapped
by firmware and what address ranges are available for future hotplug.

So, again, mostly skeleton this round, with more meat targeting v5.15.

The bulk of this has been in -next with no reported issues. The top 3
commits were promoted from the cxl 'pending' to 'next' branch recently
and -next has not had a chance to pick those up yet, but the kbuild
robot has chewed on that pending branch for a couple weeks.

Please pull, thanks.

---

The following changes since commit 4a2c1dcfaf59be4b357400d893c3f5daff6cab6c:

  ACPICA: Add the CFMWS structure definition to the CEDT table
(2021-06-07 14:04:43 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.14

for you to fetch changes up to 4ad6181e4b216ed0cb52f45d3c6d2c70c8ae9243:

  cxl/pci: Rename CXL REGLOC ID (2021-06-17 17:37:18 -0700)

----------------------------------------------------------------
cxl for 5.14

- Add support for the CXL Fixed Memory Window Structure, a recent
  extension of the ACPI CEDT (CXL Early Discovery Table)

- Add infrastructure for component registers

- Add HDM (Host-managed device memory) decoder definitions

- Define a device model for an HDM decoder tree

- Bridge CXL persistent memory capabilities to an NVDIMM bus /
  device-model

- Switch to fine grained mapping of CXL MMIO registers to allow
  different drivers / system software to own individual register blocks

- Enable media provisioning commands, and publish the label storage area
  size in sysfs

- Miscellaneous cleanups and fixes

----------------------------------------------------------------
Alison Schofield (2):
      cxl/acpi: Add the Host Bridge base address to CXL port objects
      cxl/acpi: Use the ACPI CFMWS to create static decoder objects

Ben Widawsky (11):
      cxl: Rename mem to pci
      cxl/mem: Demarcate vendor specific capability IDs
      cxl/mem: Use dev instead of pdev->dev
      cxl/mem: Split creation from mapping in probe
      cxl/mem: Move register locator logic into reg setup
      cxl/mem: Get rid of @cxlm.base
      cxl/pci: Add HDM decoder capabilities
      cxl/hdm: Fix decoder count calculation
      cxl/component_regs: Fix offset
      cxl/pci: Add media provisioning required commands
      cxl/pci: Rename CXL REGLOC ID

Dan Williams (17):
      cxl/mem: Move some definitions to mem.h
      cxl/mem: Introduce 'struct cxl_regs' for "composable" CXL devices
      cxl/core: Rename bus.c to core.c
      cxl/core: Refactor CXL register lookup for bridge reuse
      cxl/docs: Fix "Title underline too short" warning
      cxl/pci: Fixup devm_cxl_iomap_block() to take a 'struct device *'
      Merge branch 'rafael/acpica/cfmws' into for-5.14/cxl
      cxl/acpi: Introduce the root of a cxl_port topology
      cxl/Kconfig: Default drivers to CONFIG_CXL_BUS
      cxl/acpi: Add downstream port data to cxl_port instances
      cxl/acpi: Enumerate host bridge root ports
      cxl/acpi: Introduce cxl_decoder objects
      cxl/core: Add cxl-bus driver infrastructure
      cxl/pmem: Add initial infrastructure for pmem support
      libnvdimm: Export nvdimm shutdown helper, nvdimm_delete()
      libnvdimm: Drop unused device power management support
      cxl/pmem: Register 'pmem' / cxl_nvdimm devices

Ira Weiny (4):
      cxl/pci: Introduce cxl_decode_register_block()
      cxl/pci: Reserve all device regions at once
      cxl/pci: Map registers based on capabilities
      cxl/pci: Reserve individual register block regions

Vishal Verma (1):
      cxl/pci.c: Add a 'label_storage_size' attribute to the memdev

 Documentation/ABI/testing/sysfs-bus-cxl         |  103 +++
 Documentation/driver-api/cxl/memory-devices.rst |   20 +-
 drivers/cxl/Kconfig                             |   43 +-
 drivers/cxl/Makefile                            |   12 +-
 drivers/cxl/acpi.c                              |  434 +++++++++
 drivers/cxl/bus.c                               |   29 -
 drivers/cxl/core.c                              | 1067 +++++++++++++++++++++++
 drivers/cxl/cxl.h                               |  332 +++++--
 drivers/cxl/mem.h                               |   81 ++
 drivers/cxl/{mem.c => pci.c}                    |  439 ++++++----
 drivers/cxl/pci.h                               |    2 +-
 drivers/cxl/pmem.c                              |  230 +++++
 drivers/nvdimm/bus.c                            |   64 +-
 drivers/nvdimm/dimm_devs.c                      |   18 +
 include/linux/libnvdimm.h                       |    1 +
 include/uapi/linux/cxl_mem.h                    |   12 +
 16 files changed, 2596 insertions(+), 291 deletions(-)
 create mode 100644 drivers/cxl/acpi.c
 delete mode 100644 drivers/cxl/bus.c
 create mode 100644 drivers/cxl/core.c
 create mode 100644 drivers/cxl/mem.h
 rename drivers/cxl/{mem.c => pci.c} (86%)
 create mode 100644 drivers/cxl/pmem.c
