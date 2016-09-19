Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0CAE1A1E47
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:41:15 -0700 (PDT)
Subject: [ndctl PATCH 6/6] ndctl: fix potential null deref in
 util_namespace_to_json()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:38:12 -0700
Message-ID: <147432109289.39548.10889579664154150181.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Similar to commit 59a9803454ee "util_namespace_to_json: fix potential
null pointer dereference" check that we actually get a btt instance when
the namespace is detected to be in "safe" mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/util/json.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/util/json.c b/ndctl/util/json.c
index 6b74c240a3f5..82e677c2c7a7 100644
--- a/ndctl/util/json.c
+++ b/ndctl/util/json.c
@@ -179,6 +179,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		jobj = json_object_new_string("dax");
 		break;
 	case NDCTL_NS_MODE_SAFE:
+		if (!btt)
+			goto err;
 		jobj = json_object_new_string("sector");
 		size = ndctl_btt_get_size(btt);
 		break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
