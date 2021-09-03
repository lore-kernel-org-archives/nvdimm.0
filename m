Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0398372
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1630630640; x=1662166640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iAs+pKiG93XcjHXJD+d5MwRKsb5bdhDBz+qvH6LsnD8=;
  b=uab4VCgjSWFRikX3Ylu+GFTeNV+1vuYuA904pJiMXOjt8ks8Hn6mRwpa
   esOf9L1NpFOXGl0e3kK+PiP/npU/r4KvBmnr1b3d1NsC3sUtmrcIO40w6
   508kVYhPaVPF+zrMjkV7Ah+5OrKN3L/eigCEimNDU29K6HU8VlPMmZqpi
   fRnRgYPyyUYm9sUlwA1v3Tk5sBS5UFgyU+yc9nirG8EDN6NVVUI1wVjpe
   qxLtm6w2oOJcdU4+455dnOfT0tAcupSa5Lb2Z+j5ibSwVAyFwkLmN1D29
   pkG7UdoLDkLDtFZfPRJxelf/5pLhnm28h6vBwHbqbDndELm1zb4DWHfrP
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="38363814"
X-IronPort-AV: E=Sophos;i="5.85,263,1624287600"; 
   d="scan'208";a="38363814"
Received: from mail-os2jpn01lp2057.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.57])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 09:56:08 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhIs9pqRPdPWnVes1MqXbYOdyBDSGA8R3I9W9qRQMe0E4Qq6l63S07CGxBIQl+LbHx4jiVRKr+pBLgD2GUL2N86y8W8daBpMph9yGEf7kpm/WMJEtDIJOBHV7WvBd3sjMfO1RfhaYVoyX+Jd+FGaWmPBKnh5WaisGh6D4X87WZu92JWGmdyKqZYJlT5VZjRA8TkRVrqy42b4diwbz1QsQv1os4Xj33g3fptk5K/WCMKbgqQGhVQmp2Fu6m5c389UfdqDOCEi151R/rseKIkO5QCk/RF+V5GC+nHtA0kAgoX3wVjpCun8PcpE4GFjYCZiz3ReEJ+95kABP6w6pxNHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=b9nf+agcXOyowNI/KZRagSnbPp/ig2yM9A1WcmYuo0A=;
 b=Coq8nEuMaElDhCARaYGmY75saD3iSZL2ma1tMO8+IuVL0q5S26jYQ7l0zADRwpCpemvsQPCh72E5mTQun+PXshxfEqZg5o1p3WExgIe/Itg54e2U744KGa+jgGRbp40a56VKY7jZv9ZryDzb6Y47mmnIp/tENkz93F5bYKJSVD5UYsxWzB2Znc38Oh320NSxm7gorPLVd4rYjQPB36CnNU+Ad6gak2eXf9yXLSHjW8WN1Omx6vqqAETfroeyAgsMD/CnGetzhweWnB3BovZ+DuuodIHx1jKcuE6iTxMuxj+p3DnP/Ib26HLqT9Sl+ihtOKPpAuyLZsIdhg9dv1RPjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9nf+agcXOyowNI/KZRagSnbPp/ig2yM9A1WcmYuo0A=;
 b=PEbVJ1p1C8iiz7j3/g66RwB7odQsKbc8qr5M9bs4/3oYQmtvoOCWMqSPiA3qzs6crGJslGZTWhEHlRZ79zsbsgizwxwfyJZqLgwPw0yafskTTHc38/6mqtHMzxzW+XA45Iiw83fwL0PqSDqDzdsoGCjF2rBNj1q4BL0O6tNU4kU=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYYPR01MB6732.jpnprd01.prod.outlook.com (2603:1096:400:cb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Fri, 3 Sep
 2021 00:56:05 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8%9]) with mapi id 15.20.4478.019; Fri, 3 Sep 2021
 00:56:05 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, "fenghua.hu@intel.com"
	<fenghua.hu@intel.com>
