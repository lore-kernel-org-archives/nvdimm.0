Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC7B2FAE
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1630585175; x=1662121175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sq++JZeY/qo5agypW88o+pEOPUMV/RYv+MDarFVf0Lc=;
  b=BL5XfwBPvx7k/Ux3XU0ffNDFlppw9wHC+tdRvOtNH7Kar044hXodRGAe
   +gqf0s/UVYq43uytMaW3glcNshTMWfPBjqoo6/R2MKDsmByCOSbRTYF6G
   GuCb3uML3jkmfJXFZOqpXtCeHGZRPY4ljo0rHgGc9Rg3WiBjW+SYR8dY8
   gxy4mu6nZ+EdLMJWIsiX3CwZErJWWCZf7tcB2gUani7iBsFfFZRzUWzib
   PIFzXaJqEzsrmz+wPOdKTPnvMmEB99kUvdEMl6xDWQgG+JqsXoXXlNMmj
   XFnh7ZiVTaAcj03gKFJMTz+RGIW0IbgcbozZ5xarKoL2tUz7HZg25/xO7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="38416153"
X-IronPort-AV: E=Sophos;i="5.84,372,1620658800"; 
   d="scan'208";a="38416153"
Received: from mail-ty1jpn01lp2058.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.58])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 21:19:31 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdnySWDtWfOX/LzZJPRid0M/oJntU8e7B/ilChc/czBj1MO4BUzMSdEWIyBPae/yrgPzl1q1ZMAwMb/83ovoYlRQAlZOlzTgRXi2sr3j3PRi8Pi5YFrD3PK0m/udctRuwu9QRsDFHgnOBL9aj2OIuEz/RCn9XdwXAhj5Fc3uR3NVGfCwMEnU1agPpC7jR1WuvjQW7QDq312mHxUnaTXUm6x/zC8tA7NSjm7Ntm8C76n+0s5kLtwDrLaOSw65Cer+Bvf1I5LsjZqXmCFflpM3rRgX8iVaRslQfQrJNqUiv2aJ2opsiAh6hrim1vNW8ahkudO0SBBmx57KItXhpcPgcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=V+s0NAwTvvA+bBuZaOYJzW6rbC/tRxg9GTBgiDbEb+s=;
 b=Ket45P0eJ+KxMuRQEh+qM4HAkhQyW8mLHsI3UWh9FC7KFhkS2df2U/NkaifwRAdTGdXOno4LJi+mFix/ZsyxpI9C47a0iaN5g31SgZlYiXIh6ekZ2Jw6IEXPWMd6vn/pFKsDGSQ2GYm5cTnw1C/IVLEDSb37nFb6xyc55Dgro0aGbx7dpdyQf9tJNLUtEHuxm4XJZGpJz3Q0mVAbuegYNY+w9zDsCI1CPUTQg1UVtJQz4O9iYajnsQyBW5eSRrp7I4d3HzaQXmXjYwatQW1Z7UxLsJotDBzADHA+XDlH9GIwkzdg7UmeGJUNmrk25PlEsah3/mYv+BTZafIRyix5qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+s0NAwTvvA+bBuZaOYJzW6rbC/tRxg9GTBgiDbEb+s=;
 b=I58Mlb28rO425l3JyFgK9TidVcN/VYrDvASuNXJVRS+E1918tx/qSFxG58iK2HlyIjhaRhSH1T/8hEgpTPeHIi48M51KVnn0eRfN+svXUCV1ag3C3TPzvg+Gf6GteBYYC/DHLGolLdYNuzRJlaPXovvzmdd4z4tO3T/VQWRSba0=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYAPR01MB6458.jpnprd01.prod.outlook.com (2603:1096:402:3b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Thu, 2 Sep
 2021 12:19:26 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8%9]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 12:19:26 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, "fenghua.hu@intel.com"
	<fenghua.hu@intel.com>
Subject: RE: [ndctl PATCH 4/7] daxctl: add basic config parsing support
Thread-Topic: [ndctl PATCH 4/7] daxctl: add basic config parsing support
Thread-Index: AQHXnkdRcLVqoPkmT0u2cuUKRpTznquQrMfQ
Date: Thu, 2 Sep 2021 12:19:26 +0000
Message-ID:
 <TYCPR01MB64618606F0F793BD325E19B6F7CE9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-5-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-5-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-09-02T12:18:42Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=62491317-9efa-4627-a47d-6b5ceb66a6b7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99ffe706-0ab2-47a9-a04d-08d96e0be7f0
