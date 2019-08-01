Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tartarus.angband.pl (tartarus.angband.pl
 [IPv6:2001:41d0:602:dbe::8])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E769212FD41A
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jul 2019 18:03:29 -0700 (PDT)
From: Adam Borowski <kilobyte@angband.pl>
Date: Thu,  1 Aug 2019 03:00:44 +0200
Message-Id: <20190801010044.56927-1-kilobyte@angband.pl>
MIME-Version: 1.0
Subject: [PATCH] daxctl: link against libndctl,
 in case its use doesn't get pruned
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
Cc: Adam Borowski <kilobyte@angband.pl>
List-ID: <linux-nvdimm@lists.01.org>

util/json.c uses libndctl symbols, and is included by daxctl.  These
functions should then get pruned as unused, but on some platforms the
toolchain fails to do so.

These platforms are ia64, hppa and 32-bit powerpc.  It's generally a
waste of our time to build ndctl there, but as the lack of a
build-dependency requires annoying workarounds higher in the stack,
this has been requested in https://bugs.debian.org/914348 -- and is
trivially fixable on the ndctl side.

Thanks to -Wl,--as-needed there's no harm to architectures where the
pruning works, thus let's not bother with detection.

As daxctl and libdaxctl are separate, there's no circular dependency.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 daxctl/Makefile.am | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index 94f73f9..a5487d6 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -21,4 +21,5 @@ daxctl_LDADD =\
 	lib/libdaxctl.la \
 	../libutil.a \
 	$(UUID_LIBS) \
-	$(JSON_LIBS)
+	$(JSON_LIBS) \
+	../ndctl/lib/libndctl.la
-- 
2.23.0.rc0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
