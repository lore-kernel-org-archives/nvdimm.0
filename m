Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058F72F2F
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 21:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670966281; x=1702502281;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ED0IRFQTbPHUpkKi6oamb4h2FSWJ+RaBDG/IzJQ3mwg=;
  b=KaUFUgDTRdyOFj7PGgolsngKHsyS1Y3JamQwWy7ckBP9Jjl41RsDk65X
   DUTi7Bm2Xo8G+VbWHle5X6yQEqNxhYjWCu7FMQ8x9JlbWnaoEvGNzZGRv
   nvndRBct18D2MuSuIXxFMBNHDSWFvxpa9UNW2mSW9bdkuTLpBIeDSyumv
   oMjwXsg0Iifz0FDQLQr/4QBVbdsACinmEN2vJQPa4hhZl0iGpt2tN5jbP
   7xccwU62T6SigJwcEhKzYMEo8yQoVSpS2YE8oNXPql51ZQfsQDV0IMmbP
   FUEwySCGfTIo06EdTHdXoFz1gUkjCmKYjI/gNhZ+mV6PClNj+q0phWIQS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="318281581"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="318281581"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 13:18:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="712262506"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="712262506"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 13 Dec 2022 13:18:00 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 13:18:00 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 13:18:00 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 13:17:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfpaJOpg/oPtZh6jbHro4+joVOXuWTl/NHL9zJuWxyPW+/bbsvjSW4gafLNG3kjaqJZ4PhZFJcCtLOdsfAR8E+mVSeZHUQWr23meLTdM68rmVyVRtq36YuuOEOILwsg8xuhDfhuv8ZfQC8OVx2O8qpMscQPWpwovr5LucBjnekXVL925V6zvWfcv++sMaEfQMv5RzXBu69DtGD/CtH5tNbYgrrNQ1KX4mKsWIfoglBftjJl+9mVdStZXqL7O3jhMp4ASZPlqfOqStTaKUBoEdCLR0Zwt5bae8MNnIkLm1Wn+xFrdzDbis3bBijq3bXZdeiRCPdpc+1T+Lg6NJDV0vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ED0IRFQTbPHUpkKi6oamb4h2FSWJ+RaBDG/IzJQ3mwg=;
 b=P8UNTjNN1WCeKr3So13QJ+ZA7tGsVjJ8QKcDV0ntum4BoL8w9Ak7x1fR+uPucoWe/mkpOTh6qWZHoSTLXwBj9m+RkqAnSxvqIt+f2pf61tviaPKVrhCOZ/IZp7nXHcCXqjFuL753sbbvwWE5nRRXBi9UQ0EVIGgbfjGQtnRN0K4F2lMsZTnbrR5AssfU8zDzrwYB0enmaF9lzi9ESyGlM2Ws4Hbz4ua8Czr4/ut6+7iczskkGeyG4uBegX+JgKyWwG2Rux8bflicmc1DHL6R4CAWWiYBE0CY8MJKZragKKStUPui8IN197fS8SjJpi3Dv3vdcObDaW5BRocPbBsmjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by IA1PR11MB7811.namprd11.prod.outlook.com (2603:10b6:208:3f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 21:17:56 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 21:17:56 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 15/18] cxl/Documentation: Fix whitespace typos in
 create-region man page
Thread-Topic: [ndctl PATCH v2 15/18] cxl/Documentation: Fix whitespace typos
 in create-region man page
Thread-Index: AQHZC0wqm+U+TtttJ0q6gfbMmViksa5l0hIAgAAJJ4CABn7qgA==
Date: Tue, 13 Dec 2022 21:17:56 +0000
Message-ID: <093c6341db8016c2e6699c4e25e9cd9723be923b.camel@intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
	 <167053496662.582963.12739035781728195815.stgit@dwillia2-xfh.jf.intel.com>
	 <Y5NxYqD7Bgo2nT0W@aschofie-mobl2>
	 <6393790f8bc12_579c129434@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6393790f8bc12_579c129434@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|IA1PR11MB7811:EE_
