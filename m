Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A3261C8
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 20:54:19 +0000 (UTC)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20230605204544usoutp01512aca7cd99ccab652b6616998fe19c7~l3jKYeNgz0716607166usoutp01f;
	Mon,  5 Jun 2023 20:45:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20230605204544usoutp01512aca7cd99ccab652b6616998fe19c7~l3jKYeNgz0716607166usoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1685997944;
	bh=8fwyt5sdvkgpbX/KDX0BPiD3sC2x3LEM8rmegEnX7Z8=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=sr9viXp8LylmZ8VomphcrYanfliK6AKuxO97sCZPr33V9EXu+X/k1jLBYn+Su6GQ9
	 gSOJPmhhTnD9X+hQKwFM2f2sVAcuo1PDyfNW0t4a6q8Ot3DXwcmTCMVXi1P0caGAHW
	 OeJvF5j35Fc6k2Dfde9yLMeyh8/QnOCuyfKw0ctg=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230605204544uscas1p2afbdc014ce73cc0ec53e85d07693fc9a~l3jKN-BKG2163921639uscas1p2v;
	Mon,  5 Jun 2023 20:45:44 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id DB.94.62237.8794E746; Mon, 
	5 Jun 2023 16:45:44 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20230605204543uscas1p19d1b3a00134805c5c3e738dea4ee4728~l3jJ5l8D42077320773uscas1p13;
	Mon,  5 Jun 2023 20:45:43 +0000 (GMT)
X-AuditID: cbfec370-823ff7000001f31d-26-647e4978ea1c
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 56.8C.64580.7794E746; Mon, 
	5 Jun 2023 16:45:43 -0400 (EDT)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Mon, 5 Jun 2023 13:45:43 -0700
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Mon,
	5 Jun 2023 13:45:43 -0700
From: Fan Ni <fan.ni@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, Adam Manzanares
	<a.manzanares@samsung.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nmtadam.samsung@gmail.com" <nmtadam.samsung@gmail.com>, "nifan@outlook.com"
	<nifan@outlook.com>
Subject: Re: [PATCH 1/4] dax: Fix dax_mapping_release() use after free
Thread-Topic: [PATCH 1/4] dax: Fix dax_mapping_release() use after free
Thread-Index: AQHZl+6y6TFi408Er0usyJDFtX2K7g==
Date: Mon, 5 Jun 2023 20:45:43 +0000
Message-ID: <20230605204535.GA2344865@bgt-140510-bm03>
In-Reply-To: <168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4D9A649F9B0C674486759D78CF16B203@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsWy7djXc7oVnnUpBms72S2mT73AaLH65hpG
	i/OzTrFYPJ/4nMli6ZJHzBYrf/xhdWDz2DnrLrvH4j0vmTxebJ7J6LH59Qtmj6mz6z0+b5IL
	YIvisklJzcksSy3St0vgyniyy6GgWbji5p6JjA2MN/m7GDk5JARMJDb0bGXpYuTiEBJYySjx
	oPcrE4TTyiTxpWcqO0xVS+sOqMRaRoklXy9BOR8ZJU4172QFqRISWMoosWiTD4jNJqAosa9r
	OxuILSKgLTFxzkFmkAZmgbVMEvN2XmUCSQgLuEks/dfGCFHkLtHS3cQOYetJTOneDVTDwcEi
	oCLxtk8GJMwrYCbxffI9ZhCbUyBC4sCddWCtjAJiEt9PrQEbySwgLnHryXwmiKsFJRbN3sMM
	YYtJ/Nv1kA3CVpS4//0lO0S9jsSC3Z/YIGw7iXMdl6BsbYllC18zQ+wVlDg58wkLRK+kxMEV
	N8DhJSFwhUOirX0CNIhcJE7sOQC1WFpi+prLLCD3SwgkS6z6yAURzpGYv2QL1BxriYV/1jNN
	YFSZheTsWUhOmoXkpFlITpqF5KQFjKyrGMVLi4tz01OLjfNSy/WKE3OLS/PS9ZLzczcxAlPT
	6X+HC3Yw3rr1Ue8QIxMH4yFGCQ5mJRHeXV7VKUK8KYmVValF+fFFpTmpxYcYpTlYlMR5DW1P
	JgsJpCeWpGanphakFsFkmTg4pRqYNiYWXrH2a5pc9Gebj1a122+rFMNqG4dltfMZWlRtzab+
	uNN79ZbU210FDt+0F+QHO5fHRgkXXDb468MxR3BleLOOo7jnzAqlyZHOqf+M40TjEnZ98fZ8
	P0Pz9OKSkIy8F+dnz7nNGCcbd3f1mdDvFvfE/2hHnfcXf3Zni9jUiJ2P3a5/vNSbY7Dnz4JP
	XL7SF3ZdffRBu+dWzK+915e8el3J/+Tdom8nb4k/OjJPr8t4xtGIsuQXXctt5u86KfFcT+ji
	YckP4RyZ++xeyf3vmqAT+/rWvYuzWyKkXs0tPP/oTerERrdbTxz+zDFzK2fyrj4UszdwW4u5
	Ne9EIe51bau/r7iWZrc15HtxtGrtOiWW4oxEQy3mouJEAN8J91O8AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWS2cA0Sbfcsy7F4Pg2PYvpUy8wWqy+uYbR
	4vysUywWzyc+Z7JYuuQRs8XKH39YHdg8ds66y+6xeM9LJo8Xm2cyemx+/YLZY+rseo/Pm+QC
	2KK4bFJSczLLUov07RK4Mp7scihoFq64uWciYwPjTf4uRk4OCQETiZbWHUxdjFwcQgKrGSUu
	7dvECuF8ZJSYOL8HKrOUUWLxkT8sIC1sAooS+7q2s4HYIgLaEhPnHGQGKWIWWMskMW/nVSaQ
	hLCAm8TSf22MEEXuEi3dTewQtp7ElO7dQDUcHCwCKhJv+2RAwrwCZhLfJ99jhlv2s30K2BxO
	gQiJA3fWgc1hFBCT+H5qDVicWUBc4taT+UwQPwhILNlznhnCFpV4+fgfK4StKHH/+0t2iHod
	iQW7P7FB2HYS5zouQdnaEssWvmaGOEJQ4uTMJywQvZISB1fcYJnAKDELybpZSEbNQjJqFpJR
	s5CMWsDIuopRvLS4ODe9otg4L7Vcrzgxt7g0L10vOT93EyMwtk//Oxyzg/HerY96hxiZOBgP
	MUpwMCuJ8O7yqk4R4k1JrKxKLcqPLyrNSS0+xCjNwaIkzusROzFeSCA9sSQ1OzW1ILUIJsvE
	wSnVwDQlbtPmyI/yCr61rIJ3Tqt8vL5t+dnqRoP6FIkcn1fl2q3sO+ZG6+T/W3CH75ZQiaHw
	os9rfsmf8AjQ0JIvejk3qpz7XdZ5Dh3dYP+NT7qmJNdv3fq75cqZewL6vdfr3qbtrH5y/V/q
	QaEDa64HvDki4zLT4N3St3VJf8KO7ZgVcErMJbBROzX8nP5rgR6BI7pTA/jslifcu6MQK3f9
	rp+f8uW6VWc5hTYt9mzIb27ye+pw8rBb3iU/lpqurvVdZgWfdzUxbgsMfPVk1ZU6tj16ivf3
	6p22OHYtZ3sM86aP348esFWwup2g/bRZZO7f6QKLH86b9uDc3vkV6+Y5Hg85u8AmhSGy1aWh
	PnP1Rl4lluKMREMt5qLiRAAOmN/sXAMAAA==
