Received: from a11-75.smtp-out.amazonses.com (a11-75.smtp-out.amazonses.com [54.240.11.75])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B5633C507
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539652; cv=none; b=HN7FcfmX99O8nVGM3nb1GLOgAFmzA/xiDpo+OZmGvR8PuMwXfd0kuwIlJAPI/3KAjvHi2bHXurc6m9nzt0Cek21GnGh2zaXmYnffhNB65gMwHHU6l6Sg2NaYDhz09Qpej7P6oN+uDvqL0Lf9psFT83GaRu60XG/UcTfrRIWljw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539652; c=relaxed/simple;
	bh=5N8EXj14zPE1mpHheAlqf87OOHBHYU48PnTUIyCRx30=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=c5+oMmDeTuBDP84aBNIfEaNgpol14UPR2yGEWbk1TFkKMNl5lpijsveRcCXz+6bHlFCn8bmcTxNFKWpAds6lCfFQfp3BJD8Sdtsl7WNtlbXQEj3pts2Zwf6Ditu6R5KtX9opYriLhnqGf5nEgPSKwY4o+cqesYWkMYc7fBAfrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=RH7VswIb; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=OxdJPcO9; arc=none smtp.client-ip=54.240.11.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="RH7VswIb";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OxdJPcO9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539650;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=5N8EXj14zPE1mpHheAlqf87OOHBHYU48PnTUIyCRx30=;
	b=RH7VswIblYYz3s4MpcUd5LEKc0CelXrmamOqy7aom+k5ha9B8rwi9ab5F2eVnrKY
	dV2DB+zlxCLMW+ulzcP3kc9+2fZCirJCsHTSt4ohgEqfSh06+l1u4eKJAkRK9SWYgfp
	vTteVpTtLDStVLQeWuEhfNpTCjB/pG89wjn9DQWo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539650;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=5N8EXj14zPE1mpHheAlqf87OOHBHYU48PnTUIyCRx30=;
	b=OxdJPcO9PPXS06FU/F4/nxnWHsMRaF1JceXIh9tehSZ3YSn6b97jBILfsDfiIm0+
	U2EgEKK6Enb6WDpvZzEeQO7JUVj4YXle4ScHFd4FANqa4sr1s8gWIUoUGwoCdYsivo9
	41jTzwL8PcxGEItQpoY+a8OplJCQ+h8fYI6DBl8Q=
Subject: [PATCH V6 08/10] dax: read holder_ops once in
 dax_holder_notify_failure()
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
	=?UTF-8?Q?Richard_Cheng?= <icheng@nvidia.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 15 Jun 2026 16:07:30 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com>
References: 
 <0100019ecc080a68-8dc0c99f-ab17-4aa9-83d9-490e9c97ac2e-000000@email.amazonses.com> 
 <20260615160724.17584-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAAEH6G
Thread-Topic: [PATCH V6 08/10] dax: read holder_ops once in
 dax_holder_notify_failure()
X-Wm-Sent-Timestamp: 1781539649
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc09bb56-5ecc9c6b-35ba-44f8-b112-921b01b34478-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.11.75

From: John Groves <John@Groves.net>=0D=0A=0D=0Adax_holder_notify_failure(=
) reads dax_dev->holder_ops twice without=0D=0AREAD_ONCE() -- once for th=
e NULL check and once for the indirect=0D=0Anotify_failure() call. A conc=
urrent fs_put_dax() can clear holder_ops=0D=0Abetween the two reads, so t=
he check can observe a non-NULL pointer while=0D=0Athe call dereferences =
NULL. (kill_dax() also clears holder_ops, but only=0D=0Aafter synchronize=
_srcu(), so it cannot race a reader that is inside=0D=0Adax_read_lock(); =
fs_put_dax() does no such synchronization.)=0D=0A=0D=0AFetch holder_ops o=
nce into a local with READ_ONCE() so the NULL check and=0D=0Athe indirect=
 call observe the same value.=0D=0A=0D=0AFixes: 8012b86608552 ("dax: intr=
oduce holder for dax_device")=0D=0ASuggested-by: Richard Cheng <icheng@nv=
idia.com>=0D=0AReviewed-by: Richard Cheng <icheng@nvidia.com>=0D=0ASigned=
-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/super.c=
 | 12 ++++++++++--=0D=0A 1 file changed, 10 insertions(+), 2 deletions(-)=
=0D=0A=0D=0Adiff --git a/drivers/dax/super.c b/drivers/dax/super.c=0D=0Ai=
ndex 25cf99dd9360b..433cd431a6c06 100644=0D=0A--- a/drivers/dax/super.c=0D=
=0A+++ b/drivers/dax/super.c=0D=0A@@ -303,6 +303,7 @@ EXPORT_SYMBOL_GPL(d=
ax_recovery_write);=0D=0A int dax_holder_notify_failure(struct dax_device=
 *dax_dev, u64 off,=0D=0A =09=09=09      u64 len, int mf_flags)=0D=0A {=0D=
=0A+=09const struct dax_holder_operations *ops;=0D=0A =09int rc, id;=0D=0A=
=20=0D=0A =09id =3D dax_read_lock();=0D=0A@@ -311,12 +312,19 @@ int dax_h=
older_notify_failure(struct dax_device *dax_dev, u64 off,=0D=0A =09=09got=
o out;=0D=0A =09}=0D=0A=20=0D=0A-=09if (!dax_dev->holder_ops) {=0D=0A+=09=
/*=0D=0A+=09 * Read holder_ops once: a concurrent fs_put_dax() can clear =
it without=0D=0A+=09 * synchronizing against readers. Without the single =
fetch the compiler=0D=0A+=09 * could reload between the NULL check and th=
e call and dereference a=0D=0A+=09 * NULL ops.=0D=0A+=09 */=0D=0A+=09ops =
=3D READ_ONCE(dax_dev->holder_ops);=0D=0A+=09if (!ops) {=0D=0A =09=09rc =3D=
 -EOPNOTSUPP;=0D=0A =09=09goto out;=0D=0A =09}=0D=0A=20=0D=0A-=09rc =3D d=
ax_dev->holder_ops->notify_failure(dax_dev, off, len, mf_flags);=0D=0A+=09=
rc =3D ops->notify_failure(dax_dev, off, len, mf_flags);=0D=0A out:=0D=0A=
 =09dax_read_unlock(id);=0D=0A =09return rc;=0D=0A--=20=0D=0A2.53.0=0D=0A=
=0D=0A
