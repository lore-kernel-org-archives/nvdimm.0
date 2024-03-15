Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496C97476
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710464997; cv=none; b=bLa/Wby4Ol2WhAs07dksjDLIMUmpelw5s0E8FmOwjAsCktqHF0AusDP1QSN+FAXC7Qr8JsF513ZFPHGixdvOeuIxnaLgzlaD2R0rJtVRiD7c9WftlQb9hg76V3tVfgwo+3NGIy6OW3mfEfg/JdlWMPWVOU01wTzEheN093K74eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710464997; c=relaxed/simple;
	bh=CMFRuseNI/BTwpULmbwhZpjISyqhQbCM5JXERSy3H2o=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=FAwzFWlT9SXzmO0YjoGNEVdWzs3kCZobVHLhheHs1cHaYHK32kbtdGSOcCFpUxuXLKkmV8mb9VbW+sAXNO4O7/WEkRBw2f8gms7r0/Ua/BB8Loq54WOLAGnPWWR38XJqfNaoo7/19PHvzT+BOcb5Ey0+9YO9U9DHtdusraXUhkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oDrXAF+n; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oDrXAF+n"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240315010946epoutp030910a7a1f056a4df88dd7d6e9a7270cf~8yteqAO0K1737217372epoutp03L
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 01:09:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240315010946epoutp030910a7a1f056a4df88dd7d6e9a7270cf~8yteqAO0K1737217372epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1710464986;
	bh=CMFRuseNI/BTwpULmbwhZpjISyqhQbCM5JXERSy3H2o=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=oDrXAF+nj7ajElerpAV2FruP2j96EGDgizfswuFaeRl/ZP8Z8ANHhX3LWiXBVcHVp
	 tT0AxFYLvIyN/3xKCs52YGGTr0+cEN1Kh9EgNq4Jb96ONrqVvesG5FF4aWMsLuQB09
	 wQyGlSleY92XrC3ksMM/rd9VSAqhk5TPvVkYFjLM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240315010945epcas2p39a6503a37d131eb2a37c099ec9f1ca02~8yteVE8gP1180311803epcas2p3R;
	Fri, 15 Mar 2024 01:09:45 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.68]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TwmPP1XMMz4x9Q8; Fri, 15 Mar
	2024 01:09:45 +0000 (GMT)
X-AuditID: b6c32a48-bcdfd70000002587-27-65f39fd9c48c
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.DC.09607.9DF93F56; Fri, 15 Mar 2024 10:09:45 +0900 (KST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Subject: RE: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to
 cxl list
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
In-Reply-To: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b@epcms2p4>
Date: Fri, 15 Mar 2024 10:09:44 +0900
X-CMS-MailID: 20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmme7N+Z9TDf7d4bS4+/gCm8WHN/9Y
	LM7POsVisfLHH1aLWxOOMTmweize85LJ48XmmYwefVtWMXp83iQXwBKVbZORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFdJoSwxpxQoFJBYXKykb2dT
	lF9akqqQkV9cYquUWpCSU2BeoFecmFtcmpeul5daYmVoYGBkClSYkJ2xqe8Re8E37oqG16cY
	GxibubsYOTkkBEwkjs95w9zFyMUhJLCDUWL232dADgcHr4CgxN8dwiA1wgIhEufbellBbCEB
	OYm7t08xQcQ1Jd5MW8UCYrMJqEv86DwJFhcRyJC4/ucPE8hMZoEpjBLdNw6xQizjlZjR/pQF
	wpaW2L58KyOIzSmQKLHhz10miLiGxI9lvcwQtqjEzdVv2WHs98fmM0LYIhKt985C1QhKPPi5
	mxFm5oQD6xlB7pcQKJd4s94c5AYJgQZGiScr/0LNMZd49mIrG4jNK+ArcXB3L1icRUBV4ufq
	V1AzXSQefHoKFmcW0JZYtvA1OEyYgR5ev0sfYryyxJFbLBAVfBIdh2Gm80rsmPcE6hMliSlt
	R6Auk5BoaITYKiHgIbHr5kfmCYyKsxABPQvJrlkIuxYwMq9iFEstKM5NTy02KjCBx21yfu4m
	RnAK1PLYwTj77Qe9Q4xMHIyHGCU4mJVEeOsUP6YK8aYkVlalFuXHF5XmpBYfYjQF+nIis5Ro
	cj4wCeeVxBuaWBqYmJkZmhuZGpgrifPea52bIiSQnliSmp2aWpBaBNPHxMEp1cAU4LfohXfJ
	hYw5P/+X/HSM3fBbTou/7q/hoaIz+4/Fhn780dCQzdRfq8EkvenLN7W6aSoF94MrJ+7+8qUl
	aW/cUd2NW08v3Nn8Yq9Xj67U5usHa7YwN8lwcso/3f/wlQdPrtHJn6I+0jce12/U3HFn+ckb
	flOOL3msHPP3odylm0ZL7f9NLP+7T+h3p0vX5vxpqtanTvovv7FzF3/qhilyPvJyilblL6am
	F+a4vAte/eXCI3PlzJOXL4R+XqBzTPfYnHf+h179y7Wb8S6Kg+2Tr8+csleTcllOP533/NVb
	/10s/k5aEXcPsh471/YtRsHO7fYDUyn1db3G8f73fCWPC16fxPZwju2af1G1i9SymZVYijMS
	DbWYi4oTATwM3jwKBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240314040548epcas2p3698bf9d1463a1d2255dc95ac506d3ae8
References: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
	<cover.1710386468.git.alison.schofield@intel.com>
	<CGME20240314040548epcas2p3698bf9d1463a1d2255dc95ac506d3ae8@epcms2p4>

alison.schofield=40intel.com wrote:
> From: Alison Schofield <alison.schofield=40intel.com>
>
> The --media-errors option to 'cxl list' retrieves poison lists from
> memory devices supporting the capability and displays the returned
> media_error records in the cxl list json. This option can apply to
> memdevs or regions.
>
> Include media-errors in the -vvv verbose option.
>
> Example usage in the Documentation/cxl/cxl-list.txt update.
>
> Signed-off-by: Alison Schofield <alison.schofield=40intel.com>
> ---
> Documentation/cxl/cxl-list.txt 62 +++++++++++++++++++++++++++++++++-
> cxl/filter.h=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=203=20++=0D=0A>=20cxl/list.c=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=203=20++=0D=0A>=203=20files=20changed,=2067=20insertions(+),=201=20dele=
tion(-)=0D=0A>=0D=0A>=20diff=20--git=20a/Documentation/cxl/cxl-list.txt=20b=
/Documentation/cxl/cxl-list.txt=0D=0A>=20index=20838de4086678..6d3ef92c29e8=
=20100644=0D=0A>=20---=20a/Documentation/cxl/cxl-list.txt=0D=0A>=20+++=20b/=
Documentation/cxl/cxl-list.txt=0D=0A=0D=0A=5Bsnip=5D=0D=0A=0D=0A+----=0D=0A=
+In=20the=20above=20example,=20region=20mappings=20can=20be=20found=20using=
:=0D=0A+=22cxl=20list=20-p=20mem9=20--decoders=22=0D=0A+----=0D=0A=0D=0AHi,=
=20isn't=20it=20'-m=20mem9'=20instead=20of=20-p?=20FYI,=20it's=20also=20on=
=20patch's=0D=0Acover=20letter,=20too.=0D=0A=0D=0AThanks,=0D=0AWonjae
