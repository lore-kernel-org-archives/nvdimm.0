Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 021A12265A19B
 for <linux-nvdimm@lists.01.org>; Wed, 18 Apr 2018 15:04:09 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, documentation: add inject-smart to the Makefile
Date: Wed, 18 Apr 2018 16:04:02 -0600
Message-Id: <20180418220402.17600-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Jacek Zloch <jacek.zloch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

We neglected adding the inject-smart man page to the documentation
Makefile, resulting in the man page never getting generated.

Reported-by: Jacek Zloch <jacek.zloch@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 4f04087..fab05b9 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -33,6 +33,7 @@ man1_MANS = \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
 	ndctl-inject-error.1 \
+	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
 	ndctl-list.1
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
