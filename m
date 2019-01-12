Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C8F12119EF50
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:31:06 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 0/4] Add missing firmware_status checks
Date: Fri, 11 Jan 2019 18:30:31 -0700
Message-Id: <20190112013035.32087-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Ami Pathak <ami.g.pathak@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes in v2:
- For the new helper, return original positive rc when we can (Dan)
- Convert previously missed locations to the new submission helper
  (patch 2)
- Add a new patch (4/4) to fix up all callers of ndctl_cmd_submit to
  the correct return convention.

There were several places in ndctl where we neglected to check the
firmware_status from a command submission.

Add an ndctl_dimm_op target to perform error translation for a DSM
family, and provide a new helper - ndctl_cmd_submit_xlat - that will
submit the command and call an error translation routine if one has been
registered. Switch the call sites in ndctl/inject-smart.c and
ndctl/monitor.c over to the new command submission helper.

Finally, clean up all remaining callers of ndctl_cmd_submit to use the
correct return convention, i.e. only treat negative returns as an error,
and accept positive return codes as OK.

Vishal Verma (4):
  libndctl, intel: Add infrastructure for firmware_status translation
  ndctl, inject-smart: switch to ndctl_cmd_submit_xlat
  ndctl, monitor: switch to ndctl_cmd_submit_xlat
  ndctl: clean up usage of ndctl_cmd_submit

 ndctl/inject-smart.c       | 16 ++++++-------
 ndctl/lib/dimm.c           |  6 ++---
 ndctl/lib/inject.c         |  8 +++----
 ndctl/lib/intel.c          | 49 ++++++++++++++++++++++++++++++++++++++
 ndctl/lib/intel.h          |  1 +
 ndctl/lib/libndctl.c       | 28 ++++++++++++++++++++++
 ndctl/lib/libndctl.sym     |  6 +++++
 ndctl/lib/nfit.c           |  2 +-
 ndctl/lib/private.h        |  1 +
 ndctl/libndctl.h           |  3 +++
 ndctl/monitor.c            |  6 ++---
 ndctl/util/json-firmware.c |  2 +-
 ndctl/util/json-smart.c    |  8 +++----
 test/daxdev-errors.c       |  8 +++----
 test/libndctl.c            | 18 +++++++-------
 test/smart-notify.c        |  8 +++----
 16 files changed, 129 insertions(+), 41 deletions(-)

-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
