Return-Path: <SRS0=WMzx=4E=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A541EC7619D
	for <linux-nvdimm@archiver.kernel.org>; Sun, 16 Feb 2020 20:17:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81AEC2084E
	for <linux-nvdimm@archiver.kernel.org>; Sun, 16 Feb 2020 20:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81AEC2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4FE9510FC3361;
	Sun, 16 Feb 2020 12:20:17 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.100; helo=mga07.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A8BAC10FC319C
	for <linux-nvdimm@lists.01.org>; Sun, 16 Feb 2020 12:20:14 -0800 (PST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Feb 2020 12:16:57 -0800
X-IronPort-AV: E=Sophos;i="5.70,450,1574150400";
   d="scan'208";a="253215892"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Feb 2020 12:16:57 -0800
Subject: [PATCH v5 2/6] mm/numa: Skip NUMA_NO_NODE and online nodes in
 numa_map_to_online_node()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Sun, 16 Feb 2020 12:00:53 -0800
Message-ID: <158188325316.894464.15650888748083329531.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <158188324272.894464.5941332130956525504.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158188324272.894464.5941332130956525504.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: G2TB3XQPOKLAF5Z6EBYLSKOULHWSZP4U
X-Message-ID-Hash: G2TB3XQPOKLAF5Z6EBYLSKOULHWSZP4U
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>, peterz@infradead.org, dave.hansen@linux.intel.com, hch@lst.de, linux-kernel@vger.kernel.org, x86@kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/G2TB3XQPOKLAF5Z6EBYLSKOULHWSZP4U/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Update numa_map_to_online_node() to stop falling back to numa node 0
when the input is NUMA_NO_NODE. Also, skip the lookup if @node is
online. This makes the routine compatible with other arch node mapping
routines.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Link: https://lore.kernel.org/r/157401275716.43284.13185549705765009174.stgit@dwillia2-desk3.amr.corp.intel.com
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/mempolicy.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 756d6e5bb59f..19f7e71945a7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -135,21 +135,17 @@ static struct mempolicy preferred_node_policy[MAX_NUMNODES];
  */
 int numa_map_to_online_node(int node)
 {
-	int min_node;
+	int min_dist = INT_MAX, dist, n, min_node;
 
-	if (node == NUMA_NO_NODE)
-		node = 0;
+	if (node == NUMA_NO_NODE || node_online(node))
+		return node;
 
 	min_node = node;
-	if (!node_online(node)) {
-		int min_dist = INT_MAX, dist, n;
-
-		for_each_online_node(n) {
-			dist = node_distance(node, n);
-			if (dist < min_dist) {
-				min_dist = dist;
-				min_node = n;
-			}
+	for_each_online_node(n) {
+		dist = node_distance(node, n);
+		if (dist < min_dist) {
+			min_dist = dist;
+			min_node = n;
 		}
 	}
 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
