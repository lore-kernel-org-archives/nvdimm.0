Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABB62C9E;
	Fri, 28 Jan 2022 00:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643329645; x=1674865645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T9XKBUWEiW5Gc/EQfMiMf7KQVNCUAgi9KBZ44Hu22xc=;
  b=UkVwQcvXVpcBSTL+v+MlZ5CiO7w6bWINzE+iulnx4oqNtXcaS+5vLXBV
   Jz9Zm6ljXbCyCdxxfcI4YikkYU+mYkrw/VBU0UtwwUS3wvDz81MPaeGlE
   /ZgM/us4Kflt02vwfSix+S6ix4bg3RPEL8km5opi3yrTquI3eSGuaKgyc
   fV7dbNox8gt0t0edDT4lH9jFeNGiP7fUgZq8ic3p1lSHvakU6hu4O3/+T
   mp4WMWmPA30hstss28z2cse9PBLPC68JXelcHnxsMx0jrocxKIaLsE2lI
   uPJdYdtj0CdwKx6KVB+z3WRKIhDKqMf3m2igJutGESSyPpWXVJ3b2rNTZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226982066"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="226982066"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="674909611"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:23 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 03/14] cxl/mem: Cache port created by the mem dev
Date: Thu, 27 Jan 2022 16:26:56 -0800
Message-Id: <20220128002707.391076-4-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128002707.391076-1-ben.widawsky@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since region programming sees all components in the topology as a port,
it's required that endpoints are treated equally. The easiest way to go
from endpoint to port is to simply cache it at creation time.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>

---
Changes since v2:
- Rebased on Dan's latest port/mem changes
- Keep a reference to the port until the memdev goes away
- add action to release device reference for the port
---
 drivers/cxl/cxlmem.h |  2 ++
 drivers/cxl/mem.c    | 35 ++++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 7ba0edb4a1ab..2b8c66616d4e 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -37,6 +37,7 @@
  * @id: id number of this memdev instance.
  * @detach_work: active memdev lost a port in its ancestry
  * @component_reg_phys: register base of component registers
+ * @port: The port created by this device
  */
 struct cxl_memdev {
 	struct device dev;
@@ -44,6 +45,7 @@ struct cxl_memdev {
 	struct cxl_dev_state *cxlds;
 	struct work_struct detach_work;
 	int id;
+	struct cxl_port *port;
 };
 
 static inline struct cxl_memdev *to_cxl_memdev(struct device *dev)
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 27f9dd0d55b6..c36219193886 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -45,26 +45,31 @@ static int wait_for_media(struct cxl_memdev *cxlmd)
 	return 0;
 }
 
-static int create_endpoint(struct cxl_memdev *cxlmd,
-			   struct cxl_port *parent_port)
+static struct cxl_port *create_endpoint(struct cxl_memdev *cxlmd,
+					struct cxl_port *parent_port)
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint;
+	int rc;
 
 	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
 				     cxlds->component_reg_phys, parent_port);
 	if (IS_ERR(endpoint))
-		return PTR_ERR(endpoint);
+		return endpoint;
 
 	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
 
 	if (!endpoint->dev.driver) {
 		dev_err(&cxlmd->dev, "%s failed probe\n",
 			dev_name(&endpoint->dev));
-		return -ENXIO;
+		return ERR_PTR(-ENXIO);
 	}
 
-	return cxl_endpoint_autoremove(cxlmd, endpoint);
+	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return endpoint;
 }
 
 /**
@@ -127,11 +132,18 @@ __mock bool cxl_dvsec_decode_init(struct cxl_dev_state *cxlds)
 	return do_hdm_init;
 }
 
+static void delete_memdev(void *dev)
+{
+	struct cxl_memdev *cxlmd = dev;
+
+	put_device(&cxlmd->port->dev);
+}
+
 static int cxl_mem_probe(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_port *parent_port;
+	struct cxl_port *parent_port, *ep_port;
 	int rc;
 
 	/*
@@ -201,7 +213,16 @@ static int cxl_mem_probe(struct device *dev)
 		goto out;
 	}
 
-	rc = create_endpoint(cxlmd, parent_port);
+	ep_port = create_endpoint(cxlmd, parent_port);
+	if (IS_ERR(ep_port)) {
+		rc = PTR_ERR(ep_port);
+		goto out;
+	}
+
+	get_device(&ep_port->dev);
+	cxlmd->port = ep_port;
+
+	rc = devm_add_action_or_reset(dev, delete_memdev, cxlmd);
 out:
 	cxl_device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);
-- 
2.35.0

