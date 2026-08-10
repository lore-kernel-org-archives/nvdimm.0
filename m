Received: from a8-208.smtp-out.amazonses.com (a8-208.smtp-out.amazonses.com [54.240.8.208])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010338AC7D;
	Mon, 10 Aug 2026 20:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786393530; cv=none; b=JFFqJG/9X8AljK5e8JiWqT+N3uft/o6CWtI3YinGpjbMvVDVzdOdV+lahW9RCOujDz4OOLxlChq/GiMusqBFRpaWa/gdn4+p0HiCYAkv3jeZvTF16Tf33UGyVqyYIe+25buORw7mILEnXydeLt2Z/t4OBUJv0iTwv/UDBQEIQvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786393530; c=relaxed/simple;
	bh=yGO5BH0BOuHoIqMQncjKoQJlN/mC/0KQNGG6IsOeSTw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=nBnvtk5OtbglGj72uJPALDkWEBTaX/ZvqgqBForQBNjyTBspIcjV9/Z+rXJTff7JMA41Cv+PZVHDBDuIonRfsLfkUWE2fREgbdYIA8Ged4XvIGOdVw7C6kv3LJcQmer+txZeDWhaqYyv5+2/WRKlsBFHfXGvfYDPJ4nVPs1fs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=ir2fWpgm; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=rn8ROSmc; arc=none smtp.client-ip=54.240.8.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="ir2fWpgm";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="rn8ROSmc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1786393527;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=yGO5BH0BOuHoIqMQncjKoQJlN/mC/0KQNGG6IsOeSTw=;
	b=ir2fWpgme6g73ovKsC4Kj5LBJPkMtOqHmezqfiojbS6kX/G26KtSDIz30WpcxzMs
	T3TYjdRqQd1z/1HAvzX+fCx3ldmC/jkdGCP24PKETOM/uHZefFYwvDnKhfa7w7Zl4Ls
	xs0uhm82TraC+5mFD+Vyb16goiuiSNdo7+pLD2sE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1786393527;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=yGO5BH0BOuHoIqMQncjKoQJlN/mC/0KQNGG6IsOeSTw=;
	b=rn8ROSmcukPSWc5eTsWPdgwM7aWMoN3hmotw2mPrEtdKgkCfnxO2GEG7CMltrk1A
	hk6TTLU3hgLmqcv7boc9YMKXTt0MOZH4YVxiT9YDwFBn1th8ZLrg12TP5z4oq874wDY
	fp/qmFXDavCn4t00Rv3jwpcPXxacxqB6+pNjWMvQ=
Subject: [PATCH v13 08/12] famfs: iomap_begin and file-to-dax offset
 resolution
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
Date: Mon, 10 Aug 2026 20:25:27 +0000
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
 <20260810202519.96347-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdKQYd8BhJGjNjSyqPwMCz2Vr35AAAENFL
Thread-Topic: [PATCH v13 08/12] famfs: iomap_begin and file-to-dax offset
 resolution
X-Wm-Sent-Timestamp: 1786393525
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <0100019fed5a030d-9c8ae6b4-f9cf-411e-a8a7-60d7def29f00-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.10-54.240.8.208

