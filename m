Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C022FAE
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1630585121; x=1662121121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JFK3k8vP5je1JU+6LkHn615nYBs8Uum1LAwm3bpxvHQ=;
  b=XxpmRDHsP5h5ieC4LIVcj8aI9qNf1izD3vqIX5RnBq8cDQQo571X4l4V
   Ifxh5BpLVD2Rs4ivEChdK42fHUZwyI4ozZvNdpuU5gQEWuVJy+/nQ5TNV
   tpeBwbr0ldwKbkuyHCxXaHh7gPy/GLOhZdk0kWB+O3m6WKkw0b7sTGakL
   jnAsLF51GtPsVDq6Sue/ryz2AmW27VU3gFknv41Eu4IlU/3bEL7zIdTxP
   Xm0QRdjRy8w9VggTI+3BYCBEOg9+VG5D5ZVKODJUsgx+YPoyc9HEM85en
   1KFvKfemCo1WRgTLW5QebT4H0q14JGdx+WTaePD6Io3EPrva8W1j2GLMN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="38416064"
X-IronPort-AV: E=Sophos;i="5.84,372,1620658800"; 
   d="scan'208";a="38416064"
Received: from mail-ty1jpn01lp2053.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.53])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 21:17:29 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEcbcIS6ZcCkq+dP/3WKTRId8YSuhtTFy4uVp4p7GS68ULhhGRIl83za/Ccof8pYR3f/3aDGsb/09N6h6UJ1qORg6LbwZgUKdMqFHL5MVHS+9wqvuffFocfTBgokYmOecwT0nXe+NmjmdZC/+MCI5s6lxl8BNIhiqKeMAMDiO+C0jETW7c9gwpFJfE6yuWFBvmWrOJU5p724rrCwhHQv02/zRydD3wBYAaqhpgnUS6TGABSSN+5uO76Bi4RroJ5/0QtmFMNu33gG9xB8TvAQ8AoYBui6npshNrvlO51xjsRByhmYwq0ABCZBPtzCKZj3MHtw+ZVbSEBf/a6OP1Jgrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8ajjASA09/+GA+Z5ndC+7Idfzoa3MFSnQaeMdxqtqw=;
 b=jrxBp6XaIpEK11k3AJXT1WvCejGei6LHMbIZXQ8TEcrVkBZizvOwI7Nvo15/kyXE6hxDI5D1FBavKo2BhtW3RovNmsFy/PRxIqT1YHrFI9c9hzLNk0uRt3BCURg99/LqwtnrIzap6JSrczS7yDJ7hIQeVXtSDoHjAN3yt5nbQXXZM6QV0FR5oeYbXfUvRCPqJVv/FTXUgKEJYt0VCTq9Zy6nGsjitnjCP8Ui/dO5R3qTCSMjK+6RBi/76I00eHqEpSCNUJEmquxykILoiOdq96cf6wvVxLs/jYbo30UrN3dM6UE/VCy2o2Fcz1Zhd3rpKEkgho2gIs8k7j5v77f41w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8ajjASA09/+GA+Z5ndC+7Idfzoa3MFSnQaeMdxqtqw=;
 b=WwmFyaLp60jmntIgf/tEYn0Md9YCXbzz+xHwGtNn82inmG8H3xENU204V2YSyjBIvWFvzyktue6uARa3yrD9Cd4sg5Cmuu0EqpyFdj3XWrv6OAAEKulxV20iwXootVx35Ih9T08/+O7xBsgP54tos1qgVDGH087+ftiSfFwEQ/E=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYXPR01MB1648.jpnprd01.prod.outlook.com (2603:1096:403:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Thu, 2 Sep
 2021 12:17:25 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8%9]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 12:17:25 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, "fenghua.hu@intel.com"
	<fenghua.hu@intel.com>
Subject: RE: [ndctl PATCH 3/7] util/parse-config: refactor filter_conf_files
 into util/
Thread-Topic: [ndctl PATCH 3/7] util/parse-config: refactor filter_conf_files
 into util/
Thread-Index: AQHXnkdRgNMQb0fZy0+e0+Gp05ZjC6uQrECQ
Date: Thu, 2 Sep 2021 12:17:25 +0000
Message-ID:
 <TYCPR01MB6461717B39B9FDEDE9EFE55AF7CE9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-4-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-4-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-09-02T12:16:49Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=fe520678-9e89-4543-bd2b-9d7b95d2d648;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 780ed7c6-d4f7-40b5-e401-08d96e0ba019
