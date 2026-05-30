Received: from a48-182.smtp-out.amazonses.com (a48-182.smtp-out.amazonses.com [54.240.48.182])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F25933FE15
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159905; cv=none; b=Br2lxhWBmxGGJloNXSposIqcDqYyVAOPpFF3IOE8YSXYfXb5DNbQXnXOoDlTkPt3f1sy/IzsqsfyWQgc+WK25fkvxNbewS8UD96wB7rTIU2Vw0G858lYx6+mCAHGqM0SBvmxKeySDNnXrGxvIaezNuNSyAu0y8E4muqhiD1TkNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159905; c=relaxed/simple;
	bh=L5xYVi2QZJv44xJcmbAbXnoFRFwbN/tCZvKiAg6bt9w=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=qAJs+Hw7Z9jWxXSw6ZrldvH0akOPK/B+uvVwYUjAOy5qVieRWSdP1ld80gxfaoiqGGRrXTd6QKIcb9hQdtMyCOI+zNOAgkFiJFzxiY9peWXrvBZvS/FQOwbU7NjjY4PQKfHdKrrrasHWEX36tV3b0mUgBVFEV9XBxBDW9oj9aKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=fo7w1DY5; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=C+NYdSiv; arc=none smtp.client-ip=54.240.48.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="fo7w1DY5";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="C+NYdSiv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159903;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=L5xYVi2QZJv44xJcmbAbXnoFRFwbN/tCZvKiAg6bt9w=;
	b=fo7w1DY5Ru77Q3X3xW8h9vBe9m72LF1O/6upWA2XGktOPFUsCQRMh/CbXLVOaUsk
	zeeGJyVZZ/HUxnmauoAmi7UUXVZFeVRj9/OK2463n+sKbiRmiE53CeqzNZ5+YvsTdzn
	cweYAcWm6dwok8bVbxaEx30xSCz5jpDB32bcxYwM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159903;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=L5xYVi2QZJv44xJcmbAbXnoFRFwbN/tCZvKiAg6bt9w=;
	b=C+NYdSivpdt7Atb30UXWZYz3STP2eiDMgA5xWXccNgq42tVaakvzs/0fD+udFe01
	98wgaIEyeMKRABZ6aSVD4jNmza14bFk/tpGSZMZHKGPChuSIAJCrc6INWNfC+PCOzGH
	dsFOWGZtsFh8NKrxh/OBFeQXYGZh4rWD5QlKbc6s=
Subject: [PATCH V3 9/9] dax: fsdev.c minor formatting cleanup
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
Date: Sat, 30 May 2026 16:51:43 +0000
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
 <20260530165135.6738-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAADzrI
Thread-Topic: [PATCH V3 9/9] dax: fsdev.c minor formatting cleanup
X-Wm-Sent-Timestamp: 1780159902
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cc759d-7a962ed0-0f9f-4ab6-b6d3-08c171fc6558-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.48.182

From: John Groves <John@Groves.net>=0D=0A=0D=0AAddress some comments from=
 Jonathan that were missed in the merged=0D=0Aseries. Fix line wrapping i=
n fsdev_dax_recovery_write() and=0D=0Afsdev_dax_zero_page_range() signatu=
res.=0D=0A=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0ASigne=
d-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/fsdev.=
c | 15 ++++++++-------=0D=0A 1 file changed, 8 insertions(+), 7 deletions=
(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0A=
index aac0130ab2833..ff936021d7aec 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=
=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -45,8 +45,8 @@ static void fsdev_wri=
te_dax(void *addr, struct page *page,=0D=0A }=0D=0A=20=0D=0A static long =
__fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A=
-=09=09=09long nr_pages, enum dax_access_mode mode, void **kaddr,=0D=0A-=09=
=09=09unsigned long *pfn)=0D=0A+=09=09long nr_pages, enum dax_access_mode=
 mode, void **kaddr,=0D=0A+=09=09unsigned long *pfn)=0D=0A {=0D=0A =09str=
uct dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A =09size_t size =3D=
 nr_pages << PAGE_SHIFT;=0D=0A@@ -80,7 +80,8 @@ static int fsdev_dax_zero=
_page_range(struct dax_device *dax_dev,=0D=0A =09long rc;=0D=0A=20=0D=0A =
=09WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);=0D=0A-=09rc =3D=
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
