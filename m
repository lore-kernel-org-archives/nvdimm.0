Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BF43D84
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183843; x=1682719843;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NkAqIlYQJgJtxA35ufdp9ayM4/vxjLMZkUQ9nZovAmA=;
  b=Bivu7Zn3EU1Y8uyt0FdDFWHJ5KREzhEnG7OFqXcEXbXYe2Fn9PoKtXt4
   Qb5yx23U0Pw9rX3KMPhYX8eTvsvdoDu+ccoAKdVy7yNHMFQYqQfYhcdGW
   kpMfQR2phamsyO7kZxkaCTq7vJ0Ns1NAZrDTxLQDlaUX4uIeZjBLbhNIF
   /BHF7Ww6N1OgTdtu/hIkLgwutpCLjL/iZtoCwnDfPy+MuxR7/pRWSINvb
   nqp+UcaGcVeRHwtmcFeeZTanZNaCVFMwmdGdRsBV9kPjEy7TpRRUgEQRo
   XpS9MineKiYlvtSHV2kE2gYsj7hjrwuoZemrFNcA8bnijQdgWn1nsjQYc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352871336"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="352871336"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="629758881"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:43 -0700
Subject: [ndctl PATCH 08/10] cxl/list: Add support for filtering by host
 identifiers
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:42 -0700
Message-ID: <165118384289.1676208.4779565283924668304.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Accept host device names as valid filters for memdevs, ports, and
endpoints.

# cxl list -u -m 7
{
  "memdev":"mem7",
  "pmem_size":"256.00 MiB (268.44 MB)",
  "ram_size":"256.00 MiB (268.44 MB)",
  "serial":"0x6",
  "numa_node":0,
  "host":"cxl_mem.6"
}

# cxl list -u -m cxl_mem.6
{
  "memdev":"mem7",
  "pmem_size":"256.00 MiB (268.44 MB)",
  "ram_size":"256.00 MiB (268.44 MB)",
  "serial":"0x6",
  "numa_node":0,
  "host":"cxl_mem.6"
}

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/filter.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cxl/filter.c b/cxl/filter.c
index c6ab9eb58124..66fd7420144a 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -73,6 +73,9 @@ struct cxl_endpoint *util_cxl_endpoint_filter(struct cxl_endpoint *endpoint,
 
 		if (strcmp(arg, cxl_endpoint_get_devname(endpoint)) == 0)
 			break;
+
+		if (strcmp(arg, cxl_endpoint_get_host(endpoint)) == 0)
+			break;
 	}
 
 	free(ident);
@@ -116,6 +119,9 @@ static struct cxl_port *__util_cxl_port_filter(struct cxl_port *port,
 
 		if (strcmp(arg, cxl_port_get_devname(port)) == 0)
 			break;
+
+		if (strcmp(arg, cxl_port_get_host(port)) == 0)
+			break;
 	}
 
 	free(ident);
@@ -303,6 +309,9 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
 
 		if (strcmp(name, cxl_memdev_get_devname(memdev)) == 0)
 			break;
+
+		if (strcmp(name, cxl_memdev_get_host(memdev)) == 0)
+			break;
 	}
 
 	free(ident);

