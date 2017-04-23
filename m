Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31C5421954077
 for <linux-nvdimm@lists.01.org>; Sun, 23 Apr 2017 04:14:46 -0700 (PDT)
From: Yi Zhang <yizhan@redhat.com>
Subject: [PATCH] daxctl: delete duplicate "-R,
 --regions" in "daxctl list --help"
Date: Sun, 23 Apr 2017 19:14:29 +0800
Message-Id: <20170423111429.16275-1-yizhan@redhat.com>
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

Signed-off-by: Yi Zhang <yizhan@redhat.com>
---
 Documentation/daxctl-list.txt | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/daxctl-list.txt b/Documentation/daxctl-list.txt
index 168d410..3e559e5 100644
--- a/Documentation/daxctl-list.txt
+++ b/Documentation/daxctl-list.txt
@@ -69,10 +69,6 @@ OPTIONS
 --regions::
 	Include region info in the listing
 
--R::
---regions::
-	Include region info in the listing
-
 -i::
 --idle::
 	Include idle (not enabled / zero-sized) devices in the listing
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
