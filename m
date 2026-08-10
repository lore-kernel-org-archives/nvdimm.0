Received: from a8-156.smtp-out.amazonses.com (a8-156.smtp-out.amazonses.com [54.240.8.156])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C43353A69;
	Mon, 10 Aug 2026 20:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393521; cv=none; b=SVZdOY+RfQ31+ZMGp+T3jg/c/zxDngBCbtCU112K5zkvGD+HaLpjCJYuKacx8qttcv6gHC2vHo4O/yYd/pRLIyuzNaybHULC1C4jiYNhnCeBdi38X+ZixpShnbc8aOYtWWn+pS8zR19EoRkCANdndwaskVVarv+PhW9BbIMNZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393521; c=relaxed/simple;
	bh=KrMjn4ekJLeakOBiqnALH3AfkAzpsGSmfNDZpoLBrzg=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=FJ/tKdt0qUlZDXwFfqOzkL5Y5k4xNcYEc9LCuw1B6j5+6yrgiC7JydSmt+PZD5AR5hLQQsw2K3QIWiWx8pR3L3cnsqFMY1BbxVqvmOTAY3pO7CuA60VGWvCw5cUE1yT7P80LiVGpbGqBXfZ9nn5xlT1wuOBcX0nGM+z36Yk4y6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=DWFiIqK3; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=dN7U1ioa; arc=none smtp.client-ip=54.240.8.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="DWFiIqK3";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="dN7U1ioa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393517;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=KrMjn4ekJLeakOBiqnALH3AfkAzpsGSmfNDZpoLBrzg=;
	b=DWFiIqK3cN/a62DrRML4vLLs7GCZxGtxyNU7c2ZbxRHJeCkuA6VRNVun674lDQ7h
	j616Q3oWEgiD4yEeIrDD8fRZ03/ysFzITt4KQDZ6qZJQ+QLrJR8RyGuDmdHyxN29dgy
	cWhtMf2Q0Wh2eng+CYlvWNFn14uEL2WPyUC90JKk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393517;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=KrMjn4ekJLeakOBiqnALH3AfkAzpsGSmfNDZpoLBrzg=;
	b=dN7U1ioaDpip3ntzv5YaJvSl6BloIa4KayEbRoj0KiIrHpY2DhcQ4hAj+otODfhb
	IiM6v32KvHrTJ0bndMpeh3j5SJQjVOylDi1sV0o4H2ZM1PQVToxDWGeh92xWtCv1e0c
	pnYe4Me8MHosf+FgbITg3pRH5KOdk8d0B05Nmxsk=
Subject: [PATCH v13 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI 44)
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
Date: Mon, 10 Aug 2026 20:25:17 +0000
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
 <20260810202510.96332-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAAD10M
Thread-Topic: [PATCH v13 07/12] famfs: MAP_CREATE ioctl and fmap ingest (ABI
 44)
X-Wm-Sent-Timestamp: 1786393516
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed59de28-dde6a382-affe-4bc6-a91d-d4054a7c61a5-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.8.156

From: John Groves <john@groves.net>=0D=0A=0D=0AAdd the famfs file ioctl h=
andler (FAMFSIOC_NOP, FAMFSIOC_MAP_CREATE) and=0D=0Athe KABI-44 self-desc=
ribing fmap message: the wire ABI in famfs_ioctl.h=0D=0A(famfs_ioc_fmap_h=
eader plus the simple and interleaved extent structs), the=0D=0Ain-core f=
amfs_file_meta, and famfs_file_init_dax(), which copies the=0D=0Amessage =
in, parses both the simple-extent and interleaved (striped) wire=0D=0Afor=
ms into inode->i_private, and sets S_DAX.=0D=0A=0D=0AResolving those mapp=
ings to dax-device offsets (iomap_begin) is added in=0D=0Athe following c=
ommit; the read/write/fault paths keep their NULL iomap_ops=0D=0Astub unt=
il then.=0D=0A=0D=0AFamfs now accepts extent and chunk alignment at eithe=
r PMD or PTE. PMD=0D=0Ais the normal case, and it guarantees PMD faults -=
 which is right for=0D=0Alarge files, which are the original use case. Bu=
