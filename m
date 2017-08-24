Return-Path: <owner-linux-mm@kvack.org>
From: Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v2 1/2] nfit: Fix the abuse of COMPLETION_INITIALIZER_ONSTACK()
Date: Thu, 24 Aug 2017 22:22:36 +0800
Message-Id: <20170824142239.15178-1-boqun.feng@gmail.com>
In-Reply-To: <20170823152542.5150-2-boqun.feng@gmail.com>
References: <20170823152542.5150-2-boqun.feng@gmail.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, walken@google.com, Byungchul Park <byungchul.park@lge.com>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, Nicholas Piggin <npiggin@gmail.com>, kernel-team@lge.com, Boqun Feng <boqun.feng@gmail.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

COMPLETION_INITIALIZER_ONSTACK() is supposed to used as an initializer,
in other words, it should only be used in assignment expressions or
compound literals. So the usage in drivers/acpi/nfit/core.c:

	COMPLETION_INITIALIZER_ONSTACK(flush.cmp);

, is inappropriate.

Besides, this usage could also break compilations for another fix to
reduce stack sizes caused by COMPLETION_INITIALIZER_ONSTACK(), because
that fix changes COMPLETION_INITIALIZER_ONSTACK() from rvalue to lvalue,
and usage as above will report error:

	drivers/acpi/nfit/core.c: In function 'acpi_nfit_flush_probe':
	include/linux/completion.h:77:3: error: value computed is not used [-Werror=unused-value]
	  (*({ init_completion(&work); &work; }))

This patch fixes this by replacing COMPLETION_INITIALIZER_ONSTACK() with
init_completion() in acpi_nfit_flush_probe(), which does the same
initialization without any other problem.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 19182d091587..1893e416e7c0 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2884,7 +2884,7 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	 * need to be interruptible while waiting.
 	 */
 	INIT_WORK_ONSTACK(&flush.work, flush_probe);
-	COMPLETION_INITIALIZER_ONSTACK(flush.cmp);
+	init_completion(&flush.cmp);
 	queue_work(nfit_wq, &flush.work);
 	mutex_unlock(&acpi_desc->init_mutex);
 
-- 
2.14.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
