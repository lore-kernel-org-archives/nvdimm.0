Received: from a11-73.smtp-out.amazonses.com (a11-73.smtp-out.amazonses.com [54.240.11.73])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2893D33F5A3
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159895; cv=none; b=Beb09K9Z7JOSicMzeVgsd5gVrRVSIv/jG5XutcUO9ozLpDS2W67aKsLIoNpgCzUhoHHPwMldL6wMnW3hFzEPpis/KV4mjY1812ADj/Rx4JQ/kGh58IyMtOaDJCiM0Cy4ZYofUrUFOaDATNn3p9o4y7kMGVAoOxYIP02QSEWuKj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159895; c=relaxed/simple;
	bh=KvqaUWo58vfTx1jkHlUw8hBpjno8UPB4mb3T0OmHUyA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=XrnIlRJAL1plS+IibqNHTzST6klahvWN5cJFpYEtNtoN2MTPVHlSBLVdcM0JSKbMI1QYZvHrCCHS4s8y6JDtVkxqUrGoNuJ/+p24MfEy6CxjD5rkA3oWyRJZOx9UDG5mXq1Nbt3ctz9a1pa5fx3YOg7nyc4H71DB/+mNhkd69ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=JYo7KbtT; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=T7NEY0oj; arc=none smtp.client-ip=54.240.11.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="JYo7KbtT";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="T7NEY0oj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1780159893;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=KvqaUWo58vfTx1jkHlUw8hBpjno8UPB4mb3T0OmHUyA=;
	b=JYo7KbtT89YKBAjQssMMs4NjRJl3mjmmGA3xi8hvMs+2gflwxMEQOmd19enCFjRW
	KdyHIoKaoybANyQcWdvmVKDNY3h60OZ2atDYqnuHq/8WSkH0tbAkkSVCITB7W+IM23M
	7UBauYSjcMTHIvjokiqCMTv8I4rWSr8M0yNpw4EE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1780159893;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=KvqaUWo58vfTx1jkHlUw8hBpjno8UPB4mb3T0OmHUyA=;
	b=T7NEY0ojpVsWInwcaPskWA2N5T34WkxudfS0iegGT+JYQaaoAhr4Siv1Ci5ILgeH
	9gpJqXEm8MQhHjfsHugIeuQUZ9rkvhVs1W4hMfc5ZueSPN3UAjQ/Q4tIpPDE3cyDDUw
	+3GVrJAEjUp99+4h6T+/QX8nlnv4hSrsxtZn6B2k=
Subject: [PATCH V3 8/9] dax: replace exported dax_dev_get() with
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
Date: Sat, 30 May 2026 16:51:33 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com>
References: 
 <0100019e79caead2-5795328c-af48-4a93-b147-c11df7446e1a-000000@email.amazonses.com> 
 <20260530165126.6721-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc8FRa7vroVK8USxmz3hlONeiu3QAADbAn
Thread-Topic: [PATCH V3 8/9] dax: replace exported dax_dev_get() with
 non-allocating dax_dev_find()
