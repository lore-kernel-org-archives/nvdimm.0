Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
 by ml01.01.org (Postfix) with ESMTP id 417F421244A6A
 for <linux-nvdimm@lists.01.org>; Wed,  8 May 2019 19:48:03 -0700 (PDT)
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
 by cn.fujitsu.com (Postfix) with ESMTP id 3C54F4CDE919
 for <linux-nvdimm@lists.01.org>; Thu,  9 May 2019 10:40:43 +0800 (CST)
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [PATCH] Documentation: nvdimm: Fix typo
Date: Thu, 9 May 2019 10:40:36 +0800
Message-ID: <20190509024036.7743-1-ruansy.fnst@cn.fujitsu.com>
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

Remove the extra 'we '.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 Documentation/nvdimm/nvdimm.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/nvdimm/nvdimm.txt b/Documentation/nvdimm/nvdimm.txt
index e894de69915a..a2013750bcf1 100644
--- a/Documentation/nvdimm/nvdimm.txt
+++ b/Documentation/nvdimm/nvdimm.txt
@@ -284,8 +284,8 @@ A bus has a 1:1 relationship with an NFIT.  The current expectation for
 ACPI based systems is that there is only ever one platform-global NFIT.
 That said, it is trivial to register multiple NFITs, the specification
 does not preclude it.  The infrastructure supports multiple busses and
-we we use this capability to test multiple NFIT configurations in the
-unit test.
+we use this capability to test multiple NFIT configurations in theunit
+test.
 
 LIBNVDIMM: control class device in /sys/class
 
-- 
2.17.0



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
