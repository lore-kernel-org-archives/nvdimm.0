Received: from esa6.fujitsucc.c3s2.iphmx.com (esa6.fujitsucc.c3s2.iphmx.com [68.232.159.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172313FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 02:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1629772304; x=1661308304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FugrIGMfgdswzEA8TgUdVH3N9m2PpxB4pVTwv7YUMx4=;
  b=bxwrfsbmvBDbJo3vPrRXPeMt5jsRQm/6/0TBCErenbjBnnh4uPxkxP7Z
   MPtVJnNgTmWKoaPyPc6tYSMCe4EIS4MPtxB5duWujIPxFR9lr8bNCe4yz
   E0pi0ZDWB1AzHwAdON6v1oFTN6/sQ9u9dcyQZYGeB7xjp5wfMEK6vC+Q1
   0723HpFN09dopTugk2KxI7HHelGE1lWsvAdfhw3kjMzBTCozIjCc6sROl
   YxvKv1SvTSDOINkxrYjht4d+P182yTnWisz3ar76PEGvfl194szSjC0cc
   /FOmTcVPplrgFmpPy24RXHiUT3xFaFp7CFsr7QkLtyeZ3OYiMPe6tGC27
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="37575880"
X-IronPort-AV: E=Sophos;i="5.84,346,1620658800"; 
   d="scan'208";a="37575880"
Received: from mail-os2jpn01lp2059.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.59])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 11:30:31 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKeLR/WD4rrkJRv7De4IDv6ZLNgXnsLuvzTLEotS7lziwii3ZcrWYOtUDG3hHOCdHsLRLIpShEEsKZTzSpzsstFZKseVgkFkCeJEH4oNDRU7B8qc3PT3X4tUvW+i8Q+lqUf2TZQhvYiJ+iEJljl7uxb7pP8Dwwh7oqS9OH/na2BZg2/Dt6TdMfY3GSurb9CNHC1Ei244PMARAmrzV+Fs1hG3BOPffjMvWDdIY2Et75piCdEa8yGUfwKtS8BywiwARR00oiXGP8K6BeYJPPABaYA+hd2/2F/DsJLatchutr87+xzQTjVadIwhhIRyGvY+A3rbJB2F2rm1ukOsPcppwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FugrIGMfgdswzEA8TgUdVH3N9m2PpxB4pVTwv7YUMx4=;
 b=bVlOtscfzIujlxzxVtR7YYXyjPYTVruK8d+BjMNVOw64Mpp0cXVbxqF4cM5W1e/mrdcknCjKJN11O257Rx23b4pD6Tkd4VgDVmeZY2fIRJENYiZMX1ikt4OKjr1OvaZVz/PoNbW4fIE6cKeAxcGyy5GHDJ9qqHmgsOlxzt0I7dP1VlLSnqOBf+/jKAiY8MyByD4wypwktDz+3C1s+YXZD4Nt9GNlrYyC8gjLGVX6y8YPCfpo9cQHPMcVhzZ/ZuFHT7zrapg/ZL0S2hZolACubSC9JxAieYNLtMWMdBhjxehx4LNN2K5ozfzxTjP2W2YwWnYQE+u1soUfkQW3EpqX5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FugrIGMfgdswzEA8TgUdVH3N9m2PpxB4pVTwv7YUMx4=;
 b=Lesb8PhHz/dwIDCe5If3GJelBlK3bKtT3/bbyCMNAVciuKgRdwIKRO2ekMCXhbLORJciTLCLGn1CXGxxSEKUJs6a7jfEAtZ3Mn9kQo9ruEAHsffGwc3kC8v7YzrrrofxldXhsaRIexNNZaUriqwfNtxa0luJ+OxjnmrMoqK4vX4=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYAPR01MB2126.jpnprd01.prod.outlook.com (2603:1096:404:6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 02:30:27 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::dc05:4852:6968:f23e]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::dc05:4852:6968:f23e%3]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 02:30:27 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: [ndctl PATCH 1/5] ndctl, ccan: import ciniparser
Thread-Topic: [ndctl PATCH 1/5] ndctl, ccan: import ciniparser
Thread-Index: AQHXl5Sm8sH56Hp+CUO1f8fHMXdm5KuBTkAAgAAwVgCAAHFMAA==
Date: Tue, 24 Aug 2021 02:30:27 +0000
Message-ID:
 <TYCPR01MB64615AB87C53702D24EB6808F7C59@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210822203015.528438-1-qi.fuli@fujitsu.com>
	 <20210822203015.528438-2-qi.fuli@fujitsu.com>
	 <CAPcyv4imFbXW2_84QqmT+AmanXAtKXNQgKNEez3EX=o=XLiNjg@mail.gmail.com>
 <4395bebebdfbdb17422bfc82368a33fb7048ee60.camel@intel.com>
