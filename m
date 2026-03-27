Received: from a11-174.smtp-out.amazonses.com (a11-174.smtp-out.amazonses.com [54.240.11.174])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFDC3947AC
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645496; cv=none; b=ZsLVxBJOKD5ghL2b1hcVIYhFKsBw/CJTyfPa4Gfh5VOmrY6NzcMGd2dOVzqfqBlYIp2yjjg3mlzofdP+UlokJzHSNWEnGi0k0c790JJWan6hytcuyDSy6ZvizJlBy3A3UMqdILgT31fuCHISNODOUub7z0x66yazMdVuQ4ulj9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645496; c=relaxed/simple;
	bh=MwDlIR3eq7AmTNeLrlLJmJHcxDvNLG5MKOvTVkN9oJs=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=IXJh0/fqxl5M2Td5Vk219g0E8HAV8uT7VGk1OhwmnF538OvwMxNskPUuRRxjYfhPt0HDGNKfe11WeGrewWo/tY4Iw174AvzLAbGh33scUyKlw50rqnLehK/RKwZt9h2XKmeuiCkdc2mNZ3YTSIkTzITWXwao0ZZpEvDVKr9y75U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=YbDJ92+8; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=YBlmKNHy; arc=none smtp.client-ip=54.240.11.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="YbDJ92+8";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="YBlmKNHy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645494;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=MwDlIR3eq7AmTNeLrlLJmJHcxDvNLG5MKOvTVkN9oJs=;
	b=YbDJ92+8kHAkLhEqvyDGM1/pjyq/cOXAXLEfR15sgIQarW1PlpZ0PLA3ZTZ32lGV
	ysfmEuUdr2qi9kqQ9q8KlsN1WHfa43Z90giSEAHzhQnl/SgQHXZv1UrAPJyYkWve6xY
	2XNBqt/qZ1Eu+BkVsNTK8APchne+YccLF/vMZvIg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645494;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=MwDlIR3eq7AmTNeLrlLJmJHcxDvNLG5MKOvTVkN9oJs=;
	b=YBlmKNHy3ZVY5oveAeWxsr5hzEca/rFOY9TtQX7i9EMhxlKDaPCjKt4M0C5wSFla
	WLFGUQyJne366OvTADRpse1XgoM7GuQypacse+TdskYEhcS3ONjJ5IAwGrHZCbbFBL+
	h/bl5ZhilrhbFWZbLeGbN9K+UJV/xANQ/iz8VXkM=
Subject: [PATCH V10 5/8] dax: Add dax_operations for use by fs-dax on fsdev
 dax
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Fri, 27 Mar 2026 21:04:54 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
References: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com> 
 <20260327210447.79204-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi1aHe2GGSHZTu2XHeFM5MPvnA==
Thread-Topic: [PATCH V10 5/8] dax: Add dax_operations for use by fs-dax on
 fsdev dax
X-Wm-Sent-Timestamp: 1774645492
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311d415a-bd6af0fe-5445-484c-9d39-210b8170b686-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.11.174

From: John Groves <John@Groves.net>=0D=0A=0D=0Afsdev: Add dax_operations =
for use by famfs.=0D=0A=0D=0AThis replicates the functionality from drive=
rs/nvdimm/pmem.c that=0D=0Aconventional fs-dax file systems (e.g. xfs) us=
e to support dax=0D=0Aread/write/mmap to a daxdev - without which famfs c=
an't sit atop a=0D=0Adaxdev.=0D=0A=0D=0A- These methods are based on pmem=
_dax_ops from drivers/nvdimm/pmem.c=0D=0A- fsdev_dax_direct_access() retu=
rns the hpa, pfn and kva. The kva was=0D=0A  newly stored as dev_dax->vir=
t_addr by dev_dax_probe().=0D=0A- The hpa/pfn are used for mmap (dax_ioma=
p_fault()), and the kva is used=0D=0A  for read/write (dax_iomap_rw())=0D=
=0A- fsdev_dax_recovery_write() and dev_dax_zero_page_range() have not be=
en=0D=0A  tested yet. I'm looking for suggestions as to how to test those=
=2E=0D=0A- dax-private.h: add dev_dax->cached_size, which fsdev needs to=0D=
=0A  remember. The dev_dax size cannot change while a driver is bound=0D=0A=
  (dev_dax_resize returns -EBUSY if dev->driver is set). Caching the size=
