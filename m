Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9E5373BE8;
	Mon, 10 Aug 2026 07:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=3.65.3.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786347574; cv=fail; b=MriSasd5iAxRqaay4KVhDKiuX4icTd2RncBh3bkwrSzLQsTEIMe3w9TbyWof4+LljDJHRpaxVQ3j1jrz5P+/egpfbXomVpGjY2hJAiwH0W6Ii1tadFsmg68mXrdpvAsoGPpyDugkqz/vF2y1qf4Ushmieroq0EOuqMCZWNR2q0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786347574; c=relaxed/simple;
	bh=OFJHoQwGunShSF1jO4N0Ffo/15+Sqv0C59n6I7LZ9dg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jMlsY+24L7bgFLMT481pSxgnBDjgNxMs3O2sVEmCR9Ut4Iu1eUK6dKEQtpRF1tlu48B/IlkAmfeSuqwrm2D3WykdAsMoHm1H0ExPmR/EQOIsllmVILBF9LvGHAYPbu46xmforR+f+JngIzdKJsOESXuzg31RdV89eRVSbiWRzqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=rmaQ+B60; arc=fail smtp.client-ip=3.65.3.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="rmaQ+B60"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1786347572; x=1817883572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OFJHoQwGunShSF1jO4N0Ffo/15+Sqv0C59n6I7LZ9dg=;
  b=rmaQ+B60oyBitRVgYODcAmilJp3NCtbk80LAPx7ELq59UXpuZukvyufg
   9Olixt/HZdUEzePD+cdfi6DKyfBbZIg1aQDDNwBVFV9Lv0iMOm3lV25RT
   qtvpV9KGLPTUlY4xpb/e1Uv5dwAixRg9CTBuQBGyQ2Tcg1xSJdukhY0M1
   hKzHaxOuwiImGZNnTsQegE3lFmopo7j4n58DMLn88rccFJa1+VTMbUWVA
   QJbL4hIKMGl4Hs8/FB2MnYEDlVpjXrbN+3dLRmFo45o3WxwfED1HrGqCq
   5QLVG6uIr0K9oxruUbK0vPkvx8YJpYmyt+aSyPO72NVLte3DwpsFUiTl7
   Q==;
X-CSE-ConnectionGUID: 6dLzfmxETd2DJzBrSQuO0A==
X-CSE-MsgGUID: Iuqjx9U6STiVvka6SnMWTg==
X-IronPort-AV: E=Sophos;i="6.25,215,1779148800"; 
   d="scan'208";a="17646710"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 07:39:06 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:3022]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.72:2525] with esmtp (Farcaster)
 id 99e73119-d724-44d7-82f1-dd1431ae5afe; Mon, 10 Aug 2026 07:39:06 +0000 (UTC)
