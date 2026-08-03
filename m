Received: from a8-40.smtp-out.amazonses.com (a8-40.smtp-out.amazonses.com [54.240.8.40])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646BC2D9EDC;
	Mon,  3 Aug 2026 02:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724141; cv=none; b=buUMCpsB/8kjZBB+XiS9vSk+V+5N4qTb3Kf55PS03KVYC3nVPx4QCkMsEd69ciN0cRjPk0Xk5BuS7U/gCyrcPCEPVdO4kbwKEExHVhzEBesoBytCnn2veuifV/2LhpunPCjK504oInb/Zf6JOz68YHXuW+2z7K+elue8Wi8e12E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724141; c=relaxed/simple;
	bh=SrOC2rGOYCAD4tDfF8AgwnW5bQAAVt6j4GlzaTImr9s=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=IzDeT7kBQ6+Slx92RQwjEcC3xFCIW6wgy/aVLRc64uo1wIDciOWkNlX5q9llKnjz5Or8QgQk1CvlhNtvEAUt5tct/DWnymCJdYQ5Ed6tAqmy8aIsj1HZ2geh1XDmcU5L9DwzbDwHPpTbJgppVPAPpV5U7UT/KwvnRLPKDSn4c5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=TIxdnwSF; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=SunnqMGu; arc=none smtp.client-ip=54.240.8.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="TIxdnwSF";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="SunnqMGu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724137;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=SrOC2rGOYCAD4tDfF8AgwnW5bQAAVt6j4GlzaTImr9s=;
	b=TIxdnwSFtiIx35ubvaBvLDh9NwMaGCXj/nZ6VhXgcoozU/k6f/eLN1TFRfCVfuoo
	l0KR7wGrhiB/Q4GygpO3w/Y2SKjjpYf3pLFMHQ05m2PgJ46s90oiaLBfFgOe+yydceb
	701M0mmDzweGFlJXP4hPx2wEt7fSH8kbbJVVgzT0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724137;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=SrOC2rGOYCAD4tDfF8AgwnW5bQAAVt6j4GlzaTImr9s=;
	b=SunnqMGuZavJlRz/5ro5R6XnniWd8NtUfrRqvajaOyt2XNi3U+8pju/DGLEeVJaD
	ebqJYJWYSqMd08Yj2wVbpgDeZd0RpwNC90IsP2uSVuDvgdzrhhWpviSzAaejSGmUAG6
	1uSIl9hxi9PUeaU5ee0IAE0Hz2hjyz77eWJdEqPo=
Subject: [PATCH V12 04/12] famfs: Introduce inode_operations and
 super_operations
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Jake_Edge?= <jake@lwn.net>, 
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
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
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
	=?UTF-8?Q?Greg_Kroah-Hartman?= <gregkh@linuxfoundation.org>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Pasha_Tatashin?= <pasha.tatashin@soleen.com>, 
	=?UTF-8?Q?Haren_Myneni?= <haren@linux.ibm.com>, 
	=?UTF-8?Q?Pratyush_Yadav?= <pratyush@kernel.org>, 
	=?UTF-8?Q?Giovanni_Cabiddu?= <giovanni.cabiddu@intel.com>, 
	=?UTF-8?Q?Jiri_Slaby?= <jirislaby@kernel.org>, 
	=?UTF-8?Q?Ethan_Nelson-Moo?= =?UTF-8?Q?re?= <enelsonmoore@gmail.com>, 
	=?UTF-8?Q?Gabriel_Whigham?= <gabewhigham@gmail.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40m?= =?UTF-8?Q?icron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40?= =?UTF-8?Q?vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?fuse-devel=40lists=2Elinux=2E?= =?UTF-8?Q?dev?= <fuse-devel@lists.linux.dev>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Mon, 3 Aug 2026 02:28:56 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
References: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com> 
 <20260803022849.75812-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAACykv
Thread-Topic: [PATCH V12 04/12] famfs: Introduce inode_operations and
 super_operations
X-Wm-Sent-Timestamp: 1785724135
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc573edf6-93c159df-6197-4bdf-9f1d-74b77a72ce7e-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.8.40

