Received: from a11-6.smtp-out.amazonses.com (a11-6.smtp-out.amazonses.com [54.240.11.6])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C15837BE91
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477580; cv=none; b=pFtvbeSu8miaZ+bC9xfT1IZyCCMgPh5ULl/kGiRWdcKlGvqMchXGrtRGoXHGP8iORkSAu1GQ0AoVRlU6fAYyWujlaQX0STU/+ST2WF7dAj7fXOgz3q3q68kvtVGUaL5B2z6BrV6DgvnUIyLBzzagYKK7QVGBGgFY+4REEtxhR2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477580; c=relaxed/simple;
	bh=OiQmo1C52slDFRLYhOHFP/kYnr45ga6g7NhS5+M2BuI=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=a2avaJr7GMXgt70Urzp+U8T6cM4TSYOvXjb4XY3fRj03NviyAQSOBwBzBbb1Ge8ArE1cW8ILL6tuNw9NebI0qIZnHyNaIQZAQwM3Jz0DjNbQVJnfeSxh+/BZJFySJWto205B9sdBRMtuBC2swrpcamcT5hNvaCVoYQoHLSAdbOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=ERFLL6hi; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=ikAU17ED; arc=none smtp.client-ip=54.240.11.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="ERFLL6hi";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ikAU17ED"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477574;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=OiQmo1C52slDFRLYhOHFP/kYnr45ga6g7NhS5+M2BuI=;
	b=ERFLL6hirT8niQ06x+g1i/C3VKx38gxQDF0ip7sG674QB1jHgyC7O0AZC9Q6bDxk
	r+F1c+BhqsiX3pfy67RvsD9UVMTTafXVShP9xzsyet7ILw4vbU+9Qz28azffrVT2YEi
	/StSUdqiAeOsrYLeW1Asq2NotsGw3lV1TnYe4eqA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477574;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=OiQmo1C52slDFRLYhOHFP/kYnr45ga6g7NhS5+M2BuI=;
	b=ikAU17EDlff33OVen5q+vdbeyRdcdSWjuEN2FclVf1Z2r1FICz4nWKLmInqDfegq
	sV4vHqXouMaCIkcngSYJacws21sDHEz5lp7ApVNv67cPljIHiNpKm1eAGAj2vptYqtB
	ps6OMOf9G2f+nL29jyy8qG5ZFGk/Wk5bXmAIsmJA=
Subject: [PATCH V2 6/7] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Fri, 22 May 2026 19:19:34 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
References: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com> 
 <20260522191925.79227-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h+7e4zSojcNRQ2wV9eJQr6w4gAADCAS
Thread-Topic: [PATCH V2 6/7] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
X-Wm-Sent-Timestamp: 1779477573
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e5120f45c-f2183035-0304-4601-87bc-85d933ce51e7-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.11.6

From: John Groves <John@Groves.net>=0D=0A=0D=0AThis fix is in response to=
 a Sashiko review, and some subsequent=0D=0Aanalysis.=0D=0A=0D=0Adax_dev_=
get() uses iget5_locked() which creates a new inode if no=0D=0Amatching o=
ne exists. This is correct for the internal caller=0D=0A(alloc_dax), but =
dangerous for external callers that look up devices=0D=0Afrom user-suppli=
ed or metadata-supplied dev_t values:=0D=0A=0D=0A1. A new inode is create=
d with DAXDEV_ALIVE set but no backing driver,=0D=0A   no ops, and no IDA=
-allocated minor number.=0D=0A=0D=0A2. On teardown, dax_destroy_inode() w=
arns because kill_dax() was never=0D=0A   called, and dax_free_inode() ca=
lls ida_free() for a minor that was=0D=0A   never ida_alloc'd =E2=80=94 p=
otentially freeing the minor of a real device.=0D=0A=0D=0AAdd dax_dev_fin=
d() which uses ilookup5() for lookup-only semantics:=0D=0Ait returns an e=
xisting dax_device with an elevated inode reference, or=0D=0ANULL if no d=
evice with the given dev_t exists. It never creates inodes.=0D=0A=0D=0AMa=
ke dax_dev_get() static again (internal to super.c for alloc_dax),=0D=0Ae=
xport dax_dev_find() instead, and update the two external callers=0D=0A(f=
amfs_inode.c, famfs.c). Also add the missing CONFIG_DAX=3Dn stub.=0D=0A=0D=
=0AFixes: 2ae624d5a555d ("dax: export dax_dev_get()")=0D=0ASigned-off-by:=
 John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/super.c | 27 ++=
