Received: from a11-129.smtp-out.amazonses.com (a11-129.smtp-out.amazonses.com [54.240.11.129])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31403603C9;
	Mon, 20 Jul 2026 03:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519163; cv=none; b=Zi2r9MDL6EddFAaJOGJzPQUoP1rHRGTMXeUh83Is/Sby+ut+8SnQCZScASjnx/rYrX5Ao7ynwkNm1B0WGs1jTpzcvYa2TrbuonNKZo8Uc88s9YQkL0b2n2WET4XOf7P8joYdNPf9jq53WQBAjK2eysxc9II/XeJuuTMWLkTkEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519163; c=relaxed/simple;
	bh=dPvZAm9T4fVj9XmyOPQc4PNauVW2eMgGn2kwqTC9GwY=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Nvwk7C/+Z/fqV/lIhgW0Iyv6nRXg3lKQq7A9WVpYH2tqZbucxsucEYC/h/gezm6lOjSCP3g/6JguLj6OeKw5fc9znEoebYOrkKFygY6xf4iLDn0Im4NTj8rmd1IaEpXc0VTh4JA5nKCThDtrjtpFWtRe1OuXNlCvQMqIp3MyeBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=bH3AwUTm; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=UKoYpw2N; arc=none smtp.client-ip=54.240.11.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="bH3AwUTm";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UKoYpw2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519161;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=dPvZAm9T4fVj9XmyOPQc4PNauVW2eMgGn2kwqTC9GwY=;
	b=bH3AwUTmTDH6ekb/5vDg2bD4q5we8ORD81qwnJ6I3OkS+suVrjobkmfbl05vvcCS
	TlgiDreKK1cCo3MdZOj4/knTJjktA/NSWzXDz1noFlmxiq2lK3dXzl85bMhHiZUFMsy
	Ph4J6Y40bx8fdDLrgh/jCEIdJRUGNHF/ANj/IrdM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519161;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=dPvZAm9T4fVj9XmyOPQc4PNauVW2eMgGn2kwqTC9GwY=;
	b=UKoYpw2Nkc691K6FoAJJKnFfyqV2trVpGfTjvSxt/OvEzSSNs4+gUFHSL+x4j/XV
	CKog2K/mfdsG1wNOrIcJAXJZ/XLF95NvdebMrchlDoZhWX6+GDl+LIruAA9/eGbZJhm
	zLvUtMimVktSaxwEROPXY4bBgllAXbfz9JUlSyBU=
Subject: [PATCH V11 4/9] famfs_fuse: Create files with famfs fmaps
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
Date: Mon, 20 Jul 2026 03:46:01 +0000
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
 <20260720034553.68798-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAAEMoX
Thread-Topic: [PATCH V11 4/9] famfs_fuse: Create files with famfs fmaps
X-Wm-Sent-Timestamp: 1784519159
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da174eb-4cd0f3ae-59da-4533-b469-6eee009a22bd-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.129

From: John Groves <john@groves.net>=0D=0A=0D=0AInterpret the fmap retriev=
ed by GET_FMAP into the in-memory metadata that=0D=0Alater patches use to=
 resolve read/write/mmap directly to dax.=0D=0A=0D=0A- uapi: add the fmap=
 wire format -- struct fuse_famfs_fmap_header and=0D=0A  struct fuse_famf=
