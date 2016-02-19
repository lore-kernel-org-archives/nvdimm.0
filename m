Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/2] ACPI 6.1 update for NFIT Control Region Structure
Date: Fri, 19 Feb 2016 16:08:51 -0700
Message-Id: <1455923333-13629-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: robert.moore@intel.com, elliott@hpe.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@acpica.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure
as follows.
 - Valid Fields, Manufacturing Location, and Manufacturing Date
   are added from reserved range.  No change in the structure size.
 - IDs defined as SPD values are arrays of bytes.  The spec 
   clarified that they need to be represented as arrays of bytes
   as well.

Patch 1 changes 'struct acpi_nfit_control_region' and the NFIT driver.
Patch 2 changes the nfit test driver.

link: http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf

---
Toshi Kani (2):
 1/2 ACPI/NFIT: Update Control Region Structure per ACPI 6.1
 2/2 nfit_test: Update SPD ID init handlings

---
 drivers/acpi/nfit.c              | 75 ++++++++++++++++++++++++++++++++++------
 include/acpi/actbl1.h            | 24 ++++++++-----
 tools/testing/nvdimm/test/nfit.c | 64 ++++++++++++++++++++--------------
 3 files changed, 119 insertions(+), 44 deletions(-)
