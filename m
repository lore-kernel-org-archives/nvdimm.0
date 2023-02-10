Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDAA2588
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 10:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=SQs9Byp/59oWdOveoKngg+1MkdQYN2WO1s09bsQ4pj4=;
  b=lNeERq52IQDaxpjfi6TmbTrDAmU6KSiB0ErFW+GQdvyK82du7lnLaPfE
   VUn4tWjampbBvvoFlIpgWBy12oSHq3J5dRRFyoocK7nZh5XZXumSSVaeV
   qmM33MArGYAN1KoS9ixSImo616/vI5LlYgFf10lzOaDWY/0ZQJhDPboWQ
   s=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Brice.Goglin@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.97,286,1669071600"; 
   d="scan'208,217";a="92078655"
Received: from clt-128-93-177-128.vpn.inria.fr (HELO [128.93.177.128]) ([128.93.177.128])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:15:45 +0100
Message-ID: <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
Date: Fri, 10 Feb 2023 11:15:44 +0100
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
 "gregory.price@memverge.com" <gregory.price@memverge.com>,
 "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Weiny, Ira" <ira.weiny@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
In-Reply-To: <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------bDOTFTbB8yrF7SHtST4dU01k"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------bDOTFTbB8yrF7SHtST4dU01k
Content-Type: multipart/mixed; boundary="------------ORA98VzRfdZ30tVP0N5oeoI5";
 protected-headers="v1"
From: Brice Goglin <Brice.Goglin@inria.fr>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
 "gregory.price@memverge.com" <gregory.price@memverge.com>,
 "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Weiny, Ira" <ira.weiny@intel.com>
Message-ID: <34a03b27-923c-7bb0-d77a-b0fddc535160@inria.fr>
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
 <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
 <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>
In-Reply-To: <a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.com>

--------------ORA98VzRfdZ30tVP0N5oeoI5
Content-Type: multipart/alternative;
 boundary="------------hacrWOdbQpf5mhyQt5qftgPn"

