Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021026.outbound.protection.outlook.com [52.101.62.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4CF7F
	for <nvdimm@lists.linux.dev>; Tue,  2 Aug 2022 02:44:14 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JimwbYR3wHCE3DTAGw6J5qN8XwCVjEkiZvq9N/oFHM+7SE3O6h9aH1GbjBgM/pEbLvVMAAHaygIdniO5hOT68SLQjPEYPXAM5Sln3yXtqVXbFnmhhFft5VbnXzB8okn0dZcfeYJwU+viP9Jh92wVPN8VC/8I364iNC+O8K4dZyORePDPJYTy3SMFKvHYJTJDgVPD8SH+LnfGJOBXV1mun6dlrgAtNoiW/Wv5VAtDuNrfqhU9RDQDfDsm/YDi4vz/MqILmu1IZRigu0Yiv0Bs5827q/1w3WDKWHDtd27K4KpCix91lkgJsVPJ5v+W6V/DhKr1utEoKHe6VcBA2ml05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqzArzzB7KSI5vvkSLUzdeO2I2IJO1jqgq+z7AfdSJM=;
 b=Tr4/gkLAER6sFqB8ZoBZ52h0EAeRV/sG5tRANh7T/ZFwxCeLvpWXQw2HwkEOR8O547XkmipGNjYEF7pbcbiEmZYvzP5gf8vyabhI3IwEKl7iwE5ddm8Bb0itIHH3FV4Zblqrwo2HA9A9fXMUT4QDDQElJvObrk+uTIRJAg+tmCQO0w+CQR7padW3I6UpK2KUyPd0Lt2hZwES7QvA8ek0Bj+yuOXP89G16SNS6oJWPUcCVpdqnfGjhhVonf6XNCyA8i7brO6PXRGmXLAaEL9zPySY+qT93JI1w2ZSHP1sgIJekso41WMISYqCo1GHmFSsQ7hN1n5AyZSBPlD0HrF76A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqzArzzB7KSI5vvkSLUzdeO2I2IJO1jqgq+z7AfdSJM=;
 b=WkvUoL9SsQxp8LeQxoI1/wRFJow4a8mrYvus5s2Jmhf6pOhweomjJksyJMNuVn2cu0sEXK8IybRbPWEgdqUGItPYEhRlGawMwJ2qdDEGWDOiv9TsyOYZNz5oo5uxe9WGTryFTLisvNRKz2kHxPKf1doHVhag5x0CRXWot6KxeOo=
Received: from BL0PR2101MB1027.namprd21.prod.outlook.com
 (2603:10b6:207:37::30) by SJ1PR21MB3578.namprd21.prod.outlook.com
 (2603:10b6:a03:452::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.6; Tue, 2 Aug
 2022 02:44:10 +0000
Received: from BL0PR2101MB1027.namprd21.prod.outlook.com
 ([fe80::85e3:ec0c:cbc6:7fb4]) by BL0PR2101MB1027.namprd21.prod.outlook.com
 ([fe80::85e3:ec0c:cbc6:7fb4%5]) with mapi id 15.20.5504.013; Tue, 2 Aug 2022
 02:44:10 +0000
From: Giovanni Zinzi <Giovanni.Zinzi@microsoft.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: [help] Wiping all physical disks with no internet connection (intel
 optane disks)
Thread-Topic: [help] Wiping all physical disks with no internet connection
 (intel optane disks)
Thread-Index: AdimGb1QMM5Kxw5JQ1q+CtZ4IJW0Pg==
Date: Tue, 2 Aug 2022 02:44:10 +0000
Message-ID:
 <BL0PR2101MB1027519248BDCFEEDE892D679E9D9@BL0PR2101MB1027.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=eb2e0f02-1710-484a-9c61-970867108da7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-08-02T02:43:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dae88f5-9269-4c77-9f44-08da7430e0a4
x-ms-traffictypediagnostic: SJ1PR21MB3578:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xrKyf9WIM/mC2ntn9ZKQM6HgJv3sjW5ffZ3/tJvnGzNcCphyPFRaMeiWmp1k4UGy6NfLmCpylZwy5+gnLRhH6pBzUj9T0EbjslpzZf9PQ4CsF7e9UiQuJc8+GDMYudKNkAgXXW4r7AxMtICb8k7Kh8/C/8Q6KWwDJlOuHAiKecWtBm1VBAD+h3JCB9R+6psn0pQAhyDk+GlQiKGh7xGoK3zvHXoG/4WFi6hzcnEQQClKFJ/zMmjaHzdF+10FZYJcg6Q41KIBQ3X/Az+mBSS2KIvwkTlf37ib/PR43bLe9/hRc2CAZPRoAEWb6YL5IpE8v+WgBp2zI9eu7OhEOqEmJZz4xlZax+omlTknQNxxvPLD1z/3GEVEqP3ow7oiJda+GOYZoWMKpkMqyhlF5aifQouaqdRPtZCQWll/hOqURR9DnhWjKq+oEabTZgXCKV65DFX41bqbKkUHU4FsQMAIuOojLxFHKC178orK1Ur6fOflDeBVrFOpu25Ugy3x1UxAWrrZlSeR0qHgsJaqKlcx5W1HjqChAksFOqs7bD6xK8LPkwwuh9Mhl/ZbGq4LWp71sR4CO5EZePckw6MmwOKkcflGu5D8ezA4WcOenAR8ZV5n/amCx1p9RPPkK7IVDYnIOx/Tfa2Q8N80qU7wlh5314Jep6ZPrc319/4NZlg/gQfaDGlPNRFol4ll8sWvOBVM00tHsD9dLWkp16JEW1AiA2ME5nEK1+hi+hmzcK+AAhVk7aQoBXPynlIIUEYeoQcRU57ZqfdVKs1YkjyWXF1ym7ZkY2YV9eS4JCsvS3Pz//TrGaCDFp83EHizsdHv7OJIjiW0jvBSuQqsHcAdJTBPUxUW1ovBCeA/a+muFdFPrgIunLVv48ph/8yH1IWL3z3r
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1027.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199009)(55016003)(33656002)(7696005)(2906002)(6506007)(6916009)(83380400001)(316002)(66946007)(76116006)(8936002)(52536014)(66556008)(66476007)(86362001)(66446008)(478600001)(8676002)(64756008)(41300700001)(38100700002)(38070700005)(5660300002)(122000001)(4744005)(82950400001)(71200400001)(186003)(66574015)(9686003)(82960400001)(26005)(8990500004)(10290500003)(36394005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?EchvdxWE6GsLg2AIwRApkZtjW4PoIZ3AvVCGXYOCSbnw4y74JS1nzHaWmwmi?=
 =?us-ascii?Q?cRVutarJKvOLDYAJSU9fF5MBO1jjH9HC/724vwqrPvGN29yZGOqlby14jlVT?=
 =?us-ascii?Q?rElq/0Z1r4qoTOexpAoIQVR27EaWzARyso1gO+4t24USM1/JtNib88jDw40V?=
 =?us-ascii?Q?ecEaLC22O7cigeqAR0iCpn3yNqRq/l+AalsW9qbOalqP869Ae9s2cZrWz0Ki?=
 =?us-ascii?Q?XtWfMEgy1jA4sh+BpMNHEW/S3yEjYC+kSvdJLjJUsCAtfTgjBc1uMFLV31Ll?=
 =?us-ascii?Q?2peX8kbrbNisJPcP6xeLlwjTlMkITulsKg/qNxIwopKNzJE8EIqKQlK9NnhY?=
 =?us-ascii?Q?QZj2SM3Os7PZgORFwrlcIcel3R2xk1rh/3C0L0CFsCTDA/vGI/3CQUoRsLWF?=
 =?us-ascii?Q?PYHX3lgt0vBa9DX1iZhCmQN2dE4YeVIvacrdEbsJuR9MEsM2l2WzPuSpD6SH?=
 =?us-ascii?Q?TxDKWUZrWzUSLY8uHnbUssv7kYN2LduIEQFoQTa1tFF75ZMVTZSh5+o0UdFX?=
 =?us-ascii?Q?NNi8dJhPYdEAhTg1c9iPbwErEeZN+IKeVx2ckXR/yLyl/RFEGfnZuDxmVyea?=
 =?us-ascii?Q?ruW3OHze/B2H7PR8iWJbL+zRNyoZIdhBHsCEkREP82UjWJl5yCuNeVTePZB3?=
 =?us-ascii?Q?+VAWI2jiWiAVB8iIXQ0mLzfTJytEYyW08Piuui1fvWI81MMh0+jQEaOlpcza?=
 =?us-ascii?Q?aTrUhz/nLUDilkACrKL7ttXTjaHqRNRvEDOFnyzSG+bDM4OxtvKQkPSNLXXA?=
 =?us-ascii?Q?4P74HeLZjBDp8nRijUZFn7c1sba8R0mdMgg2jQDCszrpVhdQwFkkzH9eBU43?=
 =?us-ascii?Q?/sy/jkMjN2NtUJ9/Lq9V2UVos6JrnXs7T72zhd9FDVxq0pFZyWZHbNw3ds1g?=
 =?us-ascii?Q?Xdvq6ohNxzR/l3RBgcDsmoJaq74l7geRXIBqVnBu9VcrLgj71mY7GEAIroJV?=
 =?us-ascii?Q?FYkVblqq2bCAbuot+0zNAmtOvHJelDxo3CkU5bL4Kgc7LFhKdUIDxtlIjNSj?=
 =?us-ascii?Q?/gPDrR4Q9/LM0OGv+xHHCe3Vl4VFH0ODJvWZWQ97mYjfsfXEcGclJtRIxjYt?=
 =?us-ascii?Q?jTRhbOyeAvNodz9Tf77jCoWRulo7oimEBaErBIfVapm2CEne9bOhr7Jp5y3k?=
 =?us-ascii?Q?Zz+g58k2kApUFI5L4YO3PUg7hzD8JjPghEnic+hRCH2VxEQFoaQCd8o8SJ9M?=
 =?us-ascii?Q?ziMhe6TMLZVDWnzfKwp//+QGiR3cRLZ5HjTc5eHCCmS6yasfnB9QCfMnXUaq?=
 =?us-ascii?Q?VfdzO52xmv1YAmWPFurgFYp4isdROsvz6DdpcxjPg72fuHr5ZYwCotu7Opes?=
 =?us-ascii?Q?L4Jr7ZobJ2wsBSpAR5NUBCbzdVTUZgcClGIdqj2S8z8Is9/MByE2SvvXPUBq?=
 =?us-ascii?Q?SfJ70xuLdUcXzJDloEvy3i7VOUB5GeS4r3pzOc+KbtxZsdX9NRNSaYg2snPV?=
 =?us-ascii?Q?P0ILuoCfl4YeZysBcZSd6LE7wnyJAw9feVJAqE6MLLH4J68rYxQZfGLtmly0?=
 =?us-ascii?Q?rbvZhGK0eN7EAwO5V4FNMDU2dgzhgFUJDJke?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1027.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dae88f5-9269-4c77-9f44-08da7430e0a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 02:44:10.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7tNZ/FS6augB9ERJA+T/q6oiCf5pJhczmdVCjXqzS/KrsaRU9JI5SX9YmceUYCklUIGNs6Yp85inZOgnPajDKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3578

Hi,

My name is Giovanni and I'm a developer in Azure. I am trying to use the li=
bnvdimm subsystem to wipe all pmem on a server. I tried creating a kickstar=
ter file to do this (and installing ndctl for ease of us), but the server I=
'm installing a custom iso on has no internet connection...

Do you have any example kickstarter files that would wipe all pmem either i=
n the %pre or %post section?

Thanks!
Giovanni