From: John Groves <john@groves.net>=0D=0A=0D=0AThe famfs inode and super =
operations are generic other than=0D=0Ashow_options, evict_inode and seta=
ttr (which prevents truncation..=0D=0A=0D=0AThis commit builds but is sti=
ll too incomplete to run=0D=0A=0D=0ASigned-off-by: John Groves <john@grov=
es.net>=0D=0A---=0D=0A fs/famfs/famfs_inode.c    | 249 ++++++++++++++++++=
+++++++++++++++++++-=0D=0A fs/famfs/famfs_internal.h |   6 +=0D=0A 2 file=
s changed, 252 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/fs/f=
amfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex ad71e5e7a8e3..efc6=
b852eca0 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/fam=
fs_inode.c=0D=0A@@ -29,6 +29,9 @@=0D=0A=20=0D=0A #define FAMFS_DEFAULT_MO=
DE=090755=0D=0A=20=0D=0A+static const struct inode_operations famfs_file_=
inode_operations;=0D=0A+static const struct inode_operations famfs_dir_in=
ode_operations;=0D=0A+=0D=0A static struct inode *famfs_get_inode(=0D=0A =
=09=09=09struct super_block *sb,=0D=0A =09=09=09const struct inode *dir,=0D=
=0A@@ -54,11 +57,11 @@ static struct inode *famfs_get_inode(=0D=0A =09=09=
init_special_inode(inode, mode, dev);=0D=0A =09=09break;=0D=0A =09case S_=
IFREG:=0D=0A-=09=09inode->i_op =3D NULL /* famfs_file_inode_operations */=
;=0D=0A+=09=09inode->i_op =3D &famfs_file_inode_operations;=0D=0A =09=09i=
node->i_fop =3D NULL /* &famfs_file_operations */;=0D=0A =09=09break;=0D=0A=
 =09case S_IFDIR:=0D=0A-=09=09inode->i_op =3D NULL /* famfs_dir_inode_ope=
rations */;=0D=0A+=09=09inode->i_op =3D &famfs_dir_inode_operations;=0D=0A=
 =09=09inode->i_fop =3D &simple_dir_operations;=0D=0A=20=0D=0A =09=09/* D=
irectory inodes start off with i_nlink =3D=3D 2 (for ".") */=0D=0A@@ -72,=
6 +75,246 @@ static struct inode *famfs_get_inode(=0D=0A =09return inode;=
=0D=0A }=0D=0A=20=0D=0A+/************************************************=
***************************=0D=0A+ * famfs inode_operations=0D=0A+ */=0D=0A=
+=0D=0A+static int=0D=0A+famfs_setattr(=0D=0A+=09struct mnt_idmap *idmap,=
=0D=0A+=09struct dentry *dentry,=0D=0A+=09struct iattr *iattr)=0D=0A+{=0D=
=0A+=09struct inode *inode =3D d_inode(dentry);=0D=0A+=09struct famfs_fs_=
info *fsi =3D inode->i_sb->s_fs_info;=0D=0A+=0D=0A+=09/* Resizing a famfs=
 file (its size is pinned to the fmap) */=0D=0A+=09if ((iattr->ia_valid &=
 ATTR_SIZE) &&=0D=0A+=09    !famfs_opt_enabled(fsi, FAMFS_OPT_TRUNCATE) &=
&=0D=0A+=09    iattr->ia_size !=3D i_size_read(inode))=0D=0A+=09=09return=
 -EPERM;=0D=0A+=09if ((iattr->ia_valid & ATTR_MODE) &&=0D=0A+=09    !famf=
s_opt_enabled(fsi, FAMFS_OPT_CHMOD))=0D=0A+=09=09return -EPERM;=0D=0A+=09=
if ((iattr->ia_valid & (ATTR_UID | ATTR_GID)) &&=0D=0A+=09    !famfs_opt_=
enabled(fsi, FAMFS_OPT_CHOWN))=0D=0A+=09=09return -EPERM;=0D=0A+=09if ((i=
attr->ia_valid & (ATTR_ATIME | ATTR_MTIME)) &&=0D=0A+=09    !famfs_opt_en=
abled(fsi, FAMFS_OPT_UTIMES))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09=
return simple_setattr(idmap, dentry, iattr);=0D=0A+}=0D=0A+=0D=0A+static =
const struct inode_operations famfs_file_inode_operations =3D {=0D=0A+=09=
/* All generic */=0D=0A+=09.setattr=09   =3D famfs_setattr,=0D=0A+=09.get=
attr=09   =3D simple_getattr,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Internal =
inode creation helper, shared by ->create, ->mkdir, ->mknod and=0D=0A+ * =
->symlink. Each of those callers is responsible for its own FAMFS_OPT_*=0D=
=0A+ * permission check before getting here.=0D=0A+ */=0D=0A+static int=0D=
=0A+famfs_mknod(struct mnt_idmap *idmap, struct inode *dir, struct dentry=
 *dentry,=0D=0A+=09    umode_t mode, dev_t dev)=0D=0A+{=0D=0A+=09struct f=
amfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=09struct timespec64 tv=
;=0D=0A+=09struct inode *inode;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=0A+=
=09=09return -ENODEV;=0D=0A+=0D=0A+=09inode =3D famfs_get_inode(dir->i_sb=
, dir, mode, dev);=0D=0A+=09if (!inode)=0D=0A+=09=09return -ENOSPC;=0D=0A=
+=0D=0A+=09d_make_persistent(dentry, inode);=0D=0A+=09tv =3D inode_set_ct=
ime_current(inode);=0D=0A+=09inode_set_mtime_to_ts(inode, tv);=0D=0A+=09i=
node_set_atime_to_ts(inode, tv);=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=
=0D=0A+static struct dentry *famfs_mkdir(struct mnt_idmap *idmap, struct =
inode *dir,=0D=0A+=09=09struct dentry *dentry, umode_t mode)=0D=0A+{=0D=0A=
+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=09int rc;=0D=
=0A+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return ERR_PTR(-ENODEV);=0D=0A=
+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_MKDIR))=0D=0A+=09=09return ERR_=
PTR(-EPERM);=0D=0A+=0D=0A+=09rc =3D famfs_mknod(&nop_mnt_idmap, dir, dent=
ry, mode | S_IFDIR, 0);=0D=0A+=09if (rc)=0D=0A+=09=09return ERR_PTR(rc);=0D=
=0A+=0D=0A+=09inc_nlink(dir);=0D=0A+=0D=0A+=09return ERR_PTR(0);=0D=0A+}=0D=
=0A+=0D=0A+static int famfs_create(struct mnt_idmap *idmap, struct inode =
*dir,=0D=0A+=09=09=09struct dentry *dentry, umode_t mode, bool excl)=0D=0A=
+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=
=0A+=09if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=09if (!famfs=
_opt_enabled(fsi, FAMFS_OPT_CREATE))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=
=0A+=09return famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0)=
;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_mknod_op(struct mnt_idmap *=
idmap, struct inode *dir,=0D=0A+=09       struct dentry *dentry, umode_t =
mode, dev_t dev)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb=
->s_fs_info;=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_MKNOD)=
)=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09return famfs_mknod(idmap, di=
r, dentry, mode, dev);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_symlin=
k(struct mnt_idmap *idmap, struct inode *dir,=0D=0A+=09      struct dentr=
y *dentry, const char *symname)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fs=
i =3D dir->i_sb->s_fs_info;=0D=0A+=09struct inode *inode;=0D=0A+=09int le=
n, rc;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A=
+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_SYMLINK))=0D=0A+=09=09return -E=
PERM;=0D=0A+=0D=0A+=09inode =3D famfs_get_inode(dir->i_sb, dir, S_IFLNK |=
 0777, 0);=0D=0A+=09if (!inode)=0D=0A+=09=09return -ENOSPC;=0D=0A+=0D=0A+=
