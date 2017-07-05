Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C10C20958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:23 -0700 (PDT)
Subject: [ndctl PATCH 0/6] ndctl updates for v1.2 namespace labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:48:35 -0700
Message-ID: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Update test/libndctl, init-labels, and read-labels for the new format.

An update to ndctl.h for the new ACPI 6.2 command formats is also
included. A later patch series will implement library helpers for those
new commands.

---

Dan Williams (6):
      ndctl, test: push btt-check test back to 4.14
      ndctl, test: unit test new pmem sector_size support
      ndctl: update to latest ndctl.h
      ndctl, read-labels: updates for v1.2 of the namespace specification
      ndctl, init-labels: allow opt-in to new v1.2 label format
      ndctl, create-namespace: set pmem namespace sector size


 ndctl/dimm.c      |  243 ++++++++++++++++++++++++++++++++++++++++++++---------
 ndctl/namespace.c |   40 +++++----
 ndctl/ndctl.h     |   42 +++++++++
 test/btt-check.sh |    2 
 test/libndctl.c   |   59 ++++++++++---
 5 files changed, 314 insertions(+), 72 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
