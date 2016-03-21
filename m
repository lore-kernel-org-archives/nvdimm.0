Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6213.austin.hp.com (g1t6213.austin.hp.com [15.73.96.121])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D6801A1F54
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 12:37:53 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v8 00/10] nvdimm: Add an IOCTL pass thru for DSM calls
Date: Mon, 21 Mar 2016 13:37:00 -0600
Message-Id: <cover.1458583367.git.jerry.hoemann@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


The NVDIMM code in the kernel supports an IOCTL interface to user
space based upon the Intel Example DSM:

	http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

This interface cannot be used by other NVDIMM DSMs that support
incompatible functions.

An alternative DSM specification for Type N DSM being developed
by Hewlett Packard Enterprise can be found at:

	https://github.com/HewlettPackard/hpe-nvm/tree/master/Documentation

To accommodate multiple and conflicting DSM specifications, this patch
set adds a generic "pass-thru" IOCTL interface which is not tied to
a particular DSM.

A new _IOC_NR ND_CMD_CALL == "10" is added for the pass thru call.

The new data structure nd_cmd_pkg serves as a wrapper for the
pass-thru calls.  This wrapper supplies the data that the kernel
needs to make the _DSM call.

Unlike the definitions of the _DSM functions themselves, the nd_cmd_pkg
provides the calling information (input/output sizes) in an uniform
manner making the kernel marshaling of the arguments straight
forward.

This shifts the marshaling burden from the kernel to the user
space application while still permitting the kernel to internally
call _DSM functions.

The kernel functions __nd_ioctl and acpi_nfit_ctl were modified
to accommodate ND_CMD_CALL.

Changes in version 8:
---------------------
1. augmented family_to_uuid() to return uuid.  This to address bug
   in prior version where acpi_nfit_ctl wasn't updating uuid
   with value associated with command family.

2. patch 0006 changes name of nvdimm_bus_descriptor.dsm_mask to .cmd_mask

3. patch 0008 adds field cmd_ioctl if kernel supports full ioctl
   as with Intel example dsm.

4. patch 0009 make determination if kernel supports the full
   cmd_ioctl for that dsm.  Updates the commands_show function
   to invert the sense of display of commands.  All dsm support
   pass-thru, only the Intel Example DSM supports the full
   ioctl interface.

5. patch 0010 adds explicit ioctl interface to return command mask.
   This was done in part to avoid "unknown" command in sysfs.



Changes in version 7:
--------------------
0. change name ND_CMD_CALL_DSM to ND_CMD_CALL
    - part of abstracting out DSM missed in version 6.

1. change name in struct nd_call_dsm
    a) "ncp_" -> "nd_"
    b) ncp_pot_size -> nd_fw_size
    c) ncp_type -> nd_family
    o) cascade name changes to other patches

2. Expanded comment around data structure nd_cmd_pkg

3. At Dan's request, hard coding "root" UUID.
    a) retract extension of dsm_uuid to nvdimm_bus_descriptor.
    b) reverted nfit.c/acpi_nfit_init_dsms() with the exception of
	allowing function 0 in mask.

4. At Dan's request, removed "rev" from nd_cmd_pkg.  Hard-coding
    use of rev "1" in acpi_nfit_ctl.


Changes in version 6:
---------------------
Built against
git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git
libnvdimm-pending

0. Patches "Clean-up access mode check" and "Fix security issue with DSM IOCTL"
   already in above libnvdimm-pending.  So omitted here.

1. Incorporated changes from Dan's RFC patch set
   https://lists.01.org/pipermail/linux-nvdimm/2016-January/004049.html

2. Dan asked me to abstract out the DSM aspects from the ndm_cmd_dsmcall_pkg.
   This became nd_cmd_pkg.  UUIDs are no longer passed in from
   user applications.

3. To accommodate multiple UUIDS, added table cmd_type_tbl which is used
   to determine UUID for the acpi object by calling function 0 for
   each UUID in table until success.

   This table also provides a MASK field that the kernel can use
   to exclude functions being called.

   This table can be thought of a list of "acceptable" DSMs.

4. The cmd_type_tbl is also used by acpi_nfit_ctl to map the
   external handle of calls to internal handle, UUID.

   Note, code only validates that the requested type of call is one in
   cmd_type_tbl, but it might not necessarily be the same found during
   acpi_nfit_add_dimm.  The ACPI SPEC appears to allow and firmware
   does implement multiple UUID per object.

   In the case where type is in table, but the UUID isn't supported
   by the underlying firmware, firmware shall return an error when
   called.

   This allows for use of a secondary DSM on an object.  This could
   be considered a feature or a defect.  This can be tightened
   up if needed.



Changes in version 5:
---------------------
0. Fixed submit comment for drivers/acpi/utils.c.


Changes in version 4:
---------------------
0. Added patch to correct parameter type passed to acpi_evaluate_dsm
   ACPI defines arguments rev and fun as 64 bit quantities and the ioctl
   exports to user face rev and func. We want those to match the ACPI spec.

   Also modified acpi_evaluate_dsm_typed and acpi_check dsm which had
   similar issue.

1. nd_cmd_dsmcall_pkg rearrange a reserve and rounded up total size
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
  of the _DSM data as the user space buffer would accommodate.

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
3. Adjust sizes in nd_passthru_pkg. DSM integers are 64 bit.
4. No new ioctl type, instead tunnel into the existing number space.
5. Push down one function level where determine ioctl cmd type.
6. re-work diagnostic print/dump message in pass-thru functions.

Jerry Hoemann (10):
  ACPI / util: Fix acpi_evaluate_dsm() argument type
  nvdimm: Add wrapper for IOCTL pass thru
  nvdimm: Increase max envelope size for IOCTL
  nvdimm: Add UUIDs
  nvdimm: Add IOCTL pass thru functions
  libnvdimm: nvdimm_bus_descriptor field name change
  tools/testing/nvdimm: 'call_dsm' support
  nvdimm: command ioctl support
  nvdimm: sysfs shows which dsm support full command ioctl.
  nvdimm: Add ioctl to return command mask.

 drivers/acpi/nfit.c              | 154 +++++++++++++++++++++++++++++++++------
 drivers/acpi/nfit.h              |   6 ++
 drivers/acpi/utils.c             |   4 +-
 drivers/nvdimm/bus.c             |  55 +++++++++++++-
 drivers/nvdimm/core.c            |   3 +-
 drivers/nvdimm/dimm_devs.c       |  12 ++-
 drivers/nvdimm/nd-core.h         |   1 +
 include/acpi/acpi_bus.h          |   6 +-
 include/linux/libnvdimm.h        |   6 +-
 include/uapi/linux/ndctl.h       |  62 ++++++++++++++++
 tools/testing/nvdimm/test/nfit.c |  15 +++-
 11 files changed, 283 insertions(+), 41 deletions(-)

-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
