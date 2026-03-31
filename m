Received: from a11-127.smtp-out.amazonses.com (a11-127.smtp-out.amazonses.com [54.240.11.127])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC4D3E122C
	for <nvdimm@lists.linux.dev>; Tue, 31 Mar 2026 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960726; cv=none; b=CcC4hXbaccnFtx3OpO2KC5v/+0/RoGODl27z0SDlYdSTphGOJWX6q3hiZyRNWjimBxSeMNvopBvquBJz65gf8/VxCduKWilY4uIj/tmd/7nVbl6DCwWKhN+994I98T1kriq+B0ZM1965gO2F1WyebAKhzSCf+NsbKScnQHSU0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960726; c=relaxed/simple;
	bh=IOcHZpAlYQmnHnzsQY3zzU5HgtL7+fyx0wKm4O2scXM=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=S5Fnu9HhvBhWcs5V7O7MONcCUERxxY1RgPqPJyI22EqTGEVhD+gvYiUNlh4FruAHZsu4sYju48dOIgwYH06ytenYX+AMF4MBXoJBAHssBX9fvhKkpDKOqrdVa9dO/P3s20Nr/WZDwU92BK1sg/kZLWlDbGI/vhdwbL3zZpmksPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=E1fPGChC; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=fjq+pKwA; arc=none smtp.client-ip=54.240.11.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="E1fPGChC";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fjq+pKwA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774960723;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=IOcHZpAlYQmnHnzsQY3zzU5HgtL7+fyx0wKm4O2scXM=;
	b=E1fPGChCNgblGP44rg3GyflAFBCxfvxd7sYR1ix1VwERkP9Ub3eUxqQrobACm9gk
	D3I+y93RhBKo//pMaV8vXPpY6VLVgEn2wNU+Qmx8xJF6wlil9dtxXK4QCOWByoiDhUm
	LZnFVLWzwQg2xV6UayZFl5ZzOPArB1sYr3QMmmNQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774960723;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=IOcHZpAlYQmnHnzsQY3zzU5HgtL7+fyx0wKm4O2scXM=;
	b=fjq+pKwA49Sj0fqiYoiYe89m9ZDx2nbOGH1MVegFyhD86JL0t4bYW6rXY7eDY87J
	yVfnY+X+VblcpKxfHcNWP2P4AE3XIIPrZvQY0duRfSd7wZu7Hf/GvEGz7lD5id7wrO5
	+9JGaMwYoAIZK8aKRBXcLJyl36r1iGrSdDzteoTc=
Subject: [PATCH V10 04/10] famfs_fuse: Create files with famfs fmaps
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
Date: Tue, 31 Mar 2026 12:38:43 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
References: 
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com> 
 <20260331123835.35155-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcwQtOHndpAxOuTWKDY5V1K0DHfQ==
Thread-Topic: [PATCH V10 04/10] famfs_fuse: Create files with famfs fmaps
X-Wm-Sent-Timestamp: 1774960722
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d43e74528-d0ec811e-b3dc-4eaf-b9f3-c9c7c7ffce96-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.31-54.240.11.127

From: John Groves <john@groves.net>=0D=0A=0D=0AOn completion of GET_FMAP =
message/response, setup the full famfs=0D=0Ametadata such that it's possi=
ble to handle read/write/mmap directly to=0D=0Adax. Note that the devdax_=
iomap plumbing is not in yet...=0D=0A=0D=0A* Add famfs_kfmap.h: in-memory=
 structures for resolving famfs file maps=0D=0A  (fmaps) to dax.=0D=0A* f=
amfs.c: allocate, initialize and free fmaps=0D=0A* inode.c: only allow fa=
mfs mode if the fuse server has CAP_SYS_RAWIO=0D=0A* Update MAINTAINERS f=
or the new file.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=
=0A---=0D=0A MAINTAINERS               |   1 +=0D=0A fs/fuse/famfs.c     =
      | 339 +++++++++++++++++++++++++++++++++++++-=0D=0A fs/fuse/famfs_kf=
