Received: from a10-18.smtp-out.amazonses.com (a10-18.smtp-out.amazonses.com [54.240.10.18])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6473242BE
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159874; cv=none; b=H2N3/F66cjUrin7JIy3faVSN8i4jp+xcftZhKK3vgpJHTN35nQU2FOoUEX6SpoaZmFHzmI8pgrjLTQG8I1QSVvBcWRohmjir3QohRSkdjuktma+8CxsePbMnrb0Mof1bVBcue6wjsM4/RvW2dN7V0319AaWp7jlIpmY1V246HLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159874; c=relaxed/simple;
	bh=3JS4IiXi48wZ8mqSM/0NhNQnt4SZky6TLmhaX4Q0ElQ=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=JFLa9c6Fgws10Arr0ed8TLUnENd6u9KxtRR75Wsv+RxxHhpjAOyhWyAwp+3F9vQEzPYujC+7VXaSp+K4ewYDvyhUrX35xPO6UWhWK2QNEgI83SZT0Gf0HI4szYzq0gekKAztgXLtLufGdQO2OKqk7IBQpMg95nUdI4FJD1UYwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=H6q6/yQu; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=pKJqNWp6; arc=none smtp.client-ip=54.240.10.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="H6q6/yQu";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="pKJqNWp6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159872;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=3JS4IiXi48wZ8mqSM/0NhNQnt4SZky6TLmhaX4Q0ElQ=;
	b=H6q6/yQu649zGXjI0Arc8pFqGL12NlRzVDtxr54LIxqqao5n9VQVtK9Eo+RBQWPU
	gN9BWiuyyfuMq18L/DGzG+xO38q/wHCzz8siVskngkaVs++u37wtO5pmwVk758S7ME8
	6J6AM3qY+g3omY3ulGoT2Xth7MqYJ6RWDYvDXs0U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159872;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=3JS4IiXi48wZ8mqSM/0NhNQnt4SZky6TLmhaX4Q0ElQ=;
	b=pKJqNWp6C8BAyDfOr54hBwlnyr15q7FvaA53u0za8riXKIftOL6SdGbflv2xDw7o
	Cgf3wSxqhtzLQFpiyx/P4zwvy/BYKhDK6TMGSYRDWh+JMtXGNeC+IDJKyzJjv2OXjZi
	FL67jlFs9phatuGRcKA4CYI9CdpLHIVQINQh5YD4=
Subject: [PATCH V3 6/9] dax/fsdev: fail probe on invalid pgmap offset
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
Date: Sat, 30 May 2026 16:51:12 +0000
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
 <20260530165107.6687-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAACrJB
Thread-Topic: [PATCH V3 6/9] dax/fsdev: fail probe on invalid pgmap offset
X-Wm-Sent-Timestamp: 1780159871
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cbfeba-7b2cf549-f869-4572-bc78-b32ebf16eb7c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.10.18

From: John Groves <John@Groves.net>

Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
condition means the remapped region starts after the device's data
region, which is an impossible state. Previously the probe continued
with data_offset=0, leaving virt_addr silently misaligned. Now probe
returns -EINVAL with a diagnostic message.

Fixes: 759455848df0b ("dax: Save the kva from memremap")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index a2d2eb20fb4d0..aac0130ab2833 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -310,8 +310,13 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		u64 phys = dev_dax->ranges[0].range.start;
 		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
 
-		if (!WARN_ON(pgmap_phys > phys))
-			data_offset = phys - pgmap_phys;
+		if (pgmap_phys > phys) {
+			dev_err(dev, "pgmap start %#llx exceeds data start %#llx\n",
+				pgmap_phys, phys);
+			rc = -EINVAL;
+			goto err_pgmap;
+		}
+		data_offset = phys - pgmap_phys;
 
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
-- 
2.53.0

