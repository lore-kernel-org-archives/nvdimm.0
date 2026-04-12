Received: from a10-72.smtp-out.amazonses.com (a10-72.smtp-out.amazonses.com [54.240.10.72])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8F2199949
	for <nvdimm@lists.linux.dev>; Sun, 12 Apr 2026 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.10.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776009008; cv=none; b=h7LROcgcMGekAlkZUqbVCU6qpIrlLdgtslXovRCoL++vjALTjBOESn0lKw/Ke3TEgzC5tWV94SoY57SJp2u9/YqLev7yRlOe/l5WsANMZ9wG+VyjXJcW2eWxXyDKMPujvzfnuze+KWowcB/jHNvquw0B7MKqiYm1QxFmMbQfyWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776009008; c=relaxed/simple;
	bh=neAQvvv/hyVTBAB5YwhRWXaPt9x/OTou63RHu59lGTc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:References:
	 Message-ID; b=NMduOfHhhWhCWhS+Emr7lT66B7bq6pSfIGRchzuK8tE+vpjkOVNdjJyq4swPf/hf8Ig6EBHZp4hlBWo2W3ihJZMcSs3f8dg6wmVqpTSf5rQkHOjhFmfIg10oCiP5NdE8sTfwbn2aCyZP9n6qIxQpK76iguv8EwXmYOWPgGPq5Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=pkDqB8ZA; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=MK2rnbyk; arc=none smtp.client-ip=54.240.10.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="pkDqB8ZA";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="MK2rnbyk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1776009006;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
	bh=neAQvvv/hyVTBAB5YwhRWXaPt9x/OTou63RHu59lGTc=;
	b=pkDqB8ZAo2BfGISnZK3OR8lfBdIy9VFgGjrIVT7ry/WpsQD4lYX9qz6/DQzIm35G
	rgxqL/RRUeJFkfbfhJwGQ5p7fM6EuQVbp4/v8crg/7JsIXti+IjSj4LKLkrYF92ybcd
	/h5cC/35WDvQcZ1IQdPM7PIu8IL77XwgkC2qOtec=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1776009006;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
	bh=neAQvvv/hyVTBAB5YwhRWXaPt9x/OTou63RHu59lGTc=;
	b=MK2rnbykTn4gsG2kBHLRd3n/AueoSpjR6ZQe7HtPS5blDXZjwNUj4NrUnmYyDIM1
	VxeGJe8tq+NNfmNz1f8ZWdEMSrjK3Gl1xcmTOKtrBjZ9XFBHxTvFgc6jIJ7RFDrQfMO
	exoTfXqyODOhIIzqQBO7CWokQcsa2SEzmmMplWPE=
Subject: [PATCH] dax/fsdev: fix uninitialized kaddr in
 fsdev_dax_zero_page_range()
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <ira.weiny@intel.com>, 
	=?UTF-8?Q?nvdimm=40lists=2El?= =?UTF-8?Q?inux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vg?= =?UTF-8?Q?er=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>
Cc: 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?Dan_Carpenter?= <dan.carpenter@linaro.org>, 
	=?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Sun, 12 Apr 2026 15:50:06 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260412154944.461748-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcypQHpyrYMyPqQm+7F5viUQCFoQ==
Thread-Topic: [PATCH] dax/fsdev: fix uninitialized kaddr in
 fsdev_dax_zero_page_range()
X-Wm-Sent-Timestamp: 1776009005
X-Original-Mailer: git-send-email 2.53.0
Message-ID: <0100019d8262cda2-9714d31c-8fc1-4ca5-b32d-4df678240d14-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.04.12-54.240.10.72

From: John Groves <John@Groves.net>=0D=0A=0D=0A__fsdev_dax_direct_access(=
) returns -EFAULT without setting *kaddr when=0D=0Adax_pgoff_to_phys() re=
turns -1 (pgoff out of range). The return value=0D=0Awas ignored, leaving=
 kaddr uninitialized before being passed to=0D=0Afsdev_write_dax().=0D=0A=
=0D=0ACheck the return value and propagate the error.=0D=0A=0D=0AThanks t=
o Dan Carpenter and the smatch project for reporting this.=0D=0A=0D=0ASig=
ned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A drivers/dax/fsde=
v.c | 5 ++++-=0D=0A 1 file changed, 4 insertions(+), 1 deletion(-)=0D=0A=0D=
=0Adiff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c=0D=0Aindex 4499=
d9621f33..188b2526bee4 100644=0D=0A--- a/drivers/dax/fsdev.c=0D=0A+++ b/d=
rivers/dax/fsdev.c=0D=0A@@ -80,9 +80,12 @@ static int fsdev_dax_zero_page=
_range(struct dax_device *dax_dev,=0D=0A =09=09=09pgoff_t pgoff, size_t n=
r_pages)=0D=0A {=0D=0A =09void *kaddr;=0D=0A+=09long rc;=0D=0A=20=0D=0A =09=
WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);=0D=0A-=09__fsdev=
_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);=0D=0A+=09=
rc =3D __fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, N=
ULL);=0D=0A+=09if (rc < 0)=0D=0A+=09=09return rc;=0D=0A =09fsdev_write_da=
x(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);=0D=0A =09return 0;=0D=0A }=0D=0A=0D=
=0Abase-commit: 2ae624d5a555d47a735fb3f4d850402859a4db77=0D=0A--=20=0D=0A=
2.53.0=0D=0A=0D=0A
