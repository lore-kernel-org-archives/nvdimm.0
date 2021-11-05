Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09CD2C85
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 01:21:05 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id v23so81835pjr.5
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 18:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8BlblZNwkbcKAS2iistnQm3UAf7Ffy7cqWTYNAo60h4=;
        b=GMrUJl1+msSYfMehtGPnWry7jg7iiXw4HoUmUoMjERxr1CqPy8hJ+6ol5Yg02gffwI
         PFAhl2+Z0fggHaE3EQ7WERHF7StmMA5KMS13kEBSYcLwg5cXgxdknznk31v3cncJQ1xg
         DzGQIeh1AeXw5laDFQGCLXCpjpXZklk0+brhz8r4va0fU0bLNgYWWlaLDMhseaZPx6LB
         JluAtn7I9nwuDBtqKocsPD/mOoPhyoph2zjzr/nmFXv3i9hdSpYpmfWAZtK38OfGZD34
         tWUeDvXcxqPKPKqkDgaTowTcaKs+OZtd2ZKDzsfAPtkmB5vf2zG2dAUPJRG/bNhW15ZR
         wrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8BlblZNwkbcKAS2iistnQm3UAf7Ffy7cqWTYNAo60h4=;
        b=3xMilj8MtEzEDgOmGMv3JAIpoLpS8oKXxYDRcuXRSe/i663JRgb5EsSnrfV0Ttgl8Y
         2KHpCpP5o/4KSAcwy4NdRkkr7tpySZKCriIpcjYEHNb8w+JQbRPahzFJ6h3K5IPnUsh4
         rFgQ+HFW5umeguzeQnpbcYhpXytorcEqiFGFoTaoI6/bIt1gyCIhcLLekN88kSU5dZVJ
         3mDa5SyW15D1vJMWHxBzuf/WHzCjb0s58ibl80cP59ggrKv7VaPDhfxKZmqPQrFA5aaO
         WZvjO+bJsy/2pheTMX/gSYDa6B/o+JC8pyoKUn7Hi3RAh0pWL+at7XtsYdWhf8B3DqdY
         9Jpg==
X-Gm-Message-State: AOAM530SYQ/EnnjAWEWVSZ6FeF4IoRtJ9/frWsFCvwmIrNNUxwiDzIGJ
	K1UBFtXR1ztCnqNVyYNJ9bnHeF8vUok7Zuyn9/p6Qg==
X-Google-Smtp-Source: ABdhPJx6X4yCBHZUqPm/q0IetQzSKp48gnHuH7S3KIvG/nzBmYkpBQtyF7YVuNddtgFirDmjXpzu9EoUghp9IMOjhnQ=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr5946350pjb.93.1636075265420;
 Thu, 04 Nov 2021 18:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 18:20:55 -0700
Message-ID: <CAPcyv4gSGURnUvkvMyfr+SbSZikhBdyCLXVkqn_Sa8PbjtxUXQ@mail.gmail.com>
Subject: [GIT PULL] Compute Express Link update for v5.16
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.16

...to receive more preparation and plumbing work in the CXL subsystem.
From an end user perspective the highlight here is lighting up the CXL
Persistent Memory related commands (label read / write) with the
generic ioctl() front-end in LIBNVDIMM. Otherwise, the ability to
instantiate new persistent and volatile memory regions is still on
track for v5.17. More details in the tag message below. This has
appeared in linux-next with no reported issues.

---

