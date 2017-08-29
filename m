Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4B4121E70D39
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:18 -0700 (PDT)
Subject: [ndctl PATCH 1/7] ndctl, init-labels: fix '--label-version' option
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:01:35 -0700
Message-ID: <150403689570.8240.8554898211089265114.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Kill the unnecessary double-dash characters in the definition of the
long option.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 264917d05cc0..ee3b9979fa8c 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -952,7 +952,7 @@ OPT_STRING('i', "input", &param.infile, "input-file", \
 #define INIT_OPTIONS() \
 OPT_BOOLEAN('f', "force", &param.force, \
 		"force initialization even if existing index-block present"), \
-OPT_STRING('V', "--label-version", &param.labelversion, "version-number", \
+OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 	"namespace label specification version (default: 1.1)")
 
 static const struct option read_options[] = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
