Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF47846BB
	for <nvdimm@lists.linux.dev>; Sat, 11 Feb 2023 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=CG7hShGDdUKOotB6kBNTk6MGENa5ygi3ku28tBG1Ue4=;
  b=RVavklKITAv+Sv8SN3tgm+lVu1jm0uA/DMM3ffpV1NvfNxTcKRK/Oo8Y
   w1wSErB3Ee/vJUHaPMSwblWSL7z4hW+HAaeDxtp4sWKVKWOHreYbtFCo8
   z+2VCpH4nBP+L4LO+nP40+0tNWe2gfqsUComG+toF906uzMuqT8OSEgXN
   U=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Brice.Goglin@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.97,289,1669071600"; 
   d="scan'208";a="47483832"
Received: from 91-175-88-48.subs.proxad.net (HELO [192.168.0.166]) ([91.175.88.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2023 16:55:17 +0100
Message-ID: <b7a4b785-10c5-53d9-0f6b-eadd80b94d31@inria.fr>
Date: Sat, 11 Feb 2023 16:55:15 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "gregory.price@memverge.com" <gregory.price@memverge.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Weiny, Ira" <ira.weiny@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
 <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
 <20230210124307.00003be0@Huawei.com>
 <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
 <63e6f52057bc_36c729483@dwillia2-xfh.jf.intel.com.notmuch>
From: Brice Goglin <Brice.Goglin@inria.fr>
In-Reply-To: <63e6f52057bc_36c729483@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------hFlhgpj9BZvLcmfLWidtgd25"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------hFlhgpj9BZvLcmfLWidtgd25
Content-Type: multipart/mixed; boundary="------------pwXogcJ1WyoJCL5XHW9PaP0b";
 protected-headers="v1"
From: Brice Goglin <Brice.Goglin@inria.fr>
To: Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "gregory.price@memverge.com" <gregory.price@memverge.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Weiny, Ira" <ira.weiny@intel.com>
Message-ID: <b7a4b785-10c5-53d9-0f6b-eadd80b94d31@inria.fr>
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
 <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
 <20230210124307.00003be0@Huawei.com>
 <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
 <63e6f52057bc_36c729483@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <63e6f52057bc_36c729483@dwillia2-xfh.jf.intel.com.notmuch>

--------------pwXogcJ1WyoJCL5XHW9PaP0b
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

TGUgMTEvMDIvMjAyMyDDoCAwMjo1MywgRGFuIFdpbGxpYW1zIGEgw6ljcml0wqA6DQoNCj4g
QnJpY2UgR29nbGluIHdyb3RlOg0KPiBbLi5dDQo+Pj4+IEJ5IHRoZSB3YXksIG9uY2UgY29u
ZmlndXJlZCBpbiBzeXN0ZW0gcmFtLCBteSBDWEwgcmFtIGlzIG1lcmdlZCBpbnRvIGFuDQo+
Pj4+IGV4aXN0aW5nICJub3JtYWwiIE5VTUEgbm9kZS4gSG93IGRvIEkgdGVsbCBRZW11IHRo
YXQgYSBDWEwgcmVnaW9uIHNob3VsZA0KPj4+PiBiZSBwYXJ0IG9mIGEgbmV3IE5VTUEgbm9k
ZT8gSSBhc3N1bWUgdGhhdCdzIHdoYXQncyBnb2luZyB0byBoYXBwZW4gb24NCj4+Pj4gcmVh
bCBoYXJkd2FyZT8NCj4+PiBXZSBkb24ndCB5ZXQgaGF2ZSBrZXJuZWwgY29kZSB0byBkZWFs
IHdpdGggYXNzaWduaW5nIGEgbmV3IE5VTUEgbm9kZS4NCj4+PiBXYXMgb24gdGhlIHRvZG8g
bGlzdCBpbiBsYXN0IHN5bmMgY2FsbCBJIHRoaW5rLg0KPj4NCj4gSW4gZmFjdCwgdGhlcmUg
aXMgbm8gcGxhbiB0byBzdXBwb3J0ICJuZXciIE5VTUEgbm9kZSBjcmVhdGlvbi4gQSBub2Rl
DQo+IGNhbiBvbmx5IGJlIG9ubGluZWQgLyBwb3B1bGF0ZWQgZnJvbSBzZXQgb2Ygc3RhdGlj
IG5vZGVzIGRlZmluZWQgYnkNCj4gcGxhdGZvcm0tZmlybXdhcmUuIFRoZSBzZXQgb2Ygc3Rh
dGljIG5vZGVzIGlzIGRlZmluZWQgYnkgdGhlIHVuaW9uIG9mDQo+IGFsbCB0aGUgcHJveGlt
aXR5IGRvbWFpbiBudW1iZXJzIGluIHRoZSBTUkFUIGFzIHdlbGwgYXMgYSBub2RlIHBlcg0K
PiBDRk1XUyAvIFFURyBpZC4gU2VlOg0KPg0KPiAgICAgIGZkNDlmOTljMTgwOSBBQ1BJOiBO
VU1BOiBBZGQgYSBub2RlIGFuZCBtZW1ibGsgZm9yIGVhY2ggQ0ZNV1Mgbm90IGluIFNSQVQN
Cj4NCj4gLi4uZm9yIHRoZSBDWEwgbm9kZSBlbnVtZXJhdGlvbiBzY2hlbWUuDQo+DQo+IE9u
Y2UgeW91IGhhdmUgYSBub2RlIHBlciBDRk1XUyB0aGVuIGl0IGlzIHVwIHRvIENEQVQgYW5k
IHRoZSBRVEcgRFNNIHRvDQo+IGdyb3VwIGRldmljZXMgYnkgd2luZG93LiBUaGlzIHNjaGVt
ZSBhdHRlbXB0cyB0byBiZSBhcyBzaW1wbGUgYXMNCj4gcG9zc2libGUsIGJ1dCBubyBzaW1w
bGVyLiBJZiBtb3JlIGdyYW51bGFyaXR5IGlzIG5lY2Vzc2FyeSBpbiBwcmFjdGljZSwNCj4g
dGhhdCB3b3VsZCBiZSBhIGdvb2QgZGlzY3Vzc2lvbiB0byBoYXZlIHNvb25pc2guLiBMU0Yv
TU0gY29tZXMgdG8gbWluZC4NCg0KQWN0dWFsbHkgSSB3YXMgbWlzdGFrZW4sIHRoZXJlJ3Mg
YWxyZWFkeSBhIG5ldyBOVU1BIG5vZGUgd2hlbiBjcmVhdGluZw0KYSByZWdpb24gdW5kZXIg
UWVtdSwgYnV0IG15IHRvb2xzIGlnbm9yZWQgaXQgYmVjYXVzZSBpdCdzIGVtcHR5Lg0KQWZ0
ZXIgZGF4Y3RsIG9ubGluZS1tZW1vcnksIHRoaW5ncyBsb29rIGdvb2QuDQoNCkNhbiB5b3Ug
Y2xhcmlmeSB5b3VyIGFib3ZlIHNlbnRlbmNlcyBvbiBhIHJlYWwgbm9kZT8gSWYgSSBjb25u
ZWN0IHR3bw0KbWVtb3J5IGV4cGFuZGVycyBvbiB0d28gc2xvdHMgb2YgdGhlIHNhbWUgQ1BV
LCBkbyBJIGdldCBhIHNpbmdsZSBDRk1XUyBvciB0d28/DQpXaGF0IGlmIEkgY29ubmVjdCB0
d28gZGV2aWNlcyB0byBhIHNpbmdsZSBzbG90IGFjcm9zcyBhIENYTCBzd2l0Y2g/DQoNCkJy
aWNlDQoNCg==

--------------pwXogcJ1WyoJCL5XHW9PaP0b--

--------------hFlhgpj9BZvLcmfLWidtgd25
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEelpOgOQAl7r26tY4RJGQ8yNavTsFAmPnumMFAwAAAAAACgkQRJGQ8yNavTtf
0BAAl5lKWGV/GW3BXpeTY2tmKAxjYeL32srV3O1LdhHU3G6JQTvGGEz+M8NKih8jossH3kffE73c
3Le2lmEs4SdGQkpWCB55FMxxTMBsCOZ15R727I45wkbFRahTfmonk9BOpkAuZ2NkNe7hANdzaVEj
V2YJx+n0Zl1SkZYc/gIdPmbtdii8yr6fTO341MF2gWkTRXo6I9572SsxQthhlhNDUknHLMOkdMFx
Is6rWkmhcoITPD3AaruWxOFZtUFh4KD8qp2NPWS/M4LqMReKJnYTRmxAEvwHiXZXuwRYPr7jr1ay
dpZMcdnGpA3OfqBziy+zpBXHNIDeTvWchQPe8tj5yOZokBq6xpcgbCabpZr9j6hwK9e7sEC4NZsr
1J9lPlFD/KQyYTx+opGzR5Jiqjl7CcWKHlczxLwR+7ojbWWSKOOIJRmE7m/rrZvpxGYGloMGfmUA
QvE4XGSXL93uQnIut5jIPfhiDY+DR/AKgV7kfg/h2JVhm57B0+HknGEQIx6hOdqjPco9EhmBsXGu
rEkbJWGV203dlpuYH50NIwcgqFTH/MQJ1Emdb/gIJ3Ccmrq32t16QibhY/1th6eTV7fB3LAgGsLP
fkGl7AhRZspGUEJK1S7kSLSxTR+IyFo7TCLh8glWpmZ41TfOY3SgvPKfwm29d81kJQrqpTUohFWC
Gs8=
=UByZ
-----END PGP SIGNATURE-----

--------------hFlhgpj9BZvLcmfLWidtgd25--
