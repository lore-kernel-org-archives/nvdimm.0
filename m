Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420A933C0
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=akfzNA3CnLMsKm3Mbb4o4t+XjAxRUDogeWIi5MNI9r4=;
  b=jSwolkQulW42eNP/dNcSnmnn9TXbEQutpO5fMU/xEzcmTQaWYmnN506f
   GlpKKMavuNikr0330D0t384HgcFQL9g1tWjQ/KKJM7evxG27mkQ26V1lM
   mDowx+mM7tMFmxjLamiR4GdNhdziEib3DpbhuEe/Q8XHoWO4+IbvFG3sc
   0=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Brice.Goglin@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.97,287,1669071600"; 
   d="scan'208";a="92189736"
Received: from 91-160-5-165.subs.proxad.net (HELO [192.168.44.23]) ([91.160.5.165])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 17:09:43 +0100
Message-ID: <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
Date: Fri, 10 Feb 2023 17:09:43 +0100
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
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "gregory.price@memverge.com" <gregory.price@memverge.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Weiny, Ira" <ira.weiny@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
 <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
 <20230210124307.00003be0@Huawei.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
In-Reply-To: <20230210124307.00003be0@Huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kWkJT86Ehy7cBn7iqSixX45f"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kWkJT86Ehy7cBn7iqSixX45f
Content-Type: multipart/mixed; boundary="------------r74KqkgT70Q8dFuEqS9lES3O";
 protected-headers="v1"
From: Brice Goglin <Brice.Goglin@inria.fr>
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "gregory.price@memverge.com" <gregory.price@memverge.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Weiny, Ira" <ira.weiny@intel.com>
Message-ID: <7e2605a8-cd49-4d6f-9f62-07ff6edd50d8@inria.fr>
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
 <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
 <20230210124307.00003be0@Huawei.com>
In-Reply-To: <20230210124307.00003be0@Huawei.com>

--------------r74KqkgT70Q8dFuEqS9lES3O
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

TGUgMTAvMDIvMjAyMyDDoCAxMzo0MywgSm9uYXRoYW4gQ2FtZXJvbiBhIMOpY3JpdMKgOg0K
Pg0KPj4gSGVsbG8gVmlzaGFsDQo+Pg0KPj4gVGhhbmtzIGEgbG90LCB0aGluZ3Mgd2VyZSBm
YWlsaW5nIGJlY2F1c2UgbXkga2VybmVsIGRpZG4ndCBoYXZlDQo+PiBDT05GSUdfQ1hMX1JF
R0lPTl9JTlZBTElEQVRJT05fVEVTVD15LiBOb3cgSSBhbSBhYmxlIHRvIGNyZWF0ZSBhIHNp
bmdsZQ0KPj4gcmFtIHJlZ2lvbiwgZWl0aGVyIHdpdGggYSBzaW5nbGUgZGV2aWNlIG9yIG11
bHRpcGxlIGludGVybGVhdmVkIG9uZXMuDQo+Pg0KPj4gSG93ZXZlciBJIGNhbid0IGdldCBt
dWx0aXBsZSBzZXBhcmF0ZSByYW0gcmVnaW9ucy4gSWYgSSBib290IGEgY29uZmlnDQo+PiBs
aWtlIHlvdXJzIGJlbG93LCBJIGdldCA0IHJhbSBkZXZpY2VzLiBIb3cgY2FuIEkgY3JlYXRl
IG9uZSByZWdpb24gZm9yDQo+PiBlYWNoPyBPbmNlIEkgY3JlYXRlIHRoZSBmaXJzdCBvbmUs
IG90aGVycyBmYWlsIHNheWluZyBzb21ldGhpbmcgbGlrZQ0KPj4gYmVsb3cuIEkgdHJpZWQg
dXNpbmcgb3RoZXIgZGVjb2RlcnMgYnV0IGl0IGRpZG4ndCBoZWxwIChJIHN0aWxsIG5lZWQN
Cj4+IHRvIHJlYWQgbW9yZSBDWEwgZG9jcyBhYm91dCBkZWNvZGVycywgd2h5IG5ldyBvbmVz
IGFwcGVhciB3aGVuIGNyZWF0aW5nDQo+PiBhIHJlZ2lvbiwgZXRjKS4NCj4+DQo+PiBjeGwg
cmVnaW9uOiBjb2xsZWN0X21lbWRldnM6IG5vIGFjdGl2ZSBtZW1kZXZzIGZvdW5kOiBkZWNv
ZGVyOiBkZWNvZGVyMC4wIGZpbHRlcjogbWVtMw0KPiBIaSBCcmljZSwNCj4NCj4gUUVNVSBl
bXVsYXRpb24gY3VycmVudGx5IG9ubHkgc3VwcG9ydHMgc2luZ2xlIEhETSBkZWNvZGVyIGF0
IGVhY2ggbGV2ZWwsDQo+IHNvIEhCLCBTd2l0Y2ggVVNQLCBFUCAod2l0aCBleGNlcHRpb24g
b2YgdGhlIENGTVdTIHRvcCBsZXZlbCBvbmVzIGFzIHNob3duDQo+IGluIHRoZSBleGFtcGxl
IHdoaWNoIGhhcyB0d28gb2YgdGhvc2UpLiBXZSBzaG91bGQgZml4IHRoYXQuLi4NCj4NCj4g
Rm9yIG5vdywgeW91IHNob3VsZCBiZSBhYmxlIHRvIGRvIGl0IHdpdGggbXVsdGlwbGUgcHhi
LWN4bCBpbnN0YW5jZXMgd2l0aA0KPiBhcHByb3ByaWF0ZSBDRk1XUyBlbnRyaWVzIGZvciBl
YWNoIG9uZS4gV2hpY2ggaXMgaG9ycmlibGUgYnV0IG1pZ2h0IHdvcmsNCj4gZm9yIHlvdSBp
biB0aGUgbWVhbnRpbWUuDQoNCg0KVGhhbmtzIEpvbmF0aGFuLCB0aGlzIHdvcmtzIGZpbmU6
DQoNCiAgIC1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPXZtZW0wLHNoYXJlPW9uLHNp
emU9MjU2TSBcDQogICAtZGV2aWNlIHB4Yi1jeGwsYnVzX25yPTEyLGJ1cz1wY2llLjAsaWQ9
Y3hsLjEgXA0KICAgLWRldmljZSBjeGwtcnAscG9ydD0wLGJ1cz1jeGwuMSxpZD1yb290X3Bv
cnQxMyxjaGFzc2lzPTAsc2xvdD0yIFwNCiAgIC1kZXZpY2UgY3hsLXR5cGUzLGJ1cz1yb290
X3BvcnQxMyx2b2xhdGlsZS1tZW1kZXY9dm1lbTAsaWQ9Y3hsLXZtZW0wIFwNCiAgIC1vYmpl
Y3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPXZtZW0xLHNoYXJlPW9uLHNpemU9MjU2TSBcDQog
ICAtZGV2aWNlIHB4Yi1jeGwsYnVzX25yPTE0LGJ1cz1wY2llLjAsaWQ9Y3hsLjIgXA0KICAg
LWRldmljZSBjeGwtcnAscG9ydD0wLGJ1cz1jeGwuMixpZD1yb290X3BvcnQxNCxjaGFzc2lz
PTEsc2xvdD0yIFwNCiAgIC1kZXZpY2UgY3hsLXR5cGUzLGJ1cz1yb290X3BvcnQxNCx2b2xh
dGlsZS1tZW1kZXY9dm1lbTEsaWQ9Y3hsLXZtZW0xIFwNCiAgIC1NIGN4bC1mbXcuMC50YXJn
ZXRzLjA9Y3hsLjEsY3hsLWZtdy4wLnNpemU9NEcsY3hsLWZtdy4xLnRhcmdldHMuMD1jeGwu
MixjeGwtZm13LjEuc2l6ZT00Rw0KDQoNCj4+IEJ5IHRoZSB3YXksIG9uY2UgY29uZmlndXJl
ZCBpbiBzeXN0ZW0gcmFtLCBteSBDWEwgcmFtIGlzIG1lcmdlZCBpbnRvIGFuDQo+PiBleGlz
dGluZyAibm9ybWFsIiBOVU1BIG5vZGUuIEhvdyBkbyBJIHRlbGwgUWVtdSB0aGF0IGEgQ1hM
IHJlZ2lvbiBzaG91bGQNCj4+IGJlIHBhcnQgb2YgYSBuZXcgTlVNQSBub2RlPyBJIGFzc3Vt
ZSB0aGF0J3Mgd2hhdCdzIGdvaW5nIHRvIGhhcHBlbiBvbg0KPj4gcmVhbCBoYXJkd2FyZT8N
Cj4gV2UgZG9uJ3QgeWV0IGhhdmUga2VybmVsIGNvZGUgdG8gZGVhbCB3aXRoIGFzc2lnbmlu
ZyBhIG5ldyBOVU1BIG5vZGUuDQo+IFdhcyBvbiB0aGUgdG9kbyBsaXN0IGluIGxhc3Qgc3lu
YyBjYWxsIEkgdGhpbmsuDQoNCg0KR29vZCB0byBrbm93biwgdGhhbmtzIGFnYWluLg0KDQpC
cmljZQ0KDQoNCg==

