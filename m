Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F05121C91278
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 15:40:39 -0700 (PDT)
Subject: [PATCH 1/4] ndctl: switch to kernel versioning scheme
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Jul 2017 15:36:16 -0700
Message-ID: <150102217596.2258.13826333444582305967.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Similar to perf, now that ndctl is part of the kernel source tree it
also shares the version number of the source tree. This is consistent
with the policy of not maintaining separate version numbers for drivers
within the kernel tree.

The version can be overridden by a local 'version' file, but now the
default version will no longer be hard coded. Instead, it is derived
from the kernel's 'kernelversion' Makefile target. The policy appending
'.git${abbrev_commit}', and optionally '.dirty', for off-label releases
is still the default when a git tree is available.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/ndctl/git-version |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/ndctl/git-version b/tools/ndctl/git-version
index 8cc8d2f97bd6..a6461036ec8e 100755
--- a/tools/ndctl/git-version
+++ b/tools/ndctl/git-version
@@ -19,7 +19,7 @@ dirty() {
 	fi
 }
 
-DEF_VER=57.1
+DEF_VER=$(MAKEFLAGS= make -sC ../.. kernelversion)
 
 LF='
 '
@@ -29,7 +29,7 @@ LF='
 if test -f version; then
 	VN=$(cat version) || VN="$DEF_VER"
 elif test -d ${GIT_DIR:-.git} -o -f .git &&
-	VN=$(git describe --match "v[0-9]*" --abbrev=7 HEAD 2>/dev/null) &&
+	VN=$(git describe --match "v[4-9]*" --abbrev=7 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
 	v[0-9]*)
@@ -37,9 +37,9 @@ elif test -d ${GIT_DIR:-.git} -o -f .git &&
 	esac; then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	read COMMIT COMMIT_SUBJECT <<EOF
+	read COMMIT COMMIT_SUBJECT <<- EOF
 	$(git log --oneline --abbrev=8 -n1 HEAD 2>/dev/null)
-EOF
+	EOF
 	if [ -z $COMMIT ]; then
 		VN="${DEF_VER}+"
 	else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