In-Reply-To: <4395bebebdfbdb17422bfc82368a33fb7048ee60.camel@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-08-24T02:27:02Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=e06f0cca-ada4-4e7a-80b0-c93d212452ae;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2bb6b62-a463-4f61-715d-08d966a722b8
x-ms-traffictypediagnostic: TYAPR01MB2126:
x-microsoft-antispam-prvs:
 <TYAPR01MB2126A659522FB8D5A283FC9AF7C59@TYAPR01MB2126.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 3q6bYWxflQ9Z2sOoMbB6RZUQXZ7HiSXULrRBLYtcI/Gh3SchnSsVf+wHmPDMdzr5+vcN9iIU0Y8G17PrEXmrdEsSBCDExKnTFSC6KuPRau5GwLlGta33Fxp4ohm/2rBEZX3/+VSxVGEDJ4748o03lq9t6M51EdJiPEJjbXaqe5tyRVslph05E6vUkMRXKSlfPi8IiVDUNC5wRVuk7v4F5Py4q2q4Tl03gcjJtiDq10ws7N8V5kveckjNmKRSFYV/rlIfYlryNZgvNgFAzmdcK/uanjDz+uhT9Nd31nO9VnGdmJplt60MtMIRtGk5pyf7M4UTBcYv4KmG8kEygKqCJ6uIRgBXFA1ZuR9lp3X2v6NCPIZtjw6vY1T87AF7qr5AM3Kl6U+7rM2GZTyB7WkodH9hxmXHY9gUWcOApcpwEtYQUyaoggSVdxZyNOUAbEEU4Qlf967LV470NpfwCUNgS62xkjat+jfy4/Qk7+w74+gVGY5k33t5ai66CZlsRZmYhhSNNtzkdr79ubkcu5v8aUkWizQzBsYUwOTLvdz+V8YvcuzA857XEUjv9Lx71eBtqGIaoPmZFRZC9BmJQuTMWmjGVZpoERElILEWpLQhgCwgokYKPddhi85yJ9QVqj7cpZjzBWFWoo9A4FMhwlro70wQbtmtk1xkWDmVitJsa72h+6aBVbxsO6WNQ4rTDxQw5DqEKceVSV2w+2jOyVD0mMPYgSYKmX3R2Ot5E+UrJmEt4n69ToJMA0oPuuBg1WSeBvXXO0q29GiK6VA75pSLSYrjmZIb43fiQTpKesaeb/8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(83380400001)(33656002)(6506007)(53546011)(86362001)(26005)(122000001)(38100700002)(8936002)(2906002)(71200400001)(64756008)(66446008)(4326008)(186003)(66556008)(66476007)(76116006)(38070700005)(52536014)(66946007)(316002)(5660300002)(110136005)(8676002)(966005)(85182001)(478600001)(55016002)(9686003)(7696005)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?di9GVUtNbis5SlV5SVExTVFMWEtZcVBpSmYvUGxHeFdvY2Y4TmZWZVdL?=
 =?iso-2022-jp?B?akZUbXZKbENMZGJVcnpvTUxHRmprOHQ0NGtwMmw2elpmZWo2amt4ZWpW?=
 =?iso-2022-jp?B?N2lnTmpIeFk4V3o3ODlHZDhySStuS2NhamxQMlpZNWxoTXgvYXU3L3Nx?=
 =?iso-2022-jp?B?UExGTTRBc29jL3NpOHU4WDB4MHpkcFI0b2VudGdKSEFOK3JJdkVXSlF5?=
 =?iso-2022-jp?B?U29yTkpKUlM4Q1pLZEsydU9SWHZGa3pobUZ6ajFFK3p6T1FhSWl3eDhr?=
 =?iso-2022-jp?B?UEc5ZS9nenVMdm1rdmxIWnpEZGxKUFg3RFVjNlZ6WkRYTVR5Z0srUm9n?=
 =?iso-2022-jp?B?NkJZMXN5K2p6cGNNS0RqclNWM2hwUGlpeHhLKytuQUx2WUU3MjM0T21t?=
 =?iso-2022-jp?B?MlhkVGg3OWNKb0ppWEJsV0plSThaVVIzcnhvejBIU1JILzkxMDErbWht?=
 =?iso-2022-jp?B?SEdLSEtxRnlWQW1VdlNOUEMzYkJTWFoxRzVDSXFXNFFkaVptbTBmelFQ?=
 =?iso-2022-jp?B?d3k5VjFtNGRZcVpwRlJvb2srdFJkYU80a1RSSVNhcGlYQlJuOHVQNXVp?=
 =?iso-2022-jp?B?Wm8vVGJLNDVZWnZPckNRUHNjK2Y1dThPVUNBQWlrclRnOXRhdzc0TGl1?=
 =?iso-2022-jp?B?cTQ5ZXdPMVVoczVUVzJhaExTRkViSHJQMGxVUExRN2NYWERSVDZjamdX?=
 =?iso-2022-jp?B?R2szNWxCMjFkNlUvVCtWVUhGbkdtbmR1R3YzWk1DbWZtWE80bzVGSkI3?=
 =?iso-2022-jp?B?VjVGSmZ0RTIxclFpQjhRWW9WR0RJUDdQUzFXdmxRQTQ5QklQdlMrV3p3?=
 =?iso-2022-jp?B?dGtqaDFqMFJBS0MrV053ejdaT05mQXZIYUQyckREdU1YektPWTJkcnpB?=
 =?iso-2022-jp?B?a3pzaE16cGFFVXdRMnllNlVaSjgrMitkNWxTb3VEV1U2Rk9jMU1iaXFQ?=
 =?iso-2022-jp?B?T3FkNDRnd2gxSURwMDB4L0tmL3dkQ01WaVBkdFFPajFWcjg1K3dja0RI?=
 =?iso-2022-jp?B?VlB3ZEpIYy9lWWN3bDhWUHBQM1gwVG1teVdTdG00L0lIaXN2MGI1anNQ?=
 =?iso-2022-jp?B?Q0lnd1lmQ2VaMHJsRlYyVHB3RTNJV0JuMkF0Uy9HbE5ONTVNR2FId3dp?=
 =?iso-2022-jp?B?d3EwY3Fvcjh4ZU44ZVJaUmhxYWJvVWhRa0YrMDI5R1I4aEVMOWFJd0pz?=
 =?iso-2022-jp?B?b21adTV5L1FWeWJoa0IrUnNFU1BMMjk4WnJiNGZQUTNJWjltbU1OdThw?=
 =?iso-2022-jp?B?b1R6emhlRWRTcTd1aWxLT1pNUHJyZjZjOU0rSUFXTU82QmcvcldWQXFv?=
 =?iso-2022-jp?B?czY4TmNsaWxqTzJidkh0UEhaUmxON2ZVZ01PRjNiSm42L2dxcjZnc0Vl?=
 =?iso-2022-jp?B?WmhuZ2djSitiTFk3OXkwZThlYVFzaEdHVmx5NWlCWWlmVlVjRGU4a2Jw?=
 =?iso-2022-jp?B?LzZ0OU9ESWM5akdZUlQvZXdtVURqcDdwUjUyYUJWdjFTeGhuTStRREZO?=
 =?iso-2022-jp?B?dVA0dXR5L3o4R1c2Rk0wcUJVMmtXU0FyMjE3eWZnWTBnV2JvMUlnK2tD?=
 =?iso-2022-jp?B?MFljWjhqcDFwZW45S1B2YnBYbkFFZ0Q0QmZ2YXUwbGh3d0hHTXpUajNZ?=
 =?iso-2022-jp?B?bXdGUUlNdldwblNQc00wWUpudENqWGhJL1lnUHF2ZzFxWUJ5a3lVT0la?=
 =?iso-2022-jp?B?RjJWSE9RNmdZVVhndVAxVEh6NjRGVFUzL0VzbTVCZWdlc1VyYjlYVVlW?=
 =?iso-2022-jp?B?TERJOEtOQWtiSno3RDBuczhzbEVTc0daWHR5T2FZRGd6UkQwNCt1YVVw?=
 =?iso-2022-jp?B?WllRdGVocHFLR2VyUHNjRmpJTlJzVkQvT0htR1ZzTko0VnhnZXZIbmlH?=
 =?iso-2022-jp?B?Z1ZEbFpKSG53MEVzdVBrZnFsbTBLS3pVVERsc0xITndJWHBHQUpQcks5?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bb6b62-a463-4f61-715d-08d966a722b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 02:30:27.7043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pkRk7fXqcw8vPmDhTgbXxPCe4jh98v0l7XVsealffHmHUf6mIbB4HzpPOS4Q0pO0StQrKNqxvtNm1MbyEFgM8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2126

>=20
> On Mon, 2021-08-23 at 09:48 -0700, Dan Williams wrote:
> > On Sun, Aug 22, 2021 at 1:36 PM QI Fuli <fukuri.sai@gmail.com> wrote:
> > >
> > > Import ciniparser from ccan[1].
> > > [1] https://ccodearchive.net/info/ciniparser.html
> >
> > Hi Qi,
> >
> > Vishal points out that an updated version of this code is now
> > available as a proper library that ships in distributions called
> > "iniparser".
> >
> Here is the link to the project - it seems like it is maintained by the s=
ame person,
> just outside of ccan, and as a standalone project:
>=20
> https://github.com/ndevilla/iniparser

Thank you for the information.
I will send an update patch set.

Qi
