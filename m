Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 68BC01A1DFB
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jul 2016 14:31:10 -0700 (PDT)
Subject: [ndctl PATCH] build: quiet warnings about missing git repository
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Jul 2016 14:29:28 -0700
Message-ID: <146740856798.33306.12339801003788127221.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yi Zhang <yi.a.zhang@hotmail.com>
List-ID: <linux-nvdimm@lists.01.org>

The git-version script auto-appends the commit id, but complains if the
repository is missing.  The complaint is benign, but we should also tag
builds outside of git with a '+' because who knows what changes were
made locally.

Link: https://github.com/pmem/ndctl/issues/5
Reported-by: Yi Zhang <yi.a.zhang@hotmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 git-version |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/git-version b/git-version
index 3823ee29afaf..9eb8fd654e38 100755
--- a/git-version
+++ b/git-version
@@ -38,9 +38,13 @@ elif test -d ${GIT_DIR:-.git} -o -f .git &&
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
 	read COMMIT COMMIT_SUBJECT <<EOF
-	$(git log --oneline --abbrev=8 -n1 HEAD)
+	$(git log --oneline --abbrev=8 -n1 HEAD 2>/dev/null)
 EOF
-	VN="$(dirty ${DEF_VER}.git$COMMIT)"
+	if [ -z $COMMIT ]; then
+		VN="${DEF_VER}+"
+	else
+		VN="$(dirty ${DEF_VER}.git$COMMIT)"
+	fi
 fi
 
 echo $VN

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
