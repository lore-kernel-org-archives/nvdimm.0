Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334AC5A0E8
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 23:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543826; cv=none; b=FjaGBHjE882XUvaboUkr0R3590XXytQF7CKpLne8AithJYH39oJKvnsqkVtQLLiBBd82XNjqp5ww2qhKJ5zV6Agq4km+fSbVrJNlWQmfcR+8MVIGGwNZaClF6YDdfWnEi+xqqsDltH2Aaw+Beu0sghtAmVoqahQUP0++XhLbT78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543826; c=relaxed/simple;
	bh=RMuhIjUGazBLLwRV5Az+LWoHwQf1/uGbV597a9mcp2c=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=K54bL9I4AcypF7IDZp/CKiz9LZtaWsmGBcupmH+7AGcRagTZ6jTkgBznOK/UdAqmoc84T7h4ezg4AAg9ykmqLyuV6xiE9w3Ba2oRoKS8hDh47cIViByy0CIvtPFbu2pNyfgaV/dJ3XCX2TGH9fuuG25OzNPCE346Py4wSVr30gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G0od8TO2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G0od8TO2"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240315230336epoutp013b025b039ec9a3750353dd436ea31777~9EomwqGKK2709727097epoutp01O
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 23:03:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240315230336epoutp013b025b039ec9a3750353dd436ea31777~9EomwqGKK2709727097epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1710543816;
	bh=RMuhIjUGazBLLwRV5Az+LWoHwQf1/uGbV597a9mcp2c=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=G0od8TO2IwVTGE+yd/zxqF3ly7VesKQviD9KDnMAVYrUFv1j2KHVCPdbfBSxhvrtF
	 5oVQAoRx3C6zPbl9n7Hd9cUVflUDOXmNj0DbSQz+kaZGddmned/ELzcezqyHKbeNd5
	 dvXTy9O6q5ogAVkjrArg5UJrFUtu8V71vzc2qd6w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240315230335epcas2p1be595b9a66cf779ad1463b129d5fa0ac~9EomgPn5q1367013670epcas2p1o;
	Fri, 15 Mar 2024 23:03:35 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.99]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TxKYM1GGMz4x9Pr; Fri, 15 Mar
	2024 23:03:35 +0000 (GMT)
