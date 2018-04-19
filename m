Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0679521E080FE
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 08:11:37 -0700 (PDT)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl v2 3/3] Documentation: add asciidoctor-extensions.rb to
 .gitignore
Date: Thu, 19 Apr 2018 17:11:20 +0200
Message-Id: <20180419151120.11041-4-tiwai@suse.de>
In-Reply-To: <20180419151120.11041-1-tiwai@suse.de>
References: <20180419151120.11041-1-tiwai@suse.de>
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

Two new files were added for asciidoctor support.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index 20a04dedd862..c7d11d91398c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,6 +15,8 @@ Makefile.in
 *.1
 Documentation/daxctl/asciidoc.conf
 Documentation/ndctl/asciidoc.conf
+Documentation/daxctl/asciidoctor-extensions.rb
+Documentation/ndctl/asciidoctor-extensions.rb
 .dirstamp
 daxctl/daxctl
 daxctl/lib/libdaxctl.la
-- 
2.16.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
