Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 605691A1FAC
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 18:07:50 -0700 (PDT)
Subject: [ndctl PATCH 0/5] smart support and 'list' enhancements
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 18:06:59 -0700
Message-ID: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
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

1/ Provide helper routines for higher level management software to issue
   SMART data retrieval commands.

2/ Add a reference implementation of SMART data retrieval by extending
   the 'list' command to emit json with SMART key/value data.

3/ With health information available it is useful to know which
   namespaces are impacted by a dimm that reports a bad health status,
   so a 'filter by dimm' mechanism is added to the 'list' command.

---

Dan Williams (5):
      ndctl: rebuild libndctl.h when libndctl.h.in changes
      ndctl: helper for S.M.A.R.T. data retrieval
      ndctl, list: clean up default behavior
      ndctl, list: add a '--health' option
      ndctl, list: add 'filter by dimm' capability


 Documentation/ndctl-list.txt |   29 ++++++++++++-
 Makefile.am                  |    8 +++
 builtin-list.c               |   31 +++++++++++--
 configure.ac                 |   26 +++++++++++
 lib/libndctl-private.h       |    1 
 lib/libndctl-smart.c         |   81 +++++++++++++++++++++++++++++++++++
 lib/libndctl.c               |    1 
 lib/libndctl.sym             |   10 ++++
 lib/ndctl/libndctl.h.in      |   55 ++++++++++++++++++++++++
 ndctl.h                      |   29 +++++++++++++
 test/libndctl.c              |   68 +++++++++++++++++++++++++++++
 util/filter.c                |   83 ++++++++++++++++++++++++++++++++++++
 util/filter.h                |    5 ++
 util/json.c                  |   97 ++++++++++++++++++++++++++++++++++++++++++
 util/json.h                  |    1 
 15 files changed, 516 insertions(+), 9 deletions(-)
 create mode 100644 lib/libndctl-smart.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
