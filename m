Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 0/4] nvdimm: Add an IOCTL pass thru for DSM calls
Date: Fri,  6 Nov 2015 15:27:27 -0700
Message-Id: <cover.1446684001.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

The NVDIMM code in the kernel supports an IOCTL interface to user
space based upon the Intel Example DSM:

	http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

This interface cannot be used by other NVDIMM DSMs that support
incompatible functions.

This patch set adds a generic "passthru" IOCTL interface which
is not tied to a particular DSM.

A new IOCTL type "P" is added for the pass thru call.

The new data structure ndn_pkg serves as a wrapper for the passthru
calls.  This wrapper supplies the data that the kernel needs to
make the _DSM call.

Unlike the definitions of the _DSM functions themselves, the ndn_pkg
provides the calling information (input/output sizes) in an uniform
manner making the kernel marshaling of the arguments straight
forward.

This shifts the marshaling burden from the kernel to the user
space application while still permitting the kernel to internally
calling _DSM functions.

To make the resultant kernel code easier to understand the existing
functions acpi_nfit_ctl and __nd_ioctl were renamed to .*_intel to
denote calling mechanism as in 4.2 tailored to the Intel Example DSM.
New functions acpi_nfit_ctl_passthru and __nd_ioctl_passthru were
created to supply the pass thru interface.


These changes are based upon the 4.3 kernel.


Jerry Hoemann (4):
  nvdimm: Add wrapper for IOCTL pass thru.
  nvdimm: Add IOCTL pass thru
  nvdimm: Add IOCTL pass thru
  nvdimm: rename functions that aren't IOCTL passthru

 drivers/acpi/nfit.c        |  91 ++++++++++++++++++++++++++++++++--
 drivers/nvdimm/bus.c       | 118 +++++++++++++++++++++++++++++++++++++++++----
 drivers/nvdimm/dimm_devs.c |   6 +--
 include/linux/libnvdimm.h  |   3 +-
 include/uapi/linux/ndctl.h |  20 +++++++-
 5 files changed, 220 insertions(+), 18 deletions(-)

-- 
1.7.11.3

