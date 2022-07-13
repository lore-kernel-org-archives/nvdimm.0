Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3850A7A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 08:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657699501; x=1689235501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R0XmLzIjKvm0PErqsElSj5trtmtHJPdL3VC4pWtilHM=;
  b=DDurOy0L8lHCGcEP/5bQ7rUdcNkbG87rawdw+YEQFfRIESj6yoIZmBhm
   f2CSWNJHqtT3omn1PFFI1+hB5qT1Xn+PhdSqRouV1LQYFrGrbyT+xWVw6
   vCr1ySDDCIZA/A3KCNzTba7pkw+sAWWCgAWpFUKT8lVBtQR3OrWGqta7a
   E5bEbDq5RWQQ80S3vTRhcSMwNwa8P8pHKVxmM7bjf/QpIZCOq0At4PzJU
   l041NByf6h2V8IyWgVyOcsTInNpiM44Z1Q0YGBpzDLQivRha0OlW28iRG
   B97t08H1uvrh1z5zcaOBia7Py7VC2CS15UMnSUchCRY7rHZOa1XZ0pfvK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285169691"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="285169691"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 01:05:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="922536873"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jul 2022 01:05:00 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 01:05:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 01:05:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 01:04:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRRi6jq+a5BSU4BErm91PXgEqf1w4ONy3VBTt0iwcrCWj9tpYXt0oeHhroJaqFVMrPsScPhJPrR1pzqJnqvkPWCiwu2AOEVMabcK7HnKK5cG3HynVBgg6Hifsl732ezWTEeHt+sL6i9ZI83SQry6i1WfiQeRcqf0/2JO5VXFTNtfpfy8JVVq10iM/y3masW/MNrUKow7J83zEQJpvlXeCvSbysGZqlNeFGm8EDGGIt3nNlMw1+/R6Cg0Vs5bOXK32AwSo7dsEdtQEL7YjwY4oxRYZQt0czacXM+V4t7gpMWtn9Zf2htjVJZzNuNPpcKQQOGx0jJKczfC0ZGKbgoaCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0XmLzIjKvm0PErqsElSj5trtmtHJPdL3VC4pWtilHM=;
 b=kSwTMqi/fJXz6bE/ImUewZsgg6h/9SjoFovt0csQ7yDs3x7EHhEhhWpfZL8wSQWPbLXm0zVk9IpclbyTkxKRYaYjd8lYYA+IlznX4e2AP+6k+OcVepgOso0d2nv4ywZAh29FT93ar/whe3qu98LK7NytZOs2NGGgvFRh9lUdh4K7T5vkDocGKNSB6/smmMXi/s9Wa6ZeJ0J7TOzAIA/8J1s8PyfT4lccgJFQtaTlx76vBfLzxoknloUk0v+EADhKH30HdHt5ZgHXUB4cnLqlrKzFWGSH5cKzwkY0zAuRmfHdL3q8gDZP9lvWW4Tp5Jenu8cH2T7d4DlDlosLJ+iX+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CH0PR11MB5564.namprd11.prod.outlook.com (2603:10b6:610:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 08:04:58 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 08:04:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 09/11] cxl/memdev: Add {reserve,free}-dpa commands
Thread-Topic: [ndctl PATCH 09/11] cxl/memdev: Add {reserve,free}-dpa commands
Thread-Index: AQHYliLC6TspiwknFkmS7FZM5+geRa178jUA
Date: Wed, 13 Jul 2022 08:04:58 +0000
Message-ID: <cac1d3a7a7e6515b2db0ce7ee73db812686d3407.camel@intel.com>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
	 <165765289554.435671.7351049564074120659.stgit@dwillia2-xfh>
