Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E394D1A1DF9
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 18:44:30 -0700 (PDT)
Subject: [ndctl PATCH 0/3] device-dax test for recent kernel bugs
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Sep 2016 18:41:27 -0700
Message-ID: <147347168712.15190.17312702584906386275.stgit@dwillia2-desk3.amr.corp.intel.com>
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

These tests trigger the kernel bugs fixed by the following commits:

d0e5845561c2 dax: fix device-dax region base
9049771f7d54 mm: fix cache mode of dax pmd mappings
ca120cf68887 mm: fix show_smap() for zone_device-pmd ranges

---

Dan Williams (3):
      test, device-dax: /proc/self/smaps
      test, device-dax: fix 'skip' reporting when test device not found
      test, device-dax: address translation


 test/device-dax.c |  165 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 util/size.h       |    1 
 2 files changed, 149 insertions(+), 17 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
