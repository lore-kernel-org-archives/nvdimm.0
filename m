Received: from a11-32.smtp-out.amazonses.com (a11-32.smtp-out.amazonses.com [54.240.11.32])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A5A408015
	for <nvdimm@lists.linux.dev>; Mon, 15 Jun 2026 16:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781539632; cv=none; b=XOjSs9MgWNY6/+3CL3RVMRYu+I2dDO7Xc5iCjCEkTWB8wbduo/KZriyBnP4TNPhiMeJO7NtJJb+me3aYKYFEF734nyxafH9d7F7/xQMVOCrNsCPLh5tHJSJMSGjuSwVl+gaHJ7Vodscxr5kcRcRtIXWqoxVB0HnsN9QmHaRzvCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781539632; c=relaxed/simple;
	bh=Fi8SdNbhwZEiFKG+bWC467VWOw9jTHPS2TcJOoQVHeg=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=WmyBrd44VO3X42FAGn5BYH2EQtT9pcFl8n1vaBKZuI+T099ofw+T1KYmXENnZMH1NvYmg6C0F1699a8fQv3eyLOWy6G2ulRbrmMRSC6Xjt9KeAJx+OOgMK5vXmgxvKT2PvOzBmItO6EK4XeoYWcjwz+RoO/AwIKVNAe+x33sOb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Wt/G9BK3; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=QSm9ac8M; arc=none smtp.client-ip=54.240.11.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Wt/G9BK3";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="QSm9ac8M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781539630;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Fi8SdNbhwZEiFKG+bWC467VWOw9jTHPS2TcJOoQVHeg=;
	b=Wt/G9BK3eZnLNois3yUPp0hf2M9RHjabHZ49TJVXtO8mDtMuaFEz5Z9x1JHErB0L
	nHk+oxPCld36gj9IMhxoDrVkWiTgZkyq3Jgup0tWyqcsb8xY5hb5OFTpsoiEUiSXOHO
	Kn/gCkL1NQkkQss1FnxN22lLLCTu767ziXSK1Exg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781539630;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Fi8SdNbhwZEiFKG+bWC467VWOw9jTHPS2TcJOoQVHeg=;
	b=QSm9ac8MGeFr5Ry8bJbOS2Cnz5+IpDuf/g/KyEsGmV2/pr4nKiHAdGQM8Dg+JI0+
	nm5RjsOetMw8A/m+UFnzc/b/bppfCJrt+a5ehtAjPClpYz5Ivs6pwkXtFNCvftdayS2
	JXmuIsSIpbw/3/2qxX5f3kVpOMpUeS15FFckEclQ=
Subject: [PATCH V6 06/10] dax/fsdev: use __va(phys) for kaddr in direct_access
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
Date: Mon, 15 Jun 2026 16:07:10 +0000
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
 <20260615160704.17550-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc/ODO6LspbHjzStSzrfP9PzvfSwAADZ2X
Thread-Topic: [PATCH V6 06/10] dax/fsdev: use __va(phys) for kaddr in
 direct_access
X-Wm-Sent-Timestamp: 1781539629
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ecc096de8-8bc254a7-d2cc-44b6-82b1-1394fda8bb41-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.15-54.240.11.32

From: John Groves <John@Groves.net>=0D=0A=0D=0AUse __va(phys) instead of =
virt_addr + linear_offset for the kaddr=0D=0Areturn in __fsdev_dax_direct=
_access(). The previous code added a=0D=0Adevice-linear byte offset to vi=
rt_addr (which is __va of ranges[0]),=0D=0Abut for multi-range devices wi=
th physical gaps between ranges, this=0D=0Alinear arithmetic crosses the =
gap and produces a wrong kernel virtual=0D=0Aaddress. Using __va(phys) wh=
ere phys comes from dax_pgoff_to_phys()=0D=0Ais correct for any range lay=
out because the direct map translates=0D=0Aeach physical address independ=
ently.=0D=0A=0D=0AThis leaves dev_dax->virt_addr write-only, so remove th=
e field=0D=0A(suggested by Dave Jiang).=0D=0A=0D=0AFixes: 759455848df0b (=
"dax: Save the kva from memremap")=0D=0A=0D=0AReviewed-by: Dave Jiang <da=
ve.jiang@intel.com>=0D=0AReviewed-by: Alison Schofield <alison.schofield@=
intel.com>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=
 drivers/dax/dax-private.h | 2 --=0D=0A drivers/dax/fsdev.c       | 8 ++-=
