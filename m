Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B13B821CF1CF3
 for <linux-nvdimm@lists.01.org>; Tue, 20 Feb 2018 10:12:25 -0800 (PST)
Subject: [PATCH v6] ndctl: add option to list firmware information for a DIMM
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 20 Feb 2018 11:18:22 -0700
Message-ID: <151915058813.67767.11669588596758645038.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding firmware output of firmware information when ndctl list -D -F is used.
Components displayed are current firmware version, updated firmware version,
and if a coldboot is required (firmware updated).

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
---

v6:
- changed all instaces of API calls of updated_version to next_version for
  better clarity. Data structure for Intel DSM not changed.
- changed coldboot_required to need_powercycle for better clarity.

v5:
- Changed next_version to updated version to be in sync with DSM spec.
- Changed emission of "unknown" string to -1 for error versions.

v4:
- Remove output when updated_version is 0. That indicates no updated firmware.

v3:
- Fixed issue where it skips displaying rest of the details if there's no
  firmware details.

v2:
- Added copyright
- Added support for human readable option (hex) for versions
- Removed check against CMD_CALL as it's not useful

---

Dave Jiang (1):
      ndctl: add option to list firmware information for a DIMM


 Documentation/ndctl/ndctl-list.txt |   13 +++++
 ndctl/Makefile.am                  |    1 
 ndctl/lib/firmware.c               |    2 -
 ndctl/lib/intel.c                  |   12 ++++-
 ndctl/lib/libndctl.sym             |    2 -
 ndctl/lib/private.h                |    2 -
 ndctl/libndctl.h                   |    2 -
 ndctl/list.c                       |   13 +++++
 ndctl/util/json-firmware.c         |   91 ++++++++++++++++++++++++++++++++++++
 util/json.h                        |    2 +
 10 files changed, 134 insertions(+), 6 deletions(-)
 create mode 100644 ndctl/util/json-firmware.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
