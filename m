Received: from a48-181.smtp-out.amazonses.com (a48-181.smtp-out.amazonses.com [54.240.48.181])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35043D47B8
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 13:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773926385; cv=none; b=LJbXvPY+Q5xi/1RZxTL7xt7iPSiHeezX68SaJyeNGnbGj5FB8mWhOel9+hg4EsJUw/N2KdtFvNVqBE+ImvJBP/4mwregdIgiBslxUhdJtZjWGdmhmwuKuoVxkaPiFJYFYMY/QL916ksgRIc7ybmUFKZtMA5DxrggQ8hM/iX3jkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773926385; c=relaxed/simple;
	bh=vvF6H0bhf3l8GpJ7XejUj0yzmPwTHvG4641LuF7xixU=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Ef88tfWS/2JbHnM9VliqbzKKBfvfGVjb3FoblbMwuDD1gDJXSJv4r0B+NwJHFpQeDFwTBffVLOgcS02JsBRQdNjwNEvFptafJLnX6j5gU3TI1rTM3/ZQnG1Nr7u69YQXyJnP4TW4zaWGV8f2+u3TBtD4eIlrrHjk2bZ9QLKA1BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=YHXic3J1; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=UmQnB0XO; arc=none smtp.client-ip=54.240.48.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="YHXic3J1";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UmQnB0XO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1773926381;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=vvF6H0bhf3l8GpJ7XejUj0yzmPwTHvG4641LuF7xixU=;
	b=YHXic3J1PDotNh03B9Zcm6lOl0obl3wrDQ/Dvml618Xj6eCmxqqvfw2bPHypXAGj
	HCLO7lRsEWKa9wzNPYGQ/vyELDaBXoKrd0vL/0ITuCW/MSJasj5N+1G9XSrO0gRqPYC
	qc8aiLopwbf+SvXeQPPwV5hl2L8kL9my5wBlvL9I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1773926381;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=vvF6H0bhf3l8GpJ7XejUj0yzmPwTHvG4641LuF7xixU=;
	b=UmQnB0XOcnUSCHV8H4snp5P7rXrLYmLogNprADAivz6cwJU/AnRgYlh881qTsHD+
	RNkgE6K6K+/gCyDZda0+E7XrRiIW8LNqr0ryMUIr7RA0abJiz88ZY5dPBED8ESwZs63
	otXaHqPWbVMEpuKBBB8y85rG6jTbSrRsTDLgrCi8=
Subject: [PATCH V8 06/10] famfs_fuse: Plumb dax iomap and fuse read/write/mmap
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
Date: Thu, 19 Mar 2026 13:19:41 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260318203054.4344.fuse@groves.net>
References: <20260318203054.4344.fuse@groves.net> 
 <20260319131928.13423-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHctz+ZMjBZ3RwkQ1uhcQrmTMqILwAAVQgdABjcT6E=
Thread-Topic: [PATCH V8 06/10] famfs_fuse: Plumb dax iomap and fuse
 read/write/mmap
X-Wm-Sent-Timestamp: 1773926379
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d0640769d-af11a99e-1bf6-4f72-bbcd-09ff52b5e685-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.19-54.240.48.181

From: John Groves <john@groves.net>=0D=0A=0D=0AThis commit fills in read/=
write/mmap handling for famfs files. The=0D=0Adev_dax_iomap interface is =
used - just like xfs in fs-dax mode.=0D=0A=0D=0A- Read/write are handled =
by famfs_fuse_[read|write]_iter() via=0D=0A  dax_iomap_rw() to fsdev_dax.=
=0D=0A- Mmap is handled by famfs_fuse_mmap()=0D=0A- Faults are handled by=
 famfs_filemap_fault(), using dax_iomap_fault()=0D=0A  to fsdev_dax.=0D=0A=
- File offset to dax offset resolution is handled via=0D=0A  famfs_fuse_i=
omap_begin(), which uses famfs "fmaps" to resolve the=0D=0A  the requeste=
d (file, offset) to an offset on a dax device (by way of=0D=0A  famfs_fil=
eofs_to_daxofs() and famfs_interleave_fileofs_to_daxofs())=0D=0A=0D=0ASig=
ned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse/famfs.c =
 | 448 +++++++++++++++++++++++++++++++++++++++++++++++=0D=0A fs/fuse/file=
