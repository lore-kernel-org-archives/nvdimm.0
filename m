Received: from esa8.fujitsucc.c3s2.iphmx.com (esa8.fujitsucc.c3s2.iphmx.com [68.232.159.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD7F3FD3
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1630588444; x=1662124444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ieFk33LgtFNVkVfOayyMZHbXKPYxaGtp1teiIXL6kFY=;
  b=NaPCf5l863iKzHau1P9Otql7zsNU1tlDUryPnNJHNguBPjOtq2Q8COOG
   SXuUu5k8nC/gc9GL0TeHO+KGQCgKmYPtlq1iQXvrAo9ElYBgrT0iHDf1a
   eZHLbhtBjh8AVHQ5gwCqjxdfwgWg3rOy2CTyMU9+lIU5e6dBf/DGJSGun
   S8VhNJoVs5C50IfVO5eF9SBODMBXv0LIOw/rlYl5Dto99HBqUSrzyaFWg
   sZAclGWO4u/omnFKAmOE89M17+Y7gUrWAqJb5mojZEbLemyPtgigGTchh
   fJ2wPC7kCDh3kQqzO3jPpsxW+t3kh+04MVketBIr+7XsHP7TkdEU+EIn8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="38417608"
X-IronPort-AV: E=Sophos;i="5.84,372,1620658800"; 
   d="scan'208";a="38417608"
Received: from mail-os2jpn01lp2052.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.52])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 22:12:51 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxMFDpr1u85mlF0lZ2h6GUEqqmk6WJhIy1546JSC+9wgyJvvrz14ocXhaV5HIhFuHGtQ8hitNLGmb101+49FdzQ2gD6i2+fvsbVNejMrAe383JjupbEe4zGumN59viDgvUv+V54UIypV/5LIu0I/axej6/UXG98y5wFasH2y99X43VSWXAeIXWtlUJD+g1PlAcDPovbONotydyMyOI1dp1+Tum/MAJTVi9g8ZFuFZxuKgyRG4KPmzEflqVLFkvEOITHZFKYMW82q8HVhtVAQsuvBYgz+Ief17N9udmmfHP1ap3qG8o+Cx6M10VDHZSwZGR1p3ZvFliHluVhc/OhjGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJgM3PqeYNyIsjGIWvvZ3oUTpIN6eTPv2OjcNOIYcPc=;
 b=dFTBMgYiDhSuflhzQWSKzkLkJH31ESHRiaSlt3JBRQ4P6W9XO4HSF/DUusrYS3b1XGABfZoeqVHQ4XBdj2zgKnwBs230R65mdJ5haETiFKpvkeiq5RBQ/tOS+tUOAnNdp+t8XwLyk1aThwgB0tegEQ/F5fe8zHgic/HbxKMNY6LWNF/Syz6+S6g7a5ME1HsH64zDEfkeshOBu41BDuEH+Aj//GbV4jagNtmM/0lujxKMVltPLQ/+tBnfJ0Gj5voM9HEUqnDlbL5L2RyyRmACDR2jgizR31VQ8do0iaHJMfMLwBlHhCF1uBmxPJhwULDiV3gfTy1JK/P3u+b4Clh0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJgM3PqeYNyIsjGIWvvZ3oUTpIN6eTPv2OjcNOIYcPc=;
 b=U6qWqTmJXFfZ6EkoDIi8sL5R7LnXPZ1bwnNeqjLl5q47KPKmxHr9sdSdgKQhg1H5VoDOuAcvu4p543ZkXEspjD9gt23g0c/8zksqe51FEWwSyR5Uivc+WBEVAV9ia8zLYl1RHYGTd38W0GFN9T76MHs+JZwmF7g/U3WsKqHjUbE=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYXPR01MB1646.jpnprd01.prod.outlook.com (2603:1096:403:e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Thu, 2 Sep
 2021 13:12:48 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8%9]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 13:12:48 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, "fenghua.hu@intel.com"
	<fenghua.hu@intel.com>
Subject: RE: [ndctl PATCH 5/7] util/parse-configs: add a key/value search
 helper
Thread-Topic: [ndctl PATCH 5/7] util/parse-configs: add a key/value search
 helper
Thread-Index: AQHXnkdUad8oPYjbN0WhgtzgSaZH86uQu5jw
Date: Thu, 2 Sep 2021 13:12:48 +0000
Message-ID:
 <TYCPR01MB646185DDB581E60AC4945098F7CE9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-6-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-6-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-09-02T13:11:44Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=bec25d7a-0b67-417c-a689-5357de1c91fa;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eee7bd39-6ef0-4a4e-c3f3-08d96e135c95
