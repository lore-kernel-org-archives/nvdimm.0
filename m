Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8882F25
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652289451; x=1683825451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WHDdURNms3aWfdEJX5KkrqUkQcS2EWtnqEvYYDuGX0w=;
  b=afrKiHwVsBOcgAkrOMqFvsKPEbG3/5gqOK19u91+p5D9Az6tr2R1LgCa
   lh9r+Im/BcTBTsqj+uVuAWiXLQyL7f87VGIymvBGK+u0wSn32DKyDTs24
   mhnSPUSUd4ReOQYFXUHrTx9TKEKrV6KbOSjPH+YOacHWsio6vDkQdy8Rr
   gF8/uYWk0922vNUpXHbuL9bl2dLZiIx/vWYBGMHqB8ZrCjrykc/5ZiU/T
   r7ststOzTfj1oe96hg1x4jXYPXEsjW8aeV14anzeNzd7K4lN+ag0FPvt1
   G4keJ9deoMMCd99lTJ6n+WTjlgEc4+Ym5nvz8tjjl3h9X3I+BEhL/n6Cw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="268597193"
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="268597193"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 10:17:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="636495042"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 11 May 2022 10:17:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 10:17:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 10:17:21 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Wed, 11 May 2022 10:17:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@infradead.org>,
	"Hansen, Dave" <dave.hansen@intel.com>, Peter Zijlstra
	<peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david
	<david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel
	<linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux
 Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	<snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>,
	Vivek Goyal <vgoyal@redhat.com>, Jue Wang <juew@google.com>
Subject: RE: [PATCH v9 3/7] mce: fix set_mce_nospec to always unmap the whole
 page
Thread-Topic: [PATCH v9 3/7] mce: fix set_mce_nospec to always unmap the whole
 page
Thread-Index: AQHYVqBhtO9kfcaX30Okv6G3eRqhwq0Znj6AgABQagCAABkaEA==
Date: Wed, 11 May 2022 17:17:21 +0000
Message-ID: <5aa1c9aacc5a4086a904440641062669@intel.com>
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-4-jane.chu@oracle.com>
 <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
 <CAPcyv4id8AbTFpO7ED_DAPren=eJQHwcdY8Mjx18LhW+u4MdNQ@mail.gmail.com>
 <Ynt3WlpcJwuqffDX@zn.tnic>
In-Reply-To: <Ynt3WlpcJwuqffDX@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

PiBJIC0ganVzdCBsaWtlIHlvdSAtIGFtIHdhaXRpbmcgZm9yIFRvbnkgdG8gc2F5IHdoZXRoZXIg
aGUgc3RpbGwgbmVlZHMNCj4gdGhpcyB3aG9sZV9wYWdlKCkgdGhpbmcuIEkgYWxyZWFkeSBzdWdn
ZXN0ZWQgcmVtb3ZpbmcgaXQgc28gSSdtIGZpbmUNCj4gd2l0aCB0aGlzIHBhdGNoLg0KDQpJSVJD
IHRoaXMgbmV3IHBhdGNoIGVmZmVjdGl2ZWx5IHJldmVydHMgYmFjayB0byB0aGUgb3JpZ2luYWwg
YmVoYXZpb3IgdGhhdA0KSSBpbXBsZW1lbnRlZCBiYWNrIGF0IHRoZSBkYXduIG9mIHRpbWUuIEku
ZS4ganVzdCBhbHdheXMgbWFyayB0aGUgd2hvbGUNCnBhZ2UgIm5vdCBwcmVzZW50IiBhbmQgZG9u
J3QgdHJ5IHRvIG1lc3Mgd2l0aCBVQyBtYXBwaW5ncyB0byBhbGxvdw0KcGFydGlhbCAoYnV0IG5v
bi1zcGVjdWxhdGl2ZSkgYWNjZXNzIHRvIHRoZSBub3QtcG9pc29uZWQgcGFydHMgb2YgdGhlDQpw
YWdlLg0KDQpJZiB0aGF0IGlzIHRoZSBjYXNlIC4uLiB0aGVuIEFja2VkLWJ5OiBUb255IEx1Y2sg
PHRvbnkubHVja0BpbnRlbC5jb20+DQoNCklmIEkndmUgbWlzdW5kZXJzdG9vZCAuLi4gdGhlbiBw
bGVhc2UgZXhwbGFpbiB3aGF0IGl0IGlzIGRvaW5nLg0KDQpUaGFua3MNCg0KLVRvbnkNCg==
