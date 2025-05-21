Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com [216.71.156.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAB239E74
	for <nvdimm@lists.linux.dev>; Wed, 21 May 2025 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.156.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747818097; cv=fail; b=Lr3/yGo+jB1nGqQw816w8OFC65ZMZpse6gFki8sz4B+XRcNUNPkee3/Z4pDnd6pqPvTAo0ZaHt9M+LR/wUV5uc0etKsLfybMYiogJBD4NGY0lP05RxChw3ehgd+IB6n5Opa55b11sXMhaH06ITx/vAR9R3oxQIuOY67Zc+um5Qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747818097; c=relaxed/simple;
	bh=AwCtIlbdogSb5T+92mGZVodP1mwPuU5I1hicsCJQaL0=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R3tm2M2kP+OJPPVdvj0dUZAJdrwpDh/mL7a5ashGNIXboctMO/eSXoMnMn8eAM27WDMpNUS1hpFzgcTwLL1fSyKRXbrdb2JnzTK4rw/CiSr4eTbgoIXIlDSradM5sxop8LZeo4XSf5mbKpWMTjhLx9U/Lu0jzI0S5ySxkchrIFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=CSFtR3Ru; arc=fail smtp.client-ip=216.71.156.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="CSFtR3Ru"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747818094; x=1779354094;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=AwCtIlbdogSb5T+92mGZVodP1mwPuU5I1hicsCJQaL0=;
  b=CSFtR3RuBjh2mInTP45F0zmAAM89ml62OHM8hKlRr7BrNuPBIfJnORJj
   2cNvcyb4ZGWI4oSomdJaRSWvJm2KINZBQ/tp0H/vNNcRLqHiUn7XXngw0
   XLCyPJXePxbb4Wy28vRWP5fXq+6FPbChFm+h2gI0Zk8oyeT65F+v2VSHI
   o9M3iSM7QNJ1FJFidPlB4/pQu1xoasDWsuNwi3HLveg4X9LbTWHfr2F7k
   nAe/KPg3YnslcB7TCDvBNGpkbbIWZVzbTHfpn6Aibjh5/arFn3xNCTX73
   6GzkC+y3nc05EGLatZUeK8s4sjVlbI4bTUcch6dRN8UfP8PVPqjt/9Zn9
   Q==;
X-CSE-ConnectionGUID: auRvj0jcSoKROBdTFTwN3g==
X-CSE-MsgGUID: hck/ddaMRouCxDDbzVCKKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="157082634"
X-IronPort-AV: E=Sophos;i="6.15,303,1739804400"; 
   d="scan'208";a="157082634"
Received: from mail-japaneastazlp17011030.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.30])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 18:00:22 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/zEqKXjNjXcmR5MBm5ym1bCQgU6qffN4o2suoWH1vpAOSLGo0mueoRn33vdd2ofjuUnGwZEBgAg5Ml7HdjiDLPzXO7nBzSYds2XqlBG1PJewwwC/9gFhiLAtztkuU4UCE6mrXsEorQj3kkSIVBNiOhceauo2DijpZIpigmgqWi89zbmPOFAT0TLfKgM0GLSMOaQ6lNOPmrfrske/UL4+EseIWeZ/FEn8MBfAXVfdgrvwsiKbVLH/INXJeMOoFOSH12Ct++deB35APygWDeCQwqKpNH5KPwBlHiIspe8WA/tm5Hwnyw0jJ8BEQ2pD6hdYnBWzO4Ob6F9CfgTSaDSRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwCtIlbdogSb5T+92mGZVodP1mwPuU5I1hicsCJQaL0=;
 b=q5FxRrS+alrlA8xk7HIWrs8f6eI4jhzFVU+zrZC3PioCRA+Z9rutCNAD6ikrRu9MOcXnb8x/AF3982WbjgbplVizJAlDcaDGsaGIm/9Q6DJVlvbDiN+1RbvdZALF/j5GOp4yD/pbkf0goXirTHymt07s1LURUz+EASktzKhi67xad1kLNoAWTAMASKOUE8ahszgczqmCUu1g/VPOLN/vEV7mhbrJHKl/X2bi4XSFi4hCTWvQfVP1RqwkSbenwiC/vU+3htnItWa/Gc7X//Tjt5PP5pZe73EpDi4/FMyDnqxgFfFLe5NbDcyUBRaMBnzq6+d2eOB+W3hiT/EFYG1+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com (2603:1096:403:6::12)
 by OSOPR01MB12280.jpnprd01.prod.outlook.com (2603:1096:604:2dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Wed, 21 May
 2025 09:00:19 +0000
Received: from TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377]) by TY1PR01MB1562.jpnprd01.prod.outlook.com
 ([fe80::d9ba:425a:7044:6377%4]) with mapi id 15.20.8769.019; Wed, 21 May 2025
 09:00:19 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "alison.schofield@intel.com" <alison.schofield@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, Marc Herbert
	<marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event driven
 wait
