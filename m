Return-Path: <owner-linux-mm@kvack.org>
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 5/5] mm/migrate: Add page movement trace event
Date: Thu, 21 Mar 2019 14:01:57 -0600
Message-Id: <20190321200157.29678-6-keith.busch@intel.com>
In-Reply-To: <20190321200157.29678-1-keith.busch@intel.com>
References: <20190321200157.29678-1-keith.busch@intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Trace the source and destination node of a page migration to help debug
memory usage.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 include/trace/events/migrate.h | 26 ++++++++++++++++++++++++++
 mm/migrate.c                   |  1 +
 2 files changed, 27 insertions(+)

diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index d25de0cc8714..3d4b7131e547 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -6,6 +6,7 @@
 #define _TRACE_MIGRATE_H
 
 #include <linux/tracepoint.h>
+#include <trace/events/mmflags.h>
 
 #define MIGRATE_MODE						\
 	EM( MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
@@ -71,6 +72,31 @@ TRACE_EVENT(mm_migrate_pages,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
+
+TRACE_EVENT(mm_migrate_move_page,
+
+	TP_PROTO(struct page *from, struct page *to, int status),
+
+	TP_ARGS(from, to, status),
+
+	TP_STRUCT__entry(
+		__field(struct page *, from)
+		__field(struct page *, to)
+		__field(int, status)
+	),
+
+	TP_fast_assign(
+		__entry->from = from;
+		__entry->to = to;
+		__entry->status = status;
+	),
+
+	TP_printk("node from=%d to=%d status=%d flags=%s refs=%d",
+		page_to_nid(__entry->from), page_to_nid(__entry->to),
+		__entry->status,
+		show_page_flags(__entry->from->flags & ((1UL << NR_PAGEFLAGS) - 1)),
+		page_ref_count(__entry->from))
+);
 #endif /* _TRACE_MIGRATE_H */
 
 /* This part must be outside protection */
diff --git a/mm/migrate.c b/mm/migrate.c
index 83fad87361bf..d97433da12c0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -997,6 +997,7 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 			page->mapping = NULL;
 	}
 out:
+	trace_mm_migrate_move_page(page, newpage, rc);
 	return rc;
 }
 
-- 
2.14.4