s_simple_ext, plus enum fuse_famfs_file_type and enum=0D=0A  famfs_ext_ty=
pe. An fmap is a simple (linear) list of extents, each=0D=0A  mapping a f=
ile-offset range to a range on a dax device. A striped file=0D=0A  is exp=
ressed by unrolling it into a longer simple-extent list in=0D=0A  userspa=
ce, so the kernel format stays simple-only.=0D=0A- famfs_kfmap.h: add the=
 in-memory structures (struct famfs_file_meta,=0D=0A  struct famfs_meta_s=
imple_ext) that hang from fuse_inode->famfs_meta.=0D=0A- famfs.c: add fam=
fs_fuse_meta_alloc()/famfs_file_init_dax() to parse and=0D=0A  validate t=
he fmap and build the in-memory form, plus __famfs_meta_free().=0D=0A  Wh=
ile parsing, detect a uniform (power-of-two) extent size and record it=0D=
=0A  as meta->ext_shift, so the resolver can index the extent list by a s=
hift=0D=0A  (O(1)) instead of walking it; a non-uniform list falls back t=
o a walk=0D=0A  (ext_shift =3D=3D 0).=0D=0A- inode.c: only allow famfs mo=
de if the fuse server holds CAP_SYS_RAWIO.=0D=0A- Update MAINTAINERS for =
the new file.=0D=0A=0D=0AThe dev_dax_iomap plumbing that consumes this me=
tadata is added in a=0D=0Alater patch.=0D=0A=0D=0ASigned-off-by: John Gro=
ves <john@groves.net>=0D=0A---=0D=0A MAINTAINERS               |   1 +=0D=
=0A fs/fuse/famfs.c           | 240 +++++++++++++++++++++++++++++++++++++=
-=0D=0A fs/fuse/famfs_kfmap.h     |  64 ++++++++++=0D=0A fs/fuse/fuse_i.h=
          |   8 +-=0D=0A fs/fuse/inode.c           |  20 +++-=0D=0A inclu=
