Received: from a11-6.smtp-out.amazonses.com (a11-6.smtp-out.amazonses.com [54.240.11.6])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF5397B02;
	Mon, 10 Aug 2026 20:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393491; cv=none; b=Re+nCH4EvSo11i/dink3QULYm5VCIhd2/PKo9r+0NEgFBTu1qxJaAEJjoVlzIpuL9dy3R5GHcu9FRho1N5PndeVV3C0hP5CR8x3i/uJw92lV0axM4foh2lI/TRLjNQR0K0L1aPKvf1dcGYHyi9XPsVygcV0kLr38xu834VF7MMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393491; c=relaxed/simple;
	bh=jhD/rnHLu4JAdll/CWVojBQDzu1Qq8cYP1Gu0r2Z7f8=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=sonk8x5t41fiYkpPubATUye1tIAb2nS9yzDxl6DzbkU23nEYgQNQlqD1dfQtcvPE7rB9jY3WliN9oaOWgNEQf7w0dQrnhwslOHI0q0JhQX+aE+2m/eeT1kDHutyKvL1W3H/7R3Y48WMZe5+rFZakCATBJC/qDRXJTYOL4ECeOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=IJgOMk5F; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=V6K8Pz/A; arc=none smtp.client-ip=54.240.11.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="IJgOMk5F";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="V6K8Pz/A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393488;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=jhD/rnHLu4JAdll/CWVojBQDzu1Qq8cYP1Gu0r2Z7f8=;
	b=IJgOMk5Fq4KaA+0bNkyqWQyZYqt2VYNVe5HUwq2YVdELyxtQX8CjK291Mq3HCs72
	Jv4j5y8jxfaFLnGiP3EBm/i/jIuz+tmbCNowLSXGrYGH+ni6zn2YcfNDapJlSmR2fab
	lK6+fspILkag6gG6s/XyV561ULRz8+xACysmxK4Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393488;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=jhD/rnHLu4JAdll/CWVojBQDzu1Qq8cYP1Gu0r2Z7f8=;
	b=V6K8Pz/AZjc22LJJNHM4Qk+K412nO+jlxjgfoyPx8ZxDppAx3FfgpQ5xkXwtHbFE
	J+cP2TfwaC3X9FM6vAKsbNbotEgADOTpT1Oh0MH04FiXqXzDeJRVZqxgyyRVUlJup7f
	WyTSYJLZCNkwbmXOUTyGXCUeF2tq/jRVNc0ftawI=
Subject: [PATCH v13 04/12] famfs: Introduce inode_operations and
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
Date: Mon, 10 Aug 2026 20:24:48 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
References: 
 <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com> 
 <20260810202440.96280-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAACwSq
Thread-Topic: [PATCH v13 04/12] famfs: Introduce inode_operations and
 super_operations
X-Wm-Sent-Timestamp: 1786393486
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed596b17-7d05bea5-52b4-4cf9-ac49-b687a0368a3e-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.6

