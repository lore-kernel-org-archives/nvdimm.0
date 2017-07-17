Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3528A21B06E71
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jul 2017 10:10:25 -0700 (PDT)
Subject: [PATCH] MAINTAINERS: list drivers/acpi/nfit/ files for libnvdimm
 sub-system
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Jul 2017 10:05:52 -0700
Message-ID: <150031115197.22823.18044115417154054780.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Patches that update the drivers/acpi/nfit/ directory need to be copied
to the nvdimm mailing list. The drivers/acpi/nfit* glob has been broken
ever since the nfit driver source was refactored into multiple files
under the drivers/acpi/nfit/ directory.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f6ec1be48609..9a9c49bcacd6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7702,6 +7702,7 @@ Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
 S:	Supported
 F:	drivers/nvdimm/*
+F:	drivers/acpi/nfit/*
 F:	include/linux/nd.h
 F:	include/linux/libnvdimm.h
 F:	include/uapi/linux/ndctl.h
@@ -7713,7 +7714,6 @@ Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/blk.c
 F:	drivers/nvdimm/region_devs.c
-F:	drivers/acpi/nfit*
 
 LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