x-ms-traffictypediagnostic: TYXPR01MB1648:
x-microsoft-antispam-prvs:
 <TYXPR01MB1648BF4C2EA4DBAFE19F60F5F7CE9@TYXPR01MB1648.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 5sSU9gXEZ9NIEU+e199vxUbWTI4Ft08sHC8/E/Xg+YndTEEW60urklBr3v2AV1oFK83f31X6qLkhUmuZ4Bg+eFZHuzpl6QAbWyGDbxZT2gpbkeyTW7FF5jrMsdeBnN1ksZxJgP27LZYSRLTp9FpKwkCmxbeYsxR1jCgkXXm6KZ5OFA+kjR4TlGe6nPa4ALbmn+anAeSkBMBwVx9dYzsP8qrkEuvKiJnmr/v3ZUO/PY/kOZFjs1UPB7wfpqBM/KKPpiGRPPsQtJnOqeG7ISZIxsSN/k2voAJJo9+jk//LKSulEOV5XkK1J5CdrrtuU0JGWPDx83RkMDcHPI3J+TceyvmznSNuT12BCb5Ogs9gftS+6tj0vR6avgcvTZWY8xf5RpvFtwMFCJrC+7Mes1FieqmXVkuIvD87OnGttC4rkbLmhqqR4tbH6+VdBd+hQxg3mD/027KhEHffwdsc6AHjGh6tz9+GZGcsdzVi3096TSx7s9/y+FtLna1MxnjPDupOmGnOKs5bZdgpbFttYUdl1yssnWv/y821Ga1iemOAVWLV9qOksMep8OiugGYRII483//3HAwI8jDOU1J1XEsXsIevHN80u3v9cXQSqYdURMBZWupCsgJMkvskgDQNdPG3arlXo3xjjMVL0wuXRqVvpy7p5WhvmVFo6XVju9aHMvjjXkcP9cJuQR6FEiTtRd8QWJ/rcdBiK9s5RPmZQv09aw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(5660300002)(38100700002)(4326008)(38070700005)(76116006)(8936002)(9686003)(64756008)(122000001)(55016002)(86362001)(7696005)(478600001)(33656002)(2906002)(110136005)(66946007)(71200400001)(6506007)(83380400001)(8676002)(52536014)(66446008)(316002)(186003)(54906003)(85182001)(66556008)(66476007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?WEg2Z092U2o5TEIzNUJrMGh5ajN2dTc2K0dUL1AyT0pDODdRb01IbXhT?=
 =?iso-2022-jp?B?ZENYeVdFdmNUMHVPTjVzMW9LR0JwT0l4ZkU0TDlRRVZqM1p2ZmdTQ3NS?=
 =?iso-2022-jp?B?TjBWWTZaU0NSS05mWi9Xa0ViTVQ2VEc5Rll1NUkwQnl3Z1ZnVTFZUDFX?=
 =?iso-2022-jp?B?N2hNK2ZjbnNyZEpXME9zMlEzVmM1RXlXNHBxQ2V1aXEyL0N6akJwTXJU?=
 =?iso-2022-jp?B?RXh6UHBFNFdJL2VnNnpJVUUxdzVFanBPcnJoSVQrcEZCR3lWc2pCOHgr?=
 =?iso-2022-jp?B?UFk1MEZSYU5DeGRYK2xzUDZieVBJbVNWZWV4c09tYStDdm5YOElpT2Jr?=
 =?iso-2022-jp?B?NGw1SHUxWld5aGJtNlZ3YkFlL1hsYW04aVFvcThGSHRGbVVqeFVpQjFa?=
 =?iso-2022-jp?B?bkE4R0ExMnBnN05sQWpRRUVzNHE2akpqS29zVW1Yb25kcjNtNmhRU1Jx?=
 =?iso-2022-jp?B?cGs4eUllZlIyNGkrTGNTeVNMcUNNTGdBZitDaWZVQWd4WFNPQUhsdVh1?=
 =?iso-2022-jp?B?aU5SdGd1MDFyNHU1OUlHWlZscVhVS3FJM2htczJrdUlUaDFnOVFBWksr?=
 =?iso-2022-jp?B?Qkt3aEsxWHczd283SkJGYVppMDlvSGJRRzJZVEFmQW9xWGVZQzZWaUxM?=
 =?iso-2022-jp?B?WnhCWk5OT0haT0tZWXl6eGJVVlR5VHg3RW1zUVp6YlpqU09FYVVQd1dj?=
 =?iso-2022-jp?B?RTBpZ2QwOWpPWGVMeG1XWEpidE5vRzlwOHlBenp4RmJsYUNvSnZTWVpY?=
 =?iso-2022-jp?B?a01YMFFvcmFBZnhVMnN6VkRYS2RmUUNPbW9ycWNjeWRxSWhmSTdWWCtx?=
 =?iso-2022-jp?B?ZGJDbnNJZUdoODJFN094VXBvNnJzUTd6UnR5eUFtaldackxkelVZREFQ?=
 =?iso-2022-jp?B?cTIxSW5zZnROM1JBUzJEcE04blVGdG5uNU1wVVdrUE1vdFNkTTFQSXNj?=
 =?iso-2022-jp?B?OTBHSE5PcEpmRGpkNWFDSUhtLzdMQ0U4ZDRhdDB4NTNVTjVOZUhYd0Fy?=
 =?iso-2022-jp?B?K3dQM0lOTjh1UVhIQjh3QzJDcEdMWnk5RGhKaStEeTU4ZWt4alV0bmhn?=
 =?iso-2022-jp?B?SnhqUjkxbm1wVVZNK2IvZi9DRzdvYkpsWlIwVUNOMk9ERjdQWkwrYm8x?=
 =?iso-2022-jp?B?UHdiTS9oV0hSbVFqVStHRHphNzlhaHBqdnBVaUY5WDkySWIycUZ6RjFD?=
 =?iso-2022-jp?B?bDhuemVuZThxQThYY2FWb3BqR3JjMTUwb2p6V3lNUVp6KzdJQjQ1VUZy?=
 =?iso-2022-jp?B?RFAzYkJZeE95MEEwSlU0bXhUbEZVQnpuWSt2blhFdGFNeE9CaS9RWDVY?=
 =?iso-2022-jp?B?elpVdkFzd3lrOXA5aUM1SFNHaHBObkgzcEdDeDlHeFZtVUcrMUNpT2tX?=
 =?iso-2022-jp?B?Z0xoRUxWdk9iQTNZTGJtUE5ZS1JSV3hONDYzeTV4bUxZeElaTlhQVm4x?=
 =?iso-2022-jp?B?RnRHQXRJcXNRd3JkbVQ5RzZwTkY0ZCtHNmZSU0tBMDR0VzZzMFdZaG5k?=
 =?iso-2022-jp?B?eWpBQkM5amF2RVczR2o5dzBiMFZNRkJuRzZVMkwvTkF3OXNHMU1KdExn?=
 =?iso-2022-jp?B?cmlRK3pkS2kyMi81TGlKY0ZiWllIMzM3WU5KNGNlcEIzVytuMnBGYWlR?=
 =?iso-2022-jp?B?d1NSWkRPdFdueEc2aFlDbGtienpUWWp3ZmxqakFuWXVXWkI1WUJyOXNi?=
 =?iso-2022-jp?B?NHFrOGVhOWt6NjNRK3EyaHVwaHhtblg5QTlaeWluQ3VtR0wxWG1DUnRp?=
 =?iso-2022-jp?B?bUNkZUZzWldGWURkR2pRekg0dFFNdjE1dURIVHoyOTRNTUxhN1BROUQx?=
 =?iso-2022-jp?B?UHUzekRMTVZXejhzT2VmYy9ZUTZSek1BejJZWUJkeG5QTXo0bzJkZWE4?=
 =?iso-2022-jp?B?b05CMW9JUy9BNzkwY1dkTTk1ZUNPN3M0U3F1U2J2bzZRbG9kUXZXWC9I?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 780ed7c6-d4f7-40b5-e401-08d96e0ba019
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 12:17:25.9004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zq9zc+vuzJiazsnG7HCJpewhCjanjwJiq9wnYJcuyQdxJ9tvF1be9QgElbKGDCVGy+fFLUgU3iMJdWehmThdbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYXPR01MB1648

