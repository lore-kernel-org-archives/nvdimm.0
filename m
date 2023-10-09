Received: from esa5.fujitsucc.c3s2.iphmx.com (esa5.fujitsucc.c3s2.iphmx.com [68.232.159.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9369E168C4
	for <nvdimm@lists.linux.dev>; Mon,  9 Oct 2023 09:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="PA2FP/Cw"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1696844524; x=1728380524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=48T84uAsaQfqAKK/j/46hJsMjSFkdKFHifnF3FD//m0=;
  b=PA2FP/CwGeQc59QBnptcJ4sIvMOnWcjOD5ti6oJpcyz7MK1Sff56MIhJ
   EwYKxWD+7t0KNWE90E6KfLQFnpqPmLfxtthKdU6mtDd8KBfgo6JmmkVe3
   BMubhdm0quIndPh4F8NAsjfqTu2ktCTOKeAxPeumUEQuwoZROgOBqWrT1
   8B1l11e6mrbW8qVX6WwnS1QrpfAFEirWd2RaQIYyUpMXXKiSBKFttJa3h
   DstrNgBP/xJyQstkIm8xegdc1sH9rQJn83U2mOwicMQhRlQXe5pOoyG+Z
   YmznxgOm4t27xHurfMRbpQkFwscMElFAmX30LGKga59vcHxx0AnfnpFOk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="98669114"
X-IronPort-AV: E=Sophos;i="6.03,210,1694703600"; 
   d="scan'208";a="98669114"
Received: from mail-os0jpn01lp2104.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.104])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2023 18:40:52 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiQl7rBh2ZuHz7ZVHEl1gTliwCjzXr3E0xYWgzUxhlCF5fJuzQTq1Wb0XUvH3yrQJmE9idRXvp5KZp70QH3RinIWZMUu65HB8K9OkVbhNDorX+0Icw6OBUZ5UlY13ef5crIKuwBFep8NsCGYbtAE/NgmpzOradwBBOPtV58JCmCrSmb8Rb7w5Qz/YYe4RHR8bpClNEoIFf9GbiA9hNLshbOZj2DzauF6bc1LacgBL46/fPB3F7MbJLQ9/tmbfubhMfoamRcpX166akIPlzpZcIr4nr+2W364E2x+iLqhW64bgA7Up5rLvVOTITvw7EXsUFz9WT+PeNEnCjeCRwDAhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48T84uAsaQfqAKK/j/46hJsMjSFkdKFHifnF3FD//m0=;
 b=nKRxTAANUvn8h5nfL9cdif0ubij9wZZJhsi8Ic5+IQ2v2vprUsIEyfLsgOBlBt/JE5r7iFGwuas3NQAtE2Bo15KETFQcNEXJ434vgY24naZmvzoeXuo7DmpZZXB0/hx8kM7OhIsvjJC54BUXVYINRKg25lmol52gJheA1LAFwEiB/pcqhDZBJxS/Y7Wj3SqJuceewBOsT2FmikxFTcPeL9wng3tSKAh8gwC08eDZ6d+/XHNbY/yA8JP5UY4ioUw+IuQ7zjmNNP7eLhqZq1Sc6CySE62f5SJTJIGBP9MrJ+lKlt+wQKmPS5IKFkHVALTCuHGAmsiKBYfCdVEKVYUBzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB10023.jpnprd01.prod.outlook.com (2603:1096:400:1eb::7)
 by OSRPR01MB11423.jpnprd01.prod.outlook.com (2603:1096:604:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Mon, 9 Oct
 2023 09:40:49 +0000
Received: from TYCPR01MB10023.jpnprd01.prod.outlook.com
 ([fe80::deb2:2f3a:1a57:2722]) by TYCPR01MB10023.jpnprd01.prod.outlook.com
 ([fe80::deb2:2f3a:1a57:2722%3]) with mapi id 15.20.6863.032; Mon, 9 Oct 2023
 09:40:49 +0000
From: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>
To: "Xiao Yang (Fujitsu)" <yangx.jy@fujitsu.com>, "vishal.l.verma@intel.com"
	<vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: RE: [NDCTL PATCH 1/2] daxctl: Don't check param.no_movable when
 param.no_online is set
Thread-Topic: [NDCTL PATCH 1/2] daxctl: Don't check param.no_movable when
 param.no_online is set
Thread-Index: AQHZy00cA5SrfJ8k3kaniMJt20sbt7BBkrpw
Date: Mon, 9 Oct 2023 09:40:49 +0000
Message-ID:
 <TYCPR01MB10023816C66F638C16336F35383CEA@TYCPR01MB10023.jpnprd01.prod.outlook.com>
References: <20230810053958.14992-1-yangx.jy@fujitsu.com>
In-Reply-To: <20230810053958.14992-1-yangx.jy@fujitsu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=238adecf-2a2a-4511-9381-e365d84d487b;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2023-10-09T09:40:40Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB10023:EE_|OSRPR01MB11423:EE_
x-ms-office365-filtering-correlation-id: 576323f7-f540-4f2a-7849-08dbc8abd1fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZKKYPVle4CivVYfLDgfGoSdAhzgvgvlYjhb4ac6dOT5MMWl16P3hn2ze4my40GQZKbCMIkO9cs8vT00xDgY30/CkShJGtFDNvAWijOUh4p/eSEgjYSrjIuCTYW95WjO5/uVKKYuw4mFD+6BL7gkrDVasXVW4Ocuw8hX8130AhB8qbTWT52hsGI2Kf5nPXZ1LHmGPRW3eu/lJeENQMXFY7XyK75ceTTeBwFAHerXCx+2uYnoljfT/D8XZH2nVuI1Y1PVaTKiXLh27WNq5ngSR0vR4ksghokoG1hLsB4jCvocRrK/HN50X1F7IdKZIdlSQ1UDJOX4ZBnzp6YOuPSKYZB3cqL0rOe+G2E2n8HeZE91QO/ztdBS3bNTWsXf8xxUAJPfSn4+S1SJfI8LCWKZ1PngM6dGWPGuFeCIKZYne0Cq7k/bANePS55991/CkKteu5ZLXw62WWg1T3Und3ahGY1nE/hnpKilKLUlk7wRtkYh3cuHYxTE63L9zTAvrIuemhzRHahMSBp1ly3gamVjRWuX82yKeX0GCDVDpr5ma9c5gYLaskvgMXI1lECgtOivBWrdZWZ55I/UVPz9natoD4vCRodRmlryuMfeAf4592C3GkBF+67bWrtokXTybOD9ErXQUu92VOYd1bixYOoywMA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB10023.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(230922051799003)(451199024)(186009)(1590799021)(1800799009)(64100799003)(2906002)(1580799018)(33656002)(53546011)(9686003)(26005)(86362001)(85182001)(6506007)(71200400001)(7696005)(478600001)(83380400001)(122000001)(82960400001)(38070700005)(38100700002)(55016003)(64756008)(66446008)(66476007)(316002)(66946007)(66556008)(110136005)(76116006)(5660300002)(4326008)(8676002)(8936002)(41300700001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?NUp3RmlmSWFDdlZQRm5tYzlhLzdUV1VTRmUyOUlnT2lNc0R0ZnFIbXBtKzYr?=
 =?gb2312?B?Mk1HWUJ4MXlUQmQwQ2FoRzVtbDdiOEY3bk4zVmxmeW1vZkU0ZFh6SjRhSkNi?=
 =?gb2312?B?UWk3TWw2a25QSFoyb3JTQXZxSi9Pc0hSYk4xSFZpemZJTHlzZHhKa0JISWEv?=
 =?gb2312?B?eXIrRkdXS3FxNjlTaDRzOHYxLzg1V1FRcDMvSnVwUnRKTFJodFY5UGgrQ3dP?=
 =?gb2312?B?OGNicm55R1UyZkVGUGQxbDNCZTkvS1ovKzVhRXBhSTlEN2NrQmNxOUZaYWsz?=
 =?gb2312?B?cER5ZTEzN095eis5dkIyNk1WcDJIUjBrSURyQm41T3RkNzgzZ2Q0ZDhVZksv?=
 =?gb2312?B?VTIxSWN2VHErVFNYdm84TTlFQkI4WWRsNERmdkJ2cHhCVjdOUGM4a0ZmbHpU?=
 =?gb2312?B?U2x6MWdLUFdGQURUcDlFWVBjaXZ0ZGJuZTJQNVRpalJDM1NLdlJVUFBHTVI3?=
 =?gb2312?B?VmhVN1lVYlZwc1JrOFJGWG0rUkY1QmNjM2dia1lYOGRjb0Z6WHByRnliaXUw?=
 =?gb2312?B?WUswNnhka0FoOTU4SW5sS3M1MnQya3pjeTdIVzFHV3pkYlU3eEZnVHFUN2Nz?=
 =?gb2312?B?REs4c2Y0NVU4eFdUYlZBU1BQelZ1eE5XL2IvUE00aVh5OGRCNVZBdDdVaTA0?=
 =?gb2312?B?RjZoelhTR2JRREt4U2NMNWxCSzdiajhMZXFSejlwaFNRbVRNeHMzZzBBbWYr?=
 =?gb2312?B?NmRKelpGcTRoaUxPa1lXN0MzallJdWdjMjMxZDZKeENYNjNuekJIYVRXNVo1?=
 =?gb2312?B?RHNBNXFGNjlMU29aMUtxd3VVbUNiQVFIUnorZzhEaXBWb0xCTHhEZVpEdzJL?=
 =?gb2312?B?U2dSRW5GZ0FRb2pwVElZRThPM1d3OGZsRDM2cXRINnJyQVZpT2xOYktBVW1G?=
 =?gb2312?B?M0xOSzJ1SlpwTXRCdEs5ZUgzSmcvei9keFlsTDhvSGc4a1RWbXUxTmlBUGcx?=
 =?gb2312?B?aVNwOVQwcWhFc3N1OVFGN0MwVmdMeW4vQmlYM2Mwd0RaUFNXb0pEaURkemEw?=
 =?gb2312?B?a1BGcGhqeHkvSXFYN3pLbHlYK2dxay9JYlJUNHF5OThMeVlkaGlrb0lYRVBo?=
 =?gb2312?B?OG0zL3FsTnNTd1FESDZSWFdYbXBaSUNhdXR4VG02OEFKNkx4dityeUdnMCtx?=
 =?gb2312?B?YU95STNBUFg2bndzcm50K1RmandBblYrOHk3V2RkZWVEc3JBcUFtMnZydGpK?=
 =?gb2312?B?UkRqUDNNemtJMXV6R1lQQ2t5WThvMHo4TkRHTEVONXUrSXRmK2NxZGg3aVhB?=
 =?gb2312?B?YXdWRzZYZ1lZRTJnQjJZUG4vVVJsY1JVOFlmVW0vQXFaMVNQcnNvNmxkRlgz?=
 =?gb2312?B?N1JRUG9XSE1hbmJYTEIzOFNTTDVQWk5IWXpHc3FaM1FZcFFIRStob2J3UUVX?=
 =?gb2312?B?VDFFcFFxMUNWL2taWTNWT3lIZGQ3bjZOb1h3dkE2SnhNVUxuQzFJRHNwQmFS?=
 =?gb2312?B?OTF5LzBPVjR5b1haOXl2M3NIZUhlUTVXbTNub2dub0djNzRabXFzeGxGcWxt?=
 =?gb2312?B?WjN0TjJrckdYRjNwekkyaU5iODhjT3pNVUsrNDEwbG9SZEg1dHdKc3c5ek9M?=
 =?gb2312?B?a0Z6cHFxQUkvOW1rWVFhNXNoVnhvU21QSnFscFZYV1FSb1N2Uk5hZTQrYk5k?=
 =?gb2312?B?Vmo2dFRZWjBEOXB3RXlKOWxqOWx4cEErbU1yUTByd1lyVW0rRHlDNGFmRGxQ?=
 =?gb2312?B?bnZ3Vkp4RUpLWW16TE9OeTFDaHVMaS9OU3ZDRkhVZmpWQnRpWWRjdDViaUEr?=
 =?gb2312?B?N2N6RXo1MmFDRTRGbWxYRkJzUkRKZDhjMTBqQWM2MjN0cXVnSmNUR1JGTWNz?=
 =?gb2312?B?QjVGLzQ2MzJqVDkzcDVodEJSVCtQaWdoYXlkZS9FaFR5SEo1bXVSb3UzdG1Y?=
 =?gb2312?B?S21pYU9Rb1BMeVUydGRTR1hia3pRZEJhNFpTOFE5Z0d4aTBwTVZyS29KZ253?=
 =?gb2312?B?ZnRTYkJIdHlrTXowN2hObnFGc21YbG1hRVkrR1BFdXl5bjVGZllOaGFCdWlM?=
 =?gb2312?B?SmRBL0xKd05QUE4zeXQyZVdwb2R5SHRRUURreEl0ZmNqaUlSamV0UDYzTXl4?=
 =?gb2312?B?VXZ3NnlPOHg0QUFkMXEwQjlwSE5yc3VDcldlUTNhVWM5eUFDWTA2ZVYwMFBh?=
 =?gb2312?Q?OWmXrc7xpW9Ccpcs7/bvcw5Bd?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+xElhqH6HOn+l9+YOtQ/UtMH+Tfxe+fvxUwQ1LGbLHrRefRiYyIus/BjjR9oRhUedrv3IVDQaPkoENvVoqE3MLumSZoNN8CZUULVZ3CzsIoDZbPyB2AsTKKFhqcvez+PdBzVm1/tfOgQzcSXC7AAXg+2rq0ndtxapD2/hUNuP4RiFLquO6i3JbE6Wy8ShiXPRt2XFFLi/H9Py2lUy8diGMn/xZZG4gstp/+jgB1LOqnQ4JekUi9G6hDZp9jx/rmEJ2D9/q3y4jw/G832DSSmvEGukuUHnNnmGLc7X2EzoE8tS4J2/VAy1qzcwYkqbs2I4eU3Kp2pPce8cMX64aAX4BWHHudHUYTlT2e3wQB0C3xUI5Ugo9PI65f5jp5tRQBFbQLQ6KY4nJSvpvwrwIFQAFSS2rAAqRvun/IaPYU7hgvuDHyP7pXc/5TdMJ7YlwVK/dSzP9X45nTAnP/C0nsFYbQH/TzIPH+7B9aFfMedm1cw0Q/AyW+emtXB9lQz74lyvyFddNmo7D4eZJcni9x/UJ/LXaCb/3KF0g2PAuHgwhtEzMumW4cHXqDOy/LDXLyl/rTuBg7+8I8MctuMxU7M+OPRcMqvA8a45DoG3VWo/XrVr71Y0wHr+Aggl+WL5o2wyosHVOuyjbPoyKpMIgxKw+vMsdbvOWKtJmcNz5jvWR5N/Dk2tUawmM64zjxCU8ujcxK5Ww86jeGKeXTx8ni9ToynyLOe/Fo0EeN3UZLqhvLf3DarK96lu1Yy8WMW7gyir6GCPD/J2qtsedAdHpBU3l2+wgt1E9JTVwqddhRmDGEfenRb5oCnHumAwUsIyfQNOrdRy6GY5VHtf0VCQDU3AQ==
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB10023.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576323f7-f540-4f2a-7849-08dbc8abd1fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2023 09:40:49.0797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IoyS6RrEgKzK6og1eXxuCqF97GlgjB3pylEF1vWvVnWTU7cVEd6XjdcZgmMPjAyF3tWIcrTCAecof7ilKQNJpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSRPR01MB11423

UGluZw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogWGlhbyBZYW5nIDx5YW5n
eC5qeUBmdWppdHN1LmNvbT4gDQpTZW50OiAyMDIzxOo41MIxMMjVIDEzOjQwDQpUbzogdmlzaGFs
LmwudmVybWFAaW50ZWwuY29tOyBudmRpbW1AbGlzdHMubGludXguZGV2DQpDYzogbGludXgtY3hs
QHZnZXIua2VybmVsLm9yZzsgWWFuZywgWGlhby/R7iDP/iA8eWFuZ3guanlAZnVqaXRzdS5jb20+
DQpTdWJqZWN0OiBbTkRDVEwgUEFUQ0ggMS8yXSBkYXhjdGw6IERvbid0IGNoZWNrIHBhcmFtLm5v
X21vdmFibGUgd2hlbiBwYXJhbS5ub19vbmxpbmUgaXMgc2V0DQoNCnBhcmFtLm5vX21vdmFibGUg
aXMgdXNlZCB0byBvbmxpbmUgbWVtb3J5IGluIFpPTkVfTk9STUFMIGJ1dCBwYXJhbS5ub19vbmxp
bmUgaXMgdXNlZCB0byBub3Qgb25saW5lIG1lbW9yeS4gU28gaXQncyB1bm5lY2Vzc2FyeSB0byBj
aGVjayBwYXJhbS5ub19tb3ZhYmxlIHdoZW4gcGFyYW0ubm9fb25saW5lIGlzIHNldC4NCg0KU2ln
bmVkLW9mZi1ieTogWGlhbyBZYW5nIDx5YW5neC5qeUBmdWppdHN1LmNvbT4NCi0tLQ0KIGRheGN0
bC9kZXZpY2UuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RheGN0bC9kZXZpY2UuYyBiL2RheGN0bC9kZXZpY2Uu
YyBpbmRleCAzNjBhZThiLi5iYTMxZWI2IDEwMDY0NA0KLS0tIGEvZGF4Y3RsL2RldmljZS5jDQor
KysgYi9kYXhjdGwvZGV2aWNlLmMNCkBAIC03MTEsNyArNzExLDcgQEAgc3RhdGljIGludCByZWNv
bmZpZ19tb2RlX3N5c3RlbV9yYW0oc3RydWN0IGRheGN0bF9kZXYgKmRldikNCiAJY29uc3QgY2hh
ciAqZGV2bmFtZSA9IGRheGN0bF9kZXZfZ2V0X2Rldm5hbWUoZGV2KTsNCiAJaW50IHJjLCBza2lw
X2VuYWJsZSA9IDA7DQogDQotCWlmIChwYXJhbS5ub19vbmxpbmUgfHwgIXBhcmFtLm5vX21vdmFi
bGUpIHsNCisJaWYgKHBhcmFtLm5vX29ubGluZSkgew0KIAkJaWYgKCFwYXJhbS5mb3JjZSAmJiBk
YXhjdGxfZGV2X3dpbGxfYXV0b19vbmxpbmVfbWVtb3J5KGRldikpIHsNCiAJCQlmcHJpbnRmKHN0
ZGVyciwNCiAJCQkJIiVzOiBlcnJvcjoga2VybmVsIHBvbGljeSB3aWxsIGF1dG8tb25saW5lIG1l
bW9yeSwgYWJvcnRpbmdcbiIsDQotLQ0KMi40MC4xDQoNCg==
