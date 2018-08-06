Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28791210DBE70
 for <linux-nvdimm@lists.01.org>; Mon,  6 Aug 2018 14:21:47 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id h4-v6so15589651qtj.7
 for <linux-nvdimm@lists.01.org>; Mon, 06 Aug 2018 14:21:47 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH] ndctl,
 documentation: Clarify the dimm id for ndctl list d option
Date: Mon,  6 Aug 2018 17:21:30 -0400
Message-Id: <20180806212130.1605-1-msys.mizuma@gmail.com>
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
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

User may be confused the dimm id description of ndctl list -d
option because ndctl list says id, but the id is not useful to
d option.

]# ndctl list -d nmem7 | jq -r .id
cdab-0a-07e0-fefffeff
]# ndctl list -d cdab-0a-07e0-fefffeff
]#

The appropriate id here is X in 'nmemX' (Above example, X is 7).
Let's clarify the description.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 Documentation/ndctl/ndctl-list.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index 13ebdcd..1b5882a 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -64,9 +64,10 @@ include::xable-region-options.txt[]
 
 -d::
 --dimm=::
-	An 'nmemX' device name, or dimm id number. Filter listing by
-	devices that reference the given dimm. For example to see all
-	namespaces comprised of storage capacity on nmem0:
+	An 'nmemX' device name, or dimm id number. The dimm id number
+	here is X in 'nmemX'. Filter listing by devices that reference
+	the given dimm. For example to see all namespaces comprised
+	of storage capacity on nmem0:
 ----
 # ndctl list --dimm=nmem0 --namespaces
 ----
-- 
2.18.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