x-ms-office365-filtering-correlation-id: 7e5dc0f7-7d28-4601-8d2a-08dadd4f8113
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JPL0jeUbrxxvI/PthEMzUjVSRG3R52egfrGn/wPwVZDz6eCn/91Sk4CCfJ85La4clYZxGzP1ucwQF0hse9NtlxmrLTnSObAhb4AJL0O8hzlupFA79vbb3/ZdH7f0i6A39br/9Eqgz+novYjh8QPQGjSPFTGKxN8lNcgQDrF25Umh+fbK9VY8rXZc1sPiz32ma17ltOz4nLKFKyU77f/NDDH3VURxXluIotGsZL91LMnQXD/6bMRN5jZfV1IL+cRNOLIjse77TUhf+HEYNYnkEEEc/hHVHQTrIRAUwhaYw2hs+GahW5ixobmyfR2gqGPyB94HN8ajWvmUSVQs01E443wsjwYqDIwpmkmB8k/WP4KsCqmPl4xNrKs8pRq/eHMilMwDNw6bDkqMdSxjLyBWichoLrYok5gmTheQ4Q288m1l9AE0PcOzHO2XRznGO7RQfqAmvwG4C2kYfwmyiideHPA1+DJMdHvyinNvox9Qm5UCgC4B758i/dspDTIYVG2vv0W0L79AhBWYA/LHP+LbhHEBgm+MUNXAgm6Hkgsqou3DKOOekGYtucorFUNbDRwydS7x5sjN+GNhjlgEohoFGEFs7EMWHdnEy62hOyBePqIRx8T/4nEJ5qSM2sAXXgmvZwLUdQ5uZ/IqVhFYiFvix5Pye0K11mQWvjffnQJqwV1+FMuKullkFck2pX2kJdnuGWiQKMtqPCGudKPxVk849A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(66946007)(41300700001)(6636002)(316002)(76116006)(54906003)(122000001)(91956017)(66446008)(66476007)(86362001)(2906002)(8676002)(4326008)(8936002)(82960400001)(38070700005)(38100700002)(4744005)(36756003)(5660300002)(66556008)(71200400001)(64756008)(6486002)(478600001)(2616005)(110136005)(6506007)(186003)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3NFKy9jQ1VlVUUzd3FRSWRJMUlXRVg4REJ4Sm9vVGRORnNES2JrQW54QzB1?=
 =?utf-8?B?d1NCeHlJcDljTGd0QU1VTW5IaTBJSnZTUHcxVFhsTU15eW1mcFptQmRBUW5h?=
 =?utf-8?B?eUhIejVoZXd2NlVCU1JlU1NXZXdKaGVobFRka3dObTlPdk9qdnFDMUJ3bU0r?=
 =?utf-8?B?WjZXbC9hRzlhbkE1K0dQa09xanFEd0xsZ3Vpa3F4RlJpZmVjWHZ6UVRRMDR0?=
 =?utf-8?B?Y0VjVEJhV1JZWi9sTS9CTDFmeE9ibEU0aGhaeVQ0OGFEa2J4NGFtY3E3NG9X?=
 =?utf-8?B?RzRsd0ZJRmdpcGVIK2tOUDdGNDdkMEVoMlVXL1ZIeS9wNXgyemY5REZWOUFh?=
 =?utf-8?B?RVRCWnA2K0twemk5OWVJQlFaZ1VzUEhGaUowNHpSZ2JVcEtuMEoxY084M2Zu?=
 =?utf-8?B?TFFqQ2tLcnJoYUpUdnlCcXpSMGZuRmZTOUZoeWhzZTJJVjRxVW9ydmhPN20w?=
 =?utf-8?B?S3U4L01YNDhLbFpGUzVmRDR1RUJNeUVIdXRidWZnck1vbjF4UFZ2RnpaaWpQ?=
 =?utf-8?B?eGxGYU12WXJWVm1qMFJMQ1RHZThMd0lUbzFOUzNNV3VIeTFiUE9TNkdha3ZN?=
 =?utf-8?B?VzdieldQWnYrVCt1YnlUWWtMd2t5cXFQR2RaZFlmUStvd3VFWlFqSmo4WnpY?=
 =?utf-8?B?NFIxMnVhcWx3L0pzUTg3TU85MkgrZ3d6eUs4REhqSFRpaWxVdWJWbklNUEc3?=
 =?utf-8?B?aXlpcDlteHowUnNoOGpJeitaL2psV2FwL0Z1VThBcUIwNjMxanpwZUh5L3Bh?=
 =?utf-8?B?MzZPL1J4dGlmN2FGNHByalV2c1BZYUQ1Y3dkeHhCbFZPL2krNmN4bVRkemVG?=
 =?utf-8?B?NDJaQjU5VXI0MnBwK3psQkM4N3dqdTg1RFdOZ0ZrSDl5cnFHTXRWRUttY29M?=
 =?utf-8?B?bHQxeXRPbXZjN2hCYWxjMTJTTldSTEJ1UlB3WEdwZVVnVmNqeU5VcXNxSnV2?=
 =?utf-8?B?ZDRna1hiUFlIbFpBR0VCb3hFL25JT1pJZDJBdGZQN0JDbG50bWpvTURHNWJy?=
 =?utf-8?B?Q2d3NlFFWHZwTGZSeTlHbGx0WHo3ZnRaY240a2FWQjgvd3JEdmJvc0dhdm9a?=
 =?utf-8?B?dEhyQUpvQ2pXdDNpV2FyazFBUVJGRmVJZVBuTC92REhyY3ZacFA5WWZ4aUhY?=
 =?utf-8?B?VkdNL2xVM01aOXJka1RJY2xvaHdKU00wOG14MkZRZ1o5cDhocHVFWDhQdGR6?=
 =?utf-8?B?TTB5aWMxTTNzTWtweVd1K1lCWmJMLzFMN2ZORENnakxZaEIrTEpmMFZ1YzJN?=
 =?utf-8?B?bHkzazByY3V4RGtXVUlhbExUbE05V05XWmwvbDBMTnZiTU50U3F2aTJ6emFv?=
 =?utf-8?B?bjQ0OTMyRVNwKzFid2dseGd5c1B3aFFuU3U4MjNRTE8zTXNjWU1pVGZkOTFl?=
 =?utf-8?B?SnhWT1NjWTRVdytWL1dOR2d6SnVML0NqbEJXQXVqT09tWEVKSVd2a3dMdmZh?=
 =?utf-8?B?K2orUUxuUGVCeUUvQjhIYVhsdHNyTHJGaytEUFZCbUtucTA1UlNvSWhwWUJp?=
 =?utf-8?B?cm9RcU5xQ2h1T2hHbG1LMFA1aktYZlI4TUY3c2Z6UzFIdkhQRlg4d0JoMTB1?=
 =?utf-8?B?SzZNRnk1MmJJbHRMU1AyREI0eXFBUnpZTisybmk3ekdGejh5aG43Z25OcWFy?=
 =?utf-8?B?MUpTN0JDUkFhOWFIVEhueDNKazNwV09ZWnhCdGdFemJwWWxMNHcwaCsxS001?=
 =?utf-8?B?djdsNHlLK3Jyc09GY2JodGhDTUFWTnZacnpZbU1teUFhZldVZGMvRWtRV2Qw?=
 =?utf-8?B?N2I4M0poWEJ2NGhjUWdsMFNlT0UvYW5zTGNPVzNSUW9YVWF5MzVHWUh4S25a?=
 =?utf-8?B?Q1J1QXpNdyttOVdBVHRVWExXdklHYVc0WktXajFtYkQvbGZLQU5TdjduVktU?=
 =?utf-8?B?Unlnb2FwbU1mYVpNWi9yTFZmRkhrZmYyZStPcDdHVitZRW1xV2ExUm43N3g4?=
 =?utf-8?B?Zk1mcTZUV1Q4SWhZTmhNb0c4ckZHT2xFL0FmQzdMdmJmUEFOeDh1ZUpzSnZS?=
 =?utf-8?B?QWhqZnd1SGdQcWNxU29lQ2V6dE8vU0dKa1ZsbCtiNmdnVTJsTWIxVGh2TlVk?=
 =?utf-8?B?cFVoL2xROFFMNzFyeks5WklCOHNNZGkwcDUxZ0NaQWNNeWEwcklYaGp1NkFt?=
 =?utf-8?B?YitqUnBqZWdHQytGWFc1ZUd2VUkxd3RkVlRCMzhPYzR1bHBFYjJQUkVGUG0x?=
 =?utf-8?Q?h3rIHOS8yNeTxezrT7/P3nk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A7E8A5C9FF2B646B6F433183A2847F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5dc0f7-7d28-4601-8d2a-08dadd4f8113
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 21:17:56.3574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JxDZdgEgEJXMz/PQ4CgVmv6Fxhf5v2f6pr/+G9eY+xPrUy0mJqUL5UpAgys/s+Bys5M4rGgf4tSUYyB/hnWielBOvzVt+Ufdq0NUFlYi3yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7811
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIyLTEyLTA5IGF0IDEwOjA2IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEFsaXNvbiBTY2hvZmllbGQgd3JvdGU6DQo+ID4gT24gVGh1LCBEZWMgMDgsIDIwMjIgYXQgMDE6
Mjk6MjZQTSAtMDgwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiA+IA0KPiA+IE1pc3NpbmcgU09C
IGFuZCBjb21taXQgbG9nDQo+IA0KPiBXaG9vcHMsIG1vdmVkIHRvbyBmYXN0IGFuZCBicm9rZSB0
aGluZ3MuDQo+IA0KPiBWaXNoYWwsIGZlZWwgZnJlZSB0byBhZGQ6DQoNCk5vIHByb2JsZW0sIGRv
bmUuIFBhdGNoIDcgd2FzIG1pc3NpbmcgdGhlc2UgdG9vLCBidXQgSSd2ZSBmaXhlZCB0aGF0IHVw
DQphcyB3ZWxsLiBUaGlzIHNlcmllcyBpcyBub3cgaW4gcHVzaGVkIHRvIHBlbmRpbmcuDQoNCj4g
DQo+IC0tLQ0KPiBUaGUgJ2NyZWF0ZS1yZWdpb24nIG1hbiBwYWdlIGhhZCBzb21lIHR5cG9zIHdo
ZW4gaXQgd2FzIGZpcnN0IGNyZWF0ZWQuDQo+IENsZWFuIHRoZW0gdXAgcGVyIHN5bnRheCBleHBl
Y3RhdGlvbnMuDQo+IA0KPiBGaXhlczogMjFiMDg5MDI1MTc4ICgiY3hsOiBhZGQgYSAnY3JlYXRl
LXJlZ2lvbicgY29tbWFuZCIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmou
d2lsbGlhbXNAaW50ZWwuY29tPg0KPiAtLS0NCj4gDQo+IC4uLm9yIGxldCBtZSBrbm93IGlmIHlv
dSB3YW50IGEgcmVzZW5kLg0KDQo=
