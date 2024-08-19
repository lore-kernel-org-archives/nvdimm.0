Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com [216.71.156.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7FF8BFC
	for <nvdimm@lists.linux.dev>; Mon, 19 Aug 2024 03:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.156.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724039182; cv=fail; b=MzcsfP4QeP5vtm0z0QnejVP/oS1uCU9ZtLzrzvL8UmFNyQj/xUbULuHoRx6m+wKUU8Gl1QTieAf9sK9bljh0I1//rDpvAA7p7RfnzRM7tb0tXMQe+/ixPJf34l2l6WqKlQDDjNA+KVD6Qr1Qhj9anQmV1HI6yepGApofk5DwBpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724039182; c=relaxed/simple;
	bh=s1D4Vkh+wtcwwJ9ZFIEuenI41Cb53pKa20rXEE/s02I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uB5FtVlQdP8c0aceIjG03CVCw2oVET6LKVpczHx5QhssLc/As/kgISD8L+7LSWSGFkZTd2jyai8KxcJuMOTIosLUVL3pS4IDNuKbjs1HJ9NPIwfc5V/m3B8OKYWms/ikCYRtahOP5yroW1zgxJmTVufMqCdSQDIhQZjgaxLCmNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=OVgz8oys; arc=fail smtp.client-ip=216.71.156.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="OVgz8oys"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1724039180; x=1755575180;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s1D4Vkh+wtcwwJ9ZFIEuenI41Cb53pKa20rXEE/s02I=;
  b=OVgz8oysAiCGJ2ovacuDVecRYe8+dAPWCnCxOOK8/fd1mM2ZYIMLX/t7
   BoAuKeO8/GDKoP6+eqr+e9FvLMRccl7y2lLFdj2V0agcMwVI/sqWhy0NY
   RuP/8ldu2OEgspq7RioZWy+gG3Sex35u3S5pDJo6uaF3tQ0Z1cgArEfTe
   6cVS7SRYlVMeqm28KjZVLvzu6o40gwpnqVyShSttGNaumYv/rX6jHw2RL
   NS/Ur8zgbeba8jsuC9trkrFQw+a1CGoLtiRJz8kz/pVDTk4DPeYOwcpEB
   RseODZ7GyOtX5S/8EEFUplIF3UvDBA3/h/+CJqQQ9CLhapzSRgK2MSIJe
   w==;
X-CSE-ConnectionGUID: j8sLVNZ/R+CiAjTJUGdWfw==
X-CSE-MsgGUID: 2fEboKsPQ6uP3Fvh4vncxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="128466869"
X-IronPort-AV: E=Sophos;i="6.10,158,1719846000"; 
   d="scan'208";a="128466869"
Received: from mail-japaneastazlp17011029.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.29])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 12:45:07 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OcLwGXLv33j8vhOzhMCvYmU7YI1RSOWJdu3/aJyvLaIhplfuZcIxbDKs3Y3PPYphWKix0yF1ew9famvdWUmljFw7Q4w8wNZvNOrHwZsFV6x3FPWN87A6jAnu1xFM7LXTfU1niFs8TQH7P8yo//Ht2P7VC/oWp/IQ7N2RhNqECQQJMFQclkTZKnBGr3u55+uZLTnO/oUqqzPXhIfBPLwS5kts5QmQOVcns+RwaBDHLbiMhBPINNTpNnrTgY+c/7e2abrbPXnOC7DMR9fP7nR4SSc2EU+1yowsnL+cFtNpAD6MOfb6lqJfQdpTKXDrp2QBy4jwxItr59SwUfWXyNsfHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1D4Vkh+wtcwwJ9ZFIEuenI41Cb53pKa20rXEE/s02I=;
 b=CmhcRRAbWGzJEiGZjE1jn4+b4/HCRzjwHuWHeXlGIvyidVCzMCAnI472EUkesJVE/oGSB4mUJidwfiYQ6srkkbEr1lpXoVG9c2AYI7sIPZ0Vvfupq97RhWKcHVB+xy6mAVJNxwgrVcBVkyOZ+Tzyr6ns8lVRJrnsB4vfhKj+PgwEs5xWxQPE5ATGBe59lN3z2IxYwipe1RjjZjHw9emiqGBdcgmQST3VL/g4YL6xNlFlO4fS9cxKtKLFT1GrbOd639bCxLqkUQbor+TKgyEnsbzUkPlWxZc3IsZ6kJMGC8K3zWt5bYwH6kLCYLT8DEOGtQLg0r0RQYEwXfmgYYNggw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by TYCPR01MB7894.jpnprd01.prod.outlook.com (2603:1096:400:183::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 03:45:04 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%3]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 03:45:03 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: Dan Williams <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "ira.weiny@intel.com"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Thread-Topic: [PATCH v2 1/2] nvdimm: Fix devs leaks in scan_labels()