From: John Groves <john@groves.net>=0D=0A=0D=0AThe famfs inode and super =
operations are generic other than=0D=0Ashow_options, evict_inode and seta=
ttr (which prevents truncation..=0D=0A=0D=0AThis commit builds but is sti=
ll too incomplete to run=0D=0A=0D=0ASigned-off-by: John Groves <john@grov=
es.net>=0D=0A---=0D=0Av13:=0D=0A - famfs_rename(): gate a rename that rep=
laces an existing target by the same=0D=0A   FAMFS_OPT_UNLINK / FAMFS_OPT=
_RMDIR policy that unlink()/rmdir() enforce.=0D=0A   Previously simple_re=
name() removed the target (a mapped file, or a=0D=0A   directory) with on=
ly the FAMFS_OPT_RENAME check, bypassing those gates=0D=0A   (Sashiko bot=
).=0D=0A - famfs_mknod(): bump the parent directory's mtime/ctime when an=
 entry is=0D=0A   created (create/mkdir/mknod) instead of re-setting the =
new child inode's=0D=0A   timestamps; matches famfs_symlink() and POSIX (=
Sashiko bot).=0D=0A=0D=0A fs/famfs/famfs_inode.c    | 289 +++++++++++++++=
++++++++++++++++++++++-=0D=0A fs/famfs/famfs_internal.h |   6 +=0D=0A 2 f=
iles changed, 292 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/f=
s/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 5735d8d1900b..b=
7a3d8d6ee8c 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/=
famfs_inode.c=0D=0A@@ -29,6 +29,9 @@=0D=0A=20=0D=0A #define FAMFS_DEFAULT=
_MODE=090755=0D=0A=20=0D=0A+static const struct inode_operations famfs_fi=
le_inode_operations;=0D=0A+static const struct inode_operations famfs_dir=
_inode_operations;=0D=0A+=0D=0A static struct inode *=0D=0A famfs_get_ino=
de(=0D=0A =09struct super_block *sb,=0D=0A@@ -55,11 +58,11 @@ famfs_get_i=
node(=0D=0A =09=09init_special_inode(inode, mode, dev);=0D=0A =09=09break=
;=0D=0A =09case S_IFREG:=0D=0A-=09=09inode->i_op =3D NULL /* famfs_file_i=
node_operations */;=0D=0A+=09=09inode->i_op =3D &famfs_file_inode_operati=
ons;=0D=0A =09=09inode->i_fop =3D NULL /* &famfs_file_operations */;=0D=0A=
 =09=09break;=0D=0A =09case S_IFDIR:=0D=0A-=09=09inode->i_op =3D NULL /* =
famfs_dir_inode_operations */;=0D=0A+=09=09inode->i_op =3D &famfs_dir_ino=
de_operations;=0D=0A =09=09inode->i_fop =3D &simple_dir_operations;=0D=0A=
=20=0D=0A =09=09/* Directory inodes start off with i_nlink =3D=3D 2 (for =
".") */=0D=0A@@ -73,6 +76,286 @@ famfs_get_inode(=0D=0A =09return inode;=0D=
=0A }=0D=0A=20=0D=0A+/***************************************************=
************************=0D=0A+ * famfs inode_operations=0D=0A+ */=0D=0A+=
=0D=0A+static int=0D=0A+famfs_setattr(=0D=0A+=09struct mnt_idmap *idmap,=0D=
=0A+=09struct dentry *dentry,=0D=0A+=09struct iattr *iattr)=0D=0A+{=0D=0A=
+=09struct inode *inode =3D d_inode(dentry);=0D=0A+=09struct famfs_fs_inf=
o *fsi =3D inode->i_sb->s_fs_info;=0D=0A+=0D=0A+=09/* Resizing a famfs fi=
le (its size is pinned to the fmap) */=0D=0A+=09if ((iattr->ia_valid & AT=
TR_SIZE) &&=0D=0A+=09    !famfs_opt_enabled(fsi, FAMFS_OPT_TRUNCATE) &&=0D=
=0A+=09    iattr->ia_size !=3D i_size_read(inode))=0D=0A+=09=09return -EP=
ERM;=0D=0A+=09if ((iattr->ia_valid & ATTR_MODE) &&=0D=0A+=09    !famfs_op=
t_enabled(fsi, FAMFS_OPT_CHMOD))=0D=0A+=09=09return -EPERM;=0D=0A+=09if (=
(iattr->ia_valid & (ATTR_UID | ATTR_GID)) &&=0D=0A+=09    !famfs_opt_enab=
led(fsi, FAMFS_OPT_CHOWN))=0D=0A+=09=09return -EPERM;=0D=0A+=09if ((iattr=
->ia_valid & (ATTR_ATIME | ATTR_MTIME)) &&=0D=0A+=09    !famfs_opt_enable=
d(fsi, FAMFS_OPT_UTIMES))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09retu=
rn simple_setattr(idmap, dentry, iattr);=0D=0A+}=0D=0A+=0D=0A+static cons=
t struct inode_operations famfs_file_inode_operations =3D {=0D=0A+=09/* A=
ll generic */=0D=0A+=09.setattr=09   =3D famfs_setattr,=0D=0A+=09.getattr=
=09   =3D simple_getattr,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Internal inod=
e creation helper, shared by ->create, ->mkdir, ->mknod and=0D=0A+ * ->sy=
mlink. Each of those callers is responsible for its own FAMFS_OPT_*=0D=0A=
+ * permission check before getting here.=0D=0A+ */=0D=0A+static int=0D=0A=
+famfs_mknod(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=09struct inode *di=
r,=0D=0A+=09struct dentry *dentry,=0D=0A+=09umode_t mode,=0D=0A+=09dev_t =
dev)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=
=0D=0A+=09struct inode *inode;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=
=09return -ENODEV;=0D=0A+=0D=0A+=09inode =3D famfs_get_inode(dir->i_sb, d=
ir, mode, dev);=0D=0A+=09if (!inode)=0D=0A+=09=09return -ENOSPC;=0D=0A+=0D=
=0A+=09d_make_persistent(dentry, inode);=0D=0A+=09/* Adding an entry upda=
tes the parent directory's mtime/ctime */=0D=0A+=09inode_set_mtime_to_ts(=
dir, inode_set_ctime_current(dir));=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A=
+=0D=0A+static struct dentry *=0D=0A+famfs_mkdir(=0D=0A+=09struct mnt_idm=
ap *idmap,=0D=0A+=09struct inode *dir,=0D=0A+=09struct dentry *dentry,=0D=
=0A+=09umode_t mode)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->=
i_sb->s_fs_info;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=0A=
+=09=09return ERR_PTR(-ENODEV);=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMF=
S_OPT_MKDIR))=0D=0A+=09=09return ERR_PTR(-EPERM);=0D=0A+=0D=0A+=09rc =3D =
famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFDIR, 0);=0D=0A+=09if =
(rc)=0D=0A+=09=09return ERR_PTR(rc);=0D=0A+=0D=0A+=09inc_nlink(dir);=0D=0A=
+=0D=0A+=09return ERR_PTR(0);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs=
_create(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=09struct inode *dir,=0D=
=0A+=09struct dentry *dentry,=0D=0A+=09umode_t mode,=0D=0A+=09bool excl)=0D=
=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=
=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=09if (!fa=
mfs_opt_enabled(fsi, FAMFS_OPT_CREATE))=0D=0A+=09=09return -EPERM;=0D=0A+=
=0D=0A+=09return famfs_mknod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG,=
 0);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_mknod_op(=0D=0A+=09struc=
t mnt_idmap *idmap,=0D=0A+=09struct inode *dir,=0D=0A+=09struct dentry *d=
entry,=0D=0A+=09umode_t mode,=0D=0A+=09dev_t dev)=0D=0A+{=0D=0A+=09struct=
 famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09if (!famfs_=
opt_enabled(fsi, FAMFS_OPT_MKNOD))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A=
+=09return famfs_mknod(idmap, dir, dentry, mode, dev);=0D=0A+}=0D=0A+=0D=0A=
+static int=0D=0A+famfs_symlink(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=
=09struct inode *dir,=0D=0A+=09struct dentry *dentry,=0D=0A+=09const char=
 *symname)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs=
