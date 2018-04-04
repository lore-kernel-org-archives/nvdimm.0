Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7776C22526491
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:21:52 -0700 (PDT)
Subject: [ndctl PATCH 0/5] Address Range Scrub (ARS) Utilities
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 14:11:56 -0700
Message-ID: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add ndctl utility support for listing the state of ARS operations,
waiting for an existing ARS run to complete, and initiating new ARS
runs. A few fixes and new apis fall out as a result.

---

Dan Williams (5):
      ndctl, scrub: fix ndctl_bus_wait_for_scrub_completion()
      ndctl, scrub: report the bus scrub state in 'ndctl list'
      ndctl, scrub: add ndctl_bus_start_scrub()
      ndctl: add new START and WAIT actions
      ndctl, scrub: add {wait,start}-scrub helper utilities


 Documentation/ndctl/Makefile.am           |    3 +
 Documentation/ndctl/ars-description.txt   |    9 ++
 Documentation/ndctl/ndctl-start-scrub.txt |   61 ++++++++++++++
 Documentation/ndctl/ndctl-wait-scrub.txt  |   61 ++++++++++++++
 builtin.h                                 |    2 
 ndctl/Makefile.am                         |    1 
 ndctl/action.h                            |    2 
 ndctl/bus.c                               |  129 +++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c                      |  107 ++++++++++++++++--------
 ndctl/lib/libndctl.sym                    |    2 
 ndctl/libndctl.h                          |    2 
 ndctl/namespace.c                         |    3 +
 ndctl/ndctl.c                             |    2 
 util/json.c                               |   10 ++
 14 files changed, 359 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/ndctl/ars-description.txt
 create mode 100644 Documentation/ndctl/ndctl-start-scrub.txt
 create mode 100644 Documentation/ndctl/ndctl-wait-scrub.txt
 create mode 100644 ndctl/bus.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
