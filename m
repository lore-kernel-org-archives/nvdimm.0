Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3322FAE
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 20:15:53 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="225320488"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="225320488"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 13:15:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="457570718"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 30 Sep 2021 13:15:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 13:15:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 13:15:51 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Thu, 30 Sep 2021 13:15:51 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Linux NVDIMM
	<nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>, Luis Chamberlain
	<mcgrof@suse.com>
Subject: RE: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Topic: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Thread-Index: AQHXqIoy8XPfkR1JMkW3cwGAzdEmA6ukSywAgAEVjQCAAjfSAIAA+nuAgAWrXACADySZgP//i9PQgACYmwD//41FoIAAe3MA//+MOcA=
Date: Thu, 30 Sep 2021 20:15:51 +0000
Message-ID: <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
References: <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic> <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic> <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic>
In-Reply-To: <YVYXjoP0n1VTzCV7@zn.tnic>
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

PiBTbyBsZXQgbWUgY3V0IHRvIHRoZSBjaGFzZToNCj4NCj4gICAgICAgIGlmICghbWVtb3J5X2Zh
aWx1cmUoLi4pKQ0KPiAgICAgICAgICAgICAgICBzZXRfbWNlX25vc3BlYyhwZm4sIHdob2xlX3Bh
Z2UuLi4pOw0KPg0KPiB3aGVuIG1lbW9yeV9mYWlsdXJlKCkgcmV0dXJucyAwLCBpcyBhIHdob2xl
IHBhZ2UgbWFya2VkIGFzIGh3cG9pc29uIG9yDQo+IG5vdD8NCg0KRGVwZW5kcyBvbiB3aGF0IHRo
ZSB3aG9sZV9wYWdlKCkgaGVscGVyIHNhaWQuDQoNCnN0YXRpYyBib29sIHdob2xlX3BhZ2Uoc3Ry
dWN0IG1jZSAqbSkNCnsNCiAgICAgICAgaWYgKCFtY2FfY2ZnLnNlciB8fCAhKG0tPnN0YXR1cyAm
IE1DSV9TVEFUVVNfTUlTQ1YpKQ0KICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KDQogICAg
ICAgIHJldHVybiBNQ0lfTUlTQ19BRERSX0xTQihtLT5taXNjKSA+PSBQQUdFX1NISUZUOw0KfQ0K
DQo+IEJlY2F1c2UgSSBzZWUgdGhlcmUgY2xvc2UgdG8gdGhlIHRvcCBvZiB0aGUgZnVuY3Rpb246
DQo+DQo+CWlmIChUZXN0U2V0UGFnZUhXUG9pc29uKHApKSB7DQo+CQkuLi4NCj4NCj4gYWZ0ZXIg
dGhpcywgdGhhdCB3aG9sZSBwYWdlIGlzIGh3cG9pc29uIEknZCBzYXkuIE5vdCBhIGNhY2hlbGlu
ZSBidXQgdGhlDQo+IHdob2xlIHRoaW5nLg0KDQpUaGF0IG1heSBub3cgYmUgYSBjb25mdXNpbmcg
bmFtZSBmb3IgdGhlIHBhZ2UgZmxhZyBiaXQuIFVudGlsIHRoZQ0KcG1lbS9zdG9yYWdlIHVzZSBj
YXNlIHdlIGp1c3Qgc2ltcGx5IGxvc3QgdGhlIHdob2xlIHBhZ2UgKGJhY2sNCnRoZW4gc2V0X21j
ZV9ub3NwZWMoKSBkaWRuJ3QgdGFrZSBhbiBhcmd1bWVudCwgaXQganVzdCBtYXJrZWQgdGhlDQp3
aG9sZSBwYWdlIGFzICJub3QgcHJlc2VudCIgaW4gdGhlIGtlcm5lbCAxOjEgbWFwKS4NCg0KU28g
dGhlIG1lYW5pbmcgb2YgSFdQb2lzb24gaGFzIHN1YnRseSBjaGFuZ2VkIGZyb20gInRoaXMgd2hv
bGUNCnBhZ2UgaXMgcG9pc29uZWQiIHRvICJ0aGVyZSBpcyBzb21lIHBvaXNvbiBpbiBzb21lL2Fs
bFsxXSBvZiB0aGlzIHBhZ2UiDQoNCi1Ub255DQoNClsxXSBldmVuIGluIHRoZSAiYWxsIiBjYXNl
IHRoZSBwb2lzb24gaXMgbGlrZWx5IGp1c3QgaW4gb25lIGNhY2hlIGxpbmUsIGJ1dA0KdGhlIE1D
SV9NSVNDX0FERFJfTFNCIGluZGljYXRpb24gaW4gdGhlIG1hY2hpbmUgY2hlY2sgYmFuayBzYWlk
DQp0aGUgc2NvcGUgd2FzIHRoZSB3aG9sZSBwYWdlLiBUaGlzIGhhcHBlbmVkIG9uIHNvbWUgb2xk
ZXIgc3lzdGVtcw0KZm9yIHBhZ2Ugc2NydWIgZXJyb3JzIHdoZXJlIHRoZSBtZW1vcnkgY29udHJv
bGxlciB3YXNuJ3Qgc21hcnQgZW5vdWdoDQp0byB0cmFuc2xhdGUgdGhlIGNoYW5uZWwgYWRkcmVz
cyBiYWNrIHRvIGEgY2FjaGUgZ3JhbnVsYXIgc3lzdGVtIGFkZHJlc3MuDQo=
