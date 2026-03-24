Received: from a11-123.smtp-out.amazonses.com (a11-123.smtp-out.amazonses.com [54.240.11.123])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17572253A1
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312759; cv=none; b=nlvXmbj1ApSltT3+8UFqZikUFxY4vk7KNI2Qfpjzr/LKXv/uXxBTjlebffEpWl553ZQJvMRGogYIb+R1yhSkD1DzdEiaZO4kMkxkoc3c/K7ZrI3o1MNoiMvBVpldIuwTEcMqe5CnKFMfIM5367j9yY139XpDwAFyhI4LwQ63JAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312759; c=relaxed/simple;
	bh=qC+AQb8J/tV4P4KbMykUYk7O6V65rtOyyfBySJ+Y0F4=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=RXy2zlOjFzyuGaeVE7JN32avDFK5dVuuo5k+5MSJYppBEXxa3QteDr647ZFkCWK3ggmafp5MHMapLkzFrt5u36TXHSe10clI0JAxq04Jnugx3n8yqTafRSPYYr5qVY48g3Lw5h6KJK+RHP7iuf1Y116giZeEToti3s6m0QVQzvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=PsQy+Zie; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=JiKctosk; arc=none smtp.client-ip=54.240.11.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="PsQy+Zie";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="JiKctosk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312756;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=qC+AQb8J/tV4P4KbMykUYk7O6V65rtOyyfBySJ+Y0F4=;
	b=PsQy+Zie/J2BSwjaNIfFRYj/wvYlZC64hHueeUwDO7+cXHdjD0lIL95TuJCGvmXB
	iKSZqNI1cTB4qjY5VCOsbyMFNEFzvYsC9vxrAuLxCrVtRJD/4nCnvd6s5L3iBob6nr2
	sUfefERvGYbPZ5RfQeP9Uosmbv5l9Zgl2DqdF+uY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312756;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=qC+AQb8J/tV4P4KbMykUYk7O6V65rtOyyfBySJ+Y0F4=;
	b=JiKctoskEnPgvpBJY5+da6Y502oFFaV/dVK0CnlYetMB363ko2W3PPssREp/bj5r
	35KA4uakJyIm8vO6twO2wOu9yq0yP3xg98rc38jMyDwl9EmrHhesNrQAr9LMIpz0Bmt
	q9Ca86ekyMPwa274P4fYS7fhSupJwX99LH7RLzQs=
Subject: [PATCH V9 6/8] dax: Add dax_set_ops() for setting dax_operations at
 bind time
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
Date: Tue, 24 Mar 2026 00:39:16 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com>
References: 
 <0100019d1d463523-617e8165-a084-4d91-aa5e-13778264d5d4-000000@email.amazonses.com> 
 <20260324003906.5083-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyaj3/rqL5QwQTunShNvBT7KjQ==
Thread-Topic: [PATCH V9 6/8] dax: Add dax_set_ops() for setting
 dax_operations at bind time
X-Wm-Sent-Timestamp: 1774312755
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d4814db-1e36cd9c-09c3-4e60-b48f-2b5c3cb9e406-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.123

From: John Groves <John@Groves.net>=0D=0A=0D=0AAdd a new dax_set_ops() fu=
nction that allows drivers to set the=0D=0Adax_operations after the dax_d=
evice has been allocated. This is needed=0D=0Afor fsdev_dax where the ope=
rations need to be set during probe and=0D=0Acleared during unbind.=0D=0A=
=0D=0AThe fsdev driver uses devm_add_action_or_reset() for cleanup consis=
tency,=0D=0Aavoiding the complexity of mixing devm-managed resources with=
 manual=0D=0Acleanup in a remove() callback. This ensures cleanup happens=
 automatically=0D=0Ain the correct reverse order when the device is unbou=
nd.=0D=0A=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com>=0D=0ASigned=
-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/fsdev.c=
 | 16 ++++++++++++++++=0D=0A drivers/dax/super.c | 38 +++++++++++++++++++=
