Received: from a10-72.smtp-out.amazonses.com (a10-72.smtp-out.amazonses.com [54.240.10.72])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58523002B3
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140176; cv=none; b=NN5bxwtgNaDnIkWP95pwNXIgf7qg2+I2hMc44HuPs+e+Fo919r0xomkckD7WUrQC1FsbfLOu9200T8wJ2l56U4hQzs8ScBoMtaJodpBlK45VpegRjuZiF/yVAOGXn8yCi9RLakneXIcLVEApqMVFIo9qiceiSJd2HcUK2juu3qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140176; c=relaxed/simple;
	bh=0193u6d6wUudY8MxIwPxm5G3HN7pVR0sP/eDPDA8tns=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=BptZxWOIwoiZzjbNfSU4oNy+jUl6jzkNUwT6vYORK/h/cHAaQ9nvrErh4U03sE+k6k0WIXmqV9pWPaoJ+MF7OLaWAy4mCeiJEUQw4OK8zGHqy4dqxnkiTaI8ZvanRoUJg0jw1cs+CV51aPgt74r1eRWKkUSPVqvLA9KFjgHF8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=oiWIj0ph; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=AuFI+GRW; arc=none smtp.client-ip=54.240.10.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="oiWIj0ph";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="AuFI+GRW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779140174;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=0193u6d6wUudY8MxIwPxm5G3HN7pVR0sP/eDPDA8tns=;
	b=oiWIj0ph2xRW8z08WL7B6R6L6nbcc2wwUpf1cxz7yPIJtrKx8TxnzSBp6VE+8X7p
	LkaqUfzQ81XWRL/p50yUElk6JMdvi8fBEhl4u8ksTDOv8gVB/VzlEwPcLcZ3faRWZj5
	gqUK7RmODfAiSh0rpVr5wmsGENF4SZqutjl9D49I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779140174;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=0193u6d6wUudY8MxIwPxm5G3HN7pVR0sP/eDPDA8tns=;
	b=AuFI+GRWknbo5po7ffOeWN0UKAu7+ijtsCvOV6ZySIH48+L0CYxk83u1CHSzeq4H
	3rpw+KKJYinm4nqj/EH857qgSwJlh1xILymiS9YNI/a51omiOmyetbHqnHKtjhKI6Q0
	tcsTV1LW/lSSrbhyXh+OTI3CTMtIvYovu8YiY+ww=
Subject: [PATCH 3/6] dax/fsdev: fix kaddr for multi-range and fail probe on
 invalid pgmap offset
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
Date: Mon, 18 May 2026 21:36:14 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
References: 
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com> 
 <20260518213609.31281-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc5w41mkJXxS0+R8GcNdWTTpRlkwAACQy3
Thread-Topic: [PATCH 3/6] dax/fsdev: fix kaddr for multi-range and fail probe
 on invalid pgmap offset
X-Wm-Sent-Timestamp: 1779140173
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e3d04a274-fa7de276-d361-460b-836c-c5e6191a5803-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.18-54.240.10.72

From: John Groves <John@Groves.net>=0D=0A=0D=0ATwo fixes for virtual addr=
ess handling in fsdev:=0D=0A=0D=0A1. Use __va(phys) instead of virt_addr =
+ linear_offset for the kaddr=0D=0A   return in __fsdev_dax_direct_access=
(). The previous code added a=0D=0A   device-linear byte offset to virt_a=
ddr (which is __va of ranges[0]),=0D=0A   but for multi-range devices wit=
h physical gaps between ranges, this=0D=0A   linear arithmetic crosses th=
e gap and produces a wrong kernel virtual=0D=0A   address. Using __va(phy=
s) where phys comes from dax_pgoff_to_phys()=0D=0A   is correct for any r=
ange layout because the direct map translates=0D=0A   each physical addre=
ss independently.=0D=0A=0D=0A2. Convert the WARN_ON to a fatal error when=
 pgmap_phys > phys. This=0D=0A   condition means the remapped region star=
ts after the device's data=0D=0A   region, which is an impossible state. =
Previously the probe continued=0D=0A   with data_offset=3D0, leaving virt=
_addr silently misaligned. Now probe=0D=0A   returns -EINVAL with a diagn=
ostic message.=0D=0A=0D=0AFixes: 759455848df0b ("dax: Save the kva from m=
emremap")=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=
 drivers/dax/fsdev.c | 12 ++++++++----=0D=0A 1 file changed, 8 insertions=
(+), 4 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fsdev.c b/drivers=
/dax/fsdev.c=0D=0Aindex de7e6dee68386..bf0ba1f1f0b76 100644=0D=0A--- a/dr=
ivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -51,7 +51,6 @@ s=
tatic long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t =
pgoff,=0D=0A =09struct dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A=
 =09size_t size =3D nr_pages << PAGE_SHIFT;=0D=0A =09size_t offset =3D pg=
off << PAGE_SHIFT;=0D=0A-=09void *virt_addr =3D dev_dax->virt_addr + offs=
et;=0D=0A =09phys_addr_t phys;=0D=0A=20=0D=0A =09phys =3D dax_pgoff_to_ph=
ys(dev_dax, pgoff, size);=0D=0A@@ -62,7 +61,7 @@ static long __fsdev_dax_=
direct_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A =09}=0D=0A=
=20=0D=0A =09if (kaddr)=0D=0A-=09=09*kaddr =3D virt_addr;=0D=0A+=09=09*ka=
ddr =3D __va(phys);=0D=0A=20=0D=0A =09if (pfn)=0D=0A =09=09*pfn =3D PHYS_=
PFN(phys);=0D=0A@@ -311,8 +310,13 @@ static int fsdev_dax_probe(struct de=
v_dax *dev_dax)=0D=0A =09=09u64 phys =3D dev_dax->ranges[0].range.start;=0D=
=0A =09=09u64 pgmap_phys =3D dev_dax->pgmap[0].range.start;=0D=0A=20=0D=0A=
-=09=09if (!WARN_ON(pgmap_phys > phys))=0D=0A-=09=09=09data_offset =3D ph=
ys - pgmap_phys;=0D=0A+=09=09if (pgmap_phys > phys) {=0D=0A+=09=09=09dev_=
err(dev, "pgmap start %#llx exceeds data start %#llx\n",=0D=0A+=09=09=09=09=
pgmap_phys, phys);=0D=0A+=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09goto err=
_pgmap;=0D=0A+=09=09}=0D=0A+=09=09data_offset =3D phys - pgmap_phys;=0D=0A=
=20=0D=0A =09=09pr_debug("%s: offset detected phys=3D%llx pgmap_phys=3D%l=
lx offset=3D%llx\n",=0D=0A =09=09       __func__, phys, pgmap_phys, data_=
offset);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
