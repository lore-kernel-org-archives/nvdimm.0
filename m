Received: from a11-129.smtp-out.amazonses.com (a11-129.smtp-out.amazonses.com [54.240.11.129])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148A6409104
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539661; cv=none; b=USzqQub++Wq+1L8BClYhO/IvPj9BHuxNTiyGUY7k7+YiLHfvUcJlpANuEtHggt83ddDoDMFGDmtzrL2dwsqZy/n5ul0VUzk1/yBvl+6sk2JMTvki+o3MJGlfhcYdB7Jtb30007C/1x7sjIDJWsCBfQOash42fZEpvW3oVGvvctU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539661; c=relaxed/simple;
	bh=kjOtM8kS5SlweokE7GEtRICVRj08X+VdoA5mKgs8ZzQ=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=s0190H75rEmfq7Ot/tHrnX2z7bpCsyNIvYSZ4C1mxe40aGQaBytmYQ7qCdeQTSKhWrwwyz5ZyrC8m66jNhK+uJIdb/c5/BDDnqCkiJUl/SUlJXRBt+j+J0encfpg0M1LKC6P5KF7zrgw1hV4ExVL6P0Dhq43kDzT7xZIPbG4Ip4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=e2d/K4iq; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=HtSBRqcE; arc=none smtp.client-ip=54.240.11.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="e2d/K4iq";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="HtSBRqcE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539659;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=kjOtM8kS5SlweokE7GEtRICVRj08X+VdoA5mKgs8ZzQ=;
	b=e2d/K4iqpnnyEF9CRxg/6TDoXjcJuG6waa6PcVO9jXpOthDnjArBCpcg9MUZ4Cd/
	b+ltOxfMa2r9f5mWx9DTzJ4jv89CBNUrgcfksrn+IRnhxJ/ZTQ3B+hfQlJ0JrVgLXdG
	GOd4/+KJ07buQjm76IZ2R80zGIRLuit7jqrQ0ryU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539659;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=kjOtM8kS5SlweokE7GEtRICVRj08X+VdoA5mKgs8ZzQ=;
	b=HtSBRqcEiKJAdspvZ829zEkslpWxqdGaokkZDjtEkbie0e10/fC1jUfYCUfFnimy
	q7hACGNR2dW4srfdAVGBvBF0i5+Ptn3/WtsQXZ0uOeUdem2KsLdqpk1Vd4PKhE9nwst
	AIQvfdhPFy/dO05CGMQzE9LjhkvdohNl/poeJJZU=
Subject: [PATCH V6 09/10] dax: fix holder_ops race in fs_put_dax()
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
Date: Mon, 15 Jun 2026 16:07:38 +0000
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
 <20260615160733.17601-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAAEdOl
Thread-Topic: [PATCH V6 09/10] dax: fix holder_ops race in fs_put_dax()
X-Wm-Sent-Timestamp: 1781539657
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc09dcab-2f4aa175-0b84-4b36-9e54-ebff302ebb0a-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.11.129

From: John Groves <John@Groves.net>=0D=0A=0D=0AClear holder_ops before ho=
lder_data so that a concurrent fs_dax_get()=0D=0Acannot have its newly in=
stalled holder_ops overwritten. cmpxchg()=0D=0Aprovides release ordering =
on weakly-ordered architectures, ensuring the=0D=0AWRITE_ONCE(holder_ops,=
 NULL) store is visible to any CPU that observes=0D=0Athe holder_data rel=
ease.=0D=0A=0D=0AAdd a WARN_ON() that fires only when the cmpxchg observe=
s a non-NULL=0D=0Avalue that is not @holder, i.e. fs_put_dax() called by =
something that=0D=0Ais not the current holder. That is an API contract vi=
olation; the=0D=0AWARN_ON() does not prevent the damage but makes the bug=
 visible.=0D=0A=0D=0AA NULL cmpxchg result is deliberately tolerated: kil=
