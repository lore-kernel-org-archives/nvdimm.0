Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6216.austin.hp.com (g1t6216.austin.hp.com [15.73.96.123])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAA161A1F86
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:17:02 -0800 (PST)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v6 5/8] nvdimm: data structure changes for dsm calls
Date: Fri, 11 Mar 2016 14:16:29 -0700
Message-Id: <5f25808e2cbbe5485a43b08e0c56f42aa6ae7468.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Indicate "dsm_call" capability.
Track uuid.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/linux/libnvdimm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index af31d1c..83996b6 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -68,7 +68,9 @@ struct nd_mapping {
 
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
+	unsigned int call_dsm:1;
 	unsigned long dsm_mask;
+	const u8 *dsm_uuid;
 	char *provider_name;
 	ndctl_fn ndctl;
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
