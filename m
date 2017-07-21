Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <1500645635.4073.25.camel@redhat.com>
Subject: Re: KVM "fake DAX" flushing interface - discussion
From: Rik van Riel <riel@redhat.com>
Date: Fri, 21 Jul 2017 10:00:35 -0400
In-Reply-To: <46101617.33460557.1500643755247.JavaMail.zimbra@redhat.com>
References: <1455443283.33337333.1500618150787.JavaMail.zimbra@redhat.com>
 <945864462.33340808.1500620194836.JavaMail.zimbra@redhat.com>
 <20170721121241.GA18014@stefanha-x1.localdomain>
 <46101617.33460557.1500643755247.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
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
To: Pankaj Gupta <pagupta@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, kvm-devel <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA3LTIxIGF0IDA5OjI5IC0wNDAwLCBQYW5rYWogR3VwdGEgd3JvdGU6Cj4g
PiA+IAo+ID4gPiDCoMKgwqDCoMKgLSBGbHVzaCBoaW50IGFkZHJlc3MgdHJhcHMgZnJvbSBndWVz
dCB0byBob3N0IGFuZCBkbyBhbgo+ID4gPiBlbnRpcmUgZnN5bmMKPiA+ID4gwqDCoMKgwqDCoMKg
wqBvbiBiYWNraW5nIGZpbGUgd2hpY2ggaXRzZWxmIGlzIGNvc3RseS4KPiA+ID4gCj4gPiA+IMKg
wqDCoMKgwqAtIENhbiBiZSB1c2VkIHRvIGZsdXNoIHNwZWNpZmljIHBhZ2VzIG9uIGhvc3QgYmFj
a2luZyBkaXNrLgo+ID4gPiBXZSBjYW4KPiA+ID4gwqDCoMKgwqDCoMKgwqBzZW5kIGRhdGEocGFn
ZXMgaW5mb3JtYXRpb24pIGVxdWFsIHRvIGNhY2hlLWxpbmUKPiA+ID4gc2l6ZShsaW1pdGF0aW9u
KQo+ID4gPiDCoMKgwqDCoMKgwqDCoGFuZCB0ZWxsIGhvc3QgdG8gc3luYyBjb3JyZXNwb25kaW5n
IHBhZ2VzIGluc3RlYWQgb2YKPiA+ID4gZW50aXJlIGRpc2sKPiA+ID4gwqDCoMKgwqDCoMKgwqBz
eW5jLgo+ID4gCj4gPiBBcmUgeW91IHN1cmU/wqDCoFlvdXIgcHJldmlvdXMgcG9pbnQgc2F5cyBv
bmx5IHRoZSBlbnRpcmUgZGV2aWNlIGNhbgo+ID4gYmUKPiA+IHN5bmNlZC7CoMKgVGhlIE5WRElN
TSBBZHJlc3MgRmx1c2ggSGludHMgaW50ZXJmYWNlIGRvZXMgbm90IGludm9sdmUKPiA+IGFkZHJl
c3MgcmFuZ2UgaW5mb3JtYXRpb24uCj4gCj4gSnVzdCBzeW5jaW5nIGVudGlyZSBibG9jayBkZXZp
Y2Ugc2hvdWxkIGJlIHNpbXBsZSBidXQgY29zdGx5LgoKQ29zdGx5IGRlcGVuZHMgb24ganVzdCBo
b3cgZmFzdCB0aGUgYmFja2luZyBJTyBkZXZpY2UgaXMuCgpJZiB0aGUgYmFja2luZyBJTyBpcyBh
IHNwaW5uaW5nIGRpc2ssIGRvaW5nIHRhcmdldGVkIHJhbmdlCnN5bmNzIHdpbGwgY2VydGFpbmx5
IGJlIGZhc3Rlci4KCk9uIHRoZSBvdGhlciBoYW5kLCBpZiB0aGUgYmFja2luZyBJTyBpcyBvbmUg
b2YgdGhlIGxhdGVzdApnZW5lcmF0aW9uIFNTRCBkZXZpY2VzLCBpdCBtYXkgYmUgZmFzdGVyIHRv
IGhhdmUganVzdCBvbmUKaHlwZXJjYWxsIGFuZCBmbHVzaCBldmVyeXRoaW5nLCB0aGFuIGl0IHdv
dWxkIGJlIHRvIGhhdmUKc2VwYXJhdGUgc3luYyBjYWxscyBmb3IgZWFjaCByYW5nZSB0aGF0IHdl
IHdhbnQgZmx1c2hlZC4KClNob3VsZCB3ZSBkZXNpZ24gb3VyIGludGVyZmFjZXMgZm9yIHllc3Rl
cmRheSdzIHN0b3JhZ2UKZGV2aWNlcywgb3IgZm9yIHRvbW9ycm93J3Mgc3RvcmFnZSBkZXZpY2Vz
PwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
