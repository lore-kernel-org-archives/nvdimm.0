Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473121EB49
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 21:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707339783; cv=fail; b=h8QXzgDkpMfl58Uiu89TUeS1cZDMtfUypmicHz9ushZFZD19hh7y08yYlVceVK5+wulLX6kot6uHWfMZesw/s/8k2ABIbyXxo+qAc7VE0rfQHTeAcwzgZGcZHqRJDOoyRuySAfev8BBeZItgptxGKBfu3TR3tfFZzMcr6VlNXmU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707339783; c=relaxed/simple;
	bh=or13VQPElggvfYNgJ1xl5XuN4Ndi8+kXTduyp5E5zcs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WKr3RFSXeoVRJMUBNlivf4D0W/ybyfbdMkReGq6nCcfvSpPMZkyRvhFDdXzBJrVc2f1tTaZybnS8k0WLZKxK9xoTBknyyS9C91mSSeYfvaeEiq8afeWMCB/C5ksfod+NmP3qMZQvu3Rf4qbqRkZa23PjeQKGwVrK8vDYTOcsMPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E1RuWedx; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E1RuWedx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707339781; x=1738875781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=or13VQPElggvfYNgJ1xl5XuN4Ndi8+kXTduyp5E5zcs=;
  b=E1RuWedxOnfUkAdQl1u5keZoI/kJC4eIC2LaeJbP1Y/ZbC3PpmKfu0wu
   +DsT1kLTTjMk9pqFnwmzbqDJXnMZ2mj7tt5jF35s1+BhdUehdfZh7DmVQ
   vlVS635bXc8AHxACCDuNZsopVYWJ38d/L+L4T7WuFwrjEGCH4A9UfwZ7F
   5ejhNbwT+ivILlON89IcKG1YaQesi9oAzWtfQIAWAW3Vgm0ejlCBa55rz
   eeB6uIiaSGOKDtoQkFZ3dNRVFI/7euA86M2yJlcLLbUjARPDHmDH3TMZh
   xG1MlQM0lFPccuZxpLiqIM1z8/tYDCo5v6HPYfTyV2yx+6YixwLxGLpUr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="12169374"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="12169374"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 13:03:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="1754672"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 13:03:00 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 13:02:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 13:02:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 13:02:59 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 13:02:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEIMuXXILe5e5MrT63W80xs/Ji6tKvans7MbdQT14M0cA6jpHa6Cqpy51AxxAfFXxATjmp/uvNA79Jfgv9GfHEjgJSfTqoqyA2u8pj5nzRD10ca70EItBWNcP4wpmPTuozxIuKWOgrr2/Vb/yDF8srhVtrKR3M1fPylwh/0hIkw9aS2FDL+PgotTQcaIiD045OmdeeFYnRl9uKoTlcFoPLKSwi0FP+Y7cIFBqz+9cFn6iQzpxpKu7ScmryI2zvDgnwTjdN4LbuDBi78mSTsIDWYvJIIzZgR5V17+iJk0LOJIRuEN6ZiWcsCG7VvhC5ExZBSEq2l3w1z/2n75bpUMwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=or13VQPElggvfYNgJ1xl5XuN4Ndi8+kXTduyp5E5zcs=;
 b=BGAflE3DIq/J0VCEAQ2a6ozhOcHN1QvbAw+fU+SrFo4lMqNYSrlENeOFl4ZiVPC4pZYfZE5nadYmzLo64jEF8ake6qMup/Z9/GNFhsQaQ2ET1bT/1TshCHXOiLOhU6/IRJzvPisUok5vMQ2UagcHHQo076oAXubifqiObVLd/5Kwv+BmwTixmXzGXCyCGA1p9GVbG3SOVh/BgQNcUIyyXMAEv0e0yzVKZ6nZJilQsaeYoy3RY30dJIMLCBMsZyF5hgbcMn9MOXtTz8US0eLiz3kEu7WEGH9tECD/DBKwYC5NRQO6gyeMFzhLNqceQs9sOCb2cuBMomkQHGYd4Pmu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38; Wed, 7 Feb
 2024 21:02:51 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7249.038; Wed, 7 Feb 2024
 21:02:51 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [NDCTL PATCH v6 3/4] ndctl: cxl: add QoS class check for CXL
 region creation
