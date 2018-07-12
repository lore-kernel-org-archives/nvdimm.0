Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78EAC207DF299
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 22:40:18 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D385EAC0151
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 14:40:11 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH] ndctl, documentation: fix the manpage of inject-smart
Date: Thu, 12 Jul 2018 14:40:00 +0900
Message-Id: <20180712054000.18519-1-qi.fuli@jp.fujitsu.com>
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

The ndctl inject-smart doesn't have a [-H | --health] option.
This patch replaces [-H | --health] in the manpage of inject-smart
with [-f | --fatal].

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 Documentation/ndctl/ndctl-inject-smart.txt | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
index 0dc6481..06710ec 100644
--- a/Documentation/ndctl/ndctl-inject-smart.txt
+++ b/Documentation/ndctl/ndctl-inject-smart.txt
@@ -50,6 +50,7 @@ OPTIONS
 --media-temperature-threshold=::
 	Set <value> for the smart media temperature threshold.
 
+-x::
 --media-temperature-alarm=::
 	Enable or disable the smart media temperature alarm. Options are
 	'on' or 'off'.
@@ -62,6 +63,7 @@ OPTIONS
 --ctrl-temperature-threshold=::
 	Set <value> for the smart controller temperature threshold.
 
+-y::
 --ctrl-temperature-alarm=::
 	Enable or disable the smart controller temperature alarm. Options are
 	'on' or 'off'.
@@ -74,16 +76,16 @@ OPTIONS
 --spares-threshold=::
 	Set <value> for the smart spares threshold.
 
+-z::
 --spares-alarm=::
 	Enable or disable the smart spares alarm. Options are 'on' or 'off'.
 
--H::
---health=::
-	Smart attribute for health status. Provide either 'fatal' or 'nominal'
-	to set the state of the attribute.
+-f::
+--fatal::
+	Inject fatal for the health state attribute.
 
 -U::
---unsafe-shutdown=::
+--unsafe-shutdown::
 	Set the flag to spoof an unsafe shutdown on the next power down.
 
 -v::
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