Subject: RE: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
 auto-onlining
Thread-Topic: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
 auto-onlining
Thread-Index: AQHXnkdY+x89je57fEOHraImSwmqQKuRfcug
Date: Fri, 3 Sep 2021 00:56:05 +0000
Message-ID:
 <TYCPR01MB646150C9A6006CFFD3846AC2F7CF9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-8-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-8-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-09-03T00:46:48Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=7c249d94-3661-4709-af92-438212b04dc5;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9478cd7-5cb9-4005-96f2-08d96e759ba9
x-ms-traffictypediagnostic: TYYPR01MB6732:
x-microsoft-antispam-prvs:
 <TYYPR01MB67324BF027724408306557C4F7CF9@TYYPR01MB6732.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 IjdkJkOHnzWeXk708gEbk5T6J/nBa24fLA+Yw+FUFKU5n12U+rMnjbg04tYAP7DydLd0rNLAIG11Z/Coz5GybaPvRN4Cl4f5H9ozCdnVr3+mSyAa4RWRnjwcAOMpPIruWvJxwyPh5kQ5pnhNyjo5+d/dXd9BBWwiufTRwTpJTBM6KlZirFa3GAAJlcSyMVLT5SeSkoG3kq5v0cI+3X2LdaPt8Xy+O2TtdAz00IBu7NlmZ96rCbSeu2Ujmbgk/+sYTs0T+tqIcqdV5FFcqIzsX5SN5L4acY/sFq/YF5d8eLdn4yDpE/wXAjtkm6VOZsgHg51bkYIhATVWo+hz3ifHILirmQxuhC36t3iJRK8u3J+jmeBB1HZoPaAoStYbkBfY5sv7c4q2v9falJ6f6SJbNf7uQMxO027BZvvgB789VjyN32+SZp5XNqPVESQHh1ukCitIlDZCsL6+5rShMf2J5pznjULiVvRmCPFMpzimcg5adcjf7oCTH01vsEVCE6hPq3eDCXWHnDm5hlzQ9K8aBDQXlakI3wXDoqpkI44ObirgmQgoU5FzdcX0uOHvOil/cWPky4yeDQHZjdqPtO9Rc0Tl2cDXBQsSaXR6uZtqQch5IJ7LMFviv5RxCrXeMLNdclGkA9XPenmCfNNzjAZNxirmVgIVp90yTkdh60luiY8KnaEInbe6muOs8N2zPZaGZ6gYUzzknaqArDSvBWFyOw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(8676002)(54906003)(110136005)(8936002)(26005)(9686003)(71200400001)(86362001)(2906002)(83380400001)(76116006)(85182001)(38100700002)(122000001)(66446008)(478600001)(316002)(66946007)(64756008)(66476007)(186003)(66556008)(6506007)(7696005)(55016002)(33656002)(4326008)(38070700005)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?MzZBRE1hUzB1UUlNRUJ2azc2S1lRUCtCaHJxLzRvVCtONWk0MS9aaWNL?=
 =?iso-2022-jp?B?czNrYWFIQlQzKzVpczZKNkN3ZEVlcFhkOUxhS2NWV0hFcERwSVBsMHdP?=
 =?iso-2022-jp?B?Y0V2M0toT1FCYUdhLzJWY3hwZlVMMXFJN2NhcVlQSWw1VmFWci9pVVo3?=
 =?iso-2022-jp?B?WitvdTlUQUZ5QVBKV01RQU91R055VXEwQ3ZIR01ZZ0pSWUZUQ2hQSENz?=
 =?iso-2022-jp?B?cVVzdFhBRU11U3hNdTkyYXdtaS9qMzBhQlhkcEdaaGF2SzIreUNSM0R2?=
 =?iso-2022-jp?B?eitGL28rSk02NGhlOGNSK21MRGdPd2dUcXdraGROb2lFMVJiMWFOdGRF?=
 =?iso-2022-jp?B?d1hPbWFqd2dEQjRsOTBueGp1T1RMWm5uNnJrZ3o0NERKOThEUEY4WmpL?=
 =?iso-2022-jp?B?cGZSa2NCdkY0QmUwWDUzMVg4UnAxbUk0cUxuY1VrTStwb1J3VHVXSWlz?=
 =?iso-2022-jp?B?ZDdSc2FZSldpanZEbzdUam9NdHpTZG9xVlpMMmIzSk4rS0xiL0hHbEpQ?=
 =?iso-2022-jp?B?OW4zanA2STNRSFU2M2hnNGtJeXI0VmZBM09sKzlQUWxyWmlZdTVvOEI1?=
 =?iso-2022-jp?B?ZVNBRjI0NU5QWjFnMlIybnNkNEdqODk3SDlIV1krMjlJOGtXbFlERzQ4?=
 =?iso-2022-jp?B?MDJ1SlJycEhFTVBDQ01GVWhtMHJTSzBQOExzVVFUUVRPYUxsckI1WFdK?=
 =?iso-2022-jp?B?WXg2Ym93VmRTVE9SNFZ0SnRibzYrdE1DVDZDYnVhSU8wVHVqMDVaVW1y?=
 =?iso-2022-jp?B?KzdieXRmak9Ud1gvUDlWS2lmelVrTUFORmN4a0RNN0xqSCtkbHhidElD?=
 =?iso-2022-jp?B?SDV3WWdhdnZWRUNLL09oN2F0alRHSzZzcHRiYlNnUi9XWnVDSTQvalJU?=
 =?iso-2022-jp?B?WnRLQU1mVkxKOFYwQ0IydUFnZGRkcHBTSEVKOGZiOUxxc0YvcnBUK0Jr?=
 =?iso-2022-jp?B?ZWwvNk95c1lRQ2lQODdBRzhBQmNoVXNROHhPdTRPWVR1N1dwbXpnRWRY?=
 =?iso-2022-jp?B?aCs3RUxTVVV0bWEwU3lwU3AxVEprUnF3Nk92NnFtRENTUFNKbXgyckVa?=
 =?iso-2022-jp?B?U1M2Sy9PdW81aHdWK0NhR0YxQkNnNUp0N2NWenMwM1hvNUwvTVA2NGFa?=
 =?iso-2022-jp?B?a3diQ0YwbnhwcVB1TUhmNVhKRjNvN3hUcTJoVHYzVkx4eE44WmhkZEoz?=
 =?iso-2022-jp?B?QTNiaTZGRWxmVFpOQ3NlRWtRamEvNnBQY2F3d2xvQktZSlU0RWlLU051?=
 =?iso-2022-jp?B?R3lGdEhnME9WUkxPa0N3VG1RamhQWTlqQmdRVUg5Y0tob1htSmFhVDA0?=
 =?iso-2022-jp?B?aE1tTG01dXpiQUdBWDZwVmlnYll2akYwRlJRRFR0V0xTc0tab2hleGpW?=
 =?iso-2022-jp?B?TTkzc3ZBT25uRjhGNVBHMGZZMkF1V2pycW43VXF5Vk81UnQyOHcyZ2Jt?=
 =?iso-2022-jp?B?UHcxU204ejZpU05rRElMMWpLM1VwWVlySGVZZEpqSFozTE0vV25Yc09m?=
 =?iso-2022-jp?B?MFRpTVpaOFl1d0RSK0oyUUJyWGlqWTBFeFZjMEVFbnZldmQwbDVXWDYv?=
 =?iso-2022-jp?B?WVc1UGtHcDlMandJL1pZMEpJUWsybTRaNHIxUlg5dEl6Mm94YXlpM0hE?=
 =?iso-2022-jp?B?NUtyUDFTM2hCdllnVVRaaExhSUJScGpoaTNpMzBGcWZqT1U2VWpxdlhM?=
 =?iso-2022-jp?B?QnRsRE1KNWVxNTlhdHU3S0E1am9VUTJlS3FTRjdab09CckZsRGk3RW9D?=
 =?iso-2022-jp?B?OXgzRUJvUGYvV2RYVUVaRHl2M2dMUzB2S2pDYVFqRzhaRldFb2t6ZnFH?=
 =?iso-2022-jp?B?Kyt4QjVMWUNDZmNBYWsyZVgxRWhhWWxDTldRL09SNlpmL3l1djhTbXhE?=
 =?iso-2022-jp?B?NWNENkxuUUt5bjhqZExubHJSVDBnQjZ6RW9yeUN3alhyMy9BZjBTNm9x?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d9478cd7-5cb9-4005-96f2-08d96e759ba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 00:56:05.0561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h2BNq3B+EQN+rMnAF2JZ3r5DTaCGBXRz0jAJoyiOZjvCMzwHr8DB/LR8Ct/cPVer4Bku3xZBTCH25cqnX3xKCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB6732

