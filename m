Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id F02D21A1E02
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 16:58:08 -0700 (PDT)
Subject: [ndctl PATCH 0/2] ACPI 6.1 DIMM id support
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2016 16:57:19 -0700
Message-ID: <146171495520.32030.11537526996792266896.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Following Toshi's patches to add a sysfs attribute for DIMM ids, plumb
this new attribute into libndctl and the 'ndctl list' utility.

---

Dan Williams (2):
      ndctl: add ndctl_dimm_get_unique_id() api
      ndctl, list: add 'id' to the dimm listing


 lib/libndctl.c          |   38 +++++++++++++++++++++++++++++++-------
 lib/libndctl.sym        |    1 +
 lib/ndctl/libndctl.h.in |    1 +
 util/json.c             |    8 ++++++++
 4 files changed, 41 insertions(+), 7 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