=09len =3D strlen(symname) + 1;=0D=0A+=09rc =3D page_symlink(inode, symna=
me, len);=0D=0A+=09if (rc) {=0D=0A+=09=09iput(inode);=0D=0A+=09=09return =
rc;=0D=0A+=09}=0D=0A+=0D=0A+=09d_make_persistent(dentry, inode);=0D=0A+=09=
inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));=0D=0A+=0D=0A+=09=
return 0;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_link(struct dentry =
*old_dentry, struct inode *dir, struct dentry *dentry)=0D=0A+{=0D=0A+=09s=
truct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09if (!f=
amfs_opt_enabled(fsi, FAMFS_OPT_LINK))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=
=0A+=09return simple_link(old_dentry, dir, dentry);=0D=0A+}=0D=0A+=0D=0A+=
static int famfs_unlink(struct inode *dir, struct dentry *dentry)=0D=0A+{=
=0D=0A+=09struct inode *inode =3D d_inode(dentry);=0D=0A+=09struct famfs_=
fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09/* A file with an =
fmap may only be unlinked when explicitly enabled */=0D=0A+=09if (inode->=
i_private && !famfs_opt_enabled(fsi, FAMFS_OPT_UNLINK))=0D=0A+=09=09retur=
n -EPERM;=0D=0A+=0D=0A+=09return simple_unlink(dir, dentry);=0D=0A+}=0D=0A=
+=0D=0A+static int famfs_rmdir(struct inode *dir, struct dentry *dentry)=0D=
=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=
=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RMDIR))=0D=0A+=09=09retur=
n -EPERM;=0D=0A+=0D=0A+=09return simple_rmdir(dir, dentry);=0D=0A+}=0D=0A=
+=0D=0A+static int=0D=0A+famfs_rename(=0D=0A+=09struct mnt_idmap *idmap,=0D=
=0A+=09struct inode *old_dir,=0D=0A+=09struct dentry *old_dentry,=0D=0A+=09=
struct inode *new_dir,=0D=0A+=09struct dentry *new_dentry,=0D=0A+=09unsig=
ned int flags)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D old_dir->i_=
sb->s_fs_info;=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RENA=
ME))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09return simple_rename(idma=
p, old_dir, old_dentry, new_dir, new_dentry,=0D=0A+=09=09=09     flags);=0D=
=0A+}=0D=0A+=0D=0A+static const struct inode_operations famfs_dir_inode_o=
perations =3D {=0D=0A+=09.create=09=09=3D famfs_create,=0D=0A+=09.lookup=09=
=09=3D simple_lookup,=0D=0A+=09.link=09=09=3D famfs_link,=0D=0A+=09.unlin=
k=09=09=3D famfs_unlink,=0D=0A+=09.symlink=09=3D famfs_symlink,=0D=0A+=09=
=2Emkdir=09=09=3D famfs_mkdir,=0D=0A+=09.mknod=09=09=3D famfs_mknod_op,=0D=
=0A+=09.rmdir=09=09=3D famfs_rmdir,=0D=0A+=09.rename=09=09=3D famfs_renam=
e,=0D=0A+};=0D=0A+=0D=0A+/***********************************************=
******************************=0D=0A+ * famfs super_operations=0D=0A+ *=0D=
=0A+ * TODO: implement a famfs_statfs() that shows size, free and availab=
le space,=0D=0A+ * etc.=0D=0A+ */=0D=0A+=0D=0A+/*=0D=0A+ * famfs_show_opt=
ions() - Display the mount options in /proc/mounts.=0D=0A+ */=0D=0A+stati=
c int famfs_show_options(struct seq_file *m, struct dentry *root)=0D=0A+{=
=0D=0A+=09struct famfs_fs_info *fsi =3D root->d_sb->s_fs_info;=0D=0A+=0D=0A=
+=09if (fsi->mount_opts.mode !=3D FAMFS_DEFAULT_MODE)=0D=0A+=09=09seq_pri=
ntf(m, ",mode=3D%o", fsi->mount_opts.mode);=0D=0A+=0D=0A+=09return 0;=0D=0A=
+}=0D=0A+=0D=0A+static void famfs_evict_inode(struct inode *inode)=0D=0A+=
{=0D=0A+=09inode->i_private =3D NULL;=0D=0A+=09dax_break_layout_final(ino=
de);=0D=0A+=09truncate_inode_pages_final(&inode->i_data);=0D=0A+=09clear_=
inode(inode);=0D=0A+}=0D=0A+=0D=0A+static const struct super_operations f=
amfs_super_ops =3D {=0D=0A+=09.statfs=09=09=3D simple_statfs,=0D=0A+=09.d=
rop_inode=09=3D inode_just_drop,=0D=0A+=09.show_options=09=3D famfs_show_=
options,=0D=0A+=09.evict_inode    =3D famfs_evict_inode,=0D=0A+};=0D=0A+=0D=
=0A+/********************************************************************=
*********/=0D=0A+=0D=0A /*=0D=0A  * famfs dax_operations (for famfs-mode =
dax)=0D=0A  */=0D=0A@@ -305,7 +548,7 @@ famfs_fill_super(struct super_blo=
ck *sb, struct fs_context *fc)=0D=0A =09sb->s_blocksize=09=09=3D PAGE_SIZ=
E;=0D=0A =09sb->s_blocksize_bits=09=3D PAGE_SHIFT;=0D=0A =09sb->s_magic=09=
=09=3D FAMFS_SUPER_MAGIC;=0D=0A-=09sb->s_op=09=09=3D NULL /* famfs_super_=
ops */;=0D=0A+=09sb->s_op=09=09=3D &famfs_super_ops;=0D=0A =09sb->s_time_=
gran=09=09=3D 1;=0D=0A }=0D=0A=20=0D=0Adiff --git a/fs/famfs/famfs_intern=
al.h b/fs/famfs/famfs_internal.h=0D=0Aindex ebb9c499cf69..485087588a11 10=
0644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b/fs/famfs/famfs_inter=
nal.h=0D=0A@@ -70,6 +70,12 @@ struct famfs_fs_info {=0D=0A =09struct rw_s=
emaphore       devlist_sem;=0D=0A };=0D=0A=20=0D=0A+/* This stub will be =
replaced in a later commit=20=0D=0A+ * Note: the opt parameter is intenti=
onally unused, and will be used by=0D=0A+ * the replacement function when=
 that commit lands=0D=0A+ */=0D=0A+#define famfs_opt_enabled(fsi, opt) (f=
si !=3D 0)=0D=0A+=0D=0A int lookup_daxdev(const char *pathname, dev_t *de=
vno);=0D=0A int famfs_devlist_alloc(struct famfs_fs_info *fsi);=0D=0A int=
 famfs_install_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,=0D=
=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
