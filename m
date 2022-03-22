Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED6266A2
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 23:36:56 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso4808142pjb.0
        for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 16:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5DqFCQ2oE1pYCzIYiiNKM9mZOaie+LDyoMdfausdlzI=;
        b=L33V0a+wmtYwezPj9X1Y4RJsFXoUt8lcvZygJQRB9QGp2FlIAFlFCQSenTQiToUg+c
         3+e//zmnt99gfM9YruaQC/jabOcnXZHGDQJJDdByUeVnv/mVCp0W6RjHZEX/I8WX27Ql
         gfRkjvV8mjJK2JqpRMhGmcG7akVWkhriyu5EbJnrNq4rpyVJGw0FIadK6tIQSUu/c78h
         PuOzORsIXQ6y81ojU4gPKOVlrOgm4JcFomgufQdqbFe5GU4fxRJgeWFa7o4VGW4fOvZl
         0C85Tzri705dX4QyezpCUZjgAGW/9zRpecwXMzaZT8oqBaLW+kqwh6kmfuXhI0OLhyvr
         PCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5DqFCQ2oE1pYCzIYiiNKM9mZOaie+LDyoMdfausdlzI=;
        b=ujo25Ea1P8mXFc8HtgJjBSH99ZYM/4R39CTTMHfrV2uUtv2sIJ8DNP/6sb49mwjyMK
         CKwYmyzTggeTaaSuw9Gac2eUgLgQBsuZPwt3rQAZYOHNbAeLhhDw+LSSwzbJt9DgJM6x
         GTFQ9npPah+TeqsYeq26qok1zgyzgvxU/mn4MOVwXYoQDVw7n4QXXJ7NZFJ/WtzYAOUh
         pkTbXtVHs6/aO1lO6mZpI1aVLz9AB0wrVZa6DVSC//A8ii2WE8CreJlPbUp/Odj1niyx
         m5djUojBoZuauHsPr18zn2N2wN4qanuw9nMFGOjuSeY36DRS7PN4pL/fFYeg6gnTBNho
         tm+w==
X-Gm-Message-State: AOAM531nm8A4qQDsa4z3FAM10M3kh+hv0SwPqYdFrB5d/S2QWnEQ/gw2
	ahqhCeaBN3QMVdq2VvNzchxwcjCRPsj9kWgBl6fD3kExaH5/Gg==
X-Google-Smtp-Source: ABdhPJwaBAmXrFbdDD+Fv0CHyPPagaF2dqGsWuhdIMGEoUkYGhFSdY/MQiRuUWJd7gbbe4sUVvQHnLl99jCHRmIqx9M=
X-Received: by 2002:a17:90a:c083:b0:1c6:a164:fd5d with SMTP id
 o3-20020a17090ac08300b001c6a164fd5dmr8015377pjs.8.1647992216166; Tue, 22 Mar
 2022 16:36:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Mar 2022 16:36:48 -0700
Message-ID: <CAPcyv4jE=wfmfWS94WyMWhHwub0jJ4Vm6hnz8G3HJ9rd8pXKSA@mail.gmail.com>
Subject: [GIT PULL] Compute Express Link update for v5.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.18

...to receive the CXL subsystem update for v5.18. This development
cycle extends the subsystem to discover CXL resources throughout a
CXL/PCIe switch topology and respond to hot add/remove events anywhere
in that topology. This is more foundational infrastructure in
preparation for dynamic memory region provisioning support. Recall
that CXL memory regions, as the new "Theory of Operation" section of
Documentation/driver-api/cxl/memory-devices.rst describes, bring
storage volume striping semantics to memory. The hot add/remove
behavior is validated with extensions to the cxl_test unit test
environment and this test in the cxl-cli test suite:

https://github.com/pmem/ndctl/blob/djbw/for-74/cxl/test/cxl-topology.sh

All but the top commit of this update have seen multiple weeks of
exposure in Linux-next with no reported issues. The top-commit is an
obviously correct fix applied today.

---

