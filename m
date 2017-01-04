Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD28C81944
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jan 2017 15:35:47 -0800 (PST)
Subject: [ndctl PATCH] test: fix multi_pmem link error
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jan 2017 15:31:40 -0800
Message-ID: <148357270056.3357.1307228634254197776.stgit@dwillia2-desk3.amr.corp.intel.com>
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

As reported by issue #8:

  "I tried to build ndctl, and I executed "make check",
   but I met link error of libuuid like followings.

    /usr/bin/ld: multi-pmem.o: undefined reference to symbol 'uuid_unparse@@UUID_1.0'
    /lib/x86_64-linux-gnu/libuuid.so.1: error adding symbols: DSO missing from command line

   Not only libuuid, but also libkmod has similar problem."

Add the missing libraries to the dependency list. This happens to work
on latest Fedora, but fails for the reporter on Ubuntu 14.04.

Link: https://github.com/pmem/ndctl/issues/8
Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/test/Makefile.am b/test/Makefile.am
index 9e3ae1dab411..7ec14118f74d 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -89,4 +89,6 @@ multi_pmem_SOURCES = \
 multi_pmem_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(JSON_LIBS) \
+		$(UUID_LIBS) \
+		$(KMOD_LIBS) \
 		../libutil.a

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
