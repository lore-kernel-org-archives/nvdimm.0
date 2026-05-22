Received: from a11-121.smtp-out.amazonses.com (a11-121.smtp-out.amazonses.com [54.240.11.121])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3429B36AB5A
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477547; cv=none; b=Dr00jLjPK+7XiJw/QmGP6UnDXK8aZkiaelJN2btR+AbomAWALnwpnQ2ECa+0Hds2yoPPqGKogNPoTpUXz6Zp89HUZbSAMpsVNs3f3Lx/PhqRTv69fu/+XAOkTSYtMOGtUSI6e+jijl1zLF+qOYac/o5pf66V/nDsjPOcQX+py+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477547; c=relaxed/simple;
	bh=nIUB7xswtpRvLSpZJlptyo9wVpkGXeAE088yrSAtpLI=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=sfjDbR4zW1D3FIfoGIaE3TcpQbzNscxCKesz/UAYaEFSrcVag3ZD+FqE5Ihhc3N/0f8Ni0IZN2YtAWw7PXAQJ6MhRn5Ph67936lboeFPfWwLuoT8ZZoIMWOUQnpxB9m6BvtS8haoIucvPbKv9TnN7LyHvogyHajkt3OGN5zC3/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=O00k182c; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ZimWdGI5; arc=none smtp.client-ip=54.240.11.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="O00k182c";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ZimWdGI5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477545;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=nIUB7xswtpRvLSpZJlptyo9wVpkGXeAE088yrSAtpLI=;
	b=O00k182c3SpIiNMAveFMqwdmb98d3KhCNK4bcY3DqmlhlU6EK7hTnN1bAtJYIsJj
	HQgx/wWrK/QSZpUwPn7CNpYJHdNwLOShQtFOu4bVHaFPrqgcUuT85xtkgiHk4PrpCap
	/upBcYgmi6A7fY+L25fNxXmTXxelf39EM77yIanE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477545;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=nIUB7xswtpRvLSpZJlptyo9wVpkGXeAE088yrSAtpLI=;
	b=ZimWdGI54Sk9NXoAJCYA39bHKGA1KRCbAP6TypKqDjCl5ZjdA6mM4pzMMamqGBuU
	EZod1MCHCL3HqPsyvv30IPiVT7iLJaK9Mg5rWNY2vSlBisRbGazsBkiGAIaN3GdGBOk
	Wldo+79jYvno401Ci7uNER24peSHwn54LCMy37is=
Subject: [PATCH V2 3/7] dax/fsdev: fix kaddr for multi-range and fail probe
 on invalid pgmap offset
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
Date: Fri, 22 May 2026 19:19:04 +0000
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
 <20260522191859.79167-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h+7e4zSojcNRQ2wV9eJQr6w4gAAB7C6
Thread-Topic: [PATCH V2 3/7] dax/fsdev: fix kaddr for multi-range and fail
 probe on invalid pgmap offset
X-Wm-Sent-Timestamp: 1779477543
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e51208026-d62e0ffa-73d4-4cac-b950-dbbbb13ab38c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.11.121

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
 drivers/dax/fsdev.c | 16 +++++++++-------=0D=0A 1 file changed, 9 insert=
ions(+), 7 deletions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fsdev.c b/dri=
vers/dax/fsdev.c=0D=0Aindex 42aac7e952516..aac0130ab2833 100644=0D=0A--- =
a/drivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -51,9 +51,7 =
@@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgof=
f_t pgoff,=0D=0A =09struct dev_dax *dev_dax =3D dax_get_private(dax_dev);=
=0D=0A =09size_t size =3D nr_pages << PAGE_SHIFT;=0D=0A =09size_t offset =
=3D pgoff << PAGE_SHIFT;=0D=0A-=09void *virt_addr =3D dev_dax->virt_addr =
+ offset;=0D=0A =09phys_addr_t phys;=0D=0A-=09unsigned long local_pfn;=0D=
=0A=20=0D=0A =09phys =3D dax_pgoff_to_phys(dev_dax, pgoff, size);=0D=0A =09=
if (phys =3D=3D -1) {=0D=0A@@ -63,11 +61,10 @@ static long __fsdev_dax_di=
rect_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A =09}=0D=0A=20=
=0D=0A =09if (kaddr)=0D=0A-=09=09*kaddr =3D virt_addr;=0D=0A+=09=09*kaddr=
 =3D __va(phys);=0D=0A=20=0D=0A-=09local_pfn =3D PHYS_PFN(phys);=0D=0A =09=
if (pfn)=0D=0A-=09=09*pfn =3D local_pfn;=0D=0A+=09=09*pfn =3D PHYS_PFN(ph=
ys);=0D=0A=20=0D=0A =09/*=0D=0A =09 * Use cached_size which was computed =
at probe time. The size cannot=0D=0A@@ -313,8 +310,13 @@ static int fsdev=
_dax_probe(struct dev_dax *dev_dax)=0D=0A =09=09u64 phys =3D dev_dax->ran=
ges[0].range.start;=0D=0A =09=09u64 pgmap_phys =3D dev_dax->pgmap[0].rang=
e.start;=0D=0A=20=0D=0A-=09=09if (!WARN_ON(pgmap_phys > phys))=0D=0A-=09=09=
=09data_offset =3D phys - pgmap_phys;=0D=0A+=09=09if (pgmap_phys > phys) =
{=0D=0A+=09=09=09dev_err(dev, "pgmap start %#llx exceeds data start %#llx=
\n",=0D=0A+=09=09=09=09pgmap_phys, phys);=0D=0A+=09=09=09rc =3D -EINVAL;=0D=
=0A+=09=09=09goto err_pgmap;=0D=0A+=09=09}=0D=0A+=09=09data_offset =3D ph=
ys - pgmap_phys;=0D=0A=20=0D=0A =09=09pr_debug("%s: offset detected phys=3D=
%llx pgmap_phys=3D%llx offset=3D%llx\n",=0D=0A =09=09       __func__, phy=
s, pgmap_phys, data_offset);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
