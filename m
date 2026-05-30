Received: from a11-123.smtp-out.amazonses.com (a11-123.smtp-out.amazonses.com [54.240.11.123])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98887352027
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159853; cv=none; b=Tr8AWt5tXqZUok49bqaUYJ4Fo4vtJYURfUhaAOdLMT8ThGblI7wgbgFD2zy3PynboQUvz8zHzLPCGPcrHltA5k7qBNBxna7qXJBHQL7m0UIGbncv1Bi0QPQBrewVRrBdxo3O0qNemALusDZv4g7bH4C7p1vBCoPZgdwY//yKqfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159853; c=relaxed/simple;
	bh=Yjf1l0Hr5D8TWxYSANOJ867+1VU3pqr9HdNWKUkw7vA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=WLpQC6x6ylBH4I+uIXIKUWROHtrNSWL75JOK8kq62CH0lVIUqY9jq0fdTMlSzdbb3rOXtsCCYW8WMr1AyPR7SpWpxDxhfm9ayCErYop0efncwb0xcpPYr/lNbQtzg/0zT5gYVkUoyKRIoM6TNn16ia/3Qhxznfz0K/SRI0TvMNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=QuI6prOt; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KDDQ+Cut; arc=none smtp.client-ip=54.240.11.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="QuI6prOt";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KDDQ+Cut"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159850;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Yjf1l0Hr5D8TWxYSANOJ867+1VU3pqr9HdNWKUkw7vA=;
	b=QuI6prOtcMceJg75LiKCh6qOqdh89pa9QKNY/QPeLZAEGXLXzXBRMXj+tAzWVxk4
	3QxmyVd6q/FL6CLpjbgCxuRpRkSF83sld5dQ9xBt6S5GF6oRKvfYW1MXF1Mcip26hNu
	8uXb6In1MyM8SEP0lPQ7pGWQ7YxNxoSF9KGZSmpI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159850;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Yjf1l0Hr5D8TWxYSANOJ867+1VU3pqr9HdNWKUkw7vA=;
	b=KDDQ+CutO1UL66yrx/OCIK80pk78Otmf0F6x1FZeYVoETgGC9wOqZ2AWf9ueuUqf
	Ku6BpghxGS0gpfwYlUbF3sF3TdUiJ3ckcd4reppxRjqRrCzNNSXAKGZrZJhb5jjRoHh
	qb97YcQtTeEClr/TSxlDyjj0gvs0oGjIHD03TfuI=
Subject: [PATCH V3 3/9] dax/fsdev: clear vmemmap_shift when binding static
 pgmap
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sat, 30 May 2026 16:50:50 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
References: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com> 
 <20260530165045.6636-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAAB16u
Thread-Topic: [PATCH V3 3/9] dax/fsdev: clear vmemmap_shift when binding
 static pgmap
X-Wm-Sent-Timestamp: 1780159849
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cba76d-76fe26ff-33d2-4842-8eee-bd108eae6990-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.11.123

From: John Groves <John@Groves.net>

Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a static
device from device_dax (which may set vmemmap_shift based on alignment) to
fsdev_dax, the stale vmemmap_shift persists on the shared pgmap. Explicitly
zero it before devm_memremap_pages() so the vmemmap is built for order-0
folios as fsdev requires.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index f315533b299e9..dbd722ed7ab05 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -237,6 +237,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 
 		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
 	} else {
 		size_t pgmap_size;
 
-- 
2.53.0

