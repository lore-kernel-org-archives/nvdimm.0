Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4854C9D
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591340; x=1692127340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8MiiEmJrUVg6tXUUT3jHHbUKQ3S9VPBvZYaANeWql+s=;
  b=kOeEA588SsKyYDX7Ld+iRcjk9mIuVmU7kO0KSuXQEESnwgLRstVLQj4c
   /BfUvO/YAH7Nb05opcYqg6Qa77+oDclFyFeelV1QWl4XT87jSnH7Y94El
   BsB03GbE3/M6KiLIAucs/1DGspH2rghFbKeGVZQ4F+bCQwYrQqboM4I86
   Sf/GjtD7EvMn7+Ct5e4N/R6PoCBPUDV12rMRWLzZUQt5Caylz65DfGXjN
   ynHSsWq7/kZrD7WpW1FcQQ2BkYk/ynlsS0QRpc/vky6PoIJpcQRCu6T0X
   6JBHpDfR8u6scXCXmobrZ0Wn76OpIgnWka8POgTMYl4bZQinMeBE6vaUF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038708"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038708"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758239"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:18 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 01/11] libcxl: add a depth attribute to cxl_port
Date: Mon, 15 Aug 2022 13:22:04 -0600
Message-Id: <20220815192214.545800-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1236; h=from:subject; bh=8MiiEmJrUVg6tXUUT3jHHbUKQ3S9VPBvZYaANeWql+s=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jzdnFGQtnwnh+BFjX+8zMfjL6TctTFQYveX0dki9Lji 3Kc7HaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIox0jwwwDhYW7uzTk5viJ6fYaXN tw+s09s49cN7NYbz1Pye/8soHhf/qht/cdmy1uRbI7PbbIv3v70tK9hnvEvm6eIx9a8j9jMRcA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a depth attribute to the cxl_port structure, that can be used for
calculating its distance from the root port, and will be needed for
interleave granularity calculations during region creation.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h | 1 +
 cxl/lib/libcxl.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index f6d4573..832a815 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -66,6 +66,7 @@ struct cxl_port {
 	int decoders_init;
 	int dports_init;
 	int nr_dports;
+	int depth;
 	struct cxl_ctx *ctx;
 	struct cxl_bus *bus;
 	enum cxl_port_type type;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index be6bc2c..946cd4b 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -744,6 +744,7 @@ static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
 	port->type = type;
 	port->parent = parent_port;
 	port->type = type;
+	port->depth = parent_port ? parent_port->depth + 1 : 0;
 
 	list_head_init(&port->child_ports);
 	list_head_init(&port->endpoints);
-- 
2.37.1

