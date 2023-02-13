Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C33DAD52
	for <nvdimm@lists.linux.dev>; Mon, 13 Feb 2023 21:39:22 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20230213213916usoutp028905d3ea545478a2fc181ad1eab10959~DgB7tH-8t0679806798usoutp02_;
	Mon, 13 Feb 2023 21:39:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20230213213916usoutp028905d3ea545478a2fc181ad1eab10959~DgB7tH-8t0679806798usoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1676324356;
	bh=apffgPHQo2OKd2kN82/EeOwUBe+9ozPjYP2UmTtQ2b4=;
	h=From:To:CC:Subject:Date:References:From;
	b=Je4iQm/G5l7jl8usGRHNmcFGrggcTAKAKTKTN2r5BeKtUAQmcxv6H9KIP3IhqWdn2
	 99lnHHw8f22ZIBOu28Hk3FWpZ2hfbW3sWVlu85QS7FwkZIrgYVJmT8GYF92jZT5Peg
	 y12KBY+WBlAicKeD3uNNNeNHDzWMI+NeO7yVIs0I=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
	[203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230213213916uscas1p250505b5d7452cfe6af763a6ed3d84ba3~DgB7mUo8Z1155611556uscas1p2l;
	Mon, 13 Feb 2023 21:39:16 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges1new.samsung.com (USCPEMTA) with SMTP id 66.58.06976.40EAAE36; Mon,
	13 Feb 2023 16:39:16 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa~DgB7NCbTl1771417714uscas1p2H;
	Mon, 13 Feb 2023 21:39:16 +0000 (GMT)
X-AuditID: cbfec36d-d99ff70000011b40-40-63eaae04beac
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 6F.9B.11378.30EAAE36; Mon,
	13 Feb 2023 16:39:15 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Mon, 13 Feb 2023 13:39:15 -0800
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
	SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
	13 Feb 2023 13:39:15 -0800
From: Adam Manzanares <a.manzanares@samsung.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: Fan Ni <fan.ni@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, Adam Manzanares
	<a.manzanares@samsung.com>
Subject: [ndctl PATCH] daxctl: Skip over memory failure node status
Thread-Topic: [ndctl PATCH] daxctl: Skip over memory failure node status
Thread-Index: AQHZP/OehnE/B2wTYkm5lOWEJwqLyw==
Date: Mon, 13 Feb 2023 21:39:15 +0000
Message-ID: <20230213213853.436788-1-a.manzanares@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42LZduzreV2Wda+SDf7PlbJYfXMNo8X5WadY
	LFb++MNqcWvCMSYHFo/Fe14yebzYPJPRY+rseo/Pm+QCWKK4bFJSczLLUov07RK4Mpas6mYv
	eMVe0fjlCHsD42a2LkZODgkBE4mPW2+zdzFycQgJrGSUuPx2PiuE08oksf/jBFaYqk+v17NA
	JNYySqxde5QJJCEk8IlR4u38dIjEMkaJBVOWgs1lEzCQ+H18IzOILSJQIHHozAWwbmaB9YwS
	7Vd2Ao3l4BAWcJZ4u9wEosZDYlpjAyuErSdx4PUhFhCbRUBVYvmRVWBzeAXsJD58bARbzCgg
	JvH91Bowm1lAXOLWk/lMEJcKSiyavYcZwhaT+LfrIdSfihL3v79kh6jXk7gxdQobhK0tsWzh
	a6j5ghInZz5hgaiXlDi44gbYzRICvRwSK4+sg0q4SFxbfRlqmbTE1etToZblS+xquwJlV0hc
	fd0NtdhaYuGf9VCH8kn8/fWIEeR3CQFeiY42oQmMSrOQvDALyXmzkJw3C8l5CxhZVjGKlxYX
	56anFhvmpZbrFSfmFpfmpesl5+duYgQml9P/DufuYNxx66PeIUYmDsZDjBIczEoivMJPXyQL
	8aYkVlalFuXHF5XmpBYfYpTmYFES5zW0PZksJJCeWJKanZpakFoEk2Xi4JRqYJqSP0fht5nx
	DY0JZdcPnva5vjvPXdvYbf9SXVeGA2zLT68Nqd3Wm5dw0LTV+eL7QJ7lxXtLJ+hLrMiaXrJF
	VL/rzqc1fo73uWZnux1LOcnw8o27e+L7n0zT3ulZJgRZZF7Im5VwJv3D6kNcpf4nW/t/Twq0
	frR9+1kXjQ8L9IKeL1G37NPZUxtYf1nqhGuNhr6R091HwfNK5/z8/j0s3ejpwbnNWzMn35+5
	V5dRbp9A0OyZd3+pnDNde9elwMx/4txQKdnCZ7OPZGWU7Zlz46/pisxqMYmVQXsXK00+/FTh
	zA1NoacbBRkuTF90etbs1q6IGbu5G0veOmYfMJDcOvGZVVXFbufEm+fs/Sri2CcrsRRnJBpq
	MRcVJwIAmpf9sZ0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LJbGCaqMu87lWywcVPVharb65htDg/6xSL
	xcoff1gtbk04xuTA4rF4z0smjxebZzJ6TJ1d7/F5k1wASxSXTUpqTmZZapG+XQJXxpJV3ewF
	r9grGr8cYW9g3MzWxcjJISFgIvHp9XqWLkYuDiGB1YwSx1fsZIVwPjFKbJp8iBGkSkhgGaPE
	obviIDabgIHE7+MbmUFsEYECiUNnLoB1MwusZ5RovwLSzcEhLOAs8Xa5CUSNh8S0xgZWCFtP
	4sDrQywgNouAqsTyI6vA5vAK2El8+NjIBGIzCohJfD+1BsxmFhCXuPVkPhPEpQISS/acZ4aw
	RSVePv7HCmErStz//pIdol5P4sbUKWwQtrbEsoWvoeYLSpyc+YQFol5S4uCKGywTGEVnIVkx
	C0n7LCTts5C0L2BkWcUoXlpcnJteUWyYl1quV5yYW1yal66XnJ+7iREYUaf/HY7cwXj01ke9
	Q4xMHIyHGCU4mJVEeIWfvkgW4k1JrKxKLcqPLyrNSS0+xCjNwaIkzivkOjFeSCA9sSQ1OzW1
	ILUIJsvEwSnVwMRnqazhlT/NKmXeNGcHo8fbqirvOGq4TJ6n1Ne1avXRSeKLY1hMbGc4bBfr
	nLFsV6Puu8qDU5m3Z5XpvfA5znub8+J2I2VVw5cdxjJFbbXtLmv23r1h+0tOft7X1+eKvwqU
	ZF3W2afIsHiJqVigRC/XLF5ezV3r1n5e59/S9E7+XblF/dRzIo/km2c/qd3+xfXpl/2r3mUe
	OSDIO8emSFlrWmG3RoDA5755Ctwr63jYPPjdvl7d1Kx2wqfS4M3RV9x3/Nrro8QCbC4LBDOc
	ynE4scxHwvXnEuZJW7WTfnV3brTbb/bH7vIm/ryOY8LHv1hbxwcKMX48v8Dyq861I7eTzhYV
	dS01a61iYa4rU2Ipzkg01GIuKk4EAGbb/+kXAwAA
X-CMS-MailID: 20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa
CMS-TYPE: 301P
X-CMS-RootMailID: 20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa
References: <CGME20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa@uscas1p2.samsung.com>

When trying to match a dax device to a memblock physical address
memblock_in_dev will fail if the the phys_index sysfs file does
not exist in the memblock. Currently the memory failure directory
associated with a node is currently interpreted as a memblock.
Skip over the memory_failure directory within the node directory.

Signed-off-by: Adam Manzanares <a.manzanares@samsung.com>
---
 daxctl/lib/libdaxctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index d990479..b27a8af 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1552,6 +1552,8 @@ static int daxctl_memory_op(struct daxctl_memory *mem=
, enum memory_op op)
 	errno =3D 0;
 	while ((de =3D readdir(node_dir)) !=3D NULL) {
 		if (strncmp(de->d_name, "memory", 6) =3D=3D 0) {
+			if (strncmp(de->d_name, "memory_", 7) =3D=3D 0)
+				continue;
 			rc =3D memblock_in_dev(mem, de->d_name);
 			if (rc < 0)
 				goto out_dir;
--=20
2.39.0