X-CMS-MailID: 20230605204543uscas1p19d1b3a00134805c5c3e738dea4ee4728
CMS-TYPE: 301P
X-CMS-RootMailID: 20230605204543uscas1p19d1b3a00134805c5c3e738dea4ee4728
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
	<168577283412.1672036.16111545266174261446.stgit@dwillia2-xfh.jf.intel.com>
	<CGME20230605204543uscas1p19d1b3a00134805c5c3e738dea4ee4728@uscas1p1.samsung.com>

On Fri, Jun 02, 2023 at 11:13:54PM -0700, Dan Williams wrote:
> A CONFIG_DEBUG_KOBJECT_RELEASE test of removing a device-dax region
> provider (like modprobe -r dax_hmem) yields:
>=20
>  kobject: 'mapping0' (ffff93eb460e8800): kobject_release, parent 00000000=
00000000 (delayed 2000)
>  [..]
>  DEBUG_LOCKS_WARN_ON(1)
>  WARNING: CPU: 23 PID: 282 at kernel/locking/lockdep.c:232 __lock_acquire=
+0x9fc/0x2260
>  [..]
>  RIP: 0010:__lock_acquire+0x9fc/0x2260
>  [..]
>  Call Trace:
>   <TASK>
>  [..]
>   lock_acquire+0xd4/0x2c0
>   ? ida_free+0x62/0x130
>   _raw_spin_lock_irqsave+0x47/0x70
>   ? ida_free+0x62/0x130
>   ida_free+0x62/0x130
>   dax_mapping_release+0x1f/0x30
>   device_release+0x36/0x90
>   kobject_delayed_cleanup+0x46/0x150
>=20
> Due to attempting ida_free() on an ida object that has already been
> freed. Devices typically only hold a reference on their parent while
> registered. If a child needs a parent object to complete its release it
> needs to hold a reference that it drops from its release callback.
> Arrange for a dax_mapping to pin its parent dev_dax instance until
> dax_mapping_release().
>=20
> Fixes: 0b07ce872a9e ("device-dax: introduce 'mapping' devices")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Reviewed-by: Fan Ni <fan.ni@samsung.com>

>  drivers/dax/bus.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 227800053309..aee695f86b44 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -635,10 +635,12 @@ EXPORT_SYMBOL_GPL(alloc_dax_region);
>  static void dax_mapping_release(struct device *dev)
>  {
>  	struct dax_mapping *mapping =3D to_dax_mapping(dev);
> -	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
> +	struct device *parent =3D dev->parent;
> +	struct dev_dax *dev_dax =3D to_dev_dax(parent);
> =20
>  	ida_free(&dev_dax->ida, mapping->id);
>  	kfree(mapping);
> +	put_device(parent);
>  }
> =20
>  static void unregister_dax_mapping(void *data)
> @@ -778,6 +780,7 @@ static int devm_register_dax_mapping(struct dev_dax *=
dev_dax, int range_id)
>  	dev =3D &mapping->dev;
>  	device_initialize(dev);
>  	dev->parent =3D &dev_dax->dev;
> +	get_device(dev->parent);
>  	dev->type =3D &dax_mapping_type;
>  	dev_set_name(dev, "mapping%d", mapping->id);
>  	rc =3D device_add(dev);
>=20
> =