t there are also active=0D=0Ause cases that use zillions of small files, =
and those need PTE support=0D=0Ato avoid big space amplification.=0D=0A=0D=
=0AAlso add famfs ioctls to ioctl-number.rst=0D=0A=0D=0ASigned-off-by: Jo=
hn Groves <john@groves.net>=0D=0A---=0D=0Av13:=0D=0A - Renamed the read-o=
nly module parameter famfs_kabi_version -> kabi_version;=0D=0A   it alrea=
dy lives under /sys/module/famfs/parameters/, so the famfs_ prefix=0D=0A =
  was redundant. New path: /sys/module/famfs/parameters/kabi_version (sam=
e=0D=0A   for =3Dy and =3Dm).=0D=0A - Dropped the proposed GET_GEOMETRY i=
octl (Darrick suggested turning the NOP=0D=0A   ioctl into one reporting =
the abi version and page/pmd sizes). The abi=0D=0A   version and supporte=
d allocation units are module-wide and needed before=0D=0A   mount, where=
 an ioctl cannot reach; they are exposed as read-only module=0D=0A   para=
meters instead (kabi_version already is; alloc-unit reporting will=0D=0A =
  follow when sub-PMD support lands). FAMFSIOC_NOP is retained as the=0D=0A=
   "is this famfs=3F" probe (Darrick).=0D=0A - Accept 4 KiB extent alignm=
ent, not only 2 MiB. Extent offset and length=0D=0A   (simple extents and=
 interleaved strips) must now be PAGE_SIZE-aligned=0D=0A   instead of PMD=
_SIZE-aligned -- page alignment is a superset, so 2 MiB=0D=0A   fmaps sti=
ll pass, and a 4 KiB-granular fmap is now accepted and maps as=0D=0A   PT=
Es (the fault path already falls back PMD -> PTE, while 2 MiB-aligned=0D=0A=
   extents still get huge pages). The interleaved striping chunk_size mus=
t be=0D=0A   exactly one supported allocation unit -- PAGE_SIZE (4 KiB) o=
r PMD_SIZE=0D=0A   (2 MiB) -- not an arbitrary page multiple. The alloc-u=
nit module param to=0D=0A   advertise supported granularities is deferred=
=2E=0D=0A=0D=0A .../userspace-api/ioctl/ioctl-number.rst      |   1 +=0D=0A=
 fs/famfs/famfs_file.c                         | 328 +++++++++++++++++-=0D=
=0A fs/famfs/famfs_inode.c                        |   1 +=0D=0A fs/famfs/=
famfs_internal.h                     |  46 +++=0D=0A include/uapi/linux/f=
amfs_ioctl.h              |  91 +++++=0D=0A 5 files changed, 464 insertio=
ns(+), 3 deletions(-)=0D=0A create mode 100644 include/uapi/linux/famfs_i=
octl.h=0D=0A=0D=0Adiff --git a/Documentation/userspace-api/ioctl/ioctl-nu=
mber.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst=0D=0Aindex =
3f0ef1e27eb0..5e244dec1b98 100644=0D=0A--- a/Documentation/userspace-api/=
ioctl/ioctl-number.rst=0D=0A+++ b/Documentation/userspace-api/ioctl/ioctl=
-number.rst=0D=0A@@ -299,6 +299,7 @@ Code  Seq#    Include File          =
                                   Comments=0D=0A 'u'   00-2F  linux/ublk=
_cmd.h                                          conflict!=0D=0A 'u'   20-=
3F  linux/uvcvideo.h                                          USB video c=
lass host driver=0D=0A 'u'   40-4f  linux/udmabuf.h                      =
                     userspace dma-buf misc device=0D=0A+'u'   50-5F  lin=
ux/famfs_ioctl.h                                       famfs shared memor=
y file system=0D=0A 'v'   00-1F  linux/ext2_fs.h                         =
                  conflict!=0D=0A 'v'   00-1F  linux/fs.h                =
                                conflict!=0D=0A 'v'   00-0F  linux/sonypi=
=2Eh                                            conflict!=0D=0Adiff --git=
 a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex 9c1cd2f67489.=
=2Eba19b17e80b1 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/fam=
fs/famfs_file.c=0D=0A@@ -13,9 +13,315 @@=0D=0A #include <linux/mm.h>=0D=0A=
 #include <linux/dax.h>=0D=0A #include <linux/iomap.h>=0D=0A+#include <li=
