Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5F43876DE
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 05:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788411755; cv=none; b=EDicqrcCQPCOmyJQ97KAdQaoOcsAIQMRtHihBbj51X4FcmVxsyNF1M57q9ojU1buhTqcMz5M+6ImpaQnmpWZG0YmflwAoxga69AiKdNj6hefPaCst2k7rl4lYPO2Mg95ynaGzwGEgcRQ6gBUtTj7M8tFxUhKy9HEz3knPEIIlAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788411755; c=relaxed/simple;
	bh=DrMHlZMozqyndKpLSTkuk0p4rmxGy43whNlgBg2HojY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VZtPPgissXcBw47Yc01FiahK0lyyoAWMUHHnoCSoOYlbidDCQ1x1B+dBOytOLJp58LK6/YENVJbIOuzAj2sf5NYM8nSvgs6Gqwwv8nLIl0F3RJP//NmhwlJZ8Ftf2njyxkYYv75gHrW81Ieh8Ic8bTqsZ9D8uNIgKnVMrWAoE6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UBhr9U4l; arc=none smtp.client-ip=91.218.175.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UBhr9U4l"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DrMHlZMozqyndKpLSTkuk0p4rmxGy43whNlgBg2HojY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788411750; v=1; x=1789016550;
 b=UBhr9U4l70Ia6v4yKYX+BTYZmM64gYTfy7XFSE7748EO9XzWxGOCtqaJwuZYRERfHVTI+Jge
 A0yMgk8y6gLOzBW69bl0zPVh0ejg+RYCMjAtnV2oH4XFQEN1/EjIkI3HDK/FffzYbXfH/4GQ+dl
 WV8QljyKHNsMkIVXFs5Wt5ZY=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id df70ff5a37511f08;
	Thu, 03 Sep 2026 05:02:20 +0000
X-Mizu-Trace-ID: df70ff5a37511f08
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] fs/dax: Remove redundant deferred list initialization
Date: Thu,  3 Sep 2026 13:02:07 +0800
Message-ID: <20260903050207.7015-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

prep_compound_page() calls prep_compound_head(), which initializes
folio->_deferred_list for compound folios with an order greater than one.
Therefore, dax_folio_init() initializes the list twice for large DAX
folios.

Remove the redundant initialization from dax_folio_init(). This leaves
the behavior unchanged and keeps compound folio initialization
centralized in prep_compound_head().

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 fs/dax.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6ba50142eeb2..dad4efea7964 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -469,8 +469,6 @@ static void dax_folio_init(void *entry)
 
 	if (order > 0) {
 		prep_compound_page(&folio->page, order);
-		if (order > 1)
-			INIT_LIST_HEAD(&folio->_deferred_list);
 		WARN_ON_ONCE(folio_ref_count(folio));
 	}
 }
-- 
2.50.1 (Apple Git-155)