map.h     |  67 ++++++++=0D=0A fs/fuse/fuse_i.h          |   8 +-=0D=0A f=
s/fuse/inode.c           |  20 ++-=0D=0A include/uapi/linux/fuse.h |  56 =
+++++++=0D=0A 6 files changed, 481 insertions(+), 10 deletions(-)=0D=0A c=
reate mode 100644 fs/fuse/famfs_kfmap.h=0D=0A=0D=0Adiff --git a/MAINTAINE=
RS b/MAINTAINERS=0D=0Aindex a789394552a2..4edb56afb947 100644=0D=0A--- a/=
MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A@@ -10530,6 +10530,7 @@ L:=09linu=
x-cxl@vger.kernel.org=0D=0A L:=09linux-fsdevel@vger.kernel.org=0D=0A S:=09=
Supported=0D=0A F:=09fs/fuse/famfs.c=0D=0A+F:=09fs/fuse/famfs_kfmap.h=0D=0A=
=20=0D=0A FUTEX SUBSYSTEM=0D=0A M:=09Thomas Gleixner <tglx@kernel.org>=0D=
=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c=0D=0Aindex d238d853afa8=
=2E.ac52e54e2cb5 100644=0D=0A--- a/fs/fuse/famfs.c=0D=0A+++ b/fs/fuse/fam=
fs.c=0D=0A@@ -18,9 +18,339 @@=0D=0A #include <linux/namei.h>=0D=0A #inclu=
de <linux/string.h>=0D=0A=20=0D=0A+#include "famfs_kfmap.h"=0D=0A #includ=
e "fuse_i.h"=0D=0A=20=0D=0A=20=0D=0A+/***********************************=
****************************************/=0D=0A+=0D=0A+void __famfs_meta_=
free(void *famfs_meta)=0D=0A+{=0D=0A+=09struct famfs_file_meta *fmap =3D =
famfs_meta;=0D=0A+=0D=0A+=09if (!fmap)=0D=0A+=09=09return;=0D=0A+=0D=0A+=09=
switch (fmap->fm_extent_type) {=0D=0A+=09case SIMPLE_DAX_EXTENT:=0D=0A+=09=
=09kfree(fmap->se);=0D=0A+=09=09break;=0D=0A+=09case INTERLEAVED_EXTENT:=0D=
=0A+=09=09if (fmap->ie) {=0D=0A+=09=09=09for (int i =3D 0; i < fmap->fm_n=
iext; i++)=0D=0A+=09=09=09=09kfree(fmap->ie[i].ie_strips);=0D=0A+=09=09}=0D=
=0A+=09=09kfree(fmap->ie);=0D=0A+=09=09break;=0D=0A+=09default:=0D=0A+=09=
=09pr_err("%s: invalid fmap type\n", __func__);=0D=0A+=09=09break;=0D=0A+=
=09}=0D=0A+=0D=0A+=09kfree(fmap);=0D=0A+}=0D=0A+DEFINE_FREE(__famfs_meta_=
free, void *, if (_T) __famfs_meta_free(_T))=0D=0A+=0D=0A+static int=0D=0A=
+famfs_check_ext_alignment(struct famfs_meta_simple_ext *se)=0D=0A+{=0D=0A=
+=09int errs =3D 0;=0D=0A+=0D=0A+=09if (se->dev_index !=3D 0)=0D=0A+=09=09=
errs++;=0D=0A+=0D=0A+=09/* TODO: pass in alignment so we can support the =
other page sizes */=0D=0A+=09if (!IS_ALIGNED(se->ext_offset, PMD_SIZE))=0D=
=0A+=09=09errs++;=0D=0A+=0D=0A+=09if (!IS_ALIGNED(se->ext_len, PMD_SIZE))=
=0D=0A+=09=09errs++;=0D=0A+=0D=0A+=09return errs;=0D=0A+}=0D=0A+=0D=0A+/*=
*=0D=0A+ * famfs_fuse_meta_alloc() - Allocate famfs file metadata=0D=0A+ =
* @fmap_buf:  fmap buffer from fuse server=0D=0A+ * @fmap_buf_size: size =
of fmap buffer=0D=0A+ * @metap:         pointer where 'struct famfs_file_=
meta' is returned=0D=0A+ *=0D=0A+ * Returns: 0=3Dsuccess=0D=0A+ *        =
  -errno=3Dfailure=0D=0A+ */=0D=0A+static int=0D=0A+famfs_fuse_meta_alloc=
