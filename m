Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v2] nfit: add Hyper-V NVDIMM DSM command set to white list
Date: Sat, 2 Feb 2019 03:32:01 +0000
Message-ID: <PU1P153MB01692AB56F732623399A9EC5BF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01690EDA138D3ABDE5B4A482BF970@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4jD1oRWzA4ZiMYZm1uxsbOdgqzbb9raH70-HBDqapcE_g@mail.gmail.com>
 <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4haUouYs_Vfju2SMvjcwc7rqY06zqT8NJ-3uakGMZSu0w@mail.gmail.com>
 <PU1P153MB01694FCAF062E089059CD441BF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4gdWJ8qtiASU9ggz56Mkrm9OXfsO74RM9OOrXFmBw_A9Q@mail.gmail.com>
 <PU1P153MB0169D8F7C6E29C22FE122F3FBF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169D661955195EA070E7EF0BF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4iEcCG0h+HLPkfSC0aNDLq9hdoO00XErF93PHTmEgO-TQ@mail.gmail.com>
In-Reply-To: <CAPcyv4iEcCG0h+HLPkfSC0aNDLq9hdoO00XErF93PHTmEgO-TQ@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

PiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gU2VudDog
RnJpZGF5LCBGZWJydWFyeSAxLCAyMDE5IDU6MjkgUE0NCj4gLi4uIA0KPiBIb25lc3RseSwgdGhl
IHF1aWNrZXN0IHBhdGggdG8gc29tZXRoaW5nIGZ1bmN0aW9uYWwgZm9yIExpbnV4IGlzIHRvDQo+
IHNpbXBseSBkZWxldGUgdGhlIF9MU1Igc3VwcG9ydCBhbmQgdXNlIHJhdyBtb2RlIGRlZmluZWQg
bmFtZXNwYWNlcy4NCj4gV2h5IGhhdmUgbGFiZWxzIGlmIHRoZXkgYXJlIHJlYWQtb25seSBhbmQg
dGhlIHJlZ2lvbiBpcyBzdWZmaWNpZW50IGZvcg0KPiBkZWZpbmluZyBib3VuZGFyaWVzPw0KSHlw
ZXItViBWaXJ0dWFsIE5WRElNTSBjYW4gYWxyZWFkeSB3b3JrIHdpdGggVWJ1bnR1IDE5LjA0IHZp
cnR1YWwgbWFjaGluZQ0KcnVubmluZyBvbiBIeXBlci1WLCBpLmUuIEkgY2FuIGNyZWF0ZSBhIHJh
dyBvciBmc2RheCBuYW1lc2FwY2UsIGFuZCBjcmVhdGUgYQ0KeGZzIG9yIGV4dDQgZmlsZSBzeXNl
dG0gaW4gL2Rldi9wbWVtMHAxLCBhbmQgbW91bnQgdGhlIGZpbGUgc3lzdGVtIHdpdGggYW5kDQp3
aXRob3V0ICItbyBkYXgiLiBUaGUgYmFzaWMgZnVuY3Rpb25hbGl0eSBpcyBnb29kLg0KDQpNeSBy
ZWNlbnQgd29yayBpcyBtYWlubHkgZm9yIG5kY3RsIHN1cHBvcnQsIGkuZS4gZ2V0IHRoZSBoZWFs
dGggaW5mbyBieSBuZGN0bCwNCmFuZCB1c2UgbmRjdGwgdG8gbW9uaXRvciB0aGUgZXJyb3IgZXZl
bnRzIChpZiBhcHBsaWNhYmxlKS4NCg0KVGhhbmtzLA0KLS0gRGV4dWFuDQo=
