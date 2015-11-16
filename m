Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 0/3] nvdimm: Add an IOCTL pass thru for DSM calls
Date: Mon, 16 Nov 2015 11:38:16 -0700
Message-Id: <cover.1447698598.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>


The NVDIMM code in the kernel supports an IOCTL interface to user
space based upon the Intel Example DSM:

	http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

This interface cannot be used by other NVDIMM DSMs that support
incompatible functions.

This patch set adds a generic "passthru" IOCTL interface which
is not tied to a particular DSM.

A new _IOC_NR ND_CMD_PASSTHRU == "100" is added for the pass thru call.

The new data structure nd_passthru_pkg serves as a wrapper for the passthru
calls.  This wrapper supplies the data that the kernel needs to
make the _DSM call.

Unlike the definitions of the _DSM functions themselves, the nd_passthru_pkg
provides the calling information (input/output sizes) in an uniform
manner making the kernel marshaling of the arguments straight
forward.

This shifts the marshaling burden from the kernel to the user
space application while still permitting the kernel to internally
call _DSM functions.

To make the resultant kernel code easier to understand the existing
functions acpi_nfit_ctl and __nd_ioctl were renamed to .*_intel to
denote calling mechanism as in 4.3 tailored to the Intel Example DSM.
New functions acpi_nfit_ctl_passthru and __nd_ioctl_passthru were
created to supply the pass thru interface.


These changes are based upon the 4.3 kernel.


Changes in version 2:
---------------------
1. Cleanup access mode check in nd_ioctl and nvdimm_ioctl.
2. Change name of ndn_pkg to nd_passthru_pkg
3. Adjust sizes in nd_passthru_pkg. DSM intergers are 64 bit.
4. No new ioctl type, instead tunnel into the existing number space.
5. Push down one function level where determine ioctl cmd type.
6. re-work diagnostic print/dump message in pass-thru functions.



Jerry Hoemann (3):
  nvdimm: Clean-up access mode check.
  nvdimm: Add wrapper for IOCTL pass thru
  nvdimm: Add IOCTL pass thru functions

 drivers/acpi/nfit.c        |  93 ++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/bus.c       | 101 +++++++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/ndctl.h |  16 +++++++
 3 files changed, 202 insertions(+), 8 deletions(-)

-- 
1.7.11.3

