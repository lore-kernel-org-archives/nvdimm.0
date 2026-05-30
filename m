Received: from a11-121.smtp-out.amazonses.com (a11-121.smtp-out.amazonses.com [54.240.11.121])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ACC332EA7
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159883; cv=none; b=qQdn5HWR483bvNys7tfMBP+BfRZ7P4G16ldPUXb9SC476LOSnCa6Hmm6ucKSvfT31Jiex9RlhWFiWCNfgmXLVz4jbIwE5IysrEh0OKKsu5WiMkDqCJqZTeN0WQ+kr7SDM/3lCSXZyFceHG+EzGzzoGQFFD+cDkKPVAY+wPNhKgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159883; c=relaxed/simple;
	bh=oZLQq3x7F225xsGkvTwM0En1CLF8h7BIeRhyUhBbq5A=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=KmpWDV/5CakBXFoNXZHFrNXxXlmd6v9YmWQ6xBliZZloEhYcR3otke6eyOZnTt+D6weUT7jhEJb+rpc8q3cAkNrG9yL8o9VA3MIQxuMxemdcNMHwpxufcXJ7jpBPcqCIYvGJLv2jlLm11RhmYEyEimvh6x1DOZZuMg4IOyWIQnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=RHNpJRQ+; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=YMiRUOSe; arc=none smtp.client-ip=54.240.11.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="RHNpJRQ+";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="YMiRUOSe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159880;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=oZLQq3x7F225xsGkvTwM0En1CLF8h7BIeRhyUhBbq5A=;
	b=RHNpJRQ+f8+8dokFjjsgwhK/hIJjxrPYqqHjklSf0bogl58LIXfA+jE1QSIA7aaF
	6m8+5F0XE1e8acjP0doqtsD92l+6d0FRbDXnJpOgWxkeaI2U/LanaPAaVvnXe5VzGak
	1mYsPLkwm+Kzd/9YejKBBGiB3CgUbQOnvNAIZAHE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159880;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=oZLQq3x7F225xsGkvTwM0En1CLF8h7BIeRhyUhBbq5A=;
	b=YMiRUOSesI7mM7e/SOGQakShjsw1zeS1E70d4fz+CJYP20VUtjiEizAeMcv5YO9w
	GS2eWUnSLWq0YEUTKyf8eRhEX/Oftoy8O5y0f3/MxE0EJaJ/1TxwQE3SYZQ6QibjVzD
	e/Z0vdChzEqA10oGJ5xsLAT7WY0n25r9k5KevKxo=
Subject: [PATCH V3 7/9] dax: fix holder_ops race in fs_put_dax()
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
Date: Sat, 30 May 2026 16:51:20 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
References: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com> 
 <20260530165115.6704-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAAC+PF
Thread-Topic: [PATCH V3 7/9] dax: fix holder_ops race in fs_put_dax()
X-Wm-Sent-Timestamp: 1780159879
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cc1d9e-d39ff70d-4f1d-4a02-8b8e-e01c70272c0c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.11.121

From: John Groves <John@Groves.net>=0D=0A=0D=0AClear holder_ops before ho=
lder_data so that a concurrent fs_dax_get()=0D=0Acannot have its newly in=
stalled holder_ops overwritten. cmpxchg()=0D=0Aprovides release ordering =
on weakly-ordered architectures, ensuring the=0D=0AWRITE_ONCE(holder_ops,=
 NULL) store is visible to any CPU that observes=0D=0Athe holder_data rel=
ease.=0D=0A=0D=0AAdd WARN_ON() on the cmpxchg result to catch two API con=
tract=0D=0Aviolations: fs_put_dax() called by a non-holder, or called twi=
ce by=0D=0Athe same holder (double-put). Either way holder_ops has alread=
y been=0D=0Acleared, so WARN_ON() does not prevent the damage but makes t=
he bug=0D=0Avisible. (Note: "damage" is only if a non-holder causes holde=
r_ops=0D=0Ato be cleared)=0D=0A=0D=0AAlso add a kerneldoc comment documen=
ting that fs_put_dax() must only=0D=0Abe called by the current holder.=0D=
=0A=0D=0AFixes: eec38f5d86d27 ("dax: Add fs_dax_get() func to prepare dax=
 for fs-dax usage")=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A=
---=0D=0A drivers/dax/super.c | 35 ++++++++++++++++++++++++++++++++---=0D=
=0A 1 file changed, 32 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --gi=
t a/drivers/dax/super.c b/drivers/dax/super.c=0D=0Aindex 25cf99dd9360b..4=
c56ac2faacdb 100644=0D=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/dax=
/super.c=0D=0A@@ -116,11 +116,40 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev)=
;=0D=0A=20=0D=0A #if IS_ENABLED(CONFIG_FS_DAX)=0D=0A=20=0D=0A+/**=0D=0A+ =
* fs_put_dax() - release holder ownership of a dax_device=0D=0A+ * @dax_d=
ev: dax device to release (may be NULL)=0D=0A+ * @holder: the holder poin=
ter previously passed to fs_dax_get() or=0D=0A+ *          fs_dax_get_by_=
bdev(); must match exactly, as it is used=0D=0A+ *          in a cmpxchg =
to atomically release ownership=0D=0A+ *=0D=0A+ * Must only be called by =
the current holder. Clears holder_ops before=0D=0A+ * holder_data to avoi=
d a race where a concurrent fs_dax_get() could have=0D=0A+ * its newly in=
stalled holder_ops overwritten.=0D=0A+ */=0D=0A void fs_put_dax(struct da=
x_device *dax_dev, void *holder)=0D=0A {=0D=0A-=09if (dax_dev && holder &=
&=0D=0A-=09    cmpxchg(&dax_dev->holder_data, holder, NULL) =3D=3D holder=
)=0D=0A-=09=09dax_dev->holder_ops =3D NULL;=0D=0A+=09if (dax_dev && holde=
r) {=0D=0A+=09=09/*=0D=0A+=09=09 * Clear holder_ops before releasing hold=
er_data. A concurrent=0D=0A+=09=09 * dax_holder_notify_failure() that see=
s NULL ops returns=0D=0A+=09=09 * -EOPNOTSUPP cleanly. A concurrent fs_da=
x_get() that acquires=0D=0A+=09=09 * holder_data after the cmpxchg below =
is guaranteed to observe=0D=0A+=09=09 * holder_ops=3DNULL first (cmpxchg =
provides release ordering), so=0D=0A+=09=09 * its subsequent store of new=
 ops will not be overwritten.=0D=0A+=09=09 *=0D=0A+=09=09 * Two cases wil=
l trigger the WARN_ON():=0D=0A+=09=09 * - Caller is not the current holde=
r; this is an API contract=0D=0A+=09=09 *   violation, and the holder wil=
l no longer get callbacks=0D=0A+=09=09 * - Holder calls this function twi=
ce; also a contract violation=0D=0A+=09=09 *=0D=0A+=09=09 * A lock would =
be necessary to guard against the contract=0D=0A+=09=09 * violations, but=
 we WARN_ON() instead since violating the=0D=0A+=09=09 * contract is a bu=
g=0D=0A+=09=09 */=0D=0A+=09=09WRITE_ONCE(dax_dev->holder_ops, NULL);=0D=0A=
+=09=09WARN_ON(cmpxchg(&dax_dev->holder_data, holder, NULL) !=3D holder);=
=0D=0A+=09}=0D=0A =09put_dax(dax_dev);=0D=0A }=0D=0A EXPORT_SYMBOL_GPL(fs=
_put_dax);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
