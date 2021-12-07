Received: from esa13.fujitsucc.c3s2.iphmx.com (esa13.fujitsucc.c3s2.iphmx.com [68.232.156.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180D62C80
	for <nvdimm@lists.linux.dev>; Tue,  7 Dec 2021 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1638876371; x=1670412371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T/iyIgGYw/eHjAjsyrP1+uvapF0ypldhNuWZF/waf9A=;
  b=F7dW9Enj9gXGxs4YFew8hRBCZmZMi+FbMRz4TEcCk7qF3+5Xj0u+tZmw
   LNfSe6Om5o2z3DKi6ejvd5A0OU8efRVQQ1EaehbABt0U+lCg7N6hK0FeQ
   VYc0O+3iXoWreqNQ7yXP5mLbQCZEyu4vyGbP0CCXQrsrkz0EqEyY1NpyT
   s7OhObg8yS8argI5NCwUfFhghNSer6PXOi/aecDj+zdZThgUWa+7y4Fba
   RenkWn0BNcFLNBrvdqrhboO+PRB7bhoOqStMPyn3R+LKRxss+gGMjFWa/
   ORbTKzEP7QKTHvzf3eXHmC0huoUeEjHy4TyilJ72whARngIEPCm+Z4yLG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="45173829"
X-IronPort-AV: E=Sophos;i="5.87,293,1631545200"; 
   d="scan'208";a="45173829"
Received: from mail-os0jpn01lp2113.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.113])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 20:24:58 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmZr3iSEnjlpp+S49IIdVXQC1kpbfRFT64Ue2FwyBoOVMtImnT4Qg9rKPyZtbyYPWygnwH03qlpuFd2DvJkUiyU46vUXJnavYH7mZu+iSkvdjzIdc04vGAx9qPNdt3FOYuCd1r0FmcxlOqsfE8NruLUIV6u09kSQp7lxlYIcEPUiqTsXeeumPkLsbQUN87hcce/N6z5YVNQ3IYkXid9j/a1i8qRQElJEhfVueG1st48je92MviLE9iMK3QlpzqHLEgSu9x6Sr/AXZ7YPNE2+jNmx4WGVZPMWNctOzu74gzQ6C92Ntm55VG6238CkuJHtxo2dtt2ySmNNYwaLlnWUvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U80ChLOa2lFNTnfScDkKYk5/EVAeq6XIg1O5b9X87w=;
 b=IGyzcdlqzH+padb1PMz4IiHL+hnpVBgaNiD9zBWupLAr+gWhXQFAddS2OWnXpX5/Kc+JLAiJNLiyPK5CPUb31khFEYuJDhkOtDYimof2P3CqC3CYnDhFqXQXLtRzl+KT9aTTFIfs1g3uEkegTG52MABRdSTs9uzs7h5TUJ1YXN4+3mYLhuV/BZI0axhesiw0lCypXy3MqFsmjE+iwUJRb3IVdePT9UnNArt8YJj7r5ZbaxQrGfQ/KxZVLLK5UmVmm2Q9ERM4qVOdYxN/3ufkEy9wWT8/OguGtvFdxXcaVx6dwBrKhEu05e7HbunT1bYalQlIodYOg4jLBImcsi1Ysg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U80ChLOa2lFNTnfScDkKYk5/EVAeq6XIg1O5b9X87w=;
 b=VL2LE5shR5vvvFGH5i7lMsplIsKE+WZQuyTD18qDw18u1PH46MWI82RDq8mD+NRFqVqexgN31aFbJS6zQVncFTMB6JTE4q3uKObEVfhueHPcuN6uP7XR9WrcEXoHdFXcFjpSsz2onfvitmwOgkgZvKBjdLIJsmYFOHr7+zo4VVQ=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYAPR01MB4429.jpnprd01.prod.outlook.com (2603:1096:404:127::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19; Tue, 7 Dec
 2021 11:24:54 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::f1f6:6978:64e2:b506]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::f1f6:6978:64e2:b506%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 11:24:54 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Hu, Fenghua"
	<fenghua.hu@intel.com>
