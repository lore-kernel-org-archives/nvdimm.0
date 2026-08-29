Received: from a11-129.smtp-out.amazonses.com (a11-129.smtp-out.amazonses.com [54.240.11.129])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C019941D65D;
	Sat, 29 Aug 2026 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023514; cv=none; b=OCyySLvBRKs2LL6cZQuppCMUzF6ycuZppqR3qceXX40eRF5rY89XgGNlKFY5gPqPdabxt7alyMtBaBGHyYHSAPahjpSL9LomDjV1Qu93gAsoDS3a55a46/8it45rFNsQmhArRqWSAEs/+TJPGxK9M28n98uwr6L5Ni/6ivlBVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023514; c=relaxed/simple;
	bh=y4SHRS6qn8rzRkE4W3ZcFQ4oroFeLAIuiV6zYfn1vfc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=JpGh9dJ4whk/WqrAAEQIV4k2Mq1Y5GlUCdd9xxf80crvYAqhFa8XV3gh3O4oMpkMKFwC97XKKtrYL5LkO/zK/wex5yimDix4Fd5c5rwZ6LZ7yuE/Bt0nPBwpT6SyZ52RozqlTBG7KYFF8EXGpFjIbwAKoxq5dIj39IWuHKcrbXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=SwfT1ukH; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=Ni8hYwIu; arc=none smtp.client-ip=54.240.11.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="SwfT1ukH";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Ni8hYwIu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023506;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=y4SHRS6qn8rzRkE4W3ZcFQ4oroFeLAIuiV6zYfn1vfc=;
	b=SwfT1ukHv/mDFymwvUKFMd5xHX4ZQWXCm2bCPUf9wwbS7r2Z/+AWOmd8z6mWdJ0x
	5NGfX+kit8/iaBmBtAlPQ5VbkPhRnu1RK/Hqtuw7/16thSAn5zRPNbMWN/YRrX3MfTw
	Dk4OimSRZFUnZXaXa5L2hlMOkejoVN/tuICpxFWs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023506;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=y4SHRS6qn8rzRkE4W3ZcFQ4oroFeLAIuiV6zYfn1vfc=;
	b=Ni8hYwIu0C6Nwi4nCzsIHftIoki4yP1XdCWpnO/McJuD9nuJpkZ8e+KreDAtMDUa
	3sFeVmoU1t2OG08S010mqgJL2bt4oBWSYdUPOxviGIWuvBOSlEH7UfqxMLvblauffXK
	EXv4AzdDXB+b7mQ6uacV5Pc8fAdsTPN8+SXyF89o=
Subject: [PATCH V14 06/12] famfs: Introduce mmap and VM fault handling
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
Date: Sat, 29 Aug 2026 17:11:46 +0000
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
 <20260829171139.7439-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAADdr3
Thread-Topic: [PATCH V14 06/12] famfs: Introduce mmap and VM fault handling
X-Wm-Sent-Timestamp: 1788023504
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e81858b-7fcc80df-8aa2-4262-9727-8cb01a0227fb-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.11.129

