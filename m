Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 446CC222F4E03
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 14:48:54 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id d5so26314382oti.3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 14:53:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com>
 <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Dec 2017 14:53:42 -0800
Message-ID: <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
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
To: Brice Goglin <brice.goglin@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Matthew Wilcox <willy@infradead.org>, Linux ACPI" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBEZWMgMjEsIDIwMTcgYXQgMTI6MzEgUE0sIEJyaWNlIEdvZ2xpbiA8YnJpY2UuZ29n
bGluQGdtYWlsLmNvbT4gd3JvdGU6Cj4gTGUgMjAvMTIvMjAxNyDDoCAyMzo0MSwgUm9zcyBad2lz
bGVyIGEgw6ljcml0IDoKWy4uXQo+IEhlbGxvCj4KPiBJIGNhbiBjb25maXJtIHRoYXQgSFBDIHJ1
bnRpbWVzIGFyZSBnb2luZyB0byB1c2UgdGhlc2UgcGF0Y2hlcyAoYXQgbGVhc3QKPiBhbGwgcnVu
dGltZXMgdGhhdCB1c2UgaHdsb2MgZm9yIHRvcG9sb2d5IGRpc2NvdmVyeSwgYnV0IHRoYXQncyB0
aGUgdmFzdAo+IG1ham9yaXR5IG9mIEhQQyBhbnl3YXkpLgo+Cj4gV2UgcmVhbGx5IGRpZG4ndCBs
aWtlIEtOTCBleHBvc2luZyBhIGhhY2t5IFNMSVQgdGFibGUgWzFdLiBXZSBoYWQgdG8KPiBleHBs
aWNpdGx5IGRldGVjdCB0aGF0IHNwZWNpZmljIGNyYXp5IHRhYmxlIHRvIGZpbmQgb3V0IHdoaWNo
IE5VTUEgbm9kZXMKPiB3ZXJlIGxvY2FsIHRvIHdoaWNoIGNvcmVzLCBhbmQgdG8gZmluZCBvdXQg
d2hpY2ggTlVNQSBub2RlcyB3ZXJlCj4gSEJNL01DRFJBTSBvciBERFIuIEFuZCB0aGVuIHdlIGhh
ZCB0byBoaWRlIHRoZSBTTElUIHZhbHVlcyB0byB0aGUKPiBhcHBsaWNhdGlvbiBiZWNhdXNlIHRo
ZSByZXBvcnRlZCBsYXRlbmNpZXMgZGlkbid0IG1hdGNoIHJlYWxpdHkuIFF1aXRlCj4gYW5ub3lp
bmcuCj4KPiBXaXRoIFJvc3MnIHBhdGNoZXMsIHdlIGNhbiBlYXNpbHkgZ2V0IHdoYXQgd2UgbmVl
ZDoKPiAqIHdoaWNoIE5VTUEgbm9kZXMgYXJlIGxvY2FsIHRvIHdoaWNoIENQVXM/IC9zeXMvZGV2
aWNlcy9zeXN0ZW0vbm9kZS8KPiBjYW4gb25seSByZXBvcnQgYSBzaW5nbGUgbG9jYWwgbm9kZSBw
ZXIgQ1BVIChkb2Vzbid0IHdvcmsgZm9yIEtOTCBhbmQKPiB1cGNvbWluZyBhcmNoaXRlY3R1cmVz
IHdpdGggSEJNK0REUisuLi4pCj4gKiB3aGljaCBOVU1BIG5vZGVzIGFyZSBzbG93L2Zhc3QgKGZv
ciBib3RoIGJhbmR3aWR0aCBhbmQgbGF0ZW5jeSkKPiBBbmQgd2UgY2FuIHN0aWxsIGxvb2sgYXQg
U0xJVCB1bmRlciAvc3lzL2RldmljZXMvc3lzdGVtL25vZGUgaWYgcmVhbGx5Cj4gbmVlZGVkLgo+
Cj4gQW5kIG9mIGNvdXJzZSBoYXZpbmcgdGhpcyBpbiBzeXNmcyBpcyBtdWNoIGJldHRlciB0aGFu
IHBhcnNpbmcgQUNQSQo+IHRhYmxlcyB0aGF0IGFyZSBvbmx5IGFjY2Vzc2libGUgdG8gcm9vdCA6
KQoKT24gdGhpcyBwb2ludCwgaXQncyBub3QgY2xlYXIgdG8gbWUgdGhhdCB3ZSBzaG91bGQgYWxs
b3cgdGhlc2Ugc3lzZnMKZW50cmllcyB0byBiZSB3b3JsZCByZWFkYWJsZS4gR2l2ZW4gL3Byb2Mv
aW9tZW0gbm93IGhpZGVzIHBoeXNpY2FsCmFkZHJlc3MgaW5mb3JtYXRpb24gZnJvbSBub24tcm9v
dCB3ZSBhdCBsZWFzdCBuZWVkIHRvIGJlIGNhcmVmdWwgbm90CnRvIHVuZG8gdGhhdCB3aXRoIG5l
dyBzeXNmcyBITUFUIGF0dHJpYnV0ZXMuIE9uY2UgeW91IG5lZWQgdG8gYmUgcm9vdApmb3IgdGhp
cyBpbmZvLCBpcyBwYXJzaW5nIGJpbmFyeSBITUFUIHZzIHN5c2ZzIGEgYmxvY2tlciBmb3IgdGhl
IEhQQwp1c2UgY2FzZT8KClBlcmhhcHMgd2UgY2FuIGVubGlzdCAvcHJvYy9pb21lbSBvciBhIHNp
bWlsYXIgZW51bWVyYXRpb24gaW50ZXJmYWNlCnRvIHRlbGwgdXNlcnNwYWNlIHRoZSBOVU1BIG5v
ZGUgYW5kIHdoZXRoZXIgdGhlIGtlcm5lbCB0aGlua3MgaXQgaGFzCmJldHRlciBvciB3b3JzZSBw
ZXJmb3JtYW5jZSBjaGFyYWN0ZXJpc3RpY3MgcmVsYXRpdmUgdG8gYmFzZQpzeXN0ZW0tUkFNLCBp
LmUuIG5ldyBJT1JFU19ERVNDXyogdmFsdWVzLiBJJ20gd29ycmllZCB0aGF0IGlmIHdlIHN0YXJ0
CnB1Ymxpc2hpbmcgYWJzb2x1dGUgbnVtYmVycyBpbiBzeXNmcyB1c2Vyc3BhY2Ugd2lsbCBkZWZh
dWx0IHRvIGxvb2tpbmcKZm9yIHNwZWNpZmljIG1hZ2ljIG51bWJlcnMgaW4gc3lzZnMgdnMgYXNr
aW5nIHRoZSBrZXJuZWwgZm9yIG1lbW9yeQp0aGF0IGhhcyBwZXJmb3JtYW5jZSBjaGFyYWN0ZXJp
c3RpY3MgcmVsYXRpdmUgdG8gYmFzZSAiU3lzdGVtIFJBTSIuIEluCm90aGVyIHdvcmRzIHRoZSBh
YnNvbHV0ZSBwZXJmb3JtYW5jZSBpbmZvcm1hdGlvbiB0aGF0IHRoZSBITUFUCnB1Ymxpc2hlcyBp
cyB1c2VmdWwgdG8gdGhlIGtlcm5lbCwgYnV0IGl0J3Mgbm90IGNsZWFyIHRoYXQgdXNlcnNwYWNl
Cm5lZWRzIHRoYXQgdnMgYSByZWxhdGl2ZSBpbmRpY2F0b3IgZm9yIG1ha2luZyBOVU1BIG5vZGUg
cHJlZmVyZW5jZQpkZWNpc2lvbnMuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGlt
bQo=
