Received: from a11-174.smtp-out.amazonses.com (a11-174.smtp-out.amazonses.com [54.240.11.174])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73B92E62B3;
	Mon, 20 Jul 2026 03:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519198; cv=none; b=balFHvvwkn5qWaobwNhmSHfYt+cp8JDYggvSXpylA8d9n93I4N8UO1n5YNfnTsjpWWY6FOqR/4MM0iftgLbZqMJtG+wfANQBK/tImKH0Rf2oXLFzafoKFh8fbfXy9hPliiC6LbTRZOOVuhd6xes+Vb6BaIUbO2HRRgBDhtiyy9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519198; c=relaxed/simple;
	bh=MhEVLeA397QfpTukR00LYPLufAwA4jgOMl/PsKcE3UE=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=V3ph/Umal/stz/8IGNyUBEQFH3LL5aAGvumlICLDFTludx2BVQlMi6BIYFQW2P340OWGSVhMhMu43k/Bli55atN42imtAhr8PtF8SD7r/Pe+LXp7DH5iGo7Ej/ibwCCdHywZSAUMs0/mH6pnSRBWWhNxDXTnK4LkJ8XZAis6FyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=qVI+jIy0; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=i27iyYwg; arc=none smtp.client-ip=54.240.11.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="qVI+jIy0";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="i27iyYwg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519195;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=MhEVLeA397QfpTukR00LYPLufAwA4jgOMl/PsKcE3UE=;
	b=qVI+jIy0CMWeTdeuUVv3miYig0owmeIfDKi8oqK2APswI14kylCN1+2Ef0tJAKJk
	Q1Pret+HZ7poFTrFsDJD2Rk9cbPeSfsAXkTxl1WJXeiBnvOPZfmg/deOGGlHowqnz7A
	V5qjRHJLS2hPsr1EMZ8xPTgMMZ06E4VIiIiZmyy0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519195;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=MhEVLeA397QfpTukR00LYPLufAwA4jgOMl/PsKcE3UE=;
	b=i27iyYwgUZHpoaBS9D4vRmcaMDICrHa5Acz5dloejb6Zfb9Sfa5/LUlIRwgkhtVe
	dTDMUa74XKhgOhLhVZR/x5v2BvX36+ezWVMT/T5pvc8PlFdrcYRfrugET9aewBZ8aOw
	/UdMa7yRitC46pD5AywtuXXrdW3YTm/6fS8bbL84=
Subject: [PATCH V11 7/9] famfs_fuse: fail I/O on invalid or errored daxdevs
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
Date: Mon, 20 Jul 2026 03:46:35 +0000
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
 <20260720034626.68851-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAAFdm1
Thread-Topic: [PATCH V11 7/9] famfs_fuse: fail I/O on invalid or errored
 daxdevs
X-Wm-Sent-Timestamp: 1784519194
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da1faa3-75c84002-18fc-4762-a69c-ef33d15a449d-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.11.174

From: John Groves <john@groves.net>=0D=0A=0D=0AGate the iomap resolution =
path on the state of the daxdev backing each=0D=0Areferenced extent. famf=
s_dax_err() returns an error if the daxdev slot is=0D=0Ainvalid (-EIO), w=
as flagged dax_err (-EIO), or has reported a memory error=0D=0Avia notify=
_failure (-EHWPOISON). famfs_fileofs_to_daxofs() calls it and,=0D=0Aon er=
ror, marks the file (meta->error) and stops allowing access.=0D=0A=0D=0AM=
emory errors are at least somewhat more likely on disaggregated memory=0D=
=0Athan on-board memory. In general the recovery is to unmount and=0D=0Ar=
e-initialize the memory, though degraded modes may be possible in the=0D=0A=
future when famfs supports file systems backed by more than one daxdev=0D=
=0A(data on a working daxdev can still be accessed). For now, return erro=
rs=0D=0Afor any file that has touched an invalid or errored daxdev.=0D=0A=
=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse=
/famfs.c | 28 ++++++++++++++++++++++++++++=0D=0A 1 file changed, 28 inser=
tions(+)=0D=0A=0D=0Adiff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c=0D=0Ai=
ndex ac56317944d9..8d13282e8949 100644=0D=0A--- a/fs/fuse/famfs.c=0D=0A++=
+ b/fs/fuse/famfs.c=0D=0A@@ -589,6 +589,26 @@ famfs_file_init_dax(=0D=0A=20=
=0D=0A static int famfs_file_bad(struct inode *inode);=0D=0A=20=0D=0A+sta=
tic int famfs_dax_err(struct famfs_daxdev *dd)=0D=0A+{=0D=0A+=09if (!dd->=
valid) {=0D=0A+=09=09pr_err("%s: daxdev=3D%s invalid\n",=0D=0A+=09=09    =
   __func__, dd->name);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09if (=
dd->dax_err) {=0D=0A+=09=09pr_err("%s: daxdev=3D%s dax_err\n",=0D=0A+=09=09=
       __func__, dd->name);=0D=0A+=09=09return -EIO;=0D=0A+=09}=0D=0A+=09=
if (dd->error) {=0D=0A+=09=09pr_err("%s: daxdev=3D%s memory error\n",=0D=0A=
+=09=09       __func__, dd->name);=0D=0A+=09=09return -EHWPOISON;=0D=0A+=09=
}=0D=0A+=09return 0;=0D=0A+}=0D=0A+=0D=0A /**=0D=0A  * famfs_fileofs_to_d=
axofs() - Resolve (file, offset, len) to (daxdev, offset, len)=0D=0A  *=0D=
=0A@@ -661,6 +681,7 @@ famfs_fileofs_to_daxofs(struct inode *inode, struc=
t iomap *iomap,=0D=0A =09=09u64 daxdev_idx           =3D meta->se[i].dev_=
index;=0D=0A =09=09loff_t ext_len_remainder =3D dax_ext_len - local_offse=
t;=0D=0A =09=09struct famfs_daxdev *dd;=0D=0A+=09=09int rc;=0D=0A=20=0D=0A=
 =09=09if (daxdev_idx >=3D fc->dax_devlist->nslots) {=0D=0A =09=09=09pr_e=
rr("%s: daxdev_idx %llu >=3D nslots %d\n",=0D=0A@@ -670,6 +691,13 @@ famf=
s_fileofs_to_daxofs(struct inode *inode, struct iomap *iomap,=0D=0A=20=0D=
=0A =09=09dd =3D &fc->dax_devlist->devlist[daxdev_idx];=0D=0A=20=0D=0A+=09=
=09rc =3D famfs_dax_err(dd);=0D=0A+=09=09if (rc) {=0D=0A+=09=09=09/* Shut=
 down access to this file */=0D=0A+=09=09=09meta->error =3D true;=0D=0A+=09=
=09=09return rc;=0D=0A+=09=09}=0D=0A+=0D=0A =09=09iomap->addr    =3D dax_=
ext_offset + local_offset;=0D=0A =09=09iomap->offset  =3D file_offset;=0D=
=0A =09=09iomap->length  =3D min_t(loff_t, len, ext_len_remainder);=0D=0A=
--=20=0D=0A2.53.0=0D=0A=0D=0A
