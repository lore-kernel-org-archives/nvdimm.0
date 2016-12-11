Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB7C882081
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:38:45 -0800 (PST)
Subject: [ndctl PATCH 0/6] updates for device-dax sub-division support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:34:36 -0800
Message-ID: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Towards being able to script discovery, allocation, and resizing of
device dax instances, extend the libdaxctl apis for pending 4.10 kernel
updates.

---

Dan Williams (6):
      util, sysfs: convert add_dev_fn to return the device
      libdaxctl: add daxctl_region_get_{id,size,align} apis
      daxctl: add dax region iteration apis
      ndctl: add per-context private data
      test, daxctl: test dax region apis
      daxctl: add daxctl_dev_set_size()


 daxctl/lib/libdaxctl-private.h |    4 +
 daxctl/lib/libdaxctl.c         |  217 ++++++++++++++++++++++++++++++++++------
 daxctl/lib/libdaxctl.sym       |   18 +++
 daxctl/libdaxctl.h             |   12 ++
 ndctl/lib/libndctl-private.h   |    2 
 ndctl/lib/libndctl.c           |  122 ++++++++++------------
 ndctl/lib/libndctl.sym         |    2 
 ndctl/libndctl.h.in            |    2 
 test/libndctl.c                |   68 ++++++++++++-
 util/sysfs.c                   |   15 +--
 util/sysfs.h                   |    2 
 11 files changed, 350 insertions(+), 114 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
