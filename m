Received: from a11-73.smtp-out.amazonses.com (a11-73.smtp-out.amazonses.com [54.240.11.73])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757423955C8;
	Mon, 20 Jul 2026 03:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519187; cv=none; b=BWBctrGVwtN1ntM685rDt/+CylywXegIcAjewpuYJ5sPcct56hXw6MNkRSgxP0Sl5rBB5570wp6U0n0LN1KAcLfKpKquROKiBN+uGk47yKnpw69CFpUpVKhYsZFkI+pXVHJ3H7X0UQM7zz6FLhmUivuqj94494CFS3nTgqolj2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519187; c=relaxed/simple;
	bh=WUQAulE2NrUB6yiAgOBtbJye1J7dC4Xp8xmeVneBwuw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=kO+DCcmteJjodWDKHpUddzRB6yAMh5lwSkFImP0/AEtRqOQP0btC2DsVkVKIg8hiZgaAh/U2sNLSQ0DDaFpkrlZ+1bw2rl0nttsYUYXt0nwTgkHQT+LPGyoFDdmgGuGIIrkZZmdTYJXjPXaauCoC+aBeGEDwOZcJU6imo82KU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=KkqhQ2O/; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=hxDBT/CU; arc=none smtp.client-ip=54.240.11.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="KkqhQ2O/";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="hxDBT/CU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519184;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=WUQAulE2NrUB6yiAgOBtbJye1J7dC4Xp8xmeVneBwuw=;
	b=KkqhQ2O/G+UwyJAi2Jd2H6jnVHx+AJMDBAeuHsqKu6LZYrS6w/MrU2v/eNwBTe+S
	0GisVjyj3td0o2khsWj9PpRVz3rtdyWVwZ65AtdvnWb7oQGfTTSnsVALjpG3btEhjNn
	ovGMGzcLwm1oX29dK0C4Snae8cNIGv+LYC6aR/2U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519184;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=WUQAulE2NrUB6yiAgOBtbJye1J7dC4Xp8xmeVneBwuw=;
	b=hxDBT/CUFAoyxyjbIkjrmS2tvurkd0xahzdaWXIdo5o2f9NJQZt1g5nZPoZQyo+G
	Ng2zQ92PBCP4zkiA3CIAo+F5810VaxJCdjJl4i90kuN2VC9C0NtdDaTW5rJtazGl+lM
	DZhaZ8PScSbeg69js3j87hM7F2aX4u8Vpan2/19Q=
Subject: [PATCH V11 6/9] famfs_fuse: Plumb dax iomap and fuse read/write/mmap
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
Date: Mon, 20 Jul 2026 03:46:24 +0000
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
 <20260720034616.68834-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAAFDjd
Thread-Topic: [PATCH V11 6/9] famfs_fuse: Plumb dax iomap and fuse
 read/write/mmap
X-Wm-Sent-Timestamp: 1784519183
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da1cf3d-bb04c043-a09f-4925-bf63-eb92452871e5-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.73

From: John Groves <john@groves.net>=0D=0A=0D=0AFill in read/write/mmap ha=
ndling for famfs files using the dev_dax_iomap=0D=0Ainterface, the same p=
ath xfs uses in fs-dax mode.=0D=0A=0D=0A- Read/write go through famfs_fus=
e_[read|write]_iter() via dax_iomap_rw()=0D=0A  to fsdev_dax.=0D=0A- Mmap=
 is handled by famfs_fuse_mmap().=0D=0A- Faults are handled by famfs_file=
map_fault() via dax_iomap_fault() to=0D=0A  fsdev_dax.=0D=0A- File-offset=
-to-dax-offset resolution is handled by=0D=0A  famfs_fuse_iomap_begin(), =
which uses the file's fmap to resolve a=0D=0A  (file, offset) to an offse=
t on a dax device via=0D=0A  famfs_fileofs_to_daxofs().=0D=0A=0D=0ASigned=
-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse/famfs.c  | =
337 ++++++++++++++++++++++++++++++++++++++++++++++-=0D=0A fs/fuse/file.c =
  |  18 ++-=0D=0A fs/fuse/fuse_i.h |  19 +++=0D=0A 3 files changed, 371 i=
nsertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/fs/fuse/famfs.c b/fs=
/fuse/famfs.c=0D=0Aindex a2a7dd631dc0..ac56317944d9 100644=0D=0A--- a/fs/=
fuse/famfs.c=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -580,7 +580,342 @@ famfs_=
file_init_dax(=0D=0A =09return rc;=0D=0A }=0D=0A=20=0D=0A-#define FMAP_BU=
FSIZE PAGE_SIZE=0D=0A+/**************************************************=
*******************=0D=0A+ * iomap_operations=0D=0A+ *=0D=0A+ * This stuf=
f uses the iomap (dax-related) helpers to resolve file offsets to=0D=0A+ =
* offsets within a dax device.=0D=0A+ */=0D=0A+=0D=0A+static int famfs_fi=
le_bad(struct inode *inode);=0D=0A+=0D=0A+/**=0D=0A+ * famfs_fileofs_to_d=
axofs() - Resolve (file, offset, len) to (daxdev, offset, len)=0D=0A+ *=0D=
=0A+ * This function is called by famfs_fuse_iomap_begin() to resolve an =
offset in a=0D=0A+ * file to an offset in a dax device. This is upcalled =
from dax from calls to=0D=0A+ * both  * dax_iomap_fault() and dax_iomap_r=
w(). Dax finishes the job resolving=0D=0A+ * a fault to a specific physic=
al page (the fault case) or doing a memcpy=0D=0A+ * variant (the rw case)=
=0D=0A+ *=0D=0A+ * Pages can be PTE (4k), PMD (2MiB) or (theoretically) P=
uD (1GiB)=0D=0A+ * (these sizes are for X86; may vary on other cpu archit=
ectures=0D=0A+ *=0D=0A+ * @inode:  The file where the fault occurred=0D=0A=
+ * @iomap:       To be filled in to indicate where to find the right mem=
ory,=0D=0A+ *               relative  to a dax device.=0D=0A+ * @file_off=
set: Within the file where the fault occurred (will be page boundary)=0D=0A=
+ * @len:         The length of the faulted mapping (will be a page multi=
ple)=0D=0A+ *               (will be trimmed in *iomap if it's disjoint i=
n the extent list)=0D=0A+ * @flags:       flags passed to famfs_fuse_ioma=
p_begin(), and sent back via=0D=0A+ *               struct iomap=0D=0A+ *=
=0D=0A+ * Return values: 0 on success, with the result in the modified @i=
omap struct.=0D=0A+ *                -EIO if (file_offset, len) cannot be=
 resolved to a dax extent,=0D=0A+ *                which includes access =
past EOF (the caller turns this into a=0D=0A+ *                short read=
/write or a SIGBUS).=0D=0A+ */=0D=0A+static int=0D=0A+famfs_fileofs_to_da=
xofs(struct inode *inode, struct iomap *iomap,=0D=0A+=09=09=09loff_t file=
_offset, off_t len, unsigned int flags)=0D=0A+{=0D=0A+=09struct fuse_inod=
e *fi =3D get_fuse_inode(inode);=0D=0A+=09struct famfs_file_meta *meta =3D=
 fi->famfs_meta;=0D=0A+=09struct fuse_conn *fc =3D get_fuse_conn(inode);=0D=
=0A+=09loff_t local_offset =3D file_offset;=0D=0A+=09u64 i;=0D=0A+=0D=0A+=
=09if (!fc->dax_devlist) {=0D=0A+=09=09pr_err("%s: null dax_devlist\n", _=
_func__);=0D=0A+=09=09goto err_out;=0D=0A+=09}=0D=0A+=0D=0A+=09if (famfs_=
file_bad(inode))=0D=0A+=09=09goto err_out;=0D=0A+=0D=0A+=09iomap->offset =
=3D file_offset;=0D=0A+=0D=0A+=09if (meta->ext_shift) {=0D=0A+=09=09/*=0D=
=0A+=09=09 * Uniform extent size (detected at parse time): the containing=
=0D=0A+=09=09 * extent index is a shift of the file offset, so resolve in=
=0D=0A+=09=09 * O(1) instead of walking the extent list.=0D=0A+=09=09 */=0D=
=0A+=09=09u64 ext_size =3D 1ULL << meta->ext_shift;=0D=0A+=0D=0A+=09=09i =
=3D file_offset >> meta->ext_shift;=0D=0A+=09=09local_offset =3D file_off=
set & (ext_size - 1);=0D=0A+=09} else {=0D=0A+=09=09/* Single extent or n=
on-uniform list: walk it */=0D=0A+=09=09for (i =3D 0; i < meta->fm_nexten=
ts; i++) {=0D=0A+=09=09=09if (local_offset < meta->se[i].ext_len)=0D=0A+=09=
=09=09=09break;=0D=0A+=09=09=09local_offset -=3D meta->se[i].ext_len;=0D=0A=
+=09=09}=0D=0A+=09}=0D=0A+=0D=0A+=09/* local_offset is now the offset wit=
hin extent i (if i is in range) */=0D=0A+=09if (i < meta->fm_nextents && =
local_offset < meta->se[i].ext_len) {=0D=0A+=09=09loff_t dax_ext_offset  =
  =3D meta->se[i].ext_offset;=0D=0A+=09=09loff_t dax_ext_len       =3D me=
ta->se[i].ext_len;=0D=0A+=09=09u64 daxdev_idx           =3D meta->se[i].d=
ev_index;=0D=0A+=09=09loff_t ext_len_remainder =3D dax_ext_len - local_of=
fset;=0D=0A+=09=09struct famfs_daxdev *dd;=0D=0A+=0D=0A+=09=09if (daxdev_=
idx >=3D fc->dax_devlist->nslots) {=0D=0A+=09=09=09pr_err("%s: daxdev_idx=
 %llu >=3D nslots %d\n",=0D=0A+=09=09=09       __func__, daxdev_idx, fc->=
dax_devlist->nslots);=0D=0A+=09=09=09goto err_out;=0D=0A+=09=09}=0D=0A+=0D=
=0A+=09=09dd =3D &fc->dax_devlist->devlist[daxdev_idx];=0D=0A+=0D=0A+=09=09=
iomap->addr    =3D dax_ext_offset + local_offset;=0D=0A+=09=09iomap->offs=
et  =3D file_offset;=0D=0A+=09=09iomap->length  =3D min_t(loff_t, len, ex=
t_len_remainder);=0D=0A+=09=09iomap->dax_dev =3D dd->devp;=0D=0A+=09=09io=
map->type    =3D IOMAP_MAPPED;=0D=0A+=09=09iomap->flags   =3D flags;=0D=0A=
+=09=09return 0;=0D=0A+=09}=0D=0A+=0D=0A+ err_out:=0D=0A+=09/*=0D=0A+=09 =
* We fell out the end of the extent list, i.e. the access is past EOF.=0D=
=0A+=09 * This is a normal, unprivileged-reachable condition (e.g. a faul=
t in=0D=0A+=09 * the tail of a mapping that extends past EOF), so log at =
debug level.=0D=0A+=09 * The specific error cases above (null dax_devlist=
, bad daxdev index)=0D=0A+=09 * have already logged at error level before=
 jumping here.=0D=0A+=09 */=0D=0A+=09pr_debug("%s: could not resolve file=
_offset %lld (past EOF=3F)\n",=0D=0A+=09=09 __func__, (long long)file_off=
set);=0D=0A+=0D=0A+=09/*=0D=0A+=09 * Return a zero-length mapping and -EI=
O. dax turns this into a short=0D=0A+=09 * read/write or a SIGBUS rather =
than touching dax memory.=0D=0A+=09 */=0D=0A+=09iomap->addr    =3D 0; /* =
there is no valid dax device offset */=0D=0A+=09iomap->offset  =3D file_o=
ffset; /* file offset */=0D=0A+=09iomap->length  =3D 0; /* this had bette=
r result in no access to dax mem */=0D=0A+=09iomap->dax_dev =3D NULL;=0D=0A=
+=09iomap->type    =3D IOMAP_MAPPED;=0D=0A+=09iomap->flags   =3D flags;=0D=
=0A+=0D=0A+=09return -EIO;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_fuse_i=
omap_begin() - Handler for iomap_begin upcall from dax=0D=0A+ *=0D=0A+ * =
This function is pretty simple because files are=0D=0A+ * * never partial=
ly allocated=0D=0A+ * * never have holes (never sparse)=0D=0A+ * * never =
"allocate on write"=0D=0A+ *=0D=0A+ * @inode:  inode for the file being a=
ccessed=0D=0A+ * @offset: offset within the file=0D=0A+ * @length: Length=
 being accessed at offset=0D=0A+ * @flags:  flags to be retured via struc=
t iomap=0D=0A+ * @iomap:  iomap struct to be filled in, resolving (offset=
, length) to=0D=0A+ *          (daxdev, offset, len)=0D=0A+ * @srcmap: so=
urce mapping if it is a COW operation (which it is not here)=0D=0A+ */=0D=
=0A+static int=0D=0A+famfs_fuse_iomap_begin(struct inode *inode, loff_t o=
ffset, loff_t length,=0D=0A+=09=09  unsigned int flags, struct iomap *iom=
ap, struct iomap *srcmap)=0D=0A+{=0D=0A+=09return famfs_fileofs_to_daxofs=
(inode, iomap, offset, length, flags);=0D=0A+}=0D=0A+=0D=0A+/* Note: We n=
ever need a special set of write_iomap_ops because famfs never=0D=0A+ * p=
erforms allocation on write.=0D=0A+ */=0D=0A+const struct iomap_ops famfs=
_iomap_ops =3D {=0D=0A+=09.iomap_begin=09=09=3D famfs_fuse_iomap_begin,=0D=
=0A+};=0D=0A+=0D=0A+/****************************************************=
*****************=0D=0A+ * vm_operations=0D=0A+ */=0D=0A+static vm_fault_=
t=0D=0A+__famfs_fuse_filemap_fault(struct vm_fault *vmf, unsigned int ord=
er,=0D=0A+=09=09      bool write_fault)=0D=0A+{=0D=0A+=09struct inode *in=
ode =3D file_inode(vmf->vma->vm_file);=0D=0A+=09vm_fault_t ret;=0D=0A+=09=
unsigned long pfn;=0D=0A+=0D=0A+=09if (!IS_DAX(file_inode(vmf->vma->vm_fi=
le))) {=0D=0A+=09=09pr_err("%s: file not marked IS_DAX!!\n", __func__);=0D=
=0A+=09=09return VM_FAULT_SIGBUS;=0D=0A+=09}=0D=0A+=0D=0A+=09if (write_fa=
ult) {=0D=0A+=09=09sb_start_pagefault(inode->i_sb);=0D=0A+=09=09file_upda=
te_time(vmf->vma->vm_file);=0D=0A+=09}=0D=0A+=0D=0A+=09ret =3D dax_iomap_=
fault(vmf, order, &pfn, NULL, &famfs_iomap_ops);=0D=0A+=09if (ret & VM_FA=
ULT_NEEDDSYNC)=0D=0A+=09=09ret =3D dax_finish_sync_fault(vmf, order, pfn)=
;=0D=0A+=0D=0A+=09if (write_fault)=0D=0A+=09=09sb_end_pagefault(inode->i_=
sb);=0D=0A+=0D=0A+=09return ret;=0D=0A+}=0D=0A+=0D=0A+static inline bool=0D=
=0A+famfs_is_write_fault(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09return (v=
mf->flags & FAULT_FLAG_WRITE) &&=0D=0A+=09       (vmf->vma->vm_flags & VM=
_SHARED);=0D=0A+}=0D=0A+=0D=0A+static vm_fault_t=0D=0A+famfs_filemap_faul=
t(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09return __famfs_fuse_filemap_faul=
t(vmf, 0, famfs_is_write_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+static vm_faul=
t_t=0D=0A+famfs_filemap_huge_fault(struct vm_fault *vmf, unsigned int ord=
er)=0D=0A+{=0D=0A+=09return __famfs_fuse_filemap_fault(vmf, order,=0D=0A+=
=09=09=09=09famfs_is_write_fault(vmf));=0D=0A+}=0D=0A+=0D=0A+static vm_fa=
ult_t=0D=0A+famfs_filemap_mkwrite(struct vm_fault *vmf)=0D=0A+{=0D=0A+=09=
return __famfs_fuse_filemap_fault(vmf, 0, true);=0D=0A+}=0D=0A+=0D=0A+con=
st struct vm_operations_struct famfs_file_vm_ops =3D {=0D=0A+=09.fault=09=
=09=3D famfs_filemap_fault,=0D=0A+=09.huge_fault=09=3D famfs_filemap_huge=
_fault,=0D=0A+=09.map_pages=09=3D filemap_map_pages,=0D=0A+=09.page_mkwri=
te=09=3D famfs_filemap_mkwrite,=0D=0A+=09.pfn_mkwrite=09=3D famfs_filemap=
_mkwrite,=0D=0A+};=0D=0A+=0D=0A+/****************************************=
*****************************=0D=0A+ * file_operations=0D=0A+ */=0D=0A+=0D=
=0A+/**=0D=0A+ * famfs_file_bad() - Check for files that aren't in a vali=
d state=0D=0A+ *=0D=0A+ * @inode: inode=0D=0A+ *=0D=0A+ * Returns: 0=3Dsu=
ccess=0D=0A+ *          -errno=3Dfailure=0D=0A+ */=0D=0A+static int=0D=0A=
+famfs_file_bad(struct inode *inode)=0D=0A+{=0D=0A+=09struct fuse_inode *=
fi =3D get_fuse_inode(inode);=0D=0A+=09struct famfs_file_meta *meta =3D f=
i->famfs_meta;=0D=0A+=09size_t i_size =3D i_size_read(inode);=0D=0A+=0D=0A=
+=09if (!meta) {=0D=0A+=09=09pr_err("%s: un-initialized famfs file\n", __=
func__);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (meta->error) {=0D=
=0A+=09=09pr_debug("%s: previously detected metadata errors\n", __func__)=
;=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (i_size !=3D meta->file=
_size) {=0D=0A+=09=09pr_warn("%s: i_size overwritten from %ld to %ld\n",=0D=
=0A+=09=09       __func__, meta->file_size, i_size);=0D=0A+=09=09meta->er=
ror =3D true;=0D=0A+=09=09return -ENXIO;=0D=0A+=09}=0D=0A+=09if (!IS_DAX(=
inode)) {=0D=0A+=09=09pr_debug("%s: inode %llx IS_DAX is false\n",=0D=0A+=
=09=09=09 __func__, (u64)inode);=0D=0A+=09=09return -ENXIO;=0D=0A+=09}=0D=
=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+static ssize_t=0D=0A+famfs_fuse_rw_=
prep(struct kiocb *iocb, struct iov_iter *ubuf)=0D=0A+{=0D=0A+=09struct i=
node *inode =3D iocb->ki_filp->f_mapping->host;=0D=0A+=09size_t i_size =3D=
 i_size_read(inode);=0D=0A+=09size_t count =3D iov_iter_count(ubuf);=0D=0A=
+=09size_t max_count;=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09rc =3D famfs_f=
ile_bad(inode);=0D=0A+=09if (rc)=0D=0A+=09=09return (ssize_t)rc;=0D=0A+=0D=
=0A+=09/* Avoid unsigned underflow if position is past EOF */=0D=0A+=09if=
 (iocb->ki_pos >=3D i_size)=0D=0A+=09=09max_count =3D 0;=0D=0A+=09else=0D=
=0A+=09=09max_count =3D i_size - iocb->ki_pos;=0D=0A+=0D=0A+=09if (count =
> max_count)=0D=0A+=09=09iov_iter_truncate(ubuf, max_count);=0D=0A+=0D=0A=
+=09if (!iov_iter_count(ubuf))=0D=0A+=09=09return 0;=0D=0A+=0D=0A+=09retu=
rn rc;=0D=0A+}=0D=0A+=0D=0A+ssize_t=0D=0A+famfs_fuse_read_iter(struct kio=
cb *iocb, struct iov_iter=09*to)=0D=0A+{=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A=
+=09rc =3D famfs_fuse_rw_prep(iocb, to);=0D=0A+=09if (rc)=0D=0A+=09=09ret=
urn rc;=0D=0A+=0D=0A+=09if (!iov_iter_count(to))=0D=0A+=09=09return 0;=0D=
=0A+=0D=0A+=09rc =3D dax_iomap_rw(iocb, to, &famfs_iomap_ops);=0D=0A+=0D=0A=
+=09file_accessed(iocb->ki_filp);=0D=0A+=09return rc;=0D=0A+}=0D=0A+=0D=0A=
+ssize_t=0D=0A+famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter =
*from)=0D=0A+{=0D=0A+=09ssize_t rc;=0D=0A+=0D=0A+=09rc =3D famfs_fuse_rw_=
prep(iocb, from);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=0A+=0D=0A+=09=
if (!iov_iter_count(from))=0D=0A+=09=09return 0;=0D=0A+=0D=0A+=09return d=
ax_iomap_rw(iocb, from, &famfs_iomap_ops);=0D=0A+}=0D=0A+=0D=0A+int=0D=0A=
+famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma)=0D=0A+{=0D=
=0A+=09struct inode *inode =3D file_inode(file);=0D=0A+=09ssize_t rc;=0D=0A=
+=0D=0A+=09rc =3D famfs_file_bad(inode);=0D=0A+=09if (rc)=0D=0A+=09=09ret=
urn rc;=0D=0A+=0D=0A+=09file_accessed(file);=0D=0A+=09vma->vm_ops =3D &fa=
mfs_file_vm_ops;=0D=0A+=09vm_flags_set(vma, VM_HUGEPAGE);=0D=0A+=09return=
 0;=0D=0A+}=0D=0A=20=0D=0A #define FMAP_BUFSIZE_INIT PAGE_SIZE=0D=0A /*=0D=
=0Adiff --git a/fs/fuse/file.c b/fs/fuse/file.c=0D=0Aindex b4e7b6a64587..=
2435a79cbb4a 100644=0D=0A--- a/fs/fuse/file.c=0D=0A+++ b/fs/fuse/file.c=0D=
=0A@@ -1859,6 +1859,8 @@ static ssize_t fuse_file_read_iter(struct kiocb =
*iocb, struct iov_iter *to)=0D=0A=20=0D=0A =09if (FUSE_IS_VIRTIO_DAX(fi))=
=0D=0A =09=09return fuse_dax_read_iter(iocb, to);=0D=0A+=09if (fuse_file_=
famfs(fi))=0D=0A+=09=09return famfs_fuse_read_iter(iocb, to);=0D=0A=20=0D=
=0A =09/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */=0D=0A =09if (ff-=
>open_flags & FOPEN_DIRECT_IO)=0D=0A@@ -1881,6 +1883,8 @@ static ssize_t =
fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)=0D=0A=20=0D=
=0A =09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09return fuse_dax_write_iter=
(iocb, from);=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=09return famfs_=
fuse_write_iter(iocb, from);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO overrid=
es FOPEN_PASSTHROUGH */=0D=0A =09if (ff->open_flags & FOPEN_DIRECT_IO)=0D=
=0A@@ -1896,9 +1900,13 @@ static ssize_t fuse_splice_read(struct file *in=
, loff_t *ppos,=0D=0A =09=09=09=09unsigned int flags)=0D=0A {=0D=0A =09st=
ruct fuse_file *ff =3D in->private_data;=0D=0A+=09struct inode *inode =3D=
 file_inode(in);=0D=0A+=09struct fuse_inode *fi =3D get_fuse_inode(inode)=
;=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */=0D=0A=
-=09if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))=
=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=09return -EIO; /* famfs does=
 not use the page cache... */=0D=0A+=09else if (fuse_file_passthrough(ff)=
 && !(ff->open_flags & FOPEN_DIRECT_IO))=0D=0A =09=09return fuse_passthro=
ugh_splice_read(in, ppos, pipe, len, flags);=0D=0A =09else=0D=0A =09=09re=
turn filemap_splice_read(in, ppos, pipe, len, flags);=0D=0A@@ -1908,9 +19=
16,13 @@ static ssize_t fuse_splice_write(struct pipe_inode_info *pipe, s=
truct file *out,=0D=0A =09=09=09=09 loff_t *ppos, size_t len, unsigned in=
t flags)=0D=0A {=0D=0A =09struct fuse_file *ff =3D out->private_data;=0D=0A=
+=09struct inode *inode =3D file_inode(out);=0D=0A+=09struct fuse_inode *=
fi =3D get_fuse_inode(inode);=0D=0A=20=0D=0A =09/* FOPEN_DIRECT_IO overri=
des FOPEN_PASSTHROUGH */=0D=0A-=09if (fuse_file_passthrough(ff) && !(ff->=
open_flags & FOPEN_DIRECT_IO))=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=
=09return -EIO; /* famfs does not use the page cache... */=0D=0A+=09else =
if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))=0D=0A=
 =09=09return fuse_passthrough_splice_write(pipe, out, ppos, len, flags);=
=0D=0A =09else=0D=0A =09=09return iter_file_splice_write(pipe, out, ppos,=
 len, flags);=0D=0A@@ -2420,6 +2432,8 @@ static int fuse_file_mmap(struct=
 file *file, struct vm_area_struct *vma)=0D=0A =09/* DAX mmap is superior=
 to direct_io mmap */=0D=0A =09if (FUSE_IS_VIRTIO_DAX(fi))=0D=0A =09=09re=
turn fuse_dax_mmap(file, vma);=0D=0A+=09if (fuse_file_famfs(fi))=0D=0A+=09=
=09return famfs_fuse_mmap(file, vma);=0D=0A=20=0D=0A =09/*=0D=0A =09 * If=
 inode is in passthrough io mode, because it has some file open=0D=0Adiff=
 --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 5394aae9dbac..728=
1fb8b6402 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=
=0A@@ -1355,6 +1355,9 @@ extern void fuse_sysctl_unregister(void);=0D=0A =
int famfs_file_init_dax(struct fuse_mount *fm,=0D=0A =09=09=09struct inod=
e *inode, void *fmap_buf,=0D=0A =09=09=09size_t fmap_size);=0D=0A+ssize_t=
 famfs_fuse_write_iter(struct kiocb *iocb, struct iov_iter *from);=0D=0A+=
ssize_t famfs_fuse_read_iter(struct kiocb *iocb, struct iov_iter=09*to);=0D=
=0A+int famfs_fuse_mmap(struct file *file, struct vm_area_struct *vma);=0D=
=0A void __famfs_meta_free(void *map);=0D=0A=20=0D=0A void famfs_teardown=
(struct fuse_conn *fc);=0D=0A@@ -1400,6 +1403,22 @@ static inline void fa=
mfs_teardown(struct fuse_conn *fc)=0D=0A {=0D=0A }=0D=0A=20=0D=0A+static =
inline ssize_t famfs_fuse_write_iter(struct kiocb *iocb,=0D=0A+=09=09=09=09=
=09    struct iov_iter *to)=0D=0A+{=0D=0A+=09return -ENODEV;=0D=0A+}=0D=0A=
+static inline ssize_t famfs_fuse_read_iter(struct kiocb *iocb,=0D=0A+=09=
=09=09=09=09   struct iov_iter *to)=0D=0A+{=0D=0A+=09return -ENODEV;=0D=0A=
+}=0D=0A+static inline int famfs_fuse_mmap(struct file *file,=0D=0A+=09=09=
=09=09  struct vm_area_struct *vma)=0D=0A+{=0D=0A+=09return -ENODEV;=0D=0A=
+}=0D=0A+=0D=0A static inline struct fuse_backing *famfs_meta_set(struct =
fuse_inode *fi,=0D=0A =09=09=09=09=09=09  void *meta)=0D=0A {=0D=0A--=20=0D=
=0A2.53.0=0D=0A=0D=0A