X-Farcaster-Flow-ID: 99e73119-d724-44d7-82f1-dd1431ae5afe
Received: from EX19EXOEUC002.ant.amazon.com (10.252.51.145) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 10 Aug 2026 07:39:05 +0000
Received: from FR5P281CU006.outbound.protection.outlook.com (10.252.51.199) by
 EX19EXOEUC002.ant.amazon.com (10.252.51.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Mon, 10 Aug 2026 07:39:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9vuo/t+KbEoqtkQ39AR3iOcvQUL2Ef71IP5gGoOS4DIIwDiC/JRflqzftHyb7ViO2GauTKbgzvyhW1SwKSVg/GjfnGQe412GWGRzp5I9pk+DJXptDvbmKOImvAxxwuIyXBySq1Nc4WyGb9bxAeRVkgA2vM7lfFO7lCAeRG0gnc0TbaPURQn/8lFFMBFksqBodcaKECJUm2DfGlrAKP/3jH1ZNSXaw1/4Nv6WsNAHqfTKFbUc14SvTwG6OxATYGyZtZfewMbagsJ1vLuq+V7SBRlfvuPyTWnxoO6wBKF4xRoh1snGiWgX/9WXpwosNO3RV8P8b0qP7mj8E7olz9gjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFJHoQwGunShSF1jO4N0Ffo/15+Sqv0C59n6I7LZ9dg=;
 b=BWhS9mbf1Fbt3C6MvO56GplLXfLFo0k7tFQuw9qZcg/hJZSmUoOHMLvnY4ci3tKoLolc0Y9DATaKGQlqlsxjdoRIB7KeEyt1lv2sB6U5vBVg6oGVTdA9w/aLcpaeaNuI1zLjRtU9DAOnRkfQtUxNRY1YJq1//BcyzpgGQFKmK2MYKBJEBP44yaHVS+f3af2CHG7hE7L/KdDjO5zGp4qMwT2I28p0nn6NHqj8BBm12WuKj7f1dJ3vX6I/LvAl64zJMLHlqfADEzWmSJ/R17XtFlQ39cPxyxWIsYCd92pWV+nL/j4W3xVO3yHsNz1MwSc6uWag+C43qgM0v3oN1h/5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e0::23)
 by FR3P281MB2233.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 07:39:02 +0000
Received: from FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7ad:f028:e0a7:bd4b]) by FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7ad:f028:e0a7:bd4b%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 07:39:02 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowangio@gmail.com>, Alex Williamson <alex@shazbot.org>,
	David Airlie <airlied@redhat.com>, Dmitry Osipenko
	<dmitry.osipenko@collabora.com>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>, Feng Liu <feliu@nvidia.com>, Gerd Hoffmann
	<kraxel@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, Jens Axboe
	<axboe@kernel.dk>, Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet
	<corbet@lwn.net>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Parav Pandit <parav@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Stefan Hajnoczi <stefanha@redhat.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Thread-Topic: [RFC PATCH 00/12] virtio: support devices that own their
 virtqueue memory
Thread-Index: AQHdKJtQEEy8HRZf90m58IdCni7Bqw==
Date: Mon, 10 Aug 2026 07:39:02 +0000
Message-ID: <c56fb4d0-33ef-4e9b-ac18-ac4e896957cd@amazon.com>
References: <20260809182010.32931-1-graf@amazon.com>
 <20260810021450-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260810021450-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRSP281MB6250:EE_|FR3P281MB2233:EE_