--------------hacrWOdbQpf5mhyQt5qftgPn
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpMZSAwOS8wMi8yMDIzIMOgIDIwOjE3LCBWZXJtYSwgVmlzaGFsIEwgYSDDqWNyaXTCoDoN
Cj4gT24gVGh1LCAyMDIzLTAyLTA5IGF0IDEyOjA0ICswMTAwLCBCcmljZSBHb2dsaW4gd3Jv
dGU6DQo+PiBIZWxsbyBWaXNoYWwNCj4+DQo+PiBJIGFtIHRyeWluZyB0byBwbGF5IHdpdGgg
dGhpcyBidXQgYWxsIG15IGF0dGVtcHRzIGZhaWxlZCBzbyBmYXIuIENvdWxkDQo+PiB5b3Ug
cHJvdmlkZSBRZW11IGFuZCBjeGwtY2xpIGNvbW1hbmQtbGluZXMgdG8gZ2V0IGEgdm9sYXRp
bGUgcmVnaW9uDQo+PiBlbmFibGVkIGluIGEgUWVtdSBWTT8NCj4gSGkgQnJpY2UsDQo+DQo+
IEdyZWcgaGFkIHBvc3RlZCBoaXMgd29ya2luZyBjb25maWcgaW4gYW5vdGhlciB0aHJlYWQ6
DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWN4bC9ZOXNNczBGR3VsUVNJZTl0
QG1lbXZlcmdlLmNvbS8NCj4NCj4gSSd2ZSBhbHNvIHBhc3RlZCBiZWxvdywgdGhlIHFlbXUg
Y29tbWFuZCBsaW5lIGdlbmVyYXRlZCBieSB0aGUgcnVuX3FlbXUNCj4gc2NyaXB0IEkgcmVm
ZXJlbmNlZC4gKE5vdGUgdGhhdCB0aGlzIGFkZHMgYSBidW5jaCBvZiBzdHVmZiBub3Qgc3Ry
aWN0bHkNCj4gbmVlZGVkIGZvciBhIG1pbmltYWwgQ1hMIGNvbmZpZ3VyYXRpb24gLSB5b3Ug
Y2FuIGNlcnRhaW5seSB0cmltIGEgbG90DQo+IG9mIHRoYXQgb3V0IC0gdGhpcyBpcyBqdXN0
IHRoZSBkZWZhdWx0IHNldHVwIHRoYXQgaXMgZ2VuZXJhdGVkIGFuZCBJDQo+IHVzdWFsbHkg
cnVuKS4NCg0KDQpIZWxsbyBWaXNoYWwNCg0KVGhhbmtzIGEgbG90LCB0aGluZ3Mgd2VyZSBm
YWlsaW5nIGJlY2F1c2UgbXkga2VybmVsIGRpZG4ndCBoYXZlDQpDT05GSUdfQ1hMX1JFR0lP
Tl9JTlZBTElEQVRJT05fVEVTVD15LiBOb3cgSSBhbSBhYmxlIHRvIGNyZWF0ZSBhIHNpbmds
ZQ0KcmFtIHJlZ2lvbiwgZWl0aGVyIHdpdGggYSBzaW5nbGUgZGV2aWNlIG9yIG11bHRpcGxl
IGludGVybGVhdmVkIG9uZXMuDQoNCkhvd2V2ZXIgSSBjYW4ndCBnZXQgbXVsdGlwbGUgc2Vw
YXJhdGUgcmFtIHJlZ2lvbnMuIElmIEkgYm9vdCBhIGNvbmZpZw0KbGlrZSB5b3VycyBiZWxv
dywgSSBnZXQgNCByYW0gZGV2aWNlcy4gSG93IGNhbiBJIGNyZWF0ZSBvbmUgcmVnaW9uIGZv
cg0KZWFjaD8gT25jZSBJIGNyZWF0ZSB0aGUgZmlyc3Qgb25lLCBvdGhlcnMgZmFpbCBzYXlp
bmcgc29tZXRoaW5nIGxpa2UNCmJlbG93LiBJIHRyaWVkIHVzaW5nIG90aGVyIGRlY29kZXJz
IGJ1dCBpdCBkaWRuJ3QgaGVscCAoSSBzdGlsbCBuZWVkDQp0byByZWFkIG1vcmUgQ1hMIGRv
Y3MgYWJvdXQgZGVjb2RlcnMsIHdoeSBuZXcgb25lcyBhcHBlYXIgd2hlbiBjcmVhdGluZw0K
YSByZWdpb24sIGV0YykuDQoNCmN4bCByZWdpb246IGNvbGxlY3RfbWVtZGV2czogbm8gYWN0
aXZlIG1lbWRldnMgZm91bmQ6IGRlY29kZXI6IGRlY29kZXIwLjAgZmlsdGVyOiBtZW0zDQoN
CkJ5IHRoZSB3YXksIG9uY2UgY29uZmlndXJlZCBpbiBzeXN0ZW0gcmFtLCBteSBDWEwgcmFt
IGlzIG1lcmdlZCBpbnRvIGFuDQpleGlzdGluZyAibm9ybWFsIiBOVU1BIG5vZGUuIEhvdyBk
byBJIHRlbGwgUWVtdSB0aGF0IGEgQ1hMIHJlZ2lvbiBzaG91bGQNCmJlIHBhcnQgb2YgYSBu
ZXcgTlVNQSBub2RlPyBJIGFzc3VtZSB0aGF0J3Mgd2hhdCdzIGdvaW5nIHRvIGhhcHBlbiBv
bg0KcmVhbCBoYXJkd2FyZT8NCg0KVGhhbmtzDQoNCkJyaWNlDQoNCg0KDQo+DQo+DQo+ICQg
cnVuX3FlbXUuc2ggLWcgLS1jeGwgLS1jeGwtZGVidWcgLS1ydyAtciBub25lIC0tY21kbGlu
ZQ0KPiAvaG9tZS92dmVybWE3L2dpdC9xZW11L2J1aWxkL3FlbXUtc3lzdGVtLXg4Nl82NA0K
PiAtbWFjaGluZSBxMzUsYWNjZWw9a3ZtLG52ZGltbT1vbixjeGw9b24NCj4gLW0gODE5Mk0s
c2xvdHM9NCxtYXhtZW09NDA5NjRNDQo+IC1zbXAgOCxzb2NrZXRzPTIsY29yZXM9Mix0aHJl
YWRzPTINCj4gLWVuYWJsZS1rdm0NCj4gLWRpc3BsYXkgbm9uZQ0KPiAtbm9ncmFwaGljDQo+
IC1kcml2ZSBpZj1wZmxhc2gsZm9ybWF0PXJhdyx1bml0PTAsZmlsZT1PVk1GX0NPREUuZmQs
cmVhZG9ubHk9b24NCj4gLWRyaXZlIGlmPXBmbGFzaCxmb3JtYXQ9cmF3LHVuaXQ9MSxmaWxl
PU9WTUZfVkFSUy5mZA0KPiAtZGVidWdjb25maWxlOnVlZmlfZGVidWcubG9nICANCj4gLWds
b2JhbCBpc2EtZGVidWdjb24uaW9iYXNlPTB4NDAyDQo+IC1kcml2ZSBmaWxlPXJvb3QuaW1n
LGZvcm1hdD1yYXcsbWVkaWE9ZGlzaw0KPiAta2VybmVsIC4vbWtvc2kuZXh0cmEvbGliL21v
ZHVsZXMvNi4yLjAtcmM2Ky92bWxpbnV6DQo+IC1pbml0cmQgbWtvc2kuZXh0cmEvYm9vdC9p
bml0cmFtZnMtNi4yLjAtcmMyKy5pbWcNCj4gLWFwcGVuZCBzZWxpbnV4PTAgYXVkaXQ9MCBj
b25zb2xlPXR0eTAgY29uc29sZT10dHlTMCByb290PS9kZXYvc2RhMiBpZ25vcmVfbG9nbGV2
ZWwgcncgY3hsX2FjcGkuZHluZGJnPStmcGxtIGN4bF9wY2kuZHluZGJnPStmcGxtIGN4bF9j
b3JlLmR5bmRiZz0rZnBsbSBjeGxfbWVtLmR5bmRiZz0rZnBsbSBjeGxfcG1lbS5keW5kYmc9
K2ZwbG0gY3hsX3BvcnQuZHluZGJnPStmcGxtIGN4bF9yZWdpb24uZHluZGJnPStmcGxtIGN4
bF90ZXN0LmR5bmRiZz0rZnBsbSBjeGxfbW9jay5keW5kYmc9K2ZwbG0gY3hsX21vY2tfbWVt
LmR5bmRiZz0rZnBsbSBtZW1tYXA9MkchNEcgZWZpX2Zha2VfbWVtPTJHQDZHOjB4NDAwMDAN
Cj4gLWRldmljZSBlMTAwMCxuZXRkZXY9bmV0MCxtYWM9NTI6NTQ6MDA6MTI6MzQ6NTYNCj4g
LW5ldGRldiB1c2VyLGlkPW5ldDAsaG9zdGZ3ZD10Y3A6OjEwMDIyLToyMg0KPiAtb2JqZWN0
IG1lbW9yeS1iYWNrZW5kLWZpbGUsaWQ9Y3hsLW1lbTAsc2hhcmU9b24sbWVtLXBhdGg9Y3hs
dGVzdDAucmF3LHNpemU9MjU2TQ0KPiAtb2JqZWN0IG1lbW9yeS1iYWNrZW5kLWZpbGUsaWQ9
Y3hsLW1lbTEsc2hhcmU9b24sbWVtLXBhdGg9Y3hsdGVzdDEucmF3LHNpemU9MjU2TQ0KPiAt
b2JqZWN0IG1lbW9yeS1iYWNrZW5kLWZpbGUsaWQ9Y3hsLW1lbTIsc2hhcmU9b24sbWVtLXBh
dGg9Y3hsdGVzdDIucmF3LHNpemU9MjU2TQ0KPiAtb2JqZWN0IG1lbW9yeS1iYWNrZW5kLWZp
bGUsaWQ9Y3hsLW1lbTMsc2hhcmU9b24sbWVtLXBhdGg9Y3hsdGVzdDMucmF3LHNpemU9MjU2
TQ0KPiAtb2JqZWN0IG1lbW9yeS1iYWNrZW5kLXJhbSxpZD1jeGwtbWVtNCxzaGFyZT1vbixz
aXplPTI1Nk0NCj4gLW9iamVjdCBtZW1vcnktYmFja2VuZC1yYW0saWQ9Y3hsLW1lbTUsc2hh
cmU9b24sc2l6ZT0yNTZNDQo+IC1vYmplY3QgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPWN4bC1t
ZW02LHNoYXJlPW9uLHNpemU9MjU2TQ0KPiAtb2JqZWN0IG1lbW9yeS1iYWNrZW5kLXJhbSxp
ZD1jeGwtbWVtNyxzaGFyZT1vbixzaXplPTI1Nk0NCj4gLW9iamVjdCBtZW1vcnktYmFja2Vu
ZC1maWxlLGlkPWN4bC1sc2EwLHNoYXJlPW9uLG1lbS1wYXRoPWxzYTAucmF3LHNpemU9MUsN
Cj4gLW9iamVjdCBtZW1vcnktYmFja2VuZC1maWxlLGlkPWN4bC1sc2ExLHNoYXJlPW9uLG1l
bS1wYXRoPWxzYTEucmF3LHNpemU9MUsNCj4gLW9iamVjdCBtZW1vcnktYmFja2VuZC1maWxl
LGlkPWN4bC1sc2EyLHNoYXJlPW9uLG1lbS1wYXRoPWxzYTIucmF3LHNpemU9MUsNCj4gLW9i
amVjdCBtZW1vcnktYmFja2VuZC1maWxlLGlkPWN4bC1sc2EzLHNoYXJlPW9uLG1lbS1wYXRo
PWxzYTMucmF3LHNpemU9MUsNCj4gLWRldmljZSBweGItY3hsLGlkPWN4bC4wLGJ1cz1wY2ll
LjAsYnVzX25yPTUzDQo+IC1kZXZpY2UgcHhiLWN4bCxpZD1jeGwuMSxidXM9cGNpZS4wLGJ1
c19ucj0xOTENCj4gLWRldmljZSBjeGwtcnAsaWQ9aGIwcnAwLGJ1cz1jeGwuMCxjaGFzc2lz
PTAsc2xvdD0wLHBvcnQ9MA0KPiAtZGV2aWNlIGN4bC1ycCxpZD1oYjBycDEsYnVzPWN4bC4w
LGNoYXNzaXM9MCxzbG90PTEscG9ydD0xDQo+IC1kZXZpY2UgY3hsLXJwLGlkPWhiMHJwMixi
dXM9Y3hsLjAsY2hhc3Npcz0wLHNsb3Q9Mixwb3J0PTINCj4gLWRldmljZSBjeGwtcnAsaWQ9
aGIwcnAzLGJ1cz1jeGwuMCxjaGFzc2lzPTAsc2xvdD0zLHBvcnQ9Mw0KPiAtZGV2aWNlIGN4
bC1ycCxpZD1oYjFycDAsYnVzPWN4bC4xLGNoYXNzaXM9MCxzbG90PTQscG9ydD0wDQo+IC1k
ZXZpY2UgY3hsLXJwLGlkPWhiMXJwMSxidXM9Y3hsLjEsY2hhc3Npcz0wLHNsb3Q9NSxwb3J0
PTENCj4gLWRldmljZSBjeGwtcnAsaWQ9aGIxcnAyLGJ1cz1jeGwuMSxjaGFzc2lzPTAsc2xv
dD02LHBvcnQ9Mg0KPiAtZGV2aWNlIGN4bC1ycCxpZD1oYjFycDMsYnVzPWN4bC4xLGNoYXNz
aXM9MCxzbG90PTcscG9ydD0zDQo+IC1kZXZpY2UgY3hsLXR5cGUzLGJ1cz1oYjBycDAsbWVt
ZGV2PWN4bC1tZW0wLGlkPWN4bC1kZXYwLGxzYT1jeGwtbHNhMA0KPiAtZGV2aWNlIGN4bC10
eXBlMyxidXM9aGIwcnAxLG1lbWRldj1jeGwtbWVtMSxpZD1jeGwtZGV2MSxsc2E9Y3hsLWxz
YTENCj4gLWRldmljZSBjeGwtdHlwZTMsYnVzPWhiMXJwMCxtZW1kZXY9Y3hsLW1lbTIsaWQ9
Y3hsLWRldjIsbHNhPWN4bC1sc2EyDQo+IC1kZXZpY2UgY3hsLXR5cGUzLGJ1cz1oYjFycDEs
bWVtZGV2PWN4bC1tZW0zLGlkPWN4bC1kZXYzLGxzYT1jeGwtbHNhMw0KPiAtZGV2aWNlIGN4
bC10eXBlMyxidXM9aGIwcnAyLHZvbGF0aWxlLW1lbWRldj1jeGwtbWVtNCxpZD1jeGwtZGV2
NA0KPiAtZGV2aWNlIGN4bC10eXBlMyxidXM9aGIwcnAzLHZvbGF0aWxlLW1lbWRldj1jeGwt
bWVtNSxpZD1jeGwtZGV2NQ0KPiAtZGV2aWNlIGN4bC10eXBlMyxidXM9aGIxcnAyLHZvbGF0
aWxlLW1lbWRldj1jeGwtbWVtNixpZD1jeGwtZGV2Ng0KPiAtZGV2aWNlIGN4bC10eXBlMyxi
dXM9aGIxcnAzLHZvbGF0aWxlLW1lbWRldj1jeGwtbWVtNyxpZD1jeGwtZGV2Nw0KPiAtTSBj
eGwtZm13LjAudGFyZ2V0cy4wPWN4bC4wLGN4bC1mbXcuMC5zaXplPTRHLGN4bC1mbXcuMC5p
bnRlcmxlYXZlLWdyYW51bGFyaXR5PThrLGN4bC1mbXcuMS50YXJnZXRzLjA9Y3hsLjAsY3hs
LWZtdy4xLnRhcmdldHMuMT1jeGwuMSxjeGwtZm13LjEuc2l6ZT00RyxjeGwtZm13LjEuaW50
ZXJsZWF2ZS1ncmFudWxhcml0eT04aw0KPiAtb2JqZWN0IG1lbW9yeS1iYWNrZW5kLXJhbSxp
ZD1tZW0wLHNpemU9MjA0OE0NCj4gLW51bWEgbm9kZSxub2RlaWQ9MCxtZW1kZXY9bWVtMCwN
Cj4gLW51bWEgY3B1LG5vZGUtaWQ9MCxzb2NrZXQtaWQ9MA0KPiAtb2JqZWN0IG1lbW9yeS1i
YWNrZW5kLXJhbSxpZD1tZW0xLHNpemU9MjA0OE0NCj4gLW51bWEgbm9kZSxub2RlaWQ9MSxt
ZW1kZXY9bWVtMSwNCj4gLW51bWEgY3B1LG5vZGUtaWQ9MSxzb2NrZXQtaWQ9MQ0KPiAtb2Jq
ZWN0IG1lbW9yeS1iYWNrZW5kLXJhbSxpZD1tZW0yLHNpemU9MjA0OE0NCj4gLW51bWEgbm9k
ZSxub2RlaWQ9MixtZW1kZXY9bWVtMiwNCj4gLW9iamVjdCBtZW1vcnktYmFja2VuZC1yYW0s
aWQ9bWVtMyxzaXplPTIwNDhNDQo+IC1udW1hIG5vZGUsbm9kZWlkPTMsbWVtZGV2PW1lbTMs
DQo+IC1udW1hIG5vZGUsbm9kZWlkPTQsDQo+IC1vYmplY3QgbWVtb3J5LWJhY2tlbmQtZmls
ZSxpZD1udm1lbTAsc2hhcmU9b24sbWVtLXBhdGg9bnZkaW1tLTAsc2l6ZT0xNjM4NE0sYWxp
Z249MUcNCj4gLWRldmljZSBudmRpbW0sbWVtZGV2PW52bWVtMCxpZD1udjAsbGFiZWwtc2l6
ZT0yTSxub2RlPTQNCj4gLW51bWEgbm9kZSxub2RlaWQ9NSwNCj4gLW9iamVjdCBtZW1vcnkt
YmFja2VuZC1maWxlLGlkPW52bWVtMSxzaGFyZT1vbixtZW0tcGF0aD1udmRpbW0tMSxzaXpl
PTE2Mzg0TSxhbGlnbj0xRw0KPiAtZGV2aWNlIG52ZGltbSxtZW1kZXY9bnZtZW0xLGlkPW52
MSxsYWJlbC1zaXplPTJNLG5vZGU9NQ0KPiAtbnVtYSBkaXN0LHNyYz0wLGRzdD0wLHZhbD0x
MA0KPiAtbnVtYSBkaXN0LHNyYz0wLGRzdD0xLHZhbD0yMQ0KPiAtbnVtYSBkaXN0LHNyYz0w
LGRzdD0yLHZhbD0xMg0KPiAtbnVtYSBkaXN0LHNyYz0wLGRzdD0zLHZhbD0yMQ0KPiAtbnVt
YSBkaXN0LHNyYz0wLGRzdD00LHZhbD0xNw0KPiAtbnVtYSBkaXN0LHNyYz0wLGRzdD01LHZh
bD0yOA0KPiAtbnVtYSBkaXN0LHNyYz0xLGRzdD0xLHZhbD0xMA0KPiAtbnVtYSBkaXN0LHNy
Yz0xLGRzdD0yLHZhbD0yMQ0KPiAtbnVtYSBkaXN0LHNyYz0xLGRzdD0zLHZhbD0xMg0KPiAt
bnVtYSBkaXN0LHNyYz0xLGRzdD00LHZhbD0yOA0KPiAtbnVtYSBkaXN0LHNyYz0xLGRzdD01
LHZhbD0xNw0KPiAtbnVtYSBkaXN0LHNyYz0yLGRzdD0yLHZhbD0xMA0KPiAtbnVtYSBkaXN0
LHNyYz0yLGRzdD0zLHZhbD0yMQ0KPiAtbnVtYSBkaXN0LHNyYz0yLGRzdD00LHZhbD0yOA0K
PiAtbnVtYSBkaXN0LHNyYz0yLGRzdD01LHZhbD0yOA0KPiAtbnVtYSBkaXN0LHNyYz0zLGRz
dD0zLHZhbD0xMA0KPiAtbnVtYSBkaXN0LHNyYz0zLGRzdD00LHZhbD0yOA0KPiAtbnVtYSBk
aXN0LHNyYz0zLGRzdD01LHZhbD0yOA0KPiAtbnVtYSBkaXN0LHNyYz00LGRzdD00LHZhbD0x
MA0KPiAtbnVtYSBkaXN0LHNyYz00LGRzdD01LHZhbD0yOA0KPiAtbnVtYSBkaXN0LHNyYz01
LGRzdD01LHZhbD0xMA0KPg0K
--------------hacrWOdbQpf5mhyQt5qftgPn
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF=
-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class=3D"moz-cite-prefix">Le 09/02/2023 =C3=A0 20:17, Verma, Vis=
hal L
      a =C3=A9crit=C2=A0:<br>
    </div>
    <blockquote type=3D"cite"
      cite=3D"mid:a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.co=
