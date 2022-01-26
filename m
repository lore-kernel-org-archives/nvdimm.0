Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8702CB1
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 17:00:32 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id g2so21630650pgo.9
        for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 09:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ajou.ac.kr; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ZLHyK20O5fjF8tpaoo4j4wWZ9TVY0iYMrpJ/AYsNoaQ=;
        b=vrRs5jvx6MkUUyv2+3VMlJ0DdZKdb5shEnyiX6qp1PYWk/jGgYvTT5hwB+VXIgNNh/
         Sss0qn3KCFbxifeoskWZw8SC5TMnXCX/L1/7Q6Da2k0lUBZj/MLhH6/gP/BGcjs65Ujt
         G1OWv1P2NOFGz8C73t9E4E0auwqGR5PwM8qrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZLHyK20O5fjF8tpaoo4j4wWZ9TVY0iYMrpJ/AYsNoaQ=;
        b=VQT+a/AzLntY5mrzNBP/koQZpoOfqJr6Mz+7TQPjA9HkX2nhLHvqE+7b0O/Xd4sNxN
         5mcf3Rg9Jgg6asJlvdtNvGtFEKzU6OVNe2v3+MgTrxSWbL/tNbg4FJkTSjbXGTtSQI9a
         1hvpTozi1p2g3KROzxFtLnbdDukP0axcAuuE14zXDbTdoFHIQG2YVzl9CsuJjZIdSTJT
         cdIIh44t8MkEX5piUlpcK6PZRTt5cF7LS4RimknJxIa+wUpJajaQPf2KR3FMdlhNrm10
         iPnDOuvv6l1u+NM5uoM7QB3X/RLZoMR8mS4nIOp5pgPq3qyMqsw9A+dQQnk0mGuFzMNz
         AdUw==
X-Gm-Message-State: AOAM530wIIZoZjShN1UnXnjAG+EfzvL1OU16nXs0uBjFzGvPhc4ODqvS
	J3ysAdtf9SvoLgixi46IUBZ7vw==
X-Google-Smtp-Source: ABdhPJxjVpKnnpPwVrHzt9Td3FqWXgprztHCOyVZfWq6BIkg6WioylZ1Pcindlze94y0eyDQ5CLH9g==
X-Received: by 2002:a65:578b:: with SMTP id b11mr11425671pgr.318.1643216431459;
        Wed, 26 Jan 2022 09:00:31 -0800 (PST)
Received: from localhost.localdomain ([210.107.197.32])
        by smtp.googlemail.com with ESMTPSA id q6sm17540644pgb.85.2022.01.26.09.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:00:31 -0800 (PST)
From: Jonghyeon Kim <tome01@ajou.ac.kr>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonghyeon Kim <tome01@ajou.ac.kr>
Subject: [PATCH 1/2] mm/memory_hotplug: Export shrink span functions for zone and node
Date: Thu, 27 Jan 2022 02:00:01 +0900
Message-Id: <20220126170002.19754-1-tome01@ajou.ac.kr>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Export shrink_zone_span() and update_pgdat_span() functions to head
file. We need to update real number of spanned pages for NUMA nodes and
zones when we add memory device node such as device dax memory.

Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
---
 include/linux/memory_hotplug.h | 3 +++
 mm/memory_hotplug.c            | 6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index be48e003a518..25c7f60c317e 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -337,6 +337,9 @@ extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long start_pfn,
 				       unsigned long nr_pages);
+extern void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
+			     unsigned long end_pfn);
+extern void update_pgdat_span(struct pglist_data *pgdat);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a9627dc784c..38f46a9ef853 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -389,7 +389,7 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
 	return 0;
 }
 
-static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
+void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
 	unsigned long pfn;
@@ -428,8 +428,9 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(shrink_zone_span);
 
-static void update_pgdat_span(struct pglist_data *pgdat)
+void update_pgdat_span(struct pglist_data *pgdat)
 {
 	unsigned long node_start_pfn = 0, node_end_pfn = 0;
 	struct zone *zone;
@@ -456,6 +457,7 @@ static void update_pgdat_span(struct pglist_data *pgdat)
 	pgdat->node_start_pfn = node_start_pfn;
 	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 }
+EXPORT_SYMBOL_GPL(update_pgdat_span);
 
 void __ref remove_pfn_range_from_zone(struct zone *zone,
 				      unsigned long start_pfn,
-- 
2.17.1

