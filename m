Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8363AD
	for <nvdimm@lists.linux.dev>; Mon, 24 Apr 2023 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682366378; x=1713902378;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P2ooNdPDxUeEi5VnnIXUPzDHClIKyt6TVSaGBLvg6Z8=;
  b=GboMc6OJlcBcYZAokVQenvbDpq3OXkBmnz4Iy8HAkjQs1Mc9w4EaH8cc
   6wEe9nV+r9WkdF4x1iQNYX422WnzmnqaC9oUT4uiu4KR0PcCAwwHOocdr
   kfABxHwC+L1CAfN6v0ncy2FfdxH5q9QtjS7D6jJ1j8lUrcVCj4MKtg4eY
   elIha18KaTFOkXTVE06dyV1nwIldF3TfzqvmhbI+godOtJSIZYDNRxvFV
   sJ29rviTPigRGGpKBolT//QVvH90UGnTbM8L5xWhKmKBCSV53y8wg8Crk
   flsg6oo/j5+P6yvthDDPEmaccDNkDLWsBxZ3qQ6jYYK8BkDsCXLaIP6Ag
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="335442140"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="335442140"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="804759831"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="804759831"
Received: from fbirang-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.88.12])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:37 -0700
Subject: [PATCH 1/4] cxl/list: Fix filtering RCDs
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 24 Apr 2023 12:59:37 -0700
Message-ID: <168236637746.1027628.14674251843014155022.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
References: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Attempts to filter by memdev fail when the memdev is an RCD (RCH topology):

    # cxl list -BEM -m 11
      Warning: no matching devices found

    [
    ]

This is caused by VH topology assumption where an intervening host-bridge
port is expected between the root CXL port and the endpoint. In an RCH
topology an endpoint is integrated in the host-bridge.

Search for endpoints directly attached to the root:

    # cxl list -BEMu -m 11
    {
      "bus":"root3",
      "provider":"cxl_test",
      "endpoints:root3":[
        {
          "endpoint":"endpoint22",
          "host":"mem11",
          "depth":1,
          "memdev":{
            "memdev":"mem11",
            "ram_size":"2.00 GiB (2.15 GB)",
            "serial":"0xa",
            "numa_node":0,
            "host":"cxl_rcd.10"
          }
        }
      ]
    }


Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 59e5bdbcc750..e6c94d623303 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1457,8 +1457,9 @@ CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
 	return 0;
 }
 
-static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
-						   struct cxl_memdev *memdev)
+static struct cxl_endpoint *
+cxl_port_recurse_endpoint(struct cxl_port *parent_port,
+			  struct cxl_memdev *memdev)
 {
 	struct cxl_endpoint *endpoint;
 	struct cxl_port *port;
@@ -1468,7 +1469,7 @@ static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
 			if (strcmp(cxl_endpoint_get_host(endpoint),
 				   cxl_memdev_get_devname(memdev)) == 0)
 				return endpoint;
-		endpoint = cxl_port_find_endpoint(port, memdev);
+		endpoint = cxl_port_recurse_endpoint(port, memdev);
 		if (endpoint)
 			return endpoint;
 	}
@@ -1476,6 +1477,18 @@ static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
 	return NULL;
 }
 
+static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
+						   struct cxl_memdev *memdev)
+{
+	struct cxl_endpoint *endpoint;
+
+	cxl_endpoint_foreach(parent_port, endpoint)
+		if (strcmp(cxl_endpoint_get_host(endpoint),
+			   cxl_memdev_get_devname(memdev)) == 0)
+			return endpoint;
+	return cxl_port_recurse_endpoint(parent_port, memdev);
+}
+
 CXL_EXPORT struct cxl_endpoint *
 cxl_memdev_get_endpoint(struct cxl_memdev *memdev)
 {

