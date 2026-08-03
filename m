Received: from a11-17.smtp-out.amazonses.com (a11-17.smtp-out.amazonses.com [54.240.11.17])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2616C31619B;
	Mon,  3 Aug 2026 02:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724170; cv=none; b=JDxr5iqb8AoYTwLdHIXssMPRndYeNvzA4hwqL8oBESpe2m3vot3Pnzy//eB4x1V6UKfiBiPAZWZutbdrhAHIGyk2hj0dw8r0/CpjMH3F1bmtSWHm/mG5PVbxA9p1qRHwbpFeSf0wbICBHcQ4KRlTMdUrvnDXybY284/l8vFeUok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724170; c=relaxed/simple;
	bh=iWnfY41qkQg8hBkgsc12pwpckmBo/+bN3/m22v2At3Y=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=iwWf04n3HTgA492q63v3HqxqJGAg4szaUQX07le/wG1tEedlyU5EVxCRsxs6nD9WBss/y04SA7ludcQ/PsKBYjT7h99b6BWAwbUh/3Sw9k8FO/gk3nuVQ7iRXQ7LfoQBIJwnSMrvUpHHan54bDXsCZX5LYvHo8FUUcHvQvpma00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=gS9q7K7s; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=VAI5xIKQ; arc=none smtp.client-ip=54.240.11.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="gS9q7K7s";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="VAI5xIKQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724167;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=iWnfY41qkQg8hBkgsc12pwpckmBo/+bN3/m22v2At3Y=;
	b=gS9q7K7soa9ik45SWFNx8pnKrxX12VJLowohDEZlpN4n8Shu52ADgodpCcO+9x/K
	8Zrm9B/NjvEpUOwNguSuCMfCdJfxz9KhMgTgusQ/4PwLYkRoEwyILUv0U9tR/RBxmif
	tmuqr4TYFDOxmf4Imgg99SHO/xqs+M3UpGlNb9m8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724167;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=iWnfY41qkQg8hBkgsc12pwpckmBo/+bN3/m22v2At3Y=;
	b=VAI5xIKQJfkSlkJ+yXXzqTTUoJ1udi7BK6mjgc1nsn6C3RqbPV5zC8MO2lulk2LI
	bWS/azF7TXc2R+OysNtgNAhhwFyljOe00QuzD0DLc+/Wip+rRpLCkNcbR8A875DAtgW
	TtElmEfKgnl9QhxsNr22MZqdhaNRDhIBe/bF2pDk=
Subject: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)
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
Date: Mon, 3 Aug 2026 02:29:26 +0000
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
 <20260803022919.75875-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAAD5RH
