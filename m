Received: from a11-80.smtp-out.amazonses.com (a11-80.smtp-out.amazonses.com [54.240.11.80])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3613195FB
	for <nvdimm@lists.linux.dev>; Sun,  7 Jun 2026 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780860864; cv=none; b=V9HchdW9C2H/yb4lwqKY1/Kc4Z4RDosYB/xTwBTWFhyGLJOD1RYjKa/9npCoMyu9gRK5wHCPVP7Nliim+MtQE6vUn2k1HWhRpB2OALSpjTU/v6lwEkjjNVSLQHXcB4+CXa00HW4aYtlJLKmwaOOqJqSHUreD4iKhk9ObxgWNK8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780860864; c=relaxed/simple;
	bh=83eAPS5aq2FNY7nw+mBltDpLjPqVjLuRdTUS1ysDzxY=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Hi9oPZpxZR3Qd/pqTjTZi47YLLzNkUQzWL/IfIOSqEqD/B6HPzXljkG41j4gCXov7k/ZX2dLl8Moe4OMS4inD9sLpPGa4w01Zd8JyWZfwsP6Kwv+IQdpXrTdV/1NJFZNgYWgmqQoCihVyTnHWJZxkT+E450WWX4/xgULwyELYeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=lFL6m7aR; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=bq/iPrsg; arc=none smtp.client-ip=54.240.11.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="lFL6m7aR";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="bq/iPrsg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780860861;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=83eAPS5aq2FNY7nw+mBltDpLjPqVjLuRdTUS1ysDzxY=;
	b=lFL6m7aR+Js0kOXObinbtlF6aL8hQjSnZkfef+X7xgGeYJ9Z3CSwv0OAwDsCf/NK
	XK1JamEI49rHNRS3Z7cuAlY9mmjED/PjHI9SfSiCtE80lVv4R0bp+SVq9MEROvleHmE
	p9AiszM062wbWzu0R/JU7lyX6UE5srJL18Ep1Be4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780860861;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=83eAPS5aq2FNY7nw+mBltDpLjPqVjLuRdTUS1ysDzxY=;
	b=bq/iPrsgQDcmL0Z+qyBFQUCj00p/EpbHZTKSdMyc/kLVFsuSvfGNzWAtAnYPHFsI
	UEvYE3KqvfY26hOStPjhl62bkAMggX17xBio+QJdPmASQiiqsCgD4/0r9BESznXb7RJ
	kSZrwoSzCGd4K0F5LUVDRtWYG83Bc9DhuFP0x1QA=
Subject: [PATCH V4 8/9] dax: replace exported dax_dev_get() with
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
Date: Sun, 7 Jun 2026 19:34:21 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com>
References: 
 <0100019ea3929225-a0f8e6f7-30ae-4f8e-ae6f-19129666c4c3-000000@email.amazonses.com> 
 <20260607193416.94407-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc9rRhSPXw4ZdTQtuvnkZG9OrQIgAAEF5W
