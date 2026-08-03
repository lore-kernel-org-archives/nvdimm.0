Received: from a8-208.smtp-out.amazonses.com (a8-208.smtp-out.amazonses.com [54.240.8.208])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97D13126A0;
	Mon,  3 Aug 2026 02:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724159; cv=none; b=WZfzExcG4zYrduqDGvffll9VrNbExwIBhhoA8eMBBlfYMeiwQ3DXe6J/cr94Dc15+eGM9ucBEfKx2QzYOq9yyTIYxh22Gz6RyAAGVR3TsrtDzOTCpiTA8mg6KPN2J9j+H3JeADtuytOAKrR6h4Gdwm9Z9/znLuFeAu7DiU5SJRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724159; c=relaxed/simple;
	bh=gleu6c5G+G91jRFWnBd/V15HiL6si5VlrTztoVW3hIQ=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=qc6MxwtD1aLIQhvI6OvDy8D2LLlh3H/RS9gD7KthfwhtsRh0IkNLAOuRxHMwqP6/bP+NWZEbu4j3BmsaKWIcYWnTe1mXr5XhaobNbBfttioRs1D8oqVUPCbY7F5YW8ZKfierDrndd9rWuFZnmxZvMoJlaE1inOihp2v0OJPKc94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=oV01nx7O; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=lGBhtbfc; arc=none smtp.client-ip=54.240.8.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="oV01nx7O";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="lGBhtbfc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724156;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=gleu6c5G+G91jRFWnBd/V15HiL6si5VlrTztoVW3hIQ=;
	b=oV01nx7OigbXjdReJtSU7yZxmbrpP9VWZOTUxi+2oxTKLsdzz51fGpmGVkTBXPRJ
	xu9vx1XDCS4DIQbmKkDmjPiQd6ut5V30qoo8bd6vzTWb+4qZtCnZoTiHnau1U9TLiyk
	iso01MZRVssnzdf8NpSm5CAsRHowG7epJmz2zy74=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724156;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=gleu6c5G+G91jRFWnBd/V15HiL6si5VlrTztoVW3hIQ=;
	b=lGBhtbfcMMnAlPog3/3h66jCjaQe6OBy096Ae66g5n6+bWLTfz0i6fuKL5BDB9v+
	47gWEoxz/Sb4doNwL8EkhYJ3q+gnemCC7r1il9TxCzrEBJ+Te426JbvBYaBuXcocHRc
	VwtMdnxwTkHkkJ/DgnXbfHQfmiJr13NKVLWmy8hM=
Subject: [PATCH V12 06/12] famfs: Introduce mmap and VM fault handling
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
Date: Mon, 3 Aug 2026 02:29:16 +0000
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
 <20260803022909.75856-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAADhds
Thread-Topic: [PATCH V12 06/12] famfs: Introduce mmap and VM fault handling
X-Wm-Sent-Timestamp: 1785724155
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc5743aef-39284cf3-b235-4a69-832f-c51b2198e8da-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.8.208

