Received: from a11-6.smtp-out.amazonses.com (a11-6.smtp-out.amazonses.com [54.240.11.6])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CDD21A434;
	Sat, 29 Aug 2026 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023493; cv=none; b=VRDVbfOWJCOGxiJHm6ioDi8a/NJJAvkzn8+kvGObMXgKI8jmgeVbw4U9fViRhQCNrnftklPhJf+yd8iVI1BZYClooEtQlj0JGPcDZCehas9X8MbmApbfiQhGDyGH31kLb0RU5nStCMhmj9K3rQnQQVRixshyPW82NfDt5seFZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023493; c=relaxed/simple;
	bh=qOHa7W+cQx4P3O5NPB6FOKhbasld/d8G3/e9dZcKbCs=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Br1BBhBbR0fzj5uvNAo9ryjsXTyGgzWnK4tnQA2SpUsGTXPGfzAOcHsbpL/5+eNEaRxqGVYEqaAEqDf+Q7zMncKuJ/lWLyUG6u4bFpMpO9xKlDrP7CRy0wfLx16xpg8687O2QfNVGtFV7HRAioEp7+StlZH1YBMXwKn+cpb4ICQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=h8lK2xls; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=h6udmjRq; arc=none smtp.client-ip=54.240.11.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="h8lK2xls";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="h6udmjRq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023482;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=qOHa7W+cQx4P3O5NPB6FOKhbasld/d8G3/e9dZcKbCs=;
	b=h8lK2xlszHjLOnIc/Cvt/5X0sq/GvWOHps2B46TEIDXLhQJUwzSD7yvrQCoMga5X
	mxgrwXZdy+LZU+mooBSJlwiRFnGuSUFVe8EP4bxpBLHgi+CpUSIQLqaSs4FXd2n25Ub
	BpQcXNhf8sZSr24MCXM6iUiKIPkcILcf16yzM0fY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023482;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=qOHa7W+cQx4P3O5NPB6FOKhbasld/d8G3/e9dZcKbCs=;
	b=h6udmjRqn49yys9eLvH0OeHcThoQShiU/ATTkp8yfsa/svCJJWVhP+yll5O/eN0J
	XofSWYik72dy3zZqWhPWPjy7IHgAtAPReGjSX5SfQJxtTnWb0qD8gt2/dqjpB7CkIW4
	1RVXWR4tBcLUVlrAiXSQQ2EHAvnz4aFbJTHx2XQY=
Subject: [PATCH V14 04/12] famfs: Introduce inode_operations and
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
Date: Sat, 29 Aug 2026 17:11:22 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com>
References: 
 <010001a04e801a4e-8eb212cd-b263-4043-ab65-33e480d2d7d4-000000@email.amazonses.com> 
 <20260829171114.7409-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAACkhI
Thread-Topic: [PATCH V14 04/12] famfs: Introduce inode_operations and
 super_operations
X-Wm-Sent-Timestamp: 1788023481
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e81289e-047de24d-e6c8-4a14-8f25-1cc2249072b2-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.6