Thread-Index: AQHa2X8zwa9xxtG/iUCzPF4J7ymSb7IfpsOAgA5594A=
Date: Mon, 19 Aug 2024 03:45:02 +0000
Message-ID: <d3a67b6e-c5df-4175-ba75-72aac63a7986@fujitsu.com>
References: <20240719015836.1060677-1-lizhijian@fujitsu.com>
 <66b69a6fc5710_257529458@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b69a6fc5710_257529458@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|TYCPR01MB7894:EE_
x-ms-office365-filtering-correlation-id: 0fa5e3e7-355e-4fd1-4596-08dcc0014e89
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?RmxWZFoxa1k4MXVoaW5BSC9PK0d2QkV1ZkZZMHcxKzUvQzdzUTR5RUJvVGxv?=
 =?utf-8?B?N2JXcFFCdUIwSDNkYTA3dHZJQ3UrU25hNjROKzY4UVZSYWZpRFRWRERZbWJm?=
 =?utf-8?B?SnMzczNFMFpJZGxST2tEaUdsK3o1MWtnbHBlTFBoeDI5cmtyWWt4ZmJHOTBM?=
 =?utf-8?B?WWhoVXlEQ1lXZWFjWUlpVU91WnJmQ0dJU0xrK25FcFBzbnBCVmcrWlk2Qmtt?=
 =?utf-8?B?T0tHb1NEc2c4ZVJCTmVCaDRKTGl6My8reGhhMjl5TjNrZFkrY2ZZRXpjMnlw?=
 =?utf-8?B?ZDBVSmJ3VUR2MHVMOWVPTUhjNGlKNW9HZndEQ2Rub05NekRPMDFrNnM5TURx?=
 =?utf-8?B?Y2VEeXdadVN6VkJmWkVPN2lKbHlRZllFd25YZXVhVFdHVEFENDdzOFl2TzV3?=
 =?utf-8?B?RzVTU1l4TFJCcExFd3BYOHEyMEx6UzMxSGFaakw0eG5wT2ovL0ZBZkUyeC9O?=
 =?utf-8?B?S1VjV1BvaFJQTGxhak41cU1hK0daZndEVUJGdW10cXdubHN5NzlxcW1SRVBp?=
 =?utf-8?B?UHRMVWpNV0NFcU41Zld2K25wV3FmakYyV3ZzQ2VwUThzZ3kyakExOW1TeUlL?=
 =?utf-8?B?d1lCR2tQK0NiVDlhMXR1eC9yK0tTRnM5U2FvSzdTdU1EeUpzWTFKNzBaYlli?=
 =?utf-8?B?OG4xaWlmVW8zcDhuK28vSkx4RjFVVkRYR2FHL3pvWmRzWmtKMmxMSzNxS0J6?=
 =?utf-8?B?bUpsaldpR0J3cjd5Y3lLbGdsNTdpMnNKNFdBYW1lOTVNckZyeStaVUw5Wmoy?=
 =?utf-8?B?aW5mNnp5MFF1WEUwM0w2MUpLaUUzM3MwM0lMZWJybnJEVTBrVklzT3ZSeStn?=
 =?utf-8?B?UXBBdTdrUzZYQVdWYmdTSnpkZzB5RHkwQWd6c3hLOWhpUmp0dXE5WWlBM1N5?=
 =?utf-8?B?b2h1VEJFY0Y4L2J2aDNpaUdDOFVYdmNDRXpYODVJLzdkU1lnYWE1alhJWUwv?=
 =?utf-8?B?UXhUTVFtUE1TS1NrWHdBcjkzTnBTa1pVcGRzSEhKVnBwRUc3V2IwTjR3ZW9p?=
 =?utf-8?B?NmVoS3pxcUREQWFVbnZVTUZudGxMOUd2a3NJckFFYm02UFB0S3BYVEdHU1N2?=
 =?utf-8?B?V3hOays0UU4vdmtsQVRLbDJlUFFLNGtDc0lUaGM1MzBHaVdNNVVBQ1pGRXR1?=
 =?utf-8?B?TnQ4eTZSb01ScjFrWVNjR0xSeVVPTlFRNS80eFk3b3QxVCtVckFCOXBCRldw?=
 =?utf-8?B?K1dFdWJZSk9aQmVSSFJmSzVQbGdyajFBaUtwU1M3ZXVPTlFYQW1MdWRIcWJl?=
 =?utf-8?B?NXNkS3lBdFhIZTBNR3VuNlMxSTJsQWtsalY2VFNQa3JBMk9TbnlBeG4yMTBn?=
 =?utf-8?B?a0Z0Q1pITU5yNndVMW1jODFydXlJOTdoSlNsemovVWhzNmdKbUNhWm00UUh0?=
 =?utf-8?B?dHRrcmxLNGtCOTZONXYvQ2l3dCtHejd1ZTlpVGZTWGxLMW1DcHp0N3VzY1pE?=
 =?utf-8?B?QjdEdU1vY1U3TzhwVmxzMjQ1YnJ2b2NDZTRaVVhXbW1PVnpmMnp3eXM4c1hr?=
 =?utf-8?B?UFNOOVRhZnNsRTZyb3Z2aVA3MjRvOTRTUVFVdU9QdGZ5Y3B2UTdyZzd6OVlu?=
 =?utf-8?B?K2Z5VG1OK0pBb0l0bi9tQm5LS1NSUU4rTENubGU4NkhpUzVVaGc5TkhNeGhC?=
 =?utf-8?B?L1FxSjIxemZDRUgwSm82S0ovQWd0NlVYTFVqa3dKd01rbEFwS2FsUFJRcUh2?=
 =?utf-8?B?Vmw0ZklVbnNJWldkb1lHRzhJNGVSOHFBamFWVitHdFlkTDdCUHpUM0lmdE5a?=
 =?utf-8?B?RU5qN3VuNUxxVi8wYjVmZmdGY05NMUFvL25Ybk9lR24rOGdmcVdtMTN5V1J4?=
 =?utf-8?B?UXNreDczUVJEczJVWndmWE9PNkN5ZnMvSHAvNUJpdVpXVjQ1RnRVR1ExL2p3?=
 =?utf-8?B?Q3hZV3VpWXZ6WnpaQ1pBYWhuWStvcHAxZnV3R2w0U01obDd2a1hkN2UvaGM4?=
 =?utf-8?Q?1Q1C6STVPIo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eFVZYklodHNJOXpGakhRZjN0NTNHNTJLUVVyMmMzZGhnYzQrY244bnVtTjhv?=
 =?utf-8?B?aHNkZlhDRlU2dHRyMHhJMTNrT252UE9HY0VFVzV1RGluL3h4VlpmT2pXSTlY?=
 =?utf-8?B?ZHBMV0k2aFc5dGREQkJtanU0YmpKL3JHd3R1Y2hiYUJpU0NtVU1WdjJLQith?=
 =?utf-8?B?SXRSWmFuN09Kc0l0SUJ6U1VIdVJEd2NuY3NpR01tZUxNeW14Ny9aelZlMFNq?=
 =?utf-8?B?a3NHL0wxMmU0K25CdW5lWUE3bExpaVc3aWNaNUpPdG81WHRpRkxZZ1dkMVd4?=
 =?utf-8?B?bE9xS3VMTlFIclE4MWhPWVB3VXNmRndWVktBWDhkTGlkdEdIbDBtalJ6ZTlz?=
 =?utf-8?B?K21NOXhVTEgrRUhWblArU29HZVVUM25LcnRiQ0w1d2owQklMRWEyWEpodVpO?=
 =?utf-8?B?V0JQMmg0SzhBUGlrWE5FQk8vRkFqOEQ3dGtkSEN3d3hNVzFxYWlVVWtxUXNU?=
 =?utf-8?B?MThpcWt5N2ZFQm05Q0ZyM2hsSWR3NnVldktlN0xFM2ZxNE0wTTBlemNaY09a?=
 =?utf-8?B?VXdPOVlOSXM3WEFRWjhNZzFMSGdmNkl0SHl6cE5ubTNuN0dpR1dFYUFpSFBs?=
 =?utf-8?B?bmVKZHdYMkxoakxFbnlOYXFVa0ViNU1mWGp3bzFPam8yUGxuOXMwUnVPbVNv?=
 =?utf-8?B?QkROMUhlNlBpRDhVWUhOSmcwamVVdEl4ZElndjVkZDF2eEJqODI4ajB3OUhl?=
 =?utf-8?B?WTNGaTFocHBmbldFa3VueURGTjlHemJDR0F3aUMvVm5rd0VneHh0NVpyWVF3?=
 =?utf-8?B?dXpKdGlWNnFTai81ejNxdzJmeDg0VE11UFlGbXltcGlFd0VVR00zK2lLMFBN?=
 =?utf-8?B?VUVzNzYrYWpCb2o5SGtnUjZyT0tiTXVKRFdmZUphUGNia2RXemRxVHNvcHhz?=
 =?utf-8?B?ekdFSlB2VTdTZk42V1h3clYzY2lSQ3krYXEycDl2S1czSENCWXVmQzhMc3Jx?=
 =?utf-8?B?TWhxQllGYjhqby9QWUY1MWplbm4xRHBiR2pkcXFCY29GYzluK3Q2dHBELzNk?=
 =?utf-8?B?NCtsclA0bHBVdmpBM1BlZGV1a0pLRjJ4WisvVU1QeHI2VFpOMlhFNVN5VDRq?=
 =?utf-8?B?emxaN3FhRFpIM25MNGxsWXFQbStGMVdOc0JCRkxVMllOYTFWc1RRa3JtdGdP?=
 =?utf-8?B?WStxc0xEU0I0bnIrMkN4SUZaM2t3dEs5bWVGYllrZFdnMC8wdlRWT3VaTm9a?=
 =?utf-8?B?czlrZGxQZ05icVBPYmllcythQy9VQUNxcXVDVDJjS0NMb1V4aUVQUngzTnJ4?=
 =?utf-8?B?YnArcUdKdGhrb1lZbWtxYXJaSzlEdmhML2FpSVlEVytyaFRHdmtHOUtyUzhJ?=
 =?utf-8?B?Zlc3ZC8xb3BQZC92eENUUUZLTDhsVWxDRmExSHB0NC9nS2lCcXdMNjVMQjdR?=
 =?utf-8?B?UXdOVGVQNUtqZExzSFFqcC8rQVg4VGFyS2VjWmdhY09iekxCSUgrN0lXc1Vu?=
 =?utf-8?B?NGJDYUxZN25vOThncjdCeEs5WDhPRGtseHZkOUMvcm11ZG12VkNRTSszeU8v?=
 =?utf-8?B?U2luRFFPcTRXSWRFRmFxVU9Id2lDQS9VdnBBTmJ0V2Vic2RIVE5ZOTQzUmNy?=
 =?utf-8?B?WkNFUmpIZXN3bS9lWldzQTBlZ05wTGVGZkZkaXRjTlNlTm5BcnkrZ0ZOYmRu?=
 =?utf-8?B?SjZ4bk5NclFTRHFmV3J0ZWZ2NkgvTld1VEVQazNuUEozbjdFVjRtU24xc1pF?=
 =?utf-8?B?Y3VQWXBYYXZjeHFZZm56bjdjSzRxelVhVFU5MzF5YUNlK2d4eUtybUlDSEtF?=
 =?utf-8?B?S2dibjJnY1RZL3FoSHVqbUtBOVd1MVR0L1lSLy9EZ3l1MWVhZGxXS1czVi9p?=
 =?utf-8?B?Y1pyd1AwZTJSZkJ6ZDFqOFJ4cENXemx5MnYrM1lqWHVPQ0ZtbXBmT1NJWURh?=
 =?utf-8?B?a3M4clR5SnJEY2M3Q0lLU2FkU01adkxxYXY0VmxFOWNMNGZUWThTSGhFc3VR?=
 =?utf-8?B?M1gxUjVjQWNJcTE5dVh4REJkclJYTmltcmhncEFMS3NnVVdOMlZ6VE1Pa2FG?=
 =?utf-8?B?dnBFUktObmFjd0JlelhLR1QvRUFyRTlUV3JNSE5jVUR1T3Y1ZVA1RE1ydXpD?=
 =?utf-8?B?ZkhKbWYwNU1kWFFIVUdpeVZoaFdJT1Jpd0hDTUxDTXBIWFV5U1FPN3hhaGph?=
 =?utf-8?B?OVUzQWVUK2pOZ2M1MVA1UE5GWmUvaW5FUHBYM21JM0tQc2R5YXlEZWVXOFQr?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DCA84B4FA199149BD600CB68722F224@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	epmsvCsiX3Tcmc4EC2hfB3eiC25F3ttYhuypftEGuWX1gnOisPVzdvZpNJe01Aydq/ChGVqpC3ddr2UNnQeAamzqYcMqiBSJlnk0odT8V4BChx4q5rbUeh7Qv8LKxRw7GKDzZpSO9Mhh4AMpLt/haVBxC9koHoklZuMIjk4hlYL4DnZjdU4HqGxcsuh+xoqeo0iSZEBsTr+NLCbFLYw5/SLWdA8y9vNoCNREJYVl2K86S0SKlIAcBqlDBnvrS3r+Lh/psKjALst8oavHpoIl37xy8mPXTaSiGXjuPC5455zTxzEf6mgU8ZJAnaSVS+1hTSL4AXqWJqLNf5ceSoMUkbs+1K3JfCaPNO/OKk4orz16GZ+9DWUfX/vQVkkcTJilzzLd0YZMi1Fd7F4vIDiAxWAlTD7bGe37Gj8skZZbYWnKHlFHNZPia3howaOdULp+x2UNcL5PbfyLnJerDstDtopxD67TaHGFFH+DdCCQRuQZJdBWUuXr2NILgVqm7dBEAvLLsc+AC1kTypMT7DDVE1soqAl0WClk0Vyhsd1FZyUdlYk501OaGeN8oVjR3o1sjrn+w6Zvx0X+usytkPne/ZHwu27elUJU+uFH02XY/8tsNa1+n6hvRA8mPSxQ2DTY
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa5e3e7-355e-4fd1-4596-08dcc0014e89
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2024 03:45:02.4488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HW+hCVxvp+C7xFAG4+A4tIp/XN+632b+BypitQjO2igYluupBbd6ScV6vXZwAcunOStu4u21MY6aDssVHXLrFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7894