The following changes since commit e4e737bb5c170df6135a127739a9e6148ee3da82:

  Linux 5.15-rc2 (2021-09-19 17:28:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.16

for you to fetch changes up to c6d7e1341cc99ba49df1384c8c5b3f534a5463b1:

  ocxl: Use pci core's DVSEC functionality (2021-10-29 11:53:52 -0700)

----------------------------------------------------------------
cxl for v5.16

- Fix support for platforms that do not enumerate every ACPI0016 (CXL
  Host Bridge) in the CHBS (ACPI Host Bridge Structure).

- Introduce a common pci_find_dvsec_capability() helper, clean up open
  coded implementations in various drivers.

- Add 'cxl_test' for regression testing CXL subsystem ABIs. 'cxl_test'
  is a module built from tools/testing/cxl/ that mocks up a CXL topology
  to augment the nascent support for emulation of CXL devices in QEMU.

- Convert libnvdimm to use the uuid API.

- Complete the definition of CXL namespace labels in libnvdimm.

- Tunnel libnvdimm label operations from nd_ioctl() back to the CXL
  mailbox driver. Enable 'ndctl {read,write}-labels' for CXL.

- Continue to sort and refactor functionality into distinct driver and
  core-infrastructure buckets. For example, mailbox handling is now a
  generic core capability consumed by the PCI and cxl_test drivers.

----------------------------------------------------------------
Alison Schofield (1):
      cxl/acpi: Do not fail cxl_acpi_probe() based on a missing CHBS

Ben Widawsky (10):
      Documentation/cxl: Add bus internal docs
      cxl/pci: Disambiguate cxl_pci further from cxl_mem
      cxl/pci: Convert register block identifiers to an enum
      cxl/pci: Remove dev_dbg for unknown register blocks
      cxl/pci: Remove pci request/release regions
      cxl/pci: Make more use of cxl_register_map
      cxl/pci: Split cxl_pci_setup_regs()
      PCI: Add pci_find_dvsec_capability to find designated VSEC
      cxl/pci: Use pci core's DVSEC functionality
      ocxl: Use pci core's DVSEC functionality

Dan Williams (23):
      libnvdimm/labels: Add uuid helpers
      libnvdimm/label: Add a helper for nlabel validation
      libnvdimm/labels: Introduce the concept of multi-range namespace labels
      libnvdimm/labels: Fix kernel-doc for label.h
      libnvdimm/label: Define CXL region labels
      libnvdimm/labels: Introduce CXL labels
      cxl/pci: Make 'struct cxl_mem' device type generic
      cxl/pci: Clean up cxl_mem_get_partition_info()
      cxl/mbox: Introduce the mbox_send operation
      cxl/pci: Drop idr.h
      cxl/mbox: Move mailbox and other non-PCI specific infrastructure
to the core
      cxl/pci: Use module_pci_driver
      cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP
      cxl/mbox: Add exclusive kernel command support
      cxl/pmem: Translate NVDIMM label commands to CXL label commands
      cxl/pmem: Add support for multiple nvdimm-bridge objects
      tools/testing/cxl: Introduce a mocked-up CXL port hierarchy
      cxl/bus: Populate the target list at decoder create
      cxl/mbox: Move command definitions to common location
      tools/testing/cxl: Introduce a mock memory device + driver
      cxl/core: Split decoder setup into alloc + add
      cxl/pci: Fix NULL vs ERR_PTR confusion
      cxl/pci: Add @base to cxl_register_map

 Documentation/driver-api/cxl/memory-devices.rst |    6 +
 arch/powerpc/platforms/powernv/ocxl.c           |    3 +-
 drivers/cxl/acpi.c                              |  139 ++-
 drivers/cxl/core/Makefile                       |    1 +
 drivers/cxl/core/bus.c                          |  119 ++-
 drivers/cxl/core/core.h                         |   11 +-
 drivers/cxl/core/mbox.c                         |  787 ++++++++++++++
 drivers/cxl/core/memdev.c                       |  118 ++-
 drivers/cxl/core/pmem.c                         |   39 +-
 drivers/cxl/cxl.h                               |   58 +-
 drivers/cxl/cxlmem.h                            |  202 +++-
 drivers/cxl/pci.c                               | 1240 ++---------------------
 drivers/cxl/pci.h                               |   14 +-
 drivers/cxl/pmem.c                              |  163 ++-
 drivers/misc/ocxl/config.c                      |   13 +-
 drivers/nvdimm/btt.c                            |   11 +-
 drivers/nvdimm/btt_devs.c                       |   14 +-
 drivers/nvdimm/core.c                           |   40 +-
 drivers/nvdimm/label.c                          |  139 ++-
 drivers/nvdimm/label.h                          |   94 +-
 drivers/nvdimm/namespace_devs.c                 |   95 +-
 drivers/nvdimm/nd-core.h                        |    5 +-
 drivers/nvdimm/nd.h                             |  185 +++-
 drivers/nvdimm/pfn_devs.c                       |    2 +-
 drivers/pci/pci.c                               |   32 +
 include/linux/nd.h                              |    4 +-
 include/linux/pci.h                             |    1 +
 tools/testing/cxl/Kbuild                        |   38 +
 tools/testing/cxl/config_check.c                |   13 +
 tools/testing/cxl/mock_acpi.c                   |  109 ++
 tools/testing/cxl/mock_pmem.c                   |   24 +
 tools/testing/cxl/test/Kbuild                   |   10 +
 tools/testing/cxl/test/cxl.c                    |  576 +++++++++++
 tools/testing/cxl/test/mem.c                    |  256 +++++
 tools/testing/cxl/test/mock.c                   |  171 ++++
 tools/testing/cxl/test/mock.h                   |   27 +
 36 files changed, 3269 insertions(+), 1490 deletions(-)
 create mode 100644 drivers/cxl/core/mbox.c
 create mode 100644 tools/testing/cxl/Kbuild
 create mode 100644 tools/testing/cxl/config_check.c
 create mode 100644 tools/testing/cxl/mock_acpi.c
 create mode 100644 tools/testing/cxl/mock_pmem.c
 create mode 100644 tools/testing/cxl/test/Kbuild
 create mode 100644 tools/testing/cxl/test/cxl.c
 create mode 100644 tools/testing/cxl/test/mem.c
 create mode 100644 tools/testing/cxl/test/mock.c
 create mode 100644 tools/testing/cxl/test/mock.h