m">
      <pre class=3D"moz-quote-pre" wrap=3D"">On Thu, 2023-02-09 at 12:04 =
+0100, Brice Goglin wrote:
</pre>
      <blockquote type=3D"cite">
        <pre class=3D"moz-quote-pre" wrap=3D"">
Hello Vishal

I am trying to play with this but all my attempts failed so far. Could=20
you provide Qemu and cxl-cli command-lines to get a volatile region=20
enabled in a Qemu VM?
</pre>
      </blockquote>
      <pre class=3D"moz-quote-pre" wrap=3D"">
Hi Brice,

Greg had posted his working config in another thread:
<a class=3D"moz-txt-link-freetext" href=3D"https://lore.kernel.org/linux-=
cxl/Y9sMs0FGulQSIe9t@memverge.com/">https://lore.kernel.org/linux-cxl/Y9s=
Ms0FGulQSIe9t@memverge.com/</a>

I've also pasted below, the qemu command line generated by the run_qemu
script I referenced. (Note that this adds a bunch of stuff not strictly
needed for a minimal CXL configuration - you can certainly trim a lot
of that out - this is just the default setup that is generated and I
usually run).</pre>
    </blockquote>
    <p><br>
    </p>
    <pre>Hello Vishal</pre>
    <pre>Thanks a lot, things were failing because my kernel didn't have
