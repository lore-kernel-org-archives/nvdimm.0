Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C768211B6C1D
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 14:53:51 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/3] Add missing firmware_status checks
Date: Fri, 11 Jan 2019 15:53:36 -0700
Message-Id: <20190111225339.6939-1-vishal.l.verma@intel.com>
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

There were several places in ndctl where we neglected to check the
firmware_status from a command submission.

Add an ndctl_dimm_op target to perform error translation for a DSM
family, and provide a new helper -ndctl_cmd_submit_xlat - that will
submit the command and call an error translation routing if one has been
registered.

Finally, switch the call sites in ndctl/inject-smart.c and
ndctl/monitor.c over to the new command submission helper.

Vishal Verma (3):
  libndctl, intel: Add infrastructure for firmware_status translation
  ndctl, inject-smart: switch to ndctl_cmd_submit_xlat
  ndctl, monitor: switch to ndctl_cmd_submit_xlat

 ndctl/inject-smart.c   |  8 +++----
 ndctl/lib/intel.c      | 49 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/intel.h      |  1 +
 ndctl/lib/libndctl.c   | 26 ++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  6 ++++++
 ndctl/lib/private.h    |  1 +
 ndctl/libndctl.h       |  3 +++
 ndctl/monitor.c        |  4 ++--
 8 files changed, 92 insertions(+), 6 deletions(-)

-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
