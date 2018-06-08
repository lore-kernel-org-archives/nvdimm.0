Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E22E520974116
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 08:00:34 -0700 (PDT)
Subject: Re: [qemu PATCH 1/5] gitignore: ignore generated qapi job files
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <edcae62f-e3b6-6e25-60a5-843eeae89396@redhat.com>
From: Eric Blake <eblake@redhat.com>
Message-ID: <4865a48e-2653-b077-6656-acc5f1b49def@redhat.com>
Date: Fri, 8 Jun 2018 10:00:32 -0500
MIME-Version: 1.0
In-Reply-To: <edcae62f-e3b6-6e25-60a5-843eeae89396@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gMDYvMDgvMjAxOCAwOTo1OSBBTSwgRXJpYyBCbGFrZSB3cm90ZToKPiBPbiAwNi8wNy8yMDE4
IDA1OjMxIFBNLCBSb3NzIFp3aXNsZXIgd3JvdGU6Cj4+IFdpdGggYSBmdWxseSBidWlsdCBRRU1V
IEkgY3VycmVudGx5IHNlZSB0aGUgZm9sbG93aW5nIHdpdGggImdpdCBzdGF0dXMiOgo+Pgo+PiDC
oMKgIFVudHJhY2tlZCBmaWxlczoKPj4gwqDCoMKgwqAgKHVzZSAiZ2l0IGFkZCA8ZmlsZT4uLi4i
IHRvIGluY2x1ZGUgaW4gd2hhdCB3aWxsIGJlIGNvbW1pdHRlZCkKPj4KPj4gwqDCoMKgwqDCoMKg
IHFhcGkvcWFwaS1jb21tYW5kcy1qb2IuYwo+PiDCoMKgwqDCoMKgwqAgcWFwaS9xYXBpLWNvbW1h
bmRzLWpvYi5oCj4+IMKgwqDCoMKgwqDCoCBxYXBpL3FhcGktZXZlbnRzLWpvYi5jCj4+IMKgwqDC
oMKgwqDCoCBxYXBpL3FhcGktZXZlbnRzLWpvYi5oCj4+IMKgwqDCoMKgwqDCoCBxYXBpL3FhcGkt
dHlwZXMtam9iLmMKPj4gwqDCoMKgwqDCoMKgIHFhcGkvcWFwaS10eXBlcy1qb2IuaAo+PiDCoMKg
wqDCoMKgwqAgcWFwaS9xYXBpLXZpc2l0LWpvYi5jCj4+IMKgwqDCoMKgwqDCoCBxYXBpL3FhcGkt
dmlzaXQtam9iLmgKPj4KPj4gVGhlc2UgYXJlIGFsbCBnZW5lcmF0ZWQgZmlsZXMuwqAgSWdub3Jl
IHRoZW0uCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFJvc3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxp
bnV4LmludGVsLmNvbT4KPj4gQ2M6IEtldmluIFdvbGYgPGt3b2xmQHJlZGhhdC5jb20+Cj4+IENj
OiBFcmljIEJsYWtlIDxlYmxha2VAcmVkaGF0LmNvbT4KPj4gRml4ZXM6IGNvbW1pdCBiZjQyNTA4
ZjI0ZWUgKCJqb2I6IEludHJvZHVjZSBxYXBpL2pvYi5qc29uIikKPiAKPiBZb3UncmUgdGhlIHRo
aXJkIHRvIHBvc3QgdGhpczoKPiAKPiBodHRwczovL2xpc3RzLmdudS5vcmcvYXJjaGl2ZS9odG1s
L3FlbXUtZGV2ZWwvMjAxOC0wNS9tc2cwNzI4MC5odG1sCj4gaHR0cHM6Ly9saXN0cy5nbnUub3Jn
L2FyY2hpdmUvaHRtbC9xZW11LWRldmVsLzIwMTgtMDYvbXNnMDE2MjQuaHRtbAoKQWxzbywgd2hl
biBzZW5kaW5nIGEgc2VyaWVzLCBpdCdzIGJlc3QgdG8gaW5jbHVkZSBhIDAvNSBjb3ZlciBsZXR0
ZXIgCih0aGUgYXV0b21hdGVkIENJIHRvb2xpbmcgaGFuZGxlcyB0aGF0IGJldHRlciwgYW1vbmcg
b3RoZXIgcmVhc29ucykuIApZb3UgY2FuIHVzZSAnZ2l0IGNvbmZpZycgdG8gYXV0b21hdGljYWxs
eSBzZW5kIGEgY292ZXIgbGV0dGVyIGZvciBhbnkgCnBhdGNoIHNlcmllcyA+IDEuICBGb3IgbW9y
ZSB0aXBzLCAKaHR0cHM6Ly93aWtpLnFlbXUub3JnL0NvbnRyaWJ1dGUvU3VibWl0QVBhdGNoCgot
LSAKRXJpYyBCbGFrZSwgUHJpbmNpcGFsIFNvZnR3YXJlIEVuZ2luZWVyClJlZCBIYXQsIEluYy4g
ICAgICAgICAgICsxLTkxOS0zMDEtMzI2NgpWaXJ0dWFsaXphdGlvbjogIHFlbXUub3JnIHwgbGli
dmlydC5vcmcKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