From: John Groves <john@groves.net>=0D=0A=0D=0AThe famfs inode and super =
operations are generic other than=0D=0Ashow_options, evict_inode and seta=
ttr (which prevents truncation..=0D=0A=0D=0AThis commit builds but is sti=
ll too incomplete to run=0D=0A=0D=0AReviewed-by: "Darrick J. Wong" <djwon=
g@kernel.org>=0D=0AReviewed-by: Jeff Layton <jlayton@kernel.org>=0D=0ASig=
ned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=0D=0A fs/famfs/f=
amfs_inode.c    | 289 +++++++++++++++++++++++++++++++++++++-=0D=0A fs/fam=
fs/famfs_internal.h |   6 +=0D=0A 2 files changed, 292 insertions(+), 3 d=
eletions(-)=0D=0A=0D=0Adiff --git a/fs/famfs/famfs_inode.c b/fs/famfs/fam=
fs_inode.c=0D=0Aindex 5735d8d1900b..b7a3d8d6ee8c 100644=0D=0A--- a/fs/fam=
fs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_inode.c=0D=0A@@ -29,6 +29,9 @@=
=0D=0A=20=0D=0A #define FAMFS_DEFAULT_MODE=090755=0D=0A=20=0D=0A+static c=
onst struct inode_operations famfs_file_inode_operations;=0D=0A+static co=
nst struct inode_operations famfs_dir_inode_operations;=0D=0A+=0D=0A stat=
ic struct inode *=0D=0A famfs_get_inode(=0D=0A =09struct super_block *sb,=
=0D=0A@@ -55,11 +58,11 @@ famfs_get_inode(=0D=0A =09=09init_special_inode=
(inode, mode, dev);=0D=0A =09=09break;=0D=0A =09case S_IFREG:=0D=0A-=09=09=
inode->i_op =3D NULL /* famfs_file_inode_operations */;=0D=0A+=09=09inode=
->i_op =3D &famfs_file_inode_operations;=0D=0A =09=09inode->i_fop =3D NUL=
L /* &famfs_file_operations */;=0D=0A =09=09break;=0D=0A =09case S_IFDIR:=
=0D=0A-=09=09inode->i_op =3D NULL /* famfs_dir_inode_operations */;=0D=0A=
+=09=09inode->i_op =3D &famfs_dir_inode_operations;=0D=0A =09=09inode->i_=
fop =3D &simple_dir_operations;=0D=0A=20=0D=0A =09=09/* Directory inodes =
start off with i_nlink =3D=3D 2 (for ".") */=0D=0A@@ -73,6 +76,286 @@ fam=
fs_get_inode(=0D=0A =09return inode;=0D=0A }=0D=0A=20=0D=0A+/************=
***************************************************************=0D=0A+ * =
famfs inode_operations=0D=0A+ */=0D=0A+=0D=0A+static int=0D=0A+famfs_seta=
ttr(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=09struct dentry *dentry,=0D=
=0A+=09struct iattr *iattr)=0D=0A+{=0D=0A+=09struct inode *inode =3D d_in=
ode(dentry);=0D=0A+=09struct famfs_fs_info *fsi =3D inode->i_sb->s_fs_inf=
o;=0D=0A+=0D=0A+=09/* Resizing a famfs file (its size is pinned to the fm=
ap) */=0D=0A+=09if ((iattr->ia_valid & ATTR_SIZE) &&=0D=0A+=09    !famfs_=
opt_enabled(fsi, FAMFS_OPT_TRUNCATE) &&=0D=0A+=09    iattr->ia_size !=3D =
i_size_read(inode))=0D=0A+=09=09return -EPERM;=0D=0A+=09if ((iattr->ia_va=
lid & ATTR_MODE) &&=0D=0A+=09    !famfs_opt_enabled(fsi, FAMFS_OPT_CHMOD)=
)=0D=0A+=09=09return -EPERM;=0D=0A+=09if ((iattr->ia_valid & (ATTR_UID | =
ATTR_GID)) &&=0D=0A+=09    !famfs_opt_enabled(fsi, FAMFS_OPT_CHOWN))=0D=0A=
+=09=09return -EPERM;=0D=0A+=09if ((iattr->ia_valid & (ATTR_ATIME | ATTR_=
MTIME)) &&=0D=0A+=09    !famfs_opt_enabled(fsi, FAMFS_OPT_UTIMES))=0D=0A+=
=09=09return -EPERM;=0D=0A+=0D=0A+=09return simple_setattr(idmap, dentry,=
 iattr);=0D=0A+}=0D=0A+=0D=0A+static const struct inode_operations famfs_=
file_inode_operations =3D {=0D=0A+=09/* All generic */=0D=0A+=09.setattr=09=
   =3D famfs_setattr,=0D=0A+=09.getattr=09   =3D simple_getattr,=0D=0A+};=
=0D=0A+=0D=0A+/*=0D=0A+ * Internal inode creation helper, shared by ->cre=
ate, ->mkdir, ->mknod and=0D=0A+ * ->symlink. Each of those callers is re=
sponsible for its own FAMFS_OPT_*=0D=0A+ * permission check before gettin=
g here.=0D=0A+ */=0D=0A+static int=0D=0A+famfs_mknod(=0D=0A+=09struct mnt=
_idmap *idmap,=0D=0A+=09struct inode *dir,=0D=0A+=09struct dentry *dentry=
,=0D=0A+=09umode_t mode,=0D=0A+=09dev_t dev)=0D=0A+{=0D=0A+=09struct famf=
s_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=09struct inode *inode;=0D=
=0A+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=0D=0A=
+=09inode =3D famfs_get_inode(dir->i_sb, dir, mode, dev);=0D=0A+=09if (!i=
node)=0D=0A+=09=09return -ENOSPC;=0D=0A+=0D=0A+=09d_make_persistent(dentr=
y, inode);=0D=0A+=09/* Adding an entry updates the parent directory's mti=
me/ctime */=0D=0A+=09inode_set_mtime_to_ts(dir, inode_set_ctime_current(d=
ir));=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static struct dentry=
 *=0D=0A+famfs_mkdir(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=09struct i=
node *dir,=0D=0A+=09struct dentry *dentry,=0D=0A+=09umode_t mode)=0D=0A+{=
=0D=0A+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=09in=
t rc;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return ERR_PTR(-ENOD=
EV);=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_MKDIR))=0D=0A+=09=09r=
eturn ERR_PTR(-EPERM);=0D=0A+=0D=0A+=09rc =3D famfs_mknod(&nop_mnt_idmap,=
 dir, dentry, mode | S_IFDIR, 0);=0D=0A+=09if (rc)=0D=0A+=09=09return ERR=
_PTR(rc);=0D=0A+=0D=0A+=09inc_nlink(dir);=0D=0A+=0D=0A+=09return ERR_PTR(=
0);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_create(=0D=0A+=09struct m=
nt_idmap *idmap,=0D=0A+=09struct inode *dir,=0D=0A+=09struct dentry *dent=
ry,=0D=0A+=09umode_t mode,=0D=0A+=09bool excl)=0D=0A+{=0D=0A+=09struct fa=
mfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09if (fsi->dever=
ror)=0D=0A+=09=09return -ENODEV;=0D=0A+=09if (!famfs_opt_enabled(fsi, FAM=
FS_OPT_CREATE))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09return famfs_m=
knod(&nop_mnt_idmap, dir, dentry, mode | S_IFREG, 0);=0D=0A+}=0D=0A+=0D=0A=
+static int=0D=0A+famfs_mknod_op(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A=
+=09struct inode *dir,=0D=0A+=09struct dentry *dentry,=0D=0A+=09umode_t m=
ode,=0D=0A+=09dev_t dev)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D d=
ir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OP=
T_MKNOD))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09return famfs_mknod(i=
dmap, dir, dentry, mode, dev);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famf=
s_symlink(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=09struct inode *dir,=0D=
=0A+=09struct dentry *dentry,=0D=0A+=09const char *symname)=0D=0A+{=0D=0A=
+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=09struct i=
node *inode;=0D=0A+=09int len, rc;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=0A=
+=09=09return -ENODEV;=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_SYM=
LINK))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09inode =3D famfs_get_ino=
de(dir->i_sb, dir, S_IFLNK | 0777, 0);=0D=0A+=09if (!inode)=0D=0A+=09=09r=
eturn -ENOSPC;=0D=0A+=0D=0A+=09len =3D strlen(symname) + 1;=0D=0A+=09rc =3D=
 page_symlink(inode, symname, len);=0D=0A+=09if (rc) {=0D=0A+=09=09iput(i=
node);=0D=0A+=09=09return rc;=0D=0A+=09}=0D=0A+=0D=0A+=09d_make_persisten=
t(dentry, inode);=0D=0A+=09inode_set_mtime_to_ts(dir, inode_set_ctime_cur=
rent(dir));=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A=
+famfs_link(=0D=0A+=09struct dentry *old_dentry,=0D=0A+=09struct inode *d=
ir,=0D=0A+=09struct dentry *dentry)=0D=0A+{=0D=0A+=09struct famfs_fs_info=
 *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09if (!famfs_opt_enabled(fs=
i, FAMFS_OPT_LINK))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09return sim=
ple_link(old_dentry, dir, dentry);=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+=
famfs_unlink(struct inode *dir, struct dentry *dentry)=0D=0A+{=0D=0A+=09s=
truct inode *inode =3D d_inode(dentry);=0D=0A+=09struct famfs_fs_info *fs=
i =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09/* A file with an fmap may on=
ly be unlinked when explicitly enabled */=0D=0A+=09if (inode->i_private &=
& !famfs_opt_enabled(fsi, FAMFS_OPT_UNLINK))=0D=0A+=09=09return -EPERM;=0D=
=0A+=0D=0A+=09return simple_unlink(dir, dentry);=0D=0A+}=0D=0A+=0D=0A+sta=
tic int famfs_rmdir(struct inode *dir, struct dentry *dentry)=0D=0A+{=0D=0A=
+=09struct famfs_fs_info *fsi =3D dir->i_sb->s_fs_info;=0D=0A+=0D=0A+=09i=
f (!famfs_opt_enabled(fsi, FAMFS_OPT_RMDIR))=0D=0A+=09=09return -EPERM;=0D=
=0A+=0D=0A+=09return simple_rmdir(dir, dentry);=0D=0A+}=0D=0A+=0D=0A+stat=
ic int=0D=0A+famfs_rename(=0D=0A+=09struct mnt_idmap *idmap,=0D=0A+=09str=
uct inode *old_dir,=0D=0A+=09struct dentry *old_dentry,=0D=0A+=09struct i=
node *new_dir,=0D=0A+=09struct dentry *new_dentry,=0D=0A+=09unsigned int =
flags)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D old_dir->i_sb->s_fs=
_info;=0D=0A+=09struct inode *target =3D d_inode(new_dentry);=0D=0A+=0D=0A=
+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RENAME))=0D=0A+=09=09return -EP=
ERM;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Renaming over an existing target remo=
ves it, so require the same=0D=0A+=09 * policy gate that unlink()/rmdir()=
 would. RENAME_EXCHANGE swaps the=0D=0A+=09 * two entries rather than rem=
