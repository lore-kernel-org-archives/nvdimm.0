Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01BB15CA1
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 23:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668642090; x=1700178090;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to;
  bh=51lOlSScMtNXt0xN1+cfGR14o3FY+CtRO0z+BQRrxHI=;
  b=TAsk0icdPz7zR83Dg7JHVuKCqum77zeKgGZqcJpu3DSiwcowTvZWELkx
   wmegfNN46segFVGQyk+/mZ6wJ477i2qc4YNjczanTfnc1a8+K6x3f5SSl
   dxlQE2LVqsveuVts4o1tr5lZAt6ylVWqT8RMxREk2my5So4lVtD7G4lrl
   e6NdbWfouXuOBrgXuPuLgEBreDmopESwW3bLJxIbSqStVR+LcSMTOI/Ll
   7RBwH+3KXo99x8cIALTQedo5wPFr2kFilxvMQICPCIxmRdTrhO98tnAIQ
   hZS/vBGGYMiYLnuHz5uuuw3vAJ4oO11ySAfOFq6srTiEPPZOtk4+SDwEc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339519703"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339519703"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="641848521"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="641848521"
Received: from jjeyaram-mobl1.amr.corp.intel.com (HELO [192.168.1.28]) ([10.212.1.223])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:27 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 16 Nov 2022 16:37:36 -0700
Subject: [PATCH v2 1/2] ACPI: HMAT: remove unnecessary variable initialization
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221116-acpi_hmat_fix-v2-1-3712569be691@intel.com>
References: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
In-Reply-To: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-kernel@vger.kernel.org, Chris Piper <chris.d.piper@intel.com>, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d1636
X-Developer-Signature: v=1; a=openpgp-sha256; l=1117;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=51lOlSScMtNXt0xN1+cfGR14o3FY+CtRO0z+BQRrxHI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmlpeqV387XKDrnL1W5XHjGteB445I/szYv821ZPCW64y+D
 3t3pHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIsXhGhvNT0uw5Flzl3fGsPfR98d
 4lAjamAdlH/XOymz5N+mwr+pWRYUHWnfP5Dnasz87t9dx0IzyqtjtEKoFrn0t7++qta44KcgIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In hmat_register_target_initiators(), the variable 'best' gets
initialized in the outer per-locality-type for loop. The initialization
just before setting up 'Access 1' targets was unnecessary. Remove it.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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