-----=0D=0A 2 files changed, 2 insertions(+), 8 deletions(-)=0D=0A=0D=0Ad=
iff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h=0D=0Ain=
dex 81e4af49e39c1..607a53a91f58b 100644=0D=0A--- a/drivers/dax/dax-privat=
e.h=0D=0A+++ b/drivers/dax/dax-private.h=0D=0A@@ -69,7 +69,6 @@ struct de=
v_dax_range {=0D=0A  * data while the device is activated in the driver.=0D=
=0A  * @region: parent region=0D=0A  * @dax_dev: core dax functionality=0D=
=0A- * @virt_addr: kva from memremap; used by fsdev_dax=0D=0A  * @cached_=
size: size of daxdev cached by fsdev_dax=0D=0A  * @align: alignment of th=
is instance=0D=0A  * @target_node: effective numa node if dev_dax memory =
range is onlined=0D=0A@@ -85,7 +84,6 @@ struct dev_dax_range {=0D=0A stru=
ct dev_dax {=0D=0A =09struct dax_region *region;=0D=0A =09struct dax_devi=
ce *dax_dev;=0D=0A-=09void *virt_addr;=0D=0A =09u64 cached_size;=0D=0A =09=
unsigned int align;=0D=0A =09int target_node;=0D=0Adiff --git a/drivers/d=
ax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex 68a4369562f70..57c589e19b539 =
100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A=
@@ -51,9 +51,7 @@ static long __fsdev_dax_direct_access(struct dax_device=
 *dax_dev, pgoff_t pgoff,=0D=0A =09struct dev_dax *dev_dax =3D dax_get_pr=
ivate(dax_dev);=0D=0A =09size_t size =3D nr_pages << PAGE_SHIFT;=0D=0A =09=
size_t offset =3D pgoff << PAGE_SHIFT;=0D=0A-=09void *virt_addr =3D dev_d=
ax->virt_addr + offset;=0D=0A =09phys_addr_t phys;=0D=0A-=09unsigned long=
 local_pfn;=0D=0A=20=0D=0A =09phys =3D dax_pgoff_to_phys(dev_dax, pgoff, =
size);=0D=0A =09if (phys =3D=3D -1) {=0D=0A@@ -63,11 +61,10 @@ static lon=
g __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=
=0A =09}=0D=0A=20=0D=0A =09if (kaddr)=0D=0A-=09=09*kaddr =3D virt_addr;=0D=
=0A+=09=09*kaddr =3D __va(phys);=0D=0A=20=0D=0A-=09local_pfn =3D PHYS_PFN=
(phys);=0D=0A =09if (pfn)=0D=0A-=09=09*pfn =3D local_pfn;=0D=0A+=09=09*pf=
n =3D PHYS_PFN(phys);=0D=0A=20=0D=0A =09/*=0D=0A =09 * Use cached_size wh=
ich was computed at probe time. The size cannot=0D=0A@@ -351,7 +348,6 @@ =
static int fsdev_dax_probe(struct dev_dax *dev_dax)=0D=0A =09=09pr_debug(=
"%s: offset detected phys=3D%llx pgmap_phys=3D%llx offset=3D%llx\n",=0D=0A=
 =09=09       __func__, phys, pgmap_phys, data_offset);=0D=0A =09}=0D=0A-=
=09dev_dax->virt_addr =3D addr + data_offset;=0D=0A=20=0D=0A =09inode =3D=
 dax_inode(dax_dev);=0D=0A =09cdev =3D inode->i_cdev;=0D=0A--=20=0D=0A2.5=
3.0=0D=0A=0D=0A