KEp1c3QgYmFjayBmcm9tIHRoZSBzdW1tZXIgaG9saWRheSkNCg0KU29ycnkgZm9yIHRoZSBsYXRl
IHJlcGx5Lg0KDQoNCk9uIDEwLzA4LzIwMjQgMDY6MzgsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4g
SSBub3RpY2UgdGhpcyBwYXRjaCBpcyBub3QgdXBzdHJlYW0geWV0LiBMZXQncyB0cnkgdG8gZ2V0
IGl0IG92ZXIgdGhlDQo+IGdvYWwgbGluZS4NCj4gDQo+IExpIFpoaWppYW4gd3JvdGU6DQo+PiBU
aGUgbGVha2FnZSB3b3VsZCBoYXBwZW4gd2hlbiBjcmVhdGVfbmFtZXNwYWNlX3BtZW0oKSBtZWV0
cyBhbiBpbnZhbGlkDQo+PiBsYWJlbCB3aGljaCBnZXRzIGZhaWx1cmUgaW4gdmFsaWRhdGluZyBp
c2V0Y29va2llLg0KPiANCj4gSSB3b3VsZCByZXdyaXRlIHRoaXMgYXM6DQo+IA0KPiAic2Nhbl9s
YWJlbHMoKSBsZWFrcyBtZW1vcnkgd2hlbiBsYWJlbCBzY2FubmluZyBmYWlscyBhbmQgaXQgZmFs
bHMgYmFjaw0KPiB0byBqdXN0IGNyZWF0aW5nIGEgZGVmYXVsdCAic2VlZCIgbmFtZXNwYWNlIGZv
ciB1c2Vyc3BhY2UgdG8gY29uZmlndXJlLg0KPiBSb290IGNhbiBmb3JjZSB0aGUga2VybmVsIHRv
IGxlYWsgbWVtb3J5LiINCg0KSXQgc291bmRzIGdvb2QgdG8gbWUuDQoNCj4gDQo+IC4uLnRoZW4g
YSBkaXN0cmlidXRpb24gZGV2ZWxvcGVyIGtub3dzIHRoZSB1cmdlbmN5IHRvIGJhY2twb3J0IHRo
aXMgZml4Lg0KPiANCj4+IFRyeSB0byByZXN1c2UgdGhlIGRldnMgdGhhdCBtYXkgaGF2ZSBhbHJl
YWR5IGJlZW4gYWxsb2NhdGVkIHdpdGggc2l6ZQ0KPj4gKDIgKiBzaXplb2YoZGV2KSkgcHJldmlv
dXNseS4NCj4gDQo+IFJhdGhlciB0aGFuIGNvbmRpdGlvbmFsbHkgcmVhbGxvY2F0aW5nIEkgdGhp
bmsgaXQgd291bGQgYmUgYmV0dGVyIHRvDQo+IHVuY29uZGl0aW9uYWxseSBhbGxvY2F0ZSB0aGUg
bWluaW11bSwgc29tZXRoaW5nIGxpa2U6DQoNCg0KT2theSwgSSB3aWxsIHVwZGF0ZSBpdCBpbiBW
My4NCg0KDQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2
cy5jIGIvZHJpdmVycy9udmRpbW0vbmFtZXNwYWNlX2RldnMuYw0KPiBpbmRleCBkNmQ1NThmOTRk
NmIuLjFjMzhjOTNiZWUyMSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9udmRpbW0vbmFtZXNwYWNl
X2RldnMuYw0KPiArKysgYi9kcml2ZXJzL252ZGltbS9uYW1lc3BhY2VfZGV2cy5jDQo+IEBAIC0x
OTM3LDEyICsxOTM3LDE2IEBAIHN0YXRpYyBpbnQgY21wX2RwYShjb25zdCB2b2lkICphLCBjb25z
dCB2b2lkICpiKQ0KPiAgIHN0YXRpYyBzdHJ1Y3QgZGV2aWNlICoqc2Nhbl9sYWJlbHMoc3RydWN0
IG5kX3JlZ2lvbiAqbmRfcmVnaW9uKQ0KPiAgIHsNCj4gICAgICAgICAgaW50IGksIGNvdW50ID0g
MDsNCj4gLSAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXYsICoqZGV2cyA9IE5VTEw7DQo+ICsgICAg
ICAgc3RydWN0IGRldmljZSAqZGV2LCAqKmRldnM7DQo+ICAgICAgICAgIHN0cnVjdCBuZF9sYWJl
bF9lbnQgKmxhYmVsX2VudCwgKmU7DQo+ICAgICAgICAgIHN0cnVjdCBuZF9tYXBwaW5nICpuZF9t
YXBwaW5nID0gJm5kX3JlZ2lvbi0+bWFwcGluZ1swXTsNCj4gICAgICAgICAgc3RydWN0IG52ZGlt
bV9kcnZkYXRhICpuZGQgPSB0b19uZGQobmRfbWFwcGluZyk7DQo+ICAgICAgICAgIHJlc291cmNl
X3NpemVfdCBtYXBfZW5kID0gbmRfbWFwcGluZy0+c3RhcnQgKyBuZF9tYXBwaW5nLT5zaXplIC0g
MTsNCj4gICANCj4gKyAgICAgICBkZXZzID0ga2NhbGxvYygyLCBzaXplb2YoZGV2KSwgR0ZQX0tF
Uk5FTCk7DQo+ICsgICAgICAgaWYgKCFkZXZzKQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIE5V
TEw7DQo+ICsNCj4gICAgICAgICAgLyogInNhZmUiIGJlY2F1c2UgY3JlYXRlX25hbWVzcGFjZV9w
bWVtKCkgbWlnaHQgbGlzdF9tb3ZlKCkgbGFiZWxfZW50ICovDQo+ICAgICAgICAgIGxpc3RfZm9y
X2VhY2hfZW50cnlfc2FmZShsYWJlbF9lbnQsIGUsICZuZF9tYXBwaW5nLT5sYWJlbHMsIGxpc3Qp
IHsNCj4gICAgICAgICAgICAgICAgICBzdHJ1Y3QgbmRfbmFtZXNwYWNlX2xhYmVsICpuZF9sYWJl
bCA9IGxhYmVsX2VudC0+bGFiZWw7DQo+IEBAIC0xOTYxLDEyICsxOTY1LDE0IEBAIHN0YXRpYyBz
dHJ1Y3QgZGV2aWNlICoqc2Nhbl9sYWJlbHMoc3RydWN0IG5kX3JlZ2lvbiAqbmRfcmVnaW9uKQ0K
PiAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnI7DQo+ICAgICAgICAgICAgICAgICAg
aWYgKGkgPCBjb3VudCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiAt
ICAgICAgICAgICAgICAgX19kZXZzID0ga2NhbGxvYyhjb3VudCArIDIsIHNpemVvZihkZXYpLCBH
RlBfS0VSTkVMKTsNCj4gLSAgICAgICAgICAgICAgIGlmICghX19kZXZzKQ0KPiAtICAgICAgICAg
ICAgICAgICAgICAgICBnb3RvIGVycjsNCj4gLSAgICAgICAgICAgICAgIG1lbWNweShfX2RldnMs
IGRldnMsIHNpemVvZihkZXYpICogY291bnQpOw0KPiAtICAgICAgICAgICAgICAga2ZyZWUoZGV2
cyk7DQo+IC0gICAgICAgICAgICAgICBkZXZzID0gX19kZXZzOw0KPiArICAgICAgICAgICAgICAg
aWYgKGNvdW50KSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIF9fZGV2cyA9IGtjYWxsb2Mo
Y291bnQgKyAyLCBzaXplb2YoZGV2KSwgR0ZQX0tFUk5FTCk7DQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGlmICghX19kZXZzKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdv
dG8gZXJyOw0KPiArICAgICAgICAgICAgICAgICAgICAgICBtZW1jcHkoX19kZXZzLCBkZXZzLCBz
aXplb2YoZGV2KSAqIGNvdW50KTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAga2ZyZWUoZGV2
cyk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldnMgPSBfX2RldnM7DQo+ICsgICAgICAg
ICAgICAgICB9DQo+ICAgDQo+ICAgICAgICAgICAgICAgICAgZGV2ID0gY3JlYXRlX25hbWVzcGFj
ZV9wbWVtKG5kX3JlZ2lvbiwgbmRfbWFwcGluZywgbmRfbGFiZWwpOw0KPiAgICAgICAgICAgICAg
ICAgIGlmIChJU19FUlIoZGV2KSkgew0KPiBAQCAtMTk5NCwxMCArMjAwMCw2IEBAIHN0YXRpYyBz
dHJ1Y3QgZGV2aWNlICoqc2Nhbl9sYWJlbHMoc3RydWN0IG5kX3JlZ2lvbiAqbmRfcmVnaW9uKQ0K
PiAgICAgICAgICAgICAgICAgIC8qIFB1Ymxpc2ggYSB6ZXJvLXNpemVkIG5hbWVzcGFjZSBmb3Ig
dXNlcnNwYWNlIHRvIGNvbmZpZ3VyZS4gKi8NCj4gICAgICAgICAgICAgICAgICBuZF9tYXBwaW5n
X2ZyZWVfbGFiZWxzKG5kX21hcHBpbmcpOw0KPiAgIA0KPiAtICAgICAgICAgICAgICAgZGV2cyA9
IGtjYWxsb2MoMiwgc2l6ZW9mKGRldiksIEdGUF9LRVJORUwpOw0KPiAtICAgICAgICAgICAgICAg
aWYgKCFkZXZzKQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVycjsNCj4gLQ0KPiAg
ICAgICAgICAgICAgICAgIG5zcG0gPSBremFsbG9jKHNpemVvZigqbnNwbSksIEdGUF9LRVJORUwp
Ow0KPiAgICAgICAgICAgICAgICAgIGlmICghbnNwbSkNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgIGdvdG8gZXJyOw0KPiBAQCAtMjAzNiwxMiArMjAzOCwxMCBAQCBzdGF0aWMgc3RydWN0IGRl
dmljZSAqKnNjYW5fbGFiZWxzKHN0cnVjdCBuZF9yZWdpb24gKm5kX3JlZ2lvbikNCj4gICAgICAg
ICAgcmV0dXJuIGRldnM7DQo+ICAgDQo+ICAgIGVycjoNCj4gLSAgICAgICBpZiAoZGV2cykgew0K
PiAtICAgICAgICAgICAgICAgZm9yIChpID0gMDsgZGV2c1tpXTsgaSsrKQ0KPiAtICAgICAgICAg
ICAgICAgICAgICAgICBuYW1lc3BhY2VfcG1lbV9yZWxlYXNlKGRldnNbaV0pOw0KPiAtICAgICAg
ICAgICAgICAga2ZyZWUoZGV2cyk7DQo+IC0gICAgICAgfQ0KPiAtICAgICAgIHJldHVybiBOVUxM
Ow0KPiArICAgICAgICBmb3IgKGkgPSAwOyBkZXZzW2ldOyBpKyspDQo+ICsgICAgICAgICAgICAg
ICAgbmFtZXNwYWNlX3BtZW1fcmVsZWFzZShkZXZzW2ldKTsNCj4gKyAgICAgICAga2ZyZWUoZGV2
cyk7DQo+ICsgICAgICAgIHJldHVybiBOVUxMOw0KPiAgIH0NCj4gICANCj4gICBzdGF0aWMgc3Ry
dWN0IGRldmljZSAqKmNyZWF0ZV9uYW1lc3BhY2VzKHN0cnVjdCBuZF9yZWdpb24gKm5kX3JlZ2lv
bikNCj4gDQo+IA0KPj4gQSBrbWVtbGVhayByZXBvcnRzOg0KPj4gdW5yZWZlcmVuY2VkIG9iamVj
dCAweGZmZmY4ODgwMGRkYTE5ODAgKHNpemUgMTYpOg0KPj4gICAgY29tbSAia3dvcmtlci91MTA6
NSIsIHBpZCA2OSwgamlmZmllcyA0Mjk0NjcxNzgxDQo+PiAgICBoZXggZHVtcCAoZmlyc3QgMTYg
Ynl0ZXMpOg0KPj4gICAgICAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAgLi4uLi4uLi4uLi4uLi4uLg0KPj4gICAgYmFja3RyYWNlIChjcmMgMCk6DQo+PiAg
ICAgIFs8MDAwMDAwMDBjNWRlYTU2MD5dIF9fa21hbGxvYysweDMyYy8weDQ3MA0KPj4gICAgICBb
PDAwMDAwMDAwOWVkNDNjODM+XSBuZF9yZWdpb25fcmVnaXN0ZXJfbmFtZXNwYWNlcysweDZmYi8w
eDExMjAgW2xpYm52ZGltbV0NCj4+ICAgICAgWzwwMDAwMDAwMDBlMDdhNjVjPl0gbmRfcmVnaW9u
X3Byb2JlKzB4ZmUvMHgyMTAgW2xpYm52ZGltbV0NCj4+ICAgICAgWzwwMDAwMDAwMDdiNzljZTVm
Pl0gbnZkaW1tX2J1c19wcm9iZSsweDdhLzB4MWUwIFtsaWJudmRpbW1dDQo+PiAgICAgIFs8MDAw
MDAwMDBhNWYzZGEyZT5dIHJlYWxseV9wcm9iZSsweGM2LzB4MzkwDQo+PiAgICAgIFs8MDAwMDAw
MDAxMjllMmE2OT5dIF9fZHJpdmVyX3Byb2JlX2RldmljZSsweDc4LzB4MTUwDQo+PiAgICAgIFs8
MDAwMDAwMDAyZGZlZDI4Yj5dIGRyaXZlcl9wcm9iZV9kZXZpY2UrMHgxZS8weDkwDQo+PiAgICAg
IFs8MDAwMDAwMDBlNzA0OGRlMj5dIF9fZGV2aWNlX2F0dGFjaF9kcml2ZXIrMHg4NS8weDExMA0K
Pj4gICAgICBbPDAwMDAwMDAwMzJkY2EyOTU+XSBidXNfZm9yX2VhY2hfZHJ2KzB4ODUvMHhlMA0K
Pj4gICAgICBbPDAwMDAwMDAwMzkxYzVhN2Q+XSBfX2RldmljZV9hdHRhY2grMHhiZS8weDFlMA0K
Pj4gICAgICBbPDAwMDAwMDAwMjZkYWJlYzA+XSBidXNfcHJvYmVfZGV2aWNlKzB4OTQvMHhiMA0K
Pj4gICAgICBbPDAwMDAwMDAwYzU5MGQ5MzY+XSBkZXZpY2VfYWRkKzB4NjU2LzB4ODcwDQo+PiAg
ICAgIFs8MDAwMDAwMDAzZDY5YmZhYT5dIG5kX2FzeW5jX2RldmljZV9yZWdpc3RlcisweGUvMHg1
MCBbbGlibnZkaW1tXQ0KPj4gICAgICBbPDAwMDAwMDAwM2Y0YzUyYTQ+XSBhc3luY19ydW5fZW50
cnlfZm4rMHgyZS8weDExMA0KPj4gICAgICBbPDAwMDAwMDAwZTIwMWY0YjA+XSBwcm9jZXNzX29u
ZV93b3JrKzB4MWVlLzB4NjAwDQo+PiAgICAgIFs8MDAwMDAwMDA2ZDkwZDVhOT5dIHdvcmtlcl90
aHJlYWQrMHgxODMvMHgzNTANCj4gDQo+IFRoYW5rcyBmb3IgaW5jbHVkaW5nIHRoaXMuDQo+IA0K
PiBXaXRoIHRoZSBhYm92ZSBjaGFuZ2VzIHlvdSBjYW4gYWRkOg0KPiANCj4gUmV2aWV3ZWQtYnk6
IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg==