+++++++++++++++++++++++--=0D=0A include/linux/dax.h |  6 +++++-=0D=0A 2 f=
iles changed, 30 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/dr=
ivers/dax/super.c b/drivers/dax/super.c=0D=0Aindex fa1d2a6eb2408..79e5823=
d1010d 100644=0D=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super=
=2Ec=0D=0A@@ -541,7 +541,7 @@ static int dax_set(struct inode *inode, voi=
d *data)=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A-struct dax_device *dax=
_dev_get(dev_t devt)=0D=0A+static struct dax_device *dax_dev_get(dev_t de=
vt)=0D=0A {=0D=0A =09struct dax_device *dax_dev;=0D=0A =09struct inode *i=
node;=0D=0A@@ -564,7 +564,30 @@ struct dax_device *dax_dev_get(dev_t devt=
)=0D=0A=20=0D=0A =09return dax_dev;=0D=0A }=0D=0A-EXPORT_SYMBOL_GPL(dax_d=
ev_get);=0D=0A+=0D=0A+/**=0D=0A+ * dax_dev_find - look up an existing dax=
_device by dev_t=0D=0A+ * @devt: the device number to find=0D=0A+ *=0D=0A=
+ * Returns a dax_device with an elevated inode reference, or NULL if no=0D=
=0A+ * device with the given dev_t exists. Unlike dax_dev_get(), this nev=
er=0D=0A+ * allocates a new inode =E2=80=94 it is safe for external calle=
rs that are looking=0D=0A+ * up devices from user-supplied or metadata-su=
pplied dev_t values.=0D=0A+ *=0D=0A+ * Caller must put_dax() the returned=
 device when done.=0D=0A+ */=0D=0A+struct dax_device *dax_dev_find(dev_t =
devt)=0D=0A+{=0D=0A+=09struct inode *inode;=0D=0A+=0D=0A+=09inode =3D ilo=
okup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),=0D=0A+=09=09=09 da=
x_test, &devt);=0D=0A+=09if (!inode)=0D=0A+=09=09return NULL;=0D=0A+=0D=0A=
+=09return to_dax_dev(inode);=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax_dev_fin=
d);=0D=0A=20=0D=0A struct dax_device *alloc_dax(void *private, const stru=
ct dax_operations *ops)=0D=0A {=0D=0Adiff --git a/include/linux/dax.h b/i=
nclude/linux/dax.h=0D=0Aindex fe6c3ded1b50f..29113eb95e72d 100644=0D=0A--=
- a/include/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -54,7 +54,=
7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operati=
ons *ops);=0D=0A void *dax_holder(struct dax_device *dax_dev);=0D=0A void=
 put_dax(struct dax_device *dax_dev);=0D=0A void kill_dax(struct dax_devi=
ce *dax_dev);=0D=0A-struct dax_device *dax_dev_get(dev_t devt);=0D=0A+str=
uct dax_device *dax_dev_find(dev_t devt);=0D=0A void dax_write_cache(stru=
ct dax_device *dax_dev, bool wc);=0D=0A bool dax_write_cache_enabled(stru=
ct dax_device *dax_dev);=0D=0A bool dax_synchronous(struct dax_device *da=
x_dev);=0D=0A@@ -92,6 +92,10 @@ static inline void put_dax(struct dax_dev=
ice *dax_dev)=0D=0A static inline void kill_dax(struct dax_device *dax_de=
v)=0D=0A {=0D=0A }=0D=0A+static inline struct dax_device *dax_dev_find(de=
v_t devt)=0D=0A+{=0D=0A+=09return NULL;=0D=0A+}=0D=0A static inline void =
dax_write_cache(struct dax_device *dax_dev, bool wc)=0D=0A {=0D=0A }=0D=0A=
--=20=0D=0A2.53.0=0D=0A=0D=0A
