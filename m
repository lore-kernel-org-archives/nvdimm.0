Received: from a11-77.smtp-out.amazonses.com (a11-77.smtp-out.amazonses.com [54.240.11.77])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DF626738C
	for <nvdimm@lists.linux.dev>; Tue, 24 Mar 2026 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774312698; cv=none; b=UCzkD1d3K4/S5SCdFgnkRYyXJDepq9F7jIBSD3QIskAJbST+AFZ4KRrf1TIfQ5tc8B/n2h3YHy9UVEGvR9bTUJfpsVvxxzrwJ5xIDap7DpQFM+RvaOV9RPJTzzYnhiU+9CsKxArfRVkowKH5cRad8tdHYpMQevEtav00S/kgba0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774312698; c=relaxed/simple;
	bh=yiuc0twYlcmX733odawcLOmHnxbjTLm+C+WkdnftpAE=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=lfkrLAMqIZQLSnZyoRp/Mqnsh0mdFRpUZpuF+9pk7aGmkn1gvJ64KOfGBR3Yri0fl4ezsMdjt18xkRVXRCQdO13zooemtzlreNV+gERNEGepMqYf6KXuhNYvSnnGkAuqtLPxf64VObLEb/d4EDIEUx892lTqoY93hgQVc66HWMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=Cqe0uRyd; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=lsnlpZZz; arc=none smtp.client-ip=54.240.11.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="Cqe0uRyd";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="lsnlpZZz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774312696;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=yiuc0twYlcmX733odawcLOmHnxbjTLm+C+WkdnftpAE=;
	b=Cqe0uRydg/nGxqD4nb3TWiffbOSYrCUX1CzJLkgG8wvN1IEeRYy+khXwXbeLce7U
	nc2qkpYPDvY5sZx5AjIJliLElNmf1NTPQqsSzo1kbyHQncrIEfCbp5oNPD0ldb6sbUk
	2mtwzKLQLCB4crvD9L5Gj/plxMPJHBB3r61cGaYo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774312696;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=yiuc0twYlcmX733odawcLOmHnxbjTLm+C+WkdnftpAE=;
	b=lsnlpZZzO4W9qADiDm15Hsc9hA35ApvCteRONLjMZwnPPrCRk1mcg9yFjxJOiFIa
	NC3/G20dVclX2NbHD7rKYvRPXf6M2+v37+EAkdkPkQUKlvu2ZfxmT2n0QqG2zn9DlEw
	BM8FJFBaDL67A1/qoa0+dS527T1by7q7UeZCVn7E=
Subject: [PATCH V9 2/8] dax: Factor out dax_folio_reset_order() helper
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
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>, 
	=?UTF-8?Q?Ira_Weiny?= <ira.weiny@intel.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 24 Mar 2026 00:38:15 +0000
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
 <20260324003756.4990-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcuyZ/D2VVFX/RT7OCCFY4LyVmAQ==
Thread-Topic: [PATCH V9 2/8] dax: Factor out dax_folio_reset_order() helper
X-Wm-Sent-Timestamp: 1774312694
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d1d47285f-eedfbde4-0f74-4356-b694-4b44fab92f2c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.24-54.240.11.77

From: John Groves <John@Groves.net>=0D=0A=0D=0ABoth fs/dax.c:dax_folio_pu=
t() and drivers/dax/fsdev.c:=0D=0Afsdev_clear_folio_state() (the latter c=
oming in the next commit after this=0D=0Aone) contain nearly identical co=
de to reset a compound DAX folio back to=0D=0Aorder-0 pages. Factor this =
out into a shared helper function.=0D=0A=0D=0AThe new dax_folio_reset_ord=
er() function:=0D=0A- Clears the folio's mapping and share count=0D=0A- R=
esets compound folio state via folio_reset_order()=0D=0A- Clears PageHead=
 and compound_head for each sub-page=0D=0A- Restores the pgmap pointer fo=
