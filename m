Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D31E8222DE14D
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 12:58:47 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/4] ndctl: add ndctl_encode_smart_temperature()
Date: Thu,  8 Feb 2018 14:04:26 -0700
Message-Id: <20180208210428.7285-2-vishal.l.verma@intel.com>
In-Reply-To: <20180208210428.7285-1-vishal.l.verma@intel.com>
References: <20180208210428.7285-1-vishal.l.verma@intel.com>
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

This provides for encoding of a human-readable temperature value into
the format expected by the smart command

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 16 ++++++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h       |  1 +
 3 files changed, 18 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4119a2e..ed5a65b 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -87,6 +87,22 @@ NDCTL_EXPORT double ndctl_decode_smart_temperature(unsigned int temp)
 	return t;
 }
 
+NDCTL_EXPORT unsigned int ndctl_encode_smart_temperature(double temp)
+{
+	bool negative = false;
+	unsigned int t;
+
+	if  (temp < 0) {
+		negative = true;
+		temp *= -1;
+	}
+	t = temp;
+	t *= 16;
+	if (negative)
+		t |= (1 << 15);
+	return t;
+}
+
 struct ndctl_ctx;
 
 /**
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index c160847..e7f9675 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -322,6 +322,7 @@ global:
 	ndctl_cmd_smart_threshold_set_ctrl_temperature;
 	ndctl_cmd_smart_threshold_set_spares;
 	ndctl_decode_smart_temperature;
+	ndctl_encode_smart_temperature;
 	ndctl_dimm_cmd_new_smart_inject;
 	ndctl_cmd_smart_inject_media_temperature;
 	ndctl_cmd_smart_inject_spares;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index bd33d39..6091ff3 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -76,6 +76,7 @@ size_t ndctl_min_namespace_size(void);
 size_t ndctl_sizeof_namespace_index(void);
 size_t ndctl_sizeof_namespace_label(void);
 double ndctl_decode_smart_temperature(unsigned int temp);
+unsigned int ndctl_encode_smart_temperature(double temp);
 
 struct ndctl_ctx;
 struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
