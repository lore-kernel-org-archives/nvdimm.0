Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127EE168
	for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 16:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642176253; x=1673712253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b01fEWo9Fd955MMmOv3Pm8CzK4Qn+4N6ynqzyfSMGuY=;
  b=hidgC5uUf7KI2rMnjXQuwFBFqWj1i56f2lCQSc6W2RLCtKfy8jVysJJ+
   yBuqHYazj7EJP8mt4yZu1hQKVeSIIM6hYRZl9pcFNbnZnvx058tlLpp9s
   sLUesi6EKEqzCZb/qluZIMdBy+97hcxZ76L+XKBdjuj4lSM88YD1X8L8h
   //hftX18cuNY1AoV2lhYiF6IMxeB1DJvaR4y0KK30Zc6LwVklvFVargg/
   2gvDhX2z19aKyxXY2gn/ppArGc20ft6QGwRWaI09dSGWqmxseTSSjON6L
   iZ2seCsaZr2QkrxPkagCqfiHQxGqLm4H/o5/BAhe1Tg2KIbFlrFxgA7jv
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268636090"
X-IronPort-AV: E=Sophos;i="5.88,289,1635231600"; 
   d="scan'208";a="268636090"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 08:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,289,1635231600"; 
   d="scan'208";a="577314943"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2022 08:04:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 08:04:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 08:04:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 14 Jan 2022 08:04:11 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 14 Jan 2022 08:04:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2huqfurxw82KLJMXXkym7TZQUAEC6OwCfISdbfZVt807QvNWsP/frM/q6hJZ2ywKBQPZzo4gjeHIwyZql0YRIxDhymW/27zuXrgcbX3fOxX+I8u0yIx37mJ5KvD7AnvN3wqZq4/clCSq2WjBWnry66rJ2r89mQHO68m0Gx1CbSnAbK49cCKaRS3+mqqbzRHQNKFCamZyuuLvQ2Lj4z4MfOK+TxIxWwjSSn0OaDJp/X5bwl7q02WSkkAnmfP275D2i9aHOvS8bgqy18wUPyDrgz82ErfsYzAxNGw+ITqJNIV89SzKTPdF/qY9ZX7qOns6kBnCSDNfjoWDF4yNAxHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b01fEWo9Fd955MMmOv3Pm8CzK4Qn+4N6ynqzyfSMGuY=;
 b=jsHxnttafx1icnHFeSNZ3xJark3nx/iT2oobZPQNYfcrv53K2W+djSEHLwIW9H8LOh/H3njPpf3R1mXx3oHSB91O7vSCzYBOEvZ13KlL0W/1R44nbeGpwij0PSlV49bwLCdxug1TvqCNoCPhczfW/HAOaZ3Yhb0a1OwCo9hkOpqpgMGrPcHq11xjmoMGmyS5nmQmPxb5IqMc9lHTfWm6iRlrufI1wrMCdN9iIADrY1gJcYBqlAsBwJJlWHFjP5N8CZ3lkr9NVMEUP5pxe89xfDowDFjitfQuSwZ4aSLgC0cYbw0cwsgObc3zPGxZIGJVL2ZXfO8xFzklezViZhQ9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by MWHPR1101MB2143.namprd11.prod.outlook.com (2603:10b6:301:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Fri, 14 Jan
 2022 16:04:09 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::e1a7:283b:4025:328]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::e1a7:283b:4025:328%6]) with mapi id 15.20.4888.011; Fri, 14 Jan 2022
 16:04:09 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "jmoyer@redhat.com" <jmoyer@redhat.com>, "msuchanek@suse.de"
	<msuchanek@suse.de>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "breno.leitao@gmail.com"
	<breno.leitao@gmail.com>, "vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>,
	"kilobyte@angband.pl" <kilobyte@angband.pl>
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
Thread-Topic: [ndctl PATCH v3 00/16] ndctl: Meson support
Thread-Index: AQHYAnulcNZJ9TW7fkuxyaLtBaP9V6xiu8EA
Date: Fri, 14 Jan 2022 16:04:09 +0000
Message-ID: <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31fbd463-3ed9-4f61-a575-08d9d7777fba
x-ms-traffictypediagnostic: MWHPR1101MB2143:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR1101MB2143FAE52B25E51DA751EF71C7549@MWHPR1101MB2143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IMaSnV2vTYMy2g6F6DFn99EXV0BroBmIybVPMpMWChe45VBBuS8HUZcp5Kl/80jdgg7cd9dcQHSWqh133Ddv2Zzf28W/hCDWw1ODkz2kzXa9ZKUtPpyfDUarqyweHgFHUAueH09EFsD4M/iV3fLmh545t5Ww9rjHG/7mr2GVRzN7LhGva5eTM1l8t1dLxf8hiVdtEcrcWYQ9v40sNcqOGuzk59rztjufo/6lpCAqrioiX72fi307vbLajlaD+XihX0CrDujXNF2r1VTKM00BUhwMu0/oMKH5uAixrWbI/6bymkNpvcfBUucVoz9i7almMe6LQ+0T6b8fK+hJcShBflc/kInh+XazJM9dy/09WnMtc/tmCe3HXcbIj61A9tEsnDHvzdEAlsh0VqA89QHBQkXPi1X+TN5Y/IdrUB7ed3D9927lGWeLQDzA4FxySet/l+o64jjUOGWpabBodmvhgB+Tco6IZsLZ6suZeabM1cBm1SzuZgyFGQrHXwnuRfcwlRwEXj5QU65NcU7/+cbEhq11k68ihaMvKpcpDcm7P3XZe1xQ2fwEGov/6IWaRBuIcUKlIOZK0SD73En8RDl0Wbp8nZJs+BNPIRzsEuO5zHsNuy4T5N3cWQx3ER51HRUWjxrm44tIK4HLEfxh3GnSPK4cpOrCFVYuPZCPElOx56R63GC4Z3rFMCVKRxxwg1zyePjwZc7CUh3X6sXvsVVVcUxXz0AQEKieCqZcQ959thrBzCS8P+W+RPS8nBDMBfiwq3rpCfYdAOsQjA+OWuzfOwboh9ETDaqR6NYZ4Zqd7kc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(8676002)(5660300002)(26005)(6512007)(64756008)(966005)(66476007)(2616005)(66556008)(82960400001)(76116006)(66946007)(6862004)(6636002)(8936002)(38100700002)(186003)(37006003)(122000001)(54906003)(4326008)(316002)(83380400001)(91956017)(6506007)(2906002)(508600001)(36756003)(71200400001)(86362001)(66446008)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzlWTG5kYzU5c2I1QzJJZVRjaHNTVjcyWWZCK1pmN3kzbTY3N2M0ZnRidlhs?=
 =?utf-8?B?eWgzeXIydFg3azNrejh2SU5nRDRrMFRBTVJjQk5pM0tMdDV1YjFMOCtKemdu?=
 =?utf-8?B?NkJzZ1loSExnMm1vMStmWWJmMGFsVEF6N2ovaW9PTG9SU0JaU3F6RGkxV3Mz?=
 =?utf-8?B?TmtPSGlwV2wzUHNjR3FIZnNHTE9wMXJiRWdaYmpOSUlyZmxpbEM3cWs1cXVT?=
 =?utf-8?B?NWR1Sld4NFZiVFpOT1RrZS83U0NTWDFpTko3bUI5MUI0R0ZKQmhkbk5ZMVlR?=
 =?utf-8?B?MytIL0xaTGU0a1RDeFhOWnQ3ajFLS2pFOGJpTHdkQmFLa3NGM1AyaGxHUlJq?=
 =?utf-8?B?ZjBtY29BWnozQkdOSlZoWk9WOVhtdHZIR1RZRGxQL29rYk54VVArMURqMHl6?=
 =?utf-8?B?OHUrMXRuSEN0dTU1RlhtQTQyRW41ZWZNT2ZEdjIxRVlvKytlS2NjcUZIcklS?=
 =?utf-8?B?MWtlM3NsbUN1VURFb1ZaWU5HZDNVNWt5M2pvOHVNRHZialVGc241WlIwMkhR?=
 =?utf-8?B?RFBxaVdhcUgyc1VKaXNXU1FXdlE3RG1vbTQvbi9ZSmZ6YndTK1I5d0V3UE01?=
 =?utf-8?B?am42azZ4b1VsTTc5NUFTZlgrSzZLSXlSc0dreitITmJPM3RKUDNnYU1qK3ov?=
 =?utf-8?B?TzE3OUIzQjI4UFByMTlOalpJRnNZam9PbXdzNXEyZnhmSEtnc1UrRmVCWHVr?=
 =?utf-8?B?MENiM3oweTFaZWhtVm5OQm1GTFc0U1hyamFnWURSNm9mblM3WlNRVjFqN1RD?=
 =?utf-8?B?TjNHSDlkNXZzQjBaUjlrdHJxZkx3TTVyaU9mVUloUVlXUlpQQ1NwRXI4bEVC?=
 =?utf-8?B?bTBXd1NacnRIQjEyNHBuWnFkSEFmbTFpL1JHZGhkcEZrVGdaYTRVTHhqOWdE?=
 =?utf-8?B?ZE5STEVRWk8rSWg0RzhzQnFFeDhhcU9vRncyRUVMSUlrOWpnbkxDQS91YVd4?=
 =?utf-8?B?bTlhQ293a1MvTmxUKzA3OTU2TDN2MmRMTURuaVNlL05OYW9SWWJKNE5nWm9R?=
 =?utf-8?B?azFYQytDL1dZVXcwRlU0a1h1cXloTDBaYUxrR3ZlMzZhckZtTEJjSm9rdE5k?=
 =?utf-8?B?cHpOUndYT0cwcTkxa3JoeFdjYjhTWE5lVjB1K0JheE82NUNOYVVvUFhPTkhT?=
 =?utf-8?B?SXBvLzFNaXI1N25kbWdQY0JZSWU5eXowZnZRRWdkenZSdStYb3pwVUVoNStv?=
 =?utf-8?B?VFJBLzdOY0tnS09CWW1CUVJValE0NU8rSGpwNjJnTVByaldVZG03N0dNTTlk?=
 =?utf-8?B?Ykx4QVRLYzZhcmRvRWJsektPYkZsdmVFa0syUW43eWZ3Sk01MDQ5Nk5NcHJs?=
 =?utf-8?B?c0ZMVnZ5SVFhR1Q1V0ovTDdNamx3QlgyMkhwbkFQRGV6ZzExQTJ3ZGc4Vk14?=
 =?utf-8?B?ME5RalpzZG9OUXpXaUFUdTY0TEd6ODdrQW9kK0VWQUlQM2YrWWZaQ3UxVDAv?=
 =?utf-8?B?b2hXQVovdTlIcUY5SjRWWURJS0JjN3luQkFtNS9EaWppMlpZMmhDWEZGRVRW?=
 =?utf-8?B?QzVQUkNXVTVaMHpyMmxLaEY5S3NLaHlZQ25LUFVzUDU3N05xWlNDZ2gxaXg3?=
 =?utf-8?B?RGJSYUd6YlZzcXNUOVo0ZU1QekViRm15VGFSNDJGY2FPNFZ3ajRBNm5pbVE4?=
 =?utf-8?B?RHVxaEJaOWM5MHppamNabFdHZzJsVHdvUmZrMGZDQW1adkI0OER4QUdNS2FD?=
 =?utf-8?B?UWpFbTBNMXB1VDNiRVhUdi9sdWUxL0h6OTdSK295S3NNTytnbkVmRTlwV1Jk?=
 =?utf-8?B?Vm5XNHFkSkRzQmorZzR1TU41Q2o0OWltZWl1ekpRd2dzRHd5Z0RnbTQvdzdW?=
 =?utf-8?B?SjlzWEJkd2RhbDdoQ05XeEVpLzluUTJRUlR1Umxmd3VkNGpOaHc3UEd5dUpz?=
 =?utf-8?B?azJnM2ExQytGWVdmUFlUTXhlRWtlVVkxSXEvK1pjQ3dZdVRPa2hENERzZGx2?=
 =?utf-8?B?UkZycFB6ZEVhc0dYNWhWMGtXNDJNbmtJenNHWXFBRE9ObzhvKzFCZ0JPTjhT?=
 =?utf-8?B?SUpMU3VRTHE2bklNL0l3ZzhBL0pIRnRJT0k3NTRGMndBSEdHY3YyZll1WGZx?=
 =?utf-8?B?bE83SnJjT0JwMkNCemlNcDQ0QWJRSHd6QnRuQnR2VXZUKy9YcnhGSmtXZUxY?=
 =?utf-8?B?a3ZWTDZiSytQRWMwc040TEZQRnpwL3A0OGU5RHppSHVlRkFXTWhSWU5HbDVB?=
 =?utf-8?B?N3RBQ3owNEE5OFNCeW5tek9FbERQSlJSUDhudjEzaHA3Tk1aa0RBY0pEcTJN?=
 =?utf-8?Q?UznRfERSMT2bMgFnl54tFlBdLlKMgzmKMrdZSiyokk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55FC975F52E9F34E997B05BA0B16DBDC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31fbd463-3ed9-4f61-a575-08d9d7777fba
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 16:04:09.2404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ji9l2SE7SIJEWMHB0NpocgwL3UzHVa5ZQ9BX7PjNCXgmcbRJK9iAfwOeArC0nvQ8rsl0JRHjVWPjVjtgG62z9yuqzW85yr1qUIjcj0BodU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2143
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTAxLTA1IGF0IDEzOjMxIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IENoYW5nZXMgc2luY2UgdjIgWzFdOg0KPiANCj4gLSBSZWJhc2Ugb24gdjcyDQo+ICAgLSBBZGQg
TWVzb24gc3VwcG9ydCBmb3IgdGhlIG5ldyBjb25maWcgZmlsZSBkaXJlY3RvcnkgZGVmaW5pdGlv
bnMuDQo+ICAgLSBBZGQgTWVzb24gc3VwcG9ydCBmb3IgbGFuZGluZyB0aGUgZGF4Y3RsIHVkZXYg
cnVsZQ0KPiAgICAgZGF4ZGV2LXJlY29uZmlndXJlIHNlcnZpY2UgaW4gdGhlIHJpZ2h0IGRpcmVj
dG9yaWVzDQo+IC0gSW5jbHVkZSB0aGUgZGVwcmVjYXRpb24gb2YgQkxLIEFwZXJ0dXJlIHRlc3Qg
aW5mcmFzdHJ1Y3R1cmUNCj4gLSBJbmNsdWRlIGEgbWlzY2VsbGFuZW91cyBkb2MgY2xhcmlmaWNh
dGlvbiBmb3IgJ25kY3RsIHVwZGF0ZS1maXJtd2FyZScNCj4gLSBGaXggdGhlIHRlc3RzIHN1cHBv
cnQgZm9yIG1vdmluZyB0aGUgYnVpbGQgZGlyZWN0b3J5IG91dC1vZi1saW5lDQo+IC0gSW5jbHVk
ZSBhIGZpeCBmb3IgdGhlIGRlcHJlY3RhdGlvbiBvZiB0aGUgZGF4X3BtZW1fY29tcGF0IG1vZHVs
ZQ0KPiAgIHBlbmRpbmcgaW4gdGhlIGxpYm52ZGltbS1mb3ItbmV4dCB0cmVlLg0KPiANCj4gWzFd
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzE2MzA2MTUzNzg2OS4xOTQzOTU3Ljg0OTE4Mjk4
ODEyMTUyNTU4MTUuc3RnaXRAZHdpbGxpYTItZGVzazMuYW1yLmNvcnAuaW50ZWwuY29tDQo+IA0K
PiAtLS0NCj4gDQo+IEFzIG1lbnRpb25lZCBpbiBwYXRjaCAxNCB0aGUgbW90aXZpYXRpb24gZm9y
IGNvbnZlcnRpbmcgdG8gTWVzb24gaXMNCj4gcHJpbWFyaWx5IGRyaXZlbiBieSBzcGVlZCAoYW4g
b3JkZXIgb2YgbWFnbml0dWRlIGluIHNvbWUgc2NlbmFyaW9zKSwgYnV0DQo+IE1lc29uIGFsc28g
aW5jbHVkZXMgYmV0dGVyIHRlc3QgYW5kIGRlYnVnLWJ1aWxkIHN1cHBvcnQuIFRoZSBidWlsZA0K
PiBsYW5ndWFnZSBpcyBlYXNpZXIgdG8gcmVhZCwgd3JpdGUsIGFuZCBkZWJ1Zy4gTWVzb24gaXMg
YWxsIGFyb3VuZCBiZXR0ZXINCj4gc3VpdGVkIHRvIHRoZSBuZXh0IHBoYXNlIG9mIHRoZSBuZGN0
bCBwcm9qZWN0IHRoYXQgd2lsbCBpbmNsdWRlIGFsbA0KPiB0aGluZ3MgImRldmljZSBtZW1vcnki
IHJlbGF0ZWQgKG5kY3RsLCBkYXhjdGwsIGFuZCBjeGwpLg0KPiANCj4gSW4gb3JkZXIgdG8gc2lt
cGxpZnkgdGhlIGNvbnZlcnNpb24gdGhlIG9sZCBCTEstYXBlcnR1cmUgdGVzdA0KPiBpbmZyYXN0
cnVjdHVyZSBpcyBqZXR0aXNvbmVkIGFuZCBpdCB3aWxsIGFsc28gYmUgcmVtb3ZlZCB1cHN0cmVh
bS4gU29tZQ0KPiBvdGhlciByZWZhY3RvcmluZ3MgYW5kIGZpeHVwcyBhcmUgaW5jbHVkZWQgYXMg
d2VsbCB0byBiZXR0ZXIgb3JnYW5pemUNCj4gdGhlIHV0aWx0eSBpbmZyYXN0cnVjdHVyZSBiZXR3
ZWVuIHRydWx5IGNvbW1vbiBhbmQgc3ViLXRvb2wgc3BlY2lmaWMuDQo+IA0KPiBWaXNoYWwsDQo+
IA0KPiBJbiBwcmVwYXJhdGlvbiBmb3IgbmRjdGwtdjczIHBsZWFzZSBjb25zaWRlciBwdWxsaW5n
IGluIHRoaXMgc2VyaWVzDQo+IGVhcmx5IG1haW5seSBmb3IgbXkgb3duIHNhbml0eSBvZiBub3Qg
bmVlZGluZyB0byBmb3J3YXJkIHBvcnQgbW9yZQ0KPiB1cGRhdGVzIHRvIHRoZSBhdXRvdG9vbHMg
aW5mcmFzdHJ1Y3R1cmUuDQo+IA0KSGkgRGFuLA0KDQpUaGVzZSBsb29rIGdyZWF0LCB0aGFua3Mg
YSBsb3QgZm9yIHRoaXMgd29yaywgaXQgaXMgYW4gYXdlc29tZSB3b3JrZmxvdw0KaW1wcm92ZW1l
bnQhICBJJ3ZlIG1lcmdlZCBpdCBpbnRvIHBlbmRpbmcsIGFuZCB3aWxsIGFsc28gbWVyZ2UgdG8N
Cm1hc3RlciBzaG9ydGx5IHRvIGVuY291cmFnZSBhbGwgbmV3IHN1Ym1pc3Npb25zIHRvIGJlIGJh
c2VkIG9uIHRoaXMuDQoNCkFsc28gQ0MnaW5nIGEgZmV3IGRpc3RybyBtYWludGFpbmVycyAtIHRo
aXMgd2lsbCBiZSBhIGNoYW5nZSB0bw0KcGFja2FnaW5nIHNwZWNzIGV0Yy4gdGhhdCBhcmUgbWFp
bnRhaW5lZCBvdXRzaWRlIG9mIHRoZSBuZGN0bCByZXBvLg0KVGhpcyBjaGFuZ2UgY2FuIGJlIGV4
cGVjdGVkIHRvIGxhbmQgaW4gdGhlIHY3MyByZWxlYXNlLCB3aGljaCBzaG91bGQgYmUNCmluIHRo
ZSBuZXh0IDItNCB3ZWVrcy4NCg0KVGhhbmtzLA0KVmlzaGFsDQo=
