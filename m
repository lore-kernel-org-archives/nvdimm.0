Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078E372
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 17:28:33 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="310790052"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="310790052"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 10:28:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="477066906"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 Sep 2021 10:28:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 10:28:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 10:28:15 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Thu, 30 Sep 2021 10:28:15 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>,
	Luis Chamberlain <mcgrof@suse.com>
Subject: RE: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: AQHXqIoy8XPfkR1JMkW3cwGAzdEmA6ukSywAgAEVjQCAAjfSAIAA+nuAgAWrXACADySZgP//i9PQ
Date: Thu, 30 Sep 2021 17:28:12 +0000
Message-ID: <3b3266266835447aa668a244ae4e1baf@intel.com>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic>
In-Reply-To: <YVXxr3e3shdFqOox@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

PiBRdWVzdGlvbiBpcywgY2FuIHdlIGV2ZW4gYWNjZXNzIGEgaHdwb2lzb25lZCBwYWdlIHRvIHJl
dHJpZXZlIHRoYXQgZGF0YQ0KPiBvciBhcmUgd2UgY29tcGxldGVseSBpbiB0aGUgd3Jvbmcgd2Vl
ZHMgaGVyZT8gVG9ueT8NCg0KSGFyZHdhcmUgc2NvcGUgZm9yIHBvaXNvbiBpcyBhIGNhY2hlIGxp
bmUgKDY0IGJ5dGVzIGZvciBERFIsIG1heSBiZSBsYXJnZXINCmZvciB0aGUgaW50ZXJuYWxzIG9m
IDNELVhwb2ludCBtZW1vcnkpLg0KDQpTbyB5b3UgY2FuIGFjY2VzcyB0aGUgb3RoZXIgbGluZXMg
aW4gdGhlIHBhZ2UuIFlvdSBqdXN0IG5lZWQgdG8gYmUgY2FyZWZ1bA0Kbm90IHRvIGFjY2VzcyB0
aGUgcG9pc29uLiBTZXR0aW5nIHRoZSBjYWNoZSBtb2RlIGZvciB0aGUgcGFnZSB0byB1bmNhY2hl
YWJsZQ0KZW5zdXJlcyB0aGF0IGgvdyBwcmVmZXRjaGVycyBhbmQgc3BlY3VsYXRpdmUgYWNjZXNz
IGRvbid0IGFjY2lkZW50bHkgdG91Y2gNCnRoZSBwb2lzb24gd2hpbGUgYWNjZXNzaW5nIG5lYXJi
eSBjYWNoZSBsaW5lcy4NCg0KLVRvbnkNCg==
