Received: from a10-27.smtp-out.amazonses.com (a10-27.smtp-out.amazonses.com [54.240.10.27])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F79839A046
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 21:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140184; cv=none; b=Hv4iMyh+HItAVGEJQVMtnnD6mWDgPsv8iNZpFf3BPEnH1aZJwfamKVmsGzEIhPKhUvWsmjfwpO0WHm7DeEfWFRR2f7XpYvF8EhNMUlih/mZm2XPODLC9NltccDZtd1FGOe+1/8ot7zRwGO8xLPY7dHipgbbLlcQ0RAa3cY5uO2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140184; c=relaxed/simple;
	bh=v3K7HnyRqyVukLMNmrKpUuZsKT8su2mdJgPw1vX9J4M=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=EPkcynaCdg8jlbymmj9dekkyuiKOHQBCW2OIqNXJBl8d8yhCPoD42NmjP/oh5fAEQZOXp3rU37B7yDCVQ6JhrDJqM/1qFzSl4kNb+bq8XtXzVxoK3uA21ha1kbIEe+R9ORRT4GP6Z+shMrhDNRDr0bNV8v5WM9/TSOaH+Jmg9WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=EJSCOT4z; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=KfyS7gzx; arc=none smtp.client-ip=54.240.10.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="EJSCOT4z";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="KfyS7gzx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779140181;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=v3K7HnyRqyVukLMNmrKpUuZsKT8su2mdJgPw1vX9J4M=;
	b=EJSCOT4zEatBvNh+YRLs1e1YOsH04ZocFkRPpqRDv50FsUdL9XalWVlZjvKxgImu
	kXc+CUrjPRCn6raRuR3vrkXPjuJnQosGZZ5Mt3EPr4M/F3Nt9VHj8NM9edDxYSPs1Vy
	oZI3PEvDrl7C28GLrlZJ3G7E6t/jKPFryMGatbTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779140181;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=v3K7HnyRqyVukLMNmrKpUuZsKT8su2mdJgPw1vX9J4M=;
	b=KfyS7gzxLIOSu/sNHFRzppeSW2Bjj9WI9YgYoX7o/rk8Kxg7i6E5yjCWwsibMkYk
	Kwl14vK1f9i4ix2ASNh7QRZ2ufsrhNBlkzzlCXG3RmEvnC2n4QWzxuTA03opfyPY7Pw
	MsM5dzsPx5K9MEAEpO2aIlEswe/2B8WQD9qd28fI=
Subject: [PATCH 4/6] dax/fsdev: clamp direct_access return to current
 physical range
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
Date: Mon, 18 May 2026 21:36:21 +0000
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
 <20260518213617.31298-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc5w41mkJXxS0+R8GcNdWTTpRlkwAAChR4
Thread-Topic: [PATCH 4/6] dax/fsdev: clamp direct_access return to current
 physical range
X-Wm-Sent-Timestamp: 1779140180
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e3d04bd40-5b96fa1d-1b23-4468-a0d5-c7684fb4cf05-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.18-54.240.10.27