In-Reply-To: <165765289554.435671.7351049564074120659.stgit@dwillia2-xfh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35483826-4687-4d1f-1b5c-08da64a66125
x-ms-traffictypediagnostic: CH0PR11MB5564:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GtPqPGM6CngPEduQWTD0TfGL+FjBl5rqQnfiVzPbsSGhwdD5nVRyq3VATZ92qwDwLJ9kouGoX/AQsgz4WzFY8LlY6BCK/aZqJGyuMq4qHgdU7Y/QcTukKv5o7YKg6TCxqV3A6z5JqZ/IjObJsvHzmLcYjduP+WBcr47QzRyGDKJQRDXXwaN6/e+clTrudK8MAv1rKuxeQU6w5YhyaZsDaaI++CbMkttBwtrldh8t7OweETR3axI4Fj9Bk/oZTjgmYKmzDbCacQmmPQiocYimO+aYXwGVmqhD4xu/TWx+PK4sjAW4NvD8VQFQPZWzBHd+IM//kgUL6E2hv3wnYpHXnPuLCSFeOOVhTIA3xpBx26gNJ2F9zDSbc73y5J54ZBEGo90KueHIToJwYzwAE3+lghk/GKfmjXn0VZ9v1R7SXs1mGC+qFtlsD5Cge/yCMDQp8xs2Z+I+Is/EdkfioDKc67WncEtLwErPmkNhlngySsCLYycMhAbhfqAS1BOr3fwqqwlUTD+3faVTucdTxuk/JKnwyiRcozl7q2ke7is5n2Y3F8zA5EBUD+yJ0xV0OvPaI+PIi0a0ypMvgIRaYM3GpEjUnErGS14rzlFbCk9OVfrVvekjTzajuqMx2bW0R5lsggcoS6mk/mU04CUTO4RqAVCR1mfkQVEJtlwmPGkUfDsiEkYyBmFWHxZ+fXK2M1eukfdBBKvp6OK8t55OGOzQu6TrubY7xAmEfTRbrVrO8T5dZEcqMpivPyRUMnu3usUOm+9i/XBZd/OE/Xps7aYISnSrwNsiLhhudWj0CbWEwgqCfPcj15T/oS8K68pAC0V/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(346002)(39860400002)(136003)(83380400001)(5660300002)(186003)(8936002)(6862004)(38070700005)(82960400001)(2906002)(86362001)(122000001)(71200400001)(37006003)(54906003)(91956017)(26005)(76116006)(6486002)(38100700002)(478600001)(8676002)(316002)(4326008)(66446008)(64756008)(66476007)(66556008)(6506007)(41300700001)(2616005)(36756003)(6636002)(6512007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWNRRzArK2M2d2NkNE1ubHI2akswOUVXemRkWEZBbnZXRFdwWGdaSmt6cUxz?=
 =?utf-8?B?L2FtZDJEcDdCNStUTk0wOEYxSzZ3RS9rYTRqbExFWW1HRUZNUjhPSktTRll4?=
 =?utf-8?B?VWJxRlFpQS9MYzVKTUp2WlFQVi9PWnU2MWJ6MTR0Z1V2SEF5Zk1RZlF1QnFP?=
 =?utf-8?B?QURrcS9JNmFSeHE5TXpvSDFEYVJXYkFISGowbUx3UTJxd29nQ0lhVDZlejly?=
 =?utf-8?B?MW1BMm1hOHdTOUkrM3NPY3B6ZHlJZlh2b3Q4QWFwSU9UMStHOUgxSzhxaUZN?=
 =?utf-8?B?UnkrL3VrVGt2VUZLOE1xKzBON25oUU5WajE1YVAwRXhpU3lwdFFVRnNwV3hJ?=
 =?utf-8?B?WE81WUo4R2R3MHJsWWNHeExMVUdkbFRqTWhQVUZFc3hoNUJDMTlRQ0FOWUdI?=
 =?utf-8?B?L25sN0tLWnd5eGVCclNuak1mK0tFTFBQOG92RlZFZVVET3F5akhzdnpzSGV0?=
 =?utf-8?B?eWduS0NWSkFPZmEzei9jWFlQNXpseHFkYTloaVpKSXdyRG5ybmcrWG5renl4?=
 =?utf-8?B?Z3JVemRJYlJXYlZRd0ZROFZZc1VCYTA3TENtaDJKYWw3SHlrdytEcW5FREhy?=
 =?utf-8?B?RllsdlNXWEJzY0VQYjlSaktRcmM0ZHZaTUtwNUpaTUFiT2RpeDBOTThZUVNq?=
 =?utf-8?B?cENhclovYmVsd0lEa0tVNGFIT1VxcVlrblhBRUdzV25wL1lBd0UrRk1mRE96?=
 =?utf-8?B?N1dDWjl5TXJzL01Ic3JHcDZZWEpPVmhmc2RSQ2V6eVd3QVpBUUVMV2J4ZnZS?=
 =?utf-8?B?MWNEU2JjekFXbVVEQ0k2U2srRk5TZ1Z2Qk9WRTZhakhFcUltWDMyZmdsanhq?=
 =?utf-8?B?ZHFXcmtCUnJUd3RDKzlLMFZaSkhVaElheDc4eFNwSVpKNmFTaFlNUmRYTGhG?=
 =?utf-8?B?bGFxVUVLOWx5dGxXYUNjb3M3cTluK3BUT08zUjNzWU5ka0ZnMEVqM2JMZDVG?=
 =?utf-8?B?OHNWRHlUWmpvbUhUSnNlOFF2RjRCZHNNMXEzOXZxU2dkemVjdS9Wa1JuZ0JI?=
 =?utf-8?B?eUpLN250OU5oV2FsZXEyL05rMUxyUzNBVlhBclUrZEZ5bWVtMFNrRmw1R1d0?=
 =?utf-8?B?T2ZGcERLeEdmdWVzUnZ0MUxOV0kraVkzTGZjVGFkYmROVTZBaDV6Wnl3VFQ4?=
 =?utf-8?B?MTlhVk42KzNWVFNDNS9oNUh3V2VOS05HdEhsNWEzQVNtNEJmU1ZEUTF5Vm8x?=
 =?utf-8?B?bXRiaHFzbDcxdVVqa1FBNkwvbCtGNnhTRWpiRzZzcjBOZEpjMnpoUEVydHJ6?=
 =?utf-8?B?NW9mN1J1Q2tMRmJES1JibklmUEQ4eVl0QlZjR3orcm5zSElVV3FFdTg3MHEv?=
 =?utf-8?B?N0pDbU9LRnZWOTlzRm5MVUdtTm1NeFJZNnZVcHp4QkYwc2hBaWc3emRnV0hB?=
 =?utf-8?B?aEk0N3U0ZUFWa2lkbm5GK01tWDFKb3BhLzJRYWFwdUcwZE0zZDNuMExvN0VP?=
 =?utf-8?B?SHU5SGN2b0p3VjRtY3FnU2hrcS9ja1Q0VitRK04ra0d2d2Rxd2w1TE1qWDho?=
 =?utf-8?B?VXdZcWQrVm1ITzgxV0l4TWw3UmRNSFcrUjBwNWh0N0l6djNidmlEMWJqYkpY?=
 =?utf-8?B?aDVXSUJ0RmZiNllCTmNrSDN4ZTIzZ3RVYlNuellrTUwxcHdTQ3pEMEZlY2Fw?=
 =?utf-8?B?cHBHaTNwZWozNDhuWGtEVGkrZEhsMVUwVXlrVFdqdWgxZzdRT2IweHlQMTRE?=
 =?utf-8?B?YkRqTkVneXFiT1EyMmdNc09MUFRrMnJsWW1kQnlFU2s5eDdRNEt2S3U0TGtl?=
 =?utf-8?B?NmkrTldFLzdia2dGNDNhbUNjcG1DelNldVNvSXFLV1pRTngzSzZhWWtmOUFn?=
 =?utf-8?B?b3c4WHF6ekJNQXJKeFRBRnNoVXhwbEJzMFFQVHJSMmhiYnMzdkxKeEZ5ZnE4?=
 =?utf-8?B?N0J6RU03T1dZL2gzNE5qOXpqazVMQjFBdmh4eHlmdGM0OVpOR0E3SGQ2L1ZG?=
 =?utf-8?B?cDUzTWNDZ3hUMzE3cTdDUjhucjh3bnlhZk03aTRYbTBycmxidHkyenBVRXZW?=
 =?utf-8?B?WEhXT1F4M2p5VUZJditIU0UzR0NuanFQT3JuNElYZTNpa3dIVG8wTGhFaUhs?=
 =?utf-8?B?VnI0enlBQWV1M0VUdDFKaVVZVnRhV015cHJxZGx5Y2luM2NOLzlrM2RnQnU4?=
 =?utf-8?B?RU95enBpWDhJK0NuM3lQSHp6Ym1INVZmNzBabWE5UW1vOTlJWGR5aTVqSWxu?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4DE12FE514BA84196BEA5038BAB500E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35483826-4687-4d1f-1b5c-08da64a66125
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 08:04:58.3360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PxpQmUw8jsYylcD4uNVsKu4j4dQ/R7s2iypYcqcli8OcoOjp8SnKMgLrV5wlQWY5JoX7sBe5q8janQpycvkNjiBPjGl0UYzxEONW51SJ08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5564
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIyLTA3LTEyIGF0IDEyOjA4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
QWRkIGhlbHBlciBjb21tYW5kcyBmb3IgbWFuYWdpbmcgYWxsb2NhdGlvbnMgb2YgRFBBIChkZXZp
Y2UgcGh5c2ljYWwKPiBhZGRyZXNzKSBjYXBhY2l0eSBvbiBhIHNldCBvZiBDWEwgbWVtb3J5IGRl
dmljZXMuCj4gCj4gVGhlIG1haW4gY29udmVuaWVuY2UgdGhpcyBjb21tYW5kIGFmZm9yZHMgaXMg
YXV0b21hdGljYWxseSBwaWNraW5nIHRoZSBuZXh0Cj4gZGVjb2RlciB0byBhbGxvY2F0ZSBwZXIt
bWVtZGV2Lgo+IAo+IEZvciBleGFtcGxlLCB0byBhbGxvY2F0ZSAyNTZNaUIgZnJvbSBhbGwgZW5k
cG9pbnRzIHRoYXQgYXJlIGNvdmVyZWQgYnkgYQo+IGdpdmVuIHJvb3QgZGVjb2RlciwgYW5kIGNv
bGxlY3QgdGhvc2UgcmVzdWx0aW5nIGVuZHBvaW50LWRlY29kZXJzIGludG8gYW4KPiBhcnJheToK
PiAKPiDCoCByZWFkYXJyYXkgLXQgbWVtIDwgPChjeGwgbGlzdCAtTSAtZCAkZGVjb2RlciB8IGpx
IC1yICIuW10ubWVtZGV2IikKPiDCoCByZWFkYXJyYXkgLXQgZW5kcG9pbnQgPCA8KGN4bCByZXNl
cnZlLWRwYSAtdCBwbWVtICR7bWVtWypdfSAtcyAkKCgyNTY8PDIwKSkgfAo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBqcSAtciAiLltdIHwg
LmRlY29kZXIuZGVjb2RlciIpCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4u
ai53aWxsaWFtc0BpbnRlbC5jb20+Cj4gLS0tCj4gwqAuY2xhbmctZm9ybWF0wqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAxIAo+IMKgRG9jdW1lbnRhdGlvbi9j
eGwvbGliL2xpYmN4bC50eHQgfMKgwqDCoCAyIAoKSSBndWVzcyB0aGUgbmV3IGNvbW1hbmRzIGFy
ZSBtb3N0bHkgZm9yIGRlYnVnIG9ubHkgLSBidXQgc2hvdWxkIHdlIGFkZAptYW4gcGFnZXMgZm9y
IHRoZW0/Cgo+IMKgY3hsL2J1aWx0aW4uaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHzCoMKgwqAgMiAKPiDCoGN4bC9jeGwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAyIAo+IMKgY3hsL2ZpbHRlci5jwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgIDQgLQo+IMKgY3hsL2ZpbHRl
ci5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoMKgIDIgCj4g
wqBjeGwvbGliL2xpYmN4bC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAg
ODYgKysrKysrKysrKysrCj4gwqBjeGwvbGliL2xpYmN4bC5zeW3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHzCoMKgwqAgNCArCj4gwqBjeGwvbGliY3hsLmjCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgwqAgOSArCj4gwqBjeGwvbWVtZGV2LmPCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyNzYgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysKPiDCoDEwIGZpbGVzIGNoYW5nZWQsIDM4NSBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQo+IAoKPHNuaXA+Cgo+IAo+ICsKPiArwqDCoMKgwqDCoMKg
wqBpZiAoY3hsX2RlY29kZXJfZ2V0X21vZGUodGFyZ2V0KSAhPSBtb2RlKSB7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJjID0gY3hsX2RlY29kZXJfc2V0X2RwYV9zaXplKHRhcmdl
dCwgMCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyYykgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9nX2VycigmbWwsCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIiVzOiAlczogZmFpbGVkIHRvIGNsZWFyIGFsbG9jYXRpb24gdG8gc2V0IG1vZGVcbiIs
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZGV2bmFtZSwgY3hsX2RlY29kZXJfZ2V0X2Rldm5hbWUodGFyZ2V0KSk7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmM7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmMgPSBjeGxfZGVjb2Rlcl9zZXRfbW9kZSh0YXJnZXQsIG1vZGUpOwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocmMpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxvZ19lcnIoJm1sLCAiJXM6ICVzOiBmYWlsZWQg
dG8gc2V0ICVzIG1vZGVcbiIsIGRldm5hbWUsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3hsX2RlY29kZXJfZ2V0X2Rldm5h
bWUodGFyZ2V0KSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBtb2RlID09IENYTF9ERUNPREVSX01PREVfUE1FTSA/ICJwbWVt
IiA6ICJyYW0iKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiByYzsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ICvCoMKg
wqDCoMKgwqDCoH0KPiArCj4gK8KgwqDCoMKgwqDCoMKgcmMgPSBjeGxfZGVjb2Rlcl9zZXRfZHBh
X3NpemUodGFyZ2V0LCBzaXplKTsKPiArwqDCoMKgwqDCoMKgwqBpZiAocmMpCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGxvZ19lcnIoJm1sLCAiJXM6ICVzOiBmYWlsZWQgdG8gc2V0
IGRwYSBhbGxvY2F0aW9uXG4iLCBkZXZuYW1lLAoKVGhpcyBwYXRjaCBhZGRzIHNvbWUgPjgwIGNv
bCBsaW5lcywgd2hpY2ggaXMgZmluZSBieSBtZSAtIG1heWJlIHdlCnNob3VsZCB1cGRhdGUgLmNs
YW5nLWZvcm1hdCB0byAxMDAgdG8gbWFrZSBpdCBvZmZpY2lhbD8KCgo=
