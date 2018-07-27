Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE78F210C2D6E
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 11:36:27 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 inject-smart: Fix man page to match the current behavior
Date: Fri, 27 Jul 2018 12:36:23 -0600
Message-Id: <20180727183623.14176-1-vishal.l.verma@intel.com>
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

The inject-smart man page had a -H option for health status, which was
from a previous development iteration, and not how it actually works.
Fix it to advertise a -f flag for setting fatal status, and remove an
unnecessart '=' from the unsafe-shutdown option as it doesn't accept any
additional arguments.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-inject-smart.txt | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
index 0dc6481..20a1621 100644
--- a/Documentation/ndctl/ndctl-inject-smart.txt
+++ b/Documentation/ndctl/ndctl-inject-smart.txt
@@ -77,13 +77,12 @@ OPTIONS
 --spares-alarm=::
 	Enable or disable the smart spares alarm. Options are 'on' or 'off'.
 
--H::
---health=::
-	Smart attribute for health status. Provide either 'fatal' or 'nominal'
-	to set the state of the attribute.
+-f::
+--fatal::
+	Set the flag to spoof fatal health status.
 
 -U::
---unsafe-shutdown=::
+--unsafe-shutdown::
 	Set the flag to spoof an unsafe shutdown on the next power down.
 
 -v::
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
