Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 059E6210ED0FC
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 17:06:48 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, prepare-release.sh: fix revision update checks
Date: Fri, 10 Aug 2018 18:06:15 -0600
Message-Id: <20180811000615.11788-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

The libtool versioning checks only need to prompt for a 'REVISION'
update if the library source changed. We were triggering that check even
if the utility source had changed. Fix by changing $libdir to the
corresponding */lib/ directory.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/prepare-release.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/contrib/prepare-release.sh b/contrib/prepare-release.sh
index 45be4d8..5009eec 100755
--- a/contrib/prepare-release.sh
+++ b/contrib/prepare-release.sh
@@ -105,8 +105,8 @@ check_libtool_vers()
 {
 	local lib="$1"
 	local lib_u="${lib^^}"
-	local libdir="${lib##lib}"
-	local symfile="${libdir}/lib/${lib}.sym"
+	local libdir="${lib##lib}/lib/"
+	local symfile="${libdir}/${lib}.sym"
 	local last_cur=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
 	local last_rev=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
 	local last_age=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