> Subject: [ndctl PATCH 3/7] util/parse-config: refactor filter_conf_files =
into util/
>=20
> Move filter_conf() into util/parse-configs.c as filter_conf_files() so th=
at it can be
> reused by the config parser in daxctl.
>=20
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/libndctl.c   | 19 ++-----------------
>  util/parse-configs.h   |  4 ++++
>  util/parse-configs.c   | 16 ++++++++++++++++
>  daxctl/lib/Makefile.am |  2 ++
>  ndctl/lib/Makefile.am  |  2 ++
>  5 files changed, 26 insertions(+), 17 deletions(-)
>=20
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c index db2e38b..a=
01ac80
> 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -25,6 +25,7 @@
>  #include <util/size.h>
>  #include <util/sysfs.h>
>  #include <util/strbuf.h>
> +#include <util/parse-configs.h>
>  #include <ndctl/libndctl.h>
>  #include <ndctl/namespace.h>
>  #include <daxctl/libdaxctl.h>
> @@ -266,22 +267,6 @@ NDCTL_EXPORT void ndctl_set_userdata(struct
> ndctl_ctx *ctx, void *userdata)
>  	ctx->userdata =3D userdata;
>  }
>=20
> -static int filter_conf(const struct dirent *dir) -{
> -	if (!dir)
> -		return 0;
> -
> -	if (dir->d_type =3D=3D DT_REG) {
> -		const char *ext =3D strrchr(dir->d_name, '.');
> -		if ((!ext) || (ext =3D=3D dir->d_name))
> -			return 0;
> -		if (strcmp(ext, ".conf") =3D=3D 0)
> -			return 1;
> -	}
> -
> -	return 0;
> -}
> -
>  NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx **ctx, char *conf_d=
ir)
> {
>  	struct dirent **namelist;
> @@ -291,7 +276,7 @@ NDCTL_EXPORT void ndctl_set_configs(struct ndctl_ctx
> **ctx, char *conf_dir)
>  	if ((!ctx) || (!conf_dir))
>  		return;
>=20
> -	rc =3D scandir(conf_dir, &namelist, filter_conf, alphasort);
> +	rc =3D scandir(conf_dir, &namelist, filter_conf_files, alphasort);
>  	if (rc =3D=3D -1) {
>  		perror("scandir");
>  		return;
> diff --git a/util/parse-configs.h b/util/parse-configs.h index f70f58f..4=
91aebb
> 100644
> --- a/util/parse-configs.h
> +++ b/util/parse-configs.h
> @@ -1,8 +1,10 @@
>  // SPDX-License-Identifier: GPL-2.0
>  // Copyright (C) 2021, FUJITSU LIMITED. ALL rights reserved.
>=20
> +#include <dirent.h>
>  #include <stdbool.h>
>  #include <stdint.h>
> +#include <string.h>
>  #include <util/util.h>
>=20
>  enum parse_conf_type {
> @@ -11,6 +13,8 @@ enum parse_conf_type {
>  	MONITOR_CALLBACK,
>  };
>=20
> +int filter_conf_files(const struct dirent *dir);
> +
>  struct config;
>  typedef int parse_conf_cb(const struct config *, const char *config_file=
);
>=20
> diff --git a/util/parse-configs.c b/util/parse-configs.c index 44dcff4..7=
2c4913
> 100644
> --- a/util/parse-configs.c
> +++ b/util/parse-configs.c
> @@ -6,6 +6,22 @@
>  #include <util/strbuf.h>
>  #include <util/iniparser.h>
>=20
> +int filter_conf_files(const struct dirent *dir) {
> +	if (!dir)
> +		return 0;
> +
> +	if (dir->d_type =3D=3D DT_REG) {
> +		const char *ext =3D strrchr(dir->d_name, '.');
> +		if ((!ext) || (ext =3D=3D dir->d_name))
> +			return 0;
> +		if (strcmp(ext, ".conf") =3D=3D 0)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  static void set_str_val(const char **value, const char *val)  {
>  	struct strbuf buf =3D STRBUF_INIT;
> diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am index
> 25efd83..db2351e 100644
> --- a/daxctl/lib/Makefile.am
> +++ b/daxctl/lib/Makefile.am
> @@ -15,6 +15,8 @@ libdaxctl_la_SOURCES =3D\
>  	../../util/sysfs.h \
>  	../../util/log.c \
>  	../../util/log.h \
> +	../../util/parse-configs.h \
> +	../../util/parse-configs.c \
>  	libdaxctl.c
>=20
>  libdaxctl_la_LIBADD =3D\
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am index
> f741c44..8020eb4 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -19,6 +19,8 @@ libndctl_la_SOURCES =3D\
>  	../../util/wrapper.c \
>  	../../util/usage.c \
>  	../../util/fletcher.h \
> +	../../util/parse-configs.h \
> +	../../util/parse-configs.c \
>  	dimm.c \
>  	inject.c \
>  	nfit.c \
> --
> 2.31.1

Looks good to me.
Thank you very much.

QI
