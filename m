Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E48E21F322B4
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 16:00:21 -0700 (PDT)
Subject: [PATCH 0/3] libnvdimm: fix physical address disclosure
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Sep 2017 15:57:10 -0700
Message-ID: <150646662980.6588.6123788075203842948.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Physical address information should be restricted to root. This is
consistent with the policy of /proc/iomem and /sys/firmware/acpi/tables.

---

Dan Williams (3):
      libnvdimm, region : make 'resource' attribute only readable by root
      libnvdimm, namespace: make 'resource' attribute only readable by root
      libnvdimm, pfn: make 'resource' attribute only readable by root


 drivers/nvdimm/namespace_devs.c |    2 +-
 drivers/nvdimm/pfn_devs.c       |    8 ++++++++
 drivers/nvdimm/region_devs.c    |    8 ++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
