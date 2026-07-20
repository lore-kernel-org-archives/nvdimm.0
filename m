Received: from a8-21.smtp-out.amazonses.com (a8-21.smtp-out.amazonses.com [54.240.8.21])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AAF38AC78;
	Mon, 20 Jul 2026 03:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.8.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519211; cv=none; b=t9DtjtRHovWnUNAolr0f6UXoSKUtzbnmmsgWtMFwSGuVsKNWrx1gWagep3jmv066Urxn3T8JrR/vPLn2b9iAdOnkLJUmoKH8x5Pmyjyj6EcPuwBo+HZHNMEZS8CLpPHAeC8bS+YQoFTcvPKtcl2kLnkyWj84r4nY0Yhe4nwEiBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519211; c=relaxed/simple;
	bh=CCtK3rqmM8hleT+hyeymia0j7MCgzvaP8qrwIY9Rj7M=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=GuxI6Tb5jVOVJYZtz7XRwslN2ORyEDyvFHPHjzObJbbhiivlgGF8AXdoL+Qmi/uivccDG1+yvJMCvrfF/NyJkqTzRGNLReoXbZXfMhSQRUVQhUIYhWW6OU94rsHqlg9oL+01+FXkF4Ioz3XDLivc4hoBMpxHJDHZfxsJQBDw+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=sH6N5h6w; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=W16rZHlj; arc=none smtp.client-ip=54.240.8.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="sH6N5h6w";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="W16rZHlj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1784519207;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=CCtK3rqmM8hleT+hyeymia0j7MCgzvaP8qrwIY9Rj7M=;
	b=sH6N5h6whz+8JC3j4ad6WIo2oQOBEEXIefl3t6RcTyziG7n29C9N4/0aA7hFFSO2
	yQjlvDAM20FnUC5wWCxRqydPZ5PIgvLYoz08a9j53qnTl+vadLivlbdYvdIVM4CjvOy
	NNQmc1AESwdbmZtPtvYZ1sH9G6LaR5CnLiDb1Z2M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1784519207;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=CCtK3rqmM8hleT+hyeymia0j7MCgzvaP8qrwIY9Rj7M=;
	b=W16rZHljGUYIUTjB+Ula6xp6CY2fPeTb32xbsr0tYr5YifBIhh6VkZntbbhVMUOC
	P8yhQaDawMDievNdcY52L6HesYWAN2ddKc8cAa+5hdEJv/rJhOVYG2IAbE85TRP3wAp
	uWXjqVm3j7tZoTWUgfyNwRYSYDlI+isgu+tm9Zlw=
Subject: [PATCH V11 8/9] famfs_fuse: Add DAX address_space_operations with
 noop_dirty_folio
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
Date: Mon, 20 Jul 2026 03:46:47 +0000
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
 <20260720034638.68877-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHdF/oEAFJtLKnZRyOlO7hUjUgWYwAAF7W0
Thread-Topic: [PATCH V11 8/9] famfs_fuse: Add DAX address_space_operations
 with noop_dirty_folio
X-Wm-Sent-Timestamp: 1784519206
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019f7da22a52-50f1e51d-e030-47e8-ad9d-cda5a2a47682-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.07.20-54.240.8.21

From: John Groves <John@Groves.net>=0D=0A=0D=0AFamfs is memory-backed; th=
ere is no place to write back to, and no reason=0D=0Ato mark pages dirty =
at all. Provide an address_space_operations using=0D=0Anoop_dirty_folio s=
o the dax paths have the ops they expect.=0D=0A=0D=0ASigned-off-by: John =
Groves <john@groves.net>=0D=0A---=0D=0A fs/fuse/famfs.c | 11 +++++++++++=0D=
=0A 1 file changed, 11 insertions(+)=0D=0A=0D=0Adiff --git a/fs/fuse/famf=
s.c b/fs/fuse/famfs.c=0D=0Aindex 8d13282e8949..aea0bceef774 100644=0D=0A-=
-- a/fs/fuse/famfs.c=0D=0A+++ b/fs/fuse/famfs.c=0D=0A@@ -16,6 +16,7 @@=0D=
=0A #include <linux/dax.h>=0D=0A #include <linux/iomap.h>=0D=0A #include =
<linux/log2.h>=0D=0A+#include <linux/pagemap.h>=0D=0A #include <linux/pat=
h.h>=0D=0A #include <linux/namei.h>=0D=0A #include <linux/string.h>=0D=0A=
@@ -41,6 +42,15 @@ static const struct dax_holder_operations famfs_fuse_d=
ax_holder_ops =3D {=0D=0A =09.notify_failure=09=09=3D famfs_dax_notify_fa=
ilure,=0D=0A };=0D=0A=20=0D=0A+/*=0D=0A+ * DAX address_space_operations f=
or famfs.=0D=0A+ * famfs doesn't need dirty tracking - writes go directly=
 to=0D=0A+ * memory with no writeback required.=0D=0A+ */=0D=0A+static co=
nst struct address_space_operations famfs_dax_aops =3D {=0D=0A+=09.dirty_=
folio=09=3D noop_dirty_folio,=0D=0A+};=0D=0A+=0D=0A /********************=
*********************************************************/=0D=0A=20=0D=0A=
 /*=0D=0A@@ -564,6 +574,7 @@ famfs_file_init_dax(=0D=0A =09if (famfs_meta=
_set(fi, meta) =3D=3D NULL) {=0D=0A =09=09i_size_write(inode, meta->file_=
size);=0D=0A =09=09inode->i_flags |=3D S_DAX;=0D=0A+=09=09inode->i_data.a=
_ops =3D &famfs_dax_aops;=0D=0A =09} else {=0D=0A =09=09pr_debug("%s: fil=
e already had metadata\n", __func__);=0D=0A =09=09__famfs_meta_free(meta)=
;=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