CONFIG_CXL_REGION_INVALIDATION_TEST=3Dy. Now I am able to create a single=

ram region, either with a single device or multiple interleaved ones.

However I can't get multiple separate ram regions. If I boot a config
like yours below, I get 4 ram devices. How can I create one region for
each? Once I create the first one, others fail saying something like
below. I tried using other decoders but it didn't help (I still need
to read more CXL docs about decoders, why new ones appear when creating
a region, etc).</pre>
    <pre>cxl region: collect_memdevs: no active memdevs found: decoder: d=
ecoder0.0 filter: mem3</pre>
    <pre>By the way, once configured in system ram, my CXL ram is merged =
into an
existing "normal" NUMA node. How do I tell Qemu that a CXL region should
be part of a new NUMA node? I assume that's what's going to happen on
real hardware?
</pre>
    <pre>Thanks</pre>
    <pre>Brice</pre>
    <pre>

</pre>
    <p><br>
    </p>
    <blockquote type=3D"cite"
      cite=3D"mid:a5e4aff9f300d9b603111983165754b35c89c612.camel@intel.co=
m">
      <pre class=3D"moz-quote-pre" wrap=3D"">


$ run_qemu.sh -g --cxl --cxl-debug --rw -r none --cmdline
/home/vverma7/git/qemu/build/qemu-system-x86_64=20
-machine q35,accel=3Dkvm,nvdimm=3Don,cxl=3Don=20
-m 8192M,slots=3D4,maxmem=3D40964M=20
-smp 8,sockets=3D2,cores=3D2,threads=3D2=20
-enable-kvm=20
-display none=20
-nographic=20
-drive if=3Dpflash,format=3Draw,unit=3D0,file=3DOVMF_CODE.fd,readonly=3Do=
n=20
-drive if=3Dpflash,format=3Draw,unit=3D1,file=3DOVMF_VARS.fd=20
-debugcon <a class=3D"moz-txt-link-freetext" href=3D"file:uefi_debug.log"=
>file:uefi_debug.log</a>=20
-global isa-debugcon.iobase=3D0x402=20
-drive file=3Droot.img,format=3Draw,media=3Ddisk=20
-kernel ./mkosi.extra/lib/modules/6.2.0-rc6+/vmlinuz=20
-initrd mkosi.extra/boot/initramfs-6.2.0-rc2+.img=20
-append selinux=3D0 audit=3D0 console=3Dtty0 console=3DttyS0 root=3D/dev/=
sda2 ignore_loglevel rw cxl_acpi.dyndbg=3D+fplm cxl_pci.dyndbg=3D+fplm cx=
l_core.dyndbg=3D+fplm cxl_mem.dyndbg=3D+fplm cxl_pmem.dyndbg=3D+fplm cxl_=
port.dyndbg=3D+fplm cxl_region.dyndbg=3D+fplm cxl_test.dyndbg=3D+fplm cxl=
_mock.dyndbg=3D+fplm cxl_mock_mem.dyndbg=3D+fplm memmap=3D2G!4G efi_fake_=
mem=3D2G@6G:0x40000=20
-device e1000,netdev=3Dnet0,mac=3D52:54:00:12:34:56=20
-netdev user,id=3Dnet0,hostfwd=3Dtcp::10022-:22=20
-object memory-backend-file,id=3Dcxl-mem0,share=3Don,mem-path=3Dcxltest0.=
raw,size=3D256M=20
-object memory-backend-file,id=3Dcxl-mem1,share=3Don,mem-path=3Dcxltest1.=
raw,size=3D256M=20
-object memory-backend-file,id=3Dcxl-mem2,share=3Don,mem-path=3Dcxltest2.=
raw,size=3D256M=20
-object memory-backend-file,id=3Dcxl-mem3,share=3Don,mem-path=3Dcxltest3.=
raw,size=3D256M=20
-object memory-backend-ram,id=3Dcxl-mem4,share=3Don,size=3D256M=20
-object memory-backend-ram,id=3Dcxl-mem5,share=3Don,size=3D256M=20
-object memory-backend-ram,id=3Dcxl-mem6,share=3Don,size=3D256M=20
-object memory-backend-ram,id=3Dcxl-mem7,share=3Don,size=3D256M=20
-object memory-backend-file,id=3Dcxl-lsa0,share=3Don,mem-path=3Dlsa0.raw,=
size=3D1K=20
-object memory-backend-file,id=3Dcxl-lsa1,share=3Don,mem-path=3Dlsa1.raw,=
size=3D1K=20
-object memory-backend-file,id=3Dcxl-lsa2,share=3Don,mem-path=3Dlsa2.raw,=
size=3D1K=20
-object memory-backend-file,id=3Dcxl-lsa3,share=3Don,mem-path=3Dlsa3.raw,=
size=3D1K=20
-device pxb-cxl,id=3Dcxl.0,bus=3Dpcie.0,bus_nr=3D53=20
-device pxb-cxl,id=3Dcxl.1,bus=3Dpcie.0,bus_nr=3D191=20
-device cxl-rp,id=3Dhb0rp0,bus=3Dcxl.0,chassis=3D0,slot=3D0,port=3D0=20
-device cxl-rp,id=3Dhb0rp1,bus=3Dcxl.0,chassis=3D0,slot=3D1,port=3D1=20
-device cxl-rp,id=3Dhb0rp2,bus=3Dcxl.0,chassis=3D0,slot=3D2,port=3D2=20
-device cxl-rp,id=3Dhb0rp3,bus=3Dcxl.0,chassis=3D0,slot=3D3,port=3D3=20
-device cxl-rp,id=3Dhb1rp0,bus=3Dcxl.1,chassis=3D0,slot=3D4,port=3D0=20
-device cxl-rp,id=3Dhb1rp1,bus=3Dcxl.1,chassis=3D0,slot=3D5,port=3D1=20
-device cxl-rp,id=3Dhb1rp2,bus=3Dcxl.1,chassis=3D0,slot=3D6,port=3D2=20
-device cxl-rp,id=3Dhb1rp3,bus=3Dcxl.1,chassis=3D0,slot=3D7,port=3D3=20
-device cxl-type3,bus=3Dhb0rp0,memdev=3Dcxl-mem0,id=3Dcxl-dev0,lsa=3Dcxl-=
lsa0=20
-device cxl-type3,bus=3Dhb0rp1,memdev=3Dcxl-mem1,id=3Dcxl-dev1,lsa=3Dcxl-=
lsa1=20
-device cxl-type3,bus=3Dhb1rp0,memdev=3Dcxl-mem2,id=3Dcxl-dev2,lsa=3Dcxl-=
lsa2=20
-device cxl-type3,bus=3Dhb1rp1,memdev=3Dcxl-mem3,id=3Dcxl-dev3,lsa=3Dcxl-=
lsa3=20
-device cxl-type3,bus=3Dhb0rp2,volatile-memdev=3Dcxl-mem4,id=3Dcxl-dev4=20
-device cxl-type3,bus=3Dhb0rp3,volatile-memdev=3Dcxl-mem5,id=3Dcxl-dev5=20
-device cxl-type3,bus=3Dhb1rp2,volatile-memdev=3Dcxl-mem6,id=3Dcxl-dev6=20
-device cxl-type3,bus=3Dhb1rp3,volatile-memdev=3Dcxl-mem7,id=3Dcxl-dev7=20
-M cxl-fmw.0.targets.0=3Dcxl.0,cxl-fmw.0.size=3D4G,cxl-fmw.0.interleave-g=
ranularity=3D8k,cxl-fmw.1.targets.0=3Dcxl.0,cxl-fmw.1.targets.1=3Dcxl.1,c=
xl-fmw.1.size=3D4G,cxl-fmw.1.interleave-granularity=3D8k=20
-object memory-backend-ram,id=3Dmem0,size=3D2048M=20
-numa node,nodeid=3D0,memdev=3Dmem0,=20
-numa cpu,node-id=3D0,socket-id=3D0=20
-object memory-backend-ram,id=3Dmem1,size=3D2048M=20
-numa node,nodeid=3D1,memdev=3Dmem1,=20
-numa cpu,node-id=3D1,socket-id=3D1=20
-object memory-backend-ram,id=3Dmem2,size=3D2048M=20
-numa node,nodeid=3D2,memdev=3Dmem2,=20
-object memory-backend-ram,id=3Dmem3,size=3D2048M=20
-numa node,nodeid=3D3,memdev=3Dmem3,=20
-numa node,nodeid=3D4,=20
-object memory-backend-file,id=3Dnvmem0,share=3Don,mem-path=3Dnvdimm-0,si=
ze=3D16384M,align=3D1G=20
-device nvdimm,memdev=3Dnvmem0,id=3Dnv0,label-size=3D2M,node=3D4=20
-numa node,nodeid=3D5,=20
-object memory-backend-file,id=3Dnvmem1,share=3Don,mem-path=3Dnvdimm-1,si=
ze=3D16384M,align=3D1G=20
-device nvdimm,memdev=3Dnvmem1,id=3Dnv1,label-size=3D2M,node=3D5=20
-numa dist,src=3D0,dst=3D0,val=3D10=20
-numa dist,src=3D0,dst=3D1,val=3D21=20
-numa dist,src=3D0,dst=3D2,val=3D12=20
-numa dist,src=3D0,dst=3D3,val=3D21=20
-numa dist,src=3D0,dst=3D4,val=3D17=20
-numa dist,src=3D0,dst=3D5,val=3D28=20
-numa dist,src=3D1,dst=3D1,val=3D10=20
-numa dist,src=3D1,dst=3D2,val=3D21=20
-numa dist,src=3D1,dst=3D3,val=3D12=20
-numa dist,src=3D1,dst=3D4,val=3D28=20
-numa dist,src=3D1,dst=3D5,val=3D17=20
-numa dist,src=3D2,dst=3D2,val=3D10=20
-numa dist,src=3D2,dst=3D3,val=3D21=20
-numa dist,src=3D2,dst=3D4,val=3D28=20
-numa dist,src=3D2,dst=3D5,val=3D28=20
-numa dist,src=3D3,dst=3D3,val=3D10=20
-numa dist,src=3D3,dst=3D4,val=3D28=20
-numa dist,src=3D3,dst=3D5,val=3D28=20
-numa dist,src=3D4,dst=3D4,val=3D10=20
-numa dist,src=3D4,dst=3D5,val=3D28=20
-numa dist,src=3D5,dst=3D5,val=3D10=20