Subject: RE: [ndctl PATCH v2 00/12] Policy based reconfiguration for daxctl
Thread-Topic: [ndctl PATCH v2 00/12] Policy based reconfiguration for daxctl
Thread-Index: AQHX6vCjNG7HAaAxX0+KwPyUXzU7AKwmFywAgADJhMA=
Date: Tue, 7 Dec 2021 11:24:54 +0000
Message-ID:
 <TYCPR01MB6461A81AD718F7CEFF4EBB2EF76E9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
 <a99313fe975700d548f5a689cd6b5316356571d4.camel@intel.com>
In-Reply-To: <a99313fe975700d548f5a689cd6b5316356571d4.camel@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-12-07T11:12:13Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=6adab705-a29f-4a66-b339-b8d0d18492ac;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 186d6902-19cf-471c-77de-08d9b9743172
x-ms-traffictypediagnostic: TYAPR01MB4429:EE_
x-microsoft-antispam-prvs:
 <TYAPR01MB4429E0DC4BDE51631645E854F76E9@TYAPR01MB4429.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 D8O1SaIrZMqwPYhnFtVZ6SlDQbrvOCnRtp2jA9ELwpP+kbczFQ2k7sxHl0QeQp+YlJyXR3VNBg/f+leABGNgzR05euvXkTD7s3APP6Wtb1RURfTDQBd+1NQX58jOrI+ikfpG15NvnWkZfpjwTVNUsq78psu90UXBdjJmByDB1kpdoixbfKFGl2e5YA0iJGv7LXlJA96gdXpDIKWcFx4R2DOpQVAYAKUfifbqyUy6C1vJLztIkhhPyBSCXvlsbyGfQQy4/L0w4TReENqjnMVJQWaN4pEz/eajJ7ce0UKThwkQa6gJmQxToKiWbeF+U6LT4TjpXoTMQuvI32Hpy/WFEN/GEvjd27q+YbmHPLCPH5lBiVcOkDQZv2K7iDyCdai1NkmbP3+f7M/RVQER5sljl6nKALS16Ykl+HL64Hp843s87jfrdaEAFL1D46T8aYm4sxwMC8U0bRnmrzMjWWvFrOpPk25H/pORXtUnqU/ddSJ0A/1cHj7okjh5riK82pJMywFEB8VuBHi8EWTzVygzVHVUG5IaFDelQCq6pDG6V5CQBZqahS2+1Rqplx14CHitLWA35rl2jynLz3nFPLhxGvYxo4SSK4ryU89Bhcp4WVeYzzU75m+8J1yZCR4h++FYLwn08ez0CSet/mH53hrnWQtXawGCTQN2Vh5r+AB0k0ucb/nK9qcolg0Kb0yI9qVLBDJtNZRQ683nvfbAK/B0FiXWZRe64+Mx6hUYMX4+Ow+Ne3zm8YZuNBki0vecKMDDgxNH8SfrYxKWfotMi0wwi0p06QV4s+a3km18ICt/8HYZR3mzxdMM3gPOEnHShMsjJyy16gIebqbdu1T1QQNUlQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8676002)(4326008)(38070700005)(82960400001)(966005)(86362001)(8936002)(33656002)(9686003)(76116006)(110136005)(26005)(508600001)(83380400001)(5660300002)(38100700002)(7696005)(6506007)(2906002)(52536014)(85182001)(66476007)(186003)(55016003)(66946007)(71200400001)(54906003)(122000001)(66446008)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?TUhOVk1qQ1I0T2NTTzV4YVg4WmJlaTFvOUhFNlVRek5VdDd4SDd6Ukg4?=
 =?iso-2022-jp?B?Y2kxOGNEZXRCc1Y2T09WUTkyUXlmamUyYnkwN0laTy9DL095YXZ6VmJP?=
 =?iso-2022-jp?B?WnF3YWlrVzRuaUtwK2hHSi9Id3lOVSt5cm5xMDd3REtKR21DSFo1S1hk?=
 =?iso-2022-jp?B?R01jdFFweExCdWlEaTNvaWt1Z1I1akEwSExpU1hNQTYzbUUzbjVsVGZw?=
 =?iso-2022-jp?B?WEp2UWRlcDJlaW8vdWlCSHpyaW5qL2d0eTF1dVY2UEdzeWovYlhuelkw?=
 =?iso-2022-jp?B?SFVKeTRXaC82NEtwVVMzaHI4ZnFneEtQd3Z5STBqVHAwUUJSYXlTV2hw?=
 =?iso-2022-jp?B?dHBsTEgvRjhWdEUyWFk2ZFRMbGlQcEpQMGgvRHR6WWhTZi8wRytadVFv?=
 =?iso-2022-jp?B?OHk4YU52S2VOaXVDbjZ3VmcwYVpram9WbFIwdDlXSHlsL0pIaXM3d0lo?=
 =?iso-2022-jp?B?VktVZG9GTjBneGovRjBSZDdsaUZSTEdDOWVROWI1NThhZDF1dTJENCtv?=
 =?iso-2022-jp?B?UjhpZ21oSG1hSWpiVVBuNDdlMUxWbW4zOU13bG9PbnVxa2xxT1F6Nk5O?=
 =?iso-2022-jp?B?ZlQ0NUxsbVBJUnpja04rRWowZUlyUXVDNk5BeG81cW93S2RHZW95MzhJ?=
 =?iso-2022-jp?B?Rk1HV3p2bzFWcTlOSHZmZE5SZUVpdkkwUE5HVGQyWFNvUy9aRmhQaEIw?=
 =?iso-2022-jp?B?aGk0dDZQTUlCN2podmMwalJaOWxtcWgxQi81dmhHR3NCUzNUT2tRZUdH?=
 =?iso-2022-jp?B?SXkxQzQvWE5TUGVaMThyTDcyVzR5SDRkMW5rMW9oWkMwV3hrOGdlWUFh?=
 =?iso-2022-jp?B?b1FWQlZNSjBnUlI5NW9YUm9XMmxzTUtiVVBidVlua1M4UkVEOVdqYmI4?=
 =?iso-2022-jp?B?ekpnemtFdzEvTngxQkNVd0ZNUi96eG9JYmNmb0toTWNTRDRFS0d2bFU1?=
 =?iso-2022-jp?B?REI5L1ZhakU3S3FsVXZVOVA5aENmbWJwZE9QOGY5T0llSS8vMjhMZEhz?=
 =?iso-2022-jp?B?N2hXUkNWOWlvN3ZEZXp6bkJOd0kwRXIxZ0pqQVdNRUNjamdWbWVkM2kv?=
 =?iso-2022-jp?B?bVhad05YZTBOeCt5aFN3cDkwSlBXTm9ndHAwd3RvZFoxbEZLalVvZGwz?=
 =?iso-2022-jp?B?ZXJHOU15TmVTWE9qYlpjVURQend4Z2ZmUWpBYmliUms4OFZEdUxkVnJY?=
 =?iso-2022-jp?B?Q3k5ME1lWVNBTmRqbTJZTkpHUUp4VllnekR0ay9TT3BrMDJ3VGwyUHNE?=
 =?iso-2022-jp?B?V2FhSXZuOG1vWkgzSDdta1BnSlFac3VYcUlXcG03cXJaZmVNbFF1Vnhh?=
 =?iso-2022-jp?B?ZGpRZDM3dHpYMUl2NkVjM0tmTVZHMEVWQVQ4NVpzT0xuSkpmcXp2NzNK?=
 =?iso-2022-jp?B?eGttODIvNmxOMjQvNmxxekY5MGkwbkNwdDQ1dzF4c1Q5ZTFta2wzeWlC?=
 =?iso-2022-jp?B?TXNWaEVkRHFsR2FjN1RuVWdPb0EzYnhkTWlWMmYyY1dyQzBmRDJLN1N4?=
 =?iso-2022-jp?B?N0FKTGZ5OUJCc2wwQnVCaWNVWGwwNzVpWjFqeldSQU1jQnlxT3M0ZGZk?=
 =?iso-2022-jp?B?UWRCd0s0a1B1eTUyUGc2em5JTkVnaVpMZE9wcDZDSG13bzUxNlY0MVJk?=
 =?iso-2022-jp?B?UktPZmhjNUJNaHhiRG1qemxoZGZGakRTejUvZkpxUXlyeDlUMTVpRVYz?=
 =?iso-2022-jp?B?ZmdiUG02aU9FOElRUUFPUW1xYTJva0xQVHl4NmxkYjVWRktPb2o3Rng4?=
 =?iso-2022-jp?B?cUZFdGVzSlloWVN0SFZKQ1FvSjZZdkhWc1JQMXZMd2FicnFtWkd3bkow?=
 =?iso-2022-jp?B?NGNMT1FRTTJHdmd0S2xNeUExZ1lMMm1GenczNStEd0FpS05WQ1ZOenVv?=
 =?iso-2022-jp?B?RDMvQzBNM3oyWXRTQW1QNE9DekpJaWhETTJvRk9KTDVxOENaNlFvWmN3?=
 =?iso-2022-jp?B?OEVob0EwU1d1bHZoMitVUEh0NUczb0dRUzMya2tIYnU3ek9LdVJPdjRr?=
 =?iso-2022-jp?B?NWk5N0Zjd0FocUtFQnZJeWl4R1NpSHFEa21qNHVDNDZrZzdMdXpwNEk1?=
 =?iso-2022-jp?B?cVdBOUZNU0RXQ3lnVFZweE9QVHFnSVE0M2c0YUlMOElCN3RrNjNnekxV?=
 =?iso-2022-jp?B?MlNoc1FySjlUa1lOa0g1NkVTeVFESzFNOEttZDFmK1R2d2xDektFTU0w?=
 =?iso-2022-jp?B?R0w3Kzlsbi9zaVhGSFBOY1BEb1Zkak00T3VKeEE4dW0yek1oRHpYMFI3?=
 =?iso-2022-jp?B?azMyUzJHNzNDYVQyMVJHNzBXNk5jTnVjR3lCMkF4UmJkNEJiZHpscExk?=
 =?iso-2022-jp?B?bStpOHlubG5sdjg4QUZOTUZiWVFxWmdUZHV4S0JFMnp3eFZPUisvb1ZT?=
 =?iso-2022-jp?B?SzAyU2c9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 186d6902-19cf-471c-77de-08d9b9743172
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 11:24:54.5769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUn6s5w9MJ2CqGq5O4cCgiYvqO84Ym23TOiEo6qDdzZ95ESrP2/VbPQu2fIWpXvD/4m/aTRXlf2at+AM8rmeWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4429

