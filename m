Received: from a11-71.smtp-out.amazonses.com (a11-71.smtp-out.amazonses.com [54.240.11.71])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC7E27AC4D;
	Mon, 20 Jul 2026 03:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519132; cv=none; b=F7H0NYcKuzNjbY0Y14p21TrBM+TDxdSHqW2uUHh49qgQdhq0lZSDq8DsACi/c2jnLKZ3pudt0LxjZ+hmzSUND+ujvmPJPhtsij6bXpVJMSlZeZblA9TfOnv17GAs06b0GYlSfTq3UiDuIcMbBbtZ8VQhOXe7wmkUGrGPzJC+wAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519132; c=relaxed/simple;
	bh=yiRYVxo5aPMgp/8hVKK4Mfltlw2o5LoG56mHbiW/Hbw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=sYk+BV3B8sKTuC4ngVHsaNZQYR2zkGc3Dtgm3UzTz5udshGkCLP8kJw1otD+tvznbW+7MhjdX3Z8SwWK0HScELWQePhZM/6pMP8kYbeJ3e+NQG5Srg2+sJifKy3Dt0II0wWvb33FDDArT1vQhqQvVEL1qDpesg8b+FDKMx/mIwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=IhQwKHlt; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=oSiQ4TWa; arc=none smtp.client-ip=54.240.11.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="IhQwKHlt";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="oSiQ4TWa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519129;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=yiRYVxo5aPMgp/8hVKK4Mfltlw2o5LoG56mHbiW/Hbw=;
	b=IhQwKHlt5F6cO8w0juQHe24vlmUp2MNQQADt9oMl2ueKBJjJVsPFD88AS2UGiOSZ
	jubUUAL5qrG8rr0IQO6kd5/9RNfrTwg9nTtK5Xati7FF3JTFYf8rpOvzdk5cQ//1ewQ
	lOQCK/etEBiW5+uvRKGcfChNFBPr7z62LAaoc2TA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519129;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=yiRYVxo5aPMgp/8hVKK4Mfltlw2o5LoG56mHbiW/Hbw=;
	b=oSiQ4TWaf7vF3WNC6fa7UfdamzcpGgI3dDXenGaQW3NQEqeRSLpMqv0diKhyyQYx
	olmXAZdXApiFjYqk87FkYTsxJe8M8/G7qJDGcsXy25GWgr5zplhJ1y+VeuYFRDZHoBy
	5ieXNLMjHpT3I4a5MJHZUbUgCr1gAFJGnxhD6RzQ=
Subject: [PATCH V11 1/9] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
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
	=?UTF-8?Q?Andrew_Morton?= <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Namjae_Jeon?= <linkinjeon@kernel.org>, 
	=?UTF-8?Q?Lorenzo_Stoakes?= <ljs@kernel.org>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 20 Jul 2026 03:45:29 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
References: 
 <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com> 
 <20260720034520.68741-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAADA3+
Thread-Topic: [PATCH V11 1/9] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
X-Wm-Sent-Timestamp: 1784519128
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da0f95f-3077f162-51f8-4bbc-8133-fbb89141b841-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.71

