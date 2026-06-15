Received: from a48-181.smtp-out.amazonses.com (a48-181.smtp-out.amazonses.com [54.240.48.181])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2D7408616
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539667; cv=none; b=aMCFOROCPtGXDKm49D5KCbbgIGisMcBZZT8xZZkvF/0HkSg6/lStfoGnKOUpJq/Rr4ajlRqg/JaW7whjKxkGn0gs4FLRrjzHwk9Aozav0oOkeogUwJtbw6KWnbXk7aJA7ecfK3dHFpi0tm4sMLv7YLjZE23qNUOVGSp7fdQ788U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539667; c=relaxed/simple;
	bh=CC/Qek7kjCT79kHcu+jRRqbCPCLIBOdHdlJVe3bH0yk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=W4obXdkx88JlY3xerEZDayLGw5qwpStkFHOqAaRDODTPhxgWfvV/2RBQ5q7Mwr+dl+cSGCR7Ez5bGkgMvPBFQEUKK7d9izbUoFcKnxzVcumFUbo/lSpJ/0Vdav81dA5lKH+3npUWow+kK3vlkNFWLEpgnuhT4zoMQPi0FHQ+1gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=HdZlGyuZ; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=s1xoeuiA; arc=none smtp.client-ip=54.240.48.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="HdZlGyuZ";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="s1xoeuiA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539665;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=CC/Qek7kjCT79kHcu+jRRqbCPCLIBOdHdlJVe3bH0yk=;
	b=HdZlGyuZZT6ApVeUuMgpm3WJ2kQGn50IV/MEnOtt69fu2dThKVrrdVNeWo8UvZh2
	JbPlRyn20fHAYuA1HsENq3uHCVTVyu3L+OX1aJETwdO/BiqRsVrBxyZH9u81j43Dq2x
	YZMzvlUl0hayksSnqFp+z0sM11AS5hGO00IHO1LE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539665;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=CC/Qek7kjCT79kHcu+jRRqbCPCLIBOdHdlJVe3bH0yk=;
	b=s1xoeuiAx45PmNYULbRypB5sg4lIvIH6NCvxIy/p1AjIfxCJj6nVBF1RwNrWinls
	MsfK/EHyS6Bnlg4vUEPM6LQ9xj6gCCrJOkQzPmV9siBaDJwqzaeTHLSRMW0F6YFZEND
	7fPCK+yjnDVgY75cIJpWAsaf3rPbNukquvAC1XgY=
Subject: [PATCH V6 10/10] dax: fsdev.c minor formatting cleanup
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
Date: Mon, 15 Jun 2026 16:07:45 +0000
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
 <20260615160741.17618-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAAEs6G
Thread-Topic: [PATCH V6 10/10] dax: fsdev.c minor formatting cleanup
X-Wm-Sent-Timestamp: 1781539664
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc09f607-b558c192-72fc-4c2d-9f64-3b82796e7dd4-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.48.181

From: John Groves <John@Groves.net>=0D=0A=0D=0AAddress some comments from=
 Jonathan that were missed in the merged=0D=0Aseries. Fix line wrapping i=
n fsdev_dax_recovery_write() and=0D=0Afsdev_dax_zero_page_range() signatu=
res.=0D=0A=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0ARevie=
wed-by: Alison Schofield <alison.schofield@intel.com>=0D=0ASigned-off-by:=
 John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/fsdev.c | 15 ++=
++++++-------=0D=0A 1 file changed, 8 insertions(+), 7 deletions(-)=0D=0A=
=0D=0Adiff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex d=
50891d6dc135..598604bf5ac5c 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A++=
+ b/drivers/dax/fsdev.c=0D=0A@@ -45,8 +45,8 @@ static void fsdev_write_da=
x(void *addr, struct page *page,=0D=0A }=0D=0A=20=0D=0A static long __fsd=
ev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A-=09=
=09=09long nr_pages, enum dax_access_mode mode, void **kaddr,=0D=0A-=09=09=
=09unsigned long *pfn)=0D=0A+=09=09long nr_pages, enum dax_access_mode mo=
de, void **kaddr,=0D=0A+=09=09unsigned long *pfn)=0D=0A {=0D=0A =09struct=
 dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A =09size_t size =3D =
nr_pages << PAGE_SHIFT;=0D=0A@@ -80,7 +80,8 @@ static int fsdev_dax_zero_=
page_range(struct dax_device *dax_dev,=0D=0A =09long rc;=0D=0A=20=0D=0A =09=
WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);=0D=0A-=09rc =3D =
__fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);=0D=
=0A+=09rc =3D __fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS,=0D=
=0A+=09=09=09=09       &kaddr, NULL);=0D=0A =09if (rc < 0)=0D=0A =09=09re=
turn rc;=0D=0A =09fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);=0D=0A=
@@ -88,15 +89,15 @@ static int fsdev_dax_zero_page_range(struct dax_devic=
e *dax_dev,=0D=0A }=0D=0A=20=0D=0A static long fsdev_dax_direct_access(st=
ruct dax_device *dax_dev,=0D=0A-=09=09  pgoff_t pgoff, long nr_pages, enu=
m dax_access_mode mode,=0D=0A-=09=09  void **kaddr, unsigned long *pfn)=0D=
=0A+=09=09pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,=0D=0A+=
=09=09void **kaddr, unsigned long *pfn)=0D=0A {=0D=0A =09return __fsdev_d=
ax_direct_access(dax_dev, pgoff, nr_pages, mode,=0D=0A =09=09=09=09=09 ka=
ddr, pfn);=0D=0A }=0D=0A=20=0D=0A-static size_t fsdev_dax_recovery_write(=
struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A-=09=09void *addr, size_t=
 bytes, struct iov_iter *i)=0D=0A+static size_t fsdev_dax_recovery_write(=
struct dax_device *dax_dev,=0D=0A+=09=09pgoff_t pgoff, void *addr, size_t=
 bytes, struct iov_iter *i)=0D=0A {=0D=0A =09return _copy_from_iter_flush=
cache(addr, bytes, i);=0D=0A }=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
