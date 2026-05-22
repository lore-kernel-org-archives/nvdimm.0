Received: from a11-132.smtp-out.amazonses.com (a11-132.smtp-out.amazonses.com [54.240.11.132])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D0A3806DB
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477587; cv=none; b=HZnnmR2C9AlcTb7kst9g6qGa/ThUZX0lAKOOjXzThrSbXLm1mIdg2+Jad8624TxzqxJ/PexJRIt7mhxLj5qAYOhKCXrGVs3WrZ7ObLolnYR7NyG+bBid2rpd19jw6rnRGtPOpU3qd3jLpV1PzVW+DLec0L+C0VVut3UvCG4EPr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477587; c=relaxed/simple;
	bh=tu4UxLvc/sX88yWSCNCjqG5f+79wuYtCVrBLE5YzpsA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=fU9bNXirF/Jr+OX1jSq+CFgfuuho/8xP3VnDyVooT5MfqviEuW/B7SFoPRrXkGP5ESNUAHxo3axAwp1Tg7k7T1ygfgpmKm/NHvkLjIElx1XPe6EsMHC7XUmnxOh+BN6uA3M5gVZdQYV4on1zba+8NwZbOSice4Nh72H6um/3P0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=kED1lgXP; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=sAOqeUb0; arc=none smtp.client-ip=54.240.11.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="kED1lgXP";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="sAOqeUb0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477584;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=tu4UxLvc/sX88yWSCNCjqG5f+79wuYtCVrBLE5YzpsA=;
	b=kED1lgXPlJTY7/crAwpr7k767A3gJ5aMjJ+7Rj6Mk8c5nKIXwassGeLkb9Wn/CGW
	W3ERAdGbVqRnUHcYq++K+p7Ahj27ZXg6O0lR2VtupXeVlVaH0pB1nAkY+64Fk0iqLat
	udTh/r9/b29t3TdBz0djGOYozPPZubC0mVL2fGLs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477584;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=tu4UxLvc/sX88yWSCNCjqG5f+79wuYtCVrBLE5YzpsA=;
	b=sAOqeUb08ZdiS8uGMFxjMwsPlirfskMIOel9VLwJqrYfyG+oFzHsqWXydw90i7Gy
	oWQaOtbMpX0Y++pyLdzbavdDSHne4AjruBfJdq4yo5OzMbzK0FD+Diq8IXxuhzdaqHL
	H1metyQlAV3JWrXe4s31587F6vh9Lpi3VXLRaBx4=
Subject: [PATCH V2 7/7] dax: fsdev.c minor formatting cleanup
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
Date: Fri, 22 May 2026 19:19:43 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
References: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com> 
 <20260522191937.79247-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h+7e4zSojcNRQ2wV9eJQr6w4gAADXpr
Thread-Topic: [PATCH V2 7/7] dax: fsdev.c minor formatting cleanup
X-Wm-Sent-Timestamp: 1779477582
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e512117cd-2a9b3b34-6f2c-42e3-9110-71aef0463358-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.11.132

From: John Groves <John@Groves.net>=0D=0A=0D=0AAddress some comments from=
 Jonathan that were missed in the merged=0D=0Aseries. Fix line wrapping i=
n fsdev_dax_recovery_write() and=0D=0Afsdev_dax_zero_page_range() signatu=
res.=0D=0A=0D=0AFixes: 099c81a1f0ab ("dax: Add dax_operations for use by =
fs-dax on fsdev dax")=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=
=0A---=0D=0A drivers/dax/fsdev.c | 15 ++++++++-------=0D=0A 1 file change=
d, 8 insertions(+), 7 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fs=
dev.c b/drivers/dax/fsdev.c=0D=0Aindex f74fd1bb7f4c5..dafa24761e8ff 10064=
4=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -=
45,8 +45,8 @@ static void fsdev_write_dax(void *addr, struct page *page,=0D=
=0A }=0D=0A=20=0D=0A static long __fsdev_dax_direct_access(struct dax_dev=
ice *dax_dev, pgoff_t pgoff,=0D=0A-=09=09=09long nr_pages, enum dax_acces=
s_mode mode, void **kaddr,=0D=0A-=09=09=09unsigned long *pfn)=0D=0A+=09=09=
long nr_pages, enum dax_access_mode mode, void **kaddr,=0D=0A+=09=09unsig=
ned long *pfn)=0D=0A {=0D=0A =09struct dev_dax *dev_dax =3D dax_get_priva=
te(dax_dev);=0D=0A =09size_t size =3D nr_pages << PAGE_SHIFT;=0D=0A@@ -90=
,7 +90,8 @@ static int fsdev_dax_zero_page_range(struct dax_device *dax_d=
ev,=0D=0A =09long rc;=0D=0A=20=0D=0A =09WARN_ONCE(nr_pages > 1, "%s: nr_p=
ages > 1\n", __func__);=0D=0A-=09rc =3D __fsdev_dax_direct_access(dax_dev=
, pgoff, 1, DAX_ACCESS, &kaddr, NULL);=0D=0A+=09rc =3D __fsdev_dax_direct=
_access(dax_dev, pgoff, 1, DAX_ACCESS,=0D=0A+=09=09=09=09       &kaddr, N=
ULL);=0D=0A =09if (rc < 0)=0D=0A =09=09return rc;=0D=0A =09fsdev_write_da=
x(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);=0D=0A@@ -98,15 +99,15 @@ static int=
 fsdev_dax_zero_page_range(struct dax_device *dax_dev,=0D=0A }=0D=0A=20=0D=
=0A static long fsdev_dax_direct_access(struct dax_device *dax_dev,=0D=0A=
-=09=09  pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,=0D=0A-=09=
=09  void **kaddr, unsigned long *pfn)=0D=0A+=09=09pgoff_t pgoff, long nr=
_pages, enum dax_access_mode mode,=0D=0A+=09=09void **kaddr, unsigned lon=
g *pfn)=0D=0A {=0D=0A =09return __fsdev_dax_direct_access(dax_dev, pgoff,=
 nr_pages, mode,=0D=0A =09=09=09=09=09 kaddr, pfn);=0D=0A }=0D=0A=20=0D=0A=
-static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff=
_t pgoff,=0D=0A-=09=09void *addr, size_t bytes, struct iov_iter *i)=0D=0A=
+static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev,=0D=0A=
+=09=09pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)=0D=0A=
 {=0D=0A =09return _copy_from_iter_flushcache(addr, bytes, i);=0D=0A }=0D=
=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
