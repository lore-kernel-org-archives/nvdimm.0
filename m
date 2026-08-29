Received: from a48-178.smtp-out.amazonses.com (a48-178.smtp-out.amazonses.com [54.240.48.178])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7821A434;
	Sat, 29 Aug 2026 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788023458; cv=none; b=JeVx8faGo0PWGjNZUJTM47hO+qZ1Es7Az6DXfLHZBQZiuKgR68WeY56eQJRnfNdERcFtSzw77H9BXf6jx396M3c0blO62wJaiNYfdBXNiNCaDx9cKthVuBvAbMH6GlUDYFIaZHSqYSpMySeVf6krDSY6TORpQd1c4F6ctdg4BYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788023458; c=relaxed/simple;
	bh=kbx7Bd2T+sev84d54IrytMD8yUSFgmJSOciEGSPvHn4=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=LUzYpB9EteSAGW8HP3KvtIQw6yg20kCnHdbax3zB/4m5IsojmlygfWT101U8WzN+Lh/7Jdq77yjlzWImeRhXQ3r3BSrOCiZ98jejdEW270K4dVBUiV4HQHB/v6sIyVBSYxE/Nk1+0gK6tyXSjT8mll8ruEIjFbzZTy3sx9BXimo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=O4MzB2ZK; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=PIVPSLfp; arc=none smtp.client-ip=54.240.48.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="O4MzB2ZK";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="PIVPSLfp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=rjayupzefgi7e6fmzxcxe4cv4arrjs35; d=jagalactic.com; t=1788023452;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=kbx7Bd2T+sev84d54IrytMD8yUSFgmJSOciEGSPvHn4=;
	b=O4MzB2ZKlQ1iknrNInfHR7SSTQUX66XKkH3IyY9bNDQ5wDbslZTfuxCFMh9u75Kw
	TV0s/Pxy1qYzBbad+yG6tqxFia8I1yvEAHPlp8RE7bWCrm4P9xrbvFEgtchzEaIiKON
	OYsGb5EF+XzMQAWymVteBEnijBylor+2ca9NFE3I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1788023452;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=kbx7Bd2T+sev84d54IrytMD8yUSFgmJSOciEGSPvHn4=;
	b=PIVPSLfpA5eN4CsJHt1ZM28mKRJIMiCdreYzoro61uUPQgVafLLb4Nh6aZtes9fE
	CXOGnJB4Jov6RsdLO8VOwudOADRN5U+HnT3Haj1uiA8XQVUT/hGdyrzJZYyi6ixjzQz
	HsXMY7kVfHTXXdSL08pbmp6IHs14nNFPSuOHmq2Q=
Subject: [PATCH V14 01/12] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
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
Date: Sat, 29 Aug 2026 17:10:52 +0000
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
 <20260829171043.7363-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdN9lAfqnLmnnsQyaIwPphM+3eHAAABeEr
Thread-Topic: [PATCH V14 01/12] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
X-Wm-Sent-Timestamp: 1788023451
X-Original-Mailer: git-send-email 2.55.0
Message-ID: <010001a04e80b31a-b1fe9f64-9df4-4e8a-aa1a-c85f4a6493c6-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.08.29-54.240.48.178

From: John Groves <John@Groves.net>=0D=0A=0D=0AThis fix is in response to=
 a Sashiko review, and some subsequent=0D=0Aanalysis.=0D=0A=0D=0Adax_dev_=
get() uses iget5_locked() which creates a new inode if no=0D=0Amatching o=
ne exists. This is correct for the internal caller=0D=0A(alloc_dax), but =
dangerous for external callers that look up devices=0D=0Afrom user-suppli=
ed or metadata-supplied dev_t values:=0D=0A=0D=0A1. A new inode is create=
d with DAXDEV_ALIVE set but no backing driver,=0D=0A   no ops, and no IDA=
-allocated minor number.=0D=0A=0D=0A2. On teardown, dax_destroy_inode() w=
arns because kill_dax() was never=0D=0A   called, and dax_free_inode() ca=
lls ida_free() for a minor that was=0D=0A   never ida_alloc'd -- potentia=
lly freeing the minor of a real device.=0D=0A=0D=0AAdd dax_dev_find() whi=
ch uses ilookup5() for lookup-only semantics:=0D=0Ait returns an existing=
 dax_device with an elevated inode reference, or=0D=0ANULL if no device w=
ith the given dev_t exists. It never creates inodes.=0D=0AA dax_alive() c=
heck under dax_read_lock() guards against returning a=0D=0Adevice that is=
 concurrently being torn down by kill_dax().=0D=0A=0D=0AMake dax_dev_get(=
) static again (internal to super.c for alloc_dax),=0D=0Aexport dax_dev_f=
ind() instead, and update the two external callers=0D=0A(famfs_inode.c, f=
amfs.c). Also add the missing CONFIG_DAX=3Dn stub.=0D=0A=0D=0AAbout the '=
fixes' tag: this removes the export of dax_dev_get(),=0D=0Awhich was flaw=
ed, and replaces is with dax_dev_find(). It feels like=0D=0Athe fixes tag=
 makes sense for correcting an ABI error.=0D=0A=0D=0AFixes: 2ae624d5a555d=
 ("dax: export dax_dev_get()")=0D=0A=0D=0AReviewed-by: Dave Jiang <dave.j=