=0D=0A  at probe time allows fsdev's direct_access path can use it withou=
t=0D=0A  acquiring dax_dev_rwsem (which isn't exported anyway).=0D=0A=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/d=
ax-private.h |  2 +=0D=0A drivers/dax/fsdev.c       | 84 ++++++++++++++++=
+++++++++++++++++++++++=0D=0A 2 files changed, 86 insertions(+)=0D=0A=0D=0A=
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h=0D=0Ai=
ndex 7a3727d76a68..81e4af49e39c 100644=0D=0A--- a/drivers/dax/dax-private=
=2Eh=0D=0A+++ b/drivers/dax/dax-private.h=0D=0A@@ -70,6 +70,7 @@ struct d=
ev_dax_range {=0D=0A  * @region: parent region=0D=0A  * @dax_dev: core da=
x functionality=0D=0A  * @virt_addr: kva from memremap; used by fsdev_dax=
=0D=0A+ * @cached_size: size of daxdev cached by fsdev_dax=0D=0A  * @alig=
n: alignment of this instance=0D=0A  * @target_node: effective numa node =
if dev_dax memory range is onlined=0D=0A  * @dyn_id: is this a dynamic or=
 statically created instance=0D=0A@@ -85,6 +86,7 @@ struct dev_dax {=0D=0A=
 =09struct dax_region *region;=0D=0A =09struct dax_device *dax_dev;=0D=0A=
 =09void *virt_addr;=0D=0A+=09u64 cached_size;=0D=0A =09unsigned int alig=
n;=0D=0A =09int target_node;=0D=0A =09bool dyn_id;=0D=0Adiff --git a/driv=
ers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex c75478d3d548..30f57c74c9=
79 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=
=0A@@ -28,6 +28,85 @@=0D=0A  * - No mmap support - all access is through =
fs-dax/iomap=0D=0A  */=0D=0A=20=0D=0A+static void fsdev_write_dax(void *a=
ddr, struct page *page,=0D=0A+=09=09unsigned int off, unsigned int len)=0D=
=0A+{=0D=0A+=09while (len) {=0D=0A+=09=09void *mem =3D kmap_local_page(pa=
ge);=0D=0A+=09=09unsigned int chunk =3D min_t(unsigned int, len, PAGE_SIZ=
E - off);=0D=0A+=0D=0A+=09=09memcpy_flushcache(addr, mem + off, chunk);=0D=
=0A+=09=09kunmap_local(mem);=0D=0A+=09=09len -=3D chunk;=0D=0A+=09=09off =
=3D 0;=0D=0A+=09=09page++;=0D=0A+=09=09addr +=3D chunk;=0D=0A+=09}=0D=0A+=
}=0D=0A+=0D=0A+static long __fsdev_dax_direct_access(struct dax_device *d=
ax_dev, pgoff_t pgoff,=0D=0A+=09=09=09long nr_pages, enum dax_access_mode=
 mode, void **kaddr,=0D=0A+=09=09=09unsigned long *pfn)=0D=0A+{=0D=0A+=09=
struct dev_dax *dev_dax =3D dax_get_private(dax_dev);=0D=0A+=09size_t siz=
e =3D nr_pages << PAGE_SHIFT;=0D=0A+=09size_t offset =3D pgoff << PAGE_SH=
IFT;=0D=0A+=09void *virt_addr =3D dev_dax->virt_addr + offset;=0D=0A+=09p=
hys_addr_t phys;=0D=0A+=09unsigned long local_pfn;=0D=0A+=0D=0A+=09phys =3D=
 dax_pgoff_to_phys(dev_dax, pgoff, size);=0D=0A+=09if (phys =3D=3D -1) {=0D=
=0A+=09=09dev_dbg(&dev_dax->dev,=0D=0A+=09=09=09"pgoff (%#lx) out of rang=
e\n", pgoff);=0D=0A+=09=09return -EFAULT;=0D=0A+=09}=0D=0A+=0D=0A+=09if (=
kaddr)=0D=0A+=09=09*kaddr =3D virt_addr;=0D=0A+=0D=0A+=09local_pfn =3D PH=
YS_PFN(phys);=0D=0A+=09if (pfn)=0D=0A+=09=09*pfn =3D local_pfn;=0D=0A+=0D=
=0A+=09/*=0D=0A+=09 * Use cached_size which was computed at probe time. T=
he size cannot=0D=0A+=09 * change while the driver is bound (resize retur=
ns -EBUSY).=0D=0A+=09 */=0D=0A+=09return PHYS_PFN(min(size, dev_dax->cach=
ed_size - offset));=0D=0A+}=0D=0A+=0D=0A+static int fsdev_dax_zero_page_r=
ange(struct dax_device *dax_dev,=0D=0A+=09=09=09pgoff_t pgoff, size_t nr_=
pages)=0D=0A+{=0D=0A+=09void *kaddr;=0D=0A+=0D=0A+=09WARN_ONCE(nr_pages >=
 1, "%s: nr_pages > 1\n", __func__);=0D=0A+=09__fsdev_dax_direct_access(d=
ax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);=0D=0A+=09fsdev_write_dax(kad=
dr, ZERO_PAGE(0), 0, PAGE_SIZE);=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+=
static long fsdev_dax_direct_access(struct dax_device *dax_dev,=0D=0A+=09=
=09  pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,=0D=0A+=09=09=
  void **kaddr, unsigned long *pfn)=0D=0A+{=0D=0A+=09return __fsdev_dax_d=
irect_access(dax_dev, pgoff, nr_pages, mode,=0D=0A+=09=09=09=09=09 kaddr,=
 pfn);=0D=0A+}=0D=0A+=0D=0A+static size_t fsdev_dax_recovery_write(struct=
 dax_device *dax_dev, pgoff_t pgoff,=0D=0A+=09=09void *addr, size_t bytes=
, struct iov_iter *i)=0D=0A+{=0D=0A+=09return _copy_from_iter_flushcache(=
addr, bytes, i);=0D=0A+}=0D=0A+=0D=0A+static const struct dax_operations =
dev_dax_ops =3D {=0D=0A+=09.direct_access =3D fsdev_dax_direct_access,=0D=
=0A+=09.zero_page_range =3D fsdev_dax_zero_page_range,=0D=0A+=09.recovery=
_write =3D fsdev_dax_recovery_write,=0D=0A+};=0D=0A+=0D=0A static void fs=
dev_cdev_del(void *cdev)=0D=0A {=0D=0A =09cdev_del(cdev);=0D=0A@@ -167,6 =
+246,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)=0D=0A =09=09=
}=0D=0A =09}=0D=0A=20=0D=0A+=09/* Cache size now; it cannot change while =
driver is bound */=0D=0A+=09dev_dax->cached_size =3D 0;=0D=0A+=09for (i =3D=
 0; i < dev_dax->nr_range; i++)=0D=0A+=09=09dev_dax->cached_size +=3D ran=
ge_len(&dev_dax->ranges[i].range);=0D=0A+=0D=0A =09/*=0D=0A =09 * Use MEM=
ORY_DEVICE_FS_DAX without setting vmemmap_shift, leaving=0D=0A =09 * foli=
os at order-0. Unlike device.c (MEMORY_DEVICE_GENERIC), this=0D=0A--=20=0D=
=0A2.53.0=0D=0A=0D=0A
