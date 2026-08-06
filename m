Received: from a48-181.smtp-out.amazonses.com (a48-181.smtp-out.amazonses.com [54.240.48.181])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A072307AC7
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 00:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785976125; cv=none; b=pXApcmVaaxeCXEJp6ezoX0FCbLOQ2WRtK80WHk9+4l/DUVdK/PXsSysn2JUifBIT7yDpC0jGoyid0Godqos94clz3SYcY009NgQ6IpzpS06OG3n/SQJXVvLb09sT08ztlYDNbnPf55GVcWkdSKC5/ugvJGYt+M+UcL2fjgWvYBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785976125; c=relaxed/simple;
	bh=kl24c4r+F4VrSfxC6I+3VJNboUOE2bT+8ZU3aJDzXNM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=AuKHedxoL1x7W08r4XS6hvD3xysGNzeJzEafrx1Y1l1Kaw8y3c9UCopJN5SGfishKZOJCKHkahbbFLSg7eEkQTAmwUONwjoiEyTJqL3N9baMayU2PG1yEqk2DFo9zzBHppNzCeIP/UcyKvydlRinm/r2uBM7FWGw8RC0N1pT5LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Igm0JNcB; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=eK9c5oYM; arc=none smtp.client-ip=54.240.48.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Igm0JNcB";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="eK9c5oYM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785976122;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Reply-To:Message-Id;
	bh=kl24c4r+F4VrSfxC6I+3VJNboUOE2bT+8ZU3aJDzXNM=;
	b=Igm0JNcB0597sI75kRZ2EC1QrfXdDXeZe5T5PqWJ9RtFE7Hqe8Ef6qMRFTHNrDN9
	S1s1bzWtzt02dQOfh1MYVelKgmW6O5VLEfwXxEp6yAKk0rPo8LIWLZxUR2qe5FdH1T0
	jo3VSAJvUmA18/y8kbusN9LJdxWL3SJohphEbwkY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785976122;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Reply-To:Message-Id:Feedback-ID;
	bh=kl24c4r+F4VrSfxC6I+3VJNboUOE2bT+8ZU3aJDzXNM=;
	b=eK9c5oYMrxgJdvki4ALiAiE8OUdxkT1UmwKNiUxYVSkSViNsIEiQkkS3Dk/rBF91
	SyO2keG4PHBhSeVk/aLsjynNRuZjHRLP4apG695cEKHfyFCngtbH1MNqeEEtdaYsETQ
	r0/N1xRBtla0tsXZcSvnYyVxD2mNQ4GYHt0qQJqQ=
Subject: [PATCH] dax: Remove unused export of dax_dev_get()
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Alison_Schofield?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Cc: =?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <John@Groves.net>
Date: Thu, 6 Aug 2026 00:28:42 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260806002830.2610417-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdJTqHSqNOYbcPTuixEb1oOAfS1Q==
Thread-Topic: [PATCH] dax: Remove unused export of dax_dev_get()
Reply-To: =?UTF-8?Q?John_Groves?= <john@groves.net>
X-Wm-Sent-Timestamp: 1785976121
X-Original-Mailer: git-send-email 2.53.0
Message-ID: <0100019fd478eb93-a6bd48e4-b5f1-4871-93d4-582802956e6c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.06-54.240.48.181

From: John Groves <John@Groves.net>=0D=0A=0D=0ACommit 2ae624d5a555 ("dax:=
 export dax_dev_get()") exported dax_dev_get()=0D=0Ain v7.2 for famfs, wh=
ich has not merged. The export has never had an=0D=0Ain-tree caller, so m=
ake dax_dev_get() static again.=0D=0A=0D=0ASigned-off-by: John Groves <Jo=
hn@Groves.net>=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0AR=
eviewed-by: Alison Schofield <alison.schofield@intel.com>=0D=0A---=0D=0A =
drivers/dax/super.c | 3 +--=0D=0A include/linux/dax.h | 1 -=0D=0A 2 files=
 changed, 1 insertion(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/=
dax/super.c b/drivers/dax/super.c=0D=0Aindex 25cf99dd9360..d4ab60c406bf 1=
00644=0D=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A=
@@ -521,7 +521,7 @@ static int dax_set(struct inode *inode, void *data)=0D=
=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A-struct dax_device *dax_dev_get(de=
v_t devt)=0D=0A+static struct dax_device *dax_dev_get(dev_t devt)=0D=0A {=
=0D=0A =09struct dax_device *dax_dev;=0D=0A =09struct inode *inode;=0D=0A=
@@ -544,7 +544,6 @@ struct dax_device *dax_dev_get(dev_t devt)=0D=0A=20=0D=
=0A =09return dax_dev;=0D=0A }=0D=0A-EXPORT_SYMBOL_GPL(dax_dev_get);=0D=0A=
=20=0D=0A struct dax_device *alloc_dax(void *private, const struct dax_op=
erations *ops)=0D=0A {=0D=0Adiff --git a/include/linux/dax.h b/include/li=
nux/dax.h=0D=0Aindex fe6c3ded1b50..f6b4549a8b4b 100644=0D=0A--- a/include=
/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -54,7 +54,6 @@ struct=
 dax_device *alloc_dax(void *private, const struct dax_operations *ops);=0D=
=0A void *dax_holder(struct dax_device *dax_dev);=0D=0A void put_dax(stru=
ct dax_device *dax_dev);=0D=0A void kill_dax(struct dax_device *dax_dev);=
=0D=0A-struct dax_device *dax_dev_get(dev_t devt);=0D=0A void dax_write_c=
ache(struct dax_device *dax_dev, bool wc);=0D=0A bool dax_write_cache_ena=
bled(struct dax_device *dax_dev);=0D=0A bool dax_synchronous(struct dax_d=
evice *dax_dev);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
