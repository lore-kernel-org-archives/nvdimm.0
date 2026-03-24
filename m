Received: from a11-73.smtp-out.amazonses.com (a11-73.smtp-out.amazonses.com [54.240.11.73])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144E2253A1
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312675; cv=none; b=AweUpjTe0dTG12QDmvXxeKTIeOw81RMlnJK8joazF3TNbaPsdMz+4S8Kii8piu5woJ6BypvbpMEwYE1ci3a10rKCJrO0/OWIexQYoSrNltq/SIPi5H9B7uYqjsOr3IyBdfq0p+ZGqE0KVnHQNr1cSPsLUXxE5yrykD9PIr607Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312675; c=relaxed/simple;
	bh=Wj9IkyJj9MSuf/Dl3AxEytMFZO7jGEYqGIcH0Gtmy/I=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=bnYrD/bGG+Lniqvk/VLcVM08CbmUHfEOrjW1Q6hGxJ3Z3ApOEGPv5AhyjDc1qiM1YqLtTDuqhqz+DSsUqWZsvTe1TRR71ZwJNeJM5odn68KTPGPjbemR8H1DRu4vJWjPHmGSHbS+NENq42tzkNzedTbaT9hVT/mr1cXzKp4cv6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=RCvDZp8F; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=otiMc5nh; arc=none smtp.client-ip=54.240.11.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="RCvDZp8F";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="otiMc5nh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312673;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=Wj9IkyJj9MSuf/Dl3AxEytMFZO7jGEYqGIcH0Gtmy/I=;
	b=RCvDZp8F5W5kfPhgTS2VBb6BaeV8EsQb9cMqm60dq6XcDI0qD0QakvbLl6KWV3QC
	+aC/AwqMVkhq1NHSy/a9xhHfi5g5gg2kT/CjrVY00gHI7a/Sq4kTOPxCsJhGIE2YwlB
	XXpgKGT4a9kyumSo6eKZezdSZLvLhi88VFPdH3jY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312673;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=Wj9IkyJj9MSuf/Dl3AxEytMFZO7jGEYqGIcH0Gtmy/I=;
	b=otiMc5nhLBJfPXLoz2RkeSrd6EsDSyiunLUDTDsQXQKmNJ2zNTnriB5D3UdatjXJ
	GSdVIucpCtPN45YwTcykegewn6hv7KvR9ES3RLQ2EIB1yPbwexK/eB7EaFIERxt5uSt
	mgX99uxb5i/Ef8GsCqlR77r4nafdoBxuB9TDQ5Gg=
Subject: [PATCH V9 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Ira_Weiny?= <ira.weiny@intel.com>
Date: Tue, 24 Mar 2026 00:37:53 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
References: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com> 
 <20260324003743.4973-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyZyQU67AzTwRZicbskzyje4Wg==
Thread-Topic: [PATCH V9 1/8] dax: move dax_pgoff_to_phys from [drivers/dax/]
 device.c to bus.c
X-Wm-Sent-Timestamp: 1774312672
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d46d094-cc0a4b79-3bd2-43e8-a08d-ab8cd21266a6-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.73

From: John Groves <john@groves.net>=0D=0A=0D=0AThis function will be used=
 by both device.c and fsdev.c, but both are=0D=0Aloadable modules. Moving=
 to bus.c puts it in core and makes it available=0D=0Ato both.=0D=0A=0D=0A=
No code changes - just relocated.=0D=0A=0D=0AReviewed-by: Ira Weiny <ira.=
weiny@intel.com>=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/b=
us.c    | 24 ++++++++++++++++++++++++=0D=0A drivers/dax/device.c | 23 ---=
--------------------=0D=0A 2 files changed, 24 insertions(+), 23 deletion=
s(-)=0D=0A=0D=0Adiff --git a/drivers/dax/bus.c b/drivers/dax/bus.c=0D=0Ai=
ndex c94c09622516..e4bd5c9f006c 100644=0D=0A--- a/drivers/dax/bus.c=0D=0A=
+++ b/drivers/dax/bus.c=0D=0A@@ -1417,6 +1417,30 @@ static const struct d=
evice_type dev_dax_type =3D {=0D=0A =09.groups =3D dax_attribute_groups,=0D=
=0A };=0D=0A=20=0D=0A+/* see "strong" declaration in tools/testing/nvdimm=
/dax-dev.c */=0D=0A+__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *=
dev_dax, pgoff_t pgoff,=0D=0A+=09=09=09      unsigned long size)=0D=0A+{=0D=
=0A+=09int i;=0D=0A+=0D=0A+=09for (i =3D 0; i < dev_dax->nr_range; i++) {=
=0D=0A+=09=09struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];=0D=0A=
+=09=09struct range *range =3D &dax_range->range;=0D=0A+=09=09unsigned lo=
ng long pgoff_end;=0D=0A+=09=09phys_addr_t phys;=0D=0A+=0D=0A+=09=09pgoff=
_end =3D dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;=0D=0A+=09=09i=
f (pgoff < dax_range->pgoff || pgoff > pgoff_end)=0D=0A+=09=09=09continue=
;=0D=0A+=09=09phys =3D PFN_PHYS(pgoff - dax_range->pgoff) + range->start;=
=0D=0A+=09=09if (phys + size - 1 <=3D range->end)=0D=0A+=09=09=09return p=
hys;=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=09return -1;=0D=0A+}=0D=0A+EXPO=
RT_SYMBOL_GPL(dax_pgoff_to_phys);=0D=0A+=0D=0A static struct dev_dax *__d=
evm_create_dev_dax(struct dev_dax_data *data)=0D=0A {=0D=0A =09struct dax=
_region *dax_region =3D data->dax_region;=0D=0Adiff --git a/drivers/dax/d=
evice.c b/drivers/dax/device.c=0D=0Aindex 528e81240c4d..2d2dbfd35e94 1006=
44=0D=0A--- a/drivers/dax/device.c=0D=0A+++ b/drivers/dax/device.c=0D=0A@=
@ -57,29 +57,6 @@ static int check_vma(struct dev_dax *dev_dax, struct vm=
_area_struct *vma,=0D=0A =09=09=09   vma->vm_file, func);=0D=0A }=0D=0A=20=
=0D=0A-/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */=0D=
=0A-__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t=
 pgoff,=0D=0A-=09=09unsigned long size)=0D=0A-{=0D=0A-=09int i;=0D=0A-=0D=
=0A-=09for (i =3D 0; i < dev_dax->nr_range; i++) {=0D=0A-=09=09struct dev=
_dax_range *dax_range =3D &dev_dax->ranges[i];=0D=0A-=09=09struct range *=
range =3D &dax_range->range;=0D=0A-=09=09unsigned long long pgoff_end;=0D=
=0A-=09=09phys_addr_t phys;=0D=0A-=0D=0A-=09=09pgoff_end =3D dax_range->p=
goff + PHYS_PFN(range_len(range)) - 1;=0D=0A-=09=09if (pgoff < dax_range-=
>pgoff || pgoff > pgoff_end)=0D=0A-=09=09=09continue;=0D=0A-=09=09phys =3D=
 PFN_PHYS(pgoff - dax_range->pgoff) + range->start;=0D=0A-=09=09if (phys =
+ size - 1 <=3D range->end)=0D=0A-=09=09=09return phys;=0D=0A-=09=09break=
;=0D=0A-=09}=0D=0A-=09return -1;=0D=0A-}=0D=0A-=0D=0A static void dax_set=
_mapping(struct vm_fault *vmf, unsigned long pfn,=0D=0A =09=09=09      un=
signed long fault_size)=0D=0A {=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
