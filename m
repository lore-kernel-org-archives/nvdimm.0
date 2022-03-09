Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7500817C0
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 23:44:00 +0000 (UTC)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220309233643usoutp02a2625b5f889b539c033c1d10de82aa44~a2qIv3Lc83197131971usoutp02c;
	Wed,  9 Mar 2022 23:36:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220309233643usoutp02a2625b5f889b539c033c1d10de82aa44~a2qIv3Lc83197131971usoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1646869003;
	bh=OZ3t+YvzG339YqzSPsoWUfwRNRd0Df2qnX/7JxuJrn8=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=mtt9FfVj+vvgI+03Co15F4bHS24ads0peEGlM/uwMFQXmxsg8ZXXJR/q9G78TYHqa
	 hqkFWu0LYBdMRrPJilRSgbOTx5LXy+076sjx04/PujTUkebbZZu7IHyCZvHlP4OqHf
	 wNcCKs4ppfUiEYjSbiEA0i2gzeo6rBBjZ8TuXjSA=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20220309233643uscas1p252f6bfcf8492343f30d81db959722c1a~a2qIlgrXM2035720357uscas1p2T;
	Wed,  9 Mar 2022 23:36:43 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id 7F.53.09687.B0A39226; Wed, 
	9 Mar 2022 18:36:43 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220309233643uscas1p1fb265ba484025640d71efce3fd19d134~a2qIGbcK53127931279uscas1p1I;
	Wed,  9 Mar 2022 23:36:43 +0000 (GMT)
X-AuditID: cbfec370-9ddff700000025d7-c1-62293a0b2be1
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 1D.0A.09657.A0A39226; Wed, 
	9 Mar 2022 18:36:43 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2242.4; Wed, 9 Mar 2022 15:36:42 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
	SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
	15.01.2242.008; Wed, 9 Mar 2022 15:36:42 -0800
From: Adam Manzanares <a.manzanares@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	'Ben Widawsky' <ben.widawsky@intel.com>, 'Vishal Verma'
	<vishal.l.verma@intel.com>, 'Dan Williams' <dan.j.williams@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	Heekwon Park <heekwon.p@samsung.com>, Jongmin Gim <gim.jongmin@samsung.com>,
	Jaemin Jung <j.jaemin@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>