> Subject: Re: [ndctl PATCH v2 00/12] Policy based reconfiguration for daxc=
tl
>=20
> On Mon, 2021-12-06 at 15:28 -0700, Vishal Verma wrote:
> > Changes since v1[1]:
> > - Collect review tags
> > - Fix 'make clean' removing the reconfigure script from the source tree
> >   (Fenghua, Qi)
> > - Documentation wordsmithing (Dan)
> > - Fix line break after declarations in parse-configs.c (Dan)
> > - Move daxctl config files to its own directory, /etc/daxctl/ (Dan)
> > - Improve failure mode in the absence of a configs directory
> > - Rename {nd,dax}ctl_{get|set}_configs to
> >   {nd,dax}ctl_{get|set}_configs_dir
> > - Exit with success if -C is specified, but no matching config section
> >   is found.
> > - Refuse to proceed if CLI options are passed in along with -C (Dan)
> > - In the config file, rename: s/[auto-online foo]/[reconfigure-device f=
oo/
> >   and s/uuid/nvdimm.uuid/ (Dan)
> > - Teach device.c to accept /dev/daxX.Y instead of only daxX.Y and thus
> >   remove the need for a wrapper script that systemd invokes (Dan)
> >
> > These patches add policy (config file) support to daxctl. The
> > introductory user is daxctl-reconfigure-device. Sysadmins may wish to
> > use daxctl devices as system-ram, but it may be cumbersome to automate
> > the reconfiguration step for every device upon boot.
> >
> > Introduce a new option for daxctl-reconfigure-device, --check-config.
> > This is at the heart of policy based reconfiguration, as it allows
> > daxctl to look up reconfiguration parameters for a given device from
> > the config system instead of the command line.
> >
> > Some systemd and udev glue then automates this for every new dax
> > device that shows up, providing a way for the administrator to simply
> > list all the 'system-ram' UUIDs in a config file, and not have to
> > worry about anything else.
> >
> > An example config file can be:
> >
> >   # cat /etc/ndctl/daxctl.conf
>=20
> Missed updating this, it should be /etc/daxctl/daxctl.conf
>=20
> >
> >   [reconfigure-device unique_identifier_foo]
> >   nvdimm.uuid =3D 48d8e42c-a2f0-4312-9e70-a837faafe862
> >   mode =3D system-ram
> >   online =3D true
> >   movable =3D false
> >
> > Any file under '/etc/ndctl/' can be used - all files with a '.conf'
> > suffix
>=20
> And this should be '/etc/daxctl/'
>=20
> > will be considered when looking for matches.
> >
> > These patches depend on the initial config file support from Qi Fuli[2]=
.
> >
> > I've re-rolled Qi's original patches as the first five patches in this
> > series because of a change I made for graceful handling in the case of
> > a missing configs directory, and also to incorporate review feedback
> > that applied to the dependant patches. Patch 6 onwards is the actual
> > v2 of the daxctl policy work.
> >
> > A branch containing these patches is available at [3].
> >
> > [1]:
> > https://lore.kernel.org/nvdimm/20210831090459.2306727-1-vishal.l.verma
> > @intel.com/
> > [2]:
> > https://lore.kernel.org/nvdimm/20210824095106.104808-1-qi.fuli@fujitsu
> > .com/
> > [3]: https://github.com/pmem/ndctl/tree/vv/daxctl_config_v2
> >
> > QI Fuli (5):
> >   ndctl, util: add iniparser helper
> >   ndctl, util: add parse-configs helper
> >   ndctl: make ndctl support configuration files
> >   ndctl, config: add the default ndctl configuration file
> >   ndctl, monitor: refator monitor for supporting multiple config files

Hi Vishal,

Thank you very for the work.
I made a patch[1] to fix test/monitor.sh for the new style config file.
Could you please also pick it?

[1] https://lore.kernel.org/all/20210914024119.99711-1-qi.fuli@fujitsu.com/

Best,
QI Fuli

> >
> > Vishal Verma (7):
> >   ndctl: Update ndctl.spec.in for 'ndctl.conf'
> >   daxctl: Documentation updates for persistent reconfiguration
> >   util/parse-config: refactor filter_conf_files into util/
> >   daxctl: add basic config parsing support
> >   util/parse-configs: add a key/value search helper
> >   daxctl/device.c: add an option for getting params from a config file
> >   daxctl: add systemd service and udev rule for automatic
> >     reconfiguration
> >
> >  .../daxctl/daxctl-reconfigure-device.txt      |  75 ++
> >  Documentation/ndctl/ndctl-monitor.txt         |   8 +-
> >  configure.ac                                  |  18 +-
> >  Makefile.am                                   |   8 +-
> >  ndctl/lib/private.h                           |   1 +
> >  daxctl/lib/libdaxctl.c                        |  39 +
> >  ndctl/lib/libndctl.c                          |  39 +
> >  daxctl/libdaxctl.h                            |   2 +
> >  ndctl/libndctl.h                              |   2 +
> >  util/dictionary.h                             | 175 ++++
> >  util/iniparser.h                              | 360 ++++++++
> >  util/parse-configs.h                          |  53 ++
> >  daxctl/daxctl.c                               |   1 +
> >  daxctl/device.c                               | 174 +++-
> >  ndctl/monitor.c                               |  73 +-
> >  ndctl/ndctl.c                                 |   1 +
> >  util/dictionary.c                             | 383 ++++++++
> >  util/iniparser.c                              | 838
> ++++++++++++++++++
> >  util/parse-configs.c                          | 150 ++++
> >  Documentation/daxctl/Makefile.am              |  11 +-
> >  Documentation/ndctl/Makefile.am               |   2 +-
> >  daxctl/90-daxctl-device.rules                 |   1 +
> >  daxctl/Makefile.am                            |   9 +
> >  daxctl/daxdev-reconfigure@.service            |   8 +
> >  daxctl/lib/Makefile.am                        |   6 +
> >  daxctl/lib/libdaxctl.sym                      |   2 +
> >  ndctl.spec.in                                 |   4 +
> >  ndctl/Makefile.am                             |   9 +-
> >  ndctl/lib/Makefile.am                         |   6 +
> >  ndctl/lib/libndctl.sym                        |   2 +
> >  ndctl/ndctl.conf                              |  56 ++
> >  31 files changed, 2467 insertions(+), 49 deletions(-)  create mode
> > 100644 util/dictionary.h  create mode 100644 util/iniparser.h  create
> > mode 100644 util/parse-configs.h  create mode 100644 util/dictionary.c
> > create mode 100644 util/iniparser.c  create mode 100644
> > util/parse-configs.c  create mode 100644 daxctl/90-daxctl-device.rules
> > create mode 100644 daxctl/daxdev-reconfigure@.service
> >  create mode 100644 ndctl/ndctl.conf
> >
> >
> > base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e

