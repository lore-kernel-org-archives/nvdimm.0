Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1ED9021A04826
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 14:46:20 -0700 (PDT)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH v2] ndctl: Add package dependency information
Date: Fri, 31 Mar 2017 17:45:58 -0400
Message-ID: <1490996758-2156-1-git-send-email-linda.knippers@hpe.com>
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

To help people avoid discovering the required packages
as a result of configure failures, add a reference to
BuildRequires infomation.

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 README.md | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README.md b/README.md
index 38fc050..b4b3612 100644
--- a/README.md
+++ b/README.md
@@ -11,6 +11,10 @@ Build
 `make check`  
 `sudo make install`  
 
+There are a number of packages required for the build steps that
+may not be installed by default.   For information about the required
+packages, look at the "BuildRequires:" lines in ndctl.spec.in.
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
