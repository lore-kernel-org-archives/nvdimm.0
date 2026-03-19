Received: from a48-180.smtp-out.amazonses.com (a48-180.smtp-out.amazonses.com [54.240.48.180])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DC836215D
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773926242; cv=none; b=Uql0f63434HQplwCZCxjHaG1lepO+yQVtcM//n6hNVlFWIOqywAKBe3F5qGVnW83k+5CFKXzJjP5vXsXOJHOV9iz7xPPZXKkvmynJnSueJS0L72qKVL9GKLRuevP2EBm5tF+g1V7+5mBMa7gPYSufVtKmjPDsbnEOYsGswZrOk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773926242; c=relaxed/simple;
	bh=aVOWktn7Be6Ghxm+vuGHaN6h+AiXFLMEER9GbIe1bII=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Y3Fj/kK6v4Vi6Dq/3mNamMaqtqcfxRqE6m9SLCJxLF5Sv23szt60GhrxptWs+kyelskHmY5DvXEc4K41aS0rj/rTMzGbiEnMHR677Ca0/pldSKCowdqzedoaeczpn2cavw4vuGSQC4Do1XJFnJdYcszn3N3XgYOyL2iEUQRQOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=S6HXL8x6; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=PQweVdUJ; arc=none smtp.client-ip=54.240.48.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="S6HXL8x6";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="PQweVdUJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1773926239;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=aVOWktn7Be6Ghxm+vuGHaN6h+AiXFLMEER9GbIe1bII=;
	b=S6HXL8x6VwD6fzoVp/ppiAFZ5MAPtEyh+gMTddjIhbWfjFy78ab9WNNeG/NyWs/4
	cVECfh8Pav+DeTFwTMmp0Y75dv24FD8iBEyUE8lbMco+J2dHzDaA4SgVrIdRN7Y5Vl2
	Ui6dkP81BPFyQF09nvZWANNqqykS2JkBxZI9paZ4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1773926239;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=aVOWktn7Be6Ghxm+vuGHaN6h+AiXFLMEER9GbIe1bII=;
	b=PQweVdUJm0x0NKZFX1tv/mpnfIyx5Zov+wb6S5Bp8HAUhX7VQvkzXEvpmOpoxXbt
	uK2hN/UyJ18BsgL8xZ+FHN9FIF6xKdcTL4AaFm0fDQYg7EEc3l4PFSNjuxd8foauwV/
	2m+AHXJJ2iS8mvH+iFBURs3k0GgtlN/44iJV4myY=
Subject: [PATCH V8 01/10] famfs_fuse: Update macro
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
Date: Thu, 19 Mar 2026 13:17:19 +0000
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
 <20260319131704.13280-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHctz+ZMjBZ3RwkQ1uhcQrmTMqILwAAVQgdABjHKME=
Thread-Topic: [PATCH V8 01/10] famfs_fuse: Update macro
 s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
X-Wm-Sent-Timestamp: 1773926238
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d063e4cd5-b06bec1a-ff2c-4eb2-95e2-06223cd483b6-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.19-54.240.48.180

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
index b1bb7153cb78..4ee5065737d8 100644=0D=0A--- a/fs/fuse/file.c=0D=0A++=
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
45e108dec771 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i=
=2Eh=0D=0A@@ -1508,7 +1508,14 @@ void fuse_free_conn(struct fuse_conn *fc=
);=0D=0A=20=0D=0A /* dax.c */=0D=0A=20=0D=0A-#define FUSE_IS_DAX(inode) (=
IS_ENABLED(CONFIG_FUSE_DAX) && IS_DAX(inode))=0D=0A+static inline bool fu=
se_file_famfs(struct fuse_inode *fuse_inode) /* Will be superseded */=0D=0A=
+{=0D=0A+=09(void)fuse_inode;=0D=0A+=09return false;=0D=0A+}=0D=0A+#defin=
e FUSE_IS_VIRTIO_DAX(fuse_inode) (IS_ENABLED(CONFIG_FUSE_DAX)=09\=0D=0A+=09=
=09=09=09=09&& IS_DAX(&fuse_inode->inode)  \=0D=0A+=09=09=09=09=09&& !fus=
e_file_famfs(fuse_inode))=0D=0A=20=0D=0A ssize_t fuse_dax_read_iter(struc=
t kiocb *iocb, struct iov_iter *to);=0D=0A ssize_t fuse_dax_write_iter(st=
ruct kiocb *iocb, struct iov_iter *from);=0D=0Adiff --git a/fs/fuse/inode=
=2Ec b/fs/fuse/inode.c=0D=0Aindex e57b8af06be9..1333b3ebb18a 100644=0D=0A=
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