r each resulting order-0 folio=0D=0A- Returns the original folio order (f=
or callers that need to advance by=0D=0A  that many pages)=0D=0A=0D=0ATwo=
 intentional differences from the original dax_folio_put() logic:=0D=0A=0D=
=0A1. folio->share is cleared unconditionally. This is correct because th=
e DAX=0D=0A   subsystem maintains the invariant that share !=3D 0 only wh=
en mapping =3D=3D NULL=0D=0A   (enforced by dax_folio_make_shared()). dax=
_folio_put() ensures share has=0D=0A   reached zero before calling this h=
elper, so the unconditional clear is safe.=0D=0A=0D=0A2. folio->pgmap is =
now explicitly restored for order-0 folios. For the=0D=0A   dax_folio_put=
() caller this is a no-op (reads and writes back the same=0D=0A   field).=
 It is intentional for the upcoming fsdev_clear_folio_state()=0D=0A   cal=
ler, which converts previously-compound folios and needs pgmap=0D=0A   re=
-established for all pages regardless of order.=0D=0A=0D=0AThis simplifie=
s fsdev_clear_folio_state() from ~50 lines to ~15 lines.=0D=0A=0D=0ASugge=
sted-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0AReviewed-by:=
 Ira Weiny <ira.weiny@intel.com>=0D=0AReviewed-by: Dave Jiang <dave.jiang=
@intel.com>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=
=0A fs/dax.c            | 74 ++++++++++++++++++++++++++++++++++----------=
-=0D=0A include/linux/dax.h |  1 +=0D=0A 2 files changed, 57 insertions(+=
), 18 deletions(-)=0D=0A=0D=0Adiff --git a/fs/dax.c b/fs/dax.c=0D=0Aindex=
 289e6254aa30..eba86802a7a7 100644=0D=0A--- a/fs/dax.c=0D=0A+++ b/fs/dax.=
