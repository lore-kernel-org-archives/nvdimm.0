Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C2F184C
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183823; x=1682719823;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eWAKZOCEiukJwwwO0K/9Rdi7TNhtTLDtQjOlHQTdGi0=;
  b=ggK5JBwSYT2pOZGy6yPnnKCKOZ3CNhQAnK7Z57ZII1vzMnzXu2OKJrb7
   AxzNLepWtDVj4JOHiV7KCUN3YdrQWg4KgFCWP8L/EXS7EOByVI+PvDrkn
   N9FRRv0GzLF/y7jBpXGZ/2pG9TiZXu83yfgCxSr1ATMw20Cg5P/ra9zK6
   RYx7b1Ce8qLeLGYRImo2eve+VeLXHsvHTJdKG/WMWkxriub5VwFpLtC+8
   wnYWO53+7zlp6xOjJKoWzKCFTsBprDSGjZRUcoO5XjnACtW//3hGxRNtN
   jaadd4ouzJSBqEoVb95q99+gytJQLRoE14LDkKvbahri175QVaGV07B6k
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="291604848"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="291604848"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:23 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="808817284"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:22 -0700
Subject: [ndctl PATCH 04/10] cxl/port: Fix disable-port man page
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:22 -0700
Message-ID: <165118382203.1676208.17234717366569348622.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The man page was copied from the enable-port. Fix up some enable-port
leftovers, and duplicated --endpoint option description.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/cxl-disable-port.txt |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/Documentation/cxl/cxl-disable-port.txt b/Documentation/cxl/cxl-disable-port.txt
index de13c07d149b..ac56f20e8e6d 100644
--- a/Documentation/cxl/cxl-disable-port.txt
+++ b/Documentation/cxl/cxl-disable-port.txt
@@ -5,7 +5,7 @@ cxl-disable-port(1)
 
 NAME
 ----
-cxl-disable-port - activate / hot-add a given CXL port
+cxl-disable-port - disable / hot-remove a given CXL port and descendants
 
 SYNOPSIS
 --------
@@ -22,7 +22,6 @@ OPTIONS
 	Toggle from treating the port arguments as Switch Port identifiers to
 	Endpoint Port identifiers.
 
-
 -f::
 --force::
 	DANGEROUS: Override the safety measure that blocks attempts to disable a
@@ -31,9 +30,6 @@ OPTIONS
 	firmware and disabling an active device is akin to force removing memory
 	from a running system.
 
-	Toggle from treating the port arguments as Switch Port identifiers to
-	Endpoint Port identifiers.
-
 --debug::
 	If the cxl tool was built with debug disabled, turn on debug
 	messages.

