Received: from a48-184.smtp-out.amazonses.com (a48-184.smtp-out.amazonses.com [54.240.48.184])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A693314D2
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645523; cv=none; b=DkhFp9nDdtRA7nRhhA7a3Dz7ZcUiU1/v6LpFrl31rMWDPUO1k4BArLQJ672DTCjj/c5oo7jyz+cwNBFIEFATzw+mr39mhbBHa7mlxo1DeCM0IcGHy+4+zNb5GRAJzBLhlq8YlnyFwY1BKr7yIaxhSlf7KTZ0C2i8LZms30/uWZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645523; c=relaxed/simple;
	bh=lay3HXuMzLZo2JlHKY5v5zjUVUlqQrpAhrP7puC7AmI=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=nYiYWud+ZfivwvF+wuyubF1tftUVz/rJQ53NK74nFSeEvznoj359xHx7vuI3PbjLosMIeXPWtzc+0jJQVfsOeqFA8zvWpDbhEU0y/r4Kzm6AT/q7fGaXiGx545qq+Qn22e/vNYPgI0peVYCxBPGnP3c3AovUdslHvrOIjkpxjL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=ch2iohT3; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=F7O5nY6m; arc=none smtp.client-ip=54.240.48.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="ch2iohT3";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="F7O5nY6m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645521;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=lay3HXuMzLZo2JlHKY5v5zjUVUlqQrpAhrP7puC7AmI=;
	b=ch2iohT3vXIRoffws8ylD6KyCju03nv7b0M8vHjmquOmsW7lGzIlCYQh6NbsnOd1
	VfYF5UslOcj9SbJiWKR3OWxh8KzlQudaAx7jk/qEjjwk2yF6SiCDhN2kKQAETDrXaxR
	cdPndvwKmzjvBTzhyZ6xjMXQRZBQKxLAdm3tS2t4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645521;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=lay3HXuMzLZo2JlHKY5v5zjUVUlqQrpAhrP7puC7AmI=;
	b=F7O5nY6muMVU3Y/z2diWlJwwihBTcN2l6DCRcEG7/V2VBUCgy//+gS7lr0U23mQR
	9Eg58HKwH+3L0y78dTbAfOMFibEAn8rDMaoQR8lXr9Gp+I5fsgFadQuZfiXWEL4I/CD
	YGgLGt13WhGDUerF5L0FkGBINmdiCqmBIxLc8AJI=
Subject: [PATCH V10 8/8] dax: export dax_dev_get()
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
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>
Date: Fri, 27 Mar 2026 21:05:21 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
References: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com> 
 <20260327210514.79273-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi1rHXEBwI8URwWrsgm58k0mMQ==
Thread-Topic: [PATCH V10 8/8] dax: export dax_dev_get()
X-Wm-Sent-Timestamp: 1774645519
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311daab5-bb212f0b-4e05-4668-bf53-d76fab56be68-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.48.184

From: John Groves <john@groves.net>=0D=0A=0D=0Afamfs needs to look up a d=
ax_device by dev_t when resolving fmap=0D=0Aentries that reference charac=
ter dax devices.=0D=0A=0D=0AReviewed-by: Dave Jiang <dave.jiang@intel.com=
>=0D=0AReviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0AS=
igned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/su=
per.c | 3 ++-=0D=0A include/linux/dax.h | 1 +=0D=0A 2 files changed, 3 in=
sertions(+), 1 deletion(-)=0D=0A=0D=0Adiff --git a/drivers/dax/super.c b/=
drivers/dax/super.c=0D=0Aindex d4ab60c406bf..25cf99dd9360 100644=0D=0A---=
 a/drivers/dax/super.c=0D=0A+++ b/drivers/dax/super.c=0D=0A@@ -521,7 +521=
,7 @@ static int dax_set(struct inode *inode, void *data)=0D=0A =09return=
 0;=0D=0A }=0D=0A=20=0D=0A-static struct dax_device *dax_dev_get(dev_t de=
vt)=0D=0A+struct dax_device *dax_dev_get(dev_t devt)=0D=0A {=0D=0A =09str=
uct dax_device *dax_dev;=0D=0A =09struct inode *inode;=0D=0A@@ -544,6 +54=
4,7 @@ static struct dax_device *dax_dev_get(dev_t devt)=0D=0A=20=0D=0A =09=
return dax_dev;=0D=0A }=0D=0A+EXPORT_SYMBOL_GPL(dax_dev_get);=0D=0A=20=0D=
=0A struct dax_device *alloc_dax(void *private, const struct dax_operatio=
ns *ops)=0D=0A {=0D=0Adiff --git a/include/linux/dax.h b/include/linux/da=
x.h=0D=0Aindex a85e270bfb3c..9ef95b136bb8 100644=0D=0A--- a/include/linux=
/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -54,6 +54,7 @@ struct dax_d=
evice *alloc_dax(void *private, const struct dax_operations *ops);=0D=0A =
void *dax_holder(struct dax_device *dax_dev);=0D=0A void put_dax(struct d=
ax_device *dax_dev);=0D=0A void kill_dax(struct dax_device *dax_dev);=0D=0A=
+struct dax_device *dax_dev_get(dev_t devt);=0D=0A void dax_write_cache(s=
truct dax_device *dax_dev, bool wc);=0D=0A bool dax_write_cache_enabled(s=
truct dax_device *dax_dev);=0D=0A bool dax_synchronous(struct dax_device =
*dax_dev);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