From: John Groves <john@groves.net>=0D=0A=0D=0AAdd the iomap resolver tha=
t maps a file offset to a (daxdev, offset) pair:=0D=0Afamfs_meta_to_dax_o=
ffset() for simple extent lists and=0D=0Afamfs_meta_to_dax_offset_interle=
aved() for striped files, backed by the=0D=0Aper-daxdev health check (fam=
fs_dax_err) and table lookup=0D=0A(famfs_daxdev_for_index), plus famfs_io=
map_begin() and famfs_iomap_ops.=0D=0A=0D=0AWire it into the read, write =
and fault paths by replacing their=0D=0ANULL /*&famfs_iomap_ops*/ stub wi=
th &famfs_iomap_ops, so dax_iomap_rw() and=0D=0Adax_iomap_fault() now res=
olve through famfs.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.ne=
t>=0D=0A---=0D=0Av13:=0D=0A - iomap resolver: leave iomap->flags at 0 ins=
tead of storing the=0D=0A   ->iomap_begin operation flags, which was the =
wrong flags; drop the=20=0D=0A   now-unused flags parameter (Darrick)=0D=0A=
 - Type the resolver length parameter as loff_t (matching the ->iomap_beg=
in=0D=0A   caller) instead of off_t (Sashiko bot).=0D=0A - famfs_meta_to_=
dax_offset_interleaved(): run the fsi->deverror /=0D=0A   famfs_file_inva=
lid() guard before dereferencing meta, matching the=0D=0A   non-interleav=
ed resolver (latent/unreachable via the sole caller, but makes=0D=0A   th=
e function self-contained) (Sashiko bot).=0D=0A=0D=0A fs/famfs/famfs_file=
=2Ec | 305 +++++++++++++++++++++++++++++++++++++++++-=0D=0A 1 file change=
d, 302 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/fs/famfs/fam=
fs_file.c b/fs/famfs/famfs_file.c=0D=0Aindex ba19b17e80b1..670c8f961f11 1=
00644=0D=0A--- a/fs/famfs/famfs_file.c=0D=0A+++ b/fs/famfs/famfs_file.c=0D=
=0A@@ -322,6 +322,305 @@ famfs_file_ioctl(struct file *file, unsigned int=
 cmd, unsigned long arg)=0D=0A =09return rc;=0D=0A }=0D=0A=20=0D=0A+/****=
*****************************************************************=0D=0A+ =
* iomap_operations=0D=0A+ *=0D=0A+ * This stuff uses the iomap (dax-relat=
ed) helpers to resolve file offsets to=0D=0A+ * offsets within a dax devi=
ce.=0D=0A+ */=0D=0A+=0D=0A+static ssize_t famfs_file_invalid(struct inode=
 *inode);=0D=0A+=0D=0A+/* Check the health of a daxdev table slot */=0D=0A=