Thread-Topic: [PATCH V12 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
X-Wm-Sent-Timestamp: 1785724165
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc5746312-6cfe9a07-a658-4aba-b1e9-5233b0ddfcf4-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.11.17

From: John Groves <John@Groves.net>=0D=0A=0D=0AAdd the famfs file ioctl h=
andler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and=0D=0Athe KABI-44 self-desc=
ribing fmap message: the wire ABI in famfs_ioctl.h=0D=0A(famfs_ioc_fmap_h=
eader plus the simple and interleaved extent structs), the=0D=0Ain-core f=
amfs_file_meta, and famfs_file_init_dax(), which copies the=0D=0Amessage =
in, parses both the simple-extent and interleaved (striped) wire=0D=0Afor=
ms into inode->i_private, and sets S_DAX.=0D=0A=0D=0AResolving those mapp=
ings to dax-device offsets (iomap_begin) is added in=0D=0Athe following c=
ommit; the read/write/fault paths keep their NULL iomap_ops=0D=0Astub unt=
il then.=0D=0A=0D=0AAlso add famfs ioctls to ioctl-number.rst=0D=0A=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A .../userspace=
-api/ioctl/ioctl-number.rst      |   1 +=0D=0A fs/famfs/famfs_file.c     =
                    | 326 +++++++++++++++++-=0D=0A fs/famfs/famfs_inode.c=
                        |   1 +=0D=0A fs/famfs/famfs_internal.h          =
           |  46 +++=0D=0A include/uapi/linux/famfs_ioctl.h              =
|  91 +++++=0D=0A 5 files changed, 462 insertions(+), 3 deletions(-)=0D=0A=
 create mode 100644 include/uapi/linux/famfs_ioctl.h=0D=0A=0D=0Adiff --gi=
t a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/us=
erspace-api/ioctl/ioctl-number.rst=0D=0Aindex 3f0ef1e27eb0..5e244dec1b98 =
100644=0D=0A--- a/Documentation/userspace-api/ioctl/ioctl-number.rst=0D=0A=
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst=0D=0A@@ -299,6 +=
299,7 @@ Code  Seq#    Include File                                      =
       Comments=0D=0A 'u'   00-2F  linux/ublk_cmd.h                      =
                    conflict!=0D=0A 'u'   20-3F  linux/uvcvideo.h        =
                                  USB video class host driver=0D=0A 'u'  =
 40-4f  linux/udmabuf.h                                           userspa=
ce dma-buf misc device=0D=0A+'u'   50-5F  linux/famfs_ioctl.h            =
                           famfs shared memory file system=0D=0A 'v'   00=
-1F  linux/ext2_fs.h                                           conflict!=0D=
=0A 'v'   00-1F  linux/fs.h                                              =
  conflict!=0D=0A 'v'   00-0F  linux/sonypi.h                            =
                conflict!=0D=0Adiff --git a/fs/famfs/famfs_file.c b/fs/fa=
mfs/famfs_file.c=0D=0Aindex 678f2035fd5f..d710c8a0c923 100644=0D=0A--- a/=
fs/famfs/famfs_file.c=0D=0A+++ b/fs/famfs/famfs_file.c=0D=0A@@ -13,9 +13,=
313 @@=0D=0A #include <linux/mm.h>=0D=0A #include <linux/dax.h>=0D=0A #in=
clude <linux/iomap.h>=0D=0A+#include <linux/capability.h>=0D=0A=20=0D=0A+=
#include <linux/famfs_ioctl.h>=0D=0A #include "famfs_internal.h"=0D=0A=20=
=0D=0A+/* Expose famfs kernel abi version as a read-only module parameter=
 */=0D=0A+static int famfs_kabi_version =3D FAMFS_KABI_VERSION;=0D=0A+mod=
ule_param(famfs_kabi_version, int, 0444);=0D=0A+MODULE_PARM_DESC(famfs_ka=
bi_version, "famfs kernel abi version");=0D=0A+=0D=0A+void=0D=0A+famfs_me=
ta_free(struct famfs_file_meta *map)=0D=0A+{=0D=0A+=09if (map) {=0D=0A+=09=
=09switch (map->fm_extent_type) {=0D=0A+=09=09case FAMFS_IOC_EXT_SIMPLE:=0D=
=0A+=09=09=09kfree(map->se);=0D=0A+=09=09=09break;=0D=0A+=09=09case FAMFS=
_IOC_EXT_INTERLEAVE:=0D=0A+=09=09=09if (map->ie) {=0D=0A+=09=09=09=09u32 =
i;=0D=0A+=0D=0A+=09=09=09=09for (i =3D 0; i < map->fm_niext; i++)=0D=0A+=09=
=09=09=09=09kfree(map->ie[i].ie_strips);=0D=0A+=09=09=09}=0D=0A+=09=09=09=
kfree(map->ie);=0D=0A+=09=09=09break;=0D=0A+=09=09default:=0D=0A+=09=09=09=
break;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=09kfree(map);=0D=0A+}=0D=0A+=0D=0A=
+/**=0D=0A+ * famfs_file_init_dax() - FAMFSIOC_MAP_CREATE ioctl handler=0D=
=0A+ * @file: the un-initialized file=0D=0A+ * @arg:  user pointer to a s=
elf-describing fmap message=0D=0A+ *=0D=0A+ * The map-create ioctl carrie=
s the fmap as a self-describing message: a=0D=0A+ * struct famfs_ioc_fmap=
_header followed by an extent list. The message is=0D=0A+ * copied in, pa=
rsed into a famfs_file_meta, and published on inode->i_private.=0D=0A+ * =
Both the simple-extent and the interleaved (striped) wire forms are handl=
ed.=0D=0A+ * The wire layout byte-matches the fmap carried in a fuse famf=
s GET_FMAP reply.=0D=0A+ */=0D=0A+static int=0D=0A+famfs_check_ext_alignm=
ent(struct famfs_meta_simple_ext *se)=0D=0A+{=0D=0A+=09int errs =3D 0;=0D=
=0A+=0D=0A+=09if (!IS_ALIGNED(se->ext_offset, PMD_SIZE))=0D=0A+=09=09errs=
++;=0D=0A+=09if (!IS_ALIGNED(se->ext_len, PMD_SIZE))=0D=0A+=09=09errs++;=0D=
=0A+=0D=0A+=09return errs;=0D=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_fi=
le_init_dax(struct file *file, void __user *arg)=0D=0A+{=0D=0A+=09struct =
famfs_ioc_fmap_header fmh;=0D=0A+=09struct famfs_file_meta *meta =3D NULL=
;=0D=0A+=09struct famfs_fs_info *fsi;=0D=0A+=09struct super_block *sb;=0D=
=0A+=09struct inode *inode;=0D=0A+=09void *fmap_buf =3D NULL;=0D=0A+=09si=
ze_t extent_total =3D 0;=0D=0A+=09size_t next_offset;=0D=0A+=09int errs =3D=
 0;=0D=0A+=09int rc;=0D=0A+=09u32 i, j;=0D=0A+=0D=0A+=09inode =3D file_in=
ode(file);=0D=0A+=09if (!inode)=0D=0A+=09=09return -EBADF;=0D=0A+=09if (i=
node->i_private)=0D=0A+=09=09return -EEXIST;=0D=0A+=0D=0A+=09sb  =3D inod=
e->i_sb;=0D=0A+=09fsi =3D sb->s_fs_info;=0D=0A+=09if (fsi->deverror)=0D=0A=
+=09=09return -ENODEV;=0D=0A+=09if (!famfs_opt_enabled(fsi, FAMFS_OPT_MAP=
_CREATE))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A+=09if (copy_from_user(&=
fmh, arg, sizeof(fmh)))=0D=0A+=09=09return -EFAULT;=0D=0A+=0D=0A+=09if (f=
mh.fmap_version !=3D FAMFS_FMAP_VERSION)=0D=0A+=09=09return -EINVAL;=0D=0A=
+=09if (fmh.fmap_size < sizeof(fmh))=0D=0A+=09=09return -EINVAL;=0D=0A+=09=
if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)=0D=0A+=09=09return -EFBIG;=0D=0A+=
=09if (fmh.nextents < 1)=0D=0A+=09=09return -EINVAL;=0D=0A+=0D=0A+=09fmap=
_buf =3D kvmalloc(fmh.fmap_size, GFP_KERNEL);=0D=0A+=09if (!fmap_buf)=0D=0A=
+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09if (copy_from_user(fmap_buf, arg, =
fmh.fmap_size)) {=0D=0A+=09=09rc =3D -EFAULT;=0D=0A+=09=09goto out;=0D=0A=
+=09}=0D=0A+=09next_offset =3D sizeof(fmh);=09/* start of the extent list=
 */=0D=0A+=0D=0A+=09meta =3D kzalloc_obj(*meta, GFP_KERNEL);=0D=0A+=09if =
(!meta) {=0D=0A+=09=09rc =3D -ENOMEM;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=
=0A+=0D=0A+=09meta->error =3D false;=0D=0A+=09meta->file_type =3D fmh.fil=
e_type;=0D=0A+=09meta->file_size =3D fmh.file_size;=0D=0A+=09meta->fm_ext=
ent_type =3D fmh.ext_type;=0D=0A+=0D=0A+=09switch (fmh.ext_type) {=0D=0A+=
=09case FAMFS_IOC_EXT_SIMPLE: {=0D=0A+=09=09struct famfs_ioc_simple_ext *=
se_in =3D fmap_buf + next_offset;=0D=0A+=0D=0A+=09=09next_offset +=3D (si=
ze_t)fmh.nextents * sizeof(*se_in);=0D=0A+=09=09if (next_offset > fmh.fma=
p_size) {=0D=0A+=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09goto out;=0D=0A+=09=
=09}=0D=0A+=0D=0A+=09=09meta->fm_nextents =3D fmh.nextents;=0D=0A+=09=09m=
eta->se =3D kcalloc(meta->fm_nextents, sizeof(*meta->se),=0D=0A+=09=09=09=
=09   GFP_KERNEL);=0D=0A+=09=09if (!meta->se) {=0D=0A+=09=09=09rc =3D -EN=
OMEM;=0D=0A+=09=09=09goto out;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09for (i =3D=
 0; i < fmh.nextents; i++) {=0D=0A+=09=09=09meta->se[i].dev_index  =3D se=
_in[i].se_devindex;=0D=0A+=09=09=09meta->se[i].ext_offset =3D se_in[i].se=
_offset;=0D=0A+=09=09=09meta->se[i].ext_len    =3D se_in[i].se_len;=0D=0A=
+=0D=0A+=09=09=09if (meta->se[i].dev_index >=3D FAMFS_MAX_DAXDEVS) {=0D=0A=
+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=
=0D=0A+=09=09=09meta->dev_bitmap |=3D BIT_ULL(meta->se[i].dev_index);=0D=0A=
+=09=09=09errs +=3D famfs_check_ext_alignment(&meta->se[i]);=0D=0A+=09=09=
=09extent_total +=3D meta->se[i].ext_len;=0D=0A+=09=09}=0D=0A+=09=09break=
;=0D=0A+=09}=0D=0A+=0D=0A+=09case FAMFS_IOC_EXT_INTERLEAVE: {=0D=0A+=09=09=
s64 size_remainder =3D meta->file_size;=0D=0A+=09=09u32 niext =3D fmh.nex=
tents;=0D=0A+=0D=0A+=09=09meta->fm_niext =3D niext;=0D=0A+=09=09meta->ie =
=3D kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);=0D=0A+=09=09if (!meta-=
>ie) {=0D=0A+=09=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09goto out;=0D=0A+=09=09=
}=0D=0A+=0D=0A+=09=09/* Outer loop is over the separate interleaved exten=
ts */=0D=0A+=09=09for (i =3D 0; i < niext; i++) {=0D=0A+=09=09=09struct f=
amfs_ioc_iext *ie_in =3D fmap_buf + next_offset;=0D=0A+=09=09=09struct fa=
mfs_ioc_simple_ext *sie_in;=0D=0A+=09=09=09u64 nstrips;=0D=0A+=0D=0A+=09=09=
=09next_offset +=3D sizeof(*ie_in);=0D=0A+=09=09=09if (next_offset > fmh.=
fmap_size) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out=
;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09if (ie_in->ie_chunk_size =3D=3D =
0 ||=0D=0A+=09=09=09    !IS_ALIGNED(ie_in->ie_chunk_size, PMD_SIZE)) {=0D=
=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09=
}=0D=0A+=09=09=09if (ie_in->ie_nbytes =3D=3D 0) {=0D=0A+=09=09=09=09rc =3D=
 -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=
=09nstrips =3D ie_in->ie_nstrips;=0D=0A+=09=09=09if (nstrips < 1) {=0D=0A=
+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=
=0D=0A+=0D=0A+=09=09=09meta->ie[i].fie_chunk_size =3D ie_in->ie_chunk_siz=
e;=0D=0A+=09=09=09meta->ie[i].fie_nstrips    =3D ie_in->ie_nstrips;=0D=0A=
+=09=09=09meta->ie[i].fie_nbytes     =3D ie_in->ie_nbytes;=0D=0A+=0D=0A+=09=
=09=09/* The strip extents follow the interleaved-ext header */=0D=0A+=09=
=09=09sie_in =3D fmap_buf + next_offset;=0D=0A+=09=09=09next_offset +=3D =
nstrips * sizeof(*sie_in);=0D=0A+=09=09=09if (next_offset > fmh.fmap_size=
) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=
=09=09}=0D=0A+=0D=0A+=09=09=09meta->ie[i].ie_strips =3D=0D=0A+=09=09=09=09=
kcalloc(nstrips, sizeof(meta->ie[i].ie_strips[0]),=0D=0A+=09=09=09=09=09G=
FP_KERNEL);=0D=0A+=09=09=09if (!meta->ie[i].ie_strips) {=0D=0A+=09=09=09=09=
rc =3D -ENOMEM;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A=
+=09=09=09/* Inner loop is over the strips */=0D=0A+=09=09=09for (j =3D 0=
; j < nstrips; j++) {=0D=0A+=09=09=09=09struct famfs_meta_simple_ext *so =
=3D=0D=0A+=09=09=09=09=09&meta->ie[i].ie_strips[j];=0D=0A+=0D=0A+=09=09=09=
=09so->dev_index  =3D sie_in[j].se_devindex;=0D=0A+=09=09=09=09so->ext_of=
fset =3D sie_in[j].se_offset;=0D=0A+=09=09=09=09so->ext_len    =3D sie_in=
[j].se_len;=0D=0A+=0D=0A+=09=09=09=09if (so->dev_index >=3D FAMFS_MAX_DAX=
DEVS) {=0D=0A+=09=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09=09goto ou=
t;=0D=0A+=09=09=09=09}=0D=0A+=09=09=09=09meta->dev_bitmap |=3D BIT_ULL(so=
->dev_index);=0D=0A+=09=09=09=09errs +=3D famfs_check_ext_alignment(so);=0D=
=0A+=09=09=09=09extent_total +=3D so->ext_len;=0D=0A+=09=09=09=09size_rem=
ainder -=3D so->ext_len;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09=
if (size_remainder > 0) {=0D=0A+=09=09=09/* Strips do not cover the whole=
 file */=0D=0A+=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09goto out;=0D=0A+=09=
=09}=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A+=09default:=0D=0A+=09=09r=
c =3D -EINVAL;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=0A+=0D=0A+=09if (errs =
> 0) {=0D=0A+=09=09rc =3D -EINVAL;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=0A=
+=09if (extent_total < meta->file_size) {=0D=0A+=09=09rc =3D -EINVAL;=0D=0A=
+=09=09goto out;=0D=0A+=09}=0D=0A+=0D=0A+=09/* Publish the famfs metadata=
 on inode->i_private */=0D=0A+=09inode_lock(inode);=0D=0A+=09if (inode->i=
_private) {=0D=0A+=09=09rc =3D -EEXIST; /* file already has famfs metadat=
a */=0D=0A+=09} else {=0D=0A+=09=09inode->i_private =3D meta;=0D=0A+=09=09=
i_size_write(inode, meta->file_size);=0D=0A+=09=09inode->i_flags |=3D S_D=
AX;=0D=0A+=09=09meta =3D NULL; /* owned by the inode now */=0D=0A+=09=09r=
c =3D 0;=0D=0A+=09}=0D=0A+=09inode_unlock(inode);=0D=0A+=0D=0A+out:=0D=0A=
+=09kvfree(fmap_buf);=0D=0A+=09if (meta)=0D=0A+=09=09famfs_meta_free(meta=
);=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_file_ioctl=
() - Top-level famfs file ioctl handler=0D=0A+ * @file: the file=0D=0A+ *=
 @cmd:  ioctl opcode=0D=0A+ * @arg:  ioctl opcode argument (if any)=0D=0A=
+ */=0D=0A+static long=0D=0A+famfs_file_ioctl(struct file *file, unsigned=
 int cmd, unsigned long arg)=0D=0A+{=0D=0A+=09struct inode *inode =3D fil=
e_inode(file);=0D=0A+=09struct famfs_fs_info *fsi =3D inode->i_sb->s_fs_i=
nfo;=0D=0A+=09long rc;=0D=0A+=0D=0A+=09if (fsi->deverror && (cmd !=3D FAM=
FSIOC_NOP))=0D=0A+=09=09return -ENODEV;=0D=0A+=0D=0A+=09switch (cmd) {=0D=
=0A+=09case FAMFSIOC_NOP:=0D=0A+=09=09rc =3D 0;=0D=0A+=09=09break;=0D=0A+=
=0D=0A+=09case FAMFSIOC_MAP_CREATE:=0D=0A+=09=09rc =3D famfs_file_init_da=
x(file, (void __user *)arg);=0D=0A+=09=09break;=0D=0A+=0D=0A+=09default:=0D=
=0A+=09=09rc =3D -ENOTTY;=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A+=09r=
eturn rc;=0D=0A+}=0D=0A+=0D=0A /*****************************************=
****************************=0D=0A  * vm_operations=0D=0A  */=0D=0A@@ -93=
,9 +397,25 @@ const struct vm_operations_struct famfs_file_vm_ops =3D {=0D=
=0A static ssize_t=0D=0A famfs_file_invalid(struct inode *inode)=0D=0A {=0D=
=0A+=09struct famfs_file_meta *meta =3D inode->i_private;=0D=0A+=09size_t=
 i_size =3D i_size_read(inode);=0D=0A+=0D=0A+=09if (!meta) {=0D=0A+=09=09=
pr_debug("%s: un-initialized famfs file\n", __func__);=0D=0A+=09=09return=
 -EIO;=0D=0A+=09}=0D=0A+=09if (meta->error) {=0D=0A+=09=09pr_debug("%s: p=
reviously detected metadata errors\n", __func__);=0D=0A+=09=09return -EIO=
;=0D=0A+=09}=0D=0A+=09if (i_size !=3D meta->file_size) {=0D=0A+=09=09pr_w=
arn("%s: i_size overwritten from %ld to %ld\n",=0D=0A+=09=09       __func=
__, meta->file_size, i_size);=0D=0A+=09=09meta->error =3D true;=0D=0A+=09=
=09return -ENXIO;=0D=0A+=09}=0D=0A =09if (!IS_DAX(inode)) {=0D=0A-=09=09p=
r_debug("%s: inode %llx IS_DAX is false\n",=0D=0A-=09=09=09 __func__, (u6=
4)inode);=0D=0A+=09=09pr_debug("%s: inode %llx IS_DAX is false\n", __func=
__, (u64)inode);=0D=0A =09=09return -ENXIO;=0D=0A =09}=0D=0A =09return 0;=
=0D=0A@@ -222,7 +542,7 @@ const struct file_operations famfs_file_operati=
ons =3D {=0D=0A =09/* Custom famfs operations */=0D=0A =09.write_iter=09 =
  =3D famfs_dax_write_iter,=0D=0A =09.read_iter=09   =3D famfs_dax_read_i=
ter,=0D=0A-=09.unlocked_ioctl    =3D NULL /*famfs_file_ioctl*/,=0D=0A+=09=
=2Eunlocked_ioctl    =3D famfs_file_ioctl,=0D=0A =09.mmap=09=09   =3D fam=
fs_file_mmap,=0D=0A=20=0D=0A =09/* Force PMD alignment for mmap */=0D=0Ad=
iff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c=0D=0Aindex 91=
0a143dad30..a6c3b4574e69 100644=0D=0A--- a/fs/famfs/famfs_inode.c=0D=0A++=
+ b/fs/famfs/famfs_inode.c=0D=0A@@ -300,6 +300,7 @@ static int famfs_show=
_options(struct seq_file *m, struct dentry *root)=0D=0A=20=0D=0A static v=
oid famfs_evict_inode(struct inode *inode)=0D=0A {=0D=0A+=09famfs_meta_fr=
ee((struct famfs_file_meta *)inode->i_private);=0D=0A =09inode->i_private=
 =3D NULL;=0D=0A =09dax_break_layout_final(inode);=0D=0A =09truncate_inod=
e_pages_final(&inode->i_data);=0D=0Adiff --git a/fs/famfs/famfs_internal.=
h b/fs/famfs/famfs_internal.h=0D=0Aindex 26f5abda96dc..b5f9c8d0349f 10064=
4=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b/fs/famfs/famfs_internal=
=2Eh=0D=0A@@ -15,8 +15,52 @@=0D=0A #include <linux/bits.h>=0D=0A #include=
 <linux/build_bug.h>=0D=0A=20=0D=0A+#include <linux/famfs_ioctl.h>=0D=0A+=
=0D=0A extern const struct file_operations famfs_file_operations;=0D=0A=20=
=0D=0A+/*=0D=0A+ * Internal sanity bound on a FAMFSIOC_MAP_CREATE fmap me=
ssage. The ABI does=0D=0A+ * not advertise a maximum (the message is self=
-describing); this only guards=0D=0A+ * the copy-in against an unreasonab=
le allocation. Oversize is rejected with=0D=0A+ * -EFBIG.=0D=0A+ */=0D=0A=
+#define FAMFS_FMAP_MSG_MAX (4 * 1024 * 1024)=0D=0A+=0D=0A+struct famfs_m=
eta_simple_ext {=0D=0A+=09u64 dev_index;=0D=0A+=09u64 ext_offset;=0D=0A+=09=
u64 ext_len;=0D=0A+};=0D=0A+=0D=0A+struct famfs_meta_interleaved_ext {=0D=
=0A+=09u64 fie_nstrips;=0D=0A+=09u64 fie_chunk_size;=0D=0A+=09u64 fie_nby=
tes;=0D=0A+=09struct famfs_meta_simple_ext *ie_strips;=0D=0A+};=0D=0A+=0D=
=0A+/*=0D=0A+ * Each famfs dax file has this hanging from its inode->i_pr=
ivate.=0D=0A+ */=0D=0A+struct famfs_file_meta {=0D=0A+=09bool            =
       error;=0D=0A+=09enum famfs_file_type   file_type;=0D=0A+=09size_t =
                file_size;=0D=0A+=09enum famfs_ioc_ext_type fm_extent_typ=
e;=0D=0A+=09u64                    dev_bitmap; /* referenced daxdev indic=
es */=0D=0A+=09union { /* This will make code a bit more readable */=0D=0A=
+=09=09struct {=0D=0A+=09=09=09size_t         fm_nextents;=0D=0A+=09=09=09=
struct famfs_meta_simple_ext  *se;=0D=0A+=09=09};=0D=0A+=09=09struct {=0D=
=0A+=09=09=09size_t         fm_niext;=0D=0A+=09=09=09struct famfs_meta_in=
terleaved_ext *ie;=0D=0A+=09=09};=0D=0A+=09};=0D=0A+};=0D=0A+=0D=0A struc=
t famfs_mount_opts {=0D=0A =09umode_t mode;=0D=0A };=0D=0A@@ -83,4 +127,6=
 @@ int famfs_devlist_alloc(struct famfs_fs_info *fsi);=0D=0A int famfs_i=
nstall_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,=0D=0A =09=
=09=09 u64 index, dev_t devno, const char *name);=0D=0A=20=0D=0A+void fam=
fs_meta_free(struct famfs_file_meta *map);=0D=0A+=0D=0A #endif /* FAMFS_I=
NTERNAL_H */=0D=0Adiff --git a/include/uapi/linux/famfs_ioctl.h b/include=
/uapi/linux/famfs_ioctl.h=0D=0Anew file mode 100644=0D=0Aindex 0000000000=
00..b4eb373c1ade=0D=0A--- /dev/null=0D=0A+++ b/include/uapi/linux/famfs_i=
octl.h=0D=0A@@ -0,0 +1,91 @@=0D=0A+/* SPDX-License-Identifier: GPL-2.0 WI=
TH Linux-syscall-note */=0D=0A+/*=0D=0A+ * famfs - dax file system for sh=
ared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2024 Micron =
Technology, Inc.=0D=0A+ *=0D=0A+ * This file system, originally based on =
ramfs the dax support from xfs,=0D=0A+ * is intended to allow multiple ho=
st systems to mount a common file system=0D=0A+ * view of dax files that =
map to shared memory.=0D=0A+ */=0D=0A+#ifndef FAMFS_IOCTL_H=0D=0A+#define=
 FAMFS_IOCTL_H=0D=0A+=0D=0A+#include <linux/ioctl.h>=0D=0A+#include <linu=
x/uuid.h>=0D=0A+=0D=0A+#define FAMFS_KABI_VERSION 44=0D=0A+=0D=0A+enum fa=
mfs_file_type {=0D=0A+=09FAMFS_REG,=0D=0A+=09FAMFS_SUPERBLOCK,=0D=0A+=09F=
AMFS_LOG,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Extent type in a famfs fmap m=
essage, and of the in-core map=0D=0A+ * (famfs_file_meta.fm_extent_type).=
=0D=0A+ */=0D=0A+enum famfs_ioc_ext_type {=0D=0A+=09FAMFS_IOC_EXT_SIMPLE,=
=0D=0A+=09FAMFS_IOC_EXT_INTERLEAVE,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * The=
 FAMFSIOC_MAP_CREATE payload is a self-describing fmap message: a=0D=0A+ =
* struct famfs_ioc_fmap_header immediately followed by @nextents extent=0D=
=0A+ * records. @fmap_size gives the total message length, so a reader is=
=0D=0A+ * self-delimiting.=0D=0A+ *=0D=0A+ * For ext_type =3D=3D FAMFS_IO=
C_EXT_SIMPLE the records are an array of=0D=0A+ * @nextents famfs_ioc_sim=
ple_ext. For ext_type =3D=3D FAMFS_IOC_EXT_INTERLEAVE=0D=0A+ * each of th=
e @nextents records is a famfs_ioc_iext header immediately=0D=0A+ * follo=
wed by ie_nstrips famfs_ioc_simple_ext strip extents.=0D=0A+ *=0D=0A+ * T=
his wire layout is byte-identical to the fmap carried in a fuse famfs=0D=0A=
+ * GET_FMAP reply, so the same userspace serializer emits both.=0D=0A+ *=
=0D=0A+ * The message is self-describing (@fmap_size bounds it), so neith=
er the extent=0D=0A+ * and strip counts nor the total size are capped by =
this ABI. The kernel=0D=0A+ * applies an internal sanity limit to the cop=
y-in and returns -EFBIG for a=0D=0A+ * message larger than it will accept=
=2E=0D=0A+ */=0D=0A+#define FAMFS_FMAP_VERSION 1=0D=0A+=0D=0A+struct famf=
s_ioc_simple_ext {=0D=0A+=09__u32 se_devindex;=0D=0A+=09__u32 reserved;=0D=
=0A+=09__u64 se_offset;=0D=0A+=09__u64 se_len;=0D=0A+};=0D=0A+=0D=0A+stru=
ct famfs_ioc_iext {=09=09/* interleaved (striped) extent */=0D=0A+=09__u3=
2 ie_nstrips;=0D=0A+=09__u32 ie_chunk_size;=0D=0A+=09__u64 ie_nbytes;=09/=
* total bytes mapped by this interleaved extent */=0D=0A+=09__u64 reserve=
d;=0D=0A+};=0D=0A+=0D=0A+struct famfs_ioc_fmap_header {=0D=0A+=09__u8  fi=
le_type;=09/* enum famfs_file_type */=0D=0A+=09__u8  reserved;=0D=0A+=09_=
_u16 fmap_version;=09/* FAMFS_FMAP_VERSION */=0D=0A+=09__u32 ext_type;=09=
=09/* enum famfs_ioc_ext_type */=0D=0A+=09__u32 nextents;=0D=0A+=09__u32 =
fmap_size;=09/* total message bytes, including this header */=0D=0A+=09__=
u64 file_size;=0D=0A+=09__u64 reserved1;=0D=0A+};=0D=0A+=0D=0A+#define FA=
MFSIOC_MAGIC 'u'=0D=0A+=0D=0A+/* famfs file ioctl opcodes */=0D=0A+#defin=
e FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,   0x50)=0D=0A+=0D=0A+/*=0D=0A=
+ * MAP_CREATE carries the self-describing fmap message - struct=0D=0A+ *=
 famfs_ioc_fmap_header followed by the extent list (see above).=0D=0A+ */=
=0D=0A+#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, struct =
famfs_ioc_fmap_header)=0D=0A+=0D=0A+#endif /* FAMFS_IOCTL_H */=0D=0A--=20=
=0D=0A2.53.0=0D=0A=0D=0A
