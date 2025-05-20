Received: from esa10.fujitsucc.c3s2.iphmx.com (esa10.fujitsucc.c3s2.iphmx.com [68.232.159.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455C5647
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 09:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.247
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747733860; cv=fail; b=f0vrvX+fb+l7bepXBoc9FOAyIb0kHlGNB8U11+yWtw/XwcoaUagkJ9sDYOmfcELCtORwbNIsBRKXW8rQRpYa4vISeHMJc/4V2dCGRK5URle91/Zz1OHuELSIrCHU/LVcgAmDAf7mWc5k7SsSRUIa/GhGEeXSSSXIeUhN0MRg6Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747733860; c=relaxed/simple;
	bh=oIBQyB2sImH+VIiUvYnoI7zd3te3FWIv86X0I+3I+pY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YR1m/0FBBSod7sTIYpjC2ew4KmY64tEyKpihRJoIFx5kCsafv2jBA3bcYUcRVdo/u1mcoAMCVOErJMFSq2+lb0yCOjSQ3cnPrqziKRoKssZkRAfekT+y+pkE3EtJQRUW8mBWID0fhLvPPJAlppK2VR50TrsvUahJG4MlI8Lmm9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=sCpEu+pE; arc=fail smtp.client-ip=68.232.159.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="sCpEu+pE"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747733858; x=1779269858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oIBQyB2sImH+VIiUvYnoI7zd3te3FWIv86X0I+3I+pY=;
  b=sCpEu+pEhVu6r9mritzmiORAEWBtyk93UJ/g7B0cxt7Zob0DCOwFcTWi
   xCs59aqAGScdf6PLpftS8iV8yXFwJzWRRHoybQERGZthKPiheZjE2p7CD
   ZiuVA/hVtShozEVlCn3dowwfYrlicVXLQRYTxr53ZucrWXxXMR+bnVb7d
   x+C6J7vSMCFoI/tXfyv32TRN5+lFGP4ue/TUDh9+zHjxll0BGpJnDa22y
   V6D7v9i7bfxuEMEX/YoypaWL1hnvSZPX4twRnPfbRPS69ZkIWUUPPrHiI
   8mtyy9IWL4dETuu7JfYrgggtoMQAMZgDzcyRTwswh3gUD3PFIwF7LIJc8
   g==;
X-CSE-ConnectionGUID: OMffQp1zQlSlmq6gjN2JsQ==
X-CSE-MsgGUID: NmIvHUmoSoCABRtcc0LmCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="156085099"
X-IronPort-AV: E=Sophos;i="6.15,302,1739804400"; 
   d="scan'208";a="156085099"
Received: from mail-japanwestazlp17010005.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.5])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 18:37:29 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Leb3BU6kVlIYkriBMYeQS3ofUUo0LLcloMhnOYMmj5Qv6M1VaN/byzXSVCdvWPWlAU3dnchkezN2R6NOm2cA92D+wQK8+SwY0dVmINYNO+pEW7XWCV/mWf0Tr9LNysJF8+ooMlgHynypYkanvpv76LFq/B+RmevPtnBV2G4w7DoCxAG0QKXM3uRhstsUZMdKKKLOKyibZVY1ojqRB61ydcu2WvaYTVBpr3RRXnSFtIep7KvCvA35WtDryAAT85kIP7pLtipKmeAnbL3eL6ataxMxv3Zl5jVSBIDDEzTZRJ2gT4pw8h9UOpkAXZ5ASrBUuDEzqZ8Unt+jQs38Uj60rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIBQyB2sImH+VIiUvYnoI7zd3te3FWIv86X0I+3I+pY=;
 b=yZgdwKlwfdRnBfhWIaQIZh131vMJqLMzQ63ejM5bkp0K+OJk2bmJoGiZCGUqoBj07DeCvcPGJdmUxFrbnXKv5kowAqhhVm5772JTtEtfgBJHOzaAAWQ6r4VKVHKwOkCO+L41hLC9/UaTw4HPuGNsKfoWlp4pnCBBEVsJX7E8/Z0ptl0Scpg/vSwQMfA/yn0c0UYQRTXqiOkPCU7oHdPOaHIKkCftM4RIj3TrsfCAdG0s4U41FqejCndFGcoMqUC3TSlXHuY0RYNejN/fbgwyceu+2bLTFPnXxRz6YxpoV+Iwwry7SRutxoi6rQrJs06UOV+jdI0fbC0wfQjReigFkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYRPR01MB12430.jpnprd01.prod.outlook.com (2603:1096:405:ff::5)
 by OS7PR01MB13703.jpnprd01.prod.outlook.com (2603:1096:604:35c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 09:37:23 +0000
Received: from TYRPR01MB12430.jpnprd01.prod.outlook.com
 ([fe80::c82f:3cb1:5b5f:b363]) by TYRPR01MB12430.jpnprd01.prod.outlook.com
 ([fe80::c82f:3cb1:5b5f:b363%5]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 09:37:23 +0000
From: "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>, Davidlohr Bueso
	<dave@stgolabs.net>, "alison.schofield@intel.com"
	<alison.schofield@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: RE: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Topic: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Thread-Index: AQHbmF/9S4EY6oYJJUmO8zEOxl4fELPbNecAgABoD6A=
Date: Tue, 20 May 2025 09:37:23 +0000
Message-ID:
 <TYRPR01MB12430AEC6B6531A440D310447909FA@TYRPR01MB12430.jpnprd01.prod.outlook.com>
References: <20250318234543.562359-1-dave@stgolabs.net>
 <e2defa61-8a12-4b5d-87b2-1271222edf28@fujitsu.com>
In-Reply-To: <e2defa61-8a12-4b5d-87b2-1271222edf28@fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfQWN0aW9uSWQ9M2I0YWNjMDMtYzQ0MS00ZGMyLWE1ZjEtNjYyYmI4MjUw?=
 =?utf-8?B?OGFjO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5?=
 =?utf-8?B?LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX01ldGhv?=
 =?utf-8?B?ZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9OYW1lPUZVSklUU1UtUkVTVFJJQ1RFROKAiztNU0lQ?=
 =?utf-8?B?X0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9T?=
 =?utf-8?B?ZXREYXRlPTIwMjUtMDUtMjBUMDk6MTI6NDhaO01TSVBfTGFiZWxfYTcyOTVj?=
 =?utf-8?B?YzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?utf-8?Q?d-81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYRPR01MB12430:EE_|OS7PR01MB13703:EE_
x-ms-office365-filtering-correlation-id: c05e48c9-ca4b-4511-90cc-08dd9781ecde
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?L2hYN1RJUWRQNUU1dFFqNzdrdmJCVjBIcmdoWTdXeGZ0US9ycHZRZThRL3JT?=
 =?utf-8?B?WWh5MHJGdTlHRjMyMFVxU01hYjN0cVBISFkvVVFLZEFIMm1zZUFzMjhIYjY5?=
 =?utf-8?B?TjRNNUdPbEl0YzZkYUVneFlIQnYzQmtaV3pGSXV2VGhTK2xYVnhFSDZXWEJy?=
 =?utf-8?B?OWF3cVBaMmU0bjhvejNDQzFJQTQ2RjdYTEt2bkFRV0ZDcjhrRFRIeG5tb0NN?=
 =?utf-8?B?aTNMRGYzalp5RnpWMG0xbCtRTVFCN2cwejcrcnNmcGJIU2xMRm9nc0NHVFhM?=
 =?utf-8?B?d2tRSi8zaUd3NVc3OUlYdStGNS9GaXNTU2FDMEs5dmsxTlJkY0pOSlRpencz?=
 =?utf-8?B?Y1cycml0SytkT1NSWmJDZ3A3S1hTRXBucEw0YjFVTkRiWDZ0MkVCOVhFdk95?=
 =?utf-8?B?L0lLdS9SMWVJWTdnSHNRcGUxVS9YKzlobnZUZ2Evb3RubUxYSUNkNk41YzNL?=
 =?utf-8?B?UTFDWW9leW9NTlBaVGpqSU9MOG5TbE1GT2oxcXJoa2NHOUJDcGphNWtDSFRD?=
 =?utf-8?B?dko4RmtrYU1OMVQzWWVqK056d0Q3TmFnTGcxZjltb2lwVWI4Syt2anBzWU1I?=
 =?utf-8?B?WDFGTmNmRldVZG1rYXBISVpqTDFLMTNscVZRTzBDazFSU0g5a1JvWlpoUmZk?=
 =?utf-8?B?S1VhWFR2SUV1RDF4eHV3VDhHb3BuM2Ura0M3eCs0WXJUenVhZ01HbVc3aDdL?=
 =?utf-8?B?Q1M2SmVtWjc4R2pwS0JVMDNXMTMxemdsUEtMVnAydnlUTERIYkZMNi9RazJJ?=
 =?utf-8?B?bWRpSGNXNnlhSitxc3NwZS9ySWt6U21OYmhpTmd5Rmg2elg1MUxYVGtwNUpD?=
 =?utf-8?B?dUtkOE55ZzkrV2t1SjJEZTJzelJlMkUrU3hEbnpjSzZoeWIzY1AxQ2RYTHdy?=
 =?utf-8?B?dlF0MG15a2tDMzErVlBLbzRDUlZOdkVyRCt1VW44ZGdwQk9pbjRaOFZrMnF0?=
 =?utf-8?B?cXlrTzlRa3lMY3hTWWU2cm1hUTlKbjBaekRNSC9QbnE0VkNNUnEwaXdMWVZz?=
 =?utf-8?B?VjR3UVcrTFFwWDNpcmVOSXhhejBlSXM0OUpVVTJyOXYrSmFzbDIwR1VlNjdI?=
 =?utf-8?B?U3ZLbFNvTzl2SytVcU9GdjVzdzk0N2haTEZXQnJLdERwVFh5b0J2SW5Kald2?=
 =?utf-8?B?dW16clRHbEhNMDZzRlJPY3FpNlM5TFgxS1FxdktFVzluLzBZZk16K3BrTU5C?=
 =?utf-8?B?TlRZQlFwM0grVWpBOXJiaU1CWUxkeUhSYW5VOUtmVVhqMHIzNnM4NFVSbEZm?=
 =?utf-8?B?NEgvMXNTWXJoWmd6YzNzb1NzVjB1M0xSVkRic1BkQ2xtZHlVUWZvV1FCZ0pr?=
 =?utf-8?B?bkQzL2hRQVNJdmk0UER3dENrMUdHWnIrT1lranVvV3FPQkNKaXU3dGJwU1J1?=
 =?utf-8?B?WHVETlhZOWp6clNOZnIzM0M4MWR5QlBBQWd5QlY4VnJ4RTZndDJMSmNuM0d6?=
 =?utf-8?B?NldpYzZYT1g1WjJScFlLMEJzQi9Zd0FEUU1BUWtvbU9VcnVWTHhMVnFmdG5N?=
 =?utf-8?B?aGFYVGpTUkRxREFQSVEzRU9JbzBQelJSbnVNMCtJNENROHd1b3kxaXdsTFJQ?=
 =?utf-8?B?UlNYZ2g4RUJhWlRpaWJqYTI5V3ZvTEVCYUh2Mk5xYjJUOG5rckwyaGQzUzBw?=
 =?utf-8?B?SkYra25JbFdtSldLa2NFUkZyMnRoemFXZk85SVovWFI3d1c2QUtTZzNMZGV3?=
 =?utf-8?B?ekpicHd2TUlTZG1VVHZwY2g1UlFkQUx2emJPS3Qwb1VUM0UzdmFxUkJqUWFK?=
 =?utf-8?B?alRWeDZobXBRSWxVSkpLajdUTWdwQmV3Yy81ZlIxa1BudFNOc1AzckpLVlg5?=
 =?utf-8?B?dlB4Ny9zYUpRdmVpM2dydnJFUXpWbnZLNDkxMXljYm84UmtYKzFaUElLZDhI?=
 =?utf-8?B?YmJuMVJDc3BHNjY1SE56WWVvVEcyNGllWWgzUTBTZFBabEF5ZnN6RWRZUDdY?=
 =?utf-8?B?UGh5Z0d1SDBGSzlWcEZVMDJpREVoY1lnSCt3Q2phUTBzL3FxN096d1pFV2hm?=
 =?utf-8?B?MjhXMm9uYkhRUkJOZHc2emI5clZMVmluZ0hPV2UwbFVFeU9lM3lITHo5VHhj?=
 =?utf-8?Q?Ikpfh4?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYRPR01MB12430.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N2pNaUxIellJNzEzME5KZTJpdzQvUEE0SENkT0lKd3RtWklhVEpySFZ3WC95?=
 =?utf-8?B?aUNhb0FBMVBUZGxHZ01XT2VBSWlmV1VVSDR2clZtdnBqbDA2eGgzQTN5Sm9Y?=
 =?utf-8?B?L01CL01EWnRsU3pmQ0l2dTlYTmU0OFUrVzd0S1dvcEJSTkJxLzZtWHRQelYz?=
 =?utf-8?B?cmlwWHliNlZTajFYdysrd1ZyRHVzaWtjd3hJQ1dvS3Vwdi9oRHJOTlhZN0FZ?=
 =?utf-8?B?dUxYTU8wR3dleGZzUGt2bTRDZHQ5OGx1V1BsdzcyZXlSckt5RTczUk8reU5H?=
 =?utf-8?B?SW9IaVdWbWljTjBqWUJERk0vMUtuSmgxbmpZVEFMdzlUZzQrYXErMEoyRjlR?=
 =?utf-8?B?MGVBUzNhWXFkR1dOS1UxK2RoWkdNbVBvUVVqcitpY3piRkVWUHFudTArVVRx?=
 =?utf-8?B?SlNJUnBGTEZYMHpwV3ZxMW9tN21LL3l3VlRLeHljNjBqVFNWSkRIdkllRFVn?=
 =?utf-8?B?czZFU21NZEFjTTZKWDNMZG9PRlpWYmwvcjlnenNpV2FPNnhEKzlYWjdURVhU?=
 =?utf-8?B?QlovTUd3RlQ3dDdocWZnMmpscCs2NktncDhLdFVGUGdRQTBscHJFYkV2dGp1?=
 =?utf-8?B?RkZFUFhzcFpyZGNTMWViUzkrbkZZdFUrQlBrMmUrNnFQeFJEK014NlA5eXFO?=
 =?utf-8?B?MFJpeWhEaTYyM3NEV3dJcE1tUjdQblVJMmJMSGhwY2lMMTgwak5GWWtCNjd4?=
 =?utf-8?B?L1VRN00xVDlyWXlOYzI3VW9oZjFTaytUNDJ0TUNKbW5ieE5KZmlOaDloc3Fy?=
 =?utf-8?B?WXQzOWdld2VzVm5sVkVaR3N0dEErZEU4WE53dVQ1a2hLM1Bpc2k2NnlLSkNE?=
 =?utf-8?B?UmMwdUVhak91S3QwdHREeUxPZjJrRm9uZ3QxNDMva29RNi9TWENLNVJGcEJB?=
 =?utf-8?B?Zi9EbGZBd20zcUZMTXBHLzlIY004Z2pSa3NhZmxCemMzUGVjb25HY2NEeUJ2?=
 =?utf-8?B?d3ZIL1FsYnZ0RFlaYm1kaDlJY1U3STk4MXlOTDYwb0lOc0xNZXQvQ2lKZGJn?=
 =?utf-8?B?Qlk5V3pyb3Y0bG5DZWVORE9pRS85WEtyMHZuRExsMFVKR3hIQytmcC9ENERO?=
 =?utf-8?B?YmcrMWdJdE44V2h4Vm5RWmEwSEowK2FubEMxdXVYOEtObkF5b2pQK3czZGZW?=
 =?utf-8?B?NE5Vb2RZMXJyZWI3bnh6M2lpblJsVHJPNzRFc2llMldOMVdZb21yZFVybVcy?=
 =?utf-8?B?dTh1bWJmSHlsOExadm1ISWk2QmpjV1J5eHBoVUszYitLNEUwdVRZVHYxYTZm?=
 =?utf-8?B?RU9XRng5QndlVlg5YjlzZWhBV3FYVzZiK1BqWGlPUWFWbUFhTTFrZ3NZY0x5?=
 =?utf-8?B?L0ZaNzdHdzJlZmRhM0lBMllUOGcwak42WEFra0JVOTk4YWhHZVpYZUliZ2hH?=
 =?utf-8?B?aTFlTHJWZFoyWXVXUVJxQ0hDcjc3SXBhenFoclUxNTVwTVhkN2IvRFJYZ3lF?=
 =?utf-8?B?eGJrOGI2WWtEZkk2R0czNURjaWRoazFzaDFVVlFuZUpJS3lXS3N5dUhlZnpj?=
 =?utf-8?B?ZVk3VUV5Nk5CM2lnSmJqZVZENEY4UG56SEZTR25tWFZaWStjeC85RGRhaVFQ?=
 =?utf-8?B?SEVRZ3JPQmJDMStJLzA0aVVOdldNSHpkQ3ZyUFFuWjd4RzFVd0xJZ1VycG5v?=
 =?utf-8?B?L0pNa1dWUWhKbHkvZmdqQUxDRkl0eGpid1lxNW9QSHJCVGxFK0l3NFFHajZ6?=
 =?utf-8?B?RGdQTXE5dFZsWGo4My9iUkFVQ2JWU2ZJZy9mdDFQNUdJZmUzNk5TNTVBM2VB?=
 =?utf-8?B?a3UxWHZVcy85WCtabzk5RVRjSUsvQjFuWERRaTVSR0pjSEN6cFEyaEVuUStC?=
 =?utf-8?B?Z1BzRzk1bnlEQ2VxczlXVTEwSmQzVDlaeFFHUlRzWWI3all6ZVdFdkYvMmQv?=
 =?utf-8?B?WTlYRjRKOXdTTFRoQ0V2RTIzMSt5RElYOVkvNkYxdFNCNjlvTHJYc1NSSEI2?=
 =?utf-8?B?eEFtKzJUekJrK0pkLzFFZ2trQXdPN0dycTBTeVdQVFN1UFhCOHo4Y0R6N1ZL?=
 =?utf-8?B?U2xBOVpFVWxVSFcvNEErYzlyTkVXdEltS0NGT3E4dnFxbVV2NE5wTW1HWFoz?=
 =?utf-8?B?VEw5cXJXK2cxUUlabjd0V1pvU1huc3RzczFOYWpnNzdvaHBhT3U2djRtUEk2?=
 =?utf-8?Q?ovmjrssTlm6kvsM+dJbhBONRf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iu0ByyYx50OBnGCMJtbPMo1wRWo2NBjVC8a9XF2SL346KDKxtu1ZPDRoDhq1a5wAhwfEPZYup4WJGA5V2zm2ZoKScgClAFQqrSc/xD+HbdjnOUpS/b2b/ttjIw3HwKSATZsIJCHLpD8IFcnyfxZ+oO4f+9ChWWrxjXfbPjZR1nUFC0mKv3m1JJLdyYQ4HN3C0RngZbYjdZJkFg8tQXgPiitd0t8xlVs0tMMhiAc4LRJh9btPEu2jkTyJaxoL0Ns6OZi8ST2nwAtn9gON3kQ6N5Mwqv7XAIxyF7mcDfklPPccak5ovoYayDj+HJIJTjPIIqsC9rDS1IL3hHlhgfLdwZA4/LBRgwSazvELOJRUm0DdeYe6UAlTLt7givwFjfxJGjPB3Zq3MYyO8PEduY5RU175Ae+yP1q6Fn+iNAMg7ybDtSEKHAxKX2gh7hjrKwn5bbpdAU+aR2x6QTn/S/r1/SZ1Ixj2h/upqnI8nLeFh8SpO4M1ZwCSeeAkjdKOTmMOE+OqOeay2y295EjJkrDzuzQ8voLVRaFOCV27V7DGI7nIj/YI70AK54cg1HMiyzaug9lK+HG6VoJ3oj0Pl7J4oQGl9dt2fSVPCdqDf+jwT1PCcVB//eOXcJUugzl5lsSL
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYRPR01MB12430.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c05e48c9-ca4b-4511-90cc-08dd9781ecde
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 09:37:23.6520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f1w8WxUcCOEGSWMSS05abWeSElMr0HEyMhw/ofL+hxTna+Au9OMQtqCr6ggZ+yZWgOGnK7odKDe1dSLGKrIFHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB13703

PiBPbiAxOS8wMy8yMDI1IDA3OjQ1LCBEYXZpZGxvaHIgQnVlc28gd3JvdGU6DQo+ID4gQWRkIGEg
bmV3IGN4bF9tZW1kZXZfc2FuaXRpemUoKSB0byBsaWJjeGwgdG8gc3VwcG9ydCB0cmlnZ2VyaW5n
IG1lbW9yeQ0KPiA+IGRldmljZSBzYW5pdGF0aW9uLCBpbiBlaXRoZXIgU2FuaXRpemUgYW5kL29y
IFNlY3VyZSBFcmFzZSwgcGVyIHRoZSBDWEwNCj4gPiAzLjAgc3BlYy4NCj4gPg0KPiA+IFRoaXMg
aXMgYW5hbG9nb3VzIHRvICduZGN0bCBzYW5pdGl6ZS1kaW1tJy4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IERhdmlkbG9ociBCdWVzbyA8ZGF2ZUBzdGdvbGFicy5uZXQ+DQo+ID4gLS0tDQo+IA0K
PiBzbmlwLi4uDQo+IA0KPiA+ICtzdGF0aWMgaW50IGFjdGlvbl9zYW5pdGl6ZV9tZW1kZXYoc3Ry
dWN0IGN4bF9tZW1kZXYgKm1lbWRldiwNCj4gPiArCQkJCSAgc3RydWN0IGFjdGlvbl9jb250ZXh0
ICphY3R4KQ0KPiA+ICt7DQo+ID4gKwlpbnQgcmM7DQo+ID4gKw0KPiA+ICsJaWYgKHBhcmFtLnNl
Y3VyZV9lcmFzZSkNCj4gPiArCQlyYyA9IGN4bF9tZW1kZXZfc2FuaXRpemUobWVtZGV2LCAiZXJh
c2UiKTsNCj4gPiArICAgICAgICBlbHNlDQo+ID4gKwkJcmMgPSBjeGxfbWVtZGV2X3Nhbml0aXpl
KG1lbWRldiwgInNhbml0aXplIik7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHJjOw0KPiA+ICt9DQo+
ID4gKw0KPiANCj4gY3hsX21lbWRldl9zYW5pdGl6ZSBjb3VsZCBmYWlsIGZvciBzb21lIHJlYXNv
bnMobGFjayBvZiBoYXJkd2FyZSBzdXBwb3J0LA0KPiBkZXZpY2UgYnVzeSBldGMpDQo+IA0KPiBJ
J2QgbGlrZSB0byBsb2cgbW9yZSBkZXRhaWxzIGZvciB0aGUgZmFpbHVyZSwgc29tZXRoaW5nIGxp
a2U6DQo+IA0KPiArICAgICAgIGlmIChyYykgew0KPiArICAgICAgICAgICAgICAgbG9nX2Vycigm
bWwsICJvbmUgb3IgbW9yZSBmYWlsdXJlcywgbGFzdCBmYWlsdXJlOiAlc1xuIiwNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgc3RyZXJyb3IoLXJjKSk7DQo+ICsgICAgICAgfQ0KPiANCj4gDQo+
IE90aGVyd2lzZSwNCj4gSSB0ZXN0ZWQgaXQgd2l0aCBRRU1VIGFuZCBDWExfVEVTVCwgaXQgd29y
a2VkDQo+IA0KPiBUZXN0ZWQtYnk6IExpIFpoaWppYW4gPGxpemhpamlhbkBmdWppdHN1LmNvbT4N
Cg0KVGhhbmsgeW91IExpLXNhbiwNCg0KVGhvdWdoIEkgc3RydWdnbGVkIHRvIGNyZWF0ZSBhbiBl
bnZpcm9ubWVudCB3aXRoIGEgc2FuaXRpemF0aW9uIGZlYXR1cmUsDQpMaS1zYW4gd2FzIGZhc3Rl
ciB0aGFuIG1lLg0KSSBoYXZlIG5vIGNvbW1lbnQgZm9yIHlvdXIgcGF0Y2gsIHNvIHBsZWFzZSBn
byBhaGVhZC4NCg0KVGhhbmtzLA0KLS0tDQpZYXN1bm9yaSBHb3RvDQoNCg0K