x-ms-office365-filtering-correlation-id: 0261e98f-1827-4b90-eecd-08def6b272a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|56012099006|11063799006|10067099003|4143699003|3023799007|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: nFKilH7/WzmgZM1kO6GLpqZfUZD+6af4bq2ug1AOYJgySg7PTnKsT6OfpoOKkvreuHJOZab1DtqUGEfC4eUFsrGN/CRyf/tFxbbo5EOmstWOTIPZgtTifgsczoFoH+ZXIpEcjqwcyw7+s91kR+gje4sM01vTOC9XrWltfjT1caa1fqDvWuICA/tfZrvYzN4S03+S1L0rjrtxPS0C2vvK3YInyH+az4oNZgNIC+IK3vYoR/vE46LLc2nw+k/xr+g8EZJAk8/ubR5m5XnspqMkk3t9hpGHet5MyRtVaMiUAhNTzjI+54doYZNZ2whXd6WzzuVsSZGJkcLwMst+UCh22dHqCnjtbWIwirN8ID8+Nl8TiQZwOg28JNIjy9O3pW/yzSd+lIV5dVjNaJ3DnlVY+exS7b4Zhro45CywheDKBzRaupGiqdlEtqoQmZ8XNIZ7BsoGU6p8/BvnKafD7BBONOi1C/c3G+KdTjoKjqOxiAgKz74ajPMSopUZpmXDW8XTFb1RBk5jxPQLe5l6Q5JlzZfBnJ0SZzBfGvzXbUSdh0W1rj/7K5TMu+doEygsg9W4aXKo7+1SrVJKlslV54jb7zXHEDGIpdyidceuD/+bfyWALL9swfcPOP5s5huHfkGbS9fRcLzb+Iu9w1tTNaKUR7MkfCFsiMYxvj1WYBplPWgSr8E7VhdKzQjLtjk4HywCAte7JHNx1oJd4x6liMByy0p6aGqAehWIu0I7ZOGR9f0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(56012099006)(11063799006)(10067099003)(4143699003)(3023799007)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXZNcHFGTFNZZ2ZFQlBWblZGOWM1T2NmMGJxWkEyZVlIQkpuVFYwOFdCVkQy?=
 =?utf-8?B?anJpUUxjUGo0ZGNWdnNSeEFyNzJJanpwUEtTUHRSTUdldVh1Z1ZlT1hURG40?=
 =?utf-8?B?WGNEVDQzajV1UWxtOStWdHc4Nit0dU55TXRsb21XZmdOQ0E0SVQ3NVhqbUJt?=
 =?utf-8?B?SFR3dTNhd1lqNStCdzRBWElIMjJZVXptZ1VlV21XY0xKTXl5Ti9uSWZKV2Jo?=
 =?utf-8?B?eW96S1lyVVM0N2xaSXFwZzlZRjl1S0dnYzRDVWxNK1pGSTYwQnltVExCdDVI?=
 =?utf-8?B?NGcvN3V2cXNpbGNQZWdmOHZUUjZBeUMvOWJlbzVyQmpZVXJYd1I4WmRQSGN5?=
 =?utf-8?B?dXdIR2NRZ2JZQjZqNkpOYnpuM0NvYS9MNGs5STFFZ013eFJVOEtFa3ZlTUtt?=
 =?utf-8?B?RlA1VklJVVBza3JBZFptQWU2WC9YV2ZGY2ltdUNteVpLZ0JWVlpHK1VyZStD?=
 =?utf-8?B?b1R6c3RLek1vVDBpKzNSTU5WS1hFTG5zN0J5c1dkY3IvSlBHbmJZQ3ViY2NX?=
 =?utf-8?B?RitTYWFIZTdoUVc1RndBMGFZV2F0ZExwUjNvK1YvemxrbmVDT0RVVFM3aG54?=
 =?utf-8?B?cE5rbVdCM3RxMjNLVWNybmlDcHFKRGg0NURjSjFwUXFzV3hiMGhaL1pJTnB1?=
 =?utf-8?B?YlR1dEpoZGd0VHg5cktNdjd3R0FvVUo5emkzR21RUk9jb1FqQThGSjRsKzBt?=
 =?utf-8?B?OHNNK0FqVFovU0tWVUZoaGZXMnBHRVJGeGFOSHBzZ0dINWF5dituS0NRMDRl?=
 =?utf-8?B?YjVYaXoxNDNxbDloUlNvaVBjb0V2clFBaURVbityeUlNZWd6SFRZSWtEbWYv?=
 =?utf-8?B?dmE5bnBvNU4yMk5oM1VEVlRXNkJ1TGVnTTZFdjVpMStSVFJLQkxhWHZOUWNT?=
 =?utf-8?B?U1hIZzR6ZW1HRWE2RHZHVFVHTUNlSXhCU2JVU0xFcE03WUJaVi9yT01tVUJR?=
 =?utf-8?B?dFBOYjl0cEpydzVBL2FvVWpXaUFBekNTUFVVZTl3eS9qUEVMd2ZYMVlCOGRx?=
 =?utf-8?B?N0t2ZjZMV3IvZTJJZnpiREcwOWdFbTFocWsrRytWOUpJdWVBaWZJZXpuMmhm?=
 =?utf-8?B?U1lGM3hnTUx2dTk2K1RtSVNia1E2TkE2UlV0M3YvRVFkZzVQVHp3L21UUy9o?=
 =?utf-8?B?MEdPU2UzWllEaTRYc3AzQTRPUGpCY0YzMFNTN2xRaFdSQmwrWVZrdmRIWjNM?=
 =?utf-8?B?UEo0ODQ4bnlEZVRWcWQ2MXRzTmloTnlPdHVhNXRVUUdGdjBYemFoQndORTla?=
 =?utf-8?B?VU5Rc1gwNWpCMExDeXdIVEJMRGFQNW9qbjFKRU9NTklENE1GOHRmUHQ1SzI4?=
 =?utf-8?B?NkEvRDJoL0FPUWtabURnWXNmM2VMOGswQVlvQjhDRlFnWW5OWlIvL0lnRWw3?=
 =?utf-8?B?NDJ2N0cxeUUzempLdWNnU1dqUEpmS1A4TVFmUlBaWjJmbnlhOTZaQVp1bE9M?=
 =?utf-8?B?Q0FrTDc5NkNodUw5cy9abG91QUpBQWZmSWNaMGhyQ1BTaVN5bmhPZmV5VzJa?=
 =?utf-8?B?ckpNL0lKcE1mWC8zR1lqWXlITHFiRmZDREhaYTlrOTVWNmdVVXdoZ0k4bnhC?=
 =?utf-8?B?M3JKS2lSQW80RnFia24vYUZ4aFNhRmJRQXNnZDYzTW9rRG5xR0E3NFB4VUVr?=
 =?utf-8?B?bkhMdmhvWFFjNW1FcDlLempETDZPaFdDazd6WklaOUE1OU9nOHVWUG5CdFU3?=
 =?utf-8?B?RStsS3V4NWcrUUxpN3pic0pCelpOZzdFeHliSytFQ2haUVpiSTYvd2dlc1BJ?=
 =?utf-8?B?eEZwUnBvd3NFUjZoRTQ1cDcxUS9zTmpNVE5SU1ZQS3pNNFZXRlJmSGZqeUlO?=
 =?utf-8?B?K2JCakdUUTUwckVRbXJJVEowd3krcXhMaCsxNFpMSDRiS3pMVkF2MHBUZDFF?=
 =?utf-8?B?enhmNzVhWTJzS3huSHA1TnlRMnBRa3JyQWE3M21xU3BlcXJVUDJIb21PNHZ4?=
 =?utf-8?B?ZktOQmlrYVViN1o1MlNDL3A0TEVSSDEvMWZlWHZ6VFkwMXJyL3pnTjVVcXdp?=
 =?utf-8?B?REJBcE1UVnhyOGRaSk9zN2J0eVNtb29PRVZ6RTBzbUZjSVgxQVRTUXg4c2cr?=
 =?utf-8?B?OGd0NTNqdWtHc3FYa01Qblo4MHVaM3hiRWFpbVdzR25LVDB2QUYzcnZMOG1t?=
 =?utf-8?B?SmthK2t1bWZCcmh6Z3IrNityZGlZLzRwQzRscGlaaHpyVENGV1A2ZzZVZ1My?=
 =?utf-8?B?UTVBeFBuZnVwVmRIZEVqWFZnRWs1WkxSdzhLaVRQWUdJZFludjErNmI3Umlo?=
 =?utf-8?B?Z0I1QlE2Zkh5cEgyUi9URm5ITDdMZGc0cVhvMlhGcHNJNjc2dFJDNy9BdVA4?=
 =?utf-8?Q?wSARzNXywkU2jsOUyZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC956714685E764FB3B30B1E1650794E@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: AzNwe7MCGpaLHhnsjfnyE/zSpdUv5McWK+XO0UTCRrnT5eUlDVilZAlKdJYCYAH0kmFLS3dIx0jt85ne8q6xj1wM7FoOBWu+v8T051mJZgfQBAUy3oxvSlMu4LP3VRN+lERPm09c/QERFbFFFFGSGVqLOU14Tcr2aILSiwp/H4I833YN9Mx4j493N9f3OpviRhn+m6uDS0h6CFs1wHhZ4iNnj6UbrhIJZKBdXmQkE/EwXGcEJJwIh4TKxzL+vTEf5BWg35vJIA7zGB0vaT7jXfZb6RhTIpznuLwgZ4BprKNf8XJtgV1jveNLf7A/xIGeTHTKEjybLW2fqsi4bj4d9w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRSP281MB6250.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0261e98f-1827-4b90-eecd-08def6b272a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2026 07:39:02.0309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22uXN+JVw3JptSG1DKCodpbVFyUKeAbwJ1IPtSaTnPArgQE2acQGPaY2zjTIwhPD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB2233
