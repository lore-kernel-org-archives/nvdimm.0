Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v5 0/6] nvdimm: Add an IOCTL pass thru for DSM calls
Date: Wed,  6 Jan 2016 16:03:37 -0700
Message-Id: <cover.1452121277.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
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
call _DSM functions.

The kernel functions __nd_ioctl and acpi_nfit_ctl were modified
to accomodate ND_CMD_CALL_DSM.


Changes in version 5:
---------------------
0. Fixed submit comment for drivers/acpi/utils.c.


Changes in version 4:
---------------------
0. Added patch to correct parameter type passed to acpi_evaluate_dsm
   ACPI defines arguments rev and fun as 64 bit quanties and the ioctl
   exports to user face rev and func. We want those to match the ACPI spec.

   Also modified acpi_evaluate_dsm_typed and acpi_check dsm which had
   similar issue.

1. nd_cmd_dsmcall_pkg rearange a reserve and rounded up total size
   to 16 byte boundary.

2. Created stand alone patch for the pre-existing security issue related
   to "read only" IOCTL calls.

3. Added patch for increasing envelope size of IOCTL.  Needed to
   be able to read in the wrapper to know remaining size to copy in.

   Note: in_env, out_env are statics sized based upon this change.

4. Moved copyin code to table driven nd_cmd_desc 

  Note, the last 40 lines or so of acpi_nfit_ctl will not return _DSM
  data unless the size allocated in user space buffer equals
  out_obj->buffer.length.

  The semantic we want in the pass thru case is to return as much
  of the _DSM data as the user space buffer would accomodate.

  Hence, in acpi_nfit_ctl I have retained the line:

		memcpy(pkg->dsm_buf + pkg->h.dsm_in,
			out_obj->buffer.pointer,
			min(pkg->h.dsm_size, pkg->h.dsm_out));

  and the early return from the function.




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




Jerry Hoemann (6):
  ACPI / util: Fix acpi_evaluate_dsm() argument type
  nvdimm: Clean-up access mode check.
  nvdimm: Add wrapper for IOCTL pass thru
  nvdimm: Fix security issue with DSM IOCTL.
  nvdimm: Increase max envelope size for IOCTL
  nvdimm: Add IOCTL pass thru functions

 drivers/acpi/nfit.c        | 52 ++++++++++++++++++++++++++---------
 drivers/acpi/utils.c       |  4 +--
 drivers/nvdimm/bus.c       | 67 +++++++++++++++++++++++++++++++++++++---------
 include/acpi/acpi_bus.h    |  6 ++---
 include/linux/libnvdimm.h  |  2 +-
 include/uapi/linux/ndctl.h | 19 +++++++++++++
 6 files changed, 118 insertions(+), 32 deletions(-)

-- 
1.7.11.3

