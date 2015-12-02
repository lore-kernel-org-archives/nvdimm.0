Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 0/3] nvdimm: Add an IOCTL pass thru for DSM calls
Date: Wed,  2 Dec 2015 14:05:18 -0700
Message-Id: <cover.1449089647.git.jerry.hoemann@hpe.com>
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

A new _IOC_NR ND_CMD_CALL_DSM == "10" is added for the pass thru call.

The new data structure nd_cmd_dsmcall_pkg serves as a wrapper for
the passthru calls.  This wrapper supplies the data that the kernel
needs to make the _DSM call.

Unlike the definitions of the _DSM functions themselves, the nd_cmd_dsmcall_pkg
provides the calling information (input/output sizes) in an uniform
manner making the kernel marshaling of the arguments straight
forward.

This shifts the marshaling burden from the kernel to the user
space application while still permitting the kernel to internally
calling _DSM functions.

The kernel functions __nd_ioctl and acpi_nfit_ctl were modified
to accomodate ND_CMD_CALL_DSM.

These changes are based upon the 4.3 kernel.


Changes in version 3:
---------------------
1. Changed name ND_CMD_PASSTHRU to ND_CMD_CALL_DSM.

2. Value of ND_CMD_CALL_DSM is 10, not 100.

3. Changed name of nd_passthru_pkg to nd_cmd_dsmcall_pkg.

4. Removed separate functions for handling ND_CMD_CALL_DSM.
   Moved functionality to __nd_ioctl and acpi_nfit_ctl proper.
   The resultant code looks very different from prior versions.

5. BUGFIX: __nd_ioctl: Change the if read_only switch to use
	 _IOC_NR cmd (not ioctl_cmd) for better protection.

	Do we want to make a stand alone patch for this issue?


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

 drivers/acpi/nfit.c        | 109 ++++++++++++++++++++++++++++-----------------
 drivers/nvdimm/bus.c       |  73 +++++++++++++++++++++---------
 include/uapi/linux/ndctl.h |  18 ++++++++
 3 files changed, 139 insertions(+), 61 deletions(-)

-- 
1.7.11.3

