Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C50BE5E
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 20:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747774076; cv=fail; b=qXjgRfHEq98lVrkcIM0EnKe3l1C6IxwDSZtM9JsAquP0U8IBJDrdCGl9L7RRVsfjNuBFeEesuIpzsq6DgY3EaV9OVl2zrDZZeHj3u/Gr9bnF5U3P/+Haf4ukJYY/WyhhIPHmImuNlZXuHFNcMWB2PCqstdiR+ZXXjAiUey9ZP/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747774076; c=relaxed/simple;
	bh=ElOM1lnr84PUl6wZRiT2A5VcRz2n87WiQs7CJWW7tLw=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V2td3JkmXZ6uAeCtmNbTMhCl4XZJU58+5Y0ICFFo/l5bVC/ieGXdg88QNzd/c+uQvfK+hu8WaSronGCnG4U7EnV8hGNA/Lwn7o0zYWRYZ1etzcuif+osjZHsjdKWPjOKuUkUQj0WMG/FdMFyj8ynM/SC/B0tNhb8KfqDjH6WOJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAaed6Ea; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAaed6Ea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747774075; x=1779310075;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=ElOM1lnr84PUl6wZRiT2A5VcRz2n87WiQs7CJWW7tLw=;
  b=AAaed6EaMVXsQzKBmmDKcleltvkTXGiq+oQlC7x4YrmlNQSsdnRxZwy/
   R8PZpWNQozMSQ+Y0JFE3MglYszQQAcmlFYvg4rQWEEggW/4xnvq5vA22s
   KgKamIDT9BpxJPXX9bw4u7+uy+oT5mU3/U3e6k1dt40Bnz35uiqrcolu8
   Up8feATXM9g1qaNpml2fU2RJJ8p5tSnwcn4ohT01CC/Q6mEyHvJHaBNow
   Wr5DEzYK6DBpzkF35WVbwMZkA0oTuNg6ATPbAcTRvUcGIPD0Kj30pbwg9
   dKq+bqf610i3+JwTNTBScyCv1HcA9fbS7XmxU3bALRX2xqBbCbOzH7yXK
   Q==;
X-CSE-ConnectionGUID: WRLEMv33S1ySp8XUgl4A5g==
X-CSE-MsgGUID: 9QbtLztlTpOf6LtsX4F6IQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="67141104"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="67141104"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 13:47:55 -0700
X-CSE-ConnectionGUID: OlSl/nDxSVauhrpj3WHB0Q==
X-CSE-MsgGUID: KHtSAO+eQRqEySeeKrOLpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144672138"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 13:47:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 13:47:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 13:47:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 13:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XNkNKk0DKWADnd1mEG8ZPuLTKIOZyFyFbFDH5JurxqRCpOSyMU6rpmaoVJEW7HpZgHkSy5RH+ExjY4BcYGqjGl6GC7oQifgdt5Qk+VsA4NtinbRNEKccJ4D1vpvob1P1TScibXjgs9m20E37BbiEEC7PT9qzGQfh4K6BeiMoLUFdETdDfjMz+dit2YbOvv99yQxi3zlcRWrLhRYf6GtRS5u6zlnLSJce8Kdo9HMtS0qpLrPnTWpmgc3TJqH51b7q+CuGByKraD/5rhLYpnoGROWjGD59Mq/5BvXy0X2MPpbYbZnowTZJ1OBjgAc69hrPeTvIsUMxK9aEKCmHVcb8IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElOM1lnr84PUl6wZRiT2A5VcRz2n87WiQs7CJWW7tLw=;
 b=Ik2I2JyZmfMpjLiDE39OajQ6sJ/eEaFl1kiUio67gp49KpKyt5rbvuUBpPmdbGHcYj+zkHE9dep43yyeZ0pp+piePT83Oi+Cg/UV8djlXW9/0zJ2eJLFg+rS/DYKEO0pfAqjjeQgRc1B7Xtg5IPbXynuRQxkhD1dVMFi7xvT6LCoLJkrmkXvfZcG0anREjzko9hDp6jsDKMN5PRf+MjZBc6S4oBriEfszBd/J1++JvFHwFVTRemf8ut7ac/IcsiM3SiY1tTg0/f5tXhAaCaPdKBG/vZPnyyKfU274hRQH/rIIp4bQsS8Xn1zkHTkscytEx3B4AjooIPM1Tbo9yQ4Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by IA0PR11MB7353.namprd11.prod.outlook.com (2603:10b6:208:435::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 20:47:22 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%4]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 20:47:22 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>,
	"marc.herbert@linux.intel.com" <marc.herbert@linux.intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "lizhijian@fujitsu.com"
	<lizhijian@fujitsu.com>