Thread-Topic: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Thread-Index: AQHbyPRLuuO5SQHzW0mFd5AuCz6ti7Pcy6MA
Date: Wed, 21 May 2025 09:00:19 +0000
Message-ID: <f5174c3c-81c4-4e6b-8d3d-7fec1624e964@fujitsu.com>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
In-Reply-To: <20250519192858.1611104-1-alison.schofield@intel.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY1PR01MB1562:EE_|OSOPR01MB12280:EE_
x-ms-office365-filtering-correlation-id: 6d40654d-386b-4214-428d-08dd9845e978
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eEpmRW1ObnhQNFVWMm1FVkFLWUhFNjN5NWFOWmFHaE5veklpK1R1bGtqWWNl?=
 =?utf-8?B?VXhCbmNXMmJ0amhjSnNIRVZzL1Jzc21xSjNNNTdzaHFXbWd1d1NmSTUyblBZ?=
 =?utf-8?B?VTZYTmdab3pVelZlenhlcmVRT0Y1alBoejF1SXJrUnExNXhtS21xbFRRQ1Fq?=
 =?utf-8?B?NnJPenJhVmMzbVNYNFVJdUloZXFuNFUyY2l3M2lmK0tYb2tWUW90V1MxbSs0?=
 =?utf-8?B?NXVvSmNQMHdMQ3dRMDloL2xRY2w2YnEybzROOEtJK1EwOEo5anJNbTViL3Uw?=
 =?utf-8?B?MEhsOTBTdUxpYmQ5dE9FdWd5Z21OWkY2YjJMVUtZQ21nK2pzclRGS2R4d3Ru?=
 =?utf-8?B?Qzd5YnFaM3FZSFJGcE1BSGNwOXFNQXJCayszM0E2Mm9kVm9DUk5MMXdEV0pO?=
 =?utf-8?B?U1c4aTU1VnM1bURxRk5rY2ZuUnBSWDJxYUk2ckFJZWFUUElpZGRxQStlUTJF?=
 =?utf-8?B?VWNhYkdMT252QklML2sxajV5Sk1MY0FadmMxdUhHK2pjM2ticzQrVWZlYjVp?=
 =?utf-8?B?MG9ORmF1WmJvREhDcmNHd0tpNXJIeEErL3hjNHp5R0tHVGtPVm4rRmdqL1Bz?=
 =?utf-8?B?d0VrRyt2M0hFNi85WWhYUzgzUGNhUVdmczJXL0ZZa2c5WlAyczk1UnhDRTdt?=
 =?utf-8?B?WDUyMjgvVWV2MW1NemJzbFY3TUx1cEc2cS8wck82QXZxTkd2NncyU2RJT1pK?=
 =?utf-8?B?Z29Od1crL21Cak85SmhmVGc2dHNSQjdheTBnbzhJMHR1TStFRHFXYXhOcDFj?=
 =?utf-8?B?UnNQMWdVejNIS2JBa2VhL21VNFZGbjVNNmJmS3E5Q0wwM20yL0RiclUrQm9u?=
 =?utf-8?B?OHpaaVRrNGV3czYxd2NORHpibVlCckRnbTRMRVZvRDVNZEVYNWI4Z0RaYzd2?=
 =?utf-8?B?L0JFRlpiaHlCNWZ0anRpZGFRbTc2SGYwNFN4TkliUU0xL0tlcW5DeGp2ckcx?=
 =?utf-8?B?clorMnZuQW9KVzE0ZWFiREswcXF1MDFLN2Uwd1QvMEovYXlnZnFvbW1yL1Z5?=
 =?utf-8?B?OTVaaU5jV3daajhmZ0I0RUlyMjE5UTBVVUZ5K2dETGdhdXc3WkQzM1FZbG5j?=
 =?utf-8?B?eFBpbFVrQnhsZ0tHRVhmVi9mYWpGY2gvUXQ2bThhY2JPOW90cTdoRkJScE52?=
 =?utf-8?B?N3ljdjMySzcrN0NWU2FkaGhRNlNzV2M1S1hYNjBIVGJQNzFoR1pweWxZTjZz?=
 =?utf-8?B?WUYyQm02c0dhaDZGSlRSbU5OdTNzdkdsR0U0L2dHU2dFVjdxWk5NQndJQlhM?=
 =?utf-8?B?YXoyQi9FTjZ4cU9NZlMyVVpxbkg5TWhxRGhtQTBrQlBTdUFHRnc3S0V3QU9N?=
 =?utf-8?B?NWh5S2JJQU40TmlrcnEybE5tckl1NDBvSFNscHBjb0JkTE5sOTRJV0tTaFRq?=
 =?utf-8?B?UlV5eGhaNWJqcXJsdnVTQys0d0RtSHA3WTdnT0xMOXhYVU9BcUJoM0kwWGpV?=
 =?utf-8?B?WGdPL3RudHh5ZWxOVVAzZ1B1U3JVT2xwZ054cnR3N2ZURUh2N3lGVlQ0cDhG?=
 =?utf-8?B?ZDBQaUNJS1o3RDlmS2w2QUZ3aWVsbXB6WHVGVGhwbHhVZ2x0K0JET2JqZDRz?=
 =?utf-8?B?MlJUQXhPbjNEV200K1NaclFaT1dHYlRxTm0yZ0NuNDNsZEpVR1NBN1p4b0x0?=
 =?utf-8?B?OUd2NWNJRVdZbXBzczZPK2ltWlBIZWVZRG4yVnBzUUo5TWo5OHpjUnd1WjJh?=
 =?utf-8?B?Q3FXREdyQ0xNVHNVSnAvemM2aFpLZm8va2d2NUREWHllbFF4eXhRRDUrdWJ3?=
 =?utf-8?B?OU5MdDFSWWxhYlp6a01QdmNoOG1PaUtOYnNOVEllWEhNblR4OUkzbTJvdEM3?=
 =?utf-8?B?Z2hQUGVDVEtSekdVNnd4WnBTa3VTYkFtRW5tQnhDbW54MFNreHhXRUdPK2g3?=
 =?utf-8?B?aTBHRDZwc1FndWpEb1loRkExQm0yb2wxRlNWSkdaK3lqYUoyVGVUaWJKRnFD?=
 =?utf-8?B?bFppTXVWODBKWlpGZkhTYTBWM2JLK0h6dEdybDZUTTVUNzVOKzFLT0EzcXE3?=
 =?utf-8?B?cUpzZUlaekdLcUlBbjliVTlZT090WGV5aHF6bzVxKzdjY3d1Z21oNXZhV29l?=
 =?utf-8?Q?cFr3Yv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1562.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TlJoRUhaNlAzZjZ1cVRBaGZwV0hEN0pZajhIWHZrQnprRXlJZkNTVVp3MGJl?=
 =?utf-8?B?S1ltTXd5N1p2VEY4Q3hFS3VwRDVDVDR5Nm9oQ3dhazluK2pJeUVwekIzOWdO?=
 =?utf-8?B?aHdFUmZXRVNrWHdzU0ZLdEFRcGxOYlFUa2tsdnA0ZERpNHFpTDFnckZoT2F4?=
 =?utf-8?B?K3VBSUFTSVBEVVlrZktGNmJIWlFaMisrVUhiN24zQm1td05NL1BqQ1lTckY2?=
 =?utf-8?B?SWhiakhTYzdSWHRKTlhkUCtXbm9OaXRBUjhSRXEzOXllL0JRZ3JkeDRFUFNC?=
 =?utf-8?B?clZQaktJcitwV0VOR3p4blFNYUZFQ3ZlZFZmU1hneHUyZDBVQWdpQy9nZE9S?=
 =?utf-8?B?N1RYaXV5UzlIVXBTNHBUd0ZWdXFNcWh6RmorUUU5Y2xuL255dEpYT1hoaUFE?=
 =?utf-8?B?WkIvZ0RJR1ppdjFXU1lxWGg4dWh4YXpheE5ya1N5dWorRCtuWFVlZTBHdnNN?=
 =?utf-8?B?SnB6d1BWV2ZFZEJKWWtkdEM1WjVTMi92RTZkMU1sejVZRFRidnFWbnQyQlRa?=
 =?utf-8?B?UG5XNytMN0hpZk9aT0F1Yi8wcWphUzdqL1JxN0tEcGNKd0NKMTdNbzIxUFhO?=
 =?utf-8?B?RzNOZ0UxS1lRYk5WNmhpSWQ3RHRMdDdKRng3OWNhRUV3M3ovV0ZsS2hRQjQx?=
 =?utf-8?B?a0c3ZXBZNWFtang2MXROV1BPdE1kVmlRaXUyMEhFeGtnb2pJUDhQaVFpU1hI?=
 =?utf-8?B?YW9GbFpCWkZsR1ZJdERVZXlTN1BEOVFneFFSUllXSnVKUzhlVG9rS3dML2d3?=
 =?utf-8?B?dlgyZU5BaWhHUXVrbUtqMUdHYVdoUGI2eHZBc2JUSzFtM3ROeUFzNllZNUR6?=
 =?utf-8?B?UDdLUzZDTkJ0N2NEejRJc255ZW9VejNGUjVkMU1iNE5XTlhTMS9LMkdTbzc5?=
 =?utf-8?B?c3NMQmFOdEU3SFpzRHJoSnJGYTdvMUNYdVBUQmRmZTlrN1NSQnE4T3hKSFg5?=
 =?utf-8?B?NUF1dzZ6V2E2VnZTYVhCSXdwSk1BeE50MDhuRVdmLzdDWUNibmNkeGVhb2c3?=
 =?utf-8?B?byt2dkMxdmxUTmd4ODgrTDJ1WHhKWEJPVDZWa0JKMGtScWFmWTMwemNtQ3RR?=
 =?utf-8?B?KzZtNHBnYU80Wjd6SSt6ZFN6eXA3ZjJIZC9CbTRHSE1RV1Y4a2hlQTZoTVJr?=
 =?utf-8?B?U1ROeUdPYUNvRUpTQVlWWFBGb2NpMWFtWmNLUVUxczduK1JGNHc0R2R1U1Fq?=
 =?utf-8?B?SzFVbjZZajQ2NEhla3ppS0pqMkNoa25OdUNnVnBzRXo0MFMvWHE3YU1XVHV6?=
 =?utf-8?B?d3E2MnBnbUYxRngwcVJRTnhCSFl3N1BuQzgxbjk5eTRzWFNFZENPZ0wycE9Y?=
 =?utf-8?B?TE02MkhJSHFOS2Q0K0RmR1BjMElQT25Ud0lFR1ZsMlZkUi84RFFiUSthWGIw?=
 =?utf-8?B?ZEZwa0Q2T0w1NDkvN1FxN2h0Q1F6bXo0RDFPcGFKZ0xqaEdxU0dNYmJUOEo1?=
 =?utf-8?B?N2RGd2ttb1NpazR2ZU0rL09uU0Y4UnlJa2k0WWNqd0MyaThibUxWVnFGdjJw?=
 =?utf-8?B?bTFHdE9Ma0VVZ3ZtbVJVcDJwTWtXME9ra3BncFZSZU5xT3BnNjE5OHJtOXdv?=
 =?utf-8?B?YmlmdDBLNEdFNU5GSSt4OFBMOXRsczRYbWh0TkJrY0Fpa1UxSHF3TnE0M01L?=
 =?utf-8?B?aitLSEJOZVJ2VnVzUC9USVdpZzZvUWpRSy9iclRhTk11eDd1bzB3M01GUjE4?=
 =?utf-8?B?ajhUaDVuZ3NIbG4wSUd1Uld6K25xd3NrY0s1c09mVlc1TlIvcWFWM0doV3Vy?=
 =?utf-8?B?NlFPdVdHVjJ5THRHR0pHUUtJcG1wTHM3R0tsNktOUVBRMWpLUjV5SStuYVcr?=
 =?utf-8?B?WW5vRjJqWjF0UGIvMVBQb2RFV2lqT0lRaHRreWRtVFlZMkdRTkgrSlRGcld3?=
 =?utf-8?B?U21aMlFFcFVWL3pOTGFFckF2TjloWTRrdjF5UmFCTmlRakRUcjc0RTYrSTJY?=
 =?utf-8?B?RnQ5Mmk3L2l0TkNEbTVmZmdVK3gyMjNxT1ZFR3JxUUVpaDJOUk5peDNlMWZ1?=
 =?utf-8?B?VUR1NDA3Z1VtMWVKTkkzVllDNVhJSW9GOHh1SE55S29IU01KWTdSUGorSzF2?=
 =?utf-8?B?K0N4dTVQNXlXaHNZUmd3ZlNFd0FIbkdSai9SWERYNTR5Vy9MZnBjM0JXVUtR?=
 =?utf-8?B?eldsb3lJNjdjUzJwUWlrQjkvYUZYTFlTclRHKzRCUGc5R1lPL1BEdnBTK21o?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <236AA64B216D584CBEB35983F1C5D5F1@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5SLUiT8dvbnvc3z6RgSo64yYfhe+dWUukspJOvX6SiaDOOHWMbPmpQf+nHkHRjohjT100UrGsY4NY/gBhnvWZDgjBWRabM02yvISSQFshGeZXvu4X0XCE55QCJpmljVP9Qe3hjyxw1jjx+Ws2vB/kWTsARHhXyeuN4MRalwKQU7hGqQH7niSDzXJ9lpIUt7jC/730HeQk8BIxx3o4K3MHwDBUlxQnqnKVH5bZDhlK14ca2ZUAzXU6m68cXihLz4FdMfBCsVhgLgKf2EF8ewTRhF6rMMqCZ9FSM7u0khYUpKPIR4rMvg3EP5fWRHj0LMqzKOXM6H2RCye+NRggZ0E1Vhtn0lTjoaA8GdMMgnfj6IpUPkeCZp6+6TJKqewG6QhpJEcr8qwNQHlVKN9G5PpFV4JppBbvREBfsmJFJqQoi8eKs6UkEG9RjaFuReRXgs8caLnALBFJvG8mBCX9gXpZg7fXpwQBT273194L2G4YRTY2kwp3VyfVuDnL9bocKQLFIqgJGALO5XIOhb6hskmW6GBcHrOTPKUWpA1+P+jKEhB7qWBSsix1n3/Ux0bI/esEkbEe7OgoYkkAvDm8nZtZ0FL6vRnvRYGJnxP8scl24FkEYNOnseDn39O7zrhUaCj
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1562.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d40654d-386b-4214-428d-08dd9845e978
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 09:00:19.3335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r11sxDmOREd/lU14gS1xUWYURPpiYrn8g9D8+zWNnax8Fe6QMkhEcK5fUhHr+vlo7ohmMiXqfK4PQw4/EQWrFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSOPR01MB12280

