Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFFC747E
	for <nvdimm@lists.linux.dev>; Mon, 19 Sep 2022 23:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663631218; x=1695167218;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jj/klAsednkgzjq3ps6XLuoWHoRTcKi+tAqH8UUDsqQ=;
  b=mICXAEACBiPCxffh1Zp+HwIV3EJRiPUZo0SHwUPvTN0MSfFCKA6pPETS
   2vd5CD8CO7fzLUbl49aikomwoVlXjNiAqg9AugFoSUcPI6BxGUAiTFmjG
   7YI2fwZ/i9CYWdFv1b8EV9pk1Q2S4ywChfTZ+V4o0rZ/QqV6yfz5SFzXP
   jwe0e1FT7f32k2wyudHU4eEIHF2raq6N0ZXEaZUdrTuJN3VkadBUEHslS
   MbrCycsiroRrplHUToYaMlq6Z4wiNLTxBoKjL3wX/a5HK26eZA4H+QP9T
   hOh1AMeD4qcIO1tMO8ywL5lO3XHF87wfYleh2qvwWU5JqaNDPTd8X+LFo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="363509301"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="363509301"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="618690412"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 16:46:58 -0700
Subject: [PATCH v2 4/9] cxl: add common function to disable event trace
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 bwidawsk@kernel.org, dan.j.williams@intel.com, nafonten@amd.com,
 nvdimm@lists.linux.dev
Date: Mon, 19 Sep 2022 16:46:57 -0700
Message-ID: 
 <166363121739.3861186.14270734583823747080.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add a common function for cxl command that disables the event trace for the
instance created.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/event_trace.c |    8 ++++++++
 cxl/event_trace.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/cxl/event_trace.c b/cxl/event_trace.c
index ca2fb94f2eba..33d6812510a3 100644
--- a/cxl/event_trace.c
+++ b/cxl/event_trace.c
@@ -218,3 +218,11 @@ int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system)
 	tracefs_trace_on(inst);
 	return 0;
 }
+
+int cxl_event_tracing_disable(struct tracefs_instance *inst)
+{
+	if (!tracefs_trace_is_on(inst))
+		return 0;
+
+	return tracefs_trace_off(inst);
+}
diff --git a/cxl/event_trace.h b/cxl/event_trace.h
index 1fb905664625..9aafa942bbb2 100644
--- a/cxl/event_trace.h
+++ b/cxl/event_trace.h
@@ -18,5 +18,6 @@ struct event_ctx {
 
 int cxl_parse_events(struct tracefs_instance *inst, struct event_ctx *ectx);
 int cxl_event_tracing_enable(struct tracefs_instance *inst, const char *system);
+int cxl_event_tracing_disable(struct tracefs_instance *inst);
 
 #endif


