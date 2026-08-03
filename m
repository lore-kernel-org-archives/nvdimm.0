Received: from a48-179.smtp-out.amazonses.com (a48-179.smtp-out.amazonses.com [54.240.48.179])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E442F3C3D;
	Mon,  3 Aug 2026 02:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785724180; cv=none; b=Th8AVI8an+9jLAoud8UxtVYNhJovb/yohtwS9ht6d0iqbMZP/4StNHgO6czE8kYOSFMV1ecPb3AoT1QsnbSUh5Hdnwpagpm9PBB2f3fCI6jy51bqU0JrqqsaY2vjEGoNWOwG2dcgxsiINMvZ6WIakLGdwsKqzVuGoX2NoVarmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785724180; c=relaxed/simple;
	bh=cclcLQUthcB0Wr8312DTcdfU1zsU8GREwxAE1ttU6Kc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=aQREkZqnGA2kRSCv+K3rysUtTUmZP4Hmf1SLVhrFMO9XQhkNew58YmSZn6p4vKSpTu1rx1uj4TACMQRkjheRd3qDMnUAs10WDu3r8PRqjQbGlQrlK2bqq/E74yrmR6tFyFfCuqu1x1ZmDQPd2oMdOtizskrx1j2NMNOXwnJfXn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=YjTJLizr; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=DyLAiITy; arc=none smtp.client-ip=54.240.48.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="YjTJLizr";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="DyLAiITy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1785724177;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=cclcLQUthcB0Wr8312DTcdfU1zsU8GREwxAE1ttU6Kc=;
	b=YjTJLizrjZQMCjMEEJoJ/KRa0Sw1Kv58Ly06QMXTynAp9YD24Ck/IXyaNrYOmBJi
	LRXOejFW2GDbLxkqKBrBR86nVwv9Xlm4qlgUihSNcmv4etcDveMMggwiCyhk23TrYQg
	2J8wV3R+bYiqzJaxU+k2LSl495PEq0rkFywT7EEI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1785724177;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=cclcLQUthcB0Wr8312DTcdfU1zsU8GREwxAE1ttU6Kc=;
	b=DyLAiITyojVFsnfB4oYxbA1Up40uWFeeGvqKL3VO1MpwycaL/ooIYeahXe/kncar
	c2JE9ennt/lGUDLwf1DY2Wc9x6jgJtgSOTCtwEJzI16IlkqeST5dWBuxKCA7h0uRlM3
	+3HUTXzBKn/Lj7L4pLAlmtMMHgPpjAS+hkbP2+Hc=
Subject: [PATCH V12 08/12] famfs: iomap_begin and file-to-dax offset
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
Date: Mon, 3 Aug 2026 02:29:37 +0000
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
 <20260803022929.75893-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdIu+ovgpm4enMRRGNw8yF9Kn6iwAAETjF
Thread-Topic: [PATCH V12 08/12] famfs: iomap_begin and file-to-dax offset
 resolution
X-Wm-Sent-Timestamp: 1785724176
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019fc5748c1e-45cb66a3-f847-4c3e-8a89-a04c89d24b32-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.03-54.240.48.179