iang@intel.com>=0D=0AReviewed-by: Alison Schofield <alison.schofield@inte=
l.com>=0D=0A=0D=0AReviewed-by: "Darrick J. Wong" <djwong@kernel.org>=0D=0A=
Signed-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=0D=0A drivers=
/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++--=0D=0A include/li=
nux/dax.h |  6 +++++-=0D=0A 2 files changed, 41 insertions(+), 3 deletion=
s(-)=0D=0A=0D=0Adiff --git a/drivers/dax/super.c b/drivers/dax/super.c=0D=
=0Aindex 25cf99dd9360..0fc14d4f8198 100644=0D=0A--- a/drivers/dax/super.c=
=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -521,7 +521,7 @@ static int dax_s=
et(struct inode *inode, void *data)=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=
=0A-struct dax_device *dax_dev_get(dev_t devt)=0D=0A+static struct dax_de=
vice *dax_dev_get(dev_t devt)=0D=0A {=0D=0A =09struct dax_device *dax_dev=
;=0D=0A =09struct inode *inode;=0D=0A@@ -544,7 +544,41 @@ struct dax_devi=
ce *dax_dev_get(dev_t devt)=0D=0A=20=0D=0A =09return dax_dev;=0D=0A }=0D=0A=
-EXPORT_SYMBOL_GPL(dax_dev_get);=0D=0A+=0D=0A+/**=0D=0A+ * dax_dev_find -=
 look up an existing dax_device by dev_t=0D=0A+ * @devt: the device numbe=
r to find=0D=0A+ *=0D=0A+ * Returns a dax_device with an elevated inode r=
eference, or NULL if no=0D=0A+ * device with the given dev_t exists. Unli=
ke dax_dev_get(), this never=0D=0A+ * allocates a new inode -- it is safe=
 for external callers that are looking=0D=0A+ * up devices from user-supp=
lied or metadata-supplied dev_t values.=0D=0A+ *=0D=0A+ * Caller must put=
_dax() the returned device when done.=0D=0A+ */=0D=0A+struct dax_device *=
dax_dev_find(dev_t devt)=0D=0A+{=0D=0A+=09struct dax_device *dax_dev;=0D=0A=
+=09struct inode *inode;=0D=0A+=09int id;=0D=0A+=0D=0A+=09inode =3D ilook=
up5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),=0D=0A+=09=09=09 dax_=
test, &devt);=0D=0A+=09if (!inode)=0D=0A+=09=09return NULL;=0D=0A+=0D=0A+=
=09dax_dev =3D to_dax_dev(inode);=0D=0A+=09id =3D dax_read_lock();=0D=0A+=
=09if (!dax_alive(dax_dev)) {=0D=0A+=09=09dax_read_unlock(id);=0D=0A+=09=09=
iput(inode);=0D=0A+=09=09return NULL;=0D=0A+=09}=0D=0A+=09dax_read_unlock=
(id);=0D=0A+=0D=0A+=09return dax_dev;=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax=
_dev_find);=0D=0A=20=0D=0A struct dax_device *alloc_dax(void *private, co=
nst struct dax_operations *ops)=0D=0A {=0D=0Adiff --git a/include/linux/d=
ax.h b/include/linux/dax.h=0D=0Aindex fe6c3ded1b50..29113eb95e72 100644=0D=
=0A--- a/include/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -54,7=
 +54,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_op=
erations *ops);=0D=0A void *dax_holder(struct dax_device *dax_dev);=0D=0A=
 void put_dax(struct dax_device *dax_dev);=0D=0A void kill_dax(struct dax=
_device *dax_dev);=0D=0A-struct dax_device *dax_dev_get(dev_t devt);=0D=0A=
+struct dax_device *dax_dev_find(dev_t devt);=0D=0A void dax_write_cache(=
struct dax_device *dax_dev, bool wc);=0D=0A bool dax_write_cache_enabled(=
struct dax_device *dax_dev);=0D=0A bool dax_synchronous(struct dax_device=
 *dax_dev);=0D=0A@@ -92,6 +92,10 @@ static inline void put_dax(struct dax=
_device *dax_dev)=0D=0A static inline void kill_dax(struct dax_device *da=
x_dev)=0D=0A {=0D=0A }=0D=0A+static inline struct dax_device *dax_dev_fin=
d(dev_t devt)=0D=0A+{=0D=0A+=09return NULL;=0D=0A+}=0D=0A static inline v=
oid dax_write_cache(struct dax_device *dax_dev, bool wc)=0D=0A {=0D=0A }=0D=
=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