DQoNCk9uIDIwLzA1LzIwMjUgMDM6MjgsIGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tIHdyb3Rl
Og0KPiBkaWZmIC0tZ2l0IGEvbmRjdGwvbW9uaXRvci5jIGIvbmRjdGwvbW9uaXRvci5jDQo+IGlu
ZGV4IGJkOGE3NDg2MzQ3Ni4uOTI1YjM3ZjQxODRiIDEwMDY0NA0KPiAtLS0gYS9uZGN0bC9tb25p
dG9yLmMNCj4gKysrIGIvbmRjdGwvbW9uaXRvci5jDQo+IEBAIC02NTgsNyArNjU4LDcgQEAgaW50
IGNtZF9tb25pdG9yKGludCBhcmdjLCBjb25zdCBjaGFyICoqYXJndiwgc3RydWN0IG5kY3RsX2N0
eCAqY3R4KQ0KPiAgIAkJCXJjID0gLUVOWElPOw0KPiAgIAkJZ290byBvdXQ7DQo+ICAgCX0NCj4g
LQ0KPiArCWluZm8oJm1vbml0b3IsICJtb25pdG9yIHJlYWR5XG4iKTsNCg0KDQpUaGlzIGJyaW5n
cyB0byBtaW5kIG15IGluaXRpYWwgY29udHJpYnV0aW9uIHRvIG5kY3RsLCB3aGVyZSBpdCBjb21t
ZW50ZWQgdGhhdCBtb25pdG9yIGV4cGVjdHMgdG8NCm91dHB1dCBjb250ZW50IGluIGpzb24gZm9y
bWF0WzFdPyBTbyB0aGlzIHVwZGF0ZSBjb3VsZCBicmVhayBpdCwgZG9lcyBpdCBtYXR0ZXIgbm93
Pw0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY3hsLzRjMjM0MWM4YTRlNTc5
ZTk2NDNiN2RhYTNlYjQxMmIwYWMwZGE5OGEuY2FtZWxAaW50ZWwuY29tLw0KDQpUaGFua3MNClpo
aWppYW4NCg0KPiAgIAlyYyA9IG1vbml0b3JfZXZlbnQoY3R4LCAmbWZhKTsNCj4gICBvdXQ6