The following changes since commit 26291c54e111ff6ba87a164d85d4a4e134b7315c:

  Linux 5.17-rc2 (2022-01-30 15:37:07 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl tags/cxl-for-5.18

for you to fetch changes up to 05e815539f3f161585c13a9ab023341bade2c52f:

  cxl/core/port: Fix NULL but dereferenced coccicheck error
(2022-03-22 10:51:17 -0700)

----------------------------------------------------------------
cxl for 5.18

- Add a driver for 'struct cxl_memdev' objects responsible for CXL.mem
  operation as distinct from 'cxl_pci' mailbox operations. Its primary
  responsibility is enumerating an endpoint 'struct cxl_port' and all the
  'struct cxl_port' instances between an endpoint and the CXL platform
  root.

- Add a driver for 'struct cxl_port' objects responsible for enumerating
  and operating all Host-managed Device Memory (HDM) decoder resources
  between the platform-level CXL memory description, all intervening host
  bridges / switches, and the HDM resources in endpoints.

- Update the cxl_pci driver to validate CXL.mem operation precursors to
  HDM decoder operation like ready-polling, and legacy CXL 1.1 DVSEC
  based CXL.mem configuration.

- Add basic lockdep coverage for usage of device_lock() on CXL subsystem
  objects similar to what exists for LIBNVDIMM. Include a compile-time
  switch for which subsystem to validate at run-time.

- Update cxl_test to emulate a one level switch topology.

- Document a "Theory of Operation" for the subsystem.

- Add 'numa_node' and 'serial' attributes to cxl_memdev sysfs

- Include miscellaneous fixes for spec / QEMU CXL emulation
  compatibility and static analysis reports.

----------------------------------------------------------------
Ben Widawsky (17):
      cxl: Rename CXL_MEM to CXL_PCI
      cxl/pci: Implement Interface Ready Timeout
      cxl: Flesh out register names
      cxl/pci: Add new DVSEC definitions
      cxl/acpi: Map component registers for Root Ports
      cxl: Introduce module_cxl_driver
      cxl/core: Convert decoder range to resource
      cxl/core/port: Clarify decoder creation
      cxl/core/port: Make passthrough decoder init implicit
      cxl/core: Track port depth
      cxl/port: Add a driver for 'struct cxl_port' objects
      cxl/pci: Store component register base in cxlds
      cxl/pci: Cache device DVSEC offset
      cxl/pci: Retrieve CXL DVSEC memory info
      cxl/pci: Implement wait for media active
      cxl/mem: Add the cxl_mem driver
      cxl/core/port: Add endpoint decoders

Dan Williams (29):
      cxl/pci: Defer mailbox status checks to command timeouts
      cxl/core/port: Rename bus.c to port.c
      cxl/decoder: Hide physical address information from non-root
      cxl/core: Fix cxl_probe_component_regs() error message
      cxl: Prove CXL locking
      cxl/core/port: Use dedicated lock for decoder target list
      cxl/port: Introduce cxl_port_to_pci_bus()
      cxl/pmem: Introduce a find_cxl_root() helper
      cxl/port: Up-level cxl_add_dport() locking requirements to the caller
      cxl/pci: Rename pci.h to cxlpci.h
      cxl/core: Generalize dport enumeration in the core
      cxl/core/hdm: Add CXL standard decoder enumeration to the core
      cxl/core: Emit modalias for CXL devices
      cxl/core/port: Remove @host argument for dport + decoder enumeration
      cxl/pci: Emit device serial number
      cxl/memdev: Add numa_node attribute
      cxl/core/port: Add switch port enumeration
      cxl/core: Move target_list out of base decoder attributes
      tools/testing/cxl: Mock dvsec_ranges()
      tools/testing/cxl: Fix root port to host bridge assignment
      tools/testing/cxl: Mock one level of switches
      tools/testing/cxl: Enumerate mock decoders
      tools/testing/cxl: Add a physical_node link
      cxl/core/port: Fix / relax decoder target enumeration
      cxl/core/port: Handle invalid decoders
      cxl/core/port: Fix unregister_port() lock assertion
      cxl/core: Fix cxl_device_lock() class detection
      cxl/port: Fix endpoint refcount leak
      cxl/port: Hold port reference until decoder release

Jonathan Cameron (1):
      cxl/regs: Fix size of CXL Capability Header Register

Wan Jiabing (1):
      cxl/core/port: Fix NULL but dereferenced coccicheck error

 Documentation/ABI/testing/sysfs-bus-cxl         |   36 +
 Documentation/driver-api/cxl/memory-devices.rst |  315 ++++-
 drivers/cxl/Kconfig                             |   44 +-
 drivers/cxl/Makefile                            |    6 +-
 drivers/cxl/acpi.c                              |  152 +--
 drivers/cxl/core/Makefile                       |    4 +-
 drivers/cxl/core/bus.c                          |  675 ----------
 drivers/cxl/core/core.h                         |    2 +
 drivers/cxl/core/hdm.c                          |  276 ++++
 drivers/cxl/core/memdev.c                       |   44 +
 drivers/cxl/core/pci.c                          |   96 ++
 drivers/cxl/core/pmem.c                         |   18 +-
 drivers/cxl/core/port.c                         | 1568 +++++++++++++++++++++++
 drivers/cxl/core/regs.c                         |   67 +-
 drivers/cxl/cxl.h                               |  197 ++-
 drivers/cxl/cxlmem.h                            |   39 +
 drivers/cxl/cxlpci.h                            |   75 ++
 drivers/cxl/mem.c                               |  228 ++++
 drivers/cxl/pci.c                               |  383 ++++--
 drivers/cxl/pci.h                               |   34 -
 drivers/cxl/pmem.c                              |   12 +-
 drivers/cxl/port.c                              |   76 ++
 drivers/nvdimm/nd-core.h                        |    2 +-
 lib/Kconfig.debug                               |   23 +
 tools/testing/cxl/Kbuild                        |   22 +-
 tools/testing/cxl/mock_acpi.c                   |   74 --
 tools/testing/cxl/mock_mem.c                    |   10 +
 tools/testing/cxl/mock_pmem.c                   |   24 -
 tools/testing/cxl/test/cxl.c                    |  330 ++++-
 tools/testing/cxl/test/mem.c                    |   19 +
 tools/testing/cxl/test/mock.c                   |   91 +-
 tools/testing/cxl/test/mock.h                   |    8 +-
 32 files changed, 3725 insertions(+), 1225 deletions(-)
 delete mode 100644 drivers/cxl/core/bus.c
 create mode 100644 drivers/cxl/core/hdm.c
 create mode 100644 drivers/cxl/core/pci.c
 create mode 100644 drivers/cxl/core/port.c
 create mode 100644 drivers/cxl/cxlpci.h
 create mode 100644 drivers/cxl/mem.c
 delete mode 100644 drivers/cxl/pci.h
 create mode 100644 drivers/cxl/port.c
 create mode 100644 tools/testing/cxl/mock_mem.c
 delete mode 100644 tools/testing/cxl/mock_pmem.c