From: John Groves <john@groves.net>=0D=0A=0D=0AVirtio_fs now needs to det=
ermine if an inode is DAX && not famfs.=0D=0AThis replaces the FUSE_IS_DA=
X() macro with FUSE_IS_VIRTIO_DAX(), in=0D=0Apreparation for famfs in lat=
er commits. The dummy fuse_file_famfs()=0D=0Amacro will be replaced with =
a working function.=0D=0A=0D=0AReviewed-by: Joanne Koong <joannelkoong@gm=
ail.com>=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0ASigned-=
off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse/dir.c    |  =
2 +-=0D=0A fs/fuse/file.c   | 16 ++++++++++------=0D=0A fs/fuse/fuse_i.h =
|  9 ++++++++-=0D=0A fs/fuse/inode.c  |  4 ++--=0D=0A fs/fuse/iomode.c | =
 2 +-=0D=0A 5 files changed, 22 insertions(+), 11 deletions(-)=0D=0A=0D=0A=
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c=0D=0Aindex 0e2a1039fa43..850d6=
24c2eee 100644=0D=0A--- a/fs/fuse/dir.c=0D=0A+++ b/fs/fuse/dir.c=0D=0A@@ =
-2157,7 +2157,7 @@ int fuse_do_setattr(struct mnt_idmap *idmap, struct de=
ntry *dentry,=0D=0A =09=09is_truncate =3D true;=0D=0A =09}=0D=0A=20=0D=0A=
-=09if (FUSE_IS_DAX(inode) && is_truncate) {=0D=0A+=09if (FUSE_IS_VIRTIO_=
DAX(fi) && is_truncate) {=0D=0A =09=09filemap_invalidate_lock(mapping);=0D=
=0A =09=09fault_blocked =3D true;=0D=0A =09=09err =3D fuse_dax_break_layo=
uts(inode, 0, -1);=0D=0Adiff --git a/fs/fuse/file.c b/fs/fuse/file.c=0D=0A=
index ceada75310b8..995e37c935c6 100644=0D=0A--- a/fs/fuse/file.c=0D=0A++=
+ b/fs/fuse/file.c=0D=0A@@ -115,11 +115,12 @@ static void fuse_file_put(s=
truct fuse_file *ff, bool sync)=0D=0A =09=09=09fuse_simple_request(ff->fm=
, args);=0D=0A =09=09=09fuse_release_end(args, 0);=0D=0A =09=09} else {=0D=
=0A+=09=09=09struct fuse_inode *fi =3D get_fuse_inode(ra->inode);=0D=0A =09=
=09=09/*=0D=0A =09=09=09 * DAX inodes may need to issue a number of synch=
ronous=0D=0A =09=09=09 * request for clearing the mappings.=0D=0A =09=09=09=
 */=0D=0A-=09=09=09if (ra && ra->inode && FUSE_IS_DAX(ra->inode))=0D=0A+=09=
=09=09if (ra && ra->inode && FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09=09=09ar=
gs->may_block =3D true;=0D=0A =09=09=09args->end =3D fuse_release_end;=0D=
=0A =09=09=09if (fuse_simple_background(ff->fm, args,=0D=0A@@ -256,7 +257=
,7 @@ static int fuse_open(struct inode *inode, struct file *file)=0D=0A =
=09int err;=0D=0A =09bool is_truncate =3D (file->f_flags & O_TRUNC) && fc=
->atomic_o_trunc;=0D=0A =09bool is_wb_truncate =3D is_truncate && fc->wri=
teback_cache;=0D=0A-=09bool dax_truncate =3D is_truncate && FUSE_IS_DAX(i=
node);=0D=0A+=09bool dax_truncate =3D is_truncate && FUSE_IS_VIRTIO_DAX(f=
i);=0D=0A=20=0D=0A =09if (fuse_is_bad(inode))=0D=0A =09=09return -EIO;=0D=
=0A@@ -1839,11 +1840,12 @@ static ssize_t fuse_file_read_iter(struct kioc=
b *iocb, struct iov_iter *to)=0D=0A =09struct file *file =3D iocb->ki_fil=
p;=0D=0A =09struct fuse_file *ff =3D file->private_data;=0D=0A =09struct =
inode *inode =3D file_inode(file);=0D=0A+=09struct fuse_inode *fi =3D get=
_fuse_inode(inode);=0D=0A=20=0D=0A =09if (fuse_is_bad(inode))=0D=0A =09=09=
return -EIO;=0D=0A=20=0D=0A-=09if (FUSE_IS_DAX(inode))=0D=0A+=09if (FUSE_=
IS_VIRTIO_DAX(fi))=0D=0A =09=09return fuse_dax_read_iter(iocb, to);=0D=0A=
=20=0D=0A =09/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */=0D=0A@@ -1=
860,11 +1862,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb=
, struct iov_iter *from)=0D=0A =09struct file *file =3D iocb->ki_filp;=0D=
=0A =09struct fuse_file *ff =3D file->private_data;=0D=0A =09struct inode=
 *inode =3D file_inode(file);=0D=0A+=09struct fuse_inode *fi =3D get_fuse=
_inode(inode);=0D=0A=20=0D=0A =09if (fuse_is_bad(inode))=0D=0A =09=09retu=
rn -EIO;=0D=0A=20=0D=0A-=09if (FUSE_IS_DAX(inode))=0D=0A+=09if (FUSE_IS_V=
IRTIO_DAX(fi))=0D=0A =09=09return fuse_dax_write_iter(iocb, from);=0D=0A=20=
=0D=0A =09/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */=0D=0A@@ -2399=
,10 +2402,11 @@ static int fuse_file_mmap(struct file *file, struct vm_ar=
ea_struct *vma)=0D=0A =09struct fuse_file *ff =3D file->private_data;=0D=0A=
 =09struct fuse_conn *fc =3D ff->fm->fc;=0D=0A =09struct inode *inode =3D=
 file_inode(file);=0D=0A+=09struct fuse_inode *fi =3D get_fuse_inode(inod=
e);=0D=0A =09int rc;=0D=0A=20=0D=0A =09/* DAX mmap is superior to direct_=
io mmap */=0D=0A-=09if (FUSE_IS_DAX(inode))=0D=0A+=09if (FUSE_IS_VIRTIO_D=
AX(fi))=0D=0A =09=09return fuse_dax_mmap(file, vma);=0D=0A=20=0D=0A =09/*=
=0D=0A@@ -2852,7 +2856,7 @@ static long fuse_file_fallocate(struct file *=
file, int mode, loff_t offset,=0D=0A =09=09.mode =3D mode=0D=0A =09};=0D=0A=
 =09int err;=0D=0A-=09bool block_faults =3D FUSE_IS_DAX(inode) &&=0D=0A+=09=
bool block_faults =3D FUSE_IS_VIRTIO_DAX(fi) &&=0D=0A =09=09(!(mode & FAL=
LOC_FL_KEEP_SIZE) ||=0D=0A =09=09 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_=
FL_ZERO_RANGE)));=0D=0A=20=0D=0Adiff --git a/fs/fuse/fuse_i.h b/fs/fuse/f=
use_i.h=0D=0Aindex 85f738c53122..f450194e877f 100644=0D=0A--- a/fs/fuse/f=
use_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A@@ -1215,7 +1215,14 @@ void fuse=
_free_conn(struct fuse_conn *fc);=0D=0A=20=0D=0A /* dax.c */=0D=0A=20=0D=0A=
-#define FUSE_IS_DAX(inode) (IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode)=
)=0D=0A+static inline bool fuse_file_famfs(struct fuse_inode *fuse_inode)=
 /* Will be superseded */=0D=0A+{=0D=0A+=09(void)fuse_inode;=0D=0A+=09ret=
urn false;=0D=0A+}=0D=0A+#define FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABL=
ED(CONFIG_FUSE_DAX)=09\=0D=0A+=09=09=09=09=09&& IS_DAX(&(fuse_inode)->ino=
de)  \=0D=0A+=09=09=09=09=09&& !fuse_file_famfs(fuse_inode))=0D=0A=20=0D=0A=
 ssize_t fuse_dax_read_iter(struct kiocb *iocb, struct iov_iter *to);=0D=0A=
 ssize_t fuse_dax_write_iter(struct kiocb *iocb, struct iov_iter *from);=0D=
=0Adiff --git a/fs/fuse/inode.c b/fs/fuse/inode.c=0D=0Aindex d975073c6029=
=2E.77c21b28b6fa 100644=0D=0A--- a/fs/fuse/inode.c=0D=0A+++ b/fs/fuse/ino=
de.c=0D=0A@@ -148,7 +148,7 @@ static void fuse_evict_inode(struct inode *=
inode)=0D=0A =09/* Will write inode on close/munmap and in all other dirt=
iers */=0D=0A =09WARN_ON(inode_state_read_once(inode) & I_DIRTY_INODE);=0D=
=0A=20=0D=0A-=09if (FUSE_IS_DAX(inode))=0D=0A+=09if (FUSE_IS_VIRTIO_DAX(f=
i))=0D=0A =09=09dax_break_layout_final(inode);=0D=0A=20=0D=0A =09truncate=
_inode_pages_final(&inode->i_data);=0D=0A@@ -156,7 +156,7 @@ static void =
fuse_evict_inode(struct inode *inode)=0D=0A =09if (inode->i_sb->s_flags &=
 SB_ACTIVE) {=0D=0A =09=09struct fuse_conn *fc =3D get_fuse_conn(inode);=0D=
=0A=20=0D=0A-=09=09if (FUSE_IS_DAX(inode))=0D=0A+=09=09if (FUSE_IS_VIRTIO=
_DAX(fi))=0D=0A =09=09=09fuse_dax_inode_cleanup(inode);=0D=0A =09=09if (f=
i->nlookup) {=0D=0A =09=09=09fuse_chan_queue_forget(fc->chan, fi->forget,=
 fi->nodeid,=0D=0Adiff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c=0D=0Ai=
ndex 3728933188f3..31ee7f3304c6 100644=0D=0A--- a/fs/fuse/iomode.c=0D=0A+=
++ b/fs/fuse/iomode.c=0D=0A@@ -203,7 +203,7 @@ int fuse_file_io_open(stru=
ct file *file, struct inode *inode)=0D=0A =09 * io modes are not relevant=
 with DAX and with server that does not=0D=0A =09 * implement open.=0D=0A=
 =09 */=0D=0A-=09if (FUSE_IS_DAX(inode) || !ff->args)=0D=0A+=09if (FUSE_I=
S_VIRTIO_DAX(fi) || !ff->args)=0D=0A =09=09return 0;=0D=0A=20=0D=0A =09/*=
=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