x-ms-traffictypediagnostic: TYXPR01MB1646:
x-microsoft-antispam-prvs:
 <TYXPR01MB16469DE151B6729BE1B3AB25F7CE9@TYXPR01MB1646.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 AqL2SQYsQGaGZKXgecmSUenekmBALYN9t+vRYKTyQb4RIxfIHzevHt5sPWHNtNzYPDCy03IVepMTMS2ZS5elH3iwxkh+2EQ3pWsp9Av34SvTlq0PaIu0JFiAHUk0/b99N9NfTeG/IUBWv/ZfAXVQzVrQF4TSveFUHNlLbwOs/T6HhzkLl4oFd0OAviG/XXg5fykxofAmi0PE6F2b6Mz1MYDZhqbdp+XeF+DTQr0mhwXcrZ5uaZN8PaClsXpkJhknDQIokyEyASTH5qD4BnQN3db36geseDmZjNrLJPKuoAJ/hRtVt6sskfRqdTpvI03EFN0LHbpz2sUPWWQL+gv+uRWIYvAIwYF2WxC+M5o8aguKMmQW55iTT/6P4sllaMopYl5kYUJCCNBYzXiRlduWHHStpiTv205GGFO5UVVvqJt+93siqMIO5gvGStU9T1OOGyB8rYcnW21FwZy6YMUzAFfUHtQE1f/lnlhbtZzz+1uxu/6LV4l/s2ZziMJNLRFJPdzZOpmlGEqfQ/o4sniL/gLqxmuXU73TBnyN6bbHFh26X33wfKYlXeCKqi14kZHRMqQf3UTlCKGZWlYTHpEQ6qNLEEPWizSXGxJfI7g6/sLeY1NMAIuXBx2Jp/g42GOfvU1VaE2q2FfaWNOZPYRJkGNUEY7Q/Oo7FwaOvnbDP1FTggChW2kD5900FikQizzwonRRrwBdCmhkS9girk88ew==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(86362001)(55016002)(316002)(508600001)(54906003)(8936002)(85182001)(7696005)(52536014)(5660300002)(9686003)(4326008)(76116006)(122000001)(26005)(64756008)(38070700005)(66946007)(38100700002)(71200400001)(186003)(8676002)(66476007)(83380400001)(33656002)(66556008)(2906002)(66446008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?bjJKZHlUNVZXZ1VpU1AxQkdiOERDWkdybDczb0lRMm9RTk1lVkI1Slo0?=
 =?iso-2022-jp?B?MEEzcVVYdHNnSEJlTWc0Vy9BblR2QzRTUFlPbWtwUWFmL09NdFltM2hO?=
 =?iso-2022-jp?B?eTA2dituOHpMTmUrVC9ndERXeVAwTUFQL2FaSGRkSm52WTFkdFdUUmNZ?=
 =?iso-2022-jp?B?RE5GWDQ2bkpKd1h2Sk5NWjZRVUNsTnBtS0ZpMXpEeUZwUmF4bjdoaVFT?=
 =?iso-2022-jp?B?WjFKV3Bma3cvZDQwVmxGcmk4ZlJMTkoxWE0wR0plK3REc0EyZ1kwcGpq?=
 =?iso-2022-jp?B?MzBwYmkvcEduRG9DNy9SVWRqSy9zZ0xJTzE4V0orblpCclFVQUFmUlNw?=
 =?iso-2022-jp?B?czh1QUR4RG13Q3FMYURmenR2VDZ5STZ5S2J1OHRKRWlVaGJiTTZDajIz?=
 =?iso-2022-jp?B?VC9RQ0k4ditZaDlpRngvTHpzVGxRZlJGUWp4RzQ2VU11Q2x6MHF0djFT?=
 =?iso-2022-jp?B?NXBkd0JkZE9hTmVxWGpxRkNJMlhyeGpMWnFmRmZHYkNXUDQya3dYYkJi?=
 =?iso-2022-jp?B?SkhldnM5Nnd3MXoxNDNSa0FML0JqR1NLai9sbU0rM0lOaEJmcSt4TXdD?=
 =?iso-2022-jp?B?cGFuS2o4a2g3cGtpdWtLU3h5R3NMWkhFZVdacHY0eHluSnd1VkxBRHdy?=
 =?iso-2022-jp?B?Q0NXald2YkROS3piUS9vK0twcGVFclRMSTQvbGpSTVJvWU1lVi82Nk9q?=
 =?iso-2022-jp?B?aUFGN0tUaFlDV2VrbVlYdVJhTnU3dDY4YXRtQ3BQOVFBZEpQSUloaUVu?=
 =?iso-2022-jp?B?emRKMThwb3U3RmRhckgyV2VZVmJvQ3ZsV3ZsMHdHN0pENE8wM2xzdVpU?=
 =?iso-2022-jp?B?SVFvN2ttTS8zbXlsOGc3NTA3WjlTMWpnaWlZUis3Q2lwSkkrNUIvdWVw?=
 =?iso-2022-jp?B?azBXRGxKamVZWVl2cUJFekczcmpUM0RCSzdjeXhoamZNMFFMZzlubVdD?=
 =?iso-2022-jp?B?cFVzd2xMMEVZekpQRTZURExRcXNOU21MSU9iZEdGOUhRczJSalFKV3Bp?=
 =?iso-2022-jp?B?M2N5QURMVjFDUmVOWEl3MmxoVmNSVys3MlZHdEJwSnl5Ym9IaVlCQS9O?=
 =?iso-2022-jp?B?OWY4bTJNWVR4M3JNSjRwN1hhKzhMc3hISS9SWWYzTVljMUVIM0Y5MFFO?=
 =?iso-2022-jp?B?aEhIVGRYQ3hLNFVVTCtSMnlvK1BUN3Y1SkZpQ2F5cmlQdjhScU5zTSs0?=
 =?iso-2022-jp?B?Qm9GSEM0MjM3REJlY2hMV0JicnVwY2crandZN2NzaHJXT3dHdkpMeWtQ?=
 =?iso-2022-jp?B?UlZuaEE0YTRMb2MzSzRacHBtcFFuSWkxNVdZL2JZRlZma1lKZXRnd004?=
 =?iso-2022-jp?B?UUtvYUQ3MEZHZTN5QTBsY1BLdmRsOHEzMHdKQ1VIMXdSeVEwVGl1NHMw?=
 =?iso-2022-jp?B?Tk9Ud0IzSTIzYWtyY1FkNmV4T3I4ZWR1RUt3V2RNQVRTZklZS0lzb2E0?=
 =?iso-2022-jp?B?YUlUT1VuQXJBL3ZHUnNOSHNOV0NtUGxvaTZVcFQ1MGQ0a0lyTSt2clJa?=
 =?iso-2022-jp?B?VjRnK21nUnhSMDVZbWRwUWQ1YllXblBGZ2tyb3dGSlMzZlorMWc4ZHQ2?=
 =?iso-2022-jp?B?TVhMVG9CdlNrNjUwdXE5UnFoQUkzZXdEejJDL0dUZ3VTekgyeGJHSng4?=
 =?iso-2022-jp?B?WGRrWS82dzg2K3NUeVhTbERvMHZiUm8xMERWak1NdUg5VzhibUJIR3hu?=
 =?iso-2022-jp?B?KzgvczQ0Zmllbm4xbkt6djRvMHNZZnl0eVd3WDExYzMxc2tmZVF3eEU1?=
 =?iso-2022-jp?B?aFVwWFE3aG1NMWwwTHlQTUtEVkh6ZUhaYWRFQy9pNlBvWU8rNGlSWE9n?=
 =?iso-2022-jp?B?UUhmU2FwNWJObnZDNjI4L203TWgwS2pQci9waWtZRXVYQ2VKWDdzbHpY?=
 =?iso-2022-jp?B?Q3R4VTFMZW0zelBVaUg3UDcwZnVkUllsQXFudWdxb3h4WC9QY0VDc1F2?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eee7bd39-6ef0-4a4e-c3f3-08d96e135c95
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 13:12:48.5422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+B3imY8tLThIMt4ShKsXHV5xAgNVOC6nobp7yoP3uLqekbZTFN2Top8E7q3B+satwxyiAUKy/Rz1Gy53WZf1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYXPR01MB1646

> Subject: [ndctl PATCH 5/7] util/parse-configs: add a key/value search hel=
per
>=20
> Add a new config query type called CONFIG_SEARCH_SECTION, which searches
> all loaded config files based on a query criteria of: specified section n=
ame,
> specified key/value pair within that section, and can return other key/va=
lues from
> the section that matched the search criteria.
>=20
> This allows for multiple named subsections, where a subsection name is of=
 the
> type: '[section subsection]'.
>=20
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  util/parse-configs.h | 15 +++++++++++++  util/parse-configs.c | 51
> ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
>=20
> diff --git a/util/parse-configs.h b/util/parse-configs.h index 491aebb..6=
dcc01c
> 100644
> --- a/util/parse-configs.h
> +++ b/util/parse-configs.h
> @@ -9,6 +9,7 @@
>=20
>  enum parse_conf_type {
>  	CONFIG_STRING,
> +	CONFIG_SEARCH_SECTION,
>  	CONFIG_END,
>  	MONITOR_CALLBACK,
>  };
> @@ -20,6 +21,10 @@ typedef int parse_conf_cb(const struct config *, const=
 char
> *config_file);
>=20
>  struct config {
>  	enum parse_conf_type type;
> +	const char *section;
> +	const char *search_key;
> +	const char *search_val;
> +	const char *get_key;
>  	const char *key;
>  	void *value;
>  	void *defval;
> @@ -31,6 +36,16 @@ struct config {
>  #define CONF_END() { .type =3D CONFIG_END }  #define CONF_STR(k,v,d) \
>  	{ .type =3D CONFIG_STRING, .key =3D (k), .value =3D check_vtype(v, cons=
t char
> **), .defval =3D (d) }
> +#define CONF_SEARCH(s, sk, sv, gk, v, d)	\
> +{						\
> +	.type =3D CONFIG_SEARCH_SECTION,		\
> +	.section =3D (s),				\
> +	.search_key =3D (sk),			\
> +	.search_val =3D (sv),			\
> +	.get_key =3D (gk),			\
> +	.value =3D check_vtype(v, const char **),	\
> +	.defval =3D (d)				\
> +}
>  #define CONF_MONITOR(k,f) \
>  	{ .type =3D MONITOR_CALLBACK, .key =3D (k), .callback =3D (f)}
>=20
> diff --git a/util/parse-configs.c b/util/parse-configs.c index 72c4913..8=
eabe3d
> 100644
> --- a/util/parse-configs.c
> +++ b/util/parse-configs.c
> @@ -38,6 +38,54 @@ static void set_str_val(const char **value, const char=
 *val)
>  	*value =3D strbuf_detach(&buf, NULL);
>  }
>=20
> +static const char *search_section_kv(dictionary *d, const struct config
> +*c) {
> +	int i;
> +
> +	for (i =3D 0; i < iniparser_getnsec(d); i++) {
> +		const char *cur_sec_full =3D iniparser_getsecname(d, i);
> +		char *cur_sec =3D strdup(cur_sec_full);
> +		const char *search_val, *ret_val;
> +		const char *delim =3D " \t\n\r";
> +		char *save, *cur, *query;
> +
> +		if (!cur_sec)
> +			return NULL;
> +		if (!c->section || !c->search_key || !c->search_val
> || !c->get_key) {
> +			fprintf(stderr, "warning: malformed config query,
> skipping\n");
> +			return NULL;
> +		}
> +
> +		cur =3D strtok_r(cur_sec, delim, &save);
> +		if ((cur =3D=3D NULL) || (strcmp(cur, c->section) !=3D 0))
> +			goto out_sec;
> +
> +		if (asprintf(&query, "%s:%s", cur_sec_full, c->search_key) < 0)
> +			goto out_sec;
> +		search_val =3D iniparser_getstring(d, query, NULL);
> +		if (!search_val)
> +			goto out_query;
> +		if (strcmp(search_val, c->search_val) !=3D 0)
> +			goto out_query;
> +
> +		/* we're now in a matching section */
> +		free(query);
> +		if (asprintf(&query, "%s:%s", cur_sec_full, c->get_key) < 0)
> +			goto out_sec;
> +		ret_val =3D iniparser_getstring(d, query, NULL);
> +		free(query);
> +		free(cur_sec);
> +		return ret_val;
> +
> +out_query:
> +		free(query);
> +out_sec:
> +		free(cur_sec);
> +	}
> +
> +	return NULL;
> +}
> +
>  static int parse_config_file(const char *config_file,
>  			const struct config *configs)
>  {
> @@ -54,6 +102,9 @@ static int parse_config_file(const char *config_file,
>  					iniparser_getstring(dic,
>  					configs->key, configs->defval));
>  			break;
> +		case CONFIG_SEARCH_SECTION:
> +			set_str_val((const char **)configs->value,
> +					search_section_kv(dic, configs));
>  		case MONITOR_CALLBACK:
>  		case CONFIG_END:
>  			break;
> --
> 2.31.1

Thank you very much.
This looks good to me.

QI

