Received: from a48-177.smtp-out.amazonses.com (a48-177.smtp-out.amazonses.com [54.240.48.177])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F197136B04B
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645465; cv=none; b=e0T67LrLswWiYCwDbsBqRVQRfGRwSUxsX7xy2rF7fjIVhsRPTXPHVGV12hi0nYHIA0HDAaWr9To0wL4vBBjzkXM+yTEVfgqF/8PJI0NrzcsTMXKBmiVN2Z6eWyaVMEka5uyYErMy7+SaJN9gFFtXvRxYLZf4jb6yLII/3cLGcPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645465; c=relaxed/simple;
	bh=zIOWbJGDpwN20+ArJhUy7S2sCSSC0DAg+0qD+/z4SMg=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=s40Z87ilG+J4tGeOk8W+VPFz5+Pu0lLUGIBJ12haCB2EV8c46IbQizdgEBPT6A1VF9mod+FJn8OgBM4s/E6SA0h5vvHHAuIzro1GSg8Pt2ekYG7blGjjIyoMMZzxZBxB/8x6twkIk0AiA9PcWadzM3NZfPhnDAN6ifEsHcvPuJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=k/fh1qkk; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=SulBK2Rp; arc=none smtp.client-ip=54.240.48.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="k/fh1qkk";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="SulBK2Rp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645462;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=zIOWbJGDpwN20+ArJhUy7S2sCSSC0DAg+0qD+/z4SMg=;
	b=k/fh1qkkSgAXGGAyMREoe9/0tTH/S0LZo6+q80q9hxWBr5zAqAJ+/UG3Enf5cDB/
	y4hpfozzAkYMN5Zz16QWR80f6EqZV9Q4Of+vmF8COU/aRkaIgk27uozGz+CtIQRnpOk
	DrZmguPDqLr9/QWjshngotbWiZNfz+MlDDR+Cgws=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645462;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=zIOWbJGDpwN20+ArJhUy7S2sCSSC0DAg+0qD+/z4SMg=;
	b=SulBK2RprH5PN83TeYEGk61nrs3nHCRo6gOaep+pDjAgsEVxXK+sApoMepSwEKhW
	RO4l3PV7zCmXrJjMvdvvO+rNOFqJrFEiCMuKDKZUNdDYMusdtYDk4Ga27VrksRY9DCU
	3GnlSTG7R/8w1+cIX62KNP41TDPZKmBmgGfTjEGg=
Subject: [PATCH V10 2/8] dax: Factor out dax_folio_reset_order() helper
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
Date: Fri, 27 Mar 2026 21:04:22 +0000
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
 <20260327210411.79146-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi1Ig13Pv3iFRCOYHU2h1Yt2Vw==
Thread-Topic: [PATCH V10 2/8] dax: Factor out dax_folio_reset_order() helper
X-Wm-Sent-Timestamp: 1774645461
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311cc6b9-5be7428a-7f16-4774-8f90-a44b88ac5660-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.48.177

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
en=0D=0A   mapping =3D=3D NULL (enforced by dax_folio_make_shared()). dax=
_folio_put()=0D=0A   ensures share has reached zero before calling this h=
elper, so the=0D=0A   unconditional clear is safe.=0D=0A=0D=0A2. folio->p=
gmap is now explicitly restored for order-0 folios. For the=0D=0A   dax_f=
olio_put() caller this is a no-op (reads and writes back the same=0D=0A  =
 field). It is intentional for the upcoming fsdev_clear_folio_state()=0D=0A=
   caller, which converts previously-compound folios and needs pgmap=0D=0A=
   re-established for all pages regardless of order.=0D=0A=0D=0AThis simp=
lifies fsdev_clear_folio_state() from ~50 lines to ~15 lines.=0D=0A=0D=0A=
Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>=0D=0AReviewe=
d-by: Ira Weiny <ira.weiny@intel.com>=0D=0AReviewed-by: Dave Jiang <dave.=
jiang@intel.com>=0D=0AReviewed-by: Jonathan Cameron <jonathan.cameron@hua=
wei.com>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A=
 fs/dax.c            | 73 ++++++++++++++++++++++++++++++++++-----------=0D=