X-AuditID: b6c32a4d-743ff70000004a32-e3-65f4d3c7bf6c
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FE.54.18994.7C3D4F56; Sat, 16 Mar 2024 08:03:35 +0900 (KST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Subject: RE: [ndctl PATCH v11 7/7] cxl/test: add cxl-poison.sh unit test
Reply-To: wj28.lee@samsung.com
Sender: Wonjae Lee <wj28.lee@samsung.com>
From: Wonjae Lee <wj28.lee@samsung.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
CC: Hojin Nam <hj96.nam@samsung.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <24c1f2ec413f92e8e6e8817b3d4d55f5bb142849.1710386468.git.alison.schofield@intel.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240315230334epcms2p1d92e47ec32b59ffbb186a0204f9b0866@epcms2p1>
Date: Sat, 16 Mar 2024 08:03:34 +0900
X-CMS-MailID: 20240315230334epcms2p1d92e47ec32b59ffbb186a0204f9b0866
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmqe7xy19SDa7PZ7W4+/gCm8WHN/9Y
	LM7POsVisfLHH1aLWxOOMTmweize85LJ48XmmYwefVtWMXp83iQXwBKVbZORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFdJoSwxpxQoFJBYXKykb2dT
	lF9akqqQkV9cYquUWpCSU2BeoFecmFtcmpeul5daYmVoYGBkClSYkJ1x6v5xpoKtXBUrHu1m
	bWC8zdnFyMkhIWAicePYF/YuRi4OIYE9jBLH/y1k7WLk4OAVEJT4u0MYpEZYwEPi35arrCC2
	kICcxN3bp5gg4poSb6atYgGx2QTUJX50ngSLiwhkSFz/84cJZCazwBRGie4bh1ghlvFKzGh/
	ygJhS0tsX76VEcTmFEiUOHTkISNEXEPix7JeZghbVOLm6rfsMPb7Y/OhakQkWu+dhaoRlHjw
	czcjzMwJB9YzgtwvIVAu8Wa9OcgNEgINjBJPVv6FmmMu8ezFVjYQm1fAV+LY/WVgR7MIqEpc
	fXAJaqaLxPovX8BsZgFtiWULXzODzGQGenj9Ln2I8coSR26xQFTwSXQchpnOK7Fj3hMmCFtJ
	YkrbEajLJCQaGiG2SgCDc+2NV6wTGBVnIQJ6FpJdsxB2LWBkXsUolVpQnJuemmxUYKibl1oO
	j9/k/NxNjOBUqOW7g/H1+r96hxiZOBgPMUpwMCuJ8NYpfkwV4k1JrKxKLcqPLyrNSS0+xGgK
	9OlEZinR5HxgMs4riTc0sTQwMTMzNDcyNTBXEue91zo3RUggPbEkNTs1tSC1CKaPiYNTqoEp
	sN3w4sG/xrb3oswnc53hjSrbs2958bon1yXTKt18XTUytJb9SbjFmX0s20Pn+No7j/j7b8q8
	in109aSVwO9sPgHxY4YdR58H2O4QTp1hv0dP/ubSH79/BoRNjd51UnDWLpdnmQv3zFdU298m
	ImW5wZ5thegbbhGB1yEntuTH5kd90TnkaJTHIDnZcgHb15oGDrber1WlHOarpNa0f09LnXx1
	U8zNXw8XnlJ8YvuoSMxr41verIiFRxzzfyUv9doTEtE00+/OIp0FzzoN3/5q++E3N8XSiF3G
	4tvaN4JS9hurlnuy5rc6aomkVk11P7K+ZP9xzVUtsfs0NXfFWJ+us2F3q5217R+/zJa1NrpK
	LMUZiYZazEXFiQA91RriDgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240314040551epcas2p40829b16b09f439519a692070fb460242
References: <24c1f2ec413f92e8e6e8817b3d4d55f5bb142849.1710386468.git.alison.schofield@intel.com>
	<cover.1710386468.git.alison.schofield@intel.com>
	<CGME20240314040551epcas2p40829b16b09f439519a692070fb460242@epcms2p1>

alison.schofield=40intel.com wrote:
> From: Alison Schofield <alison.schofield=40intel.com>
>
> Exercise cxl list, libcxl, and driver pieces of the get poison list
> pathway. Inject and clear poison using debugfs and use cxl-cli to
> read the poison list by memdev and by region.
>
> Signed-off-by: Alison Schofield <alison.schofield=40intel.com>
> ---
> test/cxl-poison.sh 137 +++++++++++++++++++++++++++++++++++++++++++++
> test/meson.build=C2=A0=20=C2=A0=202=20+=0D=0A>=202=20files=20changed,=201=
39=20insertions(+)=0D=0A>=20create=20mode=20100644=20test/cxl-poison.sh=0D=
=0A>=0D=0A>=20diff=20--git=20a/test/cxl-poison.sh=20b/test/cxl-poison.sh=0D=
=0A>=20new=20file=20mode=20100644=0D=0A>=20index=20000000000000..af2e9dcd1a=
11=0D=0A>=20---=20/dev/null=0D=0A>=20+++=20b/test/cxl-poison.sh=0D=0A=0D=0A=
=5Bsnip=5D=0D=0A=0D=0A>=20+=23=20Turn=20tracing=20on.=20Note=20that=20'cxl=
=20list=20--poison'=20does=20toggle=20the=20tracing.=0D=0A=0D=0AHi,=0D=0A=
=0D=0AI=20know=20it's=20trivial=20and=20not=20sure=20if=20I'm=20understandi=
ng=20the=20history=20of=0D=0Athe=20patch=20series=20correctly,=20but=20--po=
ison=20seems=20to=20be=20an=20option=20that=0D=0Awas=20suggested=20before=
=20--media-errors.=20I'm=20wondering=20if=20it's=20okay=20to=0D=0Aleave=20t=
his=20comment.=0D=0A=0D=0AThanks,=0D=0AWonjae