x-ms-traffictypediagnostic: TYAPR01MB6458:
x-microsoft-antispam-prvs:
 <TYAPR01MB64587325EA8F8AA8B9B23B47F7CE9@TYAPR01MB6458.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 wJ1WN5udIBRC2nEispZkCUqrc2eiyVrVerhs3w4GTclNrnf1jmtqaoCKkgT+8igJDsrdygqqmxDQX42UNMPOS7OjUlu6diEpM9vkOwHZxjX6npW2qofnesXPaDdbDEQLuR9KVBtwCY5JMpmblgdIsw9zGypyLZ6v9x/vP2UI8KLI7GIPUA7meT7uK1pDSG2/6K5cvj77UO9w1jOyjhrZpEypq/hxFhGaW35eVYl0OYdbcmZ9YROxybtH+wRScFEjCf4Vd1cte8UrdzGnLMf5dn+hrmqRw52NlEWP+SQF+Pv+bJyqDIYwokOMJl7BZ0JWOgXKRjQm49rSNX581+YYEBXebOCE19A4riJGUFjjn4NTBs3NQ2k1nN2BZ+ygdOvyThn1WI/CSti1gfWQtwXDs4udKi2uEhcxj14BqRAinvzPQ3dwtmw8hQnPTrXqS/IBnkdJldlgJb5ETK7jHo8zHWybCQrAHZb9Yv/1gY4YOXJVYbiTnfKvf7lNoNR9da30IUUtHSzMtxPDoobKkIzVpIlWm+N1iWD7zXXTYmRSlXMOrgK0tks584YkJUIK1KA1cE3G+RkyL/fkRL5aSt2TTK5q6okSBRNmY8c4zE6ueuJOvJP6l6cxtb9qcLj7edJr+NoUyo2K2w8Yhlv1hDND2v46KcwNg0knj1Yspjl94h9f1RXBA/N3a5M45UsV2sBZmM28ccvKh2ki9ki8I6u2MA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(7696005)(8676002)(38070700005)(2906002)(52536014)(38100700002)(6506007)(86362001)(8936002)(4326008)(478600001)(122000001)(64756008)(66476007)(54906003)(66946007)(71200400001)(66556008)(5660300002)(66446008)(26005)(85182001)(186003)(76116006)(55016002)(9686003)(110136005)(33656002)(316002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?OGNYRFFyNXplQi9XRFFzVk9VUGlMTDloK0VWODJVZzhYT2ZvOE05K3RS?=
 =?iso-2022-jp?B?bE5NbUo1d1BwbGl4elE0L2xaZUhoSWlsSEdpNHppcENpbEhiTnYyejk0?=
 =?iso-2022-jp?B?MkRVdnhxa2prekR2S3pxcmk2bWcrV0J1aVl2OUxWNVpjYTRxRG9XM1p1?=
 =?iso-2022-jp?B?NnF0eXhhTGdtcUI0bWhOLy9VaTFNWWlxVHhDNEdGYjV1WjV6UTlrT0s5?=
 =?iso-2022-jp?B?VlpVcnVzTGQwemtSUDNRd1ExcXdRTTh4QnZrVCtUMXI1bC8vdW5HNEFy?=
 =?iso-2022-jp?B?amNJQUcvRHhUUWhSOEJScm9qUWMzUTFXY09CN24xT1Jiei9UWVBZZGtW?=
 =?iso-2022-jp?B?bm5tNWF3aVpLeWorcTdxSEdxcXNVbStJWExsd0trd0N3S0tPbFpWKzJ3?=
 =?iso-2022-jp?B?QlpXS3hmMkdwQXpoU1JtbUdOUjNSZHJDTURReVFUZDJFdndUZS9YaTE2?=
 =?iso-2022-jp?B?QytyeCtoeVpKVmFMekdqSFBlMWRNaWZhTmpZN2Y4cHdHb3pqcDV5RnZw?=
 =?iso-2022-jp?B?Y1pnUTkvcWdvN3FVNlNCMDR4OVhDNzgrVXIyYk56RkRoNVJ4a09wS09i?=
 =?iso-2022-jp?B?dUVvbmlBWmttT0FaNXVNaTRQZ3J1MU1OOTJvK1UxbitGRGRScm9HaXcy?=
 =?iso-2022-jp?B?aTlUdGZiaFJtU2NxckovNVBqeTFncGNBRDY3VUhXbWUweEhsU2xYc1BG?=
 =?iso-2022-jp?B?bEhaWlNnbzBTRC91UUR4a2lha1BLL1lTUHdvWFphdXRqMVpTVVBmak9V?=
 =?iso-2022-jp?B?cFd5bWNobFBNYjdRMzlnYyt0cG52cGFxYWRBdWRRa3pQT0xjSHVWV0JD?=
 =?iso-2022-jp?B?LzBIU0o4c1BqcXIwMW1Tems1cEJuRE5TUEVqUEo1b3pDOFlkTGJiaHVP?=
 =?iso-2022-jp?B?Ym91cmJFU0pxMW5OMy8wT1F4dVpnWmNhU25SYWc2b2QyMGZUQmhCcVJh?=
 =?iso-2022-jp?B?bXc2Y1FBaFNpQlkrWkpLYTliSjF1ci9lOTR1QkI1VDRrSHNZaDlvQVE4?=
 =?iso-2022-jp?B?TEVqcVF5bnAzUE1xWXk1WjE5V1dUcUhiSGg3blcrbUg0bzQ0TXpVR1c1?=
 =?iso-2022-jp?B?blYxaS9zMjVWWTFjMGJ5SGVZVUUrb3B1WFVXZ0p3cWNGaCtROVRmWFZF?=
 =?iso-2022-jp?B?Z2tpMkwzcmlueGlxZk5xR2xNVjV5YmlPbTl4TWRTaXU0ME1YS3NnS3R6?=
 =?iso-2022-jp?B?a1c0Zmx3RTJIUGtUSHhLRmNUWE5LUHlrWWZKVUFVdUpiVm85VGdvbWdG?=
 =?iso-2022-jp?B?a0swU3YyMEd0Qk1veGxWVURGSXAzcC9PUmR6WU13VmFZV0F0MWozbzlI?=
 =?iso-2022-jp?B?dkIvZHlWSmpxU1NocXpwWUN6YmZFVTlaTnAxNFNra2ZqMTI2NmFtdnZL?=
 =?iso-2022-jp?B?SGtqNW0yZXFyRXJWaXF6Z0VvVTdncFRUV0dxekRqd25aTUFZeUVXclZE?=
 =?iso-2022-jp?B?RHFNT0Erck1PeWRNWGRZNU05ZS9HT0c3dFVLOFdKWXpDNVBTYlZmWitt?=
 =?iso-2022-jp?B?V2hOU2UxQmVvL29yRkZSc3VpZ1FCQ21oS3lWWlN2TWppWW1xK2pPbE91?=
 =?iso-2022-jp?B?Vy9aUEJOZjdCTXhHcUp1aWR6V2NEVDAvVGc0cUFBOERSdFBGUFhFSFlI?=
 =?iso-2022-jp?B?UElmVUNFQlhVTk5WZnQ2YUd4MHM2eDJXdkI0Q0tRNXgxWWw0d2tMeFIy?=
 =?iso-2022-jp?B?M1BIVkY4eDVzQlZKQWgxZHJxYXZkN2plejByYTg5eElpL1dHYmhuYkdo?=
 =?iso-2022-jp?B?aW9PS0MxNG5FOCtZODNRTjhMVHlBY1phc3lHNWIzRENaRk9lTG9WR3lv?=
 =?iso-2022-jp?B?aERXRjExekViZTM1Y2tBYkIxcUNLVjBGNnU4K05UUmIrN3ljU3JIaWNl?=
 =?iso-2022-jp?B?ZGFXM2hLRGpyR3RDa3gxYzQ1dWo3VFdJSW1weWhSQkl6NmRaUDR4cG12?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6461.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ffe706-0ab2-47a9-a04d-08d96e0be7f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 12:19:26.3821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tubb8hNlrGH9iUBDI3uEXkYLsyTRhZITVAddk3xvwjgN0LCIhXqqFnQU9B5w2hxGA3bH+jfNQM835/r/iEpIDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6458

> Subject: [ndctl PATCH 4/7] daxctl: add basic config parsing support
>=20
> Add support similar to ndctl and libndctl for parsing config files. This =
allows
> storing a config file path/list in the daxctl_ctx, and adds APIs for sett=
ing and
> retrieving it.
>=20
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/lib/libdaxctl.c   | 37
> +++++++++++++++++++++++++++++++++++++
>  daxctl/libdaxctl.h       |  2 ++
>  daxctl/Makefile.am       |  1 +
>  daxctl/lib/Makefile.am   |  4 ++++
>  daxctl/lib/libdaxctl.sym |  2 ++
>  5 files changed, 46 insertions(+)
>=20
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c index 860bd9=
c..659d2fe
> 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -17,6 +17,8 @@
>  #include <util/log.h>
>  #include <util/sysfs.h>
>  #include <util/iomem.h>
> +#include <util/strbuf.h>
> +#include <util/parse-configs.h>
>  #include <daxctl/libdaxctl.h>
>  #include "libdaxctl-private.h"
>=20
> @@ -37,6 +39,7 @@ struct daxctl_ctx {
>  	struct log_ctx ctx;
>  	int refcount;
>  	void *userdata;
> +	const char *configs;
>  	int regions_init;
>  	struct list_head regions;
>  	struct kmod_ctx *kmod_ctx;
> @@ -68,6 +71,40 @@ DAXCTL_EXPORT void daxctl_set_userdata(struct
> daxctl_ctx *ctx, void *userdata)
>  	ctx->userdata =3D userdata;
>  }
>=20
> +DAXCTL_EXPORT void daxctl_set_configs(struct daxctl_ctx **ctx, char
> +*conf_dir) {
> +	struct dirent **namelist;
> +	struct strbuf value =3D STRBUF_INIT;
> +	int rc;
> +
> +	if ((!ctx) || (!conf_dir))
> +		return;
> +
> +	rc =3D scandir(conf_dir, &namelist, filter_conf_files, alphasort);
> +	if (rc =3D=3D -1) {
> +		perror("scandir");
> +		return;
> +	}
> +
> +	while (rc--) {
> +		if (value.len)
> +			strbuf_addstr(&value, " ");
> +		strbuf_addstr(&value, conf_dir);
> +		strbuf_addstr(&value, "/");
> +		strbuf_addstr(&value, namelist[rc]->d_name);
> +		free(namelist[rc]);
> +	}
> +	(*ctx)->configs =3D strbuf_detach(&value, NULL);
> +	free(namelist);
> +}
> +
> +DAXCTL_EXPORT const char *daxctl_get_configs(struct daxctl_ctx *ctx) {
> +	if (ctx =3D=3D NULL)
> +		return NULL;
> +	return ctx->configs;
> +}
> +
>  /**
>   * daxctl_new - instantiate a new library context
>   * @ctx: context to establish
> diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h index 683ae9c..9388f=
85 100644
> --- a/daxctl/libdaxctl.h
> +++ b/daxctl/libdaxctl.h
> @@ -28,6 +28,8 @@ int daxctl_get_log_priority(struct daxctl_ctx *ctx);  v=
oid
> daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority);  void
> daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata);  void
> *daxctl_get_userdata(struct daxctl_ctx *ctx);
> +void daxctl_set_configs(struct daxctl_ctx **ctx, char *conf_dir); const
> +char *daxctl_get_configs(struct daxctl_ctx *ctx);
>=20
>  struct daxctl_region;
>  struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx, int id, =
diff --git
> a/daxctl/Makefile.am b/daxctl/Makefile.am index 9b1313a..a9845a0 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -10,6 +10,7 @@ config.h: $(srcdir)/Makefile.am
>  		"$(daxctl_modprobe_datadir)/$(daxctl_modprobe_data)"' >>$@
> && \
>  	echo '#define DAXCTL_MODPROBE_INSTALL \
>  		"$(sysconfdir)/modprobe.d/$(daxctl_modprobe_data)"' >>$@
> +	$(AM_V_GEN) echo '#define DAXCTL_CONF_DIR  "$(ndctl_confdir)"'
> >>$@
>=20
>  daxctl_SOURCES =3D\
>  		daxctl.c \
> diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am index
> db2351e..7a53598 100644
> --- a/daxctl/lib/Makefile.am
> +++ b/daxctl/lib/Makefile.am
> @@ -13,6 +13,10 @@ libdaxctl_la_SOURCES =3D\
>  	../../util/iomem.h \
>  	../../util/sysfs.c \
>  	../../util/sysfs.h \
> +	../../util/strbuf.h \
> +	../../util/strbuf.c \
> +	../../util/wrapper.c \
> +	../../util/usage.c \
>  	../../util/log.c \
>  	../../util/log.h \
>  	../../util/parse-configs.h \
> diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym index
> a13e93d..190b605 100644
> --- a/daxctl/lib/libdaxctl.sym
> +++ b/daxctl/lib/libdaxctl.sym
> @@ -96,4 +96,6 @@ LIBDAXCTL_9 {
>  global:
>  	daxctl_dev_will_auto_online_memory;
>  	daxctl_dev_has_online_memory;
> +	daxctl_set_configs;
> +	daxctl_get_configs;
>  } LIBDAXCTL_8;
> --
> 2.31.1

Looks good to me.
Thank you very much.

QI