Subject: Re: [LSF/MM/BPF BOF idea] CXL BOF discussion
Thread-Topic: [LSF/MM/BPF BOF idea] CXL BOF discussion
Thread-Index: AQHYMmduDTspOuOipkyN4TVc0djhNqy4PleA
Date: Wed, 9 Mar 2022 23:36:42 +0000
Message-ID: <20220309233634.GA89599@bgt-140510-bm01>
In-Reply-To: <YiZ0Jmhyf515EJzD@iweiny-desk3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3C842B9F32CB7A4EB49AB6D11C93E5DF@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsWy7djX87rcVppJBlceKlvcfXyBzaLrWT+z
	xfSpFxgtVt9cw2ix/+lzFot7a/6zWux7vZfZYuWPP6wWtyYcY3Lg9Fi85yWTx6ZPk9g9Jt9Y
	zujxYvNMRo+ps+sDWKO4bFJSczLLUov07RK4MiYdmcNe0MNS8WzTNdYGxj7mLkZODgkBE4n3
	/28A2VwcQgIrGSXmzHjNDuG0MknMWd7DBFO168M1FhBbSGAto8S/b4IQRR8YJfo+drJCJPYz
	Ssza5g9iswkYSPw+vhFshYiAssTpf1fZQBqYBRpYJC70H2AESQgLmEqs7mxmgigyk7jbt4od
	wjaSWHL4M1gzi4CKxJaHW8FqeIGuOLvvDVgvp4COxKdlM8HijAJiEt9PrQGzmQXEJW49mQ91
	taDEotl7oP4Uk/i36yEbhK0ocf/7S3aIeh2JBbs/sUHYdhJXXxxjhbC1JZYtfM0MsVdQ4uTM
	JywQvZISB1fcYAF5RkLgCYfE5yUHoBIuEk1bmqEWS0tMX3MZqmgVo8SUb23sEM5mRokZvy5A
	VVlL/Ou8xj6BUWUWkstnIblqFpKrZiG5ahaSqxYwsq5iFC8tLs5NTy02zkst1ytOzC0uzUvX
	S87P3cQITFyn/x0u2MF469ZHvUOMTByMhxglOJiVRHibQjWShHhTEiurUovy44tKc1KLDzFK
	c7AoifMuy9yQKCSQnliSmp2aWpBaBJNl4uCUamAKD9j/2MP2aOgu/7hDoYt3G5yMvuB+8fqe
	levLNPYoRPY0lZxc89v38d/1AkYMt5253tccWh4e8JSl6rK8d8wvW7/7yXP17Vl6XstLW8XN
	/rVxwaNLW4okwj9F5h028fa5/L7R06aBweHqXKfnd806/3/+0aYi+L64KvJaymGn+OK/yycH
	ftlaoVkw5Vi56KRCkdBd8kEzlpbb3nJRTzl36Uje3TumiV9SmIxXLgv7ePJsqHeJnvqrXp0V
	t/Z882st6ZhSxb0yJm2jo9LJCr5o/uU1Hy36diiKs/v8iXyiVnK5N8xs8eXHK4K8ZIKbdxSv
	V7qb9/Dsan8TJwa9vINyJuEurx23XJxWnnhu81QlluKMREMt5qLiRADlqAwWywMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWS2cA0SZfbSjPJYM55Zou7jy+wWXQ962e2
	mD71AqPF6ptrGC32P33OYnFvzX9Wi32v9zJbrPzxh9Xi1oRjTA6cHov3vGTy2PRpErvH5BvL
	GT1ebJ7J6DF1dn0AaxSXTUpqTmZZapG+XQJXxqQjc9gLelgqnm26xtrA2MfcxcjJISFgIrHr
	wzWWLkYuDiGB1YwS7TdmMUM4HxglNn5/wwTh7GeUOPLwETtIC5uAgcTv4xvB2kUElCVO/7vK
	BlLELNDAInGh/wAjSEJYwFRidWczE0SRmcTdvlXsELaRxJLDn8GaWQRUJLY83ApWwwt0x9l9
	b8B6hQTqJb6uOcoKYnMK6Eh8WjYTrIZRQEzi+6k1YDazgLjErSfzmSB+EJBYsuc81D+iEi8f
	/2OFsBUl7n9/yQ5RryOxYPcnNgjbTuLqi2OsELa2xLKFr5khbhCUODnzCQtEr6TEwRU3WCYw
	SsxCsm4WklGzkIyahWTULCSjFjCyrmIULy0uzk2vKDbOSy3XK07MLS7NS9dLzs/dxAiM+dP/
	DsfsYLx366PeIUYmDsZDjBIczEoivE2hGklCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeT1iJ8YL
	CaQnlqRmp6YWpBbBZJk4OKUamOa7h13Ud1a8bSP4bKbBBYcFrqob1AvPF7DI57qEbJr/7Mmd
	xF9mz2Tdy/eW+bFv+mF7Pdf/qqG41I9trppTqxoKzf5se/jRdcVpoTDFny01/zPSS2d9lFVp
	m/pM//umfc4h00+HVyxM+/TyWc0bmZaKnOPuEyz90hUTXrQmd+aY+2wV2yLZwOF1asvF2+nm
	M4+tLdZf93T+a7ubcoe7dF/tSfUqUet1vvm3ZKXzpkK/Sdt2/o93fhCpy/m4ZJbJ7nSOt4fe
	Pim8nHI33SubOzXlquiTS63T/v8P3zNvSd7dwGN6W86GGk3WaQxmXeN3oru+bl/yh85fC8tm
	HWi79DZIc9p2HSlZw5KrKiq3lJRYijMSDbWYi4oTAfgBlWloAwAA
X-CMS-MailID: 20220309233643uscas1p1fb265ba484025640d71efce3fd19d134
CMS-TYPE: 301P
X-CMS-RootMailID: 20220307210800uscas1p2a47d31b290db7ffc27c341a780891987
References: <CGME20220307210800uscas1p2a47d31b290db7ffc27c341a780891987@uscas1p2.samsung.com>
	<YiZ0Jmhyf515EJzD@iweiny-desk3>

On Mon, Mar 07, 2022 at 01:07:50PM -0800, Ira Weiny wrote:
> Hello,
>=20
> I was curious if anyone attending LSF/mm would be interested in a CXL BOF=
?
>=20
> I'm still hoping to get an invite, but if I do I would be happy to organi=
ze
> some time to discuss the work being done.  It would be great to meet peop=
le
> face to face if possible too.

I would be interested in being a part of this discussion. Adding several
other folks on cc who I believe would be interested as well.

>=20
> Ira Weiny
> =
