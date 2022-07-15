Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75025381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919362; x=1689455362;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r2aXZnpKaSzek4KrNak5pgYah4lSLSdXiEHloFx2LQg=;
  b=GM7lsnEURq8mjtdqsUxH38dM8Lis78doTPEU1zAY4UkvqqOBUCaTrKNb
   f4/POvpXkWSEMqtTLqUq6ambjalW/fQgH3umUumcJIg4/scN2o6nADv3U
   l1REc2R+8nuHjG4NJ6FtRaWP3+GZgskxQWRKIFpVCre+zCh/yKT0bMJcu
   pOQBGmUKKE4x2Yh9xWp/yaeqiYkorlktLTfy46WNzp+ceJGEdUGaOuJOw
   gSsGSXPT+v6Ht19WMafGd/j3odfnzB2z6zg+ZnZ/S0/VjGJs3gsaE+W2T
   LWJgOYlPdQZKUT0Q/Ba1gZWzaettB7Nq5O+GnQVraWqzilSuhYeybey3X
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="347587964"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="347587964"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="624010379"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:19 -0700
Subject: [PATCH RFC 08/15] cxl/pmem: Add "Freeze Security State" security
 command support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:09:18 -0700
Message-ID: 
 <165791935875.2491387.542348076045531850.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
References: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Create callback function to support the nvdimm_security_ops() ->freeze()
callback. Translate the operation to send "Freeze Security State" security
command for CXL memory device.

See CXL 2.0 spec section 8.2.9.5.6.5 for reference.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/cxlmem.h   |    1 +
 drivers/cxl/security.c |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 70a1eb7720d3..ced85be291f3 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -253,6 +253,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
 	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
+	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index 4aec8e41e167..6399266a5908 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -105,10 +105,20 @@ static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
 	return rc;
 }
 
+static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
+}
+
 static const struct nvdimm_security_ops __cxl_security_ops = {
 	.get_flags = cxl_pmem_get_security_flags,
 	.change_key = cxl_pmem_security_change_key,
 	.disable = cxl_pmem_security_disable,
+	.freeze = cxl_pmem_security_freeze,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;


