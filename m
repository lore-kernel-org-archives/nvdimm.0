Received: from esa2.fujitsucc.c3s2.iphmx.com (esa2.fujitsucc.c3s2.iphmx.com [68.232.152.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02E73FCD
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 12:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1630585029; x=1662121029;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u5t2hXNp/ft3bOOCBIOknIHxL7pVtdng2br/t71ak3E=;
  b=qAbBrv2wTki4Tzhm+7/LJ/tpXwjvV/xX20Eqtpqh3N0kOxHhEyKho50U
   c5CL7Qqc85J6gHd8r2mTFdgtgBaJg16BGrAyrFDC4P3KQwBuXZQW0IaVv
   KOYzFNKFVn5vgsVnJMMpV9bCyzq923Cb3QnL+dJVtxVsXuN+5KdtHPkEW
   Sxfv6wVGs37JCpEtBzhLH0o5eZYp7/UTu1hQKfvw4kSpX6ETCYtOQ8AZA
   1NWi+Q0tAx3F0PMwtj3HWfhaCm1uuvcxa89dhXIQY9baHTkCZUdDU6wIF
   5d2Uo7zC25YiXjHmnx8v74iGA8+cAzo6RnqvLFS5u0rlp0LDurkynImWk
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="46606537"
X-IronPort-AV: E=Sophos;i="5.84,372,1620658800"; 
   d="scan'208";a="46606537"
Received: from mail-pu1apc01lp2052.outbound.protection.outlook.com (HELO APC01-PU1-obe.outbound.protection.outlook.com) ([104.47.126.52])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 21:15:56 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/aDVBQJAcY9vubxiz1aMK7ZsM3jEyB/u70lZIQe+7g70SPdIhynwC+pw+l5AgIYNSI+xQM6/0GgDKkYV04jotJ0R3NquLuotL3dI8wsjwG7jFYjItfxZgUetQqKdZ0P6CvMpqav7rCGyAICshRh3ugJOObKy0Y/Qv8hIYJ70z6BJTQsErOOi85Mz8oAMLlwZEk6D30yM5Rqn6TsL9IyDG/kVl1n0LgGcLhPYQvJTwm5J4XZwLwcpB5ozdZcwAkUXTAwbFgWXNpWeNfM5zdLs6+fSot4sIoxXejWeXbIsQgE68kHmJEcevts+TX0GQ5nUnYK6V8B1UMi/wgE1GwvPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iocMY9YzxDDwDeLFYEqMUkvL/+FBHIpQlAo/8llJkE=;
 b=Rdclz+4JhD6mgG8N2W2cYYqAkgHK/tSktoOut+Wu33qG3O76jm5AWLP/1065gqWKL+Zw9TWHxJBKtm8nqWTLwRiWs71J1uofFna+2A7SLsJ5S4xgMliCzF48kmlhoKn91hZgRx5SQLT7BxSMPJZ11EdkjchU8PoC1rP/IBK+uz+S8LyEo3mBueQBvt0JocUEpWc50GsOe8AJpft3r/H44YzDQEdwYdTKoxC9o+QOT56QDzsScJWhwmI0rDcN6R7pgBWAFy+6YrAAmjy18zRuVn8w2n9ulaNH1zPKk3fGBtithloPb/LQNNlsWtck6DxaSmQ1VTb33qgrxRrpt6UNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iocMY9YzxDDwDeLFYEqMUkvL/+FBHIpQlAo/8llJkE=;
 b=NZovhWrOMGAfMsUFRLq/zg5vZKI5qhYr3i/gD58HMiDjAerZTLnD/PtrXxT22FbYOXdudHhtG3lTpc5ytqIybgIIQhZfSX26R+qBDag7rfOF1T8Fg+A/FMzOAwqm1TfQUb5loz/hNFGMkJWImPQhinEb7zEpcPoL90s9Acbzpe4=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TY2PR01MB3532.jpnprd01.prod.outlook.com (2603:1096:404:d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Thu, 2 Sep
 2021 12:15:53 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a91d:f519:509:56f8%9]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 12:15:53 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: Dan Williams <dan.j.williams@intel.com>, "fenghua.hu@intel.com"
	<fenghua.hu@intel.com>
Subject: RE: [ndctl PATCH 1/7] ndctl: Update ndctl.spec.in for 'ndctl.conf'
Thread-Topic: [ndctl PATCH 1/7] ndctl: Update ndctl.spec.in for 'ndctl.conf'
Thread-Index: AQHXnkdRpPXwtMsqM0eo/gPfr1FDQauQqxsQ
Date: Thu, 2 Sep 2021 12:15:53 +0000
Message-ID:
 <TYCPR01MB6461D03B01710974180BD8A7F7CE9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
 <20210831090459.2306727-2-vishal.l.verma@intel.com>
In-Reply-To: <20210831090459.2306727-2-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-09-02T12:12:44Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=c0aa9d9c-107e-4737-89b7-ca2adce1c0b5;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad34cfe1-4ee0-4b22-ed46-08d96e0b691c
x-ms-traffictypediagnostic: TY2PR01MB3532:
x-microsoft-antispam-prvs:
 <TY2PR01MB353258DAC64C2E4501DF90E8F7CE9@TY2PR01MB3532.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 YP6andeJCW0lvqaXh9MEqu8c9Wvo7l6aURpnSslvZN5/S9bx/9z0TEwcS/eQavFmN7pdCo1riBSnCbJ7tNbdH/iYX9CJPQpan43IK9ojdMzHIDRQn7WJIZiD2AODuxCv9HN2ZsJnq0w8iUW2TXCc5mmn3y4sT7OB/lEluuU8sfPf0Zl7Ioidth2CXkxl+eoTGfj6XSsmVzf2UKQk4ew6HZmoJBMwNvkOakPCLjLBZfGd4rovFn5Wfapp+qB0DO2O8R7F9aMXRo1vRCddidRbaZ5Qwo5uIOwZHnqEkpYvNF6EJH66+14YmJpI5KpefgNQh/PTH3XGhq+ukGSfKhChmUCQKtXTnbhTQJ6Jms27t9igocQPZcuHhYtpBkRmmb0yCFDSIiINF2KEzuL4iDjMSXAyY9B9n6RbtHJlXNsIF2voHANRXvlGji08Xr2zgzwOTTsaV8gNEsq++GGQmQjyFKvvZTbXH7Ad0Exr+/PlCmxmzJ/IhpRm6IqNRemkPqSKE5J0zIVsImXST7Uto1DykE/UG82cTeEIr+oDGDNKPnmCPh+Sq2l7CRxsXJENYCb18uAAmSxM4ZW2K+gp7uVrvnSftBA816fVmK1sHwfgx3UDe7Qt6ugq4jSvey54NIb+P/Y8IrCpr+3yl/pBXqN2I3fTT/pp+FGrOoS7i+dBS0fvB+8ofkmgYBC4ZqGYOW26xMUB2h+dcpx4rr6z4013pw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(8936002)(85182001)(71200400001)(2906002)(316002)(76116006)(64756008)(66446008)(66556008)(66476007)(9686003)(15650500001)(66946007)(4326008)(83380400001)(54906003)(38100700002)(110136005)(122000001)(8676002)(6506007)(55016002)(38070700005)(86362001)(26005)(4744005)(52536014)(33656002)(5660300002)(186003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?c1M2Z2ZrYTNhYUt4Ti9lcFdGK1lPOVFsQjBBRmxudGpJT0RHa2ZUM3Y5?=
 =?iso-2022-jp?B?SFY1R2RwdlpaRGNkelRPKzB1ZkRUZnNFcDJmb0tqQWEvMjFERUsrZkpG?=
 =?iso-2022-jp?B?MFpuWlFqVUpyWXVjMS9EM2s5ZzlHY01Ndks5OER2UUdrbHdNNXh2SHk3?=
 =?iso-2022-jp?B?d1IwOUczLzgyN1h2RHZTR3YvT3RaMTcvWktGWlhiTmtGL2ZHbjFpNWRk?=
 =?iso-2022-jp?B?WjZNZE1sdWJBanFzcExxcElCcTRpbWRlU0UvSE80WlUzL0pndWV4NEdl?=
 =?iso-2022-jp?B?Z3BFNGN0Q05JeVczNjVYekhmd3NRcVhEMUMzK1dHU2s0aGNoL1BjamFh?=
 =?iso-2022-jp?B?a0VRYTRmSm1yVkdOeUNwcWVrclk3aTdhd3RyNnM5ZWQ4T09lbkYvOGVQ?=
 =?iso-2022-jp?B?VGp4ZEdHWUh5OXBuR2NFZEdqNi9qNkJQYU1aZXBYQU5iUVUyVHlBUVpD?=
 =?iso-2022-jp?B?SkhEMlEvOUVaOEZGbjl4VGNlOU5STWRqT0dMYjRXSVhxZ3NBL2VVc1ZR?=
 =?iso-2022-jp?B?eWFjVnBQbnJraS9CSjJaRnorM25pNmRIYTVYWG5IRGN4Vkp3RkFKQmF4?=
 =?iso-2022-jp?B?czdNNDhTY2tMR2JCOVB3TVhveGlGa0hPS0hPOUVFVHMzcXNmVlFSNUw0?=
 =?iso-2022-jp?B?N1hLcFEvNnc1elA2Z1FTelJQK1M0YldxWkxLQlMxZWJRTjF1enZBaUZy?=
 =?iso-2022-jp?B?SHFTbnJkOUdKOWlMcllUMUZhbGo0ZVRuc0pTczlUOGo1NDUzS2RqcXFi?=
 =?iso-2022-jp?B?YXV6S24wcThXVWlKMkpOTTJKcVZjMFpFaklWejhPdWZZOUNTcjRnN0dq?=
 =?iso-2022-jp?B?K2NRMGlvOGFob2VjdnBpbzN1UUV0VFZwN2lJTHRNc2NlYi9wZVF1MmIz?=
 =?iso-2022-jp?B?MWZIVTB1dU5ReUM1QndvcGk2TGhWT09RNDh5MzVnQ0FEQktvdllaREpH?=
 =?iso-2022-jp?B?YWlXU3ZIdFFvZTQwTlBRQWtFV0FJVlNkSm9OV21CQ0JPQllnK2xhVVRW?=
 =?iso-2022-jp?B?Unp4QUJ6SmJSZm9BM2p5UXZPS05uOGdBa1VIYlpQdXhpWU1LQ201WVpj?=
 =?iso-2022-jp?B?THBXQW9wWjFwMTlpcDVJQ21xSWxxUUEzTUhnWWpZT1Jiei8yN2hZKy9H?=
 =?iso-2022-jp?B?NW5hdlpKTm92bG1oVmRZdWlqU2FUakc3SENUVFpxZVdxTndhNk4wdXQw?=
 =?iso-2022-jp?B?NlNNVU1jdUxHb25CQmkyRGZUcTBvS2dVSzU4c3pBeG5vaDZqT3d6enZB?=
 =?iso-2022-jp?B?YXFSMjJGcGEvS2lGNlNxQi9tZGVFbTltd283NWdEK2piMjZiTzdHMGx3?=
 =?iso-2022-jp?B?SWt5N1FMdmF4L3hvT09iU0VhSGQrZk5EL2FmN1FhcC9QdEtUOEJlUEsz?=
 =?iso-2022-jp?B?T3d3T1dpQkhDZ1hPc0xGZnpFQ1RoZmVxbGY4dFF5RlMycjNJR2RJTEVy?=
 =?iso-2022-jp?B?Rjc0TWc4S09pMmhMWTlsVTZjN2o5VXN2aE1DZ1gxcUpaNEtBOGhwbHdi?=
 =?iso-2022-jp?B?cnBLOVhiMGJObENEbXBBZlM0R1RhL1I0UkNXSHF5SUZMRkVkS2VOczJ1?=
 =?iso-2022-jp?B?aEkva2pDbWFYWU1OTTA5aUpUNWh6WUxqWnUzTDdZeGd2Wkl2eG91Z3Ft?=
 =?iso-2022-jp?B?S1dSczBsSFk4Y21lWDlFemROZUFWRG9XYTVCcWJBQlI1QXNYWmJGTUZ3?=
 =?iso-2022-jp?B?MUNtaTVNNTVmcWo0TkFUZDcvTlBwM1NmSFYvaFFOaERPcW9hb1dTUFFC?=
 =?iso-2022-jp?B?WkpBYkVvY284QjdvMlk2SXNIdlJzcDVuQ3NSUFExR01pZStQZ0dUeUJz?=
 =?iso-2022-jp?B?Q3g3UngvRXc2cFUwcVF2eXVmcThQYVFDZ1hibUV3UlZROHJNV01vbVls?=
 =?iso-2022-jp?B?d0ozWWJ0MlBMZWpPYkU4UUNXMXYraVRucEJRVFExMmo0dmZLa0FFekxQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ad34cfe1-4ee0-4b22-ed46-08d96e0b691c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 12:15:53.5640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qGFgonip7rGGYDv9rHAmpeb5MgLHNHLq0syPz3zpi8czGkulnw5hSSPzgdUmAetmNl2y9OReOBixg+0DFqcj0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3532

> Subject: [ndctl PATCH 1/7] ndctl: Update ndctl.spec.in for 'ndctl.conf'
>=20
> The new config system introduces and installs a sample config file called
> ndctl.conf. Update the RPM spec to include this in the %files section for=
 ndctl.
>=20
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl.spec.in | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/ndctl.spec.in b/ndctl.spec.in index 0563b2d..07c36ec 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -118,6 +118,7 @@ make check
>  %{_sysconfdir}/modprobe.d/nvdimm-security.conf
>=20
>  %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
> +%config(noreplace) %{_sysconfdir}/ndctl/ndctl.conf
>=20
>  %files -n daxctl
>  %defattr(-,root,root)
> --
> 2.31.1

Looks good to me.
Thank you very much.

QI
