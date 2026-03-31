Received: from a11-32.smtp-out.amazonses.com (a11-32.smtp-out.amazonses.com [54.240.11.32])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6403E122C
	for <nvdimm@lists.linux.dev>; Tue, 31 Mar 2026 12:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960690; cv=none; b=FTS+LNvxShEi/r8PIEaxNlZ5U6mFbo6Af39EQzuZSqj9XNDBoTwvXfm7Cj+E6BTD2nAwxvIKr1Cs0FOGGZsJi4ksLxlaBXgKT03hIZsMjxXp/8yGBVQT41CLcxy4b+0A1412CB+CGvwQzpODR0f5YmTueCPxc38/INVyiEuRzAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960690; c=relaxed/simple;
	bh=fO1ri1rXkYsS+IZNCz+JiHpF8MKaPPKctnyAykc0tTI=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=mVgFn504QAmURvrb/h5rAn23kHDWHgu7mkqWk5SY6x5uy+5eFGCthRv3Q9Jf4x8MU2p4fUE5gvOn+yjKLSitrwhjyo74/k1IBppjD3/tiIWUKWzf9u1WRchj7Z+tOBrdX1zN28DmRG882BLivYGlOO0CK3peiqXUGaqwgvODL0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=fuNvTmbm; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=EMkqR0bj; arc=none smtp.client-ip=54.240.11.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="fuNvTmbm";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="EMkqR0bj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774960687;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=fO1ri1rXkYsS+IZNCz+JiHpF8MKaPPKctnyAykc0tTI=;
	b=fuNvTmbmm/YD43cw4YdobEqZGgD5fjR1fKF5BRGZNYvz8FhFjaXsX+nsWJIUSLFg
	Ce8Gc6tCk9jMYP6V9Ct2M/psPxi7mpCzR7vNDCOFPHXqgoVjoUQKhPAw9JM5UZkCvk3
	XBl9KTv1bStd3G6yqqejUZGVpeOXtbEhEng7WYaw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774960687;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=fO1ri1rXkYsS+IZNCz+JiHpF8MKaPPKctnyAykc0tTI=;
	b=EMkqR0bjd20gH0HWQ3kMDNhIuwxWoSn9lS8VCi+a3cNTOwZM577s6ab9eAgdOcMU
	avcXpjfzqoZIaM12fxvdd6wuLi/6Ftm/8/3gQLhg19MRvbBTRCWx9s8+ACvLOEjKOt5
	qbce2vptOlMVeC97P/+JOx/JfETnWT8rbPgoMasU=
Subject: [PATCH V10 01/10] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
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
Date: Tue, 31 Mar 2026 12:38:07 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
References: 
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com> 
 <20260331123757.35092-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcwQs4BFkXw0p3R0CP3NDOJXVjXQ==
Thread-Topic: [PATCH V10 01/10] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
X-Wm-Sent-Timestamp: 1774960686
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d43e6b8e5-cfd15189-bdf2-4e3d-8530-13f56761f558-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.31-54.240.11.32

From: John Groves <john@groves.net>=0D=0A=0D=0AVirtio_fs now needs to det=
ermine if an inode is DAX && not famfs.=0D=0AThis relaces the FUSE_IS_DAX=
() macro with FUSE_IS_VIRTIO_DAX(),=0D=0Ain preparation for famfs in late=
r commits. The dummy=0D=0Afuse_file_famfs() macro will be replaced with a=
 working=0D=0Afunction.=0D=0A=0D=0AReviewed-by: Joanne Koong <joannelkoon=