oving the target, so it is exempt.=0D=0A+=09 */=0D=0A+=09if (target && !(=
flags & RENAME_EXCHANGE)) {=0D=0A+=09=09if (S_ISDIR(target->i_mode)) {=0D=
=0A+=09=09=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_RMDIR))=0D=0A+=09=09=09=
=09return -EPERM;=0D=0A+=09=09} else if (target->i_private &&=0D=0A+=09=09=
=09   !famfs_opt_enabled(fsi, FAMFS_OPT_UNLINK)) {=0D=0A+=09=09=09return =
-EPERM;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09return simple_rename(idm=
ap, old_dir, old_dentry, new_dir, new_dentry,=0D=0A+=09=09=09     flags);=
=0D=0A+}=0D=0A+=0D=0A+static const struct inode_operations famfs_dir_inod=
e_operations =3D {=0D=0A+=09.create=09=09=3D famfs_create,=0D=0A+=09.look=
up=09=09=3D simple_lookup,=0D=0A+=09.link=09=09=3D famfs_link,=0D=0A+=09.=
unlink=09=09=3D famfs_unlink,=0D=0A+=09.symlink=09=3D famfs_symlink,=0D=0A=
+=09.mkdir=09=09=3D famfs_mkdir,=0D=0A+=09.mknod=09=09=3D famfs_mknod_op,=
=0D=0A+=09.rmdir=09=09=3D famfs_rmdir,=0D=0A+=09.rename=09=09=3D famfs_re=
name,=0D=0A+};=0D=0A+=0D=0A+/********************************************=
*********************************=0D=0A+ * famfs super_operations=0D=0A+ =
*=0D=0A+ * TODO: implement a famfs_statfs() that shows size, free and ava=
ilable space,=0D=0A+ * etc.=0D=0A+ */=0D=0A+=0D=0A+/*=0D=0A+ * famfs_show=
_options() - Display the mount options in /proc/mounts.=0D=0A+ */=0D=0A+s=
tatic int=0D=0A+famfs_show_options(struct seq_file *m, struct dentry *roo=
t)=0D=0A+{=0D=0A+=09struct famfs_fs_info *fsi =3D root->d_sb->s_fs_info;=0D=
=0A+=0D=0A+=09if (fsi->mount_opts.mode !=3D FAMFS_DEFAULT_MODE)=0D=0A+=09=
=09seq_printf(m, ",mode=3D%o", fsi->mount_opts.mode);=0D=0A+=0D=0A+=09ret=
urn 0;=0D=0A+}=0D=0A+=0D=0A+static void=0D=0A+famfs_evict_inode(struct in=
ode *inode)=0D=0A+{=0D=0A+=09inode->i_private =3D NULL;=0D=0A+=09dax_brea=
k_layout_final(inode);=0D=0A+=09truncate_inode_pages_final(&inode->i_data=
);=0D=0A+=09clear_inode(inode);=0D=0A+}=0D=0A+=0D=0A+static const struct =
super_operations famfs_super_ops =3D {=0D=0A+=09.statfs=09=09=3D simple_s=
tatfs,=0D=0A+=09.drop_inode=09=3D inode_just_drop,=0D=0A+=09.show_options=
=09=3D famfs_show_options,=0D=0A+=09.evict_inode    =3D famfs_evict_inode=
,=0D=0A+};=0D=0A+=0D=0A+/************************************************=
*****************************/=0D=0A+=0D=0A /*=0D=0A  * famfs dax_operati=
ons (for famfs-mode dax)=0D=0A  */=0D=0A@@ -312,7 +595,7 @@ famfs_fill_su=
per(struct super_block *sb, struct fs_context *fc)=0D=0A =09sb->s_blocksi=
ze=09=09=3D PAGE_SIZE;=0D=0A =09sb->s_blocksize_bits=09=3D PAGE_SHIFT;=0D=
=0A =09sb->s_magic=09=09=3D FAMFS_SUPER_MAGIC;=0D=0A-=09sb->s_op=09=09=3D=
 NULL /* famfs_super_ops */;=0D=0A+=09sb->s_op=09=09=3D &famfs_super_ops;=
=0D=0A =09sb->s_time_gran=09=09=3D 1;=0D=0A }=0D=0A=20=0D=0Adiff --git a/=
fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Aindex 37f667b2=
b79a..30f0b01010d5 100644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b=
/fs/famfs/famfs_internal.h=0D=0A@@ -70,6 +70,12 @@ struct famfs_fs_info {=
=0D=0A =09struct rw_semaphore       devlist_sem;=0D=0A };=0D=0A=20=0D=0A+=
/* This stub will be replaced in a later commit=0D=0A+ * Note: the opt pa=
rameter is intentionally unused, and will be used by=0D=0A+ * the replace=
ment function when that commit lands=0D=0A+ */=0D=0A+#define famfs_opt_en=
abled(fsi, opt) (fsi !=3D 0)=0D=0A+=0D=0A int famfs_lookup_daxdev(const c=
har *pathname, dev_t *devno);=0D=0A int famfs_devlist_alloc(struct famfs_=
fs_info *fsi);=0D=0A int famfs_install_daxdev(struct famfs_fs_info *fsi, =
struct super_block *sb,=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
