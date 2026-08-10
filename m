Received: from a11-73.smtp-out.amazonses.com (a11-73.smtp-out.amazonses.com [54.240.11.73])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDA537F300;
	Mon, 10 Aug 2026 20:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393511; cv=none; b=H0btXQ3j8Bs+Fk21Wy2doqhkd/dzqE97EdZFrKZOxgyqCJlsmVre6ADgvhiO+Dpn7GHNmZ2sSuFAy+Tnijgr+GaAPPlL+GAar/D6X9ZkR4UZSWw2jIEQ/alDwcme9BfwpvmGHFN64M/PKSzGnroy2UiBnAAn7Z369OwaWX3f8qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393511; c=relaxed/simple;
	bh=qDd92o85s9p/qNXp9Y7UDSLXUV4ciupl0zOMwLGGIDo=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=VUhTkGiYhyl0MQogHVwMHildnCcHKi6qG8ILXX6Lt+8xlNzeEUpWghAOUfB6F0fToj5t1CJ5If1ySKfBvZCRWplZcvNW9LoyYvA8+d3A9TfaKgQmCXQ07QpA+NepwElwyVW9Z4sgzMI/ozCKqKPDva9IlsHJGAKVNTbXfmh/1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=fidEhHGS; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=mdnAGBiT; arc=none smtp.client-ip=54.240.11.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="fidEhHGS";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="mdnAGBiT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393508;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=qDd92o85s9p/qNXp9Y7UDSLXUV4ciupl0zOMwLGGIDo=;
	b=fidEhHGSaeEzzHHl7LumzU8lite7S5NDIQ9DaEsZlKpU4JM9+ypcuh8Blg4HlPmt
	o32JX23Va6WBmxz98EZqp7vals8RqKyuxyz1ck0GWfBkuFF6YpmfUQJnTglhb2FrL1A
	61uuCIf4RE9hNugvCSjIE7ieAzCpCux5LBihjZHg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393508;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=qDd92o85s9p/qNXp9Y7UDSLXUV4ciupl0zOMwLGGIDo=;
	b=mdnAGBiTBEAeAijhM34yBwwwduzkmo6sEsBpLEvt5aUz/1WzlrFwNW4/CInNyTUB
	6XAX8S3xZokv+woYMgzdTwoIahvsOQsYL3NAEBeyK7w+0uZIrn26bjNi6P2sX42PBQQ
	cszIX+gC7btb7Tszfm1PLUWeBA1SdYgy5t4n7oHs=
Subject: [PATCH v13 06/12] famfs: Introduce mmap and VM fault handling
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
Date: Mon, 10 Aug 2026 20:25:08 +0000
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
 <20260810202500.96317-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAADfWk
Thread-Topic: [PATCH v13 06/12] famfs: Introduce mmap and VM fault handling
X-Wm-Sent-Timestamp: 1786393506
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed59b916-59d30a7a-070a-4670-817b-c9427b0a6535-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.11.73

From: John Groves <john@groves.net>=0D=0A=0D=0AThis commit adds vm_operat=
ions, plus famfs_mmap() and fault handlers.=0D=0AIt is still missing ioma=
p_ops, iomap mapping resolution, and=0D=0Afamfs_ioctl() for setting up fi=
le-to-memory mappings.=0D=0A=0D=0ANote that famfs supports MAP_SYNC (for =
MMAP_SYNC) basically for free,=0D=0Abecause file maps are never mutated a=
fter MAP_CREATE.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=
=0A---=0D=0Av13:=0D=0A - famfs_file_mmap(): close an mprotect() bypass of=
 FAMFS_OPT_WRITE. The gate=0D=0A   checked VM_WRITE only, so a PROT_READ|=
MAP_SHARED mapping (VM_MAYWRITE set,=0D=0A   VM_WRITE clear) passed and c=
ould then be upgraded via mprotect(PROT_WRITE).=0D=0A   Now reject an alr=
eady-writable shared mapping and strip VM_MAYWRITE from a=0D=0A   read-on=
ly one so it cannot be upgraded (Sashiko bot).=0D=0A - Added a comment on=
 famfs_filemap_mkwrite() explaining that a=0D=0A   page_mkwrite/pfn_mkwri=
