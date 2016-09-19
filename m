Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B9AD1A1E1F
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 15:01:23 -0700 (PDT)
Subject: [ndctl PATCH] build: fix recommended build procedure
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:58:19 -0700
Message-ID: <147432229981.5430.5565783441765433672.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Hideaki Kimura <hideaki.kimura@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Hideaki Kimura reports that the default build instructions do not result
in a usable build.

    $ ndctl --version
    ndctl: error while loading shared libraries: libndctl.so.6: cannot
        open shared object file: No such file or directory

Use the default recommended configure options from autogen.sh.

Reported-by: Hideaki Kimura <hideaki.kimura@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 7256c2f15e20..e9dec67a0ea2 100644
--- a/README.md
+++ b/README.md
@@ -6,7 +6,7 @@ sub-system in the Linux kernel
 Build
 =====
 `./autogen.sh`  
-`./configure --enable-local`  
+`./configure CFLAGS='-g -O0' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64`  
 `make`  
 `make check`  
 `sudo make install`  

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