From: John Groves <john@groves.net>=0D=0A=0D=0AThis commit adds vm_operat=
ions, plus famfs_mmap() and fault handlers.=0D=0AIt is still missing ioma=
p_ops, iomap mapping resolution, and=0D=0Afamfs_ioctl() for setting up fi=
le-to-memory mappings.=0D=0A=0D=0ANote that famfs supports MAP_SYNC (for =
MMAP_SYNC) basically for free,=0D=0Abecause file maps are never mutated a=
fter MAP_CREATE.=0D=0A=0D=0AReviewed-by: "Darrick J. Wong" <djwong@kernel=
=2Eorg>=0D=0AReviewed-by: Jeff Layton <jlayton@kernel.org>=0D=0ASigned-of=
f-by: John Groves <john@groves.net>=0D=0A---=0D=0A=0D=0A fs/famfs/famfs_f=
ile.c | 109 +++++++++++++++++++++++++++++++++++++++++-=0D=0A 1 file chang=
ed, 108 insertions(+), 1 deletion(-)=0D=0A=0D=0Adiff --git a/fs/famfs/fam=
fs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex 1369fe1824bc..9c1cd2f67489 1=
00644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/famfs/famfs_file.c=0D=
=0A@@ -16,6 +16,76 @@=0D=0A=20=0D=0A #include "famfs_internal.h"=0D=0A=20=
=0D=0A+/*****************************************************************=
****=0D=0A+ * vm_operations=0D=0A+ */=0D=0A+static vm_fault_t=0D=0A+__fam=
fs_filemap_fault(=0D=0A+=09struct vm_fault *vmf,=0D=0A+=09unsigned int or=
der,=0D=0A+=09bool write_fault)=0D=0A+{=0D=0A+=09struct inode *inode =3D =
file_inode(vmf->vma->vm_file);=0D=0A+=09struct super_block *sb =3D inode-=
>i_sb;=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s_fs_info;=0D=0A+=09vm_=
fault_t ret;=0D=0A+=09unsigned long pfn;=0D=0A+=0D=0A+=09if (fsi->deverro=
r)=0D=0A+=09=09return VM_FAULT_SIGBUS;=0D=0A+=0D=0A+=09if (!IS_DAX(file_i=
node(vmf->vma->vm_file))) {=0D=0A+=09=09pr_err("%s: file not marked IS_DA=
X!!\n", __func__);=0D=0A+=09=09return VM_FAULT_SIGBUS;=0D=0A+=09}=0D=0A+=0D=
=0A+=09if (write_fault) {=0D=0A+=09=09sb_start_pagefault(inode->i_sb);=0D=
=0A+=09=09file_update_time(vmf->vma->vm_file);=0D=0A+=09}=0D=0A+=0D=0A+=09=
ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&famfs_iomap_ops *=
/);=0D=0A+=09if (ret & VM_FAULT_NEEDDSYNC)=0D=0A+=09=09ret =3D dax_finish=
_sync_fault(vmf, order, pfn);=0D=0A+=0D=0A+=09if (write_fault)=0D=0A+=09=09=
sb_end_pagefault(inode->i_sb);=0D=0A+=0D=0A+=09return ret;=0D=0A+}=0D=0A+=
=0D=0A+static inline bool=0D=0A+famfs_is_write_fault(struct vm_fault *vmf=
)=0D=0A+{=0D=0A+=09return (vmf->flags & FAULT_FLAG_WRITE) &&=0D=0A+=09   =
    (vmf->vma->vm_flags & VM_SHARED);=0D=0A+}=0D=0A+=0D=0A+static vm_faul=
t_t=0D=0A+famfs_filemap_fault(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09retu=
rn __famfs_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));=0D=0A+}=0D=0A=
+=0D=0A+static vm_fault_t=0D=0A+famfs_filemap_huge_fault(struct vm_fault =
*vmf, unsigned int order)=0D=0A+{=0D=0A+=09return __famfs_filemap_fault(v=
mf, order, famfs_is_write_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+static vm_fau=
lt_t=0D=0A+famfs_filemap_mkwrite(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09r=
eturn __famfs_filemap_fault(vmf, 0, true);=0D=0A+}=0D=0A+=0D=0A+const str=
uct vm_operations_struct famfs_file_vm_ops =3D {=0D=0A+=09.fault=09=09=3D=
 famfs_filemap_fault,=0D=0A+=09.huge_fault=09=3D famfs_filemap_huge_fault=
,=0D=0A+=09.page_mkwrite=09=3D famfs_filemap_mkwrite,=0D=0A+=09.pfn_mkwri=
te=09=3D famfs_filemap_mkwrite,=0D=0A+};=0D=0A+=0D=0A /******************=
***************************************************=0D=0A  * file_operati=
ons=0D=0A  */=0D=0A@@ -120,14 +190,51 @@ famfs_dax_write_iter(struct kioc=
b *iocb, struct iov_iter *from)=0D=0A =09return rc;=0D=0A }=0D=0A=20=0D=0A=
+static int=0D=0A+famfs_file_mmap(struct file *file, struct vm_area_struc=
t *vma)=0D=0A+{=0D=0A+=09struct inode *inode =3D file_inode(file);=0D=0A+=
=09struct super_block *sb =3D inode->i_sb;=0D=0A+=09struct famfs_fs_info =
*fsi =3D sb->s_fs_info;=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09if (fsi->dev=
error)=0D=0A+=09=09return -ENODEV;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Gate sh=
ared-writable mappings on FAMFS_OPT_WRITE. Reject a mapping=0D=0A+=09 * t=
hat is already writable, and strip VM_MAYWRITE from a read-only=0D=0A+=09=
 * shared mapping so a later mprotect(PROT_WRITE) cannot upgrade it.=0D=0A=
+=09 * This is best effort: it does not revoke mappings that already exis=
t.=0D=0A+=09 */=0D=0A+=09if ((vma->vm_flags & VM_SHARED) &&=0D=0A+=09    =
!famfs_opt_enabled(fsi, FAMFS_OPT_WRITE)) {=0D=0A+=09=09if (vma->vm_flags=
 & VM_WRITE)=0D=0A+=09=09=09return -EPERM;=0D=0A+=09=09vm_flags_clear(vma=
, VM_MAYWRITE);=0D=0A+=09}=0D=0A+=0D=0A+=09rc =3D famfs_file_invalid(inod=
e);=0D=0A+=09if (rc)=0D=0A+=09=09return (int)rc;=0D=0A+=0D=0A+=09file_acc=
essed(file);=0D=0A+=09vma->vm_ops =3D &famfs_file_vm_ops;=0D=0A+=09vm_fla=
gs_set(vma, VM_HUGEPAGE);=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A const s=
truct file_operations famfs_file_operations =3D {=0D=0A =09.owner        =
     =3D THIS_MODULE,=0D=0A=20=0D=0A+=09/* fmap metadata is immutable aft=
er MAP_CREATE, so MAP_SYNC is free */=0D=0A+=09.fop_flags=09   =3D FOP_MM=
AP_SYNC,=0D=0A+=0D=0A =09/* Custom famfs operations */=0D=0A =09.write_it=
er=09   =3D famfs_dax_write_iter,=0D=0A =09.read_iter=09   =3D famfs_dax_=
read_iter,=0D=0A =09.unlocked_ioctl    =3D NULL /*famfs_file_ioctl*/,=0D=0A=
-=09.mmap=09=09   =3D NULL /* famfs_file_mmap */,=0D=0A+=09.mmap=09=09   =
=3D famfs_file_mmap,=0D=0A=20=0D=0A =09/* Force PMD alignment for mmap */=
=0D=0A =09.get_unmapped_area =3D thp_get_unmapped_area,=0D=0A--=20=0D=0A2=
=2E53.0=0D=0A=0D=0A