g@gmail.com>=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0ASig=
ned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse/dir.c   =
 |  2 +-=0D=0A fs/fuse/file.c   | 13 ++++++++-----=0D=0A fs/fuse/fuse_i.h=
 |  9 ++++++++-=0D=0A fs/fuse/inode.c  |  4 ++--=0D=0A fs/fuse/iomode.c |=
  2 +-=0D=0A 5 files changed, 20 insertions(+), 10 deletions(-)=0D=0A=0D=0A=
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c=0D=0Aindex 7ac6b232ef12..c63f0=
97bc697 100644=0D=0A--- a/fs/fuse/dir.c=0D=0A+++ b/fs/fuse/dir.c=0D=0A@@ =
-2161,7 +2161,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct de=
ntry *dentry,=0D=0A =09=09is_truncate =3D true;=0D=0A =09}=0D=0A=20=0D=0A=
-=09if (FUSE_IS_DAX(inode) && is_truncate) {=0D=0A+=09if (FUSE_IS_VIRTIO_=
DAX(fi) && is_truncate) {=0D=0A =09=09filemap_invalidate_lock(mapping);=0D=
=0A =09=09fault_blocked =3D true;=0D=0A =09=09err =3D fuse_dax_break_layo=
uts(inode, 0, -1);=0D=0Adiff --git a/fs/fuse/file.c b/fs/fuse/file.c=0D=0A=
index 676fd9856bfb..150f2e1d6c2f 100644=0D=0A--- a/fs/fuse/file.c=0D=0A++=
+ b/fs/fuse/file.c=0D=0A@@ -252,7 +252,7 @@ static int fuse_open(struct i=
node *inode, struct file *file)=0D=0A =09int err;=0D=0A =09bool is_trunca=
te =3D (file->f_flags & O_TRUNC) && fc->atomic_o_trunc;=0D=0A =09bool is_=
wb_truncate =3D is_truncate && fc->writeback_cache;=0D=0A-=09bool dax_tru=
ncate =3D is_truncate && FUSE_IS_DAX(inode);=0D=0A+=09bool dax_truncate =3D=
 is_truncate && FUSE_IS_VIRTIO_DAX(fi);=0D=0A=20=0D=0A =09if (fuse_is_bad=
(inode))=0D=0A =09=09return -EIO;=0D=0A@@ -1812,11 +1812,12 @@ static ssi=
ze_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)=0D=0A =09=
struct file *file =3D iocb->ki_filp;=0D=0A =09struct fuse_file *ff =3D fi=
le->private_data;=0D=0A =09struct inode *inode =3D file_inode(file);=0D=0A=
+=09struct fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A=20=0D=0A =09if=
 (fuse_is_bad(inode))=0D=0A =09=09return -EIO;=0D=0A=20=0D=0A-=09if (FUSE=
_IS_DAX(inode))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09return f=
use_dax_read_iter(iocb, to);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO overrid=
es FOPEN_PASSTHROUGH */=0D=0A@@ -1833,11 +1834,12 @@ static ssize_t fuse_=
file_write_iter(struct kiocb *iocb, struct iov_iter *from)=0D=0A =09struc=
t file *file =3D iocb->ki_filp;=0D=0A =09struct fuse_file *ff =3D file->p=
rivate_data;=0D=0A =09struct inode *inode =3D file_inode(file);=0D=0A+=09=
struct fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A=20=0D=0A =09if (fu=
se_is_bad(inode))=0D=0A =09=09return -EIO;=0D=0A=20=0D=0A-=09if (FUSE_IS_=
DAX(inode))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09return fuse_=
dax_write_iter(iocb, from);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO override=
s FOPEN_PASSTHROUGH */=0D=0A@@ -2370,10 +2372,11 @@ static int fuse_file_=
mmap(struct file *file, struct vm_area_struct *vma)=0D=0A =09struct fuse_=
file *ff =3D file->private_data;=0D=0A =09struct fuse_conn *fc =3D ff->fm=
->fc;=0D=0A =09struct inode *inode =3D file_inode(file);=0D=0A+=09struct =
fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A =09int rc;=0D=0A=20=0D=0A=
 =09/* DAX mmap is superior to direct_io mmap */=0D=0A-=09if (FUSE_IS_DAX=
(inode))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09return fuse_dax=
_mmap(file, vma);=0D=0A=20=0D=0A =09/*=0D=0A@@ -2934,7 +2937,7 @@ static =
long fuse_file_fallocate(struct file *file, int mode, loff_t offset,=0D=0A=
 =09=09.mode =3D mode=0D=0A =09};=0D=0A =09int err;=0D=0A-=09bool block_f=
aults =3D FUSE_IS_DAX(inode) &&=0D=0A+=09bool block_faults =3D FUSE_IS_VI=
RTIO_DAX(fi) &&=0D=0A =09=09(!(mode & FALLOC_FL_KEEP_SIZE) ||=0D=0A =09=09=
 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));=0D=0A=20=0D=0Ad=
iff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 7f16049387d1..=
80bf4438c436 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i=
=2Eh=0D=0A@@ -1508,7 +1508,14 @@ void fuse_free_conn(struct fuse_conn *fc=
);=0D=0A=20=0D=0A /* dax.c */=0D=0A=20=0D=0A-#define FUSE_IS_DAX(inode) (=
IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))=0D=0A+static inline bool fu=
se_file_famfs(struct fuse_inode *fuse_inode) /* Will be superseded */=0D=0A=
+{=0D=0A+=09(void)fuse_inode;=0D=0A+=09return false;=0D=0A+}=0D=0A+#defin=
e FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)=09\=0D=0A+=09=
=09=09=09=09&& IS_DAX(&(fuse_inode)->inode)  \=0D=0A+=09=09=09=09=09&& !f=
use_file_famfs(fuse_inode))=0D=0A=20=0D=0A ssize_t fuse_dax_read_iter(str=
uct kiocb *iocb, struct iov_iter *to);=0D=0A ssize_t fuse_dax_write_iter(=
struct kiocb *iocb, struct iov_iter *from);=0D=0Adiff --git a/fs/fuse/ino=
de.c b/fs/fuse/inode.c=0D=0Aindex c795abe47a4f..f688c31f7eef 100644=0D=0A=
--- a/fs/fuse/inode.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A@@ -162,7 +162,7 @@=
 static void fuse_evict_inode(struct inode *inode)=0D=0A =09/* Will write=
 inode on close/munmap and in all other dirtiers */=0D=0A =09WARN_ON(inod=
e_state_read_once(inode) & I_DIRTY_INODE);=0D=0A=20=0D=0A-=09if (FUSE_IS_=
DAX(inode))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09dax_break_la=
yout_final(inode);=0D=0A=20=0D=0A =09truncate_inode_pages_final(&inode->i=
_data);=0D=0A@@ -170,7 +170,7 @@ static void fuse_evict_inode(struct inod=
e *inode)=0D=0A =09if (inode->i_sb->s_flags & SB_ACTIVE) {=0D=0A =09=09st=
ruct fuse_conn *fc =3D get_fuse_conn(inode);=0D=0A=20=0D=0A-=09=09if (FUS=
E_IS_DAX(inode))=0D=0A+=09=09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09=09f=
use_dax_inode_cleanup(inode);=0D=0A =09=09if (fi->nlookup) {=0D=0A =09=09=
=09fuse_queue_forget(fc, fi->forget, fi->nodeid,=0D=0Adiff --git a/fs/fus=
e/iomode.c b/fs/fuse/iomode.c=0D=0Aindex 3728933188f3..31ee7f3304c6 10064=
4=0D=0A--- a/fs/fuse/iomode.c=0D=0A+++ b/fs/fuse/iomode.c=0D=0A@@ -203,7 =
+203,7 @@ int fuse_file_io_open(struct file *file, struct inode *inode)=0D=
=0A =09 * io modes are not relevant with DAX and with server that does no=
t=0D=0A =09 * implement open.=0D=0A =09 */=0D=0A-=09if (FUSE_IS_DAX(inode=
) || !ff->args)=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(fi) || !ff->args)=0D=0A =09=
=09return 0;=0D=0A=20=0D=0A =09/*=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
