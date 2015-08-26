Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/2]: acpi, nfit: Clarify memory device state flags
Date: Wed, 26 Aug 2015 10:20:22 -0600
Message-Id: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com, rafael.j.wysocki@intel.com
Cc: robert.moore@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, elliott@hp.com
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
NVDIMM status.  User can check the NVDIMM status from sysfs and
dmesg output, but the output can be confusing at this point.

Patch 01 clarifies the output strings from the sysfs and dmesg.

Patch 02 clarifies the define name of not-arm bit in the flags.

This patchset is based on libnvdimm-pending of the nvdimm tree.

---
Toshi Kani (2):
  1/2 nfit: Clarify memory device state flags strings
  2/2 acpica/nfit: Rename not-armed bit definition

---
 drivers/acpi/nfit.c              | 25 +++++++++++++------------
 drivers/acpi/nfit.h              |  2 +-
 include/acpi/actbl1.h            |  2 +-
 tools/testing/nvdimm/test/nfit.c |  2 +-
 4 files changed, 16 insertions(+), 15 deletions(-)
