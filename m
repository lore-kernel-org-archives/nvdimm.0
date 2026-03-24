Received: from a8-18.smtp-out.amazonses.com (a8-18.smtp-out.amazonses.com [54.240.8.18])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE1224BBF0
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312786; cv=none; b=iuBn1wA0ToCc6hNdc1+qOxK9DQL5LsD3vnv/aotcCK0RwFDLMaFJwzCXUFJJ/it3zv0FxzPa8SNanu4GvCAUTN+90ToOlah29Dpk7k9EOscfh1rsg4RwjpdHyGUG//JCzpdIJM0uaB4K+UrARXQsO1Nf5+/TcJs9DylarrYiUCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312786; c=relaxed/simple;
	bh=CS0PFGLUThtWxdaPkYO7AYMNE+APMk7d4aScFvo2gFk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=Q7YBzbZ/KyY/C18SymeKNocWeBxLYav33pdjDZxdUYv2d9czDkLJfU++CfXxR0tQpAEpAsvQwrDraXnrLxRrdKsWvT4jeMSwBFi07XSAcX+iKO4RPO+kGPik1ovAOrpxrEgdEsCpK5N4SYadqX5gK5Be00W5cnUjKQ42kSdY+8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=IDxL0adn; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=LyDgWlLR; arc=none smtp.client-ip=54.240.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="IDxL0adn";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="LyDgWlLR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312784;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=CS0PFGLUThtWxdaPkYO7AYMNE+APMk7d4aScFvo2gFk=;
	b=IDxL0adno0swqB61p4SlnN/+3L4pSdQAMtRzuaPbYcB/QfM4PkcDLk6AC/Bc+wxM
	4cx12E+MfwNjSQtixZ8DskSe8V3I+B0lt0PegqMXfSca37saVnmtMZJqjofLMfGW9ri
	4Kc8N3UVM8aIAqpohTp/+WcyduI8/D606YonMpM0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312784;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=CS0PFGLUThtWxdaPkYO7AYMNE+APMk7d4aScFvo2gFk=;
	b=LyDgWlLRLAwgorgoTOvvBV0s2EA44Fw3ZmH5a9dPx1RZ3iejvfYwZdn2OvHbX62M
	ZrnTiFWVYJZmRwliiqQgxEAjcw7f20PEtmsCCorh2akkuQYPiFcQqzXKQK9EE1wK48f
	c7mIGsOWDQUR9+7iDz/fY/6OpzHHrec9UJWA9yi4=
Subject: [PATCH V9 8/8] dax: export dax_dev_get()
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
Date: Tue, 24 Mar 2026 00:39:43 +0000
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
 <20260324003933.5127-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuya0Yn9q3UilSx21BadXMeqnCw==
Thread-Topic: [PATCH V9 8/8] dax: export dax_dev_get()
X-Wm-Sent-Timestamp: 1774312782
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d487fb8-c84bb720-35d3-4d50-8eb4-c92254121bcb-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.8.18

From: John Groves <john@groves.net>=0D=0A=0D=0Afamfs needs to look up a d=
ax_device by dev_t when resolving fmap=0D=0Aentries that reference charac=
ter dax devices.=0D=0A=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com=
>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A driver=
s/dax/super.c | 3 ++-=0D=0A include/linux/dax.h | 1 +=0D=0A 2 files chang=
ed, 3 insertions(+), 1 deletion(-)=0D=0A=0D=0Adiff --git a/drivers/dax/su=
per.c b/drivers/dax/super.c=0D=0Aindex d4ab60c406bf..25cf99dd9360 100644=0D=
=0A--- a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -521,=
7 +521,7 @@ static int dax_set(struct inode *inode, void *data)=0D=0A =09=
return 0;=0D=0A }=0D=0A=20=0D=0A-static struct dax_device *dax_dev_get(de=
v_t devt)=0D=0A+struct dax_device *dax_dev_get(dev_t devt)=0D=0A {=0D=0A =
=09struct dax_device *dax_dev;=0D=0A =09struct inode *inode;=0D=0A@@ -544=
,6 +544,7 @@ static struct dax_device *dax_dev_get(dev_t devt)=0D=0A=20=0D=
=0A =09return dax_dev;=0D=0A }=0D=0A+EXPORT_SYMBOL_GPL(dax_dev_get);=0D=0A=
=20=0D=0A struct dax_device *alloc_dax(void *private, const struct dax_op=
erations *ops)=0D=0A {=0D=0Adiff --git a/include/linux/dax.h b/include/li=
nux/dax.h=0D=0Aindex bf37b9a982f3..8c7e23ddf857 100644=0D=0A--- a/include=
/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -54,6 +54,7 @@ struct=
 dax_device *alloc_dax(void *private, const struct dax_operations *ops);=0D=
=0A void *dax_holder(struct dax_device *dax_dev);=0D=0A void put_dax(stru=
ct dax_device *dax_dev);=0D=0A void kill_dax(struct dax_device *dax_dev);=
=0D=0A+struct dax_device *dax_dev_get(dev_t devt);=0D=0A void dax_write_c=
ache(struct dax_device *dax_dev, bool wc);=0D=0A bool dax_write_cache_ena=
bled(struct dax_device *dax_dev);=0D=0A bool dax_synchronous(struct dax_d=
evice *dax_dev);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
