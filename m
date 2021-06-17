Received: from esa19.fujitsucc.c3s2.iphmx.com (esa19.fujitsucc.c3s2.iphmx.com [216.71.158.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157BC72
	for <nvdimm@lists.linux.dev>; Thu, 17 Jun 2021 00:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1623889591; x=1655425591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JbW4rikP2k4hFugs48ff+HjD4dAyrqYjA4+5vUVgXPY=;
  b=Kk8/MxxVqQgrBD4dwaMiPXgm4wbLIY3nc97dqfZa4NtRoVMKcMoxNTtb
   qYM85/QN5nY/1DHXamMeYAlBe5zvbJeYxjFyXXD3JzAb8YkgDcvqjEcJZ
   F3XzTfAfmdxHBgkzwwA2gX9QHEaZGWYG8UR3GZL4AsrzcO4GEDpONdjil
   bzjOPhGbrUQnyqqUjQrlnZMMvlTjuVG4cWQkE93xqlwh3B6DqsYnhBGoh
   3PbR+Av7jhvCyHizCjdvNAj5agt7/vMpU43lH6n6+ZmK4s8bEbm3loepS
   XoM0ZDctgVZirU7sgZZEkE1oCYjgG6EZIs7K1FRlRPFmcxidFSemSgXig
   Q==;
IronPort-SDR: GBWZ3VVRMg1SIzVsf6jupohnKoFmjDqK2BsWIPlCMdgg703piz3quHM9ZZ5IvmSkQAn1EfG+Jr
 5RczhQLdKQ8nfo2jsZ/a8M7vFDtb38dTT6z+OjauvkF8BbKi45yFZzQSouzbwRiKX2+2jV1QCf
 KvzZqmjndwlEQ4ZEAIxTL6kYKtfHrh1OZ9vKeTGXFrqod640v+klXYTuKcQqsZrWxmaoZnw0TD
 yLAps7fC1pmBtiO8cehn4tMV3Xv2B3qyBF7a8p5JC3Aj1snu5HK/ushTKStUQ1naH5sCO4wpqB
 JLw=
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="33034177"
X-IronPort-AV: E=Sophos;i="5.83,278,1616425200"; 
   d="scan'208";a="33034177"
Received: from mail-ty1jpn01lp2052.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.52])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:25:19 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ri8PqE4Apz7BTCl139ibvidHZAvZlyzk86nXtzaGncG/MyeTU7y5Mvx+7mLqhaLnc+aMF27UvX4DrfODoq0Lx4TNbA5fkbT6jajYJH7syQuyOV438obmGd/LwUGrzjTp6ZTXt2x65KSZwyKUSiga+Bpk0iZ6u3dbTNMZCYFHoERJrEYwNvKBnhq843H+ldg1K1bSszRNrTfoUgjNzZtxKHcguuyKsOzck8EvZEpgq6TQrEuqnsj3svTMkuEoABgcStwG9JGQSR9tvdxXVWt8qdvrmSSWC9RpVoppqX+WKF4GeGWpnLo8GIbpmT2nhW/RRAWOu25VQQQGgDKPKdkKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbW4rikP2k4hFugs48ff+HjD4dAyrqYjA4+5vUVgXPY=;
 b=lR50QLPhlZqs0aW3f5ZCvhslyuvBHjl2CLtkVFGSNIeTCDippenz4maslSt8B3sZE1XzCkHKyIdKwV7w8GNIQ1j1MVDn/F0urdb7tabRpyrJqk/ZRMBq+Sd0rwbZxsjUlJKEjSd23uCRazaL1o4WO06QzPEXEAdteqL6wsZM/B2sEijxPv7Hd4o1xgvMz8u4lKw9bR1giRUrnyKyDgAKWw3eIGxf1wg9wdGKUVh37Q0QnSXLfWyKErBbmM1Tp9J4TWQEwjXflACTSz5ftD0oxGvKCddf2tRQSCAMxYb7NUeTFJF25XgWdI+Y4ZjsYsimFISquDzqVFfnZStouBS3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbW4rikP2k4hFugs48ff+HjD4dAyrqYjA4+5vUVgXPY=;
 b=OpsF4Lr1Fy0eQ+XjiEJtfjTu1rNrNP13+oWTER9bePh18iXF6wzbEj7nUQrHFhpbnfdH8rM0TfEJHr7h0KKpgBfU+qzZp0hT4XX1OyQtNINHmVA1WuT8oix8G3q9dKkK6JVh0EuUjJoX34bcwv8ZBW/H7IphH3Z4VYKrEkFk+vk=
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com (2603:1096:400:7b::10)
 by TYCPR01MB6994.jpnprd01.prod.outlook.com (2603:1096:400:bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Thu, 17 Jun
 2021 00:25:16 +0000
Received: from TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a079:f51b:4299:eec3]) by TYCPR01MB6461.jpnprd01.prod.outlook.com
 ([fe80::a079:f51b:4299:eec3%8]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 00:25:16 +0000
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "fukuri.sai@gmail.com" <fukuri.sai@gmail.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: RE: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Topic: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Index: AQHXSqlGQa6cB4aEX0uPJPfjJ31HHqsAS6aAgAC81wCAAAgHAIAWdfGw
Date: Thu, 17 Jun 2021 00:25:16 +0000
Message-ID:
 <TYCPR01MB6461A39B4E076F0921335904F70E9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
References: <20210516231427.64162-1-qi.fuli@fujitsu.com>
	 <0e2b6f25a3ba8d20604f8c3aa4d8854ade0835c4.camel@intel.com>
	 <CAPcyv4inknvApE1xZOiK8u2xPLejuqixf_XKbS05fPKvno+Yyg@mail.gmail.com>
 <98516fb56623180b78bce2a6a15103023a59b884.camel@intel.com>
In-Reply-To: <98516fb56623180b78bce2a6a15103023a59b884.camel@intel.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [218.44.52.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78baabe4-90e9-4587-219f-08d9312661a8
x-ms-traffictypediagnostic: TYCPR01MB6994:
x-microsoft-antispam-prvs:
 <TYCPR01MB6994DD30B68E20A14E66D65FF70E9@TYCPR01MB6994.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Dd/K2PDG7O3MfGLKPhHjgD6puSgNaF/JMCC2FsXhbJqj52TZbfjrnQYCLG7b37fBsKVUcW32aibICRU8ndWsD3pOrpkDRZ1n6ndmWIaK6CnRZtVOd7tG9H1s92O5lW4GUDHVUV8B7T5fyLby4DL3csOw0D96QFN11a8WdznKnb4zY0wvf6SGnwUV+sfCy/K5m+FSGZCBwtH3uC6TB0/CC8uympbMydZ7Z6C48LZkty6UIJoow7LayIhWr3xBxD1x78wsxXsAGB6V3QY3K6iyBcn/olefZAHemuhYphE1AoZVtso3kEgGBTWWuUYQC7vP+rOWb/zb2Jyuc3bb0IjDpLwAIyuvlYO/LFbf0XpUBPkZ02FToE4XN9rzMz0U9Fb11desxW2Jt5P0QjIxJcr+7iTvwyDSt9FbdGdO/yHQZXGnluqVhxqjiFwkbrpMUTsMkCsEsEtj6mWT9YbbA4ZplK+j0r27xssfqhzBFTFC0ziVDTMMcNFmHga4lUQHX8Fus8EAhI7nsQnRtI9wXj975A9SR226NTdsgJY+i1S3j/xeJx9RCQWutTaMAQXGXQ7cNgScfSAKCdalmvb1yhImDK6/X2UDnTgdJuQ4/pyhQDk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6461.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(85182001)(71200400001)(33656002)(7696005)(86362001)(53546011)(6506007)(186003)(26005)(54906003)(4326008)(83380400001)(5660300002)(122000001)(110136005)(316002)(38100700002)(55016002)(9686003)(66946007)(76116006)(478600001)(52536014)(66556008)(66476007)(66446008)(2906002)(8936002)(8676002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?RVlXSjIzcDYrOU50SVM5eWZZazk1ZTlRZStQaS9QS0IxZzVsWUtKZjl0?=
 =?iso-2022-jp?B?OWdtTlMzbUVuZUVwcXlRb0dCTDQ5WUYvQjFpUVlrRXloTHlSQXVXVTZC?=
 =?iso-2022-jp?B?NFFXN29UZk1ILzlTY2JpQ3NSQ1N3cjlxL0pTSWIzTGI5TTBBTzkxS1E3?=
 =?iso-2022-jp?B?Nmg1TG5UL20rUnZZWGJyMkcrMzQxYnJnbElCMnJweEROb1RtajhXaWo2?=
 =?iso-2022-jp?B?TFpHZUMzMTFYU0dTeUo0VmZRSlN3U3BiZ3RnS2hYNTA2MWdLaGduNVBS?=
 =?iso-2022-jp?B?QXZGcjhPNnlsMHZLRDBUMmFyYVJmSFFDa1hIaDhZU3NFTm5za3lmVi9K?=
 =?iso-2022-jp?B?ak5VR0x6K045STBoVlJjcjFaS1ZGaTUvd2FrcGc3dVNGSlcvaEtaUmdP?=
 =?iso-2022-jp?B?cy9pYzRMUFBQdDZKU3prZ2tNMzBkczY5eEtLWlBtWmxlL1hsN3VCRUx6?=
 =?iso-2022-jp?B?QnZQS3JhMURsckJLNHBmOU9VTjFYYmVuTTNjWlNjQ1gwTTZsV0krWDNa?=
 =?iso-2022-jp?B?RlhZWFM5N2kxSmp2RkhGb292TSttRlFFeitua3QwUkNSTEVJc1FmOENa?=
 =?iso-2022-jp?B?Ukl5SDlvZXlrUlZ4VHYvQWN1RGJuNlp1bmRzTG5sNDFseUlXL2loRFFa?=
 =?iso-2022-jp?B?VWF5dVFnRGVBREpzTEl6cWxzRmxETytNZnB2WTVDNnhJc3hXVTBRTEp6?=
 =?iso-2022-jp?B?dTVvdmQrSkhwMkhXVGQ0UzJlWWd0eXdIaGU5NzBtb3NMM1M4cStHcThG?=
 =?iso-2022-jp?B?MjZ0eXFJU1JXSVljcW9aRmJaTFhWc2wvMkVpYXQwNGFpWkRuMUxRclZt?=
 =?iso-2022-jp?B?c1Y1RXdQMVNrUEd6bzEwWnkyRktMa1NWU0U1czd0b2ROOUdoelpHYnVx?=
 =?iso-2022-jp?B?eFZoQlhGSW9DQWdKQm5Ud281QVkyS3JKaCtnVkhpeHd0clVUK0VsWWFL?=
 =?iso-2022-jp?B?cDFQSjlGNWplSVE5WXpmM283amp2NUhnY3A2dTNNTjRpVUc4NzlMNGhz?=
 =?iso-2022-jp?B?ZUI3cldwTUF5dGszRmJwQ01PM0Z2MmVxc1JQS2paMm9Zd2hTazQ2cWxL?=
 =?iso-2022-jp?B?RTNrTndXUi8zWjcycFcvU2NHUEk2ZlZ5NW4yMlZ6MDlmWml4MnVwYWlQ?=
 =?iso-2022-jp?B?OUpwSTVYRlU4dGtEemdhUFJNMFJLdkVuNXdLVDQ5NFdGNmxFcnhVczBL?=
 =?iso-2022-jp?B?eExUclYvRTc1WmI5ODU3MlhFblI1NFpSQmJGbVAvS3VpVGZZeWgvRFBK?=
 =?iso-2022-jp?B?bWFTY0Q4SGNYL082aHhDdWZYMFExeWYxZUVuQzhGTGVQWlJER01mdlZn?=
 =?iso-2022-jp?B?WUd2VnZqSm9sYjdoaFRyZ1I1WnNna0ZMM2xxL2NwSzlaSVlBVUEzc010?=
 =?iso-2022-jp?B?WGUzZk1HNlhMSW9oUkx6REZ5bk9FTk1xbnVJSGt0WmpYM2F2V1pKUU1Y?=
 =?iso-2022-jp?B?dHFhcmxhaG1BMVk4Nm9hYnNRTUtsbHVDS01mNzB2bHZxZzZHYWtXdmM4?=
 =?iso-2022-jp?B?U2krZ1NrMlpqRFp4V2h3T0dQM09OYmpzL1g4WURyWXFMVkRVdkFtTzhu?=
 =?iso-2022-jp?B?Z3EzM04wM0JpZ2VRNVVlNnBNckE4MGd1T25ZZ2FpM0llaUdGejFGQ3l3?=
 =?iso-2022-jp?B?ZDBVL1ZaS0pXRXJpWW5URUthdVlPL0Yzd3BxWTlTek9rTmFFeWowQVAr?=
 =?iso-2022-jp?B?QllPK3hUTkx6YTh1enUrb2R1aHBWY05rY2RxVnpOTEczd1IxM2RWQTdz?=
 =?iso-2022-jp?B?UVF5bmEyWXJjVjF0bzFBM3F0YUx1VTZnUG9KTk0vdjhxczhlZ2tqcE93?=
 =?iso-2022-jp?B?bG10THFNU0ZoSElWNC96WlY0TFhsbHlKMWs1ZU9JSkMwWjFIZU5VZEk5?=
 =?iso-2022-jp?B?L1k2ZU1IeDNLZjdZdUV0RDdjZnZzPQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6461.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78baabe4-90e9-4587-219f-08d9312661a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 00:25:16.5198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x+gQGUIvk8QSeaK//ytO1N1tI45vpRkEISH3DIxSMVlLQlzWUcqUSKK5+fe0ibs6Ngs+6JWBcerF/vRqDx/Rig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6994

> On Wed, 2021-06-02 at 09:47 -0700, Dan Williams wrote:
> > On Tue, Jun 1, 2021 at 10:31 PM Verma, Vishal L
> > <vishal.l.verma@intel.com> wrote:
> > >
> > > [switching to the new mailing list]
> > >
> > > On Mon, 2021-05-17 at 08:14 +0900, QI Fuli wrote:
> > > > From: QI Fuli <qi.fuli@fujitsu.com>
> > > >
> > > > This patch set is to rename monitor.conf to ndctl.conf, and make
> > > > it a global ndctl configuration file that all ndctl commands can re=
fer to.
> > > >
> > > > As this patch set has been pending until now, I would like to know
> > > > if current idea works or not. If yes, I will finish the documents a=
nd test.
> > > >
> > > > Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>
> > >
> > > Hi Qi,
> > >
> > > Thanks for picking up on this! The approach generally looks good to
> > > me, I think we can definitely move forward with this direction.
> > >
> > > One thing that stands out is - I don't think we can simply rename
> > > the existing monitor.conf. We have to keep supporting the 'legacy'
> > > monitor.conf so that we don't break any deployments. I'd suggest
> > > keeping the old monitor.conf as is, and continuing to parse it as
> > > is, but also adding a new ndctl.conf as you have done.
> > >
> > > We can indicate that 'monitor.conf' is legacy, and any new features
> > > will only get added to the new global config to encourage migration
> > > to the new config. Perhaps we can even provide a helper script to
> > > migrate the old config to new - but I think it needs to be a user
> > > triggered action.
> > >
> > > This is timely as I also need to go add some config related
> > > functionality to daxctl, and basing it on this would be perfect, so
> > > I'd love to get this series merged in soon.
> >
> > I wonder if ndctl should treat /etc/ndctl like a conf.d directory of
> > which all files with the .conf suffix are concatenated into one
> > combined configuration file. I.e. something that maintains legacy, but
> > also allows for config fragments to be deployed individually.
>=20
> Agreed, this would be the most flexible. ciniparser doesn't seem to suppo=
rt
> multiple files directly, but perhaps ndctl can, early on, load up multipl=
e
> files/dictionaries, and stash them in ndctl_ctx. Then there can be access=
or
> functions to retrieve specific conf strings from that as needed by differ=
ent
> commands.

Thank you very much for the comments.

I also agree, and I am working on the v2 patch set now.
I found that the style of ndctl.conf is different from monitor.conf, since =
there is no section name in monitor.conf.
Do I need to keep the legacy style in monitor.conf, i.e. Can I add the sect=
ion name [monitor] to monitor.conf?

Best regards,
QI
