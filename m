Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A624209859A3
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 13:24:36 -0700 (PDT)
Subject: [PATCH v6 0/4] ndctl: convert actions to use util_filter_walk
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 11 May 2018 13:24:36 -0700
Message-ID: <152607009656.4523.5355287262776399070.stgit@djiang5-desk3.ch.intel.com>
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
v6:
- removed unintended changes (Vishal)
- added common function filter_bus_passhthrough() (Vishal, Dan)

v5:
- fix behavior regression in filter_namespace (Dan)
- fix segfault caused by no namespace for create_namespace actions.

v4:
- change struct names to be less confusing. (Dan)

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


 ndctl/dimm.c      |   78 +++++++++++++---------
 ndctl/namespace.c |  189 +++++++++++++++++++++++++++++------------------------
 ndctl/region.c    |   54 +++++++++------
 util/filter.c     |   11 +++
 util/filter.h     |   25 +++++++
 5 files changed, 212 insertions(+), 145 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