From: John Groves <John@Groves.net>=0D=0A=0D=0A__fsdev_dax_direct_access(=
) returned the number of available pages based=0D=0Aon cached_size (the t=
otal size across all ranges). For multi-range=0D=0Adevices with physical =
gaps between ranges, this over-reports the number=0D=0Aof physically cont=
iguous pages available from the returned kaddr/pfn.=0D=0ACallers trust th=
is return value to mean contiguous pages, so accessing=0D=0Abeyond the cu=
rrent range boundary would hit unmapped or unrelated memory.=0D=0A=0D=0AF=
ix by finding the range that contains the translated physical address=0D=0A=
and clamping the return to the remaining pages within that range.=0D=0A=0D=
=0AAlso remove the now-unused cached_size field from struct dev_dax, sinc=
e=0D=0Ait was only consumed by the old return calculation.=0D=0A=0D=0AFix=
es: 099c81a1f0ab3 ("dax: Add dax_operations for use by fs-dax on fsdev da=
x")=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A driv=
ers/dax/dax-private.h |  2 --=0D=0A drivers/dax/fsdev.c       | 23 ++++++=
++++++++---------=0D=0A 2 files changed, 14 insertions(+), 11 deletions(-=
)=0D=0A=0D=0Adiff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-pri=
vate.h=0D=0Aindex 81e4af49e39c1..7a3727d76a68a 100644=0D=0A--- a/drivers/=
dax/dax-private.h=0D=0A+++ b/drivers/dax/dax-private.h=0D=0A@@ -70,7 +70,=
6 @@ struct dev_dax_range {=0D=0A  * @region: parent region=0D=0A  * @dax=
_dev: core dax functionality=0D=0A  * @virt_addr: kva from memremap; used=
 by fsdev_dax=0D=0A- * @cached_size: size of daxdev cached by fsdev_dax=0D=
=0A  * @align: alignment of this instance=0D=0A  * @target_node: effectiv=
e numa node if dev_dax memory range is onlined=0D=0A  * @dyn_id: is this =
a dynamic or statically created instance=0D=0A@@ -86,7 +85,6 @@ struct de=
v_dax {=0D=0A =09struct dax_region *region;=0D=0A =09struct dax_device *d=
ax_dev;=0D=0A =09void *virt_addr;=0D=0A-=09u64 cached_size;=0D=0A =09unsi=
gned int align;=0D=0A =09int target_node;=0D=0A =09bool dyn_id;=0D=0Adiff=
 --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex bf0ba1f1f0b=
76..8b683db2c3e6b 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/driver=
s/dax/fsdev.c=0D=0A@@ -50,8 +50,8 @@ static long __fsdev_dax_direct_acces=
s(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A {=0D=0A =09struct dev_=
dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A =09size_t size =3D nr_pa=
ges << PAGE_SHIFT;=0D=0A-=09size_t offset =3D pgoff << PAGE_SHIFT;=0D=0A =
=09phys_addr_t phys;=0D=0A+=09int i;=0D=0A=20=0D=0A =09phys =3D dax_pgoff=
_to_phys(dev_dax, pgoff, size);=0D=0A =09if (phys =3D=3D -1) {=0D=0A@@ -6=
7,10 +67,20 @@ static long __fsdev_dax_direct_access(struct dax_device *d=
ax_dev, pgoff_t pgoff,=0D=0A =09=09*pfn =3D PHYS_PFN(phys);=0D=0A=20=0D=0A=
 =09/*=0D=0A-=09 * Use cached_size which was computed at probe time. The =
size cannot=0D=0A-=09 * change while the driver is bound (resize returns =
-EBUSY).=0D=0A+=09 * Return the number of physically contiguous pages ava=
ilable from=0D=0A+=09 * phys, clamped to the current range. For multi-ran=
ge devices the=0D=0A+=09 * ranges may not be physically contiguous, so we=
 cannot report=0D=0A+=09 * pages beyond the end of the range that contain=
s phys.=0D=0A =09 */=0D=0A-=09return PHYS_PFN(min(size, dev_dax->cached_s=
ize - offset));=0D=0A+=09for (i =3D 0; i < dev_dax->nr_range; i++) {=0D=0A=
+=09=09struct range *range =3D &dev_dax->ranges[i].range;=0D=0A+=0D=0A+=09=
=09if (phys >=3D range->start && phys <=3D range->end)=0D=0A+=09=09=09ret=
urn PHYS_PFN(min(size,=0D=0A+=09=09=09=09=09    (size_t)(range->end - phy=
s + 1)));=0D=0A+=09}=0D=0A+=0D=0A+=09return -EFAULT;=0D=0A }=0D=0A=20=0D=0A=
 static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,=0D=0A@@=
 -272,11 +282,6 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)=0D=
=0A =09=09}=0D=0A =09}=0D=0A=20=0D=0A-=09/* Cache size now; it cannot cha=
nge while driver is bound */=0D=0A-=09dev_dax->cached_size =3D 0;=0D=0A-=09=
for (i =3D 0; i < dev_dax->nr_range; i++)=0D=0A-=09=09dev_dax->cached_siz=
e +=3D range_len(&dev_dax->ranges[i].range);=0D=0A-=0D=0A =09/*=0D=0A =09=
 * Use MEMORY_DEVICE_FS_DAX without setting vmemmap_shift, leaving=0D=0A =
=09 * folios at order-0. Unlike device.c (MEMORY_DEVICE_GENERIC), this=0D=
=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