From: John Groves <john@groves.net>=0D=0A=0D=0AThis commit adds vm_operat=
ions, plus famfs_mmap() and fault handlers.=0D=0AIt is still missing ioma=
p_ops, iomap mapping resolution, and=0D=0Afamfs_ioctl() for setting up fi=
le-to-memory mappings.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves=
=2Enet>=0D=0A---=0D=0A fs/famfs/famfs_file.c | 101 ++++++++++++++++++++++=
+++++++++++++++++++-=0D=0A 1 file changed, 100 insertions(+), 1 deletion(=
-)=0D=0A=0D=0Adiff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=
=0Aindex e192b573c51f..678f2035fd5f 100644=0D=0A--- a/fs/famfs/famfs_file=
=2Ec=0D=0A+++ b/fs/famfs/famfs_file.c=0D=0A@@ -16,6 +16,75 @@=0D=0A=20=0D=
=0A #include "famfs_internal.h"=0D=0A=20=0D=0A+/*************************=
********************************************=0D=0A+ * vm_operations=0D=0A=
+ */=0D=0A+static vm_fault_t=0D=0A+__famfs_filemap_fault(struct vm_fault =
*vmf, unsigned int order,=0D=0A+=09=09      bool write_fault)=0D=0A+{=0D=0A=
+=09struct inode *inode =3D file_inode(vmf->vma->vm_file);=0D=0A+=09struc=
t super_block *sb =3D inode->i_sb;=0D=0A+=09struct famfs_fs_info *fsi =3D=
 sb->s_fs_info;=0D=0A+=09vm_fault_t ret;=0D=0A+=09unsigned long pfn;=0D=0A=
+=0D=0A+=09if (fsi->deverror)=0D=0A+=09=09return VM_FAULT_SIGBUS;=0D=0A+=0D=
=0A+=09if (!IS_DAX(file_inode(vmf->vma->vm_file))) {=0D=0A+=09=09pr_err("=
%s: file not marked IS_DAX!!\n", __func__);=0D=0A+=09=09return VM_FAULT_S=
IGBUS;=0D=0A+=09}=0D=0A+=0D=0A+=09if (write_fault) {=0D=0A+=09=09sb_start=
_pagefault(inode->i_sb);=0D=0A+=09=09file_update_time(vmf->vma->vm_file);=
=0D=0A+=09}=0D=0A+=0D=0A+=09ret =3D dax_iomap_fault(vmf, order, &pfn, NUL=
L, NULL /*&famfs_iomap_ops */);=0D=0A+=09if (ret & VM_FAULT_NEEDDSYNC)=0D=
=0A+=09=09ret =3D dax_finish_sync_fault(vmf, order, pfn);=0D=0A+=0D=0A+=09=
if (write_fault)=0D=0A+=09=09sb_end_pagefault(inode->i_sb);=0D=0A+=0D=0A+=
=09return ret;=0D=0A+}=0D=0A+=0D=0A+static inline bool=0D=0A+famfs_is_wri=
te_fault(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09return (vmf->flags & FAUL=
T_FLAG_WRITE) &&=0D=0A+=09       (vmf->vma->vm_flags & VM_SHARED);=0D=0A+=
}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+famfs_filemap_fault(struct vm_faul=
t *vmf)=0D=0A+{=0D=0A+=09return __famfs_filemap_fault(vmf, 0, famfs_is_wr=
ite_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+famfs_filem=
ap_huge_fault(struct vm_fault *vmf, unsigned int order)=0D=0A+{=0D=0A+=09=
return __famfs_filemap_fault(vmf, order, famfs_is_write_fault(vmf));=0D=0A=
+}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+famfs_filemap_mkwrite(struct vm_f=
ault *vmf)=0D=0A+{=0D=0A+=09return __famfs_filemap_fault(vmf, 0, true);=0D=
=0A+}=0D=0A+=0D=0A+const struct vm_operations_struct famfs_file_vm_ops =3D=
 {=0D=0A+=09.fault=09=09=3D famfs_filemap_fault,=0D=0A+=09.huge_fault=09=3D=
 famfs_filemap_huge_fault,=0D=0A+=09.map_pages=09=3D filemap_map_pages,=0D=
=0A+=09.page_mkwrite=09=3D famfs_filemap_mkwrite,=0D=0A+=09.pfn_mkwrite=09=
=3D famfs_filemap_mkwrite,=0D=0A+};=0D=0A+=0D=0A /***********************=
**********************************************=0D=0A  * file_operations=0D=
=0A  */=0D=0A@@ -117,6 +186,36 @@ famfs_dax_write_iter(struct kiocb *iocb=
, struct iov_iter *from)=0D=0A =09return rc;=0D=0A }=0D=0A=20=0D=0A+stati=
c int=0D=0A+famfs_file_mmap(struct file *file, struct vm_area_struct *vma=
)=0D=0A+{=0D=0A+=09struct inode *inode =3D file_inode(file);=0D=0A+=09str=
uct super_block *sb =3D inode->i_sb;=0D=0A+=09struct famfs_fs_info *fsi =3D=
 sb->s_fs_info;=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09if (fsi->deverror)=0D=
=0A+=09=09return -ENODEV;=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Gate shared-writ=
able mappings on FAMFS_OPT_WRITE. This is best=0D=0A+=09 * effort: cleari=
ng the bit blocks new writable mappings and write(),=0D=0A+=09 * but does=
 not revoke mappings that already exist.=0D=0A+=09 */=0D=0A+=09if ((vma->=
vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE) &&=0D=0A+=09    !famf=
s_opt_enabled(fsi, FAMFS_OPT_WRITE))=0D=0A+=09=09return -EPERM;=0D=0A+=0D=
=0A+=09rc =3D famfs_file_invalid(inode);=0D=0A+=09if (rc)=0D=0A+=09=09ret=
urn (int)rc;=0D=0A+=0D=0A+=09file_accessed(file);=0D=0A+=09vma->vm_ops =3D=
 &famfs_file_vm_ops;=0D=0A+=09vm_flags_set(vma, VM_HUGEPAGE);=0D=0A+=09re=
turn 0;=0D=0A+}=0D=0A+=0D=0A const struct file_operations famfs_file_oper=
ations =3D {=0D=0A =09.owner             =3D THIS_MODULE,=0D=0A=20=0D=0A@=
@ -124,7 +223,7 @@ const struct file_operations famfs_file_operations =3D=
 {=0D=0A =09.write_iter=09   =3D famfs_dax_write_iter,=0D=0A =09.read_ite=
r=09   =3D famfs_dax_read_iter,=0D=0A =09.unlocked_ioctl    =3D NULL /*fa=
mfs_file_ioctl*/,=0D=0A-=09.mmap=09=09   =3D NULL /* famfs_file_mmap */,=0D=
=0A+=09.mmap=09=09   =3D famfs_file_mmap,=0D=0A=20=0D=0A =09/* Force PMD =
alignment for mmap */=0D=0A =09.get_unmapped_area =3D thp_get_unmapped_ar=
ea,=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