Thread-Topic: [NDCTL PATCH v6 3/4] ndctl: cxl: add QoS class check for CXL
 region creation
Thread-Index: AQHaWeoSESvPz7YNpUqyqPgMg1TE67D/Xi+A
Date: Wed, 7 Feb 2024 21:02:51 +0000
Message-ID: <51b7c1c3f354b2fe0f0ac7fca9a35de07c5b7f23.camel@intel.com>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
	 <20240207172055.1882900-4-dave.jiang@intel.com>
In-Reply-To: <20240207172055.1882900-4-dave.jiang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH0PR11MB7635:EE_
x-ms-office365-filtering-correlation-id: 77c46466-00ba-4f88-7b97-08dc28202581
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YoR4o0j/PKCXKefqUBAv5Mu4Q/bReq/VODHVLFphpHZTs77XjsusnnkZ6t4hUc3PSk3lnZWRpjthGLuRvXZuFE877ADl1gfpyxiww81bnMtmUpyyXy6CGtLiBqCkdnWHmOHvnretb8EjnHMYStSTO8fFh8F5/gnK68hEPO1dSD0NhfZbiKfbgdTe0jNXZ285ku13ZSniGzTo1VWh5s04k6wltYHPbAagMP0Dc7/dROuH3nEK3oy5A58xnooxtfew2QuPkbLgzVewQ6OQ9eoGSLlBwsi8q7ERFvRifENK1HHKFBtVxt9NADscwQbfcAmXhdKigx0WjR+/JmvqBN4Gn6yUJu0hyZTcyVNUTWp73C8j67HZ3EjisVBHpUYAYHqlRs0KV79I9sQ5N/8ZLUxTAtGTiFB/T58RxkTUT5O4vQ6z7VKLhpYjZgjmc/yZAbP/5VWxNMoL/vO3hib6mO0ZDOKgyI5XMPqByJ2DhOaS5BcZJmwnVIQTtTjx2ONjT/t/Opd33F58DY7MPIaQ7L/MKkmJP45E8yADU+PFZs5zgGpTjjbtA1OWqndWGrKz3CJ3e3RUFScsw5k1xQ79TDBl29sZP/ZjzRdDtjHlLvUvCV9oqWubO6kPZblWNZVQZGJb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230273577357003)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(36756003)(86362001)(41300700001)(8936002)(82960400001)(316002)(8676002)(4326008)(66946007)(110136005)(76116006)(66476007)(64756008)(66446008)(66556008)(122000001)(83380400001)(38100700002)(38070700009)(6512007)(2616005)(26005)(107886003)(5660300002)(2906002)(6506007)(71200400001)(478600001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjY2ZVNPV09LVWI3a2t3MG9JVS9UMW0rZjNRWGpjRmppR3czUnAyZi9Td25G?=
 =?utf-8?B?QlpoUUJmRE9KTEFXZktUQ3gxTmtwa0VTSGFWa3kxbmd5TjFNL05Jc0NxWnpM?=
 =?utf-8?B?RThhdm5PMjJBUGVvcTVBTWF6NzRvVXM4Q0ozcnVYbVJ4NS9Ja3F6VzJTSEk1?=
 =?utf-8?B?dFptcW00ckdpSjdvY1J0OGVjRE5jOG92WjRqeEZGTVM2bEo1enBOb1dIUmpI?=
 =?utf-8?B?WUdtejhTSVVMK1gwb01wSCtSN0duaUJkZE9MY1Mwc0d0UU1QdGpQSDZVUjV3?=
 =?utf-8?B?K2x4dml6bjdKZTBpSllQR2pqL3pDWnFScEcxbDZBTy9wc0t5Vm9VVThkMnRi?=
 =?utf-8?B?dlh0OSt6SlBGUmVYRVlHaUQwV3BoZkM4R1JPMWtRYlZPL3Nxa1E3TU9lbG9O?=
 =?utf-8?B?L2IvN3JoNnJRUk9TaDV6UjgzSE1CNG92SXozamptcTVyM1VuMFYwclZBTE9S?=
 =?utf-8?B?RDA5bW1VblVSWXYwQTlaSE0rYzhkMUkxYU1KVUZHRERCRGRPRXpGZjFab2t0?=
 =?utf-8?B?U0p6MWdDUUt2ZW1RT2k1MER5dHc3ejh1dFlmOUVRVStOUlhBUEVLWHZ6NGpI?=
 =?utf-8?B?QXhyWFlMVmxJZEg2Yk5pS1FSbXpVMTZtYVJKeGU0OU45aGNhdTZ1MVc3K1dT?=
 =?utf-8?B?a25vbHUxVk9vOWllNXJ2RjA3R3BqaS9SREpsNytYR2JkTElmZnppc2NITU9k?=
 =?utf-8?B?cStXRUNrbHRXWk16anRkYUJ2dm50RFJpR0hFM0VodTNIWWkwRzBIR0hDQnpt?=
 =?utf-8?B?dGZKQTNKZjRmQkZaNTRMV1V3bUZ2SDFtYlloS1VySWZQVGhOVXpVMjRtVG1Y?=
 =?utf-8?B?STEvQnowa1M4N3NtWGVOZHh0NDF1cjBFcXN2d0RvQ2JxcnNYSm5nWkM1V01S?=
 =?utf-8?B?QUNueHVoM3RaeDk1Nm9VY3hMZnVaNHRUajRJRkkraGpESVIxek9MVzNoYzZJ?=
 =?utf-8?B?NGRPR3ZRb2d3TkhGZWVIcHNPNVRvaTBJSGJyMENBZXE0SWxtbm9DcVJ1NkJY?=
 =?utf-8?B?c21SZWNGVzROQ3RUQkordG1nWWdFN005aFVRemtaNkFvWE8wZkw2T2d0Tmtn?=
 =?utf-8?B?ZUZwcU5hQk1ESkFkRXhGaTJ1RVpwUXd5Q29lWGI0ckJ5eHBnODc4MWM3MERk?=
 =?utf-8?B?RE00S2E0bElUZFAzQ2FPWk9NQjBjckxBc0JqL05ZdU9JeXlVdUlkcTV2dTZu?=
 =?utf-8?B?Ly91NWtUbXJ0NVVaUy9rWDJINTM3bExpMVVPSW9DcnEyY0lvZlJYYlF5eFBJ?=
 =?utf-8?B?bVUrK0swTlA3ZzVYcytIMDQwZk1VdWtaT2NvRGkvTTRuaDBHL2NHQmp6SkVj?=
 =?utf-8?B?Qk9Scm1jZjVoSkROOEtiSUcxWXJMY1JnSko1WnJrY2FUNitOaVFRcHVYdFps?=
 =?utf-8?B?VXhYdldlVFhGWE5UM2dlZzF3a3dZZ002L2twcmFpOWVwN0FocTZjU1lUaktx?=
 =?utf-8?B?eCsrTzF1ZUJRckVKOWdNZXU2Z1EvRkRaTE9jcThvWmFpOTZTZTFUd1VrbmdG?=
 =?utf-8?B?YnRqaE13a3lpc2dZVGFHUlpKT1YxcHN1V3pKcEJ2dXdRUG9BWkVhRzZSLy9z?=
 =?utf-8?B?MkxoZHg5UERMQ2tTdSt4K1R6ZjZvam1ZNGJWMDdEbW9jS0VUVXBhaUdLWG8z?=
 =?utf-8?B?TUVLdjhGMzNSTU1TL01pL2o0aWtVb20yaTdGT2RBZ1MrYXlmWGxLMzJHMWcz?=
 =?utf-8?B?RWRGNTM2cEdzYlBuR291WkQ4ZDVGeE0zZUxGZzhTNGwyeTJkTFpObkhSZnJ5?=
 =?utf-8?B?MGRpUmdpL0tWdjFiTnlYdk9JUzR6eVp0V3EvWVZmWjRnbzlnMDllR1N5RzZJ?=
 =?utf-8?B?djdIWFM0dWVJaEVTazkwYUZuaFd4QTVsa2hRckZWVHNQUWJSVitENzN4V2lO?=
 =?utf-8?B?bU9leDdoRWtsMGhkeWNGbVhtL05oTS9hbkpLUGRySUQvQnhKQzlXbmJRNjdM?=
 =?utf-8?B?WVQrTDlwdk9HYlFyWGxLU29VQlVHdVY0RmRBcEdLUDhmd1B5N1RsZlBpTGsx?=
 =?utf-8?B?VGRIbTJUbUpIclJEd1lOL0lNWGJZY2FLM0x0ekliZ0taUWRMVXFINGtjdVBp?=
 =?utf-8?B?SWwrc0xya1lTeFk1cE1PbHNOSTBwSEdiejV3NXVTbVNJdml1THJFWUZwd2VE?=
 =?utf-8?B?c3lDSEFyMVppN0tFV1ZqMUREQW5vU1pZM2grdHVFMVh3NENGcVlZRUNGczFF?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19A3FF6CAB9F6D488AF029FF6F3DABE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c46466-00ba-4f88-7b97-08dc28202581
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2024 21:02:51.2647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERXhQOA3FekctcC3oLA6qbp3edAwKcHavzLzgEgDsAJe+7w6FVPvhr6R6KWL6VEhJXYDVYlfYj7/+skSx1qlv0+HNBB6Sy7Oj7HsJPy7iK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAyLTA3IGF0IDEwOjE5IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBU
aGUgQ0ZNV1MgcHJvdmlkZXMgYSBRVEcgSUQuIFRoZSBrZXJuZWwgZHJpdmVyIGNyZWF0ZXMgYSBy
b290IGRlY29kZXIgdGhhdA0KPiByZXByZXNlbnRzIHRoZSBDRk1XUy4gQSBxb3NfY2xhc3MgYXR0
cmlidXRlIGlzIGV4cG9ydGVkIHZpYSBzeXNmcyBmb3IgdGhlIHJvb3QNCj4gZGVjb2Rlci4NCj4g
DQo+IE9uZSBvciBtb3JlIFFvUyBjbGFzcyB0b2tlbnMgYXJlIHJldHJpZXZlZCB2aWEgUVRHIElE
IF9EU00gZnJvbSB0aGUgQUNQSTAwMTcNCj4gZGV2aWNlIGZvciBhIENYTCBtZW1vcnkgZGV2aWNl
LiBUaGUgaW5wdXQgZm9yIHRoZSBfRFNNIGlzIHRoZSByZWFkIGFuZCB3cml0ZQ0KPiBsYXRlbmN5
IGFuZCBiYW5kd2lkdGggZm9yIHRoZSBwYXRoIGJldHdlZW4gdGhlIGRldmljZSBhbmQgdGhlIENQ
VS4gVGhlDQo+IG51bWJlcnMgYXJlIGNvbnN0cnVjdGVkIGJ5IHRoZSBrZXJuZWwgZHJpdmVyIGZv
ciB0aGUgX0RTTSBpbnB1dC4gV2hlbiBhDQo+IGRldmljZSBpcyBwcm9iZWQsIFFvUyBjbGFzcyB0
b2tlbnPCoCBhcmUgcmV0cmlldmVkLiBUaGlzIGlzIHVzZWZ1bCBmb3IgYQ0KPiBob3QtcGx1Z2dl
ZCBDWEwgbWVtb3J5IGRldmljZSB0aGF0IGRvZXMgbm90IGhhdmUgcmVnaW9ucyBjcmVhdGVkLg0K
PiANCj4gQWRkIGEgUW9TIGNoZWNrIGR1cmluZyByZWdpb24gY3JlYXRpb24uIEVtaXQgYSB3YXJu
aW5nIGlmIHRoZSBxb3NfY2xhc3MNCj4gdG9rZW4gZnJvbSB0aGUgcm9vdCBkZWNvZGVyIGlzIGRp
ZmZlcmVudCB0aGFuIHRoZSBtZW0gZGV2aWNlIHFvc19jbGFzcw0KPiB0b2tlbi4gVXNlciBwYXJh
bWV0ZXIgb3B0aW9ucyBhcmUgcHJvdmlkZWQgdG8gZmFpbCBpbnN0ZWFkIG9mIGp1c3QNCj4gd2Fy
bmluZy4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2Zp
ZWxkQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0Bp
bnRlbC5jb20+DQo+IC0tLQ0KPiB2NjoNCj4gLSBDaGVjayByZXR1cm4gdmFsdWUgb2YgY3JlYXRl
X3JlZ2lvbl92YWxpZGF0ZV9xb3NfY2xhc3MoKSAoV29uamFlKQ0KPiAtLS0NCj4gwqBEb2N1bWVu
dGF0aW9uL2N4bC9jeGwtY3JlYXRlLXJlZ2lvbi50eHQgfMKgIDkgKysrKw0KPiDCoGN4bC9yZWdp
b24uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8IDU4ICsrKysrKysrKysrKysrKysrKysrKysrKy0NCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDY2
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVu
dGF0aW9uL2N4bC9jeGwtY3JlYXRlLXJlZ2lvbi50eHQgYi9Eb2N1bWVudGF0aW9uL2N4bC9jeGwt
Y3JlYXRlLXJlZ2lvbi50eHQNCj4gaW5kZXggZjExYTQxMmJkZGZlLi5kNWUzNGNmMzgyMzYgMTAw
NjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vY3hsL2N4bC1jcmVhdGUtcmVnaW9uLnR4dA0KPiAr
KysgYi9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtY3JlYXRlLXJlZ2lvbi50eHQNCj4gQEAgLTEwNSw2
ICsxMDUsMTUgQEAgaW5jbHVkZTo6YnVzLW9wdGlvbi50eHRbXQ0KPiDCoAlzdXBwbGllZCwgdGhl
IGZpcnN0IGNyb3NzLWhvc3QgYnJpZGdlIChpZiBhdmFpbGFibGUpLCBkZWNvZGVyIHRoYXQNCj4g
wqAJc3VwcG9ydHMgdGhlIGxhcmdlc3QgaW50ZXJsZWF2ZSB3aWxsIGJlIGNob3Nlbi4NCj4gwqAN
Cj4gKy1lOjoNCj4gKy0tc3RyaWN0OjoNCj4gKwlFbmZvcmNlIHN0cmljdCBleGVjdXRpb24gd2hl
cmUgYW55IHBvdGVudGlhbCBlcnJvciB3aWxsIGZvcmNlIGZhaWx1cmUuDQo+ICsJRm9yIGV4YW1w
bGUsIGlmIHFvc19jbGFzcyBtaXNtYXRjaGVzIHJlZ2lvbiBjcmVhdGlvbiB3aWxsIGZhaWwuDQo+
ICsNCj4gKy1xOjoNCj4gKy0tbm8tZW5mb3JjZS1xb3M6Og0KPiArCVBhcmFtZXRlciB0byBieXBh
c3MgcW9zX2NsYXNzIG1pc21hdGNoIGZhaWx1cmUuIFdpbGwgb25seSBlbWl0IHdhcm5pbmcuDQoN
CkhtLCAtcSBpcyB1c3VhbGx5IHN5bm9ueW1vdXMgd2l0aCAtLXF1aWV0LCBpdCBtaWdodCBiZSBu
aWNlIHRvIHJlc2VydmUNCml0IGZvciB0aGF0IGluIGNhc2Ugd2UgZXZlciBuZWVkIHRvIGFkZCBh
IHF1aWV0IG1vZGUuIE1heWJlIHVzZSAtUT8NCg0KDQoNCg==