Subject: Re: [ndctl PATCH v3] test/monitor.sh: replace sleep with event driven
 wait
Thread-Topic: [ndctl PATCH v3] test/monitor.sh: replace sleep with event
 driven wait
Thread-Index: AQHbyPRSkSBELZTbxk6Dqofqo9mL0LPb/tuA
Date: Tue, 20 May 2025 20:47:22 +0000
Message-ID: <f09a9e5b40838036e2355f44eadf00b9fb4168e5.camel@intel.com>
References: <20250519192858.1611104-1-alison.schofield@intel.com>
In-Reply-To: <20250519192858.1611104-1-alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|IA0PR11MB7353:EE_
x-ms-office365-filtering-correlation-id: acb31757-bd93-40e4-1833-08dd97df8561
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NTlueTEzbE90QVdHMVhHS1ova1NtRGJxV0xvbkxNY1F5VlVBcXpPTDJFUk1D?=
 =?utf-8?B?VXc4cjFneWloN25saU5UMW1BYXFQbjJYQXFFVVZGUU5IdXJBKzJiNllabENN?=
 =?utf-8?B?MVRjajFITXRSLzJKU2UwTTB6MXRndGpoWE1sZllGY3RSWGZ4STdrUjlkb0dm?=
 =?utf-8?B?bGlnNlMrOWhlWnpPQUJBOHU4ODgxaVR5Z3Y4bktVS2pEQ2Y3NTlaS1k1YlVR?=
 =?utf-8?B?bDk5R0FuWHhCWU1hVzlCcTg1aTgwZmtMNk4xM3J1bmEwaXBYY1h5cVpUdS8x?=
 =?utf-8?B?UnkvVmVsQmVhK2ZvN0VhMlA2Y3pZMm5wNE9Ib2l1U2wwbVNiM0FTd1ZqSFg5?=
 =?utf-8?B?c0MvanBhUkc3b1k2MXkxZWdzdytCMHVJcVBCZWJkV05vTFI1S3RKbmtrYXBi?=
 =?utf-8?B?UE16dTdSL2ZOaHA3RXJVb3lLU1VTQmF3b2p5blJ5Wm5SUkVRRmJKVHhoM2RP?=
 =?utf-8?B?dGgwMXdJQStIYTRkUTdraXhOVkZidFJNNWpwQ1ZaQnBsYWhzaU9Ia2dmdm9u?=
 =?utf-8?B?eTR2cTE4Z3hyczlnK3p4OC9kM1ArWHBubVNMZ1BNaEt4YUlvMWQvMENFMEtr?=
 =?utf-8?B?T2ZOL2xKbHFLQXNvZ1c1d1JlTG1aTHh0OWpLQVZFSjhmRGRRelhKUnBldUtH?=
 =?utf-8?B?OU02YktzOGwvanluK2UyRXRxUEduOGJFaDFaK1Z2ZkF6WFd1cGlTQkVnS2hG?=
 =?utf-8?B?L3gvNVRtQjNxcVo2L2g4WmZzZ0FMd0lQeEZlUlVrQnJNVHExSlRUS2JUNCti?=
 =?utf-8?B?T1JWdVZuUFNoek1lU2RueTZNTUp4dDEzRzc3NlFIU0pBTjV0TmtmeHRBRUI1?=
 =?utf-8?B?YmlnWHdNUkx0ZE1BdFkzZ2dMNmo3M1VlVW1TVnBPNlliSXBYUGllRmVvck40?=
 =?utf-8?B?RTZEUFlKN0FhblJ3STlCSDRJeEFmL3NWVFFEcWp6MkJuSTdIaHJncUdzVWNm?=
 =?utf-8?B?RGNCK09tSnBqZWloU1FmOTJCcldCMm1yN3Jnc1VzbzZIbzhONUt3b3lvTCtL?=
 =?utf-8?B?VFNNYjRKQzNVUVBYWHF6U0FTd01ZN2NqM2QyOHNseXBuVVMySkhQYmFheHlG?=
 =?utf-8?B?TGtjN3M4TnA0Nnk5czJqS2hYc0ZCekozOFd0QUpQWTUzNUlwMm93Z0dRdGNY?=
 =?utf-8?B?TWRZVGRNbUEvQUVCZ0taNkZyNGttTUFKUWdkbWh2NHE0S2d5eURjb3o4SytD?=
 =?utf-8?B?ajdEY0ZNWERCQkhSMjY5MTd4L3F5QTlUNlVSWStlSGZRSUJsK3dxczFsUGFK?=
 =?utf-8?B?Z0xNZnVPQmdRVjhaWnZTQjZtUVhHTUZuMm5oakRXeDRtalNkMlM2UGwza0hX?=
 =?utf-8?B?aHdObGxWalVPMlc0VlN0MGNraUJYWjZQR1JrelNvOWtvdzk0U1dhZFJSOHFQ?=
 =?utf-8?B?ejVSMGNpeXhmR0tSRVZWZU9WVkVJNm8rRlJLSjRGSlhjOGhRL3BpUzJPMDEw?=
 =?utf-8?B?S3hhclZ2NjJscmNES2JUU29oK1J0WlpTTWhncVhHM2FmRDFUbnFxdHVzREhR?=
 =?utf-8?B?R2tPVVBHdENlMWp4K2pDV1pnZVVlQ0V1bWNLam5rTWpuUlZUSUhhT3dLZVRP?=
 =?utf-8?B?VlRXcENLbm1RQWJVdEs1TDRCb2ovSjFCUFNGRE03OUMyalB5ZXYxc29FRk5G?=
 =?utf-8?B?T1B6bjRNYjBBT0VlYllNdG00WmZUc2ZieE82QjA4UjZKWm5CTEVZV25qc2lG?=
 =?utf-8?B?eGdxY1lhMEh5OHZZZDFla2lacDY2MzNiVmVhNG5JMXU5SnA0YktpSnErdTNT?=
 =?utf-8?B?VHNpY2YrSW9YcUZ1S05mYjdCYkRhN0hUOWZxcFBQM3B6OWZlcVd0aVp5Z2lC?=
 =?utf-8?B?Nmx2amdyQ1RzYWdpUHJua0tXK3BmYzRESFVIZTVVSWtaM29aY0hoZXhOc3B3?=
 =?utf-8?B?YTh3UGdSUXZMeUo4aWhQTWJ4eDFxZnFVOFdJb3JzYkpnMzN2cDd0U3J4VGpX?=
 =?utf-8?B?Y0QvcU5sNzhiVG95V1dWUEZjSzViMjlHV3JlOWlxbWFrZDNRa0t3SHU5TGRY?=
 =?utf-8?Q?ByH3bdaHKXhEyyluIxdp2MejQAxpUQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3VWVTJWQ1NqdVF4N0pwOEN4aUhIN1oyWW00eFoxRml5dDVIMHk5bDdjUHF0?=
 =?utf-8?B?L1pNMGdXaXRDZ1JScCtHcUVjNTkzTVpNWHRxcGZtUVNjNVBNWjk5SklOTDVm?=
 =?utf-8?B?eU12SXhGQWhvZTJUeE56NWEvUndtRHZYeFhqeXJwY2ZzTEkrL2E0VXJKWjEv?=
 =?utf-8?B?UVpub1AwNlkvdnU4QWxOSnBmT25GRUMyejBvV2pmV3B4ejVnY1VKMjJscjc1?=
 =?utf-8?B?OXVYVnpwdFkreldFbzVDTmxjZ0ZZU2dsTDZVYVdxNzJJK3VGdGxZNTQzQjh1?=
 =?utf-8?B?eFhINDFacDVlbEg2aTU2aWRqRmYzVWk1Q3lMZG5VeWcrMmdEY2hWQnRRZGYw?=
 =?utf-8?B?eExrdkVQb01Fc0FzMXJWUGF3Z2dreU45MXgyVithYlVKZmc1a2hhTzA3TmFS?=
 =?utf-8?B?ODM1SlJCcHg3a2crMldTcXNYUmpHVlhoUFdraEJCM29jOElucXUvNHlrZWIx?=
 =?utf-8?B?Z2FyVWtZYm94ZitJMGNWR3VuMjNmdTJueTIvN1BsZmtHbkhFM1ZzemxaQ0s0?=
 =?utf-8?B?MXY1NkRJVjU1MmYvU2J4Slk3STRCVjdvcmZRN0kxQi9FR1Zmb21WaVdYTU5h?=
 =?utf-8?B?Z2RobmlSVGxvdnBXU215TjF3dGFuM1FlK1hJTVF4dGNMbmpneVhkUnowNHBj?=
 =?utf-8?B?RWNFYlJxZzNjR016RmhmMVR4S1R1b0cxL2FYak5BZGJJc3BValZjay9oYmcw?=
 =?utf-8?B?azFmcXBqbWFjaW5QU0hOdEJTUDlod1RMYWh0WUNYd1ptYUpNR0l6R2MrN1px?=
 =?utf-8?B?ZE5TdEdRWDJyWk0xN3oycHQzaUN3WXRqdnpvNDF6U1hhZ0NLck9VOXZoNlFq?=
 =?utf-8?B?akRFaHl6VCtPbjdmczdjTGZmbFpQSTh4OGIyWFFmaGxrMElwU2JZOUhINWhj?=
 =?utf-8?B?SXUyYlFmL3l3bnhrOUovc1VYc3o0WDE0ekU4bWM3NzN3SlhkaWF4dGExWGVk?=
 =?utf-8?B?bEpSQUpkbXd6RHo5NExaMHorbnVTYldBdnFaejI5bm9aNUVab1VGUkRsa3Qr?=
 =?utf-8?B?cWczdzJCV2x0TkJkczI4T0tHRU8vNlpxUVAzOUpvNXBtSjJmb0N3bE1LQklh?=
 =?utf-8?B?aWlBSEdKcGwzUmNFMEY4a09yb0ZmM3crWEJPRUNBazhqSncvZTNVdC92QWF5?=
 =?utf-8?B?ZnBBV0RKcWdXekJ1aUdpQ2RtTitxaFZpWkNOclYyTUtGc3dod1NrL0o0Z2I4?=
 =?utf-8?B?d2c3M0JudXE4S0h3czhNY0x4bU5JOXBVbkVoeXY0SXZ5dnJkV0h3WmZzNzdT?=
 =?utf-8?B?Tk94VjJuTys1YUxjUnJFL1lSTEJ2YU9pK2FuejlOcENlNzRta3BqK1BmVSt4?=
 =?utf-8?B?NzdsYlRFdlhaaEJvNHZlL3VKWUpxNFYyUlJBalNySk0wbjRodDJBa1NRdE96?=
 =?utf-8?B?Z1o5eGE4THBLNVY5SGxSalpuTnJzanFBQW9DSTBPY0ZNdzM5dEY4eFM4dE9h?=
 =?utf-8?B?VjRvQy9HWWROVDJHSHFrMzJ3U2c1bU5vZDFQMFZnc3VacHpKMm9yTlFYaVlN?=
 =?utf-8?B?VmlEZFRoOUo3Rm82NldiWEhmeHZZbHBnYjFHZ3ZxazFjUHQrNnFPMTdneTRr?=
 =?utf-8?B?WWV4VVJvYjBDVVFwenl6akpFT3RxdUhnYzdtVEVnMEx5ZFpBVHM1RDNOaTEr?=
 =?utf-8?B?Tm1BekNpaGZPSHJGMFRtSlpuMVVXaXpVRWw0d1lXT1M2TVA2T2htYW1uL1Bk?=
 =?utf-8?B?Yk9kNlF3TFBzWVBQdmVCUno2VCtuUzRwMGJPTEpadXB5N2tuYW8wQ0NpZWdr?=
 =?utf-8?B?aE1GYmNLWmE4S2hNaWZCNVo2NCtNeWpsNEFMc2cxdGIzN2kwejFaYUkvME5P?=
 =?utf-8?B?VmNkbGtVM0RqSzIwbDhaSXBrc1AzQWg5QTVpUmp6WXlCYlFvTk01UkxZM0pa?=
 =?utf-8?B?d3RzOWRYWmpreURyek9sSHpFb0wzUHNKQWtlSDkzVytwNkExcjk0WEtOMmdB?=
 =?utf-8?B?REJzcnNjUU5YQUFYMldVQnRDeE9zNHZtV2dnS1ZOYzluaDAzWHNPc2ZiOS9N?=
 =?utf-8?B?U3NSTHlKTFc0eUoxRFp2alNEUWFYRGloQmRJcTJicG5NOXFJc25QS0RPWit0?=
 =?utf-8?B?a0I4OWhsekhKQU55cXpBdVRIS25kdG04eml3UW9nSzk5TUtWUlg1aHAvTml6?=
 =?utf-8?B?YktOSkJmc1lZS3VBc0w3RjBQbzllbXhOZW5ldXZEVnU1c2g1eXFTY2MySmtX?=
 =?utf-8?B?aXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E958B212975E49428EF4FE811CEAD3A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb31757-bd93-40e4-1833-08dd97df8561
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 20:47:22.7485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvG2WqTtWBftek9+i9xRUS/sgWGaIUuU1B4o/fv8ejfZId8NCjZ9MHMIk1MyZhw6Z57Vf87yApfOlHACUnPzlCl5T46BAnA+O6KlO+khqxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7353
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEyOjI4IC0wNzAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBtb25pdG9yLnNoIHJ1bnMgZm9yIDUwIHNlY29uZHMgYW5kIHNwZW5k
cyA0OCBvZiB0aG9zZSBzZWNvbmRzIHNsZWVwaW5nDQo+IGFmdGVyIHN5bmMuIEl0IHNsZWVwcyBm
b3IgMyBzZWNvbmRzIGVhY2ggdGltZSBpdCByZXN0YXJ0cyB0aGUgbW9uaXRvciwNCj4gYW5kIDMg
c2Vjb25kcyBiZWZvcmUgY2hlY2tpbmcgZm9yIGV4cGVjdGVkIGxvZyBlbnRyaWVzLg0KPiANCj4g
QWRkIGEgd2FpdF9mb3JfbG9nZmlsZV91cGRhdGUoKSBoZWxwZXIgdGhhdCB3YWl0cyBhIG1heCBv
ZiAzIHNlY29uZHMNCj4gZm9yIGFuIGV4cGVjdGVkIHN0cmluZyB0byBhcHBlYXIgTiB0aW1lcyBp
biB0aGUgbG9nZmlsZSB1c2luZyB0YWlsIC1GLg0KPiANCj4gQWRkIGEgIm1vbml0b3IgcmVhZHki
IGxvZyBtZXNzYWdlIHRvIHRoZSBtb25pdG9yIGV4ZWN1dGFibGUgYW5kIHdhaXQNCj4gZm9yIHRo
YXQgbWVzc2FnZSBvbmNlIGFmdGVyIG1vbml0b3Igc3RhcnQuIE5vdGUgdGhhdCBpZiBubyBESU1N
IGhhcyBhbg0KPiBldmVudCBmbGFnIHNldCwgdGhlcmUgd2lsbCBiZSBubyBsb2cgZW50cnkgYXQg
c3RhcnR1cC4gQWx3YXlzIGxvb2sgZm9yDQo+IHRoZSAibW9uaXRvciByZWFkeSIgbWVzc2FnZS4N
Cj4gDQo+IEV4cGFuZCB0aGUgY2hlY2tfcmVzdWx0KCkgZnVuY3Rpb24gdG8gaGFuZGxlIGJvdGgg
dGhlIHN5bmMgYW5kIHdhaXQNCj4gdGhhdCB3ZXJlIHByZXZpb3VzbHkgZHVwbGljYXRlZCBpbiBp
bmplY3Rfc21hcnQoKSBhbmQgY2FsbF9ub3RpZnkoKS4NCj4gSXQgbm93IHdhaXRzIGZvciB0aGUg
ZXhwZWN0ZWQgTiBvZiBuZXcgbG9nIGVudHJpZXMuDQo+IA0KPiBBZ2FpbiwgbG9va2luZyBmb3Ig
VGVzdGVkLWJ5IFRhZ3MuIFRoYW5rcyENCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsaXNvbiBTY2hv
ZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tPg0KDQpUZXN0ZWQtYnk6IFZpc2hhbCBW
ZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJt
YSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KDQo+IA0KPHNuaXA+DQo+ICsNCj4gKwlpZiAh
IHRpbWVvdXQgM3MgdGFpbCAtbiArMSAtRiAiJGxvZ2ZpbGUiIHwgZ3JlcCAtbSAiJGV4cGVjdF9j
b3VudCIgLXEgIiRleHBlY3Rfc3RyaW5nIjsgdGhlbg0KPiArCQllY2hvICJsb2dmaWxlIG5vdCB1
cGRhdGVkIGluIDMgc2VjcyINCj4gKwkJZXJyICIkTElORU5PIg0KPiArCWZpDQoNCkkgd2FzIHRl
bXB0ZWQgdG8gc2F5IHNvbWV0aGluZyBhYm91dCBhIGBzZXQgLW8gcGlwZWZhaWxgIGJlZm9yZSB0
aGlzLA0KYW5kIGl0IG1pZ2h0IGJlIG5pY2UgdG8gYWRkIG9uZT8NCg0KSXQncyBub3QgbmVlZGVk
IGhlcmUgc2luY2UgdGhlIGdyZXAgd2lsbCBmYWlsIGlmIHRoZSBmaXJzdCBwYXJ0IG9mIHRoZQ0K
cGlwZWxpbmUgZmFpbHMsIGFuZCB0aGVyZSdzIG5vIGNoYW5jZSBvZiB0aGUgcGlwZWxpbmUgZWF0
aW5nIHlvdXIgZXJyb3INCmluIHRoaXMgY2FzZS4NCg0KQnV0IGl0IG1pZ2h0IGJlIGdvb2QgcHJh
Y3RpY2UgdG8gZG8gaXQgZm9yIHNjZW5hcmlvcyBsaWtlDQppZiAhIGNtZDEgfCBjbWQyIC4uLiBl
dGMuDQoNCg0KDQo=
