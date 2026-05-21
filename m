Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CA1349CC1
	for <nvdimm@lists.linux.dev>; Thu, 21 May 2026 07:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.254.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347904; cv=none; b=aOiRkUaCkzf3lGvod5Nkv5K/opOunU+kZg7ykgxRL2wCnRAXCl7v5PN1nbtm10IhovF0rfv3oE0krz10RVynOhr6b/BPet9VxIoMNKfo0Bv0ce2B0Fb7fSX7JQiZldMkOKZapQcJ++GcgUMyQnnhq9FiXhQfNB4GGDYZ5jjF0V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347904; c=relaxed/simple;
	bh=rDf3nABXNo8vMeXp5HldaYDR5skbzeT8SXMZO6GsOxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzGW3C6rC7QTAd7NchpWyeLh9T6qtrurAXPe9A+cwMYkGb8EqZC9Sd6PwPT7HWzPvX/QntjgpZL5jstzMQCmShOhYNwiXvC1bDhckmY81pA1PdgSitCNRZTfFJfueGlE4N/V85IxU7BFXZkk66OpYaXKWg9JyAYDLjpmnO30WTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com; spf=pass smtp.mailfrom=ilvokhin.com; dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b=etH6b9Zu; arc=none smtp.client-ip=178.62.254.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ilvokhin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ilvokhin.com header.i=@ilvokhin.com header.b="etH6b9Zu"
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 04328D092B;
	Thu, 21 May 2026 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347901;
	bh=lDIPRhu4eC69IHX//CJMd4ihavt8RgvIqQIf1iXGap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etH6b9ZuDhqX5Sc5pXZJL0mvSO27yOgyFftApBQDRLpChk0d76J/dnjr9Me92J7s/
	 ZJKGaD44Ap9wM7bVcPGgw4E281DFuplUA3GHeDd8MZtjlQNmb8BgD1KF11wYyDYbZJ
	 iR8eQxFuk+u4YlwUZ/kmzMnnQhVm73DDT+RmYKNA=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 2/4] genirq: Move NULL check into irqdesc_lock guard unlock expression
Date: Thu, 21 May 2026 07:18:02 +0000
Message-ID: <2b4e1f690f12c8fb58f286846037c0f6d9656c46.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
constructor that can set .lock to NULL.

In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
move the NULL check into the irqdesc_lock unlock expression, making the
NULL handling explicit at the call site.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 kernel/irq/internals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 9412e57056f5..347cb333b9fe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -171,7 +171,7 @@ void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
 
 __DEFINE_CLASS_IS_CONDITIONAL(irqdesc_lock, true);
 __DEFINE_UNLOCK_GUARD(irqdesc_lock, struct irq_desc,
-		      __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
+		      if (_T->lock) __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
 		      unsigned long flags; bool bus);
 
 static inline class_irqdesc_lock_t class_irqdesc_lock_constructor(unsigned int irq, bool bus,
-- 
2.53.0-Meta

