Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12C10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932210; x=1701468210;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/h8geKe1QzI7rZRXBv8Bj9BEhk4XnHka9UJoh1Rl3js=;
  b=JPSd6coYoy1UnwLErThpn7yS/8G3UWAyUpWL2P8fZflfduuAjfiOUAag
   /eZaYMqX0OZ6pB/esDQlgxnJJTdVXm6oGi7mc7H4Pp9KMI08oBy48DF1S
   1RYxjSctI7FyQG90CsX/plBimPQy7lf7sze/o1CPYCpsQvxI97g1VQP+h
   vACbrUq0LEns60rPovd74ebxs+Eff8raLL5pMuRHA/cTo8xXFdLvQyNpi
   myFsu+V+ngjaHHVYh2UfKZ+6VM6g/Ss4v8O8mYlDby29wynA28yamliuO
   9Xvz9dlmhdDqnhtWsSq7+qatSlhmzVlHibjQAsQwhE06Edsyom+yCzJej
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295503676"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295503676"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638545039"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="638545039"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:03:30 -0800
Subject: [PATCH 3/5] cxl/pmem: Enforce keyctl ABI for PMEM security
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan.Cameron@huawei.com, dave.jiang@intel.com, nvdimm@lists.linux.dev,
 dave@stgolabs.net
Date: Thu, 01 Dec 2022 14:03:30 -0800
Message-ID: <166993221008.1995348.11651567302609703175.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Preclude the possibility of user tooling sending device secrets in the
clear into the kernel by marking the security commands as exclusive.
This mandates the usage of the keyctl ABI for managing the device
passphrase.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/mbox.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 8747db329087..35dd889f1d3a 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -704,6 +704,16 @@ int cxl_enumerate_cmds(struct cxl_dev_state *cxlds)
 		rc = 0;
 	}
 
+	/*
+	 * Setup permanently kernel exclusive commands, i.e. the
+	 * mechanism is driven through sysfs, keyctl, etc...
+	 */
+	set_bit(CXL_MEM_COMMAND_ID_SET_PASSPHRASE, cxlds->exclusive_cmds);
+	set_bit(CXL_MEM_COMMAND_ID_DISABLE_PASSPHRASE, cxlds->exclusive_cmds);
+	set_bit(CXL_MEM_COMMAND_ID_UNLOCK, cxlds->exclusive_cmds);
+	set_bit(CXL_MEM_COMMAND_ID_PASSPHRASE_SECURE_ERASE,
+		cxlds->exclusive_cmds);
+
 out:
 	kvfree(gsl);
 	return rc;