X-OriginatorOrg: amazon.de

SGV5IE1pY2hhZWwsDQoNClRoYW5rcyBhIGJ1bmNoIGZvciBoYXZpbmcgYSBkZXRhaWxlZCBhbmQg
cXVpY2sgbG9vayENCg0KT24gMTAuMDguMjYgMDg6MjMsIE1pY2hhZWwgUy4gVHNpcmtpbiB3cm90
ZToNCj4gT24gU3VuLCBBdWcgMDksIDIwMjYgYXQgMDY6MTk6NThQTSArMDAwMCwgQWxleGFuZGVy
IEdyYWYgd3JvdGU6DQo+PiBWaXJ0aW8gZHJpdmVycyB1c2UgZ3Vlc3QgbWVtb3J5IHRvIGJhY2sg
dmlydHF1ZXVlcyBhbmQgdGhlaXIgYnVmZmVycy4NCj4+IFRoYXQgbWVhbnMgYSBWTU0gbmVlZHMg
dG8gYmUgYWJsZSB0byBtYXAgZ3Vlc3QgbWVtb3J5LiBUaGF0IGlzIG9rIGluIHRoZQ0KPj4gbm9y
bWFsIHZpcnQgY2FzZS4gSXQgZ2V0cyBpY2t5IHdpdGggY29uZmlkZW50aWFsIGNvbXB1dGluZyAo
d2hlcmUgd2UgdXNlDQo+PiBzd2lvdGxiIGFzIHdvcmthcm91bmQpIGFuZCBpdCBkZWZlYXRzIHRo
ZSBwdXJwb3NlIG9mIGlzb2xhdGVkIHZob3N0LXVzZXINCj4+IGJhY2tpbmcgZGV2aWNlcywgYmVj
YXVzZSB0aGV5IGVuZCB1cCB3aXRoIGZ1bGwgUkFNIGFjY2VzcyB0byB0aGUgZ3Vlc3QuDQo+Pg0K
Pj4gU28gaW5zdGVhZCwgSSdtIHByb3Bvc2luZyBhbiBleHRlbnNpb24gdG8gdmlydGlvIHdoaWNo
IGFsbG93cyBpdCB0byBnaXZlDQo+PiBlYWNoIHZpcnRpbyBkZXZpY2UgaXRzIG93biBkZWRpY2F0
ZWQgbWVtb3J5IHJlZ2lvbiB0byBjb21tdW5pY2F0ZSB3aXRoIHRoZQ0KPj4gaG9zdCwgY2FsbGVk
IERNQiAoRGV2aWNlIE1lbW9yeSBCdWZmZXIpLiBBIHRydXN0ZWQgaHlwZXJ2aXNvciBjYW4gZm9y
Y2UNCj4+IERNQiB0byBiZSBwcmVzZW50LCB3aGljaCB0aGVuIGVuYWJsZXMgc2FmZXIsIG1vcmUg
aXNvbGF0ZWQgYW5kIHJlc2lsaWVudA0KPj4gY29tbXVuaWNhdGlvbiBiZXR3ZWVuIGd1ZXN0IGFu
ZCBob3N0Lg0KPj4NCj4+IFdpdGggRE1CLCB0aGUgZGV2aWNlIHByb3ZpZGVzIGEgc2hhcmVkIG1l
bW9yeSByZWdpb24gdGhhdCBib3RoIHBhcnRpZXMNCj4+IGFncmVlIGlzIHRoZSBmdWxsIG1lbW9y
eSBtYXAgYm90aCBoYXZlIGFjY2VzcyB0by4gQWxsIG1lbW9yeSBvZmZzZXRzDQo+PiB0aGF0IHBy
ZXZpb3VzbHkgd291bGQgaGF2ZSBiZWVuIGludG8gZ3Vlc3QgUkFNLCBhcmUgdGhlbiBvZmZzZXRz
IGludG8NCj4+IHRoaXMgc2hhcmVkIG1lbW9yeSBidWZmZXIgcmVnaW9uLiBPbmUgbmljZSBwcm9w
ZXJ0eSBvZiB0aGlzIGlzIHRoYXQgaXQNCj4+IGlzIGEgZ2VuZXJpYyBtZWNoYW5pc20gaW4gdGhl
IHZpcnRpbyB0cmFuc3BvcnQgbGF5ZXIsIHNvIGhpZ2hlciBsZXZlbA0KPj4gZHJpdmVycyB3b3Jr
IHVubW9kaWZpZWQuDQo+Pg0KPj4gSSB3YXMgZXhwbG9yaW5nIHRvIHVzZSBzd2lvdGxiIGluc3Rl
YWQgdG8gY3JlYXRlIGluZGl2aWR1YWwgcG9vbHMuIEJ1dA0KPj4gdGhhdCBhcHByb2FjaCBoYXMg
bXVsdGlwbGUgZG93bnNpZGVzOg0KPj4NCj4+IDEuIFN3aW90bGIgaXMgYW4gT1MgcHJpbWl0aXZl
IHdoaWNoIGlzIG5vdCBhdmFpbGFibGUgaW4gYWxsIE9wZXJhdGluZw0KPj4gU3lzdGVtcy4gRE1C
IGhvd2V2ZXIgbGl2ZXMgaW4gdGhlIHZpcnRpbyB0cmFuc3BvcnQgbGF5ZXIsIHdoaWNoIG1lYW5z
IHdlDQo+PiBjYW4gYWRkIHN1cHBvcnQgZm9yIGl0IGluIGFueSBPUyBpbmRlcGVuZGVudCBvZiBn
ZW5lcmljIGxheWVycy4gVGhpcw0KPj4gaGVscHMgd2l0aCBXaW5kb3dzIHN1cHBvcnQuDQo+DQo+
IEhvdyBkb2VzIGl0IGhlbHAsIGlmIHlvdSBhcmUgZ29pbmcgdG8gcHV0IGEgcG9vbCBpbg0KPiB0
aGUgZHJpdmVyLCBwdXQgYSBwb29sIGluIHRoZSBkcml2ZXIuIE1heWJlIHdpdGggdmlydGlvIG1l
bSB0bw0KPiBzaW1wbGlmeSBhbGxvY2F0aW9uLg0KDQoNCkknbSBub3Qgc3VyZSBJIHVuZGVyc3Rh
bmQgdGhlIHN1Z2dlc3Rpb24gOikNCg0KDQo+DQo+PiAyLiBXZSBtdW5nZSBETUEgc3BhY2UgdG9n
ZXRoZXIuIERNQiBwcm92aWRlcyBhIHNlcGFyYXRlIERNQSBzcGFjZSBwZXINCj4+IHZpcnRpbyBk
ZXZpY2UuIFRoaXMgbWVhbnMgd2UgY2FuIGZvciBleGFtcGxlIGltcGxlbWVudCBhIGRldmljZSBp
bg0KPj4gdmhvc3QtdXNlciBhbmQgZ2l2ZSB0aGUgaW1wbGVtZW50aW5nIHByb2Nlc3Mgb25seSB2
aXNpYmlsaXR5IHRvIHRoZSBETUINCj4+IHJlZ2lvbiwgbm90IGFsbCBvZiBndWVzdCBtZW1vcnku
IFRoYXQgcmVkdWNlcyB0aGUgZXhwb3N1cmUgdGhlDQo+PiB2aG9zdC11c2VyIHByb3ZpZGVyIGhh
cywgaW1wcm92aW5nIHNlY3VyaXR5Lg0KPj4NCj4+IDMuIERldmljZXMgY2FuIG9wdC1pbi4gQSBo
eXBlcnZpc29yIGNhbiBjaG9vc2UgdG8gdXNlIHN0YW5kYXJkIHZpcnRpbw0KPj4gc2VtYW50aWNz
IGZvciBzZWxmLWltcGxlbWVudGVkIGRldmljZXMgKGUuZy4gTlNNKSwgd2hpbGUgcmVxdWlyaW5n
IERNQg0KPj4gZm9yIGRldmljZXMgaW1wbGVtZW50ZWQgYnkgbGVzcyB0cnVzdHdvcnRoeSBwcm92
aWRlcnMuIFRoZQ0KPj4gbm9uLXRydXN0d29ydGh5IGRldmljZXMgZG8gbm90IGdldCBhbnkgdmlz
aWJpbGl0eSBpbnRvIHRoZSB0cnVzdHdvcnRoeQ0KPj4gb25lcywgZXZlbiB3aXRoIERNQiBpbiBw
bGFjZSBmb3IgYm90aC4NCj4NCj4gU28gSSBhbSBub3Qgc3VyZSB3aGV0aGVyIHRoZSBpbXBsaWNh
dGlvbiBpcyB0aGF0IGl0J3MgcHVyZWx5IGEgc29mdHdhcmUNCj4gY29uc3RydWN0LiBCdXQgaWYg
aXQgaXMsIGNhbiB3ZSBleHRlbmQgdmlydGlvIGlvbW11IHRvDQo+IGFkZCBhIHdheSB0byBkaXNj
b3ZlciBhbmQgZW5mb3JjZSB0cnVzdCBib3VuZGFyaWVzPw0KPiBBbmQgbWF5YmUgdHJhbnNsYXRl
IG9mZnNldHMgdG8gQkFScywgaWYgdGhhdCBpcyBkZXNpcmVkPw0KPg0KPiBJdCBzZWVtcyB0byBi
ZSB0aGF0IHRoZSByZXN1bHQgd291bGQgYmUgdGhhdCB3ZSBkb24ndCBuZWVkIGZpZGRseQ0KPiBz
cGVjaWFsIGNhc2luZyBpbiB2aXJ0aW8gcmluZyBzcGVjaWZpY2FsbHksIGFuZCBhIGxvdCBvZiB0
aGluZ3MgbGlrZQ0KPiBwcmUtbWFwcGVkIGRtYSB3aWxsIGJlZ2luIHRvIHdvcmsuDQoNCg0KT24g
dGhpbmcgSSdtIHRyeWluZyB0byBhdm9pZCBpcyBkeW5hbWljaXR5LiBBbnl0aGluZyB0aGF0IGR5
bmFtaWNhbGx5IA0KY2hhbmdlcyB2aXNpYmlsaXR5IG9yIG5lZWRzIHN0YXRlIHRyYWNraW5nIGlz
IHNvbWV0aGluZyB0aGF0IGNhbiBnbyANCndyb25nLiBCeSBrZWVwaW5nIGV2ZXJ5dGhpbmcgc2Vs
Zi1jb250YWluZWQgd2l0aGluIHRoZSBndWVzdCwgSSBjYW4gDQpyZWFzb24gYWJvdXQgd2hhdCBp
cyB2aXNpYmxlIGFuZCB3aGF0IGlzIG5vdCBlYXNpbHkuIEVzcGVjaWFsbHkgZm9yIA0KY29uZmlk
ZW50aWFsIGNvbXB1dGluZywgSU1ITyBzdGF0aWMgd2lucyBvdmVyIGR5bmFtaWMgaW4gZ2VuZXJh
bC4NCg0KT3IgZGlkIEkgbWlzdW5kZXJzdGFuZCB5b3VyIHN1Z2dlc3Rpb24/DQoNCkFzIHRvIHB1
cmUgc29mdHdhcmUgY29uc3RydWN0OiBXaXRoIENYTCwgeW91IGNhbiBpbXBsZW1lbnQgdGhlIGV4
YWN0IA0Kc2FtZSBwcm90b2NvbCBvbiByZWFsIGhhcmR3YXJlIGFzIHdlbGwuIEFsbCBpdCB0YWtl
cyBpcyBjYWNoZSBjb2hlcmVuY3kgDQpvZiB0aGUgQkFSIChvciB3aGF0ZXZlciB0aGUgdHJhbnNw
b3J0IHVzZXMpIHJlZ2lvbi4NCg0KDQoNCkFsZXgNCg==
