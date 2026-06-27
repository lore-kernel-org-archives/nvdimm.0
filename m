Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E456A382388;
	Sat, 27 Jun 2026 12:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782564263; cv=pass; b=AQkO1RwtVB/fFU/StnvhpHhxBTb5OCcqy8FoFWZIKjxEQtL+jEmhszo9g4MQ7VguJbXhp9H/HStRWnH63Or8quv1oAv1pxxBmE8dHDQZXZbRbtXIbxVvfzvktqMCejp6DabXH7lMPfuuaOG6CwmaS4f1hp2mLx5/9ME/hJ/8TOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782564263; c=relaxed/simple;
	bh=cxERYteQWTU3a8TILDpEYG+vRNEso7fKz0MMzI1NK4Y=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=U0BHDnEL9Cisbp+pfYx/hPOUiMYALCiClIBawolrISLMjfaXXe+l0FlBBHC4yLEm3XCivsqTwV92+WzZXpLVgvTmERE9bNMF1sNXDSSKBTP43JRV8j+X1xIB3eS21Cdj06uEeULNS3P4Rt3haeg/ZJkUFYLv4stY8xBF/U+3tB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=tyOAXEfA; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="tyOAXEfA"
ARC-Seal: i=1; a=rsa-sha256; t=1782564260; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HiGODoTXUc42Pnqrcecgia0C2hxmp2p4MiSnFVnkG1Si3tXiKpAA7pA00mfa4KiZ6pzj+72aLMEfijUbnRXFSd6DJHLtWrCAdD6Jkk791l2I3bVU908w2Gbm6EZk5vOzl4mNPBG/vga4IxHJ7SJBRDHK1u7UbFDvXQ0JhyyyraQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1782564260; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=DdkWOUkwSciCIxdUzMMc8crEmSSjspHVmReA62QMvHc=; 
	b=AC0/f/Ow244XoX251Q4SbTZAJg7O5a9H1B0rS/iLD0jGo8qDcZk4jDb947mjroduZSwJrKOytXKoLp6NDq1gB4kELRSUkePTgnXNm8X0Sp1Kgd1huMwAmh4QRxe4NB/rC3iDVHOkQIwtYm56aAlPZvwIYobPtrTlNSD7BHvXntA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782564260;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=DdkWOUkwSciCIxdUzMMc8crEmSSjspHVmReA62QMvHc=;
	b=tyOAXEfAzHv0bler0HNpXWufOF5WW02Sht2c6i3hHgqxNAXQKFGpmir0IOJ14gya
	UJMhL7hcIl8tVrYt1VlQnYpmLOgybKoLrdcvgC09DFl4Bs6wFRQMu8hBjHUpsnSj37W
	cygP1dXwQPCJoWtNAZVqmKKOCHi0O7cBqL/gtyUU=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1782564259651514.2214148577914; Sat, 27 Jun 2026 05:44:19 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1782564255661979.9792545797312; Sat, 27 Jun 2026 05:44:15 -0700 (PDT)
Date: Sat, 27 Jun 2026 20:44:15 +0800
From: Li Chen <me@linux.beauty>
To: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>
Cc: "Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Alison Schofield" <alison.schofield@intel.com>,
	"virtualization" <virtualization@lists.linux.dev>,
	"nvdimm" <nvdimm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19f091bf79b.46bc6ca85487501.1901018185771476275@linux.beauty>
In-Reply-To: <CAM9Jb+gzSrobPgH_nMPs+RsbhVP8jovpAQsC5syQKoLrtqnX=A@mail.gmail.com>
References: <20260621130246.2973254-1-me@linux.beauty> <20260621130246.2973254-5-me@linux.beauty> <CAM9Jb+gzSrobPgH_nMPs+RsbhVP8jovpAQsC5syQKoLrtqnX=A@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] nvdimm: virtio_pmem: stop allocating child
 flush bio
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Pankaj

 ---- On Thu, 25 Jun 2026 01:22:14 +0800  Pankaj Gupta <pankaj.gupta.linux@=
gmail.com> wrote ---=20
 > > pmem_submit_bio() passes the parent bio to nvdimm_flush() for
 > > REQ_FUA. For virtio-pmem this makes async_pmem_flush() allocate
 > > and submit a child PREFLUSH bio chained to the parent.
 > >
 > > That child allocation is in the block submit path. Making it
 > > blocking with GFP_NOIO can consume the same global bio mempool that
 > > submit_bio() uses, while making it GFP_ATOMIC can fail under
 > > pressure. A forced failure of the child allocation produced:
 > >
 > > virtio_pmem: forcing child bio allocation failure for test
 > > Buffer I/O error on dev pmem0, logical block 0, lost sync page write
 > > EXT4-fs (pmem0): I/O error while writing superblock
 > > EXT4-fs (pmem0): mount failed
 > >
 > > Avoid the child bio completely. Flush FUA synchronously, like
 > > REQ_PREFLUSH, then complete the parent after the flush. Since no
 > > child bio can be created, async_pmem_flush() now only issues the
 > > virtio flush and preserves negative errno values.
 >=20
 > Child flush is asynchronous (performs async flush to host side and retur=
ns).
 > Till child bio completes guest userspace waits in pending IO state.
 > It seems the current change will affect the behavior?
 >=20
 > Prior RFC [1] attempted to coalesce the async FLUSH request between gues=
t &host.
 > If there is interest, that approach could be revisited or integrated her=
e?
 >=20
 > [1] https://lore.kernel.org/all/20220111161937.56272-1-pankaj.gupta.linu=
x@gmail.com/#t


Yes, agreed. This does change the FUA path.

I will rework it to avoid the child bio allocation while keeping the
parent bio completion asynchronous, using your RFC as reference.

Regards,
Li=E2=80=8B


