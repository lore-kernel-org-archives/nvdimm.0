Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3422201B0459
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 12:06:22 -0800 (PST)
From: ira.weiny@intel.com
Subject: [PATCH V2] ndctl: Generalized make-git-snapshot.sh
Date: Fri, 15 Feb 2019 12:06:14 -0800
Message-Id: <20190215200614.30004-1-ira.weiny@intel.com>
In-Reply-To: <20190215192117.28605-1-ira.weiny@intel.com>
References: <20190215192117.28605-1-ira.weiny@intel.com>
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
To: linux-nvdimm@lists.01.org, vishal.l.verma@intel.com
List-ID: <linux-nvdimm@lists.01.org>

From: Ira Weiny <ira.weiny@intel.com>

make-git-snapshot.sh made an assumption of the git tree location.

Furthermore, it assumed the user has an rpmbuild environment directory
structure set up.

Enhance the script to figure out where in what location it has been
cloned and setup the rpmbuild tree if the user does not already
have it.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes since V1
	use rpmdev-setuptree

 make-git-snapshot.sh | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/make-git-snapshot.sh b/make-git-snapshot.sh
index 142419d623fe..513086b1f93d 100755
--- a/make-git-snapshot.sh
+++ b/make-git-snapshot.sh
@@ -2,10 +2,18 @@
 set -e
 
 NAME=ndctl
-REFDIR="$HOME/git/ndctl"  # for faster cloning, if available
+
+pushd `dirname $0`
+REFDIR=`pwd`
+popd
+
 UPSTREAM=$REFDIR #TODO update once we have a public upstream
 OUTDIR=$HOME/rpmbuild/SOURCES
 
+if [ ! -d $OUTDIR ]; then
+	rpmdev-setuptree
+fi
+
 [ -n "$1" ] && HEAD="$1" || HEAD="HEAD"
 
 WORKDIR="$(mktemp -d --tmpdir "$NAME.XXXXXXXXXX")"
@@ -14,7 +22,7 @@ trap 'rm -rf $WORKDIR' exit
 [ -d "$REFDIR" ] && REFERENCE="--reference $REFDIR"
 git clone $REFERENCE "$UPSTREAM" "$WORKDIR"
 
-VERSION=$(./git-version)
+VERSION=$($REFDIR/git-version)
 DIRNAME="ndctl-${VERSION}"
 git archive --remote="$WORKDIR" --format=tar --prefix="$DIRNAME/" HEAD | gzip > $OUTDIR/"ndctl-${VERSION}.tar.gz"
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