=0A include/linux/dax.h |  1 +=0D=0A 2 files changed, 56 insertions(+), 1=
8 deletions(-)=0D=0A=0D=0Adiff --git a/fs/dax.c b/fs/dax.c=0D=0Aindex 289=
e6254aa30..87bed6de920d 100644=0D=0A--- a/fs/dax.c=0D=0A+++ b/fs/dax.c=0D=
=0A@@ -378,6 +378,58 @@ static void dax_folio_make_shared(struct folio *f=
olio)=0D=0A =09folio->share =3D 1;=0D=0A }=0D=0A=20=0D=0A+/**=0D=0A+ * da=
x_folio_reset_order - Reset a compound DAX folio to order-0 pages=0D=0A+ =
* @folio: The folio to reset=0D=0A+ *=0D=0A+ * Splits a compound folio ba=
ck into individual order-0 pages,=0D=0A+ * clearing compound state and re=
storing pgmap pointers.=0D=0A+ *=0D=0A+ * Returns: the original folio ord=
er (0 if already order-0)=0D=0A+ */=0D=0A+int dax_folio_reset_order(struc=
t folio *folio)=0D=0A+{=0D=0A+=09struct dev_pagemap *pgmap =3D page_pgmap=
(&folio->page);=0D=0A+=09int order =3D folio_order(folio);=0D=0A+=0D=0A+=09=
/*=0D=0A+=09 * DAX maintains the invariant that folio->share !=3D 0 only =
when=0D=0A+=09 * folio->mapping =3D=3D NULL (enforced by dax_folio_make_s=
hared()).=0D=0A+=09 * Equivalently: folio->mapping !=3D NULL implies foli=
o->share =3D=3D 0.=0D=0A+=09 * Callers ensure share has been decremented =
to zero before=0D=0A+=09 * calling here, so unconditionally clearing both=
 fields is=0D=0A+=09 * correct.=0D=0A+=09 */=0D=0A+=09folio->mapping =3D =
NULL;=0D=0A+=09folio->share =3D 0;=0D=0A+=0D=0A+=09if (!order) {=0D=0A+=09=
=09/*=0D=0A+=09=09 * Restore pgmap explicitly even for order-0 folios. Fo=
r the=0D=0A+=09=09 * dax_folio_put() caller this is a no-op (same value),=
 but=0D=0A+=09=09 * fsdev_clear_folio_state() may call this on folios tha=
t=0D=0A+=09=09 * were previously compound and need pgmap re-established.=0D=
=0A+=09=09 */=0D=0A+=09=09folio->pgmap =3D pgmap;=0D=0A+=09=09return 0;=0D=
=0A+=09}=0D=0A+=0D=0A+=09folio_reset_order(folio);=0D=0A+=0D=0A+=09for (i=
nt i =3D 0; i < (1UL << order); i++) {=0D=0A+=09=09struct page *page =3D =
folio_page(folio, i);=0D=0A+=09=09struct folio *f =3D (struct folio *)pag=
e;=0D=0A+=0D=0A+=09=09ClearPageHead(page);=0D=0A+=09=09clear_compound_hea=
d(page);=0D=0A+=09=09f->mapping =3D NULL;=0D=0A+=09=09f->share =3D 0;=0D=0A=
+=09=09f->pgmap =3D pgmap;=0D=0A+=09}=0D=0A+=0D=0A+=09return order;=0D=0A=
+}=0D=0A+=0D=0A static inline unsigned long dax_folio_put(struct folio *f=
olio)=0D=0A {=0D=0A =09unsigned long ref;=0D=0A@@ -391,28 +443,13 @@ stat=
ic inline unsigned long dax_folio_put(struct folio *folio)=0D=0A =09if (r=
ef)=0D=0A =09=09return ref;=0D=0A=20=0D=0A-=09folio->mapping =3D NULL;=0D=
=0A-=09order =3D folio_order(folio);=0D=0A-=09if (!order)=0D=0A-=09=09ret=
urn 0;=0D=0A-=09folio_reset_order(folio);=0D=0A+=09order =3D dax_folio_re=
set_order(folio);=0D=0A=20=0D=0A+=09/* Debug check: verify refcounts are =
zero for all sub-folios */=0D=0A =09for (i =3D 0; i < (1UL << order); i++=
) {=0D=0A-=09=09struct dev_pagemap *pgmap =3D page_pgmap(&folio->page);=0D=
=0A =09=09struct page *page =3D folio_page(folio, i);=0D=0A-=09=09struct =
folio *new_folio =3D (struct folio *)page;=0D=0A-=0D=0A-=09=09ClearPageHe=
ad(page);=0D=0A-=09=09clear_compound_head(page);=0D=0A=20=0D=0A-=09=09new=
_folio->mapping =3D NULL;=0D=0A-=09=09/*=0D=0A-=09=09 * Reset pgmap which=
 was over-written by=0D=0A-=09=09 * prep_compound_page().=0D=0A-=09=09 */=
=0D=0A-=09=09new_folio->pgmap =3D pgmap;=0D=0A-=09=09new_folio->share =3D=
 0;=0D=0A-=09=09WARN_ON_ONCE(folio_ref_count(new_folio));=0D=0A+=09=09WAR=
N_ON_ONCE(folio_ref_count((struct folio *)page));=0D=0A =09}=0D=0A=20=0D=0A=
 =09return ref;=0D=0Adiff --git a/include/linux/dax.h b/include/linux/dax=
=2Eh=0D=0Aindex bf103f317cac..73cfc1a7c8f1 100644=0D=0A--- a/include/linu=
x/dax.h=0D=0A+++ b/include/linux/dax.h=0D=0A@@ -153,6 +153,7 @@ static in=
line void fs_put_dax(struct dax_device *dax_dev, void *holder)=0D=0A #if =
IS_ENABLED(CONFIG_FS_DAX)=0D=0A int dax_writeback_mapping_range(struct ad=
dress_space *mapping,=0D=0A =09=09struct dax_device *dax_dev, struct writ=
eback_control *wbc);=0D=0A+int dax_folio_reset_order(struct folio *folio)=
;=0D=0A=20=0D=0A struct page *dax_layout_busy_page(struct address_space *=
mapping);=0D=0A struct page *dax_layout_busy_page_range(struct address_sp=
ace *mapping, loff_t start, loff_t end);=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A=