c=0D=0A@@ -378,6 +378,59 @@ static void dax_folio_make_shared(struct foli=
o *folio)=0D=0A =09folio->share =3D 1;=0D=0A }=0D=0A=20=0D=0A+/**=0D=0A+ =
* dax_folio_reset_order - Reset a compound DAX folio to order-0 pages=0D=0A=
+ * @folio: The folio to reset=0D=0A+ *=0D=0A+ * Splits a compound folio =
back into individual order-0 pages,=0D=0A+ * clearing compound state and =
restoring pgmap pointers.=0D=0A+ *=0D=0A+ * Returns: the original folio o=
rder (0 if already order-0)=0D=0A+ */=0D=0A+int dax_folio_reset_order(str=
uct folio *folio)=0D=0A+{=0D=0A+=09struct dev_pagemap *pgmap =3D page_pgm=
ap(&folio->page);=0D=0A+=09int order =3D folio_order(folio);=0D=0A+=0D=0A=
+=09/*=0D=0A+=09 * DAX maintains the invariant that folio->share !=3D 0 o=
nly when=0D=0A+=09 * folio->mapping =3D=3D NULL (enforced by dax_folio_ma=
ke_shared()).=0D=0A+=09 * Equivalently: folio->mapping !=3D NULL implies =
folio->share =3D=3D 0.=0D=0A+=09 * Callers ensure share has been decremen=
ted to zero before=0D=0A+=09 * calling here, so unconditionally clearing =
both fields is=0D=0A+=09 * correct.=0D=0A+=09 */=0D=0A+=09folio->mapping =
=3D NULL;=0D=0A+=09folio->share =3D 0;=0D=0A+=0D=0A+=09if (!order) {=0D=0A=
+=09=09/*=0D=0A+=09=09 * Restore pgmap explicitly even for order-0 folios=
=2E For=0D=0A+=09=09 * the dax_folio_put() caller this is a no-op (same v=
alue),=0D=0A+=09=09 * but fsdev_clear_folio_state() may call this on foli=
os=0D=0A+=09=09 * that were previously compound and need pgmap=0D=0A+=09=09=
 * re-established.=0D=0A+=09=09 */=0D=0A+=09=09folio->pgmap =3D pgmap;=0D=
=0A+=09=09return 0;=0D=0A+=09}=0D=0A+=0D=0A+=09folio_reset_order(folio);=0D=
=0A+=0D=0A+=09for (int i =3D 0; i < (1UL << order); i++) {=0D=0A+=09=09st=
ruct page *page =3D folio_page(folio, i);=0D=0A+=09=09struct folio *f =3D=
 (struct folio *)page;=0D=0A+=0D=0A+=09=09ClearPageHead(page);=0D=0A+=09=09=
clear_compound_head(page);=0D=0A+=09=09f->mapping =3D NULL;=0D=0A+=09=09f=
->share =3D 0;=0D=0A+=09=09f->pgmap =3D pgmap;=0D=0A+=09}=0D=0A+=0D=0A+=09=
return order;=0D=0A+}=0D=0A+=0D=0A static inline unsigned long dax_folio_=
put(struct folio *folio)=0D=0A {=0D=0A =09unsigned long ref;=0D=0A@@ -391=
,28 +444,13 @@ static inline unsigned long dax_folio_put(struct folio *fo=
lio)=0D=0A =09if (ref)=0D=0A =09=09return ref;=0D=0A=20=0D=0A-=09folio->m=
apping =3D NULL;=0D=0A-=09order =3D folio_order(folio);=0D=0A-=09if (!ord=
er)=0D=0A-=09=09return 0;=0D=0A-=09folio_reset_order(folio);=0D=0A+=09ord=
er =3D dax_folio_reset_order(folio);=0D=0A=20=0D=0A+=09/* Debug check: ve=
rify refcounts are zero for all sub-folios */=0D=0A =09for (i =3D 0; i < =
(1UL << order); i++) {=0D=0A-=09=09struct dev_pagemap *pgmap =3D page_pgm=
ap(&folio->page);=0D=0A =09=09struct page *page =3D folio_page(folio, i);=
=0D=0A-=09=09struct folio *new_folio =3D (struct folio *)page;=0D=0A-=0D=0A=
-=09=09ClearPageHead(page);=0D=0A-=09=09clear_compound_head(page);=0D=0A=20=
=0D=0A-=09=09new_folio->mapping =3D NULL;=0D=0A-=09=09/*=0D=0A-=09=09 * R=
eset pgmap which was over-written by=0D=0A-=09=09 * prep_compound_page().=
=0D=0A-=09=09 */=0D=0A-=09=09new_folio->pgmap =3D pgmap;=0D=0A-=09=09new_=
folio->share =3D 0;=0D=0A-=09=09WARN_ON_ONCE(folio_ref_count(new_folio));=
=0D=0A+=09=09WARN_ON_ONCE(folio_ref_count((struct folio *)page));=0D=0A =09=
}=0D=0A=20=0D=0A =09return ref;=0D=0Adiff --git a/include/linux/dax.h b/i=
nclude/linux/dax.h=0D=0Aindex bf103f317cac..73cfc1a7c8f1 100644=0D=0A--- =
a/include/linux/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -153,6 +153,=
7 @@ static inline void fs_put_dax(struct dax_device *dax_dev, void *hold=
er)=0D=0A #if IS_ENABLED(CONFIG_FS_DAX)=0D=0A int dax_writeback_mapping_r=
ange(struct address_space *mapping,=0D=0A =09=09struct dax_device *dax_de=
v, struct writeback_control *wbc);=0D=0A+int dax_folio_reset_order(struct=
 folio *folio);=0D=0A=20=0D=0A struct page *dax_layout_busy_page(struct a=
ddress_space *mapping);=0D=0A struct page *dax_layout_busy_page_range(str=
uct address_space *mapping, loff_t start, loff_t end);=0D=0A--=20=0D=0A2.=
53.0=0D=0A=0D=0A