l_dax() clears=0D=0Aholder_data while a holder is still attached when a d=
evice is removed=0D=0Aout from under a mounted filesystem (after deliveri=
ng MF_MEM_PRE_REMOVE).=0D=0AThe holder's subsequent fs_put_dax() - e.g. x=
fs_free_buftarg() after a=0D=0Aforced shutdown - then legitimately finds =
holder_data already NULL, so=0D=0Awarning on that case would turn support=
ed device removal into a splat=0D=0A(or a panic with panic_on_warn).=0D=0A=
=0D=0AAlso add a kerneldoc comment documenting that fs_put_dax() must onl=
y=0D=0Abe called by the current holder.=0D=0A=0D=0AFixes: eec38f5d86d27 (=
"dax: Add fs_dax_get() func to prepare dax for fs-dax usage")=0D=0ASigned=
-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/super.c=
 | 42 +++++++++++++++++++++++++++++++++++++++---=0D=0A 1 file changed, 39=
 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/super.=
c b/drivers/dax/super.c=0D=0Aindex 433cd431a6c06..45f84b0eb909a 100644=0D=
=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -116,=
11 +116,47 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);=0D=0A=20=0D=0A #if I=
S_ENABLED(CONFIG_FS_DAX)=0D=0A=20=0D=0A+/**=0D=0A+ * fs_put_dax() - relea=
se holder ownership of a dax_device=0D=0A+ * @dax_dev: dax device to rele=
ase (may be NULL)=0D=0A+ * @holder: the holder pointer previously passed =
to fs_dax_get() or=0D=0A+ *          fs_dax_get_by_bdev(); must match exa=
ctly, as it is used=0D=0A+ *          in a cmpxchg to atomically release =
ownership=0D=0A+ *=0D=0A+ * Must only be called by the current holder. Cl=
ears holder_ops before=0D=0A+ * holder_data to avoid a race where a concu=
rrent fs_dax_get() could have=0D=0A+ * its newly installed holder_ops ove=
rwritten.=0D=0A+ */=0D=0A void fs_put_dax(struct dax_device *dax_dev, voi=
d *holder)=0D=0A {=0D=0A-=09if (dax_dev && holder &&=0D=0A-=09    cmpxchg=
(&dax_dev->holder_data, holder, NULL) =3D=3D holder)=0D=0A-=09=09dax_dev-=
>holder_ops =3D NULL;=0D=0A+=09if (dax_dev && holder) {=0D=0A+=09=09void =
*prev;=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * Clear holder_ops before relea=
sing holder_data. A concurrent=0D=0A+=09=09 * dax_holder_notify_failure()=
 that sees NULL ops returns=0D=0A+=09=09 * -EOPNOTSUPP cleanly. A concurr=
ent fs_dax_get() that acquires=0D=0A+=09=09 * holder_data after the cmpxc=
hg below is guaranteed to observe=0D=0A+=09=09 * holder_ops=3DNULL first =
(cmpxchg provides release ordering), so=0D=0A+=09=09 * its subsequent sto=
re of new ops will not be overwritten.=0D=0A+=09=09 */=0D=0A+=09=09WRITE_=
ONCE(dax_dev->holder_ops, NULL);=0D=0A+=09=09prev =3D cmpxchg(&dax_dev->h=
older_data, holder, NULL);=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * prev =3D=3D=
 holder: normal release.=0D=0A+=09=09 * prev =3D=3D NULL:   already relea=
sed by kill_dax() when the=0D=0A+=09=09 *                 device was remo=
ved under a live holder;=0D=0A+=09=09 *                 not a bug.=0D=0A+=
=09=09 * prev !=3D holder (non-NULL): fs_put_dax() called by something=0D=
=0A+=09=09 *                 that is not the current holder; an API=0D=0A=
+=09=09 *                 contract violation. A lock would be needed=0D=0A=
+=09=09 *                 to guard against this, but we WARN_ON()=0D=0A+=09=
=09 *                 instead since violating the contract is=0D=0A+=09=09=
 *                 a bug.=0D=0A+=09=09 */=0D=0A+=09=09WARN_ON(prev && pre=
v !=3D holder);=0D=0A+=09}=0D=0A =09put_dax(dax_dev);=0D=0A }=0D=0A EXPOR=
T_SYMBOL_GPL(fs_put_dax);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
