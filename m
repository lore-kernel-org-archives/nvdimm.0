Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964421398
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183817; x=1682719817;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nfv2zG5A8V35hocGwBFBf7FQQxSyBEnkJuli4Ie8N4s=;
  b=AwjWn+JUs2fHCziwcFzos9M8wjlxXHH0BvsQHY5kBCki55tZ1G0F9woH
   dyzZ/SSzp/uQUn26HPJan3GyyfhjMFQH3kZllGj7f6um9Qw1J+mjmeKmZ
   YVe7HoDfgagKiv3gANnH1kL4v1E0Pw1JcVIdjRW3UWvDnA1Jhz25xC5bH
   jZxRLln2nVrKNY1N0rpL5+sBM9ZNdmPO6b/66MmNAUls743Q3J0KgMek0
   3hbkZ+ggfLMTlK7GSbi5YFawxqdxg7x1mqOPMMdxiBdOnbrxaa5G35qca
   sfmnqePwaIi7mHzEHFRLZDC/2sIGp5eBsYAwJrmiHQXDtYQJZz7TY8vU9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="264028222"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="264028222"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="565821458"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:16 -0700
Subject: [ndctl PATCH 03/10] util: Pretty print terabytes
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:16 -0700
Message-ID: <165118381648.1676208.1686584406206186723.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

CXL capacities are such that gigabytes are too small of a unit for
displaying capacities. Add terabyte support to the display_size()
helper.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/util/json.c b/util/json.c
index ebdf8d9eedd9..1d5c6bc7822e 100644
--- a/util/json.c
+++ b/util/json.c
@@ -37,11 +37,16 @@ static int display_size(struct json_object *jobj, struct printbuf *pbuf,
 
 			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld MiB",
 					cMiB/100 , cMiB % 100);
-		} else {
+		} else if (bytes < 2*SZ_1T) {
 			long cGiB = (bytes * 200LL / SZ_1G+1) /2;
 
 			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld GiB",
 					cGiB/100 , cGiB % 100);
+		} else {
+			long cTiB = (bytes * 200LL / SZ_1T+1) /2;
+
+			c = snprintf(buf, sizeof(buf), "\"%ld.%02ld TiB",
+					cTiB/100 , cTiB % 100);
 		}
 
 		/* JEDEC */
@@ -50,12 +55,18 @@ static int display_size(struct json_object *jobj, struct printbuf *pbuf,
 
 			snprintf(buf + c, sizeof(buf) - c, " (%ld.%02ld MB)\"",
 					cMB/100, cMB % 100);
-		} else {
+		} else if (bytes < 2*SZ_1T) {
 			long cGB  = (bytes / (1000000000LL/200LL) + 1) / 2;
 
 			snprintf(buf + c, sizeof(buf) - c, " (%ld.%02ld GB)\"",
 					cGB/100 , cGB % 100);
+		} else {
+			long cTB  = (bytes / (1000000000000LL/200LL) + 1) / 2;
+
+			snprintf(buf + c, sizeof(buf) - c, " (%ld.%02ld TB)\"",
+					cTB/100 , cTB % 100);
 		}
+
 	}
 
 	return printbuf_memappend(pbuf, buf, strlen(buf));

