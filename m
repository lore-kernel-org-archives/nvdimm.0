Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8919A54
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661240732; x=1692776732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=86SwdVxA7TMFpmryejfDk5NOkDpXUJW5f4die9B9dY0=;
  b=V6WECukLOwH9NtuLosK2loG95uhp9iFGUrhIO0xmMhpKixTubLFoHYcW
   5jLAXvPgNpLwX+ND38RKGVUO9ipkKJMH8cjzDdwyc6Rk0A7Q140HGX5LP
   aElUVxBuxyB48Vw3CIUhc1M3wiKutDxez1y5TIRGZ2iLKely4+yPb6bwl
   La04C3B7QIo8Om07WAhfjhdSuHYXo0o/VopVnND45a7OxJQbflVvtZZ5T
   KLvVpenY4wovhjrnEaw8xp6sze+BVuJt+Z+pkyGeWric7fV3E2onoVd3L
   k/yuBCGbCJpv2j4ScffiVEnV+rywzOe5QWoOiDAhGVdPFyPjcGTJumN4+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294901757"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294901757"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="609254280"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:31 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/3] cxl/region: fix a dereferecnce after NULL check
Date: Tue, 23 Aug 2022 01:45:25 -0600
Message-Id: <20220823074527.404435-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823074527.404435-1-vishal.l.verma@intel.com>
References: <20220823074527.404435-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1092; h=from:subject; bh=86SwdVxA7TMFpmryejfDk5NOkDpXUJW5f4die9B9dY0=; b=owGbwMvMwCXGf25diOft7jLG02pJDMksrdNOqVVaba4I4r7asfpm9O6cndzzq7nE7/8+6y45815v wpZDHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjI9okMfwW1vZ5IMrSe/zufR6ea+9 nDtcXuhz3/CJx1mnZd1cLTjoPhf7aJmpfBvNpNjPPXymoosq+z2BexfOnVAyw5bw+6c0mY8AEA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A NULL check in region_action() implies that 'decoder' might be NULL, but
later we dereference it during cxl_decoder_foreach(). The NULL check is
valid because it was the filter result being checked, however, while
doing this, the original 'decoder' variable was being clobbered.

Check the filter results independently of the original decoder variable.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index a30313c..334fcc2 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -686,9 +686,8 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			continue;
 
 		cxl_decoder_foreach (port, decoder) {
-			decoder = util_cxl_decoder_filter(decoder,
-							  param.root_decoder);
-			if (!decoder)
+			if (!util_cxl_decoder_filter(decoder,
+						     param.root_decoder))
 				continue;
 			rc = decoder_region_action(p, decoder, action, count);
 			if (rc)
-- 
2.37.2

