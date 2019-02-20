Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F31E7211CBD10
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 09:19:20 -0800 (PST)
Subject: Re: [PATCH 0/7] libnvdimm/pfn: Fix section-alignment padding
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4j9uEn9j=Y0Vo3oQJaXo-d-Xf=2-=0ucufhcXWeYOb0Yg@mail.gmail.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <b0e54fa8-d693-2f44-f25c-edf4816c0b33@suse.de>
Date: Wed, 20 Feb 2019 18:19:11 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j9uEn9j=Y0Vo3oQJaXo-d-Xf=2-=0ucufhcXWeYOb0Yg@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gMjAvMDIvMjAxOSAxODoxMSwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+IEhlbGxvIHZhbHVlZCBy
ZXZpZXdlcnMsIGNhbiBJIHBsZWFkIGZvciBhIHNhbml0eSBjaGVjayBvZiBhdCBsZWFzdAo+ICJs
aWJudmRpbW0vcGZuOiBJbnRyb2R1Y2Ugc3VwZXItYmxvY2sgbWluaW11bSB2ZXJzaW9uIHJlcXVp
cmVtZW50cyIKPiBhbmQgImxpYm52ZGltbS9wZm46IEZpeCAnc3RhcnRfcGFkJyBpbXBsZW1lbnRh
dGlvbiI/IEluIHBhcnRpY3VsYXIKPiBKZWZmIC8gSm9oYW5uZXMgdGhpcyBoYXMgZW5kIHVzZXIg
LyBkaXN0cm8gaW1wYWN0IGluIHRoYXQgdXNlcnMgbWF5Cj4gbG9zZSBhY2Nlc3MgdG8gbmFtZXNw
YWNlcyB0aGF0IGFyZSB1cGdyYWRlZCB0byB2MS4zIGluZm8tYmxvY2tzIGFuZAo+IHRoZW4gYm9v
dCBhbiBvbGQga2VybmVsLiBJIGRpZCBub3Qgc2VlIGEgd2F5IGFyb3VuZCB0aGF0IHNoYXJwIGVk
Z2UuCgpPaCBzb3JyeSBpdCB3YXMgb24gbXkgdG9kbyBsaXN0IGFuZCB0aGVuIEkgZm9yZ290IGFi
b3V0IGl0IGFnYWluLCBJJ2xsCmdpdmUgaXQgYSBzaG90IHRvbW9ycm93LgoKQnl0ZSwKCUpvaGFu
bmVzCi0tIApKb2hhbm5lcyBUaHVtc2hpcm4gICAgICAgICAgICAgICAgICAgICAgICAgICAgU1VT
RSBMYWJzIEZpbGVzeXN0ZW1zCmp0aHVtc2hpcm5Ac3VzZS5kZSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODkKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3Ry
LiA1LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFy
ZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKS2V5IGZpbmdlcnByaW50
ID0gRUMzOCA5Q0FCIEMyQzQgRjI1RCA4NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1MApfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
