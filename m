Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 26 Jul 2017 09:47:21 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1063764405.34607875.1501076841865.JavaMail.zimbra@redhat.com>
In-Reply-To: <1501016375.26846.21.camel@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <CAPcyv4hpbk0jgp+mA=q05zVBV8ZSZvCvV68JJ4gjE3QhK70d1w@mail.gmail.com>
 <20170724102330.GE652@quack2.suse.cz>
 <1157879323.33809400.1500897967669.JavaMail.zimbra@redhat.com>
 <20170724123752.GN652@quack2.suse.cz>
 <1888117852.34216619.1500992835767.JavaMail.zimbra@redhat.com>
 <CAPcyv4in28F3FOVKp9abvrggxPuXdbGynF5=ZvBXCrywoa06JA@mail.gmail.com>
 <1501016375.26846.21.camel@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
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
To: Rik van Riel <riel@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Jan Kara <jack@suse.cz>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@gmail.com>, Ross Zwisler <ross.zwisler@intel.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Cj4gCj4gT24gVHVlLCAyMDE3LTA3LTI1IGF0IDA3OjQ2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3Jv
dGU6Cj4gPiBPbiBUdWUsIEp1bCAyNSwgMjAxNyBhdCA3OjI3IEFNLCBQYW5rYWogR3VwdGEgPHBh
Z3VwdGFAcmVkaGF0LmNvbT4KPiA+IHdyb3RlOgo+ID4gPiAKPiA+ID4gTG9va3MgbGlrZSBvbmx5
IHdheSB0byBzZW5kIGZsdXNoKGJsayBkZXYpIGZyb20gZ3Vlc3QgdG8gaG9zdCB3aXRoCj4gPiA+
IG52ZGltbQo+ID4gPiBpcyB1c2luZyBmbHVzaCBoaW50IGFkZHJlc3Nlcy4gSXMgdGhpcyB0aGUg
Y29ycmVjdCBpbnRlcmZhY2UgSSBhbQo+ID4gPiBsb29raW5nPwo+ID4gPiAKPiA+ID4gYmxrZGV2
X2lzc3VlX2ZsdXNoCj4gPiA+IMKgc3VibWl0X2Jpb193YWl0Cj4gPiA+IMKgIHN1Ym1pdF9iaW8K
PiA+ID4gwqDCoMKgwqBnZW5lcmljX21ha2VfcmVxdWVzdAo+ID4gPiDCoMKgwqDCoMKgwqBwbWVt
X21ha2VfcmVxdWVzdAo+ID4gPiDCoMKgwqDCoMKgwqAuLi4KPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGlmIChiaW8tPmJpX29wZiAmIFJFUV9GTFVTSCkKPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBudmRpbW1fZmx1c2gobmRfcmVnaW9uKTsKPiA+IAo+ID4gSSB3b3Vs
ZCBpbmplY3QgYSBwYXJhdmlydHVhbGl6ZWQgdmVyc2lvbiBvZiBwbWVtX21ha2VfcmVxdWVzdCgp
IHRoYXQKPiA+IHNlbmRzIGFuIGFzeW5jIGZsdXNoIG9wZXJhdGlvbiBvdmVyIHZpcnRpbyB0byB0
aGUgaG9zdC4gRG9uJ3QgdHJ5IHRvCj4gPiB1c2UgZmx1c2ggaGludCBhZGRyZXNzZXMgZm9yIHRo
aXMsIHRoZXkgZG9uJ3QgaGF2ZSB0aGUgcHJvcGVyCj4gPiBzZW1hbnRpY3MuIFRoZSBndWVzdCBz
aG91bGQgYmUgYWxsb3dlZCB0byBpc3N1ZSB0aGUgZmx1c2ggYW5kIHJlY2VpdmUKPiA+IHRoZSBj
b21wbGV0aW9uIGFzeW5jaHJvbm91c2x5IHJhdGhlciB0aGFuIHRha2luZyBhIHZtIGV4aXN0IGFu
ZAo+ID4gYmxvY2tpbmcgb24gdGhhdCByZXF1ZXN0Lgo+IAo+IFRoYXQgaXMgbXkgZmVlbGluZywg
dG9vLiBBIHNsb3dlciBJTyBkZXZpY2UgYmVuZWZpdHMKPiBncmVhdGx5IGZyb20gYW4gYXN5bmNo
cm9ub3VzIGZsdXNoIG1lY2hhbmlzbS4KClRoYW5rcyBmb3IgYWxsIHRoZSBzdWdnZXN0aW9ucyEK
Ckp1c3Qgd2FudCB0byBzdW1tYXJpemUgaGVyZShoaWdoIGxldmVsKToKClRoaXMgd2lsbCByZXF1
aXJlIGltcGxlbWVudGluZyBuZXcgJ3ZpcnRpby1wbWVtJyBkZXZpY2Ugd2hpY2ggcHJlc2VudHMg
CmEgREFYIGFkZHJlc3MgcmFuZ2UobGlrZSBwbWVtKSB0byBndWVzdCB3aXRoIHJlYWQvd3JpdGUo
ZGlyZWN0IGFjY2VzcykKJiBkZXZpY2UgZmx1c2ggZnVuY3Rpb25hbGl0eS4gQWxzbywgcWVtdSBz
aG91bGQgaW1wbGVtZW50IGNvcnJlc3BvbmRpbmcKc3VwcG9ydCBmb3IgZmx1c2ggdXNpbmcgdmly
dGlvLgoKVGhhbmtzLApQYW5rYWoKPiAKPiAtLQo+IEFsbCByaWdodHMgcmV2ZXJzZWQKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