X-Wm-Sent-Timestamp: 1780159891
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e79cc4e0f-26041b0e-3c38-4641-9e36-c8964a7f0e89-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.30-54.240.11.73

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
amfs.c). Also add the missing CONFIG_DAX=3Dn stub.=0D=0A=0D=0AFixes: 2ae6=
24d5a555d ("dax: export dax_dev_get()")=0D=0ASigned-off-by: John Groves <=
john@groves.net>=0D=0A---=0D=0A drivers/dax/super.c | 38 ++++++++++++++++=
++++++++++++++++++++--=0D=0A include/linux/dax.h |  6 +++++-=0D=0A 2 file=
s changed, 41 insertions(+), 3 deletions(-)=0D=0A=0D=0Adiff --git a/drive=
rs/dax/super.c b/drivers/dax/super.c=0D=0Aindex 4c56ac2faacdb..6cb271e034=
a70 100644=0D=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=
=0A@@ -550,7 +550,7 @@ static int dax_set(struct inode *inode, void *data=
)=0D=0A =09return 0;=0D=0A }=0D=0A=20=0D=0A-struct dax_device *dax_dev_ge=
t(dev_t devt)=0D=0A+static struct dax_device *dax_dev_get(dev_t devt)=0D=0A=
 {=0D=0A =09struct dax_device *dax_dev;=0D=0A =09struct inode *inode;=0D=0A=
@@ -573,7 +573,41 @@ struct dax_device *dax_dev_get(dev_t devt)=0D=0A=20=0D=
=0A =09return dax_dev;=0D=0A }=0D=0A-EXPORT_SYMBOL_GPL(dax_dev_get);=0D=0A=
+=0D=0A+/**=0D=0A+ * dax_dev_find - look up an existing dax_device by dev=
_t=0D=0A+ * @devt: the device number to find=0D=0A+ *=0D=0A+ * Returns a =
dax_device with an elevated inode reference, or NULL if no=0D=0A+ * devic=
e with the given dev_t exists. Unlike dax_dev_get(), this never=0D=0A+ * =
allocates a new inode =E2=80=94 it is safe for external callers that are =
looking=0D=0A+ * up devices from user-supplied or metadata-supplied dev_t=
 values.=0D=0A+ *=0D=0A+ * Caller must put_dax() the returned device when=
 done.=0D=0A+ */=0D=0A+struct dax_device *dax_dev_find(dev_t devt)=0D=0A+=
{=0D=0A+=09struct dax_device *dax_dev;=0D=0A+=09struct inode *inode;=0D=0A=
+=09int id;=0D=0A+=0D=0A+=09inode =3D ilookup5(dax_superblock, hash_32(de=
vt + DAXFS_MAGIC, 31),=0D=0A+=09=09=09 dax_test, &devt);=0D=0A+=09if (!in=
ode)=0D=0A+=09=09return NULL;=0D=0A+=0D=0A+=09dax_dev =3D to_dax_dev(inod=
e);=0D=0A+=09id =3D dax_read_lock();=0D=0A+=09if (!dax_alive(dax_dev)) {=0D=
=0A+=09=09dax_read_unlock(id);=0D=0A+=09=09iput(inode);=0D=0A+=09=09retur=
n NULL;=0D=0A+=09}=0D=0A+=09dax_read_unlock(id);=0D=0A+=0D=0A+=09return d=
ax_dev;=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax_dev_find);=0D=0A=20=0D=0A str=
uct dax_device *alloc_dax(void *private, const struct dax_operations *ops=
)=0D=0A {=0D=0Adiff --git a/include/linux/dax.h b/include/linux/dax.h=0D=0A=
index fe6c3ded1b50f..29113eb95e72d 100644=0D=0A--- a/include/linux/dax.h=0D=
=0A+++ b/include/linux/dax.h=0D=0A@@ -54,7 +54,7 @@ struct dax_device *al=
loc_dax(void *private, const struct dax_operations *ops);=0D=0A void *dax=
_holder(struct dax_device *dax_dev);=0D=0A void put_dax(struct dax_device=
 *dax_dev);=0D=0A void kill_dax(struct dax_device *dax_dev);=0D=0A-struct=
 dax_device *dax_dev_get(dev_t devt);=0D=0A+struct dax_device *dax_dev_fi=
nd(dev_t devt);=0D=0A void dax_write_cache(struct dax_device *dax_dev, bo=
ol wc);=0D=0A bool dax_write_cache_enabled(struct dax_device *dax_dev);=0D=
=0A bool dax_synchronous(struct dax_device *dax_dev);=0D=0A@@ -92,6 +92,1=
0 @@ static inline void put_dax(struct dax_device *dax_dev)=0D=0A static =
inline void kill_dax(struct dax_device *dax_dev)=0D=0A {=0D=0A }=0D=0A+st=
atic inline struct dax_device *dax_dev_find(dev_t devt)=0D=0A+{=0D=0A+=09=
return NULL;=0D=0A+}=0D=0A static inline void dax_write_cache(struct dax_=
device *dax_dev, bool wc)=0D=0A {=0D=0A }=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=
=0A
