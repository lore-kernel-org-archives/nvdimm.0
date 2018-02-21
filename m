Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15E152034D8C9
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:00:54 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/3] ndctl,
 configure: add -Wmaybe-uninitialized to cflags
Date: Wed, 21 Feb 2018 16:06:48 -0700
Message-Id: <20180221230648.17591-1-vishal.l.verma@intel.com>
In-Reply-To: <20180221230252.16632-1-vishal.l.verma@intel.com>
References: <20180221230252.16632-1-vishal.l.verma@intel.com>
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

rpmbuild had the above cflag enabled, but local builds didn't, resulting
in missed warnings. Add it to my_CFLAGS in configure.ac

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index 70ba360..9067b41 100644
--- a/configure.ac
+++ b/configure.ac
@@ -145,6 +145,7 @@ my_CFLAGS="\
 -Wsign-compare \
 -Wstrict-prototypes \
 -Wtype-limits \
+-Wmaybe-uninitialized
 "
 AC_SUBST([my_CFLAGS])
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