Thread-Topic: [PATCH V4 8/9] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
X-Wm-Sent-Timestamp: 1780860860
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ea3943a9d-3724a539-97c6-46f9-a3bb-c7b9a51d3889-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.07-54.240.11.80

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
l.com>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A d=
rivers/dax/super.c | 38 ++++++++++++++++++++++++++++++++++++--=0D=0A incl=
ude/linux/dax.h |  6 +++++-=0D=0A 2 files changed, 41 insertions(+), 3 de=
letions(-)=0D=0A=0D=0Adiff --git a/drivers/dax/super.c b/drivers/dax/supe=
r.c=0D=0Aindex 96f778dcde50b..b37ae79c084bb 100644=0D=0A--- a/drivers/dax=
/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -557,7 +557,7 @@ static i=
nt dax_set(struct inode *inode, void *data)=0D=0A =09return 0;=0D=0A }=0D=
=0A=20=0D=0A-struct dax_device *dax_dev_get(dev_t devt)=0D=0A+static stru=
ct dax_device *dax_dev_get(dev_t devt)=0D=0A {=0D=0A =09struct dax_device=
 *dax_dev;=0D=0A =09struct inode *inode;=0D=0A@@ -580,7 +580,41 @@ struct=
 dax_device *dax_dev_get(dev_t devt)=0D=0A=20=0D=0A =09return dax_dev;=0D=
=0A }=0D=0A-EXPORT_SYMBOL_GPL(dax_dev_get);=0D=0A+=0D=0A+/**=0D=0A+ * dax=
_dev_find - look up an existing dax_device by dev_t=0D=0A+ * @devt: the d=
evice number to find=0D=0A+ *=0D=0A+ * Returns a dax_device with an eleva=
ted inode reference, or NULL if no=0D=0A+ * device with the given dev_t e=
xists. Unlike dax_dev_get(), this never=0D=0A+ * allocates a new inode =E2=
=80=94 it is safe for external callers that are looking=0D=0A+ * up devic=
es from user-supplied or metadata-supplied dev_t values.=0D=0A+ *=0D=0A+ =
* Caller must put_dax() the returned device when done.=0D=0A+ */=0D=0A+st=
ruct dax_device *dax_dev_find(dev_t devt)=0D=0A+{=0D=0A+=09struct dax_dev=
ice *dax_dev;=0D=0A+=09struct inode *inode;=0D=0A+=09int id;=0D=0A+=0D=0A=
+=09inode =3D ilookup5(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),=0D=
=0A+=09=09=09 dax_test, &devt);=0D=0A+=09if (!inode)=0D=0A+=09=09return N=
ULL;=0D=0A+=0D=0A+=09dax_dev =3D to_dax_dev(inode);=0D=0A+=09id =3D dax_r=
ead_lock();=0D=0A+=09if (!dax_alive(dax_dev)) {=0D=0A+=09=09dax_read_unlo=
ck(id);=0D=0A+=09=09iput(inode);=0D=0A+=09=09return NULL;=0D=0A+=09}=0D=0A=
+=09dax_read_unlock(id);=0D=0A+=0D=0A+=09return dax_dev;=0D=0A+}=0D=0A+EX=
PORT_SYMBOL_GPL(dax_dev_find);=0D=0A=20=0D=0A struct dax_device *alloc_da=
x(void *private, const struct dax_operations *ops)=0D=0A {=0D=0Adiff --gi=
t a/include/linux/dax.h b/include/linux/dax.h=0D=0Aindex fe6c3ded1b50f..2=
9113eb95e72d 100644=0D=0A--- a/include/linux/dax.h=0D=0A+++ b/include/lin=
ux/dax.h=0D=0A@@ -54,7 +54,7 @@ struct dax_device *alloc_dax(void *privat=
e, const struct dax_operations *ops);=0D=0A void *dax_holder(struct dax_d=
evice *dax_dev);=0D=0A void put_dax(struct dax_device *dax_dev);=0D=0A vo=
id kill_dax(struct dax_device *dax_dev);=0D=0A-struct dax_device *dax_dev=
_get(dev_t devt);=0D=0A+struct dax_device *dax_dev_find(dev_t devt);=0D=0A=
 void dax_write_cache(struct dax_device *dax_dev, bool wc);=0D=0A bool da=
x_write_cache_enabled(struct dax_device *dax_dev);=0D=0A bool dax_synchro=
nous(struct dax_device *dax_dev);=0D=0A@@ -92,6 +92,10 @@ static inline v=
oid put_dax(struct dax_device *dax_dev)=0D=0A static inline void kill_dax=
(struct dax_device *dax_dev)=0D=0A {=0D=0A }=0D=0A+static inline struct d=
ax_device *dax_dev_find(dev_t devt)=0D=0A+{=0D=0A+=09return NULL;=0D=0A+}=
=0D=0A static inline void dax_write_cache(struct dax_device *dax_dev, boo=
l wc)=0D=0A {=0D=0A }=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