+static int=0D=0A+famfs_dax_err(struct famfs_daxdev *dd)=0D=0A+{=0D=0A+=09=
if (!dd->valid) {=0D=0A+=09=09pr_debug("%s: daxdev=3D%s invalid\n", __fun=
c__, dd->name);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (dd->dax_=
err) {=0D=0A+=09=09pr_debug("%s: daxdev=3D%s dax_err\n", __func__, dd->na=
me);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (dd->error) {=0D=0A+=
=09=09pr_debug("%s: daxdev=3D%s memory error\n", __func__, dd->name);=0D=0A=
+=09=09return -EHWPOISON;=0D=0A+=09}=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=
=0A+/*=0D=0A+ * famfs_daxdev_from_index() - resolve an extent's dev_index=
 to a health-checked=0D=0A+ * dax_device from the table. On success retur=
ns the dax_device and sets=0D=0A+ * *errp =3D 0; on failure returns NULL =
and sets *errp (< 0).=0D=0A+ */=0D=0A+static struct dax_device *=0D=0A+fa=
mfs_daxdev_from_index(struct famfs_fs_info *fsi, u64 dev_index, int *errp=
)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *devlist =3D fsi->dax_devlist=
;=0D=0A+=09struct famfs_daxdev *dd;=0D=0A+=09int rc;=0D=0A+=0D=0A+=09if (=
!devlist || dev_index >=3D devlist->nslots) {=0D=0A+=09=09pr_debug("%s: d=
ev_index %llu out of range\n",=0D=0A+=09=09=09__func__, dev_index);=0D=0A=
+=09=09*errp =3D -EIO;=0D=0A+=09=09return NULL;=0D=0A+=09}=0D=0A+=09dd =3D=
 &devlist->devlist[dev_index];=0D=0A+=09rc =3D famfs_dax_err(dd);=0D=0A+=09=
if (rc) {=0D=0A+=09=09*errp =3D rc;=0D=0A+=09=09return NULL;=0D=0A+=09}=0D=
=0A+=09*errp =3D 0;=0D=0A+=09return dd->devp;=0D=0A+}=0D=0A+=0D=0A+static=
 int=0D=0A+famfs_meta_to_dax_offset_interleaved(=0D=0A+=09struct inode *i=
node,=0D=0A+=09struct iomap *iomap,=0D=0A+=09loff_t file_offset,=0D=0A+=09=
loff_t len)=0D=0A+{=0D=0A+=09struct famfs_fs_info  *fsi =3D inode->i_sb->=
s_fs_info;=0D=0A+=09struct famfs_file_meta *meta =3D inode->i_private;=0D=
=0A+=09loff_t local_offset =3D file_offset;=0D=0A+=09int rc;=0D=0A+=09int=
 i;=0D=0A+=0D=0A+=09if (fsi->deverror || famfs_file_invalid(inode))=0D=0A=
+=09=09goto err_out;=0D=0A+=0D=0A+=09/* This function is only for extent_=
type FAMFS_IOC_EXT_INTERLEAVE */=0D=0A+=09if (meta->fm_extent_type !=3D F=
AMFS_IOC_EXT_INTERLEAVE) {=0D=0A+=09=09pr_debug("%s: bad extent type\n", =
__func__);=0D=0A+=09=09goto err_out;=0D=0A+=09}=0D=0A+=0D=0A+=09iomap->of=
fset =3D file_offset;=0D=0A+=0D=0A+=09for (i =3D 0; i < meta->fm_niext; i=
++) {=0D=0A+=09=09struct famfs_meta_interleaved_ext *fei =3D &meta->ie[i]=
;=0D=0A+=09=09u64 chunk_size =3D fei->fie_chunk_size;=0D=0A+=09=09u64 nst=
rips =3D fei->fie_nstrips;=0D=0A+=09=09u64 ext_size =3D fei->fie_nbytes;=0D=
=0A+=0D=0A+=09=09ext_size =3D min_t(u64, ext_size, meta->file_size);=0D=0A=
+=0D=0A+=09=09if (ext_size =3D=3D 0)=0D=0A+=09=09=09goto err_out;=0D=0A+=0D=
=0A+=09=09/* Is the data is in this striped extent=3F */=0D=0A+=09=09if (=
local_offset < ext_size) {=0D=0A+=09=09=09u64 chunk_num       =3D local_o=
ffset / chunk_size;=0D=0A+=09=09=09u64 chunk_offset    =3D local_offset %=
 chunk_size;=0D=0A+=09=09=09u64 stripe_num      =3D chunk_num / nstrips;=0D=
=0A+=09=09=09u64 strip_num       =3D chunk_num % nstrips;=0D=0A+=09=09=09=
u64 chunk_remainder =3D chunk_size - chunk_offset;=0D=0A+=09=09=09u64 str=
ip_offset    =3D chunk_offset + (stripe_num * chunk_size);=0D=0A+=09=09=09=
struct famfs_meta_simple_ext *strip =3D &fei->ie_strips[strip_num];=0D=0A=
+=09=09=09struct dax_device *daxdev;=0D=0A+=0D=0A+=09=09=09/*=0D=0A+=09=09=
=09 * MAP_CREATE only checks that the strips' combined=0D=0A+=09=09=09 * =
length covers the file, not that each strip is large=0D=0A+=09=09=09 * en=
ough for the chunks striped onto it. Guard against a=0D=0A+=09=09=09 * ma=
lformed fmap with an undersized strip so we never=0D=0A+=09=09=09 * resol=
ve to a dax offset past the strip's extent.=0D=0A+=09=09=09 */=0D=0A+=09=09=
=09if (strip_offset >=3D strip->ext_len)=0D=0A+=09=09=09=09goto err_out;=0D=
=0A+=0D=0A+=09=09=09daxdev =3D famfs_daxdev_from_index(fsi, strip->dev_in=
dex, &rc);=0D=0A+=09=09=09if (!daxdev) {=0D=0A+=09=09=09=09meta->error =3D=
 true;=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09=
iomap->addr    =3D strip->ext_offset + strip_offset;=0D=0A+=09=09=09iomap=
->offset  =3D file_offset;=0D=0A+=09=09=09iomap->length  =3D min_t(loff_t=
, len, chunk_remainder);=0D=0A+=09=09=09iomap->length  =3D min_t(loff_t, =
iomap->length,=0D=0A+=09=09=09=09=09       strip->ext_len - strip_offset)=
;=0D=0A+=09=09=09iomap->dax_dev =3D daxdev;=0D=0A+=09=09=09iomap->type   =
 =3D IOMAP_MAPPED;=0D=0A+=0D=0A+=09=09=09return 0;=0D=0A+=09=09}=0D=0A+=09=
=09local_offset -=3D ext_size; /* offset is beyond this striped extent */=
=0D=0A+=09}=0D=0A+=0D=0A+ err_out:=0D=0A+=09/*=0D=0A+=09 * We fell out th=
e end of the extent list (access past EOF) or the file=0D=0A+=09 * is inv=
alid. Return -EIO: iomap requires a non-zero-length mapping on=0D=0A+=09 =
* success (iomap_iter_done() warns on length =3D=3D 0), so signal the err=
or=0D=0A+=09 * rather than returning a zero-length IOMAP_MAPPED.=0D=0A+=09=
 */=0D=0A+=09pr_debug("%s: could not resolve file_offset %lld (past EOF=3F=
)\n",=0D=0A+=09=09 __func__, (long long)file_offset);=0D=0A+=0D=0A+=09iom=
ap->addr    =3D 0; /* there is no valid dax device offset */=0D=0A+=09iom=
ap->offset  =3D file_offset; /* file offset */=0D=0A+=09iomap->length  =3D=
 0;=0D=0A+=09iomap->dax_dev =3D famfs_daxdev_from_index(fsi, 0, &rc);=0D=0A=
+=09iomap->type    =3D IOMAP_MAPPED;=0D=0A+=0D=0A+=09return -EIO;=0D=0A+}=
=0D=0A+=0D=0A+/**=0D=0A+ * famfs_meta_to_dax_offset() - Resolve (file, of=
fset, len) to (daxdev, offset, len)=0D=0A+ *=0D=0A+ * This function is ca=
lled by famfs_iomap_begin() to resolve an offset in a=0D=0A+ * file to an=
 offset in a dax device. This is upcalled from dax from calls to=0D=0A+ *=
 both  * dax_iomap_fault() and dax_iomap_rw(). Dax finishes the job resol=
ving=0D=0A+ * a fault to a specific physical page (the fault case) or doi=
ng a memcpy=0D=0A+ * variant (the rw case)=0D=0A+ *=0D=0A+ * Pages can be=
 PTE (4k), PMD (2MiB) or (theoretically) PuD (1GiB)=0D=0A+ * (these sizes=
 are for X86; may vary on other cpu architectures=0D=0A+ *=0D=0A+ * @inod=
e:  The file where the fault occurred=0D=0A+ * @iomap:       To be filled=
 in to indicate where to find the right memory,=0D=0A+ *               re=
lative  to a dax device.=0D=0A+ * @file_offset: Within the file where the=
 fault occurred (will be page boundary)=0D=0A+ * @len:         The length=
 of the faulted mapping (will be a page multiple)=0D=0A+ *               =
(will be trimmed in *iomap if it's disjoint in the extent list)=0D=0A+ *=0D=
=0A+ * Return values: 0. (info is returned in a modified @iomap struct)=0D=
=0A+ */=0D=0A+static int=0D=0A+famfs_meta_to_dax_offset(=0D=0A+=09struct =
inode *inode,=0D=0A+=09struct iomap *iomap,=0D=0A+=09loff_t file_offset,=0D=
=0A+=09loff_t len)=0D=0A+{=0D=0A+=09struct famfs_fs_info  *fsi =3D inode-=
>i_sb->s_fs_info;=0D=0A+=09struct famfs_file_meta *meta =3D inode->i_priv=
ate;=0D=0A+=09loff_t local_offset =3D file_offset;=0D=0A+=09int rc;=0D=0A=
+=09int i;=0D=0A+=0D=0A+=09if (fsi->deverror || famfs_file_invalid(inode)=
)=0D=0A+=09=09goto err_out;=0D=0A+=0D=0A+=09if (meta->fm_extent_type =3D=3D=
 FAMFS_IOC_EXT_INTERLEAVE)=0D=0A+=09=09return famfs_meta_to_dax_offset_in=
terleaved(inode,=0D=0A+=09=09=09=09=09iomap, file_offset, len);=0D=0A+=0D=
=0A+=09if (meta->fm_extent_type !=3D FAMFS_IOC_EXT_SIMPLE)=0D=0A+=09=09go=
to err_out;=0D=0A+=0D=0A+=09iomap->offset =3D file_offset;=0D=0A+=0D=0A+=09=
for (i =3D 0; i < meta->fm_nextents; i++) {=0D=0A+=09=09loff_t dax_ext_of=
fset =3D meta->se[i].ext_offset;=0D=0A+=09=09loff_t dax_ext_len    =3D me=
ta->se[i].ext_len;=0D=0A+=0D=0A+=09=09if ((dax_ext_offset =3D=3D 0) &&=0D=
=0A+=09=09    (meta->file_type !=3D FAMFS_SUPERBLOCK))=0D=0A+=09=09=09pr_=
warn("%s: zero offset on non-superblock file!!\n",=0D=0A+=09=09=09=09__fu=
nc__);=0D=0A+=0D=0A+=09=09/* local_offset is the offset minus the size of=
 extents skipped=0D=0A+=09=09 * so far; If local_offset < dax_ext_len, th=
e data of interest=0D=0A+=09=09 * starts in this extent=0D=0A+=09=09 */=0D=
=0A+=09=09if (local_offset < dax_ext_len) {=0D=0A+=09=09=09loff_t ext_len=
_remainder =3D dax_ext_len - local_offset;=0D=0A+=09=09=09struct dax_devi=
ce *daxdev;=0D=0A+=0D=0A+=09=09=09daxdev =3D famfs_daxdev_from_index(fsi,=
=0D=0A+=09=09=09=09=09=09meta->se[i].dev_index, &rc);=0D=0A+=09=09=09if (=
!daxdev) {=0D=0A+=09=09=09=09meta->error =3D true;=0D=0A+=09=09=09=09retu=
rn rc;=0D=0A+=09=09=09}=0D=0A+=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * OK, we=
 found the file metadata extent where this=0D=0A+=09=09=09 * data begins=0D=
=0A+=09=09=09 * @local_offset      - The offset within the current=0D=0A+=
=09=09=09 *                      extent=0D=0A+=09=09=09 * @ext_len_remain=
der - Remaining length of ext after=0D=0A+=09=09=09 *                    =
  skipping local_offset=0D=0A+=09=09=09 * Outputs:=0D=0A+=09=09=09 * ioma=
p->addr:   the offset within the dax device where=0D=0A+=09=09=09 *      =
          the  data starts=0D=0A+=09=09=09 * iomap->offset: the file offs=
et=0D=0A+=09=09=09 * iomap->length: the valid length resolved here=0D=0A+=
=09=09=09 */=0D=0A+=09=09=09iomap->addr    =3D dax_ext_offset + local_off=
set;=0D=0A+=09=09=09iomap->offset  =3D file_offset;=0D=0A+=09=09=09iomap-=
>length  =3D min_t(loff_t, len, ext_len_remainder);=0D=0A+=09=09=09iomap-=
>dax_dev =3D daxdev;=0D=0A+=09=09=09iomap->type    =3D IOMAP_MAPPED;=0D=0A=
+=0D=0A+=09=09=09return 0;=0D=0A+=09=09}=0D=0A+=09=09local_offset -=3D da=
x_ext_len; /* Get ready for the next extent */=0D=0A+=09}=0D=0A+=0D=0A+ e=
rr_out:=0D=0A+=09/*=0D=0A+=09 * We fell out the end of the extent list (a=
ccess past EOF) or the file=0D=0A+=09 * is in an invalid state. Return -E=
IO: iomap requires a non-zero-length=0D=0A+=09 * mapping on success (ioma=
p_iter_done() warns on length =3D=3D 0), so signal=0D=0A+=09 * the error =
rather than returning a zero-length IOMAP_MAPPED. dax turns=0D=0A+=09 * t=
his into a short read/write or a SIGBUS.=0D=0A+=09 */=0D=0A+=09pr_debug("=
%s: could not resolve file_offset %lld (past EOF=3F)\n",=0D=0A+=09=09 __f=
unc__, (long long)file_offset);=0D=0A+=0D=0A+=09iomap->addr    =3D 0; /* =
there is no valid dax device offset */=0D=0A+=09iomap->offset  =3D file_o=
ffset; /* file offset */=0D=0A+=09iomap->length  =3D 0;=0D=0A+=09iomap->d=
ax_dev =3D famfs_daxdev_from_index(fsi, 0, &rc);=0D=0A+=09iomap->type    =
=3D IOMAP_MAPPED;=0D=0A+=0D=0A+=09return -EIO;=0D=0A+}=0D=0A+=0D=0A+/**=0D=
=0A+ * famfs_iomap_begin() - Handler for iomap_begin upcall from dax=0D=0A=
+ *=0D=0A+ * This function is pretty simple because files are=0D=0A+ * * =
never partially allocated=0D=0A+ * * never have holes (never sparse)=0D=0A=
+ * * never "allocate on write"=0D=0A+ *=0D=0A+ * @inode:  inode for the =
file being accessed=0D=0A+ * @offset: offset within the file=0D=0A+ * @le=
ngth: Length being accessed at offset=0D=0A+ * @flags:=0D=0A+ * @iomap:  =
iomap struct to be filled in, resolving (offset, length) to=0D=0A+ *     =
     (daxdev, offset, len)=0D=0A+ * @srcmap:=0D=0A+ */=0D=0A+static int=0D=
=0A+famfs_iomap_begin(=0D=0A+=09struct inode *inode,=0D=0A+=09loff_t offs=
et,=0D=0A+=09loff_t length,=0D=0A+=09unsigned int flags,=0D=0A+=09struct =
iomap *iomap,=0D=0A+=09struct iomap *srcmap)=0D=0A+{=0D=0A+=09return famf=
s_meta_to_dax_offset(inode, iomap, offset, length);=0D=0A+}=0D=0A+=0D=0A+=
/* Note: We never need a special set of write_iomap_ops because famfs nev=
er=0D=0A+ * performs allocation on write.=0D=0A+ */=0D=0A+const struct io=
map_ops famfs_iomap_ops =3D {=0D=0A+=09.iomap_begin=09=09=3D famfs_iomap_=
begin,=0D=0A+};=0D=0A+=0D=0A /*******************************************=
**************************=0D=0A  * vm_operations=0D=0A  */=0D=0A@@ -350,=
7 +649,7 @@ __famfs_filemap_fault(=0D=0A =09=09file_update_time(vmf->vma-=
>vm_file);=0D=0A =09}=0D=0A=20=0D=0A-=09ret =3D dax_iomap_fault(vmf, orde=
r, &pfn, NULL, NULL /*&famfs_iomap_ops */);=0D=0A+=09ret =3D dax_iomap_fa=
ult(vmf, order, &pfn, NULL, &famfs_iomap_ops);=0D=0A =09if (ret & VM_FAUL=
T_NEEDDSYNC)=0D=0A =09=09ret =3D dax_finish_sync_fault(vmf, order, pfn);=0D=
=0A=20=0D=0A@@ -471,7 +770,7 @@ famfs_dax_read_iter(struct kiocb *iocb, s=
truct iov_iter=09*to)=0D=0A =09=09return rc;=0D=0A =09}=0D=0A=20=0D=0A-=09=
rc =3D dax_iomap_rw(iocb, to, NULL /*&famfs_iomap_ops */);=0D=0A+=09rc =3D=
 dax_iomap_rw(iocb, to, &famfs_iomap_ops);=0D=0A =09inode_unlock_shared(i=
node);=0D=0A=20=0D=0A =09if (rc > 0)=0D=0A@@ -507,7 +806,7 @@ famfs_dax_w=
rite_iter(struct kiocb *iocb, struct iov_iter *from)=0D=0A=20=0D=0A =09ki=
ocb_modified(iocb); /* mtime/ctime + strip set[e]uid */=0D=0A=20=0D=0A-=09=
rc =3D dax_iomap_rw(iocb, from, NULL /*&famfs_iomap_ops*/);=0D=0A+=09rc =3D=
 dax_iomap_rw(iocb, from, &famfs_iomap_ops);=0D=0A =09inode_unlock(inode)=
;=0D=0A =09return rc;=0D=0A }=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
