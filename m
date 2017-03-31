Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 468F921A0483E
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 13:23:10 -0700 (PDT)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH] ndctl: Add some package dependency information to README.md
Date: Fri, 31 Mar 2017 16:22:18 -0400
Message-ID: <1490991738-29637-1-git-send-email-linda.knippers@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Rather than discover the required packages as a result
of configure failures, provide some hints in advance.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 README.md | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/README.md b/README.md
index 38fc050..e31fab4 100644
--- a/README.md
+++ b/README.md
@@ -11,6 +11,12 @@ Build
 `make check`  
 `sudo make install`  
 
+There are a number of packages required for the build steps that may not be installed by default.  These will be found during the first two steps.
+
+While not a complete list, the packages required to build on Fedora include:
+autogen, libtool, asciidoc, xmlto, kmod-devel, systemd-devel,libuuid-devel, json-c-devel
+The OpenSUSE package list is similar.
+
 Documentation
 =============
 See the latest documentation for the NVDIMM kernel sub-system here:
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