de/uapi/linux/fuse.h |  40 +++++++=0D=0A 6 files changed, 363 insertions(=
+), 10 deletions(-)=0D=0A create mode 100644 fs/fuse/famfs_kfmap.h=0D=0A=0D=
=0Adiff --git a/MAINTAINERS b/MAINTAINERS=0D=0Aindex 0d0fded4fddb..07db3a=
5a2af7 100644=0D=0A--- a/MAINTAINERS=0D=0A+++ b/MAINTAINERS=0D=0A@@ -1071=
9,6 +10719,7 @@ L:=09linux-cxl@vger.kernel.org=0D=0A L:=09linux-fsdevel@v=
ger.kernel.org=0D=0A S:=09Supported=0D=0A F:=09fs/fuse/famfs.c=0D=0A+F:=09=
fs/fuse/famfs_kfmap.h=0D=0A=20=0D=0A FUTEX SUBSYSTEM=0D=0A M:=09Thomas Gl=
eixner <tglx@kernel.org>=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/famf=
s.c=0D=0Aindex 80e6640ac970..8f7ee7d6151b 100644=0D=0A--- a/fs/fuse/famfs=
=2Ec=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -14,13 +14,244 @@=0D=0A #include =
<linux/mm.h>=0D=0A #include <linux/dax.h>=0D=0A #include <linux/iomap.h>=0D=
=0A+#include <linux/log2.h>=0D=0A #include <linux/path.h>=0D=0A #include =
<linux/namei.h>=0D=0A #include <linux/string.h>=0D=0A=20=0D=0A+#include "=
famfs_kfmap.h"=0D=0A #include "fuse_i.h"=0D=0A=20=0D=0A=20=0D=0A+/*******=
********************************************************************/=0D=0A=
+=0D=0A+void __famfs_meta_free(void *famfs_meta)=0D=0A+{=0D=0A+=09struct =
famfs_file_meta *fmap =3D famfs_meta;=0D=0A+=0D=0A+=09if (!fmap)=0D=0A+=09=
=09return;=0D=0A+=0D=0A+=09kfree(fmap->se);=0D=0A+=09kfree(fmap);=0D=0A+}=
=0D=0A+DEFINE_FREE(__famfs_meta_free, void *, if (_T) __famfs_meta_free(_=
T))=0D=0A+=0D=0A+static int=0D=0A+famfs_check_ext_alignment(struct famfs_=
meta_simple_ext *se)=0D=0A+{=0D=0A+=09int errs =3D 0;=0D=0A+=0D=0A+=09if =
(se->dev_index !=3D 0)=0D=0A+=09=09errs++;=0D=0A+=0D=0A+=09/* TODO: pass =
in alignment so we can support the other page sizes */=0D=0A+=09if (!IS_A=
LIGNED(se->ext_offset, PMD_SIZE))=0D=0A+=09=09errs++;=0D=0A+=0D=0A+=09if =
(!IS_ALIGNED(se->ext_len, PMD_SIZE))=0D=0A+=09=09errs++;=0D=0A+=0D=0A+=09=
return errs;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_fuse_meta_alloc() - =
Allocate famfs file metadata=0D=0A+ * @fmap_buf:  fmap buffer from fuse s=
erver=0D=0A+ * @fmap_buf_size: size of fmap buffer=0D=0A+ * @metap:      =
   pointer where 'struct famfs_file_meta' is returned=0D=0A+ *=0D=0A+ * R=
eturns: 0=3Dsuccess=0D=0A+ *          -errno=3Dfailure=0D=0A+ */=0D=0A+st=
atic int=0D=0A+famfs_fuse_meta_alloc(=0D=0A+=09void *fmap_buf,=0D=0A+=09s=
ize_t fmap_buf_size,=0D=0A+=09struct famfs_file_meta **metap)=0D=0A+{=0D=0A=
+=09struct fuse_famfs_fmap_header *fmh;=0D=0A+=09size_t extent_total =3D =
0;=0D=0A+=09size_t next_offset =3D 0;=0D=0A+=09int errs =3D 0;=0D=0A+=09i=
nt i;=0D=0A+=0D=0A+=09fmh =3D fmap_buf;=0D=0A+=0D=0A+=09/* Move past fmh =
in fmap_buf */=0D=0A+=09next_offset +=3D sizeof(*fmh);=0D=0A+=09if (next_=
offset > fmap_buf_size) {=0D=0A+=09=09pr_err("%s:%d: fmap_buf underflow o=
ffset/size %ld/%ld\n",=0D=0A+=09=09       __func__, __LINE__, next_offset=
, fmap_buf_size);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09=
if (fmh->nextents < 1) {=0D=0A+=09=09pr_err("%s: nextents %d < 1\n", __fu=
nc__, fmh->nextents);=0D=0A+=09=09return -ERANGE;=0D=0A+=09}=0D=0A+=0D=0A=
+=09/*=0D=0A+=09 * No separate upper cap on nextents: the reply buffer bo=
unds it. The=0D=0A+=09 * extent list is rejected below if it does not fit=
 in fmap_buf_size, and=0D=0A+=09 * fuse_get_fmap() already refused to kvm=
alloc a buffer larger than=0D=0A+=09 * FMAP_BUFSIZE_MAX -- so anything th=
at fits is small enough to handle.=0D=0A+=09 */=0D=0A+=0D=0A+=09struct fa=
mfs_file_meta *meta __free(__famfs_meta_free) =3D kzalloc(sizeof(*meta), =
GFP_KERNEL);=0D=0A+=0D=0A+=09if (!meta)=0D=0A+=09=09return -ENOMEM;=0D=0A=
+=0D=0A+=09meta->error =3D false;=0D=0A+=09meta->file_type =3D fmh->file_=
type;=0D=0A+=09meta->file_size =3D fmh->file_size;=0D=0A+=0D=0A+=09switch=
 (fmh->ext_type) {=0D=0A+=09case FUSE_FAMFS_EXT_SIMPLE: {=0D=0A+=09=09str=
uct fuse_famfs_simple_ext *se_in;=0D=0A+=0D=0A+=09=09se_in =3D fmap_buf +=
 next_offset;=0D=0A+=0D=0A+=09=09/* Move past simple extents */=0D=0A+=09=
=09next_offset +=3D fmh->nextents * sizeof(*se_in);=0D=0A+=09=09if (next_=
offset > fmap_buf_size) {=0D=0A+=09=09=09pr_err("%s:%d: fmap_buf underflo=
w offset/size %ld/%ld\n",=0D=0A+=09=09=09       __func__, __LINE__, next_=
offset, fmap_buf_size);=0D=0A+=09=09=09return -EINVAL;=0D=0A+=09=09}=0D=0A=
+=0D=0A+=09=09meta->fm_nextents =3D fmh->nextents;=0D=0A+=0D=0A+=09=09met=
a->se =3D kcalloc(meta->fm_nextents, sizeof(*(meta->se)),=0D=0A+=09=09=09=
=09   GFP_KERNEL);=0D=0A+=09=09if (!meta->se)=0D=0A+=09=09=09return -ENOM=
EM;=0D=0A+=0D=0A+=09=09for (i =3D 0; i < fmh->nextents; i++) {=0D=0A+=09=09=
=09meta->se[i].dev_index  =3D se_in[i].se_devindex;=0D=0A+=09=09=09meta->=
se[i].ext_offset =3D se_in[i].se_offset;=0D=0A+=09=09=09meta->se[i].ext_l=
en    =3D se_in[i].se_len;=0D=0A+=0D=0A+=09=09=09/* Record bitmap of refe=
renced daxdev indices */=0D=0A+=09=09=09meta->dev_bitmap |=3D BIT_ULL(met=
a->se[i].dev_index);=0D=0A+=0D=0A+=09=09=09errs +=3D famfs_check_ext_alig=
nment(&meta->se[i]);=0D=0A+=0D=0A+=09=09=09extent_total +=3D meta->se[i].=
ext_len;=0D=0A+=09=09}=0D=0A+=0D=0A+=09=09/*=0D=0A+=09=09 * Detect a unif=
orm extent size so the resolver can index se[]=0D=0A+=09=09 * by a shift =
rather than walking the list. This requires every=0D=0A+=09=09 * extent b=
ut the last to be the same power-of-2 size, with the=0D=0A+=09=09 * last =
no larger. ext_shift stays 0 (walk) for a single extent,=0D=0A+=09=09 * o=
r a non-uniform / non-power-of-2 list.=0D=0A+=09=09 */=0D=0A+=09=09meta->=
ext_shift =3D 0;=0D=0A+=09=09if (meta->fm_nextents > 1) {=0D=0A+=09=09=09=
u64 esz =3D meta->se[0].ext_len;=0D=0A+=09=09=09bool uniform =3D is_power=
_of_2(esz);=0D=0A+=0D=0A+=09=09=09for (i =3D 1; uniform && i < meta->fm_n=
extents - 1; i++)=0D=0A+=09=09=09=09if (meta->se[i].ext_len !=3D esz)=0D=0A=
+=09=09=09=09=09uniform =3D false;=0D=0A+=0D=0A+=09=09=09if (uniform && m=
eta->se[meta->fm_nextents - 1].ext_len > esz)=0D=0A+=09=09=09=09uniform =3D=
 false;=0D=0A+=0D=0A+=09=09=09if (uniform)=0D=0A+=09=09=09=09meta->ext_sh=
ift =3D ilog2(esz);=0D=0A+=09=09}=0D=0A+=09=09break;=0D=0A+=09}=0D=0A+=0D=
=0A+=09default:=0D=0A+=09=09pr_err("%s: invalid ext_type %d\n", __func__,=
 fmh->ext_type);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09i=
f (errs > 0) {=0D=0A+=09=09pr_err("%s: %d alignment errors found\n", __fu=
nc__, errs);=0D=0A+=09=09return -EINVAL;=0D=0A+=09}=0D=0A+=0D=0A+=09/* Mo=
re sanity checks */=0D=0A+=09if (extent_total < meta->file_size) {=0D=0A+=
=09=09pr_err("%s: file size %ld larger than map size %ld\n",=0D=0A+=09=09=
       __func__, meta->file_size, extent_total);=0D=0A+=09=09return -EINV=
AL;=0D=0A+=09}=0D=0A+=0D=0A+=09if (cmpxchg(metap, NULL, meta) !=3D NULL) =
{=0D=0A+=09=09pr_debug("%s: fmap race detected\n", __func__);=0D=0A+=09=09=
return 0; /* fmap already installed */=0D=0A+=09}=0D=0A+=09retain_and_nul=
l_ptr(meta);=0D=0A+=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * =
famfs_file_init_dax() - init famfs dax file metadata=0D=0A+ *=0D=0A+ * @f=
m:        fuse_mount=0D=0A+ * @inode:     the inode=0D=0A+ * @fmap_buf:  =
fmap response message=0D=0A+ * @fmap_size: Size of the fmap message=0D=0A=
+ *=0D=0A+ * Initialize famfs metadata for a file, based on the contents =
of the GET_FMAP=0D=0A+ * response=0D=0A+ *=0D=0A+ * Return: 0=3Dsuccess=0D=
=0A+ *          -errno=3Dfailure=0D=0A+ */=0D=0A+int=0D=0A+famfs_file_ini=
t_dax(=0D=0A+=09struct fuse_mount *fm,=0D=0A+=09struct inode *inode,=0D=0A=
+=09void *fmap_buf,=0D=0A+=09size_t fmap_size)=0D=0A+{=0D=0A+=09struct fu=
se_inode *fi =3D get_fuse_inode(inode);=0D=0A+=09struct famfs_file_meta *=
meta =3D NULL;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (fi->famfs_meta) {=0D=0A=
+=09=09pr_notice("%s: i_no=3D%llu fmap_size=3D%zu ALREADY INITIALIZED\n",=
=0D=0A+=09=09=09  __func__,=0D=0A+=09=09=09  inode->i_ino, fmap_size);=0D=
=0A+=09=09return 0;=0D=0A+=09}=0D=0A+=0D=0A+=09rc =3D famfs_fuse_meta_all=
oc(fmap_buf, fmap_size, &meta);=0D=0A+=09if (rc)=0D=0A+=09=09goto errout;=
=0D=0A+=0D=0A+=09/* Publish the famfs metadata on fi->famfs_meta */=0D=0A=
+=09inode_lock(inode);=0D=0A+=0D=0A+=09if (famfs_meta_set(fi, meta) =3D=3D=
 NULL) {=0D=0A+=09=09i_size_write(inode, meta->file_size);=0D=0A+=09=09in=
ode->i_flags |=3D S_DAX;=0D=0A+=09} else {=0D=0A+=09=09pr_debug("%s: file=
 already had metadata\n", __func__);=0D=0A+=09=09__famfs_meta_free(meta);=
=0D=0A+=09=09/* rc is 0 - the file is valid */=0D=0A+=09}=0D=0A+=0D=0A+=09=
inode_unlock(inode);=0D=0A+=09return 0;=0D=0A+=0D=0A+errout:=0D=0A+=09if =
(rc)=0D=0A+=09=09__famfs_meta_free(meta);=0D=0A+=0D=0A+=09return rc;=0D=0A=
+}=0D=0A+=0D=0A+#define FMAP_BUFSIZE PAGE_SIZE=0D=0A+=0D=0A #define FMAP_=
BUFSIZE_INIT PAGE_SIZE=0D=0A /*=0D=0A  * Largest GET_FMAP reply buffer we=
 will kvmalloc. Any fmap whose whole message=0D=0A@@ -123,12 +354,9 @@ in=
t fuse_get_fmap(struct fuse_mount *fm, struct inode *inode)=0D=0A =09=09b=
ufsize =3D required;=0D=0A =09}=0D=0A=20=0D=0A-=09/* We retrieved the "fm=
ap" (the file's map to memory), but=0D=0A-=09 * we haven't used it yet. A=
 call to famfs_file_init_dax() will be added=0D=0A-=09 * here in a subseq=
uent patch, when we add the ability to attach=0D=0A-=09 * fmaps to files.=
=0D=0A-=09 */=0D=0A+=09/* Convert fmap into in-memory format and hang fro=
m inode */=0D=0A+=09rc =3D famfs_file_init_dax(fm, inode, fmap_buf, fmap_=
size);=0D=0A=20=0D=0A =09kvfree(fmap_buf);=0D=0A-=09return 0;=0D=0A+=09re=
turn rc;=0D=0A }=0D=0Adiff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_=
kfmap.h=0D=0Anew file mode 100644=0D=0Aindex 000000000000..d87b065e8ac8=0D=
=0A--- /dev/null=0D=0A+++ b/fs/fuse/famfs_kfmap.h=0D=0A@@ -0,0 +1,64 @@=0D=
=0A+/* SPDX-License-Identifier: GPL-2.0 */=0D=0A+/*=0D=0A+ * famfs - dax =
file system for shared fabric-attached memory=0D=0A+ *=0D=0A+ * Copyright=
 2023-2026 Micron Technology, Inc.=0D=0A+ */=0D=0A+#ifndef FAMFS_KFMAP_H=0D=
=0A+#define FAMFS_KFMAP_H=0D=0A+=0D=0A+/* KABI version 43 (aka v2) fmap s=
tructures=0D=0A+ *=0D=0A+ * The location of the memory backing for a famf=
s file is described by=0D=0A+ * the response to the GET_FMAP fuse message=
 (defined in=0D=0A+ * include/uapi/linux/fuse.h).=0D=0A+ *=0D=0A+ * A fam=
fs file is described by a list of simple extents: (devindex, offset,=0D=0A=
+ * length) tuples, where devindex references a devdax device that has be=
en=0D=0A+ * registered with the kernel. The extent list must cover at lea=
st file_size.=0D=0A+ * Striping/interleaving is expressed by unrolling in=
to a longer simple-extent=0D=0A+ * list in userspace; the kernel handles =
only simple extents.=0D=0A+ */=0D=0A+=0D=0A+/*=0D=0A+ * The structures be=
low are the in-memory metadata format for famfs files.=0D=0A+ * Metadata =
retrieved via the GET_FMAP response is converted to this format=0D=0A+ * =
for use in resolving file mapping faults.=0D=0A+ *=0D=0A+ * The GET_FMAP =
response contains the same information, but in a more=0D=0A+ * message-an=
d-versioning-friendly format. Those structs can be found in the=0D=0A+ * =
famfs section of include/uapi/linux/fuse.h (aka fuse_kernel.h in libfuse)=
=0D=0A+ */=0D=0A+=0D=0A+enum famfs_file_type {=0D=0A+=09FAMFS_REG,=0D=0A+=
=09FAMFS_SUPERBLOCK,=0D=0A+=09FAMFS_LOG,=0D=0A+};=0D=0A+=0D=0A+struct fam=
fs_meta_simple_ext {=0D=0A+=09u64 dev_index;=0D=0A+=09u64 ext_offset;=0D=0A=
+=09u64 ext_len;=0D=0A+};=0D=0A+=0D=0A+/*=0D=0A+ * Each famfs dax file ha=
s this hanging from its fuse_inode->famfs_meta=0D=0A+ */=0D=0A+struct fam=
fs_file_meta {=0D=0A+=09bool                   error;=0D=0A+=09enum famfs=
_file_type   file_type;=0D=0A+=09size_t                 file_size;=0D=0A+=
=09u64 dev_bitmap; /* bitmap of referenced daxdevs by index */=0D=0A+=09s=
ize_t                 fm_nextents;=0D=0A+=09/*=0D=0A+=09 * If every exten=
t but the last is the same power-of-2 size, ext_shift=0D=0A+=09 * is ilog=
2(that size) and the resolver indexes se[] by a shift of the=0D=0A+=09 * =
file offset (O(1)). Otherwise ext_shift is 0 and the resolver walks=0D=0A=
+=09 * the list (single-extent or non-uniform files).=0D=0A+=09 */=0D=0A+=
=09u32                    ext_shift;=0D=0A+=09struct famfs_meta_simple_ex=
t  *se;=0D=0A+};=0D=0A+=0D=0A+#endif /* FAMFS_KFMAP_H */=0D=0Adiff --git =
a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h=0D=0Aindex 5bacc5098620..46a7040b38=
dc 100644=0D=0A--- a/fs/fuse/fuse_i.h=0D=0A+++ b/fs/fuse/fuse_i.h=0D=0A@@=
 -1347,6 +1347,9 @@ extern void fuse_sysctl_unregister(void);=0D=0A /* fa=
mfs.c */=0D=0A=20=0D=0A #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)=0D=0A+int f=
amfs_file_init_dax(struct fuse_mount *fm,=0D=0A+=09=09=09struct inode *in=
ode, void *fmap_buf,=0D=0A+=09=09=09size_t fmap_size);=0D=0A void __famfs=
_meta_free(void *map);=0D=0A=20=0D=0A /* Set fi->famfs_meta =3D NULL rega=
rdless of prior value */=0D=0A@@ -1364,7 +1367,10 @@ static inline struct=
 fuse_backing *famfs_meta_set(struct fuse_inode *fi,=0D=0A=20=0D=0A stati=
c inline void famfs_meta_free(struct fuse_inode *fi)=0D=0A {=0D=0A-=09fam=
fs_meta_set(fi, NULL);=0D=0A+=09if (fi->famfs_meta !=3D NULL) {=0D=0A+=09=
=09__famfs_meta_free(fi->famfs_meta);=0D=0A+=09=09WRITE_ONCE(fi->famfs_me=
ta, NULL);=0D=0A+=09}=0D=0A }=0D=0A=20=0D=0A static inline int fuse_file_=
famfs(struct fuse_inode *fi)=0D=0Adiff --git a/fs/fuse/inode.c b/fs/fuse/=
inode.c=0D=0Aindex e030a302120f..78ffc5fd50d0 100644=0D=0A--- a/fs/fuse/i=
node.c=0D=0A+++ b/fs/fuse/inode.c=0D=0A@@ -7,6 +7,7 @@=0D=0A #include "de=
v.h"=0D=0A #include "fuse_i.h"=0D=0A=20=0D=0A+#include <linux/bitfield.h>=
=0D=0A #include <linux/dax.h>=0D=0A #include <linux/pagemap.h>=0D=0A #inc=
lude <linux/slab.h>=0D=0A@@ -1414,8 +1415,21 @@ static void process_init_=
reply(struct fuse_args *args, int error)=0D=0A =09=09=09=09timeout =3D ar=
g->request_timeout;=0D=0A=20=0D=0A =09=09=09if (IS_ENABLED(CONFIG_FUSE_FA=
MFS_DAX) &&=0D=0A-=09=09=09    flags & FUSE_DAX_FMAP)=0D=0A-=09=09=09=09f=
c->famfs_iomap =3D 1;=0D=0A+=09=09=09    flags & FUSE_DAX_FMAP) {=0D=0A+=09=
=09=09=09/* famfs_iomap is only allowed if the fuse=0D=0A+=09=09=09=09 * =
server has CAP_SYS_RAWIO. This was checked=0D=0A+=09=09=09=09 * in fuse_s=
end_init, and FUSE_DAX_IOMAP was=0D=0A+=09=09=09=09 * set in in_flags if =
so. Only allow enablement=0D=0A+=09=09=09=09 * if we find it there. This =
function is=0D=0A+=09=09=09=09 * normally not running in fuse server cont=
ext,=0D=0A+=09=09=09=09 * so we can't do the capability check here...=0D=0A=
+=09=09=09=09 */=0D=0A+=09=09=09=09u64 in_flags =3D FIELD_PREP(GENMASK_UL=
L(63, 32), ia->in.flags2)=0D=0A+=09=09=09=09=09=09| ia->in.flags;=0D=0A+=0D=
=0A+=09=09=09=09if (in_flags & FUSE_DAX_FMAP)=0D=0A+=09=09=09=09=09fc->fa=
mfs_iomap =3D 1;=0D=0A+=09=09=09}=0D=0A =09=09} else {=0D=0A =09=09=09ra_=
pages =3D fc->max_read / PAGE_SIZE;=0D=0A =09=09=09fc->no_lock =3D 1;=0D=0A=
@@ -1483,7 +1497,7 @@ static struct fuse_init_args *fuse_new_init(struct =
fuse_mount *fm)=0D=0A =09=09flags |=3D FUSE_SUBMOUNTS;=0D=0A =09if (IS_EN=
ABLED(CONFIG_FUSE_PASSTHROUGH))=0D=0A =09=09flags |=3D FUSE_PASSTHROUGH;=0D=
=0A-=09if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))=0D=0A+=09if (IS_ENABLED(CON=
FIG_FUSE_FAMFS_DAX) && capable(CAP_SYS_RAWIO))=0D=0A =09=09flags |=3D FUS=
E_DAX_FMAP;=0D=0A=20=0D=0A =09/*=0D=0Adiff --git a/include/uapi/linux/fus=
e.h b/include/uapi/linux/fuse.h=0D=0Aindex d323c20e79bd..4b84a58a8f1c 100=
644=0D=0A--- a/include/uapi/linux/fuse.h=0D=0A+++ b/include/uapi/linux/fu=
se.h=0D=0A@@ -243,6 +243,12 @@=0D=0A  *=0D=0A  *  7.46=0D=0A  *  - Add FU=
SE_DAX_FMAP capability - ability to handle in-kernel fsdax maps=0D=0A+ * =
 - Add the following structures for the GET_FMAP message reply components=
:=0D=0A+ *    - struct fuse_famfs_simple_ext=0D=0A+ *    - struct fuse_fa=
mfs_fmap_header=0D=0A+ *  - Add the following enumerated types=0D=0A+ *  =
  - enum fuse_famfs_file_type=0D=0A+ *    - enum famfs_ext_type=0D=0A  */=
=0D=0A=20=0D=0A #ifndef _LINUX_FUSE_H=0D=0A@@ -1316,4 +1322,38 @@ struct =
fuse_uring_cmd_req {=0D=0A =09uint8_t padding[6];=0D=0A };=0D=0A=20=0D=0A=
+/* Famfs fmap message components */=0D=0A+=0D=0A+#define FAMFS_FMAP_VERS=
ION 1=0D=0A+=0D=0A+#define FAMFS_FMAP_MAX 32768 /* Largest supported fmap=
 message */=0D=0A+=0D=0A+enum fuse_famfs_file_type {=0D=0A+=09FUSE_FAMFS_=
FILE_REG,=0D=0A+=09FUSE_FAMFS_FILE_SUPERBLOCK,=0D=0A+=09FUSE_FAMFS_FILE_L=
OG,=0D=0A+};=0D=0A+=0D=0A+enum famfs_ext_type {=0D=0A+=09FUSE_FAMFS_EXT_S=
IMPLE =3D 0,=0D=0A+};=0D=0A+=0D=0A+struct fuse_famfs_simple_ext {=0D=0A+=09=
uint32_t se_devindex;=0D=0A+=09uint32_t reserved;=0D=0A+=09uint64_t se_of=
fset;=0D=0A+=09uint64_t se_len;=0D=0A+};=0D=0A+=0D=0A+struct fuse_famfs_f=
map_header {=0D=0A+=09uint8_t file_type; /* enum fuse_famfs_file_type */=0D=
=0A+=09uint8_t reserved;=0D=0A+=09uint16_t fmap_version;=0D=0A+=09uint32_=
t ext_type; /* enum famfs_ext_type */=0D=0A+=09uint32_t nextents;=0D=0A+=09=
uint32_t fmap_size; /* Inclusive of this header */=0D=0A+=09uint64_t file=
_size;=0D=0A+=09uint64_t reserved1;=0D=0A+};=0D=0A+=0D=0A #endif /* _LINU=
X_FUSE_H */=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