++++++++++++++++++-=0D=0A include/linux/dax.h |  1 +=0D=0A 3 files change=
d, 54 insertions(+), 1 deletion(-)=0D=0A=0D=0Adiff --git a/drivers/dax/fs=
dev.c b/drivers/dax/fsdev.c=0D=0Aindex be3d2b0e8418..4a5b25515726 100644=0D=
=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/drivers/dax/fsdev.c=0D=0A@@ -117,=
6 +117,13 @@ static void fsdev_kill(void *dev_dax)=0D=0A =09kill_dev_dax(=
dev_dax);=0D=0A }=0D=0A=20=0D=0A+static void fsdev_clear_ops(void *data)=0D=
=0A+{=0D=0A+=09struct dev_dax *dev_dax =3D data;=0D=0A+=0D=0A+=09dax_set_=
ops(dev_dax->dax_dev, NULL);=0D=0A+}=0D=0A+=0D=0A /*=0D=0A  * Page map op=
erations for FS-DAX mode=0D=0A  * Similar to fsdax_pagemap_ops in drivers=
/nvdimm/pmem.c=0D=0A@@ -303,6 +310,15 @@ static int fsdev_dax_probe(struc=
t dev_dax *dev_dax)=0D=0A =09if (rc)=0D=0A =09=09return rc;=0D=0A=20=0D=0A=
+=09/* Set the dax operations for fs-dax access path */=0D=0A+=09rc =3D d=
ax_set_ops(dax_dev, &dev_dax_ops);=0D=0A+=09if (rc)=0D=0A+=09=09return rc=
;=0D=0A+=0D=0A+=09rc =3D devm_add_action_or_reset(dev, fsdev_clear_ops, d=
ev_dax);=0D=0A+=09if (rc)=0D=0A+=09=09return rc;=0D=0A+=0D=0A =09run_dax(=
dax_dev);=0D=0A =09return devm_add_action_or_reset(dev, fsdev_kill, dev_d=
ax);=0D=0A }=0D=0Adiff --git a/drivers/dax/super.c b/drivers/dax/super.c=0D=
=0Aindex c00b9dff4a06..ba0b4cd18a77 100644=0D=0A--- a/drivers/dax/super.c=
=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -157,6 +157,9 @@ long dax_direct_=
access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,=0D=0A =09=
if (!dax_alive(dax_dev))=0D=0A =09=09return -ENXIO;=0D=0A=20=0D=0A+=09if =
(!dax_dev->ops)=0D=0A+=09=09return -EOPNOTSUPP;=0D=0A+=0D=0A =09if (nr_pa=
ges < 0)=0D=0A =09=09return -EINVAL;=0D=0A=20=0D=0A@@ -207,6 +210,10 @@ i=
nt dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,=0D=0A=20=
=0D=0A =09if (!dax_alive(dax_dev))=0D=0A =09=09return -ENXIO;=0D=0A+=0D=0A=
+=09if (!dax_dev->ops)=0D=0A+=09=09return -EOPNOTSUPP;=0D=0A+=0D=0A =09/*=
=0D=0A =09 * There are no callers that want to zero more than one page as=
 of now.=0D=0A =09 * Once users are there, this check can be removed afte=
r the=0D=0A@@ -223,7 +230,7 @@ EXPORT_SYMBOL_GPL(dax_zero_page_range);=0D=
=0A size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,=0D=
=0A =09=09void *addr, size_t bytes, struct iov_iter *iter)=0D=0A {=0D=0A-=
=09if (!dax_dev->ops->recovery_write)=0D=0A+=09if (!dax_dev->ops || !dax_=
dev->ops->recovery_write)=0D=0A =09=09return 0;=0D=0A =09return dax_dev->=
ops->recovery_write(dax_dev, pgoff, addr, bytes, iter);=0D=0A }=0D=0A@@ -=
307,6 +314,35 @@ void set_dax_nomc(struct dax_device *dax_dev)=0D=0A }=0D=
=0A EXPORT_SYMBOL_GPL(set_dax_nomc);=0D=0A=20=0D=0A+/**=0D=0A+ * dax_set_=
ops - set the dax_operations for a dax_device=0D=0A+ * @dax_dev: the dax_=
device to configure=0D=0A+ * @ops: the operations to set (may be NULL to =
clear)=0D=0A+ *=0D=0A+ * This allows drivers to set the dax_operations af=
ter the dax_device=0D=0A+ * has been allocated. This is needed when the d=
evice is created before=0D=0A+ * the driver that needs specific ops is bo=
und (e.g., fsdev_dax binding=0D=0A+ * to a dev_dax created by hmem).=0D=0A=
+ *=0D=0A+ * When setting non-NULL ops, fails if ops are already set (ret=
urns -EBUSY).=0D=0A+ * When clearing ops (NULL), always succeeds.=0D=0A+ =
*=0D=0A+ * Return: 0 on success, -EBUSY if ops already set=0D=0A+ */=0D=0A=
+int dax_set_ops(struct dax_device *dax_dev, const struct dax_operations =
*ops)=0D=0A+{=0D=0A+=09if (ops) {=0D=0A+=09=09/* Setting ops: fail if alr=
eady set */=0D=0A+=09=09if (cmpxchg(&dax_dev->ops, NULL, ops) !=3D NULL)=0D=
=0A+=09=09=09return -EBUSY;=0D=0A+=09} else {=0D=0A+=09=09/* Clearing ops=
: always allowed */=0D=0A+=09=09dax_dev->ops =3D NULL;=0D=0A+=09}=0D=0A+=09=
return 0;=0D=0A+}=0D=0A+EXPORT_SYMBOL_GPL(dax_set_ops);=0D=0A+=0D=0A bool=
 dax_alive(struct dax_device *dax_dev)=0D=0A {=0D=0A =09lockdep_assert_he=
ld(&dax_srcu);=0D=0Adiff --git a/include/linux/dax.h b/include/linux/dax.=
h=0D=0Aindex 73cfc1a7c8f1..b19bfe0c2fd1 100644=0D=0A--- a/include/linux/d=
ax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -243,6 +243,7 @@ static inlin=
e void dax_break_layout_final(struct inode *inode)=0D=0A=20=0D=0A bool da=
x_alive(struct dax_device *dax_dev);=0D=0A void *dax_get_private(struct d=
ax_device *dax_dev);=0D=0A+int dax_set_ops(struct dax_device *dax_dev, co=
nst struct dax_operations *ops);=0D=0A long dax_direct_access(struct dax_=
device *dax_dev, pgoff_t pgoff, long nr_pages,=0D=0A =09=09enum dax_acces=
s_mode mode, void **kaddr, unsigned long *pfn);=0D=0A size_t dax_copy_fro=
m_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,=0D=0A--=20=0D=
=0A2.53.0=0D=0A=0D=0A
