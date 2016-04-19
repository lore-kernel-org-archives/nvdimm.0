Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD3B61A22CD
 for <linux-nvdimm@lists.01.org>; Tue, 19 Apr 2016 11:11:42 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] autogen.sh: allow a --force to be sent to autoreconf
Date: Tue, 19 Apr 2016 12:11:17 -0600
Message-Id: <1461089477-11334-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Vishal Verma <vishal@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal@kernel.org>

Sometimes based on your libtool version, you may see something like:

libtool: Version mismatch error.  This is libtool 2.4.2, but the
libtool: definition of this LT_INIT comes from libtool 2.4.6.
libtool: You should recreate aclocal.m4 with macros from libtool 2.4.2
libtool: and run autoconf again.

which can be fixed by passing --force to autoreconf.

Let autogen.sh pass any commandline arguments on to autoreconf to allow
one to fix this.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 autogen.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/autogen.sh b/autogen.sh
index 2970a3b..a23cf53 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -7,7 +7,9 @@ if [ -f .git/hooks/pre-commit.sample -a ! -f .git/hooks/pre-commit ] ; then
 fi
 
 $(dirname $0)/git-version-gen
-autoreconf --install --symlink
+reconf_args=''
+[ -n "$*" ] && reconf_args="$*"
+autoreconf --install --symlink $reconf_args
 
 libdir() {
         echo $(cd $1/$(gcc -print-multi-os-directory); pwd)
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