</pre>
    </blockquote>
  </body>
</html>

--------------hacrWOdbQpf5mhyQt5qftgPn--

--------------ORA98VzRfdZ30tVP0N5oeoI5--

--------------bDOTFTbB8yrF7SHtST4dU01k
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEelpOgOQAl7r26tY4RJGQ8yNavTsFAmPmGVEFAwAAAAAACgkQRJGQ8yNavTvE
pA/+P91kc4QmKE1JplCW0SBzliqORT0Vc197NcEB2ICPg1O4IqBnR2YSxdMhk/fljLE/JGOEi1Q3
IjOcujhklqiUEV3M5tZ/rA+oKKcVYW7hAE8d+/y2GDRzxlBHNvHvAgWHqG135AW4CYIJ5F+U6h4k
YO40C1Z6KGRQ2zSmZUD1UMG/cUjyuJaV0jXifvdU4VDzDc5E54RpN0UC6X+wSqxBrc+BTT8IvDRG
STtE+keBNZyUY/basgUBN7bEVR3DNPMhb7m3oCo3I1mE8enT7IsGeiQ6E7It/IiOW9o1fE7pFczJ
9rvY/MDtdgOTARwM/l1g6ai7Z1Jg8h9/osH9VPaHT4VTg44VdZX6XivaS8AJm6yMy/pr0FDHab/6
b8z38cdPeMFx1Qeb55SkSXzzrg7UDD1H63wLlzjhfuQO97Iy3DijVCzBYXpDCJ3yMEnjXxsBz6HR
yJ2l2dh/jgSkm7PUqEWKGukQCQ1/sN7uvNbBrqj90xuri4jZ6qR7DdgrsgXuP0ZNaVcVDOU07Hj9
v+dUk+vTXeVUnbOXyU0XU9moQhtr3ghXGKcVl/PNCzuvV9hAiW7ILMpM0VbAXJE5Ov0mUdkHGLmz
D4OgBFiuhQqlJ/wn2duxx4r67mXG/sxd/t0Y7kBB+QZLJX9qvxOjQBIM1+mUmY5JFEWWXZ42UZoe
6UM=
=GL+2
-----END PGP SIGNATURE-----

--------------bDOTFTbB8yrF7SHtST4dU01k--
