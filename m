Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id B593D1A1E1C
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 16:45:52 -0800 (PST)
Subject: [ndctl PATCH 0/3] ndctl: clear error support for v52
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Mar 2016 16:45:11 -0800
Message-ID: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Add libndctl support for the new "clear error" command based on section
9.20.7.6 "Function Index 4 - Clear Uncorrectable Error" from the ACPI
6.1 specification.  This uncovered some minor address-range-scrub
command fixups.

---

Dan Williams (3):
      ndctl: fix ndctl_bus_cmd_new_ars_status() input validation
      ndctl: disable nfit_test regions after test
      ndctl: add 'clear error' command support


 configure.ac           |   19 +++++++
 lib/libndctl-ars.c     |  127 ++++++++++++++++++++++++++++++++++++++++++------
 lib/libndctl-private.h |    5 ++
 lib/libndctl.c         |    3 +
 lib/libndctl.sym       |    3 +
 lib/ndctl/libndctl.h   |   41 +++++++++++++++
 ndctl.h                |   13 +++++
 test/libndctl.c        |   68 +++++++++++++++++++++++++-
 8 files changed, 259 insertions(+), 20 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
