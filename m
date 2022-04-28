Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FAE3D8D
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183838; x=1682719838;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=szNK7NyLKQ9MBHYyKQS30kvZW9aBafZ+FwCwnr+bNSM=;
  b=fXSPAJuogO+FRQ2k1q9ZerizsTDheMFPbYhT0SfY953TeB4Styii4T8r
   HY/MtqpJBg3OR6/f9yu/USppsiK2qkkqG8Z3rgkIVJL6B+y9jSjmX4pH+
   WY/W1GIsIpf53EjRV/QkELYWog3gUQdhBrt7Ykm0nKbX7QnfxSEyuQJuE
   t14yxcsTPbEpfkx04XrmTJnRcjLjzY0B5G+a/AfTSbogdUqbfp+Bg8bRT
   TrVjjgiiPd+6qh8mYz1v27H76gFuTq/iUz2KeNOvsobnCafffYey7oDhz
   0BuTMW2Db19YkhqZxYExyYIc2gLIgXEVYlJLTrk/0/qmLsfZXRTG2O3iR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352871328"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="352871328"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:37 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="808817336"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:37 -0700
Subject: [ndctl PATCH 07/10] cxl/memdev: Fix bus_invalidate() crash
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:37 -0700
Message-ID: <165118383756.1676208.5717187278816036969.stgit@dwillia2-desk3.amr.corp.intel.com>
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

bus_invalidate() attempts to limit the invalidation of memdevs to a single
bus scope. However, the ordering of bus_invalidate() leads to a use after
free. Unconditionally invalidate memdevs (disconnect memdevs from their
endpoints) and resotre on next lookup. Otherwise the following command
results in the following backtrace with cxl_test:

    cxl disable-memdev 5,1 --force

#2  0x00007ffff7fb97d4 in snprintf (__fmt=0x7ffff7fbc3ed "%s/driver", __n=98,
    __s=0x574d545619f7bae2 <error: Cannot access memory at address 0x574d545619f7bae2>)
    at /usr/include/bits/stdio2.h:71
#3  cxl_port_is_enabled (port=port@entry=0x422eb0) at ../cxl/lib/libcxl.c:1379
#4  0x00007ffff7fb99a9 in cxl_port_get_bus (port=0x422eb0) at ../cxl/lib/libcxl.c:1339
#5  0x00007ffff7fba3d0 in bus_invalidate (bus=bus@entry=0x421740) at ../cxl/lib/libcxl.c:549
#6  0x00007ffff7fba4e7 in cxl_memdev_disable_invalidate (memdev=0x416fd0) at ../cxl/lib/libcxl.c:596
#7  0x000000000040624e in memdev_action (argc=<optimized out>, argv=<optimized out>, ctx=0x4152a0,
    action=action@entry=0x406b70 <action_disable>, options=options@entry=0x40fca0 <disable_options>,
    usage=usage@entry=0x40f4b0 "cxl disable-memdev <mem0> [<mem1>..<memN>] [<options>]")
    at ../cxl/memdev.c:506
#8  0x0000000000406d57 in cmd_disable_memdev (argc=<optimized out>, argv=<optimized out>,

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 0e8dd20e3c47..374b0f13905a 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -546,8 +546,7 @@ static void bus_invalidate(struct cxl_bus *bus)
 	 * indeterminate, delete them all and start over.
 	 */
 	cxl_memdev_foreach(ctx, memdev)
-		if (cxl_memdev_get_bus(memdev) == bus)
-			memdev->endpoint = NULL;
+		memdev->endpoint = NULL;
 
 	bus_port = cxl_bus_get_port(bus);
 	list_for_each_safe(&bus_port->child_ports, port, _p, list)

