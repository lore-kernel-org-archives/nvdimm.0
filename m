Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 92CDB1A1DF1
 for <linux-nvdimm@lists.01.org>; Sat, 28 May 2016 13:46:08 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: fix rpm source url,
 switch back to v$VERSION tag scheme
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 May 2016 13:45:10 -0700
Message-ID: <146446831017.33347.13551869494702303909.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The way to have github generate tarballs in ndctl-$VERSION format while
maintaining a v$VERSION tag scheme is to use a source url in the
following format:

https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 git-version   |   10 +++++-----
 ndctl.spec.in |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/git-version b/git-version
index 03b44a613a57..3823ee29afaf 100755
--- a/git-version
+++ b/git-version
@@ -2,9 +2,9 @@
 
 to_ver() {
 	VN=$1
-	#drop leading 'ndctl-' out of the version so its a pure number
-	if [ ${VN:0:6} = "ndctl-" ]; then
-			VN=${VN:6}
+	#drop leading 'v' out of the version so its a pure number
+	if [ ${VN:0:1} = "v" ]; then
+			VN=${VN:1}
 	fi
 	echo $VN
 }
@@ -29,10 +29,10 @@ LF='
 if test -f version; then
 	VN=$(cat version) || VN="$DEF_VER"
 elif test -d ${GIT_DIR:-.git} -o -f .git &&
-	VN=$(git describe --match "ndctl-[0-9]*" --abbrev=7 HEAD 2>/dev/null) &&
+	VN=$(git describe --match "v[0-9]*" --abbrev=7 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
-	ndctl-[0-9]*)
+	v[0-9]*)
 		VN="$(dirty $VN)"
 	esac; then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 221cd755e2a6..0aaef03b2e5b 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -5,7 +5,7 @@ Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
 License:	GPLv2
 Group:		System Environment/Base
 Url:		https://github.com/pmem/ndctl
-Source0:	https://github.com/pmem/ndctl/archive/ndctl-%{version}.tar.gz
+Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
 BuildRequires:	autoconf
 BuildRequires:	asciidoc

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