nux/capability.h>=0D=0A=20=0D=0A+#include <linux/famfs_ioctl.h>=0D=0A #in=
clude "famfs_internal.h"=0D=0A=20=0D=0A+/* Expose famfs kernel abi versio=
n as a read-only module parameter */=0D=0A+static int kabi_version =3D FA=
MFS_KABI_VERSION;=0D=0A+module_param(kabi_version, int, 0444);=0D=0A+MODU=
LE_PARM_DESC(kabi_version, "famfs kernel abi version");=0D=0A+=0D=0A+void=
=0D=0A+famfs_meta_free(struct famfs_file_meta *map)=0D=0A+{=0D=0A+=09if (=
map) {=0D=0A+=09=09switch (map->fm_extent_type) {=0D=0A+=09=09case FAMFS_=
IOC_EXT_SIMPLE:=0D=0A+=09=09=09kfree(map->se);=0D=0A+=09=09=09break;=0D=0A=
+=09=09case FAMFS_IOC_EXT_INTERLEAVE:=0D=0A+=09=09=09if (map->ie) {=0D=0A=
+=09=09=09=09u32 i;=0D=0A+=0D=0A+=09=09=09=09for (i =3D 0; i < map->fm_ni=
ext; i++)=0D=0A+=09=09=09=09=09kfree(map->ie[i].ie_strips);=0D=0A+=09=09=09=
}=0D=0A+=09=09=09kfree(map->ie);=0D=0A+=09=09=09break;=0D=0A+=09=09defaul=
t:=0D=0A+=09=09=09break;=0D=0A+=09=09}=0D=0A+=09}=0D=0A+=09kfree(map);=0D=
=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_check_ext_alignment(struct famf=
s_meta_simple_ext *se)=0D=0A+{=0D=0A+=09int errs =3D 0;=0D=0A+=0D=0A+=09i=
f (!IS_ALIGNED(se->ext_offset, PAGE_SIZE))=0D=0A+=09=09errs++;=0D=0A+=09i=
f (!IS_ALIGNED(se->ext_len, PAGE_SIZE))=0D=0A+=09=09errs++;=0D=0A+=0D=0A+=
=09return errs;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_file_init_dax() -=
 FAMFSIOC_MAP_CREATE ioctl handler=0D=0A+ * @file: the un-initialized fil=
e=0D=0A+ * @arg:  user pointer to a self-describing fmap message=0D=0A+ *=
=0D=0A+ * The map-create ioctl carries the fmap as a self-describing mess=
age: a=0D=0A+ * struct famfs_ioc_fmap_header followed by an extent list. =
The message is=0D=0A+ * copied in, parsed into a famfs_file_meta, and pub=
lished on inode->i_private.=0D=0A+ * Both the simple-extent and the inter=
leaved (striped) wire forms are handled.=0D=0A+ * The wire layout byte-ma=
tches the fmap carried in a fuse famfs GET_FMAP reply.=0D=0A+ */=0D=0A+st=
atic int=0D=0A+famfs_file_init_dax(struct file *file, void __user *arg)=0D=
=0A+{=0D=0A+=09struct famfs_ioc_fmap_header fmh;=0D=0A+=09struct famfs_fi=
le_meta *meta =3D NULL;=0D=0A+=09struct famfs_fs_info *fsi;=0D=0A+=09stru=
ct super_block *sb;=0D=0A+=09struct inode *inode;=0D=0A+=09void *fmap_buf=
 =3D NULL;=0D=0A+=09size_t extent_total =3D 0;=0D=0A+=09size_t next_offse=
t;=0D=0A+=09int errs =3D 0;=0D=0A+=09int rc;=0D=0A+=09u32 i, j;=0D=0A+=0D=
=0A+=09inode =3D file_inode(file);=0D=0A+=09if (!inode)=0D=0A+=09=09retur=
n -EBADF;=0D=0A+=09if (inode->i_private)=0D=0A+=09=09return -EEXIST;=0D=0A=
+=0D=0A+=09sb  =3D inode->i_sb;=0D=0A+=09fsi =3D sb->s_fs_info;=0D=0A+=09=
if (fsi->deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=09if (!famfs_opt_en=
abled(fsi, FAMFS_OPT_MAP_CREATE))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=0A=
+=09if (copy_from_user(&fmh, arg, sizeof(fmh)))=0D=0A+=09=09return -EFAUL=
T;=0D=0A+=0D=0A+=09if (fmh.fmap_version !=3D FAMFS_FMAP_VERSION)=0D=0A+=09=
=09return -EINVAL;=0D=0A+=09if (fmh.fmap_size < sizeof(fmh))=0D=0A+=09=09=
return -EINVAL;=0D=0A+=09if (fmh.fmap_size > FAMFS_FMAP_MSG_MAX)=0D=0A+=09=
=09return -EFBIG;=0D=0A+=09if (fmh.nextents < 1)=0D=0A+=09=09return -EINV=
AL;=0D=0A+=0D=0A+=09fmap_buf =3D kvmalloc(fmh.fmap_size, GFP_KERNEL);=0D=0A=
+=09if (!fmap_buf)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09if (copy_f=
rom_user(fmap_buf, arg, fmh.fmap_size)) {=0D=0A+=09=09rc =3D -EFAULT;=0D=0A=
+=09=09goto out;=0D=0A+=09}=0D=0A+=09next_offset =3D sizeof(fmh);=09/* st=
art of the extent list */=0D=0A+=0D=0A+=09meta =3D kzalloc_obj(*meta, GFP=
_KERNEL);=0D=0A+=09if (!meta) {=0D=0A+=09=09rc =3D -ENOMEM;=0D=0A+=09=09g=
oto out;=0D=0A+=09}=0D=0A+=0D=0A+=09meta->error =3D false;=0D=0A+=09meta-=
>file_type =3D fmh.file_type;=0D=0A+=09meta->file_size =3D fmh.file_size;=
=0D=0A+=09meta->fm_extent_type =3D fmh.ext_type;=0D=0A+=0D=0A+=09switch (=
fmh.ext_type) {=0D=0A+=09case FAMFS_IOC_EXT_SIMPLE: {=0D=0A+=09=09struct =
famfs_ioc_simple_ext *se_in =3D fmap_buf + next_offset;=0D=0A+=0D=0A+=09=09=
next_offset +=3D (size_t)fmh.nextents * sizeof(*se_in);=0D=0A+=09=09if (n=
ext_offset > fmh.fmap_size) {=0D=0A+=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=
=09goto out;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09meta->fm_nextents =3D fmh.n=
extents;=0D=0A+=09=09meta->se =3D kcalloc(meta->fm_nextents, sizeof(*meta=
->se),=0D=0A+=09=09=09=09   GFP_KERNEL);=0D=0A+=09=09if (!meta->se) {=0D=0A=
+=09=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09goto out;=0D=0A+=09=09}=0D=0A+=0D=
=0A+=09=09for (i =3D 0; i < fmh.nextents; i++) {=0D=0A+=09=09=09meta->se[=
i].dev_index  =3D se_in[i].se_devindex;=0D=0A+=09=09=09meta->se[i].ext_of=
fset =3D se_in[i].se_offset;=0D=0A+=09=09=09meta->se[i].ext_len    =3D se=
_in[i].se_len;=0D=0A+=0D=0A+=09=09=09if (meta->se[i].dev_index >=3D FAMFS=
_MAX_DAXDEVS) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto =
out;=0D=0A+=09=09=09}=0D=0A+=09=09=09meta->dev_bitmap |=3D BIT_ULL(meta->=
se[i].dev_index);=0D=0A+=09=09=09errs +=3D famfs_check_ext_alignment(&met=
a->se[i]);=0D=0A+=09=09=09extent_total +=3D meta->se[i].ext_len;=0D=0A+=09=
=09}=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=0A+=09case FAMFS_IOC_EXT_INT=
ERLEAVE: {=0D=0A+=09=09s64 size_remainder =3D meta->file_size;=0D=0A+=09=09=
u32 niext =3D fmh.nextents;=0D=0A+=0D=0A+=09=09meta->fm_niext =3D niext;=0D=
=0A+=09=09meta->ie =3D kcalloc(niext, sizeof(*meta->ie), GFP_KERNEL);=0D=0A=
+=09=09if (!meta->ie) {=0D=0A+=09=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09got=
o out;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09/* Outer loop is over the separat=
e interleaved extents */=0D=0A+=09=09for (i =3D 0; i < niext; i++) {=0D=0A=
+=09=09=09struct famfs_ioc_iext *ie_in =3D fmap_buf + next_offset;=0D=0A+=
=09=09=09struct famfs_ioc_simple_ext *sie_in;=0D=0A+=09=09=09u64 nstrips;=
=0D=0A+=0D=0A+=09=09=09next_offset +=3D sizeof(*ie_in);=0D=0A+=09=09=09if=
 (next_offset > fmh.fmap_size) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=
=09=09=09=09goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/* chunk_siz=
e must be exactly one supported alloc unit */=0D=0A+=09=09=09if (ie_in->i=
e_chunk_size !=3D PAGE_SIZE &&=0D=0A+=09=09=09    ie_in->ie_chunk_size !=3D=
 PMD_SIZE) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out=
;=0D=0A+=09=09=09}=0D=0A+=09=09=09if (ie_in->ie_nbytes =3D=3D 0) {=0D=0A+=
=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=0D=0A+=09=09=09}=0D=
=0A+=0D=0A+=09=09=09nstrips =3D ie_in->ie_nstrips;=0D=0A+=09=09=09if (nst=
rips < 1) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09goto out;=
=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09meta->ie[i].fie_chunk_size =3D ie=
_in->ie_chunk_size;=0D=0A+=09=09=09meta->ie[i].fie_nstrips    =3D ie_in->=
ie_nstrips;=0D=0A+=09=09=09meta->ie[i].fie_nbytes     =3D ie_in->ie_nbyte=
s;=0D=0A+=0D=0A+=09=09=09/* The strip extents follow the interleaved-ext =
header */=0D=0A+=09=09=09sie_in =3D fmap_buf + next_offset;=0D=0A+=09=09=09=
next_offset +=3D nstrips * sizeof(*sie_in);=0D=0A+=09=09=09if (next_offse=
t > fmh.fmap_size) {=0D=0A+=09=09=09=09rc =3D -EINVAL;=0D=0A+=09=09=09=09=
goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09meta->ie[i].ie_strips =3D=
=0D=0A+=09=09=09=09kcalloc(nstrips,=0D=0A+=09=09=09=09=09sizeof(meta->ie[=
i].ie_strips[0]),=0D=0A+=09=09=09=09=09GFP_KERNEL);=0D=0A+=09=09=09if (!m=
eta->ie[i].ie_strips) {=0D=0A+=09=09=09=09rc =3D -ENOMEM;=0D=0A+=09=09=09=
=09goto out;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/* Inner loop is over=
 the strips */=0D=0A+=09=09=09for (j =3D 0; j < nstrips; j++) {=0D=0A+=09=
=09=09=09struct famfs_meta_simple_ext *so =3D=0D=0A+=09=09=09=09=09&meta-=
>ie[i].ie_strips[j];=0D=0A+=0D=0A+=09=09=09=09so->dev_index  =3D sie_in[j=
].se_devindex;=0D=0A+=09=09=09=09so->ext_offset =3D sie_in[j].se_offset;=0D=
=0A+=09=09=09=09so->ext_len    =3D sie_in[j].se_len;=0D=0A+=0D=0A+=09=09=09=
=09if (so->dev_index >=3D FAMFS_MAX_DAXDEVS) {=0D=0A+=09=09=09=09=09rc =3D=
 -EINVAL;=0D=0A+=09=09=09=09=09goto out;=0D=0A+=09=09=09=09}=0D=0A+=09=09=
=09=09meta->dev_bitmap |=3D BIT_ULL(so->dev_index);=0D=0A+=09=09=09=09err=
s +=3D famfs_check_ext_alignment(so);=0D=0A+=09=09=09=09extent_total +=3D=
 so->ext_len;=0D=0A+=09=09=09=09size_remainder -=3D so->ext_len;=0D=0A+=09=
=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09if (size_remainder > 0) {=0D=0A+=
=09=09=09/* Strips do not cover the whole file */=0D=0A+=09=09=09rc =3D -=
EINVAL;=0D=0A+=09=09=09goto out;=0D=0A+=09=09}=0D=0A+=09=09break;=0D=0A+=09=
}=0D=0A+=0D=0A+=09default:=0D=0A+=09=09rc =3D -EINVAL;=0D=0A+=09=09goto o=
ut;=0D=0A+=09}=0D=0A+=0D=0A+=09if (errs > 0) {=0D=0A+=09=09rc =3D -EINVAL=
;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=0A+=09if (extent_total < meta->file=
_size) {=0D=0A+=09=09rc =3D -EINVAL;=0D=0A+=09=09goto out;=0D=0A+=09}=0D=0A=
+=0D=0A+=09/* Publish the famfs metadata on inode->i_private */=0D=0A+=09=
inode_lock(inode);=0D=0A+=09if (inode->i_private) {=0D=0A+=09=09rc =3D -E=
EXIST; /* file already has famfs metadata */=0D=0A+=09} else {=0D=0A+=09=09=
inode->i_private =3D meta;=0D=0A+=09=09i_size_write(inode, meta->file_siz=
e);=0D=0A+=09=09inode->i_flags |=3D S_DAX;=0D=0A+=09=09meta =3D NULL; /* =
owned by the inode now */=0D=0A+=09=09rc =3D 0;=0D=0A+=09}=0D=0A+=09inode=
_unlock(inode);=0D=0A+=0D=0A+out:=0D=0A+=09kvfree(fmap_buf);=0D=0A+=09if =
(meta)=0D=0A+=09=09famfs_meta_free(meta);=0D=0A+=09return rc;=0D=0A+}=0D=0A=
+=0D=0A+/**=0D=0A+ * famfs_file_ioctl() - Top-level famfs file ioctl hand=
ler=0D=0A+ * @file: the file=0D=0A+ * @cmd:  ioctl opcode=0D=0A+ * @arg: =
 ioctl opcode argument (if any)=0D=0A+ */=0D=0A+static long=0D=0A+famfs_f=
ile_ioctl(struct file *file, unsigned int cmd, unsigned long arg)=0D=0A+{=
=0D=0A+=09struct inode *inode =3D file_inode(file);=0D=0A+=09struct famfs=
_fs_info *fsi =3D inode->i_sb->s_fs_info;=0D=0A+=09long rc;=0D=0A+=0D=0A+=
=09if (fsi->deverror && (cmd !=3D FAMFSIOC_NOP))=0D=0A+=09=09return -ENOD=
EV;=0D=0A+=0D=0A+=09switch (cmd) {=0D=0A+=09case FAMFSIOC_NOP:=0D=0A+=09=09=
rc =3D 0;=0D=0A+=09=09break;=0D=0A+=0D=0A+=09case FAMFSIOC_MAP_CREATE:=0D=
=0A+=09=09rc =3D famfs_file_init_dax(file, (void __user *)arg);=0D=0A+=09=
=09break;=0D=0A+=0D=0A+=09default:=0D=0A+=09=09rc =3D -ENOTTY;=0D=0A+=09=09=
break;=0D=0A+=09}=0D=0A+=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A /******=
***************************************************************=0D=0A  * =
vm_operations=0D=0A  */=0D=0A@@ -94,9 +400,25 @@ const struct vm_operatio=
ns_struct famfs_file_vm_ops =3D {=0D=0A static ssize_t=0D=0A famfs_file_i=
nvalid(struct inode *inode)=0D=0A {=0D=0A+=09struct famfs_file_meta *meta=
 =3D inode->i_private;=0D=0A+=09size_t i_size =3D i_size_read(inode);=0D=0A=
+=0D=0A+=09if (!meta) {=0D=0A+=09=09pr_debug("%s: un-initialized famfs fi=
le\n", __func__);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (meta->=
error) {=0D=0A+=09=09pr_debug("%s: previously detected metadata errors\n"=
, __func__);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (i_size !=3D=
 meta->file_size) {=0D=0A+=09=09pr_warn("%s: i_size overwritten from %ld =
to %ld\n",=0D=0A+=09=09       __func__, meta->file_size, i_size);=0D=0A+=09=
=09meta->error =3D true;=0D=0A+=09=09return -ENXIO;=0D=0A+=09}=0D=0A =09i=
f (!IS_DAX(inode)) {=0D=0A-=09=09pr_debug("%s: inode %llx IS_DAX is false=
\n",=0D=0A-=09=09=09 __func__, (u64)inode);=0D=0A+=09=09pr_debug("%s: ino=
de %llx IS_DAX is false\n", __func__, (u64)inode);=0D=0A =09=09return -EN=
XIO;=0D=0A =09}=0D=0A =09return 0;=0D=0A@@ -233,7 +555,7 @@ const struct =
file_operations famfs_file_operations =3D {=0D=0A =09/* Custom famfs oper=
ations */=0D=0A =09.write_iter=09   =3D famfs_dax_write_iter,=0D=0A =09.r=
ead_iter=09   =3D famfs_dax_read_iter,=0D=0A-=09.unlocked_ioctl    =3D NU=
LL /*famfs_file_ioctl*/,=0D=0A+=09.unlocked_ioctl    =3D famfs_file_ioctl=
,=0D=0A =09.mmap=09=09   =3D famfs_file_mmap,=0D=0A=20=0D=0A =09/* Force =
PMD alignment for mmap */=0D=0Adiff --git a/fs/famfs/famfs_inode.c b/fs/f=
amfs/famfs_inode.c=0D=0Aindex 9e8662c4ac98..98c877a6009e 100644=0D=0A--- =
a/fs/famfs/famfs_inode.c=0D=0A+++ b/fs/famfs/famfs_inode.c=0D=0A@@ -341,6=
 +341,7 @@ famfs_show_options(struct seq_file *m, struct dentry *root)=0D=
=0A static void=0D=0A famfs_evict_inode(struct inode *inode)=0D=0A {=0D=0A=
+=09famfs_meta_free((struct famfs_file_meta *)inode->i_private);=0D=0A =09=
inode->i_private =3D NULL;=0D=0A =09dax_break_layout_final(inode);=0D=0A =
=09truncate_inode_pages_final(&inode->i_data);=0D=0Adiff --git a/fs/famfs=
/famfs_internal.h b/fs/famfs/famfs_internal.h=0D=0Aindex ff9f1d3f686e..f1=
7380d24f6d 100644=0D=0A--- a/fs/famfs/famfs_internal.h=0D=0A+++ b/fs/famf=
s/famfs_internal.h=0D=0A@@ -15,8 +15,52 @@=0D=0A #include <linux/bits.h>=0D=
=0A #include <linux/build_bug.h>=0D=0A=20=0D=0A+#include <linux/famfs_ioc=
tl.h>=0D=0A+=0D=0A extern const struct file_operations famfs_file_operati=
ons;=0D=0A=20=0D=0A+/*=0D=0A+ * Internal sanity bound on a FAMFSIOC_MAP_C=
REATE fmap message. The ABI does=0D=0A+ * not advertise a maximum (the me=
ssage is self-describing); this only guards=0D=0A+ * the copy-in against =
an unreasonable allocation. Oversize is rejected with=0D=0A+ * -EFBIG.=0D=
=0A+ */=0D=0A+#define FAMFS_FMAP_MSG_MAX (4 * 1024 * 1024)=0D=0A+=0D=0A+s=
truct famfs_meta_simple_ext {=0D=0A+=09u64 dev_index;=0D=0A+=09u64 ext_of=
fset;=0D=0A+=09u64 ext_len;=0D=0A+};=0D=0A+=0D=0A+struct famfs_meta_inter=
leaved_ext {=0D=0A+=09u64 fie_nstrips;=0D=0A+=09u64 fie_chunk_size;=0D=0A=
+=09u64 fie_nbytes;=0D=0A+=09struct famfs_meta_simple_ext *ie_strips;=0D=0A=
+};=0D=0A+=0D=0A+/*=0D=0A+ * Each famfs dax file has this hanging from it=
s inode->i_private.=0D=0A+ */=0D=0A+struct famfs_file_meta {=0D=0A+=09boo=
l                   error;=0D=0A+=09enum famfs_file_type   file_type;=0D=0A=
+=09size_t                 file_size;=0D=0A+=09enum famfs_ioc_ext_type fm=
_extent_type;=0D=0A+=09u64                    dev_bitmap; /* referenced d=
axdev indices */=0D=0A+=09union { /* This will make code a bit more reada=
ble */=0D=0A+=09=09struct {=0D=0A+=09=09=09size_t         fm_nextents;=0D=
=0A+=09=09=09struct famfs_meta_simple_ext  *se;=0D=0A+=09=09};=0D=0A+=09=09=
struct {=0D=0A+=09=09=09size_t         fm_niext;=0D=0A+=09=09=09struct fa=
mfs_meta_interleaved_ext *ie;=0D=0A+=09=09};=0D=0A+=09};=0D=0A+};=0D=0A+=0D=
=0A struct famfs_mount_opts {=0D=0A =09umode_t mode;=0D=0A };=0D=0A@@ -83=
,4 +127,6 @@ int famfs_devlist_alloc(struct famfs_fs_info *fsi);=0D=0A in=
t famfs_install_daxdev(struct famfs_fs_info *fsi, struct super_block *sb,=
=0D=0A =09=09=09 u64 index, dev_t devno, const char *name);=0D=0A=20=0D=0A=
+void famfs_meta_free(struct famfs_file_meta *map);=0D=0A+=0D=0A #endif /=
* FAMFS_INTERNAL_H */=0D=0Adiff --git a/include/uapi/linux/famfs_ioctl.h =
b/include/uapi/linux/famfs_ioctl.h=0D=0Anew file mode 100644=0D=0Aindex 0=
00000000000..b4eb373c1ade=0D=0A--- /dev/null=0D=0A+++ b/include/uapi/linu=
x/famfs_ioctl.h=0D=0A@@ -0,0 +1,91 @@=0D=0A+/* SPDX-License-Identifier: G=
PL-2.0 WITH Linux-syscall-note */=0D=0A+/*=0D=0A+ * famfs - dax file syst=
em for shared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-202=
4 Micron Technology, Inc.=0D=0A+ *=0D=0A+ * This file system, originally =
based on ramfs the dax support from xfs,=0D=0A+ * is intended to allow mu=
ltiple host systems to mount a common file system=0D=0A+ * view of dax fi=
les that map to shared memory.=0D=0A+ */=0D=0A+#ifndef FAMFS_IOCTL_H=0D=0A=
+#define FAMFS_IOCTL_H=0D=0A+=0D=0A+#include <linux/ioctl.h>=0D=0A+#inclu=
de <linux/uuid.h>=0D=0A+=0D=0A+#define FAMFS_KABI_VERSION 44=0D=0A+=0D=0A=
+enum famfs_file_type {=0D=0A+=09FAMFS_REG,=0D=0A+=09FAMFS_SUPERBLOCK,=0D=
=0A+=09FAMFS_LOG,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Extent type in a famf=
s fmap message, and of the in-core map=0D=0A+ * (famfs_file_meta.fm_exten=
t_type).=0D=0A+ */=0D=0A+enum famfs_ioc_ext_type {=0D=0A+=09FAMFS_IOC_EXT=
_SIMPLE,=0D=0A+=09FAMFS_IOC_EXT_INTERLEAVE,=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A=
+ * The FAMFSIOC_MAP_CREATE payload is a self-describing fmap message: a=0D=
=0A+ * struct famfs_ioc_fmap_header immediately followed by @nextents ext=
ent=0D=0A+ * records. @fmap_size gives the total message length, so a rea=
der is=0D=0A+ * self-delimiting.=0D=0A+ *=0D=0A+ * For ext_type =3D=3D FA=
MFS_IOC_EXT_SIMPLE the records are an array of=0D=0A+ * @nextents famfs_i=
oc_simple_ext. For ext_type =3D=3D FAMFS_IOC_EXT_INTERLEAVE=0D=0A+ * each=
 of the @nextents records is a famfs_ioc_iext header immediately=0D=0A+ *=
 followed by ie_nstrips famfs_ioc_simple_ext strip extents.=0D=0A+ *=0D=0A=
+ * This wire layout is byte-identical to the fmap carried in a fuse famf=
s=0D=0A+ * GET_FMAP reply, so the same userspace serializer emits both.=0D=
=0A+ *=0D=0A+ * The message is self-describing (@fmap_size bounds it), so=
 neither the extent=0D=0A+ * and strip counts nor the total size are capp=
ed by this ABI. The kernel=0D=0A+ * applies an internal sanity limit to t=
he copy-in and returns -EFBIG for a=0D=0A+ * message larger than it will =
accept.=0D=0A+ */=0D=0A+#define FAMFS_FMAP_VERSION 1=0D=0A+=0D=0A+struct =
famfs_ioc_simple_ext {=0D=0A+=09__u32 se_devindex;=0D=0A+=09__u32 reserve=
d;=0D=0A+=09__u64 se_offset;=0D=0A+=09__u64 se_len;=0D=0A+};=0D=0A+=0D=0A=
+struct famfs_ioc_iext {=09=09/* interleaved (striped) extent */=0D=0A+=09=
__u32 ie_nstrips;=0D=0A+=09__u32 ie_chunk_size;=0D=0A+=09__u64 ie_nbytes;=
=09/* total bytes mapped by this interleaved extent */=0D=0A+=09__u64 res=
erved;=0D=0A+};=0D=0A+=0D=0A+struct famfs_ioc_fmap_header {=0D=0A+=09__u8=
  file_type;=09/* enum famfs_file_type */=0D=0A+=09__u8  reserved;=0D=0A+=
=09__u16 fmap_version;=09/* FAMFS_FMAP_VERSION */=0D=0A+=09__u32 ext_type=
;=09=09/* enum famfs_ioc_ext_type */=0D=0A+=09__u32 nextents;=0D=0A+=09__=
u32 fmap_size;=09/* total message bytes, including this header */=0D=0A+=09=
__u64 file_size;=0D=0A+=09__u64 reserved1;=0D=0A+};=0D=0A+=0D=0A+#define =
FAMFSIOC_MAGIC 'u'=0D=0A+=0D=0A+/* famfs file ioctl opcodes */=0D=0A+#def=
ine FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,   0x50)=0D=0A+=0D=0A+/*=0D=
=0A+ * MAP_CREATE carries the self-describing fmap message - struct=0D=0A=
+ * famfs_ioc_fmap_header followed by the extent list (see above).=0D=0A+=
 */=0D=0A+#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC,  0x51, stru=
ct famfs_ioc_fmap_header)=0D=0A+=0D=0A+#endif /* FAMFS_IOCTL_H */=0D=0A--=
=20=0D=0A2.53.0=0D=0A=0D=0A
