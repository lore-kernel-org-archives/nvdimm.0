Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E00F1203BEA20
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 11:50:59 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/4] configure: add -Wunused-result and
 -D_FORTIFY_SOURCE=2 to cflags
Date: Thu,  3 May 2018 12:50:50 -0600
Message-Id: <20180503185050.7559-4-vishal.l.verma@intel.com>
In-Reply-To: <20180503185050.7559-1-vishal.l.verma@intel.com>
References: <20180503185050.7559-1-vishal.l.verma@intel.com>
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

rpmbuild had these flags enabled, and reported a couple of errors that
local builds otherwise didn't. The errors hav now been fixed, and we
can enable these flags to catch future warnings and errors through
these flags.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index cddad16..6dbfcee 100644
--- a/configure.ac
+++ b/configure.ac
@@ -147,7 +147,9 @@ my_CFLAGS="\
 -Wsign-compare \
 -Wstrict-prototypes \
 -Wtype-limits \
--Wmaybe-uninitialized
+-Wmaybe-uninitialized \
+-Wunused-result \
+-D_FORTIFY_SOURCE=2
 "
 AC_SUBST([my_CFLAGS])
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
