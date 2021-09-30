Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43F92FAE
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 19:44:51 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="212349562"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="212349562"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 12:44:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="555914542"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Sep 2021 12:44:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 12:44:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 12:44:48 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Thu, 30 Sep 2021 12:44:48 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Linux NVDIMM
	<nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>, Luis Chamberlain
	<mcgrof@suse.com>
Subject: RE: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: AQHXqIoy8XPfkR1JMkW3cwGAzdEmA6ukSywAgAEVjQCAAjfSAIAA+nuAgAWrXACADySZgP//i9PQgACYmwD//41FoA==
Date: Thu, 30 Sep 2021 19:44:48 +0000
Message-ID: <33502a16719f42aa9664c569de4533df@intel.com>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic> <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic>
In-Reply-To: <YVYQPtQrlKFCXPyd@zn.tnic>
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

PkkgZG9uJ3QgbWVhbiBmcm9tIHRoZSBodyBhc3BlY3QgYnV0IGZyb20gdGhlIE9TIG9uZTogbXkg
c2ltcGxlIHRoaW5raW5nDQo+IGlzLCAqaWYqIGEgcGFnZSBpcyBtYXJrZWQgYXMgSFcgcG9pc29u
LCBhbnkgZnVydGhlciBtYXBwaW5nIG9yIGFjY2Vzc2luZw0KPiBvZiB0aGUgcGFnZSBmcmFtZSBp
cyBwcmV2ZW50ZWQgYnkgdGhlIG1tIGNvZGUuDQo+DQo+IFNvIHlvdSBjYW4ndCBhY2Nlc3MgKmFu
eSogYml0cyB0aGVyZSBzbyB3aHkgZG8gd2UgZXZlbiBib3RoZXIgd2l0aCB3aG9sZQ0KPiBvciBu
b3Qgd2hvbGUgcGFnZT8gUGFnZSBpcyBnb25lLi4uDQoNClNlZSB0aGUgY29tbWVudCBhYm92ZSBz
ZXRfbWNlX25vc3BlYygpIC4uLg0KDQovKg0KICogUHJldmVudCBzcGVjdWxhdGl2ZSBhY2Nlc3Mg
dG8gdGhlIHBhZ2UgYnkgZWl0aGVyIHVubWFwcGluZw0KICogaXQgKGlmIHdlIGRvIG5vdCByZXF1
aXJlIGFjY2VzcyB0byBhbnkgcGFydCBvZiB0aGUgcGFnZSkgb3INCiAqIG1hcmtpbmcgaXQgdW5j
YWNoZWFibGUgKGlmIHdlIHdhbnQgdG8gdHJ5IHRvIHJldHJpZXZlIGRhdGENCiAqIGZyb20gbm9u
LXBvaXNvbmVkIGxpbmVzIGluIHRoZSBwYWdlKS4NCiAqLw0Kc3RhdGljIGlubGluZSBpbnQgc2V0
X21jZV9ub3NwZWModW5zaWduZWQgbG9uZyBwZm4sIGJvb2wgdW5tYXApDQoNCg0KSXQncyBhIGNo
b2ljZSBhcyB0byB3aGV0aGVyIHRoZSB3aG9sZSBwYWdlIGlzIGdvbmUgb3Igbm90LiBUaGUgaGlz
dG9yeSBmb3INCnRoaXMgaXMgdXNpbmcgcG1lbSBhcyBzdG9yYWdlLiBUaGUgZmlsZXN5c3RlbSBi
bG9jayBzaXplIG1heSBiZSBsZXNzIHRoYW4NCnRoZSBwYWdlIHNpemUuIEFuIGVycm9yIGluIGEg
ImJsb2NrIiBzaG91bGQgb25seSByZXN1bHQgaW4gdGhhdCBibG9jayBkaXNhcHBlYXJpbmcNCmZy
b20gdGhlIGZpbGUsIG5vdCB0aGUgc3Vycm91bmRpbmcgNGsuDQoNCk9mIGNvdXJzZSB0aGF0IG9u
bHkgd29ya3MgZm9yIHVzZXJzIG9mIHJlYWQoMikvd3JpdGUoMikgdG8gYWNjZXNzIHRoZSBmaWxl
Lg0KVGhleSBjYW4ndCBtbWFwKDIpIGFuZCBqdXN0IGdldCB0aGUgZ29vZCBiaXRzLg0KDQotVG9u
eQ0K
