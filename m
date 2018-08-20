Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FB0E210F670B
 for <linux-nvdimm@lists.01.org>; Mon, 20 Aug 2018 13:21:19 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, test: add UUID_LIBS for list_smart_dimm
Date: Mon, 20 Aug 2018 14:21:08 -0600
Message-Id: <20180820202108.16912-1-vishal.l.verma@intel.com>
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

Some environments automatically include the missing library dependency,
and others need it to be explicitly included.

Link: https://github.com/pmem/ndctl/issues/66
Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Fixes: d1941474111a ("ndctl, test: add a new unit test for monitor")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/Makefile.am b/test/Makefile.am
index c224eb7..50bb2e4 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -162,4 +162,5 @@ list_smart_dimm_SOURCES = \
 list_smart_dimm_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(JSON_LIBS) \
+		$(UUID_LIBS) \
 		../libutil.a
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