_info;=0D=0A+=09struct inode *inode;=0D=0A+=09int len, rc;=0D=0A+=0D=0A+=09=
if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=09if (!famfs_opt_en=
abled(fsi, FAMFS_OPT_SYMLINK))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09=
inode =3D famfs_get_inode(dir->i_sb, dir, S_IFLNK | 0777, 0);=0D=0A+=09if=
 (!inode)=0D=0A+=09=09return -ENOSPC;=0D=0A+=0D=0A+=09len =3D strlen(symn=
ame) + 1;=0D=0A+=09rc =3D page_symlink(inode, symname, len);=0D=0A+=09if =
(rc) {=0D=0A+=09=09iput(inode);=0D=0A+=09=09return rc;=0D=0A+=09}=0D=0A+=0D=
=0A+=09d_make_persistent(dentry, inode);=0D=0A+=09inode_set_mtime_to_ts(d=
ir, inode_set_ctime_current(dir));=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A=
+=0D=0A+static int=0D=0A+famfs_link(=0D=0A+=09struct dentry *old_dentry,=0D=
=0A+=09struct inode *dir,=0D=0A+=09struct dentry *dentry)=0D=0A+{=0D=0A+=09=
struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09if (!=
famfs_opt_enabled(fsi, FAMFS_OPT_LINK))=0D=0A+=09=09return -EPERM;=0D=0A+=
=0D=0A+=09return simple_link(old_dentry, dir, dentry);=0D=0A+}=0D=0A+=0D=0A=
+static int=0D=0A+famfs_unlink(struct inode *dir, struct dentry *dentry)=0D=
=0A+{=0D=0A+=09struct inode *inode =3D d_inode(dentry);=0D=0A+=09struct f=
amfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09/* A file wit=
h an fmap may only be unlinked when explicitly enabled */=0D=0A+=09if (in=
ode->i_private && !famfs_opt_enabled(fsi, FAMFS_OPT_UNLINK))=0D=0A+=09=09=
return -EPERM;=0D=0A+=0D=0A+=09return simple_unlink(dir, dentry);=0D=0A+}=
=0D=0A+=0D=0A+static int famfs_rmdir(struct inode *dir, struct dentry *de=
ntry)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info=
;=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RMDIR))=0D=0A+=09=
=09return -EPERM;=0D=0A+=0D=0A+=09return simple_rmdir(dir, dentry);=0D=0A=
+}=0D=0A+=0D=0A+static int=0D=0A+famfs_rename(=0D=0A+=09struct mnt_idmap =
*idmap,=0D=0A+=09struct inode *old_dir,=0D=0A+=09struct dentry *old_dentr=
y,=0D=0A+=09struct inode *new_dir,=0D=0A+=09struct dentry *new_dentry,=0D=
=0A+=09unsigned int flags)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D=
 old_dir->i_sb->s_fs_info;=0D=0A+=09struct inode *target =3D d_inode(new_=
dentry);=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RENAME))=0D=
=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Renaming over an =
existing target removes it, so require the same=0D=0A+=09 * policy gate t=
hat unlink()/rmdir() would. RENAME_EXCHANGE swaps the=0D=0A+=09 * two ent=
ries rather than removing the target, so it is exempt.=0D=0A+=09 */=0D=0A=
+=09if (target && !(flags & RENAME_EXCHANGE)) {=0D=0A+=09=09if (S_ISDIR(t=
arget->i_mode)) {=0D=0A+=09=09=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RM=
DIR))=0D=0A+=09=09=09=09return -EPERM;=0D=0A+=09=09} else if (target->i_p=
rivate &&=0D=0A+=09=09=09   !famfs_opt_enabled(fsi, FAMFS_OPT_UNLINK)) {=0D=
=0A+=09=09=09return -EPERM;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09retu=
rn simple_rename(idmap, old_dir, old_dentry, new_dir, new_dentry,=0D=0A+=09=
=09=09     flags);=0D=0A+}=0D=0A+=0D=0A+static const struct inode_operati=
ons famfs_dir_inode_operations =3D {=0D=0A+=09.create=09=09=3D famfs_crea=
te,=0D=0A+=09.lookup=09=09=3D simple_lookup,=0D=0A+=09.link=09=09=3D famf=
s_link,=0D=0A+=09.unlink=09=09=3D famfs_unlink,=0D=0A+=09.symlink=09=3D f=
amfs_symlink,=0D=0A+=09.mkdir=09=09=3D famfs_mkdir,=0D=0A+=09.mknod=09=09=
=3D famfs_mknod_op,=0D=0A+=09.rmdir=09=09=3D famfs_rmdir,=0D=0A+=09.renam=
e=09=09=3D famfs_rename,=0D=0A+};=0D=0A+=0D=0A+/*************************=
****************************************************=0D=0A+ * famfs super=
_operations=0D=0A+ *=0D=0A+ * TODO: implement a famfs_statfs() that shows=
 size, free and available space,=0D=0A+ * etc.=0D=0A+ */=0D=0A+=0D=0A+/*=0D=
=0A+ * famfs_show_options() - Display the mount options in /proc/mounts.=0D=
=0A+ */=0D=0A+static int=0D=0A+famfs_show_options(struct seq_file *m, str=
uct dentry *root)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D root->d_=
sb->s_fs_info;=0D=0A+=0D=0A+=09if (fsi->mount_opts.mode !=3D FAMFS_DEFAUL=
T_MODE)=0D=0A+=09=09seq_printf(m, ",mode=3D%o", fsi->mount_opts.mode);=0D=
=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A+famfs_evic=
t_inode(struct inode *inode)=0D=0A+{=0D=0A+=09inode->i_private =3D NULL;=0D=
=0A+=09dax_break_layout_final(inode);=0D=0A+=09truncate_inode_pages_final=
(&inode->i_data);=0D=0A+=09clear_inode(inode);=0D=0A+}=0D=0A+=0D=0A+stati=
c const struct super_operations famfs_super_ops =3D {=0D=0A+=09.statfs=09=
=09=3D simple_statfs,=0D=0A+=09.drop_inode=09=3D inode_just_drop,=0D=0A+=09=
=2Eshow_options=09=3D famfs_show_options,=0D=0A+=09.evict_inode    =3D fa=
mfs_evict_inode,=0D=0A+};=0D=0A+=0D=0A+/*********************************=
********************************************/=0D=0A+=0D=0A /*=0D=0A  * fa=
mfs dax_operations (for famfs-mode dax)=0D=0A  */=0D=0A@@ -312,7 +595,7 @=
@ famfs_fill_super(struct super_block *sb, struct fs_context *fc)=0D=0A =09=
sb->s_blocksize=09=09=3D PAGE_SIZE;=0D=0A =09sb->s_blocksize_bits=09=3D P=
AGE_SHIFT;=0D=0A =09sb->s_magic=09=09=3D FAMFS_SUPER_MAGIC;=0D=0A-=09sb->=
s_op=09=09=3D NULL /* famfs_super_ops */;=0D=0A+=09sb->s_op=09=09=3D &fam=
fs_super_ops;=0D=0A =09sb->s_time_gran=09=09=3D 1;=0D=0A }=0D=0A=20=0D=0A=
diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Ai=
ndex 37f667b2b79a..30f0b01010d5 100644=0D=0A--- a/fs/famfs/famfs_internal=
=2Eh=0D=0A+++ b/fs/famfs/famfs_internal.h=0D=0A@@ -70,6 +70,12 @@ struct =
famfs_fs_info {=0D=0A =09struct rw_semaphore       devlist_sem;=0D=0A };=0D=
=0A=20=0D=0A+/* This stub will be replaced in a later commit=0D=0A+ * Not=
e: the opt parameter is intentionally unused, and will be used by=0D=0A+ =
* the replacement function when that commit lands=0D=0A+ */=0D=0A+#define=
 famfs_opt_enabled(fsi, opt) (fsi !=3D 0)=0D=0A+=0D=0A int famfs_lookup_d=
axdev(const char *pathname, dev_t *devno);=0D=0A int famfs_devlist_alloc(=
struct famfs_fs_info *fsi);=0D=0A int famfs_install_daxdev(struct famfs_f=
s_info *fsi, struct super_block *sb,=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
