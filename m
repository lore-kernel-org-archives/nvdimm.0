Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170A23403E8
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779203427; cv=none; b=hZ1C+iqy/IL+PRo4Fl8nWPDAYxxRPPXAOCwb1usNXdfFdpFE/1qKiFI2wkTncAcLTJ/I0aG2XdqRS6MLceTX1DyfyIwpcHkcNj0v8Qo6adlJB8/3MCFPHBDiEpJyzCrnKMW/PFdO/8vjMqA4aQsmMWvsz7/LV9KNGKwBMb6YgO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779203427; c=relaxed/simple;
	bh=XGcc2JVzH99KOlr4mv66ep9fGd0a2+n6kDv1XuMSCDk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VMBipD0fOSgUmPU38qw7ECE8sMyFk7y8alq1B+NCjCq72+r0Zde59Qw11pImSuTEVlA/TAJkV1piTGxPl9oBKezF2cJVjurrpwMaMNRSvewgnRhrcVO44I9Mn3O0QP5Nrt+U8U1wHrgXrn/+lCpqOFlIbr9Kph5RYhI6nz5im5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ly2sZgtm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ly2sZgtm"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2bd266f6fc0so17845805ad.2
        for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779203419; x=1779808219; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNsRRNdoq/mh7bkgCE6Fn2FhIJG533x7ld3bg4XFCu8=;
        b=ly2sZgtmS2NRyi51bfFHbf3xuxybzjgOqA+yMTTWqzS0IfTMvsJpcrbzm8vlrKzQng
         imgPejzMeZpqI/n9CyRk8rycoG2GJd9xX/nCmcV5uWsoYsxb4vqSC++3/EXX0lmLM8Kn
         CofgF6+ugNwu40Ty4KbYM6vwtwO+eJPtBPSWqEa/Ls6ZhT7/FRDS1huR0wtIxCB0Zb7i
         ccwgm61JFfrx5VMtKbzaq5UTygBxsk75XIwONl0Cgu3ICMTxrq821m4yQe25wn1Zojji
         vYN0y24p6pcdCXAwUXhSszP9T9CGogn+Gspcmj+OR+jHsb6qqx6di/wmLvYQG8W0sHML
         ao0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203419; x=1779808219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNsRRNdoq/mh7bkgCE6Fn2FhIJG533x7ld3bg4XFCu8=;
        b=LE9ScK1DTMVMo+/MGKIkYhJ84+g5hjeGjq1TUI3YvP0vnpaQxFMPnMSuRURI3TeC5o
         PMJP2d8olvfPfdeua6H13+Xdz22yCSz826ls2oiuELbIr5VTut4B9Xi8sK5xJyN8f/3C
         jin6il57x5c5t2F3Ebet/WZzMAut3oSxlWUCaKrTLR/4QldUB90PU+7O7hRAC2krBFTN
         FPGHypjLmUVM3mcVNyGWh/eSgkIKcNTTEO1d0T+vQgtUeu4DoGPcA/Aqdmc/WR3Aj6S7
         hRlmOZpcsL69Bwtim4TpaXv8gCcO4bGKiWjwi3PPzVzDc+sl2jsfV1m1+j3ka2iK3EDf
         H2yg==
X-Forwarded-Encrypted: i=1; AFNElJ8PT/LEGQz0rS5F5NIqIxme9NdH7XvAYcekLSjT6/REwH2WGMRMxLKK/Jv/IqyEY6h64Ehdrao=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlkfLYuCmB33zLdooFQEAmRFcjP7rWpaKfmex6WfaXx4gpeEK9
	aWboh3ArldGn7o+zsooKGOXOSx/gqbSxKUSd1uYyf8AtKwQjAQ20tHik
X-Gm-Gg: Acq92OEBwCPbhBlc6NBd/8bi6NWkfT2O4jfZc4N0/bLH4k5pu/+rdxIiqE+pl8xnpWD
	VVIKyiRPhT90Q6VnkorPf4mvzLdmFrGLmDK1AIiKqjNPUjPGLyoQAJ6pjcg1keIcb+DCniLpElt
	SHI9kuQ2h7xvLZSUY8SMq1D9r57GFwfpdhj2MJ31moGmzExsWUjGGEbdlw9yXfRTh2cwCk76ltG
	uPLswXDsL90g1ZhHIl+wxWzXV+qqP10Nf+OonnXNybNFN+uzi4q6PsKIV5CKHTT9wrbQ4wYFa4U
	K/retXFw2YlncI023k5/of9gaRpSlhE1RaICTSqGo2J2R1j+xUB0MXxEIMrX4jQcE1i4UaWE6Df
	M88x5asmldxQFlpe/SankSHc7Uw6mGba0yO9iWX+3Nb4eqs+edF+anFj8o7tzCPt6AvKL7q271H
	DSa+4bGW15g697BEvC9TQZ134PmqnHzSAjGaXImmI+JyTvZig5mV4PJ8b9
X-Received: by 2002:a17:903:90e:b0:2bd:e452:a484 with SMTP id d9443c01a7336-2bde452a535mr99470535ad.33.1779203419298;
        Tue, 19 May 2026 08:10:19 -0700 (PDT)
Received: from arter97-x1 ([58.124.177.116])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11ce67sm193784595ad.74.2026.05.19.08.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 08:10:18 -0700 (PDT)
From: Juhyung Park <qkrwngud825@gmail.com>
To: linux-mm@kvack.org
Cc: Juhyung Park <qkrwngud825@gmail.com>,
	stable@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
Date: Wed, 20 May 2026 00:10:08 +0900
Message-ID: <20260519151008.1399226-1-qkrwngud825@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

free_pagetable() is called via free_hugepage_table() with
get_order(PMD_SIZE) = 9 to free the 2 MB vmemmap PMD leaves that back
struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
pagetable_free()"), it goes through pagetable_free() instead of
__free_pages(), and pagetable_free() ultimately calls
__free_pages(page, compound_order()) which ignores the explicit order
argument and infers it from the page's compound metadata.

The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
alloc_pages_node() without __GFP_COMP, so PG_head is not set and
compound_order() returns 0. Only the first of 512 pages of each PMD
chunk is returned to the buddy allocator on hot-remove; the remaining
511 pages stay allocated and become unreachable. Generalized: roughly
16 MB leaked per GB of hot-removed memory per cycle.

The leak affects every memory hot-remove path on x86_64 when
memmap_on_memory=N (the default), including dax_kmem, virtio-mem,
balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
memmap_on_memory=Y avoids it because free_hugepage_table() then takes
the altmap branch and does not call free_pagetable().

Reproduced with CXL memory toggled through DAX in a loop:

  daxctl reconfigure-device --mode=system-ram dax0.0 --force
  daxctl reconfigure-device --mode=devdax    dax0.0 --force

Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Cc: stable@vger.kernel.org
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dan Williams <djbw@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
---
 arch/x86/mm/init_64.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..a2301bddb647 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		pagetable_free(page_ptdesc(page));
+		/*
+		 * Use __free_pages() to honor @order: vmemmap PMD leaves
+		 * freed here are not compound pages, so pagetable_free()
+		 * would lose leak 511 of 512 pages per 2 MB chunk.
+		 */
+		__free_pages(page, order);
 	}
 }
 
-- 
2.54.0

