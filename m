Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138762FB2
	for <nvdimm@lists.linux.dev>; Fri, 25 Jun 2021 23:21:59 +0000 (UTC)
IronPort-SDR: u+CpW0Ta3G5ChjmQ2YN7N6DsETMY2LpFC/nxgQWG2kcjwYOUTkjO4+tCbUBJOLrf9QZYs3iLAJ
 AT7/kBptDhBg==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="293389382"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="293389382"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 16:21:58 -0700
IronPort-SDR: zRSkpY2pDsVE4WCiMQCTrxmQvSQMTeAXyxVun/W7wauFnKyD2B+EIiQljQeL9V0ETX4JYfr2PT
 OgfOPiCfnyiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="424588092"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 25 Jun 2021 16:21:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 16:21:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 25 Jun 2021 16:21:56 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.008;
 Fri, 25 Jun 2021 16:21:56 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, Jane Chu
	<jane.chu@oracle.com>
CC: Luis Chamberlain <mcgrof@suse.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: RE: set_memory_uc() does not work with pmem poison handling
Thread-Topic: set_memory_uc() does not work with pmem poison handling
Thread-Index: AQHXahf20f6jlyk6ckqRbFgJg4jBN6slXTKQ
Date: Fri, 25 Jun 2021 23:21:55 +0000
Message-ID: <ffc97a208ada4c7f8e3d3113dd323f78@intel.com>
References: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
 <YNErtAaG/i3HBII+@garbanzo> <81b46576-f30e-5b92-e926-0ffd20c7deac@oracle.com>
 <CAPcyv4hDJiAwAfvdfvnnReMik=ZVM5oNv2SH5Qo+YV3oY=VLBQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hDJiAwAfvdfvnnReMik=ZVM5oNv2SH5Qo+YV3oY=VLBQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

LSAgICAgICBlbHNlDQotICAgICAgICAgICAgICAgcmMgPSBzZXRfbWVtb3J5X3VjKGRlY295X2Fk
ZHIsIDEpOw0KKyAgICAgICBlbHNlIHsNCisgICAgICAgICAgICAgICAvKg0KKyAgICAgICAgICAg
ICAgICAqIEJ5cGFzcyBtZW10eXBlIGNoZWNrcyBzaW5jZSBtZW1vcnktZmFpbHVyZSBoYXMgc2hv
dA0KKyAgICAgICAgICAgICAgICAqIGRvd24gbWFwcGluZ3MuDQorICAgICAgICAgICAgICAgICov
DQorICAgICAgICAgICAgICAgcmMgPSBfc2V0X21lbW9yeV91YyhkZWNveV9hZGRyLCAxKTsNCisg
ICAgICAgfQ0KDQpEb2VzIHBtZW0gImZpeCIgcG9pc29uIGFkZHJlc3NlcyB5ZXQ/IElmIGl0IGRv
ZXMgKG9yIHdpbGwpIGRvZXMgaXQgbWF0dGVyIHRoYXQNCnlvdSBza2lwIHRoZSBtZW10eXBlX3Jl
c2VydmUoKSBjYWxsPw0KDQotVG9ueQ0K
