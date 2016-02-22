Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 0/3] ACPI 6.1 update for NFIT Control Region Structure
Date: Mon, 22 Feb 2016 14:55:27 -0700
Message-Id: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, elliott@hpe.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@acpica.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure
as follows.
 - Valid Fields, Manufacturing Location, and Manufacturing Date
   are added from reserved range.  No change in the structure size.
 - IDs defined as SPD values are arrays of bytes.  The spec 
   clarified that they need to be represented as arrays of bytes
   as well.

Patch 1 changes 'struct acpi_nfit_control_region' and the NFIT driver to
comply ACPI 6.1.
Patch 2 adds a new sysfs file "id" to show NVDIMM ID defined in ACPI 6.1.
Patch 3 changes the nfit test driver.

link: http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf

---
v2:
 - Remove 'mfg_location' and 'mfg_date'. (Dan Williams)
 - Rename 'unique_id' to 'id' and make this change as a separate patch.
   (Dan Williams)

---
Toshi Kani (3):
 1/3 ACPI/NFIT: Update Control Region Structure to comply ACPI 6.1
 2/3 ACPI/NFIT: Add NVDIMM ID "id" under sysfs
 3/3 nfit_test: Update SPD ID init handlings

---
 drivers/acpi/nfit.c              | 41 ++++++++++++++++++++-----
 include/acpi/actbl1.h            | 24 +++++++++------
 tools/testing/nvdimm/test/nfit.c | 64 ++++++++++++++++++++++++----------------
 3 files changed, 88 insertions(+), 41 deletions(-)
