Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 73F0B1A1E85
 for <linux-nvdimm@lists.01.org>; Mon,  9 May 2016 09:59:40 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: switch to ndctl-VERSION tag format
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 May 2016 09:58:52 -0700
Message-ID: <146281313239.8759.6868284165112471255.stgit@dwillia2-desk3.amr.corp.intel.com>
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

As Jeff notes, tarballs with names like v52.tar.gz are awful because
they are not very descriptive.  Switch to a 'package-version' format,
i.e. ndctl-52.tar.gz.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 git-version          |   25 +++++++++++++++----------
 make-git-snapshot.sh |    4 ++--
 ndctl.spec.in        |    4 ++--
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/git-version b/git-version
index 629f6d4a213d..ea6e26880aea 100755
--- a/git-version
+++ b/git-version
@@ -1,15 +1,25 @@
 #!/bin/bash
 
+to_ver() {
+	VN=$1
+	#drop leading 'ndctl-' out of the version so its a pure number
+	if [ ${VN:0:6} = "ndctl-" ]; then
+			VN=${VN:6}
+	fi
+	echo $VN
+}
+
 dirty() {
+	VN=$(to_ver $1)
 	git update-index -q --refresh
 	if test -z "$(git diff-index --name-only HEAD --)"; then
-		echo "$1"
+		echo "$VN"
 	else
-		echo "${1}.dirty"
+		echo "${VN}.dirty"
 	fi
 }
 
-DEF_VER=v52
+DEF_VER=52
 
 LF='
 '
@@ -19,10 +29,10 @@ LF='
 if test -f version; then
 	VN=$(cat version) || VN="$DEF_VER"
 elif test -d ${GIT_DIR:-.git} -o -f .git &&
-	VN=$(git describe --match "v[0-9]*" --abbrev=7 HEAD 2>/dev/null) &&
+	VN=$(git describe --match "ndctl-[0-9]*" --abbrev=7 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
-	v[0-9]*)
+	ndctl-[0-9]*)
 		VN="$(dirty $VN)"
 	esac; then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
@@ -33,9 +43,4 @@ EOF
 	VN="$(dirty ${DEF_VER}.git$COMMIT)"
 fi
 
-#drop leading 'v' out of the version so its a pure number
-if [ ${VN:0:1} = v ]; then
-	VN=${VN:1}
-fi
-
 echo $VN
diff --git a/make-git-snapshot.sh b/make-git-snapshot.sh
index 2825ac4321cd..142419d623fe 100755
--- a/make-git-snapshot.sh
+++ b/make-git-snapshot.sh
@@ -16,6 +16,6 @@ git clone $REFERENCE "$UPSTREAM" "$WORKDIR"
 
 VERSION=$(./git-version)
 DIRNAME="ndctl-${VERSION}"
-git archive --remote="$WORKDIR" --format=tar --prefix="$DIRNAME/" HEAD | gzip > $OUTDIR/"v${VERSION}.tar.gz"
+git archive --remote="$WORKDIR" --format=tar --prefix="$DIRNAME/" HEAD | gzip > $OUTDIR/"ndctl-${VERSION}.tar.gz"
 
-echo "Written $OUTDIR/v${VERSION}.tar.gz"
+echo "Written $OUTDIR/ndctl-${VERSION}.tar.gz"
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 0bdd2463698c..b8129e533e13 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -5,7 +5,7 @@ Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
 License:	GPLv2
 Group:		System Environment/Base
 Url:		https://github.com/pmem/ndctl
-Source0:	https://github.com/pmem/ndctl/archive/v%{version}.tar.gz
+Source0:	https://github.com/pmem/ndctl/archive/ndctl-%{version}.tar.gz
 
 BuildRequires:	autoconf
 BuildRequires:	asciidoc
@@ -45,7 +45,7 @@ Group:		System Environment/Libraries
 Libraries for %{name}.
 
 %prep
-%setup -q v%{version}
+%setup -q ndctl-%{version}
 
 %build
 echo "VERSION" > version

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
