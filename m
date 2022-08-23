Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E681A5F
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661240734; x=1692776734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rJ8gEEBtVLYGXTt1L5arjJ8aeJKmNlD+4PYtRRCVes=;
  b=P0/oSW2XeCbq5cg3f71QQ1b0DeHgDqMJZDIHJfyDhwnP7ZnMqcthDrCR
   ZJJtKi7/EpA3OCp6YbzWMVo0hdsHTemPQbFUo0rIOQTjvFmMpkPsCLNMr
   TPFZNJ0ihvOEp9sv6SJISGdKV2mf5fHaGVSLvZPIrw2W/cVdYDv3jo8i2
   lmgma2oxKrG565a2wbj8sQUIMQX/+Kn1yqA89xVJX6q9eZAJmUPizpwfo
   pUK6wYDc3cRIB9q76lHfHuaCiDyWvLiriSAV6E8YaJKCbXHqYMUYbvil4
   Y1700v5IKq5DHECjiwdJcwufCCJmzX503U0fsrkZGEC7BHQYE+JfQOvEx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294901762"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294901762"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:32 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="609254291"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:32 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 3/3] cxl/filter: Fix an uninitialized pointer dereference
Date: Tue, 23 Aug 2022 01:45:27 -0600
Message-Id: <20220823074527.404435-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823074527.404435-1-vishal.l.verma@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=837; h=from:subject; bh=8rJ8gEEBtVLYGXTt1L5arjJ8aeJKmNlD+4PYtRRCVes=; b=owGbwMvMwCXGf25diOft7jLG02pJDMksrdM3rpzD9XiPz/5/vlEpvj4ZhrEnntescBLlLH+lvv2L 0NGTHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIyiOG/wX/NYz45jFHbWr5+WSb+n OdS7/OXvjpeWjSLc3QKTH7Za4x/JXbVLHZoVGZ7/kyYz+B535NvI8U37H1mP8scRNc++L1CyYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Static analysis points out that there was a chance that 'jdecoder' could
be used while uninitialized in walk_decoders(). Initialize it to NULL to
avoid this.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 9a3de8c..56c6599 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -796,7 +796,7 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
 	cxl_decoder_foreach(port, decoder) {
 		const char *devname = cxl_decoder_get_devname(decoder);
 		struct json_object *jchildregions = NULL;
-		struct json_object *jdecoder;
+		struct json_object *jdecoder = NULL;
 
 		if (!p->decoders)
 			goto walk_children;
-- 
2.37.2

