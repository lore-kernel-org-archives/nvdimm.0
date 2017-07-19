Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 268C721D0B67E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:27 -0700 (PDT)
Subject: [ndctl PATCH 0/6] multi-device-dax support and other fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:32:56 -0700
Message-ID: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A test report highlighted the fact that the unit tests never verified
that multiple-namespaces in a region could be in device-dax mode. This
was fixed in the kernel [1], but there is some fallout to handle in
ndctl and daxctl:

1/ teach libdaxctl that there may be multiple dax-region instances that
   share the same region-id

2/ update 'ndctl list' to assume that there will only ever be one
   device-dax instance per-namespace and emit the "chardev" by default
   (Linda).

3/ fix 'daxctl list' to differentiate regions by path, since 'id' may be
   duplicated.

4/ add a regression test for multi-dax configurations

---

Dan Williams (6):
      ndctl, daxctl: propagate loglevel to internal libdaxctl instance
      daxctl: stop carrying 'dax_region' in the daxctl_region region_path
      daxctl: fix support for multiple instances per-region id
      ndctl, list: emit device-dax 'chardev' by default
      daxctl, list: clarify output when multiple regions share an id
      test: add multi-dax test


 daxctl/lib/libdaxctl.c   |   78 ++++++++++++++++++++++++++++++++++------------
 daxctl/lib/libdaxctl.sym |    5 +++
 daxctl/libdaxctl.h       |    2 +
 daxctl/list.c            |    2 +
 ndctl/lib/libndctl.c     |    2 +
 ndctl/list.c             |    2 +
 ndctl/namespace.c        |    2 +
 test/Makefile.am         |    1 +
 test/multi-dax.sh        |   61 ++++++++++++++++++++++++++++++++++++
 util/json.c              |   34 ++++++++++++++++++--
 util/json.h              |    3 +-
 11 files changed, 165 insertions(+), 27 deletions(-)
 create mode 100755 test/multi-dax.sh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