--------------r74KqkgT70Q8dFuEqS9lES3O--

--------------kWkJT86Ehy7cBn7iqSixX45f
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEelpOgOQAl7r26tY4RJGQ8yNavTsFAmPmbEcFAwAAAAAACgkQRJGQ8yNavTui
uhAAsWNMrh/plW5h6nZjw5ASQgPtxrktKKgEs4+/GN+yV1o4wEnZ03UwSXCoGlyYH/RSZquXFUVL
Hwhd74KOlHYIMi2kW1obpniB7bLnpR9/I3pdY+OQmN+4TlOBufRBc5EOJ/rp1sY2YNWqnNUdTwpB
o1oKMirP01Eu7y7C8d+HI7DMDkRg1Jkrv7vKutsQu96PxSKTRElBpmk13woclhJ9PKYJFsjLYlA6
hD0L6/taEXu56OF3xGhJYAjRtSElPNRksm//zoo1fcPPF+/UrStfrDrfXxHblkhWvIL3erFcaByX
Kq7PfjijzjJgP+a61d0nqcYk8KFc+KldGymxce0hdmIQtIYABgz92PIOtKAF+aGmxy3KufUchYu0
7h3/DakGz1MLvGf2GRRbqLHvmhJMcy6E2XzbM01qd0sVvGqNHZgw5O9CwzmoWxhNPa8d5qH1iQnG
kAH7dHtiyw6+T1fUarm2HXQrkp3/GfqBfQm03GNFkHphdWc7oHPTFGRD0mhP+qFyWDf0/872h8SS
wuDF1DAe2jSsRCvdV1RnZpp+Shnjs462YtntkpZfbbwPTSLmPb50aqFP76zntgEHY5wAUJt0R5Hg
GR2bvEXKzjAa4ViTp9PRQ/pWltvB5x8Fl2W87tAAjV3tj74yy9eouBmqkT4KoxYpuAMEo0F/7w40
tF4=
=Tzje
-----END PGP SIGNATURE-----

--------------kWkJT86Ehy7cBn7iqSixX45f--