(=0D=0A+=09void *fmap_buf,=0D=0A+=09size_t fmap_buf_size,=0D=0A+=09struct=
 famfs_file_meta **metap)=0D=0A+{=0D=0A+=09struct fuse_famfs_fmap_header =
*fmh;=0D=0A+=09size_t extent_total =3D 0;=0D=0A+=09size_t next_offset =3D=
 0;=0D=0A+=09int errs =3D 0;=0D=0A+=09int i, j;=0D=0A+=0D=0A+=09fmh =3D f=
map_buf;=0D=0A+=0D=0A+=09/* Move past fmh in fmap_buf */=0D=0A+=09next_of=
fset +=3D sizeof(*fmh);=0D=0A+=09if (next_offset > fmap_buf_size) {=0D=0A=
+=09=09pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",=0D=0A+=09=
=09       __func__, __LINE__, next_offset, fmap_buf_size);=0D=0A+=09=09re=
turn -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (fmh->nextents < 1) {=0D=0A+=09=
=09pr_err("%s: nextents %d < 1\n", __func__, fmh->nextents);=0D=0A+=09=09=
return -ERANGE;=0D=0A+=09}=0D=0A+=0D=0A+=09if (fmh->nextents > FUSE_FAMFS=
_MAX_EXTENTS) {=0D=0A+=09=09pr_err("%s: nextents %d > max (%d) 1\n",=0D=0A=
+=09=09       __func__, fmh->nextents, FUSE_FAMFS_MAX_EXTENTS);=0D=0A+=09=
=09return -ERANGE;=0D=0A+=09}=0D=0A+=0D=0A+=09struct famfs_file_meta *met=
a __free(__famfs_meta_free) =3D kzalloc(sizeof(*meta), GFP_KERNEL);=0D=0A=
+=0D=0A+=09if (!meta)=0D=0A+=09=09return -ENOMEM;=0D=0A+=0D=0A+=09meta->e=
rror =3D false;=0D=0A+=09meta->file_type =3D fmh->file_type;=0D=0A+=09met=
a->file_size =3D fmh->file_size;=0D=0A+=09meta->fm_extent_type =3D fmh->e=
xt_type;=0D=0A+=0D=0A+=09switch (fmh->ext_type) {=0D=0A+=09case FUSE_FAMF=
S_EXT_SIMPLE: {=0D=0A+=09=09struct fuse_famfs_simple_ext *se_in;=0D=0A+=0D=
=0A+=09=09se_in =3D fmap_buf + next_offset;=0D=0A+=0D=0A+=09=09/* Move pa=
st simple extents */=0D=0A+=09=09next_offset +=3D fmh->nextents * sizeof(=
*se_in);=0D=0A+=09=09if (next_offset > fmap_buf_size) {=0D=0A+=09=09=09pr=
_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",=0D=0A+=09=09=09  =
     __func__, __LINE__, next_offset, fmap_buf_size);=0D=0A+=09=09=09retu=
rn -EINVAL;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09meta->fm_nextents =3D fmh->n=
extents;=0D=0A+=0D=0A+=09=09meta->se =3D kcalloc(meta->fm_nextents, sizeo=
f(*(meta->se)),=0D=0A+=09=09=09=09   GFP_KERNEL);=0D=0A+=09=09if (!meta->=
se)=0D=0A+=09=09=09return -ENOMEM;=0D=0A+=0D=0A+=09=09if ((meta->fm_nexte=
nts > FUSE_FAMFS_MAX_EXTENTS) ||=0D=0A+=09=09    (meta->fm_nextents < 1))=
=0D=0A+=09=09=09return -EINVAL;=0D=0A+=0D=0A+=09=09for (i =3D 0; i < fmh-=
>nextents; i++) {=0D=0A+=09=09=09meta->se[i].dev_index  =3D se_in[i].se_d=
evindex;=0D=0A+=09=09=09meta->se[i].ext_offset =3D se_in[i].se_offset;=0D=
=0A+=09=09=09meta->se[i].ext_len    =3D se_in[i].se_len;=0D=0A+=0D=0A+=09=
=09=09/* Record bitmap of referenced daxdev indices */=0D=0A+=09=09=09met=
a->dev_bitmap |=3D (1 << meta->se[i].dev_index);=0D=0A+=0D=0A+=09=09=09er=
rs +=3D famfs_check_ext_alignment(&meta->se[i]);=0D=0A+=0D=0A+=09=09=09ex=
tent_total +=3D meta->se[i].ext_len;=0D=0A+=09=09}=0D=0A+=09=09break;=0D=0A=
+=09}=0D=0A+=0D=0A+=09case FUSE_FAMFS_EXT_INTERLEAVE: {=0D=0A+=09=09s64 s=
ize_remainder =3D meta->file_size;=0D=0A+=09=09struct fuse_famfs_iext *ie=
_in;=0D=0A+=09=09int niext =3D fmh->nextents;=0D=0A+=0D=0A+=09=09meta->fm=
_niext =3D niext;=0D=0A+=0D=0A+=09=09/* Allocate interleaved extent */=0D=
=0A+=09=09meta->ie =3D kcalloc(niext, sizeof(*(meta->ie)), GFP_KERNEL);=0D=
=0A+=09=09if (!meta->ie)=0D=0A+=09=09=09return -ENOMEM;=0D=0A+=0D=0A+=09=09=
/*=0D=0A+=09=09 * Each interleaved extent has a simple extent list of str=
ips.=0D=0A+=09=09 * Outer loop is over separate interleaved extents=0D=0A=
+=09=09 */=0D=0A+=09=09for (i =3D 0; i < niext; i++) {=0D=0A+=09=09=09u64=
 nstrips;=0D=0A+=09=09=09struct fuse_famfs_simple_ext *sie_in;=0D=0A+=0D=0A=
+=09=09=09/* ie_in =3D one interleaved extent in fmap_buf */=0D=0A+=09=09=
=09ie_in =3D fmap_buf + next_offset;=0D=0A+=0D=0A+=09=09=09/* Move past o=
ne interleaved extent header in fmap_buf */=0D=0A+=09=09=09next_offset +=3D=
 sizeof(*ie_in);=0D=0A+=09=09=09if (next_offset > fmap_buf_size) {=0D=0A+=
=09=09=09=09pr_err("%s:%d: fmap_buf underflow offset/size %ld/%ld\n",=0D=0A=
+=09=09=09=09       __func__, __LINE__, next_offset,=0D=0A+=09=09=09=09  =
     fmap_buf_size);=0D=0A+=09=09=09=09return -EINVAL;=0D=0A+=09=09=09}=0D=
=0A+=0D=0A+=09=09=09if (!IS_ALIGNED(ie_in->ie_chunk_size, PMD_SIZE)) {=0D=
=0A+=09=09=09=09pr_err("%s: chunk_size %lld not PMD-aligned\n",=0D=0A+=09=
=09=09=09       __func__, meta->ie[i].fie_chunk_size);=0D=0A+=09=09=09=09=
return -EINVAL;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09if (ie_in->ie_nbyt=
es =3D=3D 0) {=0D=0A+=09=09=09=09pr_err("%s: zero-length interleave!\n",=0D=
=0A+=09=09=09=09       __func__);=0D=0A+=09=09=09=09return -EINVAL;=0D=0A=
+=09=09=09}=0D=0A+=0D=0A+=09=09=09nstrips =3D ie_in->ie_nstrips;=0D=0A+=09=
=09=09meta->ie[i].fie_chunk_size =3D ie_in->ie_chunk_size;=0D=0A+=09=09=09=
meta->ie[i].fie_nstrips    =3D ie_in->ie_nstrips;=0D=0A+=09=09=09meta->ie=
[i].fie_nbytes     =3D ie_in->ie_nbytes;=0D=0A+=0D=0A+=09=09=09/* sie_in =
=3D the strip extents in fmap_buf */=0D=0A+=09=09=09sie_in =3D fmap_buf +=
 next_offset;=0D=0A+=0D=0A+=09=09=09/* Move past strip extents in fmap_bu=
f */=0D=0A+=09=09=09next_offset +=3D nstrips * sizeof(*sie_in);=0D=0A+=09=
=09=09if (next_offset > fmap_buf_size) {=0D=0A+=09=09=09=09pr_err("%s:%d:=
 fmap_buf underflow offset/size %ld/%ld\n",=0D=0A+=09=09=09=09       __fu=
nc__, __LINE__, next_offset,=0D=0A+=09=09=09=09       fmap_buf_size);=0D=0A=
+=09=09=09=09return -EINVAL;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09if ((=
nstrips > FUSE_FAMFS_MAX_STRIPS) || (nstrips < 1)) {=0D=0A+=09=09=09=09pr=
_err("%s: invalid nstrips=3D%lld (max=3D%d)\n",=0D=0A+=09=09=09=09       =
__func__, nstrips,=0D=0A+=09=09=09=09       FUSE_FAMFS_MAX_STRIPS);=0D=0A=
+=09=09=09=09errs++;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/* Allocate s=
trip extent array */=0D=0A+=09=09=09meta->ie[i].ie_strips =3D=0D=0A+=09=09=
=09=09kcalloc(ie_in->ie_nstrips,=0D=0A+=09=09=09=09=09sizeof(meta->ie[i].=
ie_strips[0]),=0D=0A+=09=09=09=09=09GFP_KERNEL);=0D=0A+=09=09=09if (!meta=
->ie[i].ie_strips)=0D=0A+=09=09=09=09return -ENOMEM;=0D=0A+=0D=0A+=09=09=09=
/* Inner loop is over strips */=0D=0A+=09=09=09for (j =3D 0; j < nstrips;=
 j++) {=0D=0A+=09=09=09=09struct famfs_meta_simple_ext *strips_out;=0D=0A=
+=09=09=09=09u64 devindex =3D sie_in[j].se_devindex;=0D=0A+=09=09=09=09u6=
4 offset   =3D sie_in[j].se_offset;=0D=0A+=09=09=09=09u64 len      =3D si=
e_in[j].se_len;=0D=0A+=0D=0A+=09=09=09=09strips_out =3D meta->ie[i].ie_st=
rips;=0D=0A+=09=09=09=09strips_out[j].dev_index  =3D devindex;=0D=0A+=09=09=
=09=09strips_out[j].ext_offset =3D offset;=0D=0A+=09=09=09=09strips_out[j=
].ext_len    =3D len;=0D=0A+=0D=0A+=09=09=09=09/* Record bitmap of refere=
nced daxdev indices */=0D=0A+=09=09=09=09meta->dev_bitmap |=3D (1 << devi=
ndex);=0D=0A+=0D=0A+=09=09=09=09extent_total +=3D len;=0D=0A+=09=09=09=09=
errs +=3D famfs_check_ext_alignment(&strips_out[j]);=0D=0A+=09=09=09=09si=
ze_remainder -=3D len;=0D=0A+=09=09=09}=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09=
if (size_remainder > 0) {=0D=0A+=09=09=09/* Sum of interleaved extent siz=
es is less than file size! */=0D=0A+=09=09=09pr_err("%s: size_remainder %=
lld (0x%llx)\n",=0D=0A+=09=09=09       __func__, size_remainder, size_rem=
ainder);=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A+=09=09break;=0D=
=0A+=09}=0D=0A+=0D=0A+=09default:=0D=0A+=09=09pr_err("%s: invalid ext_typ=
e %d\n", __func__, fmh->ext_type);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=
=0D=0A+=0D=0A+=09if (errs > 0) {=0D=0A+=09=09pr_err("%s: %d alignment err=
ors found\n", __func__, errs);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A=
+=0D=0A+=09/* More sanity checks */=0D=0A+=09if (extent_total < meta->fil=
e_size) {=0D=0A+=09=09pr_err("%s: file size %ld larger than map size %ld\=
n",=0D=0A+=09=09       __func__, meta->file_size, extent_total);=0D=0A+=09=
=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (cmpxchg(metap, NULL, me=
ta) !=3D NULL) {=0D=0A+=09=09pr_debug("%s: fmap race detected\n", __func_=
_);=0D=0A+=09=09return 0; /* fmap already installed */=0D=0A+=09}=0D=0A+=09=
retain_and_null_ptr(meta);=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A=
+/**=0D=0A+ * famfs_file_init_dax() - init famfs dax file metadata=0D=0A+=
 *=0D=0A+ * @fm:        fuse_mount=0D=0A+ * @inode:     the inode=0D=0A+ =
* @fmap_buf:  fmap response message=0D=0A+ * @fmap_size: Size of the fmap=
 message=0D=0A+ *=0D=0A+ * Initialize famfs metadata for a file, based on=
 the contents of the GET_FMAP=0D=0A+ * response=0D=0A+ *=0D=0A+ * Return:=
 0=3Dsuccess=0D=0A+ *          -errno=3Dfailure=0D=0A+ */=0D=0A+int=0D=0A=
+famfs_file_init_dax(=0D=0A+=09struct fuse_mount *fm,=0D=0A+=09struct ino=
de *inode,=0D=0A+=09void *fmap_buf,=0D=0A+=09size_t fmap_size)=0D=0A+{=0D=
=0A+=09struct fuse_inode *fi =3D get_fuse_inode(inode);=0D=0A+=09struct f=
amfs_file_meta *meta =3D NULL;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (fi->f=
amfs_meta) {=0D=0A+=09=09pr_notice("%s: i_no=3D%ld fmap_size=3D%ld ALREAD=
Y INITIALIZED\n",=0D=0A+=09=09=09  __func__,=0D=0A+=09=09=09  inode->i_in=
o, fmap_size);=0D=0A+=09=09return 0;=0D=0A+=09}=0D=0A+=0D=0A+=09rc =3D fa=
mfs_fuse_meta_alloc(fmap_buf, fmap_size, &meta);=0D=0A+=09if (rc)=0D=0A+=09=
=09goto errout;=0D=0A+=0D=0A+=09/* Publish the famfs metadata on fi->famf=
s_meta */=0D=0A+=09inode_lock(inode);=0D=0A+=0D=0A+=09if (famfs_meta_set(=
fi, meta) =3D=3D NULL) {=0D=0A+=09=09i_size_write(inode, meta->file_size)=
;=0D=0A+=09=09inode->i_flags |=3D S_DAX;=0D=0A+=09} else {=0D=0A+=09=09pr=
_debug("%s: file already had metadata\n", __func__);=0D=0A+=09=09__famfs_=
meta_free(meta);=0D=0A+=09=09/* rc is 0 - the file is valid */=0D=0A+=09}=
=0D=0A+=0D=0A+=09inode_unlock(inode);=0D=0A+=09return 0;=0D=0A+=0D=0A+err=
out:=0D=0A+=09if (rc)=0D=0A+=09=09__famfs_meta_free(meta);=0D=0A+=0D=0A+=09=
return rc;=0D=0A+}=0D=0A+=0D=0A #define FMAP_BUFSIZE PAGE_SIZE=0D=0A=20=0D=
=0A int fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)=0D=0A@@=
 -63,11 +393,8 @@ int fuse_get_fmap(struct fuse_mount *fm, struct inode *=
inode)=0D=0A =09}=0D=0A =09fmap_size =3D rc;=0D=0A=20=0D=0A-=09/* We retr=
ieved the "fmap" (the file's map to memory), but=0D=0A-=09 * we haven't u=
sed it yet. A call to famfs_file_init_dax() will be added=0D=0A-=09 * her=
e in a subsequent patch, when we add the ability to attach=0D=0A-=09 * fm=
aps to files.=0D=0A-=09 */=0D=0A+=09/* Convert fmap into in-memory format=
 and hang from inode */=0D=0A+=09rc =3D famfs_file_init_dax(fm, inode, fm=
ap_buf, fmap_size);=0D=0A=20=0D=0A-=09return 0;=0D=0A+=09return rc;=0D=0A=
 }=0D=0Adiff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h=0D=0An=
ew file mode 100644=0D=0Aindex 000000000000..18ab22bcc5a1=0D=0A--- /dev/n=
ull=0D=0A+++ b/fs/fuse/famfs_kfmap.h=0D=0A@@ -0,0 +1,67 @@=0D=0A+/* SPDX-=
License-Identifier: GPL-2.0 */=0D=0A+/*=0D=0A+ * famfs - dax file system =
for shared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright 2023-2026 M=
icron Technology, Inc.=0D=0A+ */=0D=0A+#ifndef FAMFS_KFMAP_H=0D=0A+#defin=
e FAMFS_KFMAP_H=0D=0A+=0D=0A+/*=0D=0A+ * The structures below are the in-=
memory metadata format for famfs files.=0D=0A+ * Metadata retrieved via t=
he GET_FMAP response is converted to this format=0D=0A+ * for use in reso=
lving file mapping faults.=0D=0A+ *=0D=0A+ * The GET_FMAP response contai=
ns the same information, but in a more=0D=0A+ * message-and-versioning-fr=
iendly format. Those structs can be found in the=0D=0A+ * famfs section o=
f include/uapi/linux/fuse.h (aka fuse_kernel.h in libfuse)=0D=0A+ */=0D=0A=
+=0D=0A+enum famfs_file_type {=0D=0A+=09FAMFS_REG,=0D=0A+=09FAMFS_SUPERBL=
OCK,=0D=0A+=09FAMFS_LOG,=0D=0A+};=0D=0A+=0D=0A+/* We anticipate the possi=
bility of supporting additional types of extents */=0D=0A+enum famfs_exte=
nt_type {=0D=0A+=09SIMPLE_DAX_EXTENT,=0D=0A+=09INTERLEAVED_EXTENT,=0D=0A+=
=09INVALID_EXTENT_TYPE,=0D=0A+};=0D=0A+=0D=0A+struct famfs_meta_simple_ex=
t {=0D=0A+=09u64 dev_index;=0D=0A+=09u64 ext_offset;=0D=0A+=09u64 ext_len=
;=0D=0A+};=0D=0A+=0D=0A+struct famfs_meta_interleaved_ext {=0D=0A+=09u64 =
fie_nstrips;=0D=0A+=09u64 fie_chunk_size;=0D=0A+=09u64 fie_nbytes;=0D=0A+=
=09struct famfs_meta_simple_ext *ie_strips;=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A=
+ * Each famfs dax file has this hanging from its fuse_inode->famfs_meta=0D=
=0A+ */=0D=0A+struct famfs_file_meta {=0D=0A+=09bool                   er=
ror;=0D=0A+=09enum famfs_file_type   file_type;=0D=0A+=09size_t          =
       file_size;=0D=0A+=09enum famfs_extent_type fm_extent_type;=0D=0A+=09=
u64 dev_bitmap; /* bitmap of referenced daxdevs by index */=0D=0A+=09unio=
n {=0D=0A+=09=09struct {=0D=0A+=09=09=09size_t         fm_nextents;=0D=0A=
+=09=09=09struct famfs_meta_simple_ext  *se;=0D=0A+=09=09};=0D=0A+=09=09s=
truct {=0D=0A+=09=09=09size_t         fm_niext;=0D=0A+=09=09=09struct fam=
fs_meta_interleaved_ext *ie;=0D=0A+=09=09};=0D=0A+=09};=0D=0A+};=0D=0A+=0D=
=0A+#endif /* FAMFS_KFMAP_H */=0D=0Adiff --git a/fs/fuse/fuse_i.h b/fs/fu=
se/fuse_i.h=0D=0Aindex b5466743c13f..df4e9c9f80bf 100644=0D=0A--- a/fs/fu=
se/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A@@ -1642,6 +1642,9 @@ extern=
 void fuse_sysctl_unregister(void);=0D=0A /* famfs.c */=0D=0A=20=0D=0A #i=
f IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)=0D=0A+int famfs_file_init_dax(struct =
fuse_mount *fm,=0D=0A+=09=09=09struct inode *inode, void *fmap_buf,=0D=0A=
+=09=09=09size_t fmap_size);=0D=0A void __famfs_meta_free(void *map);=0D=0A=
=20=0D=0A /* Set fi->famfs_meta =3D NULL regardless of prior value */=0D=0A=
@@ -1659,7 +1662,10 @@ static inline struct fuse_backing *famfs_meta_set(=
struct fuse_inode *fi,=0D=0A=20=0D=0A static inline void famfs_meta_free(=
struct fuse_inode *fi)=0D=0A {=0D=0A-=09famfs_meta_set(fi, NULL);=0D=0A+=09=
if (fi->famfs_meta !=3D NULL) {=0D=0A+=09=09__famfs_meta_free(fi->famfs_m=
eta);=0D=0A+=09=09famfs_meta_set(fi, NULL);=0D=0A+=09}=0D=0A }=0D=0A=20=0D=
=0A static inline int fuse_file_famfs(struct fuse_inode *fi)=0D=0Adiff --=
git a/fs/fuse/inode.c b/fs/fuse/inode.c=0D=0Aindex 862f4e61a5fb..5e692fc8=
4297 100644=0D=0A--- a/fs/fuse/inode.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A@@=
 -10,6 +10,7 @@=0D=0A #include "fuse_dev_i.h"=0D=0A #include "dev_uring_i=
=2Eh"=0D=0A=20=0D=0A+#include <linux/bitfield.h>=0D=0A #include <linux/da=
x.h>=0D=0A #include <linux/pagemap.h>=0D=0A #include <linux/slab.h>=0D=0A=
@@ -1464,8 +1465,21 @@ static void process_init_reply(struct fuse_mount *=
fm, struct fuse_args *args,=0D=0A =09=09=09=09timeout =3D arg->request_ti=
meout;=0D=0A=20=0D=0A =09=09=09if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&=0D=
=0A-=09=09=09    flags & FUSE_DAX_FMAP)=0D=0A-=09=09=09=09fc->famfs_iomap=
 =3D 1;=0D=0A+=09=09=09    flags & FUSE_DAX_FMAP) {=0D=0A+=09=09=09=09/* =
famfs_iomap is only allowed if the fuse=0D=0A+=09=09=09=09 * server has C=
AP_SYS_RAWIO. This was checked=0D=0A+=09=09=09=09 * in fuse_send_init, an=
d FUSE_DAX_IOMAP was=0D=0A+=09=09=09=09 * set in in_flags if so. Only all=
ow enablement=0D=0A+=09=09=09=09 * if we find it there. This function is=0D=
=0A+=09=09=09=09 * normally not running in fuse server context,=0D=0A+=09=
=09=09=09 * so we can't do the capability check here...=0D=0A+=09=09=09=09=
 */=0D=0A+=09=09=09=09u64 in_flags =3D FIELD_PREP(GENMASK_ULL(63, 32), ia=
->in.flags2)=0D=0A+=09=09=09=09=09=09| ia->in.flags;=0D=0A+=0D=0A+=09=09=09=
=09if (in_flags & FUSE_DAX_FMAP)=0D=0A+=09=09=09=09=09fc->famfs_iomap =3D=
 1;=0D=0A+=09=09=09}=0D=0A =09=09} else {=0D=0A =09=09=09ra_pages =3D fc-=
>max_read / PAGE_SIZE;=0D=0A =09=09=09fc->no_lock =3D 1;=0D=0A@@ -1527,7 =
+1541,7 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount =
*fm)=0D=0A =09=09flags |=3D FUSE_SUBMOUNTS;=0D=0A =09if (IS_ENABLED(CONFI=
G_FUSE_PASSTHROUGH))=0D=0A =09=09flags |=3D FUSE_PASSTHROUGH;=0D=0A-=09if=
 (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09if (IS_ENABLED(CONFIG_FUSE_=
FAMFS_DAX) && capable(CAP_SYS_RAWIO))=0D=0A =09=09flags |=3D FUSE_DAX_FMA=
P;=0D=0A=20=0D=0A =09/*=0D=0Adiff --git a/include/uapi/linux/fuse.h b/inc=
lude/uapi/linux/fuse.h=0D=0Aindex 9eff9083d3b5..cf678bebbfe0 100644=0D=0A=
--- a/include/uapi/linux/fuse.h=0D=0A+++ b/include/uapi/linux/fuse.h=0D=0A=
@@ -243,6 +243,13 @@=0D=0A  *=0D=0A  *  7.46=0D=0A  *  - Add FUSE_DAX_FMA=
P capability - ability to handle in-kernel fsdax maps=0D=0A+ *  - Add the=
 following structures for the GET_FMAP message reply components:=0D=0A+ *=
    - struct fuse_famfs_simple_ext=0D=0A+ *    - struct fuse_famfs_iext=0D=
=0A+ *    - struct fuse_famfs_fmap_header=0D=0A+ *  - Add the following e=
numerated types=0D=0A+ *    - enum fuse_famfs_file_type=0D=0A+ *    - enu=
m famfs_ext_type=0D=0A  */=0D=0A=20=0D=0A #ifndef _LINUX_FUSE_H=0D=0A@@ -=
1318,6 +1325,55 @@ struct fuse_uring_cmd_req {=0D=0A=20=0D=0A /* Famfs fm=
ap message components */=0D=0A=20=0D=0A+#define FAMFS_FMAP_VERSION 1=0D=0A=
+=0D=0A #define FAMFS_FMAP_MAX 32768 /* Largest supported fmap message */=
=0D=0A+#define FUSE_FAMFS_MAX_EXTENTS 32=0D=0A+#define FUSE_FAMFS_MAX_STR=
IPS 32=0D=0A+=0D=0A+enum fuse_famfs_file_type {=0D=0A+=09FUSE_FAMFS_FILE_=
REG,=0D=0A+=09FUSE_FAMFS_FILE_SUPERBLOCK,=0D=0A+=09FUSE_FAMFS_FILE_LOG,=0D=
=0A+};=0D=0A+=0D=0A+enum famfs_ext_type {=0D=0A+=09FUSE_FAMFS_EXT_SIMPLE =
=3D 0,=0D=0A+=09FUSE_FAMFS_EXT_INTERLEAVE =3D 1,=0D=0A+};=0D=0A+=0D=0A+st=
ruct fuse_famfs_simple_ext {=0D=0A+=09uint32_t se_devindex;=0D=0A+=09uint=
32_t reserved;=0D=0A+=09uint64_t se_offset;=0D=0A+=09uint64_t se_len;=0D=0A=
+};=0D=0A+=0D=0A+struct fuse_famfs_iext { /* Interleaved extent */=0D=0A+=
=09uint32_t ie_nstrips;=0D=0A+=09uint32_t ie_chunk_size;=0D=0A+=09uint64_=
t ie_nbytes; /* Total bytes for this interleaved_ext;=0D=0A+=09=09=09    =
 * sum of strips may be more=0D=0A+=09=09=09     */=0D=0A+=09uint64_t res=
erved;=0D=0A+};=0D=0A+=0D=0A+struct fuse_famfs_fmap_header {=0D=0A+=09uin=
t8_t file_type; /* enum famfs_file_type */=0D=0A+=09uint8_t reserved;=0D=0A=
+=09uint16_t fmap_version;=0D=0A+=09uint32_t ext_type; /* enum famfs_log_=
ext_type */=0D=0A+=09uint32_t nextents;=0D=0A+=09uint32_t reserved0;=0D=0A=
+=09uint64_t file_size;=0D=0A+=09uint64_t reserved1;=0D=0A+};=0D=0A+=0D=0A=
+static inline int32_t fmap_msg_min_size(void)=0D=0A+{=0D=0A+=09/* Smalle=
st fmap message is a header plus one simple extent */=0D=0A+=09return (si=
zeof(struct fuse_famfs_fmap_header)=0D=0A+=09=09+ sizeof(struct fuse_famf=
s_simple_ext));=0D=0A+}=0D=0A=20=0D=0A #endif /* _LINUX_FUSE_H */=0D=0A--=
=20=0D=0A2.53.0=0D=0A=0D=0A
