Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0573C21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:16 -0800 (PST)
Subject: [ndctl PATCH 00/16] ndctl: update SMART support for
 NVDIMM_FAMILY_INTEL
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:24:29 -0800
Message-ID: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Lijun Pan <Lijun.Pan@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

The v1.6 release of the NVDIMM_FAMILY_INTEL DSM specification [1]
updates the format of the 'SMART Threshold Command' payload and
introduces the 'SMART Set Threshold Command'. Given that the new SMART
Threshold format is broken with respect to the initial / generic
ND_IOCTL_SMART_THRESHOLD format the generic SMART commands are now
deprecated. The NVDIMM_FAMILY_INTEL SMART support is updated to use
the ND_IOCTL_CALL path similar to how libndctl abstracts the per vendor
differences of the NVDIMM_FAMILY_{HPE1,MSFT} SMART implementations.

Included in this overhaul is better infrastructure for supporting the
rest of the v1.6 DSMs that need to go through the ND_IOCTL_CALL
interface.

Note, the v1.6 specification also includes a 'SMART Error Injection'
facility, but that enabling is deferred for a later update and will be
integrated with the 'ndctl inject-error' command.

[1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf

---

Dan Williams (16):
      libndctl: rename dimm dsm_mask to cmd_mask
      libndctl: add nfit_dsm_mask as a private dimm property
      ndctl, smart: rename 'temperature' helpers to 'media_temperature'
      ndctl, intel: switch to ND_CMD_CALL passthrough for SMART commands
      ndctl: remove support for compiling against the kernel ndctl.h header
      ndctl, test: emit smart field names
      ndctl, smart: cleanup smart_cmd_op() macro
      ndctl, test: reset all nfit_test data for each test/libndctl run
      ndctl, region: cleanup error message
      ndctl: support set smart alarm/threshold
      ndctl: refactor 'smart_ops' into generic 'dimm_ops'
      ndctl, debug: improve do_cmd output for ND_CMD_CALL
      ndctl, list: teach the list command about the 'fsdax' and 'devdax' modes
      ndctl, smart: move smart temperature parsing to a library routine
      ndctl, test: trigger notifications
      ndctl, test: listen for smart notifications


 Documentation/ndctl/ndctl-list.txt |    2 
 configure.ac                       |  120 -------------
 ndctl.spec.in                      |    4 
 ndctl/Makefile.am                  |    5 -
 ndctl/check.c                      |    7 -
 ndctl/inject-error.c               |    6 -
 ndctl/lib/Makefile.am              |   22 +-
 ndctl/lib/ars.c                    |    9 -
 ndctl/lib/hpe1.c                   |   24 ++-
 ndctl/lib/intel.c                  |  334 ++++++++++++++++++++++++++++++++++++
 ndctl/lib/intel.h                  |   82 +++++++++
 ndctl/lib/libndctl.c               |  114 +++++++-----
 ndctl/lib/libndctl.sym             |   12 +
 ndctl/lib/msft.c                   |   11 +
 ndctl/lib/private.h                |   80 ++++-----
 ndctl/lib/smart.c                  |  206 ++++++----------------
 ndctl/libndctl.h                   |  190 +++++---------------
 ndctl/list.c                       |    9 +
 ndctl/namespace.c                  |    9 -
 ndctl/ndctl.h                      |   59 ------
 ndctl/region.c                     |    2 
 ndctl/util/json-smart.c            |   24 ---
 test.h                             |    3 
 test/Makefile.am                   |    7 +
 test/blk_namespaces.c              |    9 -
 test/core.c                        |   25 +++
 test/daxdev-errors.c               |    6 -
 test/dpa-alloc.c                   |    9 -
 test/dsm-fail.c                    |    6 -
 test/libndctl.c                    |  118 ++++++++-----
 test/multi-pmem.c                  |    7 -
 test/parent-uuid.c                 |    2 
 test/pmem_namespaces.c             |    7 -
 test/smart-listen.c                |  109 ++++++++++++
 test/smart-notify.c                |  220 ++++++++++++++++++++++++
 util/json.c                        |    5 -
 util/json.h                        |    8 -
 37 files changed, 1130 insertions(+), 742 deletions(-)
 create mode 100644 ndctl/lib/intel.c
 create mode 100644 ndctl/lib/intel.h
 rename ndctl/{libndctl.h.in => libndctl.h} (89%)
 create mode 100644 test/smart-listen.c
 create mode 100644 test/smart-notify.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
