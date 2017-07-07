Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41F5D21B02BAF
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 13:41:53 -0700 (PDT)
Subject: [ndctl PATCH 0/2] Be kind to humans
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Jul 2017 13:37:08 -0700
Message-ID: <149945982889.8106.13607379131149182964.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

Prompted by Yasunori's patch to add a few more fields to the "ndctl list
--dimm" output we realized it would be nice to have listings be more
user-friendly by default. These patches take advantage of json-c's
ability to specify a custom object serializer so that we can select
'human' vs 'machine' friendly output.

This of course opens the door to things like colorized output to reflect
the health state of a dimm.

---

Dan Williams (2):
      ndctl, list: convert json control flags to bit-flags
      ndctl, daxctl, list: make terminal output human readable by default


 Documentation/daxctl/daxctl-list.txt |   21 ++++
 Documentation/ndctl/ndctl-list.txt   |   30 ++++++
 daxctl/list.c                        |   36 +++++++-
 ndctl/list.c                         |   59 ++++++++++--
 ndctl/namespace.c                    |    6 +
 util/json.c                          |  162 ++++++++++++++++++++++++++--------
 util/json.h                          |   25 ++++-
 7 files changed, 279 insertions(+), 60 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
