Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 770A78032B
 for <linux-nvdimm@lists.01.org>; Wed,  8 Mar 2017 00:00:12 -0800 (PST)
Subject: Re: [PATCH v2 4/5] acpi_nfit, libnvdimm: Add support for clear poison
 list and bad blocks
References: <148892068983.46486.5008198419806159468.stgit@djiang5-desk3.ch.intel.com>
 <148892081379.46486.4526071392091548993.stgit@djiang5-desk3.ch.intel.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <4083463a-d82b-6875-8774-ac433c117211@suse.de>
Date: Wed, 8 Mar 2017 09:00:08 +0100
MIME-Version: 1.0
In-Reply-To: <148892081379.46486.4526071392091548993.stgit@djiang5-desk3.ch.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gMDMvMDcvMjAxNyAxMDowNiBQTSwgRGF2ZSBKaWFuZyB3cm90ZToKPiBQcm92aWRpbmcgbWVj
aGFuaXNtIHRvIGNsZWFyIHBvaXNvbiBsaXN0IHZpYSB0aGUgbmRjdGwgTkRfQ01EX0NMRUFSX0VS
Uk9SCj4gY2FsbC4gV2Ugd2lsbCB1cGRhdGUgdGhlIHBvaXNvbiBsaXN0IGFuZCBhbHNvIHRoZSBi
YWRibG9ja3MgYXQgcmVnaW9uIGxldmVsCj4gaWYgdGhlIHJlZ2lvbiBpcyBpbiBkYXggbW9kZSBv
ciBpbiBwbWVtIG1vZGUgYW5kIG5vdCBhY3RpdmUuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBK
aWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+Cj4gLS0tCgpUaGFua3MsClJldmlld2VkLWJ5OiBK
b2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5Ac3VzZS5kZT4KCgotLSAKSm9oYW5uZXMgVGh1
bXNoaXJuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU3RvcmFnZQpq
dGh1bXNoaXJuQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEg
NzQwNTMgNjg5ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJn
CkdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJC
IDIxMjg0IChBRyBOw7xybmJlcmcpCktleSBmaW5nZXJwcmludCA9IEVDMzggOUNBQiBDMkM0IEYy
NUQgODYwMCBEMEQwIDAzOTMgOTY5RCAyRDc2IDA4NTAKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
