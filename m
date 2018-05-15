Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from SMTP.EU.CITRIX.COM (smtp.ctxuk.citrix.com [185.25.65.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 010E6209603DB
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 11:34:02 -0700 (PDT)
Subject: Re: Draft NVDIMM proposal
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
 <b0ccf9f3-56f7-e061-a5b6-4c5e1bcbecb0@citrix.com>
 <CAPcyv4huEso9OHG65UvMh9vOp-yHOR9sptKpzSC_HhhtgbihOg@mail.gmail.com>
From: Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <260a5bae-e878-3c85-ee1a-e5ee56506431@citrix.com>
Date: Tue, 15 May 2018 19:33:58 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4huEso9OHG65UvMh9vOp-yHOR9sptKpzSC_HhhtgbihOg@mail.gmail.com>
Content-Language: en-GB
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
To: Dan Williams <dan.j.williams@intel.com>, George Dunlap <george.dunlap@citrix.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Roger Pau Monne <roger.pau@citrix.com>, Jan Beulich <JBeulich@suse.com>, Yi Zhang <yi.z.zhang@intel.com>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gMTUvMDUvMTggMTk6MDYsIERhbiBXaWxsaWFtcyB3cm90ZToKPiBPbiBUdWUsIE1heSAxNSwg
MjAxOCBhdCA3OjE5IEFNLCBHZW9yZ2UgRHVubGFwIDxnZW9yZ2UuZHVubGFwQGNpdHJpeC5jb20+
IHdyb3RlOgo+PiBPbiAwNS8xMS8yMDE4IDA1OjMzIFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4+
Cj4+IFRoaXMgaXMgYWxsIHByZXR0eSBmb3VuZGF0aW9uYWwuICBYZW4gY2FuIHJlYWQgc3RhdGlj
IEFDUEkgdGFibGVzLCBidXQKPj4gaXQgY2FuJ3QgZG8gQU1MLiAgU28gdG8gZG8gYSBwcm9wZXIg
ZGVzaWduIGZvciBYZW4sIHdlIG5lZWQgdG8ga25vdzoKPiBPb29oLCBvaywgbm8gQU1MIGluIFhl
bi4uLgo+Cj4+IDEuIElmIFhlbiBjYW4gZmluZCBvdXQsIHdpdGhvdXQgTGludXgncyBoZWxwLCB3
aGF0IG5hbWVzcGFjZXMgZXhpc3QgYW5kCj4+IGlmIHRoZXJlIGlzIG9uZSBpdCBjYW4gdXNlIGZv
ciBpdHMgb3duIHB1cnBvc2VzCj4gWWVhaCwgbm8sIG5vdCB3aXRob3V0IGNhbGxpbmcgQU1MIG1l
dGhvZHMuCgpPbmUgcGFydGljdWxhcmx5IHRob3JueSBpc3N1ZSB3aXRoIFhlbidzIGFyY2hpdGVj
dHVyZSBpcyB0aGUgb3duZXJzaGlwCm9mIHRoZSBBQ1BJIE9TUE0sIGFuZCB0aGUgZmFjdCB0aGF0
IHRoZXJlIGNhbiBvbmx5IGJlIG9uZSBpbiB0aGUKc3lzdGVtLsKgIERvbTAgaGFzIHRvIGJlIHRo
ZSBPU1BNIGluIHByYWN0aWNlLCBhcyB3ZSBkb24ndCB3YW50IHRvIHBvcnQKbW9zdCBvZiB0aGUg
TGludXggZHJpdmVycyBhbmQgaW5mcmFzdHJ1Y3R1cmUgaW4gdGhlIGh5cGVydmlzb3IuCgpJZiB3
ZSBrbmV3IGEgcHJpb3JpIHRoYXQgY2VydGFpbiBBTUwgbWV0aG9kcyBoYWQgbm8gc2lkZSBlZmZl
Y3RzLCB0aGVuCndlIGNvdWxkIGluIHByaW5jaXBsZSBleGVjdXRlIHRoZW0gZnJvbSB0aGUgaHlw
ZXJ2aXNvciwgYnV0IHRoaXMgaXMgYW4KdW5kZWNpZGVhYmxlIHByb2JsZW0gaW4gZ2VuZXJhbC7C
oCBBcyBhIHJlc3VsdCwgZXZlcnl0aGluZyBpbnZvbHZpbmcgQU1MCnJlcXVpcmVzIGRvbTAgdG8g
ZGVjaXBoZXIgdGhlIGluZm9ybWF0aW9uIGFuZCBwYXNzaW5nIGl0IHRvIFhlbiBhdCBib290LgoK
fkFuZHJldwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