> Subject: [ndctl PATCH 7/7] daxctl: add systemd service and udev rule for
> auto-onlining
>=20
> Install a helper script that calls daxctl-reconfigure-device with the
> new 'check-config' option for a given device. This is meant to be called
> via a systemd service.
>=20
> Install a systemd service that calls the above wrapper script with a
> daxctl device passed in to it via the environment.
>=20
> Install a udev rule that is triggered for every daxctl device, and
> triggers the above oneshot systemd service.
>=20
> Together, these three things work such that upon boot, whenever a daxctl
> device is found, udev triggers a device-specific systemd service called,
> for example:
>=20
>   daxdev-reconfigure@-dev-dax0.0.service
>=20
> This initiates a daxctl-reconfigure-device with a config lookup for the
> 'dax0.0' device. If the config has an '[auto-online <unique_id>]'
> section, it uses the information in that to set the operating mode of
> the device.
>=20
> If any device is in an unexpected status, 'journalctl' can be used to
> view the reconfiguration log for that device, for example:
>=20
>   journalctl --unit daxdev-reconfigure@-dev-dax0.0.service
>=20
> Update the RPM spec file to include the newly added files to the RPM
> build.
>=20
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  configure.ac                       |  9 ++++++++-
>  daxctl/90-daxctl-device.rules      |  1 +
>  daxctl/Makefile.am                 | 10 ++++++++++
>  daxctl/daxdev-auto-reconfigure.sh  |  3 +++
>  daxctl/daxdev-reconfigure@.service |  8 ++++++++
>  ndctl.spec.in                      |  3 +++
>  6 files changed, 33 insertions(+), 1 deletion(-)
>  create mode 100644 daxctl/90-daxctl-device.rules
>  create mode 100755 daxctl/daxdev-auto-reconfigure.sh
>  create mode 100644 daxctl/daxdev-reconfigure@.service
>=20
> diff --git a/configure.ac b/configure.ac
> index 9e1c6db..df6ab10 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -160,7 +160,7 @@ AC_CHECK_FUNCS([ \
>=20
>  AC_ARG_WITH([systemd],
>  	AS_HELP_STRING([--with-systemd],
> -		[Enable systemd functionality (monitor).
> @<:@default=3Dyes@:>@]),
> +		[Enable systemd functionality. @<:@default=3Dyes@:>@]),
>  	[], [with_systemd=3Dyes])
>=20
>  if test "x$with_systemd" =3D "xyes"; then
> @@ -183,6 +183,13 @@ daxctl_modprobe_data=3Ddaxctl.conf
>  AC_SUBST([daxctl_modprobe_datadir])
>  AC_SUBST([daxctl_modprobe_data])
>=20
> +AC_ARG_WITH(udevrulesdir,
> +    [AS_HELP_STRING([--with-udevrulesdir=3DDIR], [udev rules.d directory=
])],
> +    [UDEVRULESDIR=3D"$withval"],
> +    [UDEVRULESDIR=3D'${prefix}/lib/udev/rules.d']
> +)
> +AC_SUBST(UDEVRULESDIR)
> +
>  AC_ARG_WITH([keyutils],
>  	    AS_HELP_STRING([--with-keyutils],
>  			[Enable keyutils functionality (security).
> @<:@default=3Dyes@:>@]), [], [with_keyutils=3Dyes])
> diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rule=
s
> new file mode 100644
> index 0000000..ee0670f
> --- /dev/null
> +++ b/daxctl/90-daxctl-device.rules
> @@ -0,0 +1 @@
> +ACTION=3D=3D"add", SUBSYSTEM=3D=3D"dax", TAG+=3D"systemd",
> ENV{SYSTEMD_WANTS}=3D"daxdev-reconfigure@$env{DEVNAME}.service"
> diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> index f30c485..d53bdcf 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -28,3 +28,13 @@ daxctl_LDADD =3D\
>  	$(UUID_LIBS) \
>  	$(KMOD_LIBS) \
>  	$(JSON_LIBS)
> +
> +bin_SCRIPTS =3D daxdev-auto-reconfigure.sh
> +CLEANFILES =3D $(bin_SCRIPTS)

Hi Vishal,

Thank you for the patch.
I got some warnings in my test.

$ ./autogen.sh=20
daxctl/Makefile.am:33: warning: CLEANFILES multiply defined in condition TR=
UE ...
Makefile.am.in:2: ... 'CLEANFILES' previously defined here
daxctl/Makefile.am:1:   'Makefile.am.in' included from here

----------------------------------------------------------------
Initialized build system. For a common configuration please run:
----------------------------------------------------------------

./configure CFLAGS=3D'-g -O2' --prefix=3D/usr --sysconfdir=3D/etc --libdir=
=3D/usr/lib64

QI

> +
> +udevrulesdir =3D $(UDEVRULESDIR)
> +udevrules_DATA =3D 90-daxctl-device.rules
> +
> +if ENABLE_SYSTEMD_UNITS
> +systemd_unit_DATA =3D daxdev-reconfigure@.service
> +endif
> diff --git a/daxctl/daxdev-auto-reconfigure.sh
> b/daxctl/daxdev-auto-reconfigure.sh
> new file mode 100755
> index 0000000..f6da43f
> --- /dev/null
> +++ b/daxctl/daxdev-auto-reconfigure.sh
> @@ -0,0 +1,3 @@
> +#!/bin/bash
> +
> +daxctl reconfigure-device --check-config "${1##*/}"
> diff --git a/daxctl/daxdev-reconfigure@.service
> b/daxctl/daxdev-reconfigure@.service
> new file mode 100644
> index 0000000..451fef1
> --- /dev/null
> +++ b/daxctl/daxdev-reconfigure@.service
> @@ -0,0 +1,8 @@
> +[Unit]
> +Description=3DAutomatic daxctl device reconfiguration
> +Documentation=3Dman:daxctl-reconfigure-device(1)
> +
> +[Service]
> +Type=3Dforking
> +GuessMainPID=3Dfalse
> +ExecStart=3D/bin/sh -c "exec daxdev-auto-reconfigure.sh %I"
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index 07c36ec..fd1a5ff 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -124,8 +124,11 @@ make check
>  %defattr(-,root,root)
>  %license LICENSES/preferred/GPL-2.0 LICENSES/other/MIT
> LICENSES/other/CC0-1.0
>  %{_bindir}/daxctl
> +%{_bindir}/daxdev-auto-reconfigure.sh
>  %{_mandir}/man1/daxctl*
>  %{_datadir}/daxctl/daxctl.conf
> +%{_unitdir}/daxdev-reconfigure@.service
> +%config %{_udevrulesdir}/90-daxctl-device.rules
>=20
>  %files -n LNAME
>  %defattr(-,root,root)
> --
> 2.31.1

