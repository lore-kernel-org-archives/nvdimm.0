Received: from a10-72.smtp-out.amazonses.com (a10-72.smtp-out.amazonses.com [54.240.10.72])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0858339478D
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159867; cv=none; b=b36XkCbM7Qis7oeqVFb1ZdalXqYKY2hHlSQawMEwTE0+qU05kJ5hHEwNz8PQWNIlZmGLwL6KNmm8AifzF+txamYy+iUMGLPzdVVolkIlFi8tUjU7+EhL1XYbyHUVSiG4fgnzFevGGcqEXkDVT3SlVKQVRDe8quy7tcwRaERM8dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159867; c=relaxed/simple;
	bh=lxy1sq0vpzXKIlMNwLlLO42jtnqT9eR0fvORC9CqfGo=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=PjrCObEK3Q5gJrxv3q8hTOx1y3NzTfVmkjVqIhKiveINbbUXo+nMorJjdpznRC4Xathzq7XP3JMRn9ykPqLbZ9YvuE7+jM7vxE5dbaFn+luiZYiaw+OM3DO3Axzn33Vwszzsi/h6k8kRzpMC7HSn+fuAY7S7uznxALvHRZPt1vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=MQ2QoH0G; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=gIcd48kN; arc=none smtp.client-ip=54.240.10.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="MQ2QoH0G";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="gIcd48kN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159865;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=lxy1sq0vpzXKIlMNwLlLO42jtnqT9eR0fvORC9CqfGo=;
	b=MQ2QoH0GFa9LEyBMvIxc812smeeRvj2FEQ3jGxW/WNyILexbG/UzpeMTzIfw3Hf3
	X8SQID5ykkL21bZ5hS/+IPc4nhzBNLRgO2JfpgmcZ5Nl3AeW3/M6IaRd9JFqT1KvW/A
	kyRxiHtdavf1cSSDG2t+FbgsVd+MbCRU5VYcbdAw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159865;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=lxy1sq0vpzXKIlMNwLlLO42jtnqT9eR0fvORC9CqfGo=;
	b=gIcd48kNTCsEtsXziukZFjexUq3ZYD4M2Xnd4BX4Lnrsk/RNlS2uaNe8IuHvjYxh
	hfmf3T7+cbTs9okeFaKMn9xrIERvGjcJQOyLD89vfGl7Km9V9FNiaFGy8cTRy8RUGVR
	Ea4fgC6dvSdERGPo1vhYCuKzP3kHXrzCs46/1aWE=
Subject: [PATCH V3 5/9] dax/fsdev: use __va(phys) for kaddr in direct_access
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
Date: Sat, 30 May 2026 16:51:04 +0000
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
 <20260530165100.6670-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAACY82
Thread-Topic: [PATCH V3 5/9] dax/fsdev: use __va(phys) for kaddr in
 direct_access
X-Wm-Sent-Timestamp: 1780159863
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cbe087-d11f77a7-379f-4355-b65c-52b3090e9ddd-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.10.72

From: John Groves <John@Groves.net>=0D=0A=0D=0AUse __va(phys) instead of =
virt_addr + linear_offset for the kaddr=0D=0Areturn in __fsdev_dax_direct=
_access(). The previous code added a=0D=0Adevice-linear byte offset to vi=
rt_addr (which is __va of ranges[0]),=0D=0Abut for multi-range devices wi=
th physical gaps between ranges, this=0D=0Alinear arithmetic crosses the =
gap and produces a wrong kernel virtual=0D=0Aaddress. Using __va(phys) wh=
ere phys comes from dax_pgoff_to_phys()=0D=0Ais correct for any range lay=
out because the direct map translates=0D=0Aeach physical address independ=
ently.=0D=0A=0D=0AFixes: 759455848df0b ("dax: Save the kva from memremap"=
)=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A driver=
s/dax/fsdev.c | 7 ++-----=0D=0A 1 file changed, 2 insertions(+), 5 deleti=
ons(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=
=0Aindex 42aac7e952516..a2d2eb20fb4d0 100644=0D=0A--- a/drivers/dax/fsdev=
=2Ec=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -51,9 +51,7 @@ static long __=
fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A =
=09struct dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A =09size_t =
size =3D nr_pages << PAGE_SHIFT;=0D=0A =09size_t offset =3D pgoff << PAGE=
_SHIFT;=0D=0A-=09void *virt_addr =3D dev_dax->virt_addr + offset;=0D=0A =09=
phys_addr_t phys;=0D=0A-=09unsigned long local_pfn;=0D=0A=20=0D=0A =09phy=
s =3D dax_pgoff_to_phys(dev_dax, pgoff, size);=0D=0A =09if (phys =3D=3D -=
1) {=0D=0A@@ -63,11 +61,10 @@ static long __fsdev_dax_direct_access(struc=
t dax_device *dax_dev, pgoff_t pgoff,=0D=0A =09}=0D=0A=20=0D=0A =09if (ka=
ddr)=0D=0A-=09=09*kaddr =3D virt_addr;=0D=0A+=09=09*kaddr =3D __va(phys);=
=0D=0A=20=0D=0A-=09local_pfn =3D PHYS_PFN(phys);=0D=0A =09if (pfn)=0D=0A-=
=09=09*pfn =3D local_pfn;=0D=0A+=09=09*pfn =3D PHYS_PFN(phys);=0D=0A=20=0D=
=0A =09/*=0D=0A =09 * Use cached_size which was computed at probe time. T=
he size cannot=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
