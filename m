Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH 3/3] x86, ras: Add mcsafe_memcpy() function to recover
 from machine checks
Date: Tue, 8 Dec 2015 22:08:36 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F39F7D921@ORSMSX114.amr.corp.intel.com>
References: <cover.1447093568.git.tony.luck@intel.com>
	<02ef9e0e0b73591aa8ec37aae2409274d108af60.1447093569.git.tony.luck@intel.com>
	<20151112075313.GA5984@gmail.com>
	<20151112200106.GA32073@agluck-desk.sc.intel.com>
	<20151127101611.GA1087@gmail.com>
 <CAA9_cmcGbnzKLufKwT-LE_=82L2PTJ8bjfQCkPUhMxDA31ixmg@mail.gmail.com>
In-Reply-To: <CAA9_cmcGbnzKLufKwT-LE_=82L2PTJ8bjfQCkPUhMxDA31ixmg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Jens Axboe <axboe@fb.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>, Jeff Moyer <jmoyer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiBJcyB0aGF0IGFuICJBY2tlZC1ieSI/ICBJJ2QgbGlrZSB0byBwdWxsIHRoaXMgcGx1cyBWaXNo
YWwncw0KPiBnZW5kaXNrLWJhZGJsb2NrcyBwYXRjaGVzIGludG8gYSB1bmlmaWVkIGxpYm52ZGlt
bS1lcnJvci1oYW5kbGluZw0KPiBicmFuY2guICBXZSdyZSBsb29raW5nIHRvIGhhdmUgdjQuNSBh
YmxlIHRvIGF2b2lkIG9yIHN1cnZpdmUgbnZkaW1tDQo+IG1lZGlhIGVycm9ycyB0aHJvdWdoIHRo
ZSBwbWVtIGRyaXZlciBhbmQgREFYIHBhdGhzLg0KDQpJJ20gbWFraW5nIGEgVjIgdGhhdCBmaXhl
cyBzb21lIGJ1aWxkIGVycm9ycyBmb3IgMzItYml0IGFuZCBhZGRyZXNzZXMgb3RoZXIgY29tbWVu
dGFyeQ0KZnJvbSB0aGUgY29tbXVuaXR5LiBQZXJoYXBzIGEgY291cGxlIG1vcmUgZGF5cyBiZWZv
cmUgSSBmaW5pc2ggaXQgdXAgcmVhZHkgdG8gcG9zdC4NCg0KLVRvbnkNCg==
