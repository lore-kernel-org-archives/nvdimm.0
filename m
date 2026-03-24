Received: from a11-73.smtp-out.amazonses.com (a11-73.smtp-out.amazonses.com [54.240.11.73])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4AA1FC0FC
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312746; cv=none; b=D9Va9KmXPMo0a4LpNAKi2lHG7DARS/mlm/Y/vFyWXKXt1+ONyy9VWYOVkiO96nKsyvmOCk2lGlh2L+jG4wX+gIGM4xZbhYRc0UGxXDg4AvL4lf6IKW3kHoksbGBbltmCKIrUrmPfYw71ycsvkdy7SYY/O2JLC2cCukvZ981kJW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312746; c=relaxed/simple;
	bh=1ZwqoHpz+HZZyv4ZlRWcph43SDHdf/xj4vCU9/u0Q4I=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=sW7Z9IThY5+ywQ4NJyHvVrbbDYpkUySwcnXWaiiSMAw54ole/XoAr4bbhZTVPTBFElONn06ACzhMm7lf0bJd7d7v/VN6CC5xHc3UoE84EL7WOYxDMVUyz5ZrctW3ERra3/nGYxLc6C2xLa6h3h171sox8aC6pEZC42wISNF9PjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=DKdW1qOD; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=dykQ3XGJ; arc=none smtp.client-ip=54.240.11.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="DKdW1qOD";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="dykQ3XGJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312744;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=1ZwqoHpz+HZZyv4ZlRWcph43SDHdf/xj4vCU9/u0Q4I=;
	b=DKdW1qODIPcIIWrL+9rlF9N5OsMF2THyy3hh9XMmtQ6xIgglozX6zh3CfcVA52f+
	gF6JH3L4fvyriFUnw60STB2rDJ+fUBDM1VN5oTDf/R1yJ8yThuyxf7/n6uop0sHUmBx
	4Bmbvx9qUUNVD3beiNkG2ZFqGmxdANE/rTI727II=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312744;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=1ZwqoHpz+HZZyv4ZlRWcph43SDHdf/xj4vCU9/u0Q4I=;
	b=dykQ3XGJ5/ScVIlGLPeoYnLt1rvGk/wD9nReU9G0F+wmAm+ox42ESt3gxWUaoXp5
	7eKjZU6AwG+MsfTTowgmAyhtnHXKtjFrbLOQE4LjGOi0MbrITKNi7ZxtrSmYmzMWK4r
	0jrKLhjOF2EZO88P2hHI1BdP76Sa74s1q6oYAeUo=
Subject: [PATCH V9 5/8] dax: Add dax_operations for use by fs-dax on fsdev dax
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
Date: Tue, 24 Mar 2026 00:39:04 +0000
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
 <20260324003851.5045-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyacoLShcwO6StaeU6Nu4pfQrw==
Thread-Topic: [PATCH V9 5/8] dax: Add dax_operations for use by fs-dax on
 fsdev dax
