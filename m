Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71D7F
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 07:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668585470; x=1700121470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KiJFxHg73UmbAysUoUdzQCgP2Xj1YpjVLLbX13coZBc=;
  b=MIJOBMZxe3blqxTHxoHtfyAJar6lWF62/685FhiESvX5HPnKGcfSHBOS
   cyb8uU7a5ns2ybwQ+xWh+PqpOgZqrtg4HEuWfi2ahjIqWRdkVYnc66Ung
   6tno7hPGdWSvy8hUYL0a9Y0m0eaNKYmC8ko6UDEIlhEWsZBsVq5JUC186
   PLiIvOH01A+gO1vvxD+WtIeINOdqlXzr8/DLbWEKEaLWXlgBNzYi5RIg3
   twyNuQzZrGdyztaUJ5FbzDSkyvCwys7j2t/iU475VkeMYAZvg7MbM4R67
   frxa7hKWXFKLhFAr26rqrn6m3nrth5IaPLS2KnAE/RADVnDEeK6L9gdS5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="292186380"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="292186380"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="702769364"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="702769364"
Received: from ake-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.189.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 23:57:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-acpi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	liushixin2@huawei.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>
Subject: [PATCH 1/2] ACPI: HMAT: remove unnecessary variable initialization
Date: Wed, 16 Nov 2022 00:57:35 -0700
Message-Id: <20221116075736.1909690-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116075736.1909690-1-vishal.l.verma@intel.com>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=993; h=from:subject; bh=KiJFxHg73UmbAysUoUdzQCgP2Xj1YpjVLLbX13coZBc=; b=owGbwMvMwCXGf25diOft7jLG02pJDMkl0z8c2bBOhXPxhhcv27v8VlxRD5I49mFC+5c7y0NDmwr5 vVzPd5SyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAi5l8Z/ocvNH5QtEf3/525N/MSzF 9OCLPs6bb4nXLoWZLpm3m5WQ2MDJOd7b994WDqmGTY4Hjm3y0mnqA47QQfk7OVhVcu9lg2cgMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

In hmat_register_target_initiators(), the variable 'best' gets
initialized in the outer per-locality-type for loop. The initialization
just before setting up 'Access 1' targets was unnecessary. Remove it.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/numa/hmat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 23f49a2f4d14..144a84f429ed 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -644,7 +644,6 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
 	list_sort(p_nodes, &initiators, initiator_cmp);
-	best = 0;
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
-- 
2.38.1

