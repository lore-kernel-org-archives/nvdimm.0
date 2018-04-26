Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F476203B8FF3
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 11:17:04 -0700 (PDT)
Subject: [PATCH v3 0/4] convert actions to use util_filter_walk
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 26 Apr 2018 11:17:02 -0700
Message-ID: <152476632250.70161.9698682147434730585.stgit@djiang5-desk3.ch.intel.com>
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

util_filter_walk() does the looping through bus/dimm/region/namespace
that a lot of the operations in ndctl uses. Converting them to common
code and reduce maintenance on individual versions of the same code.
In this series we are convering namespace, region, and dimm actions.

---
v3:
- fixed some corner cases in namespace patch.
- changed param renaming to reduce change for util_filter_params. (Dan)
- Adding conversion to region
- Adding conversion to dimm

v2:
- split out the conversion of util_filter_params to make things more
  readable (Dan).
- Not pass in mode as util_filter_params and put back the mode check in
  util_filter_walk() (Dan).

Dave Jiang (4):
      ndctl: convert namespace actions to use util_filter_params
      ndctl: convert namespace actions to use util_filter_walk()
      ndctl: convert region actions to use util_filter_walk()
      ndctl: convert dimm actions to use util_filter_walk()


 ndctl/dimm.c      |   83 ++++++++++++++---------
 ndctl/namespace.c |  195 +++++++++++++++++++++++++++++------------------------
 ndctl/region.c    |   59 ++++++++++------
 test/btt-check.sh |    2 -
 util/filter.c     |    5 +
 util/filter.h     |   23 ++++++
 6 files changed, 221 insertions(+), 146 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