X-Wm-Sent-Timestamp: 1774312742
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d47e459-48f2a4e6-edab-4002-bde3-2ba642deccaf-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.73

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
ax-private.h |  1 +=0D=0A drivers/dax/fsdev.c       | 84 ++++++++++++++++=
+++++++++++++++++++++++=0D=0A 2 files changed, 85 insertions(+)=0D=0A=0D=0A=
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h=0D=0Ai=
ndex 7a3727d76a68..ee8f3af8387f 100644=0D=0A--- a/drivers/dax/dax-private=
=2Eh=0D=0A+++ b/drivers/dax/dax-private.h=0D=0A@@ -85,6 +85,7 @@ struct d=
ev_dax {=0D=0A =09struct dax_region *region;=0D=0A =09struct dax_device *=
dax_dev;=0D=0A =09void *virt_addr;=0D=0A+=09u64 cached_size;=0D=0A =09uns=
igned int align;=0D=0A =09int target_node;=0D=0A =09bool dyn_id;=0D=0Adif=
f --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex c75478d3d5=
48..be3d2b0e8418 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/drivers=
/dax/fsdev.c=0D=0A@@ -28,6 +28,85 @@=0D=0A  * - No mmap support - all acc=
ess is through fs-dax/iomap=0D=0A  */=0D=0A=20=0D=0A+static void fsdev_wr=
ite_dax(void *pmem_addr, struct page *page,=0D=0A+=09=09unsigned int off,=
 unsigned int len)=0D=0A+{=0D=0A+=09while (len) {=0D=0A+=09=09void *mem =3D=
 kmap_local_page(page);=0D=0A+=09=09unsigned int chunk =3D min_t(unsigned=
 int, len, PAGE_SIZE - off);=0D=0A+=0D=0A+=09=09memcpy_flushcache(pmem_ad=
dr, mem + off, chunk);=0D=0A+=09=09kunmap_local(mem);=0D=0A+=09=09len -=3D=
 chunk;=0D=0A+=09=09off =3D 0;=0D=0A+=09=09page++;=0D=0A+=09=09pmem_addr =
+=3D chunk;=0D=0A+=09}=0D=0A+}=0D=0A+=0D=0A+static long __fsdev_dax_direc=
t_access(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A+=09=09=09long n=
r_pages, enum dax_access_mode mode, void **kaddr,=0D=0A+=09=09=09unsigned=
 long *pfn)=0D=0A+{=0D=0A+=09struct dev_dax *dev_dax =3D dax_get_private(=
dax_dev);=0D=0A+=09size_t size =3D nr_pages << PAGE_SHIFT;=0D=0A+=09size_=
t offset =3D pgoff << PAGE_SHIFT;=0D=0A+=09void *virt_addr =3D dev_dax->v=
irt_addr + offset;=0D=0A+=09phys_addr_t phys;=0D=0A+=09unsigned long loca=
l_pfn;=0D=0A+=0D=0A+=09phys =3D dax_pgoff_to_phys(dev_dax, pgoff, nr_page=
s << PAGE_SHIFT);=0D=0A+=09if (phys =3D=3D -1) {=0D=0A+=09=09dev_dbg(&dev=
_dax->dev,=0D=0A+=09=09=09"pgoff (%#lx) out of range\n", pgoff);=0D=0A+=09=
=09return -EFAULT;=0D=0A+=09}=0D=0A+=0D=0A+=09if (kaddr)=0D=0A+=09=09*kad=
dr =3D virt_addr;=0D=0A+=0D=0A+=09local_pfn =3D PHYS_PFN(phys);=0D=0A+=09=
if (pfn)=0D=0A+=09=09*pfn =3D local_pfn;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * U=
se cached_size which was computed at probe time. The size cannot=0D=0A+=09=
 * change while the driver is bound (resize returns -EBUSY).=0D=0A+=09 */=
=0D=0A+=09return PHYS_PFN(min(size, dev_dax->cached_size - offset));=0D=0A=
+}=0D=0A+=0D=0A+static int fsdev_dax_zero_page_range(struct dax_device *d=
ax_dev,=0D=0A+=09=09=09pgoff_t pgoff, size_t nr_pages)=0D=0A+{=0D=0A+=09v=
oid *kaddr;=0D=0A+=0D=0A+=09WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n",=
 __func__);=0D=0A+=09__fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACC=
ESS, &kaddr, NULL);=0D=0A+=09fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE=
_SIZE);=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static long fsdev_dax_dir=
ect_access(struct dax_device *dax_dev,=0D=0A+=09=09  pgoff_t pgoff, long =
nr_pages, enum dax_access_mode mode,=0D=0A+=09=09  void **kaddr, unsigned=
 long *pfn)=0D=0A+{=0D=0A+=09return __fsdev_dax_direct_access(dax_dev, pg=
off, nr_pages, mode,=0D=0A+=09=09=09=09=09 kaddr, pfn);=0D=0A+}=0D=0A+=0D=
=0A+static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pg=
off_t pgoff,=0D=0A+=09=09void *addr, size_t bytes, struct iov_iter *i)=0D=
=0A+{=0D=0A+=09return _copy_from_iter_flushcache(addr, bytes, i);=0D=0A+}=
=0D=0A+=0D=0A+static const struct dax_operations dev_dax_ops =3D {=0D=0A+=
=09.direct_access =3D fsdev_dax_direct_access,=0D=0A+=09.zero_page_range =
=3D fsdev_dax_zero_page_range,=0D=0A+=09.recovery_write =3D fsdev_dax_rec=
overy_write,=0D=0A+};=0D=0A+=0D=0A static void fsdev_cdev_del(void *cdev)=
=0D=0A {=0D=0A =09cdev_del(cdev);=0D=0A@@ -167,6 +246,11 @@ static int fs=
dev_dax_probe(struct dev_dax *dev_dax)=0D=0A =09=09}=0D=0A =09}=0D=0A=20=0D=
=0A+=09/* Cache size now; it cannot change while driver is bound */=0D=0A=
+=09dev_dax->cached_size =3D 0;=0D=0A+=09for (i =3D 0; i < dev_dax->nr_ra=
nge; i++)=0D=0A+=09=09dev_dax->cached_size +=3D range_len(&dev_dax->range=
s[i].range);=0D=0A+=0D=0A =09/*=0D=0A =09 * Use MEMORY_DEVICE_FS_DAX with=
out setting vmemmap_shift, leaving=0D=0A =09 * folios at order-0. Unlike =
device.c (MEMORY_DEVICE_GENERIC), this=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