From: John Groves <John@Groves.net>=0D=0A=0D=0AAdd the iomap resolver tha=
t maps a file offset to a (daxdev, offset) pair:=0D=0Afamfs_meta_to_dax_o=
ffset() for simple extent lists and=0D=0Afamfs_meta_to_dax_offset_interle=
aved() for striped files, backed by the=0D=0Aper-daxdev health check (fam=
fs_dax_err) and table lookup=0D=0A(famfs_daxdev_for_index), plus famfs_io=
map_begin() and famfs_iomap_ops.=0D=0A=0D=0AWire it into the read, write =
and fault paths by replacing their=0D=0ANULL /*&famfs_iomap_ops*/ stub wi=
th &famfs_iomap_ops, so dax_iomap_rw() and=0D=0Adax_iomap_fault() now res=
olve through famfs.=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.ne=
t>=0D=0A---=0D=0A fs/famfs/famfs_file.c | 298 +++++++++++++++++++++++++++=
++++++++++++++-=0D=0A 1 file changed, 295 insertions(+), 3 deletions(-)=0D=
=0A=0D=0Adiff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c=0D=0A=
index d710c8a0c923..e7f271ce6d03 100644=0D=0A--- a/fs/famfs/famfs_file.c=0D=
=0A+++ b/fs/famfs/famfs_file.c=0D=0A@@ -320,6 +320,298 @@ famfs_file_ioct=
l(struct file *file, unsigned int cmd, unsigned long arg)=0D=0A =09return=
 rc;=0D=0A }=0D=0A=20=0D=0A+/********************************************=
*************************=0D=0A+ * iomap_operations=0D=0A+ *=0D=0A+ * Thi=
s stuff uses the iomap (dax-related) helpers to resolve file offsets to=0D=
=0A+ * offsets within a dax device.=0D=0A+ */=0D=0A+=0D=0A+static ssize_t=
 famfs_file_invalid(struct inode *inode);=0D=0A+=0D=0A+/* Check the healt=
h of a daxdev table slot */=0D=0A+static int famfs_dax_err(struct famfs_d=
axdev *dd)=0D=0A+{=0D=0A+=09if (!dd->valid) {=0D=0A+=09=09pr_debug("%s: d=
axdev=3D%s invalid\n", __func__, dd->name);=0D=0A+=09=09return -EIO;=0D=0A=
+=09}=0D=0A+=09if (dd->dax_err) {=0D=0A+=09=09pr_debug("%s: daxdev=3D%s d=
ax_err\n", __func__, dd->name);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A=
+=09if (dd->error) {=0D=0A+=09=09pr_debug("%s: daxdev=3D%s memory error\n=
", __func__, dd->name);=0D=0A+=09=09return -EHWPOISON;=0D=0A+=09}=0D=0A+=09=
return 0;=0D=0A+}=0D=0A+=0D=0A+/*=0D=0A+ * famfs_daxdev_from_index() - re=
solve an extent's dev_index to a health-checked=0D=0A+ * dax_device from =
the table. On success returns the dax_device and sets=0D=0A+ * *errp =3D =
0; on failure returns NULL and sets *errp (< 0).=0D=0A+ */=0D=0A+static s=
truct dax_device *=0D=0A+famfs_daxdev_from_index(struct famfs_fs_info *fs=
i, u64 dev_index, int *errp)=0D=0A+{=0D=0A+=09struct famfs_dax_devlist *d=
evlist =3D fsi->dax_devlist;=0D=0A+=09struct famfs_daxdev *dd;=0D=0A+=09i=
nt rc;=0D=0A+=0D=0A+=09if (!devlist || dev_index >=3D devlist->nslots) {=0D=
=0A+=09=09pr_debug("%s: dev_index %llu out of range\n",=0D=0A+=09=09=09__=
func__, dev_index);=0D=0A+=09=09*errp =3D -EIO;=0D=0A+=09=09return NULL;=0D=
=0A+=09}=0D=0A+=09dd =3D &devlist->devlist[dev_index];=0D=0A+=09rc =3D fa=
mfs_dax_err(dd);=0D=0A+=09if (rc) {=0D=0A+=09=09*errp =3D rc;=0D=0A+=09=09=
return NULL;=0D=0A+=09}=0D=0A+=09*errp =3D 0;=0D=0A+=09return dd->devp;=0D=
=0A+}=0D=0A+=0D=0A+static int=0D=0A+famfs_meta_to_dax_offset_interleaved(=
struct inode *inode, struct iomap *iomap,=0D=0A+=09=09=09 loff_t file_off=
set, off_t len, unsigned int flags)=0D=0A+{=0D=0A+=09struct famfs_fs_info=
  *fsi =3D inode->i_sb->s_fs_info;=0D=0A+=09struct famfs_file_meta *meta =
=3D inode->i_private;=0D=0A+=09loff_t local_offset =3D file_offset;=0D=0A=
+=09int rc;=0D=0A+=09int i;=0D=0A+=0D=0A+=09/* This function is only for =
extent_type FAMFS_IOC_EXT_INTERLEAVE */=0D=0A+=09if (meta->fm_extent_type=
 !=3D FAMFS_IOC_EXT_INTERLEAVE) {=0D=0A+=09=09pr_debug("%s: bad extent ty=
pe\n", __func__);=0D=0A+=09=09goto err_out;=0D=0A+=09}=0D=0A+=0D=0A+=09if=
 (fsi->deverror || famfs_file_invalid(inode))=0D=0A+=09=09goto err_out;=0D=
=0A+=0D=0A+=09iomap->offset =3D file_offset;=0D=0A+=0D=0A+=09for (i =3D 0=
; i < meta->fm_niext; i++) {=0D=0A+=09=09struct famfs_meta_interleaved_ex=
t *fei =3D &meta->ie[i];=0D=0A+=09=09u64 chunk_size =3D fei->fie_chunk_si=
ze;=0D=0A+=09=09u64 nstrips =3D fei->fie_nstrips;=0D=0A+=09=09u64 ext_siz=
e =3D fei->fie_nbytes;=0D=0A+=0D=0A+=09=09ext_size =3D min_t(u64, ext_siz=
e, meta->file_size);=0D=0A+=0D=0A+=09=09if (ext_size =3D=3D 0)=0D=0A+=09=09=
=09goto err_out;=0D=0A+=0D=0A+=09=09/* Is the data is in this striped ext=
ent=3F */=0D=0A+=09=09if (local_offset < ext_size) {=0D=0A+=09=09=09u64 c=
hunk_num       =3D local_offset / chunk_size;=0D=0A+=09=09=09u64 chunk_of=
fset    =3D local_offset % chunk_size;=0D=0A+=09=09=09u64 stripe_num     =
 =3D chunk_num / nstrips;=0D=0A+=09=09=09u64 strip_num       =3D chunk_nu=
m % nstrips;=0D=0A+=09=09=09u64 chunk_remainder =3D chunk_size - chunk_of=
fset;=0D=0A+=09=09=09u64 strip_offset    =3D chunk_offset + (stripe_num *=
 chunk_size);=0D=0A+=09=09=09struct famfs_meta_simple_ext *strip =3D &fei=
->ie_strips[strip_num];=0D=0A+=09=09=09struct dax_device *daxdev;=0D=0A+=0D=
=0A+=09=09=09/*=0D=0A+=09=09=09 * MAP_CREATE only checks that the strips'=
 combined=0D=0A+=09=09=09 * length covers the file, not that each strip i=
s large=0D=0A+=09=09=09 * enough for the chunks striped onto it. Guard ag=
ainst a=0D=0A+=09=09=09 * malformed fmap with an undersized strip so we n=
ever=0D=0A+=09=09=09 * resolve to a dax offset past the strip's extent.=0D=
=0A+=09=09=09 */=0D=0A+=09=09=09if (strip_offset >=3D strip->ext_len)=0D=0A=
+=09=09=09=09goto err_out;=0D=0A+=0D=0A+=09=09=09daxdev =3D famfs_daxdev_=
from_index(fsi, strip->dev_index, &rc);=0D=0A+=09=09=09if (!daxdev) {=0D=0A=
+=09=09=09=09meta->error =3D true;=0D=0A+=09=09=09=09return rc;=0D=0A+=09=
=09=09}=0D=0A+=0D=0A+=09=09=09iomap->addr    =3D strip->ext_offset + stri=
p_offset;=0D=0A+=09=09=09iomap->offset  =3D file_offset;=0D=0A+=09=09=09i=
omap->length  =3D min_t(loff_t, len, chunk_remainder);=0D=0A+=09=09=09iom=
ap->length  =3D min_t(loff_t, iomap->length,=0D=0A+=09=09=09=09=09       =
strip->ext_len - strip_offset);=0D=0A+=09=09=09iomap->dax_dev =3D daxdev;=
=0D=0A+=09=09=09iomap->type    =3D IOMAP_MAPPED;=0D=0A+=09=09=09iomap->fl=
ags   =3D flags;=0D=0A+=0D=0A+=09=09=09return 0;=0D=0A+=09=09}=0D=0A+=09=09=
local_offset -=3D ext_size; /* offset is beyond this striped extent */=0D=
=0A+=09}=0D=0A+=0D=0A+ err_out:=0D=0A+=09/*=0D=0A+=09 * We fell out the e=
nd of the extent list (access past EOF) or the file=0D=0A+=09 * is invali=
d. Return -EIO: iomap requires a non-zero-length mapping on=0D=0A+=09 * s=
uccess (iomap_iter_done() warns on length =3D=3D 0), so signal the error=0D=
=0A+=09 * rather than returning a zero-length IOMAP_MAPPED.=0D=0A+=09 */=0D=
=0A+=09pr_debug("%s: could not resolve file_offset %lld (past EOF=3F)\n",=
=0D=0A+=09=09 __func__, (long long)file_offset);=0D=0A+=0D=0A+=09iomap->a=
ddr    =3D 0; /* there is no valid dax device offset */=0D=0A+=09iomap->o=
ffset  =3D file_offset; /* file offset */=0D=0A+=09iomap->length  =3D 0;=0D=
=0A+=09iomap->dax_dev =3D famfs_daxdev_from_index(fsi, 0, &rc);=0D=0A+=09=
iomap->type    =3D IOMAP_MAPPED;=0D=0A+=09iomap->flags   =3D flags;=0D=0A=
+=0D=0A+=09return -EIO;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_meta_to_d=
ax_offset() - Resolve (file, offset, len) to (daxdev, offset, len)=0D=0A+=
 *=0D=0A+ * This function is called by famfs_iomap_begin() to resolve an =
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
n the extent list)=0D=0A+ * @flags:=0D=0A+ *=0D=0A+ * Return values: 0. (=
info is returned in a modified @iomap struct)=0D=0A+ */=0D=0A+static int=0D=
=0A+famfs_meta_to_dax_offset(struct inode *inode, struct iomap *iomap,=0D=
=0A+=09=09=09 loff_t file_offset, off_t len, unsigned int flags)=0D=0A+{=0D=
=0A+=09struct famfs_fs_info  *fsi =3D inode->i_sb->s_fs_info;=0D=0A+=09st=
ruct famfs_file_meta *meta =3D inode->i_private;=0D=0A+=09loff_t local_of=
fset =3D file_offset;=0D=0A+=09int rc;=0D=0A+=09int i;=0D=0A+=0D=0A+=09if=
 (fsi->deverror || famfs_file_invalid(inode))=0D=0A+=09=09goto err_out;=0D=
=0A+=0D=0A+=09if (meta->fm_extent_type =3D=3D FAMFS_IOC_EXT_INTERLEAVE)=0D=
=0A+=09=09return famfs_meta_to_dax_offset_interleaved(inode,=0D=0A+=09=09=
=09=09=09iomap, file_offset, len, flags);=0D=0A+=0D=0A+=09if (meta->fm_ex=
tent_type !=3D FAMFS_IOC_EXT_SIMPLE)=0D=0A+=09=09goto err_out;=0D=0A+=0D=0A=
+=09iomap->offset =3D file_offset;=0D=0A+=0D=0A+=09for (i =3D 0; i < meta=
->fm_nextents; i++) {=0D=0A+=09=09loff_t dax_ext_offset =3D meta->se[i].e=
xt_offset;=0D=0A+=09=09loff_t dax_ext_len    =3D meta->se[i].ext_len;=0D=0A=
+=0D=0A+=09=09if ((dax_ext_offset =3D=3D 0) &&=0D=0A+=09=09    (meta->fil=
e_type !=3D FAMFS_SUPERBLOCK))=0D=0A+=09=09=09pr_warn("%s: zero offset on=
 non-superblock file!!\n",=0D=0A+=09=09=09=09__func__);=0D=0A+=0D=0A+=09=09=
/* local_offset is the offset minus the size of extents skipped=0D=0A+=09=
=09 * so far; If local_offset < dax_ext_len, the data of interest=0D=0A+=09=
=09 * starts in this extent=0D=0A+=09=09 */=0D=0A+=09=09if (local_offset =
< dax_ext_len) {=0D=0A+=09=09=09loff_t ext_len_remainder =3D dax_ext_len =
- local_offset;=0D=0A+=09=09=09struct dax_device *daxdev;=0D=0A+=0D=0A+=09=
=09=09daxdev =3D famfs_daxdev_from_index(fsi,=0D=0A+=09=09=09=09=09=09met=
a->se[i].dev_index, &rc);=0D=0A+=09=09=09if (!daxdev) {=0D=0A+=09=09=09=09=
meta->error =3D true;=0D=0A+=09=09=09=09return rc;=0D=0A+=09=09=09}=0D=0A=
+=0D=0A+=09=09=09/*=0D=0A+=09=09=09 * OK, we found the file metadata exte=
nt where this=0D=0A+=09=09=09 * data begins=0D=0A+=09=09=09 * @local_offs=
et      - The offset within the current=0D=0A+=09=09=09 *                =
      extent=0D=0A+=09=09=09 * @ext_len_remainder - Remaining length of e=
xt after=0D=0A+=09=09=09 *                      skipping local_offset=0D=0A=
+=09=09=09 * Outputs:=0D=0A+=09=09=09 * iomap->addr:   the offset within =
the dax device where=0D=0A+=09=09=09 *                the  data starts=0D=
=0A+=09=09=09 * iomap->offset: the file offset=0D=0A+=09=09=09 * iomap->l=
ength: the valid length resolved here=0D=0A+=09=09=09 */=0D=0A+=09=09=09i=
omap->addr    =3D dax_ext_offset + local_offset;=0D=0A+=09=09=09iomap->of=
fset  =3D file_offset;=0D=0A+=09=09=09iomap->length  =3D min_t(loff_t, le=
n, ext_len_remainder);=0D=0A+=09=09=09iomap->dax_dev =3D daxdev;=0D=0A+=09=
=09=09iomap->type    =3D IOMAP_MAPPED;=0D=0A+=09=09=09iomap->flags   =3D =
flags;=0D=0A+=0D=0A+=09=09=09return 0;=0D=0A+=09=09}=0D=0A+=09=09local_of=
fset -=3D dax_ext_len; /* Get ready for the next extent */=0D=0A+=09}=0D=0A=
+=0D=0A+ err_out:=0D=0A+=09/*=0D=0A+=09 * We fell out the end of the exte=
nt list (access past EOF) or the file=0D=0A+=09 * is in an invalid state.=
 Return -EIO: iomap requires a non-zero-length=0D=0A+=09 * mapping on suc=
cess (iomap_iter_done() warns on length =3D=3D 0), so signal=0D=0A+=09 * =
the error rather than returning a zero-length IOMAP_MAPPED. dax turns=0D=0A=
+=09 * this into a short read/write or a SIGBUS.=0D=0A+=09 */=0D=0A+=09pr=
_debug("%s: could not resolve file_offset %lld (past EOF=3F)\n",=0D=0A+=09=
=09 __func__, (long long)file_offset);=0D=0A+=0D=0A+=09iomap->addr    =3D=
 0; /* there is no valid dax device offset */=0D=0A+=09iomap->offset  =3D=
 file_offset; /* file offset */=0D=0A+=09iomap->length  =3D 0;=0D=0A+=09i=
omap->dax_dev =3D famfs_daxdev_from_index(fsi, 0, &rc);=0D=0A+=09iomap->t=
ype    =3D IOMAP_MAPPED;=0D=0A+=09iomap->flags   =3D flags;=0D=0A+=0D=0A+=
=09return -EIO;=0D=0A+}=0D=0A+=0D=0A+/**=0D=0A+ * famfs_iomap_begin() - H=
andler for iomap_begin upcall from dax=0D=0A+ *=0D=0A+ * This function is=
 pretty simple because files are=0D=0A+ * * never partially allocated=0D=0A=
+ * * never have holes (never sparse)=0D=0A+ * * never "allocate on write=
"=0D=0A+ *=0D=0A+ * @inode:  inode for the file being accessed=0D=0A+ * @=
offset: offset within the file=0D=0A+ * @length: Length being accessed at=
 offset=0D=0A+ * @flags:=0D=0A+ * @iomap:  iomap struct to be filled in, =
resolving (offset, length) to=0D=0A+ *          (daxdev, offset, len)=0D=0A=
+ * @srcmap:=0D=0A+ */=0D=0A+static int=0D=0A+famfs_iomap_begin(struct in=
ode *inode, loff_t offset, loff_t length,=0D=0A+=09=09  unsigned int flag=
s, struct iomap *iomap, struct iomap *srcmap)=0D=0A+{=0D=0A+=09return fam=
fs_meta_to_dax_offset(inode, iomap, offset, length, flags);=0D=0A+}=0D=0A=
+=0D=0A+/* Note: We never need a special set of write_iomap_ops because f=
amfs never=0D=0A+ * performs allocation on write.=0D=0A+ */=0D=0A+const s=
truct iomap_ops famfs_iomap_ops =3D {=0D=0A+=09.iomap_begin=09=09=3D famf=
s_iomap_begin,=0D=0A+};=0D=0A+=0D=0A /***********************************=
**********************************=0D=0A  * vm_operations=0D=0A  */=0D=0A=
@@ -346,7 +638,7 @@ __famfs_filemap_fault(struct vm_fault *vmf, unsigned =
int order,=0D=0A =09=09file_update_time(vmf->vma->vm_file);=0D=0A =09}=0D=
=0A=20=0D=0A-=09ret =3D dax_iomap_fault(vmf, order, &pfn, NULL, NULL /*&f=
amfs_iomap_ops */);=0D=0A+=09ret =3D dax_iomap_fault(vmf, order, &pfn, NU=
LL, &famfs_iomap_ops);=0D=0A =09if (ret & VM_FAULT_NEEDDSYNC)=0D=0A =09=09=
ret =3D dax_finish_sync_fault(vmf, order, pfn);=0D=0A=20=0D=0A@@ -468,7 +=
760,7 @@ famfs_dax_read_iter(struct kiocb *iocb, struct iov_iter=09*to)=0D=
=0A =09=09return rc;=0D=0A =09}=0D=0A=20=0D=0A-=09rc =3D dax_iomap_rw(ioc=
b, to, NULL /*&famfs_iomap_ops */);=0D=0A+=09rc =3D dax_iomap_rw(iocb, to=
, &famfs_iomap_ops);=0D=0A =09inode_unlock_shared(inode);=0D=0A=20=0D=0A =
=09file_accessed(iocb->ki_filp);=0D=0A@@ -501,7 +793,7 @@ famfs_dax_write=
_iter(struct kiocb *iocb, struct iov_iter *from)=0D=0A =09=09return rc;=0D=
=0A =09}=0D=0A=20=0D=0A-=09rc =3D dax_iomap_rw(iocb, from, NULL /*&famfs_=
iomap_ops*/);=0D=0A+=09rc =3D dax_iomap_rw(iocb, from, &famfs_iomap_ops);=
=0D=0A =09inode_unlock(inode);=0D=0A =09return rc;=0D=0A }=0D=0A--=20=0D=0A=
2.53.0=0D=0A=0D=0A