=2Ec   |  18 +-=0D=0A fs/fuse/fuse_i.h |  19 ++=0D=0A 3 files changed, 48=
3 insertions(+), 2 deletions(-)=0D=0A=0D=0Adiff --git a/fs/fuse/famfs.c b=
/fs/fuse/famfs.c=0D=0Aindex 0e9415aa6339..6f935032eb17 100644=0D=0A--- a/=
fs/fuse/famfs.c=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -576,6 +576,454 @@ fam=
fs_file_init_dax(=0D=0A =09return rc;=0D=0A }=0D=0A=20=0D=0A+/***********=
**********************************************************=0D=0A+ * iomap=
_operations=0D=0A+ *=0D=0A+ * This stuff uses the iomap (dax-related) hel=
pers to resolve file offsets to=0D=0A+ * offsets within a dax device.=0D=0A=
+ */=0D=0A+=0D=0A+static int famfs_file_bad(struct inode *inode);=0D=0A+=0D=
=0A+static int=0D=0A+famfs_interleave_fileofs_to_daxofs(struct inode *ino=
de, struct iomap *iomap,=0D=0A+=09=09=09 loff_t file_offset, off_t len, u=
nsigned int flags)=0D=0A+{=0D=0A+=09struct fuse_inode *fi =3D get_fuse_in=
ode(inode);=0D=0A+=09struct famfs_file_meta *meta =3D fi->famfs_meta;=0D=0A=
+=09struct fuse_conn *fc =3D get_fuse_conn(inode);=0D=0A+=09loff_t local_=
offset =3D file_offset;=0D=0A+=0D=0A+=09/* This function is only for exte=
nt_type INTERLEAVED_EXTENT */=0D=0A+=09if (meta->fm_extent_type !=3D INTE=
RLEAVED_EXTENT) {=0D=0A+=09=09pr_err("%s: bad extent type\n", __func__);=0D=
=0A+=09=09goto err_out;=0D=0A+=09}=0D=0A+=0D=0A+=09if (famfs_file_bad(ino=
de))=0D=0A+=09=09goto err_out;=0D=0A+=0D=0A+=09iomap->offset =3D file_off=
set;=0D=0A+=0D=0A+=09for (int i =3D 0; i < meta->fm_niext; i++) {=0D=0A+=09=
=09struct famfs_meta_interleaved_ext *fei =3D &meta->ie[i];=0D=0A+=09=09u=
64 chunk_size =3D fei->fie_chunk_size;=0D=0A+=09=09u64 nstrips =3D fei->f=
ie_nstrips;=0D=0A+=09=09u64 ext_size =3D  min(fei->fie_nbytes, meta->file=
_size);=0D=0A+=0D=0A+=09=09if (!IS_ALIGNED(chunk_size, PMD_SIZE)) {=0D=0A=
+=09=09=09pr_err("%s: chunk_size %lld not PMD-aligned\n",=0D=0A+=09=09=09=
       __func__, meta->ie[i].fie_chunk_size);=0D=0A+=09=09=09return -EINV=
AL;=0D=0A+=09=09}=0D=0A+=09=09if (ext_size =3D=3D 0) {=0D=0A+=09=09=09pr_=
err("%s: ext_size=3D%lld file_size=3D%ld\n",=0D=0A+=09=09=09       __func=
__, fei->fie_nbytes, meta->file_size);=0D=0A+=09=09=09goto err_out;=0D=0A=
+=09=09}=0D=0A+=0D=0A+=09=09/* Is the data is in this striped extent=3F *=
/=0D=0A+=09=09if (local_offset < ext_size) {=0D=0A+=09=09=09u64 chunk_num=
       =3D local_offset / chunk_size;=0D=0A+=09=09=09u64 chunk_offset    =
=3D local_offset % chunk_size;=0D=0A+=09=09=09u64 chunk_remainder =3D chu=
nk_size - chunk_offset;=0D=0A+=09=09=09u64 stripe_num      =3D chunk_num =
/ nstrips;=0D=0A+=09=09=09u64 strip_num       =3D chunk_num % nstrips;=0D=
=0A+=09=09=09u64 strip_offset    =3D chunk_offset + (stripe_num * chunk_s=
ize);=0D=0A+=09=09=09u64 strip_dax_ofs =3D fei->ie_strips[strip_num].ext_=
offset;=0D=0A+=09=09=09u64 strip_devidx =3D fei->ie_strips[strip_num].dev=
_index;=0D=0A+=0D=0A+=09=09=09if (strip_devidx >=3D fc->dax_devlist->nslo=
ts) {=0D=0A+=09=09=09=09pr_err("%s: strip_devidx %llu >=3D nslots %d\n",=0D=
=0A+=09=09=09=09       __func__, strip_devidx,=0D=0A+=09=09=09=09       f=
c->dax_devlist->nslots);=0D=0A+=09=09=09=09goto err_out;=0D=0A+=09=09=09}=
=0D=0A+=0D=0A+=09=09=09if (!fc->dax_devlist->devlist[strip_devidx].valid)=
 {=0D=0A+=09=09=09=09pr_err("%s: daxdev=3D%lld invalid\n", __func__,=0D=0A=
+=09=09=09=09=09strip_devidx);=0D=0A+=09=09=09=09goto err_out;=0D=0A+=09=09=
=09}=0D=0A+=0D=0A+=09=09=09iomap->addr    =3D strip_dax_ofs + strip_offse=
t;=0D=0A+=09=09=09iomap->offset  =3D file_offset;=0D=0A+=09=09=09iomap->l=
ength  =3D min_t(loff_t, len, chunk_remainder);=0D=0A+=0D=0A+=09=09=09iom=
ap->dax_dev =3D fc->dax_devlist->devlist[strip_devidx].devp;=0D=0A+=0D=0A=
+=09=09=09iomap->type    =3D IOMAP_MAPPED;=0D=0A+=09=09=09iomap->flags   =
=3D flags;=0D=0A+=0D=0A+=09=09=09return 0;=0D=0A+=09=09}=0D=0A+=09=09loca=
l_offset -=3D ext_size; /* offset is beyond this striped extent */=0D=0A+=
=09}=0D=0A+=0D=0A+ err_out:=0D=0A+=09pr_err("%s: err_out\n", __func__);=0D=
=0A+=0D=0A+=09/* We fell out the end of the extent list.=0D=0A+=09 * Set =
iomap to zero length in this case, and return 0=0D=0A+=09 * This just mea=
ns that the r/w is past EOF=0D=0A+=09 */=0D=0A+=09iomap->addr    =3D 0; /=
* there is no valid dax device offset */=0D=0A+=09iomap->offset  =3D file=
_offset; /* file offset */=0D=0A+=09iomap->length  =3D 0; /* this had bet=
ter result in no access to dax mem */=0D=0A+=09iomap->dax_dev =3D NULL;=0D=
=0A+=09iomap->type    =3D IOMAP_MAPPED;=0D=0A+=09iomap->flags   =3D flags=
;=0D=0A+=0D=0A+=09return -EIO;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_fi=
leofs_to_daxofs() - Resolve (file, offset, len) to (daxdev, offset, len)=0D=
=0A+ *=0D=0A+ * This function is called by famfs_fuse_iomap_begin() to re=
solve an offset in a=0D=0A+ * file to an offset in a dax device. This is =
upcalled from dax from calls to=0D=0A+ * both  * dax_iomap_fault() and da=
x_iomap_rw(). Dax finishes the job resolving=0D=0A+ * a fault to a specif=
ic physical page (the fault case) or doing a memcpy=0D=0A+ * variant (the=
 rw case)=0D=0A+ *=0D=0A+ * Pages can be PTE (4k), PMD (2MiB) or (theoret=
ically) PuD (1GiB)=0D=0A+ * (these sizes are for X86; may vary on other c=
pu architectures=0D=0A+ *=0D=0A+ * @inode:  The file where the fault occu=
rred=0D=0A+ * @iomap:       To be filled in to indicate where to find the=
 right memory,=0D=0A+ *               relative  to a dax device.=0D=0A+ *=
 @file_offset: Within the file where the fault occurred (will be page bou=
ndary)=0D=0A+ * @len:         The length of the faulted mapping (will be =
a page multiple)=0D=0A+ *               (will be trimmed in *iomap if it'=
s disjoint in the extent list)=0D=0A+ * @flags:       flags passed to fam=
fs_fuse_iomap_begin(), and sent back via=0D=0A+ *               struct io=
map=0D=0A+ *=0D=0A+ * Return values: 0. (info is returned in a modified @=
iomap struct)=0D=0A+ */=0D=0A+static int=0D=0A+famfs_fileofs_to_daxofs(st=
ruct inode *inode, struct iomap *iomap,=0D=0A+=09=09=09loff_t file_offset=
, off_t len, unsigned int flags)=0D=0A+{=0D=0A+=09struct fuse_inode *fi =3D=
 get_fuse_inode(inode);=0D=0A+=09struct famfs_file_meta *meta =3D fi->fam=
fs_meta;=0D=0A+=09struct fuse_conn *fc =3D get_fuse_conn(inode);=0D=0A+=09=
loff_t local_offset =3D file_offset;=0D=0A+=0D=0A+=09if (!fc->dax_devlist=
) {=0D=0A+=09=09pr_err("%s: null dax_devlist\n", __func__);=0D=0A+=09=09g=
oto err_out;=0D=0A+=09}=0D=0A+=0D=0A+=09if (famfs_file_bad(inode))=0D=0A+=
=09=09goto err_out;=0D=0A+=0D=0A+=09if (meta->fm_extent_type =3D=3D INTER=
LEAVED_EXTENT)=0D=0A+=09=09return famfs_interleave_fileofs_to_daxofs(inod=
e, iomap,=0D=0A+=09=09=09=09=09=09=09  file_offset,=0D=0A+=09=09=09=09=09=
=09=09  len, flags);=0D=0A+=0D=0A+=09iomap->offset =3D file_offset;=0D=0A=
+=0D=0A+=09for (int i =3D 0; i < meta->fm_nextents; i++) {=0D=0A+=09=09/*=
 TODO: check devindex too */=0D=0A+=09=09loff_t dax_ext_offset =3D meta->=
se[i].ext_offset;=0D=0A+=09=09loff_t dax_ext_len    =3D meta->se[i].ext_l=
en;=0D=0A+=09=09u64 daxdev_idx =3D meta->se[i].dev_index;=0D=0A+=0D=0A+=0D=
=0A+=09=09/* TODO: test that superblock and log offsets only happen=0D=0A=
+=09=09 * with superblock and log files. Requires instrumentaiton=0D=0A+=09=
=09 * from user space...=0D=0A+=09=09 */=0D=0A+=0D=0A+=09=09/* local_offs=
et is the offset minus the size of extents skipped=0D=0A+=09=09 * so far;=
 If local_offset < dax_ext_len, the data of interest=0D=0A+=09=09 * start=
s in this extent=0D=0A+=09=09 */=0D=0A+=09=09if (local_offset < dax_ext_l=
en) {=0D=0A+=09=09=09loff_t ext_len_remainder =3D dax_ext_len - local_off=
set;=0D=0A+=09=09=09struct famfs_daxdev *dd;=0D=0A+=0D=0A+=09=09=09if (da=
xdev_idx >=3D fc->dax_devlist->nslots) {=0D=0A+=09=09=09=09pr_err("%s: da=
xdev_idx %llu >=3D nslots %d\n",=0D=0A+=09=09=09=09       __func__, daxde=
v_idx,=0D=0A+=09=09=09=09       fc->dax_devlist->nslots);=0D=0A+=09=09=09=
=09goto err_out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09dd =3D &fc->dax_d=
evlist->devlist[daxdev_idx];=0D=0A+=0D=0A+=09=09=09if (!dd->valid || dd->=
error) {=0D=0A+=09=09=09=09pr_err("%s: daxdev=3D%lld %s\n", __func__,=0D=0A=
+=09=09=09=09       daxdev_idx,=0D=0A+=09=09=09=09       dd->valid =3F "e=
rror" : "invalid");=0D=0A+=09=09=09=09goto err_out;=0D=0A+=09=09=09}=0D=0A=
+=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * OK, we found the file metadata exte=
nt where this=0D=0A+=09=09=09 * data begins=0D=0A+=09=09=09 * @local_offs=
et      - The offset within the current=0D=0A+=09=09=09 *                =
      extent=0D=0A+=09=09=09 * @ext_len_remainder - Remaining length of e=
xt after=0D=0A+=09=09=09 *                      skipping local_offset=0D=0A=
+=09=09=09 * Outputs:=0D=0A+=09=09=09 * iomap->addr:   the offset within =
the dax device where=0D=0A+=09=09=09 *                the  data starts=0D=
=0A+=09=09=09 * iomap->offset: the file offset=0D=0A+=09=09=09 * iomap->l=
ength: the valid length resolved here=0D=0A+=09=09=09 */=0D=0A+=09=09=09i=
omap->addr    =3D dax_ext_offset + local_offset;=0D=0A+=09=09=09iomap->of=
fset  =3D file_offset;=0D=0A+=09=09=09iomap->length  =3D min_t(loff_t, le=
n, ext_len_remainder);=0D=0A+=0D=0A+=09=09=09iomap->dax_dev =3D fc->dax_d=
evlist->devlist[daxdev_idx].devp;=0D=0A+=0D=0A+=09=09=09iomap->type    =3D=
 IOMAP_MAPPED;=0D=0A+=09=09=09iomap->flags   =3D flags;=0D=0A+=09=09=09re=
turn 0;=0D=0A+=09=09}=0D=0A+=09=09local_offset -=3D dax_ext_len; /* Get r=
eady for the next extent */=0D=0A+=09}=0D=0A+=0D=0A+ err_out:=0D=0A+=09pr=
_err("%s: err_out\n", __func__);=0D=0A+=0D=0A+=09/* We fell out the end o=
f the extent list.=0D=0A+=09 * Set iomap to zero length in this case, and=
 return 0=0D=0A+=09 * This just means that the r/w is past EOF=0D=0A+=09 =
*/=0D=0A+=09iomap->addr    =3D 0; /* there is no valid dax device offset =
*/=0D=0A+=09iomap->offset  =3D file_offset; /* file offset */=0D=0A+=09io=
map->length  =3D 0; /* this had better result in no access to dax mem */=0D=
=0A+=09iomap->dax_dev =3D NULL;=0D=0A+=09iomap->type    =3D IOMAP_MAPPED;=
=0D=0A+=09iomap->flags   =3D flags;=0D=0A+=0D=0A+=09return -EIO;=0D=0A+}=0D=
=0A+=0D=0A+/**=0D=0A+ * famfs_fuse_iomap_begin() - Handler for iomap_begi=
n upcall from dax=0D=0A+ *=0D=0A+ * This function is pretty simple becaus=
e files are=0D=0A+ * * never partially allocated=0D=0A+ * * never have ho=
les (never sparse)=0D=0A+ * * never "allocate on write"=0D=0A+ *=0D=0A+ *=
 @inode:  inode for the file being accessed=0D=0A+ * @offset: offset with=
in the file=0D=0A+ * @length: Length being accessed at offset=0D=0A+ * @f=
lags:  flags to be retured via struct iomap=0D=0A+ * @iomap:  iomap struc=
t to be filled in, resolving (offset, length) to=0D=0A+ *          (daxde=
v, offset, len)=0D=0A+ * @srcmap: source mapping if it is a COW operation=
 (which it is not here)=0D=0A+ */=0D=0A+static int=0D=0A+famfs_fuse_iomap=
_begin(struct inode *inode, loff_t offset, loff_t length,=0D=0A+=09=09  u=
nsigned int flags, struct iomap *iomap, struct iomap *srcmap)=0D=0A+{=0D=0A=
+=09struct fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A+=09struct famf=
s_file_meta *meta =3D fi->famfs_meta;=0D=0A+=09size_t size;=0D=0A+=0D=0A+=
=09size =3D i_size_read(inode);=0D=0A+=0D=0A+=09WARN_ON(size !=3D meta->f=
ile_size);=0D=0A+=0D=0A+=09return famfs_fileofs_to_daxofs(inode, iomap, o=
ffset, length, flags);=0D=0A+}=0D=0A+=0D=0A+/* Note: We never need a spec=
ial set of write_iomap_ops because famfs never=0D=0A+ * performs allocati=
on on write.=0D=0A+ */=0D=0A+const struct iomap_ops famfs_iomap_ops =3D {=
=0D=0A+=09.iomap_begin=09=09=3D famfs_fuse_iomap_begin,=0D=0A+};=0D=0A+=0D=
=0A+/********************************************************************=
*=0D=0A+ * vm_operations=0D=0A+ */=0D=0A+static vm_fault_t=0D=0A+__famfs_=
fuse_filemap_fault(struct vm_fault *vmf, unsigned int pe_size,=0D=0A+=09=09=
      bool write_fault)=0D=0A+{=0D=0A+=09struct inode *inode =3D file_ino=
de(vmf->vma->vm_file);=0D=0A+=09vm_fault_t ret;=0D=0A+=09unsigned long pf=
n;=0D=0A+=0D=0A+=09if (!IS_DAX(file_inode(vmf->vma->vm_file))) {=0D=0A+=09=
=09pr_err("%s: file not marked IS_DAX!!\n", __func__);=0D=0A+=09=09return=
 VM_FAULT_SIGBUS;=0D=0A+=09}=0D=0A+=0D=0A+=09if (write_fault) {=0D=0A+=09=
=09sb_start_pagefault(inode->i_sb);=0D=0A+=09=09file_update_time(vmf->vma=
->vm_file);=0D=0A+=09}=0D=0A+=0D=0A+=09ret =3D dax_iomap_fault(vmf, pe_si=
ze, &pfn, NULL, &famfs_iomap_ops);=0D=0A+=09if (ret & VM_FAULT_NEEDDSYNC)=
=0D=0A+=09=09ret =3D dax_finish_sync_fault(vmf, pe_size, pfn);=0D=0A+=0D=0A=
+=09if (write_fault)=0D=0A+=09=09sb_end_pagefault(inode->i_sb);=0D=0A+=0D=
=0A+=09return ret;=0D=0A+}=0D=0A+=0D=0A+static inline bool=0D=0A+famfs_is=
_write_fault(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09return (vmf->flags & =
FAULT_FLAG_WRITE) &&=0D=0A+=09       (vmf->vma->vm_flags & VM_SHARED);=0D=
=0A+}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+famfs_filemap_fault(struct vm_=
fault *vmf)=0D=0A+{=0D=0A+=09return __famfs_fuse_filemap_fault(vmf, 0, fa=
mfs_is_write_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+fa=
mfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int pe_size)=0D=0A+=
{=0D=0A+=09return __famfs_fuse_filemap_fault(vmf, pe_size,=0D=0A+=09=09=09=
=09=09  famfs_is_write_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+static vm_fault_=
t=0D=0A+famfs_filemap_mkwrite(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09retu=
rn __famfs_fuse_filemap_fault(vmf, 0, true);=0D=0A+}=0D=0A+=0D=0A+const s=
truct vm_operations_struct famfs_file_vm_ops =3D {=0D=0A+=09.fault=09=09=3D=
 famfs_filemap_fault,=0D=0A+=09.huge_fault=09=3D famfs_filemap_huge_fault=
,=0D=0A+=09.map_pages=09=3D filemap_map_pages,=0D=0A+=09.page_mkwrite=09=3D=
 famfs_filemap_mkwrite,=0D=0A+=09.pfn_mkwrite=09=3D famfs_filemap_mkwrite=
,=0D=0A+};=0D=0A+=0D=0A+/************************************************=
*********************=0D=0A+ * file_operations=0D=0A+ */=0D=0A+=0D=0A+/**=
=0D=0A+ * famfs_file_bad() - Check for files that aren't in a valid state=
=0D=0A+ *=0D=0A+ * @inode: inode=0D=0A+ *=0D=0A+ * Returns: 0=3Dsuccess=0D=
=0A+ *          -errno=3Dfailure=0D=0A+ */=0D=0A+static int=0D=0A+famfs_f=
ile_bad(struct inode *inode)=0D=0A+{=0D=0A+=09struct fuse_inode *fi =3D g=
et_fuse_inode(inode);=0D=0A+=09struct famfs_file_meta *meta =3D fi->famfs=
_meta;=0D=0A+=09size_t i_size =3D i_size_read(inode);=0D=0A+=0D=0A+=09if =
(!meta) {=0D=0A+=09=09pr_err("%s: un-initialized famfs file\n", __func__)=
;=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (meta->error) {=0D=0A+=09=
=09pr_debug("%s: previously detected metadata errors\n", __func__);=0D=0A=
+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (i_size !=3D meta->file_size) =
{=0D=0A+=09=09pr_warn("%s: i_size overwritten from %ld to %ld\n",=0D=0A+=09=
=09       __func__, meta->file_size, i_size);=0D=0A+=09=09meta->error =3D=
 true;=0D=0A+=09=09return -ENXIO;=0D=0A+=09}=0D=0A+=09if (!IS_DAX(inode))=
 {=0D=0A+=09=09pr_debug("%s: inode %llx IS_DAX is false\n",=0D=0A+=09=09=09=
 __func__, (u64)inode);=0D=0A+=09=09return -ENXIO;=0D=0A+=09}=0D=0A+=09re=
turn 0;=0D=0A+}=0D=0A+=0D=0A+static ssize_t=0D=0A+famfs_fuse_rw_prep(stru=
ct kiocb *iocb, struct iov_iter *ubuf)=0D=0A+{=0D=0A+=09struct inode *ino=
de =3D iocb->ki_filp->f_mapping->host;=0D=0A+=09size_t i_size =3D i_size_=
read(inode);=0D=0A+=09size_t count =3D iov_iter_count(ubuf);=0D=0A+=09siz=
e_t max_count;=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09rc =3D famfs_file_bad=
(inode);=0D=0A+=09if (rc)=0D=0A+=09=09return (ssize_t)rc;=0D=0A+=0D=0A+=09=
/* Avoid unsigned underflow if position is past EOF */=0D=0A+=09if (iocb-=
>ki_pos >=3D i_size)=0D=0A+=09=09max_count =3D 0;=0D=0A+=09else=0D=0A+=09=
=09max_count =3D i_size - iocb->ki_pos;=0D=0A+=0D=0A+=09if (count > max_c=
ount)=0D=0A+=09=09iov_iter_truncate(ubuf, max_count);=0D=0A+=0D=0A+=09if =
(!iov_iter_count(ubuf))=0D=0A+=09=09return 0;=0D=0A+=0D=0A+=09return rc;=0D=
=0A+}=0D=0A+=0D=0A+ssize_t=0D=0A+famfs_fuse_read_iter(struct kiocb *iocb,=
 struct iov_iter=09*to)=0D=0A+{=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09rc =3D=
 famfs_fuse_rw_prep(iocb, to);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=
=0A+=0D=0A+=09if (!iov_iter_count(to))=0D=0A+=09=09return 0;=0D=0A+=0D=0A=
+=09rc =3D dax_iomap_rw(iocb, to, &famfs_iomap_ops);=0D=0A+=0D=0A+=09file=
_accessed(iocb->ki_filp);=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+ssize_=
t=0D=0A+famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from)=0D=
=0A+{=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09rc =3D famfs_fuse_rw_prep(iocb=
, from);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=0A+=0D=0A+=09if (!iov=
_iter_count(from))=0D=0A+=09=09return 0;=0D=0A+=0D=0A+=09return dax_iomap=
_rw(iocb, from, &famfs_iomap_ops);=0D=0A+}=0D=0A+=0D=0A+int=0D=0A+famfs_f=
use_mmap(struct file *file, struct vm_area_struct *vma)=0D=0A+{=0D=0A+=09=
struct inode *inode =3D file_inode(file);=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A=
+=09rc =3D famfs_file_bad(inode);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=
=0D=0A+=0D=0A+=09file_accessed(file);=0D=0A+=09vma->vm_ops =3D &famfs_fil=
e_vm_ops;=0D=0A+=09vm_flags_set(vma, VM_HUGEPAGE);=0D=0A+=09return 0;=0D=0A=
+}=0D=0A+=0D=0A #define FMAP_BUFSIZE PAGE_SIZE=0D=0A=20=0D=0A int fuse_ge=
t_fmap(struct fuse_mount *fm, struct inode *inode)=0D=0Adiff --git a/fs/f=
use/file.c b/fs/fuse/file.c=0D=0Aindex d7fd934f4412..e7e3d6aa2762 100644=0D=
=0A--- a/fs/fuse/file.c=0D=0A+++ b/fs/fuse/file.c=0D=0A@@ -1831,6 +1831,8=
 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_ite=
r *to)=0D=0A=20=0D=0A =09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09return f=
use_dax_read_iter(iocb, to);=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=09=
return famfs_fuse_read_iter(iocb, to);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_=
IO overrides FOPEN_PASSTHROUGH */=0D=0A =09if (ff->open_flags & FOPEN_DIR=
ECT_IO)=0D=0A@@ -1853,6 +1855,8 @@ static ssize_t fuse_file_write_iter(st=
ruct kiocb *iocb, struct iov_iter *from)=0D=0A=20=0D=0A =09if (FUSE_IS_VI=
RTIO_DAX(fi))=0D=0A =09=09return fuse_dax_write_iter(iocb, from);=0D=0A+=09=
if (fuse_file_famfs(fi))=0D=0A+=09=09return famfs_fuse_write_iter(iocb, f=
rom);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */=
=0D=0A =09if (ff->open_flags & FOPEN_DIRECT_IO)=0D=0A@@ -1868,9 +1872,13 =
@@ static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,=0D=0A =09=
=09=09=09unsigned int flags)=0D=0A {=0D=0A =09struct fuse_file *ff =3D in=
->private_data;=0D=0A+=09struct inode *inode =3D file_inode(in);=0D=0A+=09=
struct fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A=20=0D=0A =09/* FOP=
EN_DIRECT_IO overrides FOPEN_PASSTHROUGH */=0D=0A-=09if (fuse_file_passth=
rough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))=0D=0A+=09if (fuse_file_=
famfs(fi))=0D=0A+=09=09return -EIO; /* famfs does not use the page cache.=
=2E. */=0D=0A+=09else if (fuse_file_passthrough(ff) && !(ff->open_flags &=
 FOPEN_DIRECT_IO))=0D=0A =09=09return fuse_passthrough_splice_read(in, pp=
os, pipe, len, flags);=0D=0A =09else=0D=0A =09=09return filemap_splice_re=
ad(in, ppos, pipe, len, flags);=0D=0A@@ -1880,9 +1888,13 @@ static ssize_=
t fuse_splice_write(struct pipe_inode_info *pipe, struct file *out,=0D=0A=
 =09=09=09=09 loff_t *ppos, size_t len, unsigned int flags)=0D=0A {=0D=0A=
 =09struct fuse_file *ff =3D out->private_data;=0D=0A+=09struct inode *in=
ode =3D file_inode(out);=0D=0A+=09struct fuse_inode *fi =3D get_fuse_inod=
e(inode);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUG=
H */=0D=0A-=09if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_D=
IRECT_IO))=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=09return -EIO; /* =
famfs does not use the page cache... */=0D=0A+=09else if (fuse_file_passt=
hrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))=0D=0A =09=09return fus=
e_passthrough_splice_write(pipe, out, ppos, len, flags);=0D=0A =09else=0D=
=0A =09=09return iter_file_splice_write(pipe, out, ppos, len, flags);=0D=0A=
@@ -2390,6 +2402,8 @@ static int fuse_file_mmap(struct file *file, struct=
 vm_area_struct *vma)=0D=0A =09/* DAX mmap is superior to direct_io mmap =
*/=0D=0A =09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09return fuse_dax_mmap(=
file, vma);=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=09return famfs_fu=
se_mmap(file, vma);=0D=0A=20=0D=0A =09/*=0D=0A =09 * If inode is in passt=
hrough io mode, because it has some file open=0D=0Adiff --git a/fs/fuse/f=
use_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 83e24cee994b..f5548466c2b2 100644=0D=
=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A@@ -1650,6 +16=
50,9 @@ extern void fuse_sysctl_unregister(void);=0D=0A int famfs_file_in=
it_dax(struct fuse_mount *fm,=0D=0A =09=09=09struct inode *inode, void *f=
map_buf,=0D=0A =09=09=09size_t fmap_size);=0D=0A+ssize_t famfs_fuse_write=
_iter(struct kiocb *iocb, struct iov_iter *from);=0D=0A+ssize_t famfs_fus=
e_read_iter(struct kiocb *iocb, struct iov_iter=09*to);=0D=0A+int famfs_f=
use_mmap(struct file *file, struct vm_area_struct *vma);=0D=0A void __fam=
fs_meta_free(void *map);=0D=0A=20=0D=0A void famfs_teardown(struct fuse_c=
onn *fc);=0D=0A@@ -1692,6 +1695,22 @@ int fuse_get_fmap(struct fuse_mount=
 *fm, struct inode *inode);=0D=0A static inline void famfs_teardown(struc=
t fuse_conn *fc)=0D=0A {=0D=0A }=0D=0A+static inline ssize_t famfs_fuse_w=
rite_iter(struct kiocb *iocb,=0D=0A+=09=09=09=09=09    struct iov_iter *t=
o)=0D=0A+{=0D=0A+=09return -ENODEV;=0D=0A+}=0D=0A+static inline ssize_t f=
amfs_fuse_read_iter(struct kiocb *iocb,=0D=0A+=09=09=09=09=09   struct io=
v_iter *to)=0D=0A+{=0D=0A+=09return -ENODEV;=0D=0A+}=0D=0A+static inline =
int famfs_fuse_mmap(struct file *file,=0D=0A+=09=09=09=09  struct vm_area=
_struct *vma)=0D=0A+{=0D=0A+=09return -ENODEV;=0D=0A+}=0D=0A+=0D=0A stati=
c inline struct fuse_backing *famfs_meta_set(struct fuse_inode *fi,=0D=0A=
 =09=09=09=09=09=09  void *meta)=0D=0A {=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
