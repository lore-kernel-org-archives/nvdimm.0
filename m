Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id D9F121A1E01
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 14:19:33 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: make completion smarter wrt mode/type/idle
 options
Date: Mon, 27 Jun 2016 21:18:57 +0000
Message-ID: <1467062314.7176.14.camel@intel.com>
References: <1467060218-20256-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4jpikCiOGyhoZZ70cWr9BAZibriGtNPJbQ1BeedXjJM2g@mail.gmail.com>
In-Reply-To: <CAPcyv4jpikCiOGyhoZZ70cWr9BAZibriGtNPJbQ1BeedXjJM2g@mail.gmail.com>
Content-Language: en-US
Content-ID: <CC4CEB8D3596614FACFFEC8743CAE9B5@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTA2LTI3IGF0IDE0OjEzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgSnVuIDI3LCAyMDE2IGF0IDE6NDMgUE0sIFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY28NCj4gbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIHRocmVlIG5ldyAnZmls
dGVycycgZm9yIG1vZGUsIHR5cGUsIGFuZCBpZGxlLg0KPiA+IA0KPiA+ICdtb2RlJyBhbmQgJ3R5
cGUnIHdvcmsgd2l0aCBlYWNoIG90aGVyIHRvIHByZXZlbnQgYSBibGsgbmFtZXNwYWNlDQo+ID4g
ZnJvbQ0KPiA+IHNob3dpbmcgbW9kZXMgbGlrZSAnZGF4JyBvciAnbWVtb3J5Jywgb3IgaWYgdGhv
c2UgbW9kZXMgYXJlDQo+ID4gc3BlY2lmaWVkLA0KPiA+IHRoZW4gbGltaXRpbmcgJ3R5cGUnIHRv
ICdwbWVtJy4NCj4gPiANCj4gPiBBbHNvIHNob3cgY29tcGxldGlvbnMgZm9yIC0tbWFwPSBvbmx5
IGlmIG1vZGUgaXMgJ21lbW9yeScuDQo+IC0tbWFwPSBpcyBhbHNvIHZhbGlkIHdoZW4gdGhlIG1v
ZGUgaXMgJ2RheCcuDQo+IA0KPiBUaGVyZSdzIGFsc28gYW4gYXNzdW1wdGlvbiBpbiB0aGUgLS1y
ZWNvbmZpZz0gY2FzZSBmb3INCj4gJ2NyZWF0ZS1uYW1lc3BhY2UnIHRoYXQgcGFyYW1ldGVycyBh
cmUgaW5oZXJpdGVkIGZyb20gdGhlIHRhcmdldA0KPiBuYW1lc3BhY2UuwqDCoEZvciBleGFtcGxl
LCBpdCBtaWdodCBiZSBzdXJwcmlzaW5nIHRoYXQgY29tcGxldGlvbnMgYXJlDQo+IG5vdCBwcm92
aWRlZCBmb3IgLS1tYXA9IHdoZW4gdGhlIG1vZGUgaXMgaW1wbGllZCBieSB0aGUgcHJvdmlkZWQN
Cj4gbmFtZXNwYWNlLg0KDQpHb29kIHBvaW50IC0gSSBndWVzcyB0aGVuIGl0IG1ha2VzIHNlbnNl
IHRvIGRyb3AgdGhlIGNoZWNraW5nIGVudGlyZWx5DQpmb3IgLS1tYXAuLiBJJ2xsIHNlbmQgYSB2
Mi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgt
bnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlz
dHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