te is unconditionally a write fault, so it forces=0D=0A   write_fault=3Dt=
rue rather than consulting famfs_is_write_fault(), per=0D=0A   Darrick.=0D=
=0A - Dropped .map_pages =3D filemap_map_pages from famfs_file_vm_ops: it=
 maps=0D=0A   page-cache folios, which a DAX mapping has none of (the add=
ress_space holds=0D=0A   xarray value entries, skipped via xa_is_value())=
, so it did nothing but=0D=0A   cost cycles (Sashiko bot).=0D=0A - Advert=
ise FOP_MMAP_SYNC in fop_flags so MAP_SYNC|MAP_SHARED_VALIDATE is=0D=0A  =
 accepted. famfs fmap metadata is immutable after MAP_CREATE, so the=0D=0A=
   MAP_SYNC durability guarantee is trivially met, and the fault path alr=
eady=0D=0A   handles VM_FAULT_NEEDDSYNC (Sashiko bot).=0D=0A=0D=0A fs/fam=
fs/famfs_file.c | 109 +++++++++++++++++++++++++++++++++++++++++-=0D=0A 1 =
file changed, 108 insertions(+), 1 deletion(-)=0D=0A=0D=0Adiff --git a/fs=
/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex 1369fe1824bc..9c1c=
d2f67489 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/famfs/famf=
s_file.c=0D=0A@@ -16,6 +16,76 @@=0D=0A=20=0D=0A #include "famfs_internal.=
h"=0D=0A=20=0D=0A+/******************************************************=
***************=0D=0A+ * vm_operations=0D=0A+ */=0D=0A+static vm_fault_t=0D=
=0A+__famfs_filemap_fault(=0D=0A+=09struct vm_fault *vmf,=0D=0A+=09unsign=
ed int order,=0D=0A+=09bool write_fault)=0D=0A+{=0D=0A+=09struct inode *i=
node =3D file_inode(vmf->vma->vm_file);=0D=0A+=09struct super_block *sb =3D=
 inode->i_sb;=0D=0A+=09struct famfs_fs_info *fsi =3D sb->s_fs_info;=0D=0A=
+=09vm_fault_t ret;=0D=0A+=09unsigned long pfn;=0D=0A+=0D=0A+=09if (fsi->=
deverror)=0D=0A+=09=09return VM_FAULT_SIGBUS;=0D=0A+=0D=0A+=09if (!IS_DAX=
(file_inode(vmf->vma->vm_file))) {=0D=0A+=09=09pr_err("%s: file not marke=
d IS_DAX!!\n", __func__);=0D=0A+=09=09return VM_FAULT_SIGBUS;=0D=0A+=09}=0D=
=0A+=0D=0A+=09if (write_fault) {=0D=0A+=09=09sb_start_pagefault(inode->i_=
sb);=0D=0A+=09=09file_update_time(vmf->vma->vm_file);=0D=0A+=09}=0D=0A+=0D=
=0A+=09ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&famfs_ioma=
p_ops */);=0D=0A+=09if (ret & VM_FAULT_NEEDDSYNC)=0D=0A+=09=09ret =3D dax=
_finish_sync_fault(vmf, order, pfn);=0D=0A+=0D=0A+=09if (write_fault)=0D=0A=
+=09=09sb_end_pagefault(inode->i_sb);=0D=0A+=0D=0A+=09return ret;=0D=0A+}=
=0D=0A+=0D=0A+static inline bool=0D=0A+famfs_is_write_fault(struct vm_fau=
lt *vmf)=0D=0A+{=0D=0A+=09return (vmf->flags & FAULT_FLAG_WRITE) &&=0D=0A=
+=09       (vmf->vma->vm_flags & VM_SHARED);=0D=0A+}=0D=0A+=0D=0A+static =
vm_fault_t=0D=0A+famfs_filemap_fault(struct vm_fault *vmf)=0D=0A+{=0D=0A+=
=09return __famfs_filemap_fault(vmf, 0, famfs_is_write_fault(vmf));=0D=0A=
+}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+famfs_filemap_huge_fault(struct v=
m_fault *vmf, unsigned int order)=0D=0A+{=0D=0A+=09return __famfs_filemap=
_fault(vmf, order, famfs_is_write_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+stati=
c vm_fault_t=0D=0A+famfs_filemap_mkwrite(struct vm_fault *vmf)=0D=0A+{=0D=
=0A+=09return __famfs_filemap_fault(vmf, 0, true);=0D=0A+}=0D=0A+=0D=0A+c=
onst struct vm_operations_struct famfs_file_vm_ops =3D {=0D=0A+=09.fault=09=
=09=3D famfs_filemap_fault,=0D=0A+=09.huge_fault=09=3D famfs_filemap_huge=
_fault,=0D=0A+=09.page_mkwrite=09=3D famfs_filemap_mkwrite,=0D=0A+=09.pfn=
_mkwrite=09=3D famfs_filemap_mkwrite,=0D=0A+};=0D=0A+=0D=0A /************=
*********************************************************=0D=0A  * file_o=
perations=0D=0A  */=0D=0A@@ -120,14 +190,51 @@ famfs_dax_write_iter(struc=
t kiocb *iocb, struct iov_iter *from)=0D=0A =09return rc;=0D=0A }=0D=0A=20=
=0D=0A+static int=0D=0A+famfs_file_mmap(struct file *file, struct vm_area=
_struct *vma)=0D=0A+{=0D=0A+=09struct inode *inode =3D file_inode(file);=0D=
=0A+=09struct super_block *sb =3D inode->i_sb;=0D=0A+=09struct famfs_fs_i=
nfo *fsi =3D sb->s_fs_info;=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09if (fsi-=
>deverror)=0D=0A+=09=09return -ENODEV;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Gat=
e shared-writable mappings on FAMFS_OPT_WRITE. Reject a mapping=0D=0A+=09=
 * that is already writable, and strip VM_MAYWRITE from a read-only=0D=0A=
+=09 * shared mapping so a later mprotect(PROT_WRITE) cannot upgrade it.=0D=
=0A+=09 * This is best effort: it does not revoke mappings that already e=
xist.=0D=0A+=09 */=0D=0A+=09if ((vma->vm_flags & VM_SHARED) &&=0D=0A+=09 =
   !famfs_opt_enabled(fsi, FAMFS_OPT_WRITE)) {=0D=0A+=09=09if (vma->vm_fl=
ags & VM_WRITE)=0D=0A+=09=09=09return -EPERM;=0D=0A+=09=09vm_flags_clear(=
vma, VM_MAYWRITE);=0D=0A+=09}=0D=0A+=0D=0A+=09rc =3D famfs_file_invalid(i=
node);=0D=0A+=09if (rc)=0D=0A+=09=09return (int)rc;=0D=0A+=0D=0A+=09file_=
accessed(file);=0D=0A+=09vma->vm_ops =3D &famfs_file_vm_ops;=0D=0A+=09vm_=
flags_set(vma, VM_HUGEPAGE);=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A cons=
t struct file_operations famfs_file_operations =3D {=0D=0A =09.owner     =
        =3D THIS_MODULE,=0D=0A=20=0D=0A+=09/* fmap metadata is immutable =
after MAP_CREATE, so MAP_SYNC is free */=0D=0A+=09.fop_flags=09   =3D FOP=
_MMAP_SYNC,=0D=0A+=0D=0A =09/* Custom famfs operations */=0D=0A =09.write=
_iter=09   =3D famfs_dax_write_iter,=0D=0A =09.read_iter=09   =3D famfs_d=
ax_read_iter,=0D=0A =09.unlocked_ioctl    =3D NULL /*famfs_file_ioctl*/,=0D=
=0A-=09.mmap=09=09   =3D NULL /* famfs_file_mmap */,=0D=0A+=09.mmap=09=09=
   =3D famfs_file_mmap,=0D=0A=20=0D=0A =09/* Force PMD alignment for mmap=
 */=0D=0A =09.get_unmapped_area =3D thp_get_unmapped_area,=0D=0A--=20=0D=0A=
2.53.0=0D=0A=0D=0A
