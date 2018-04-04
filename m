Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96E5622526491
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:22:13 -0700 (PDT)
Subject: [ndctl PATCH 4/5] ndctl: add new START and WAIT actions
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 14:12:17 -0700
Message-ID: <152287633697.29230.7355050331429260998.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for adding 'start-scrub' and 'wait-scrub' utilities,
define new device actions for these operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/action.h    |    2 ++
 ndctl/namespace.c |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/ndctl/action.h b/ndctl/action.h
index 43ea62adbcd2..1ecad49530d5 100644
--- a/ndctl/action.h
+++ b/ndctl/action.h
@@ -11,5 +11,7 @@ enum device_action {
 	ACTION_CREATE,
 	ACTION_DESTROY,
 	ACTION_CHECK,
+	ACTION_WAIT,
+	ACTION_START,
 };
 #endif /* __NDCTL_ACTION_H__ */
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index aef356abbee1..1c39d9b01adc 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1054,6 +1054,9 @@ static int do_xaction_namespace(const char *namespace,
 					if (rc < 0)
 						return rc;
 					return 1;
+				default:
+					rc = -EINVAL;
+					break;
 				}
 				if (rc >= 0)
 					success++;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
