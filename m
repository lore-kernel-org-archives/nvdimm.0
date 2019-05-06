From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 12/17] kunit: tool: add Python wrappers for running
 KUnit tests
Date: Mon, 6 May 2019 14:42:53 -0700
Message-ID: <CAFd5g47d-e31NecDEbMud0rUH55EbhcS0wJpjB1PZZaX5Udqmw@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-13-brendanhiggins@google.com>
 <20190502110220.GD12416@kroah.com>
 <CAFd5g47t=EdLKFCT=CnPkrM2z0nDVo24Gz4j0VxFOJbARP37Lg@mail.gmail.com>
 <a49c5088-a821-210c-66de-f422536f5b01@gmail.com>
 <CAFd5g44iWRchQKdJYtjRtPY6e-6e0eXpKXXsx5Ooi6sWE474KA@mail.gmail.com>
 <1a5f3c44-9fa9-d423-66bf-45255a90c468@gmail.com>
 <CAFd5g45RYm+zfdJXnyp2KZZH5ojfOzy++aq+4zBeE5VDu6WgEw@mail.gmail.com>
 <052fa196-4ea9-8384-79b7-fe6bacc0ee82@gmail.com>
 <CAFd5g47aY-CL+d7DfiyTidY4aAVY+eg1TM1UJ4nYqKSfHOi-0w@mail.gmail.com>
 <63f63c7c-6185-5e64-b338-6a5e7fb9e27c@gmail.com>
 <CAGXu5jJpp2HyEWMtAde+VUt=9ni3HRu69NM4rUQJu4kBrnx9Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAGXu5jJpp2HyEWMtAde+VUt=9ni3HRu69NM4rUQJu4kBrnx9Kw@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Kees Cook <keescook@google.com>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Shuah Khan <shuah@kernel.org>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Felix Guo <felixguoxiuping@gmail.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird,
 Timothy" <Tim.Bird@sony.com>, linux-um@lists.infradead.org
List-Id: linux-nvdimm@lists.01.org

PiBPbiBTdW4sIE1heSA1LCAyMDE5IGF0IDU6MTkgUE0gRnJhbmsgUm93YW5kIDxmcm93YW5kLmxp
c3RAZ21haWwuY29tPiB3cm90ZToKPiA+IFlvdSBjYW4gc2VlIHRoZSBmdWxsIHZlcnNpb24gMTQg
ZG9jdW1lbnQgaW4gdGhlIHN1Ym1pdHRlcidzIHJlcG86Cj4gPgo+ID4gICAkIGdpdCBjbG9uZSBo
dHRwczovL2dpdGh1Yi5jb20vaXNhYWNzL3Rlc3Rhbnl0aGluZy5naXRodWIuaW8uZ2l0Cj4gPiAg
ICQgY2QgdGVzdGFueXRoaW5nLmdpdGh1Yi5pbwo+ID4gICAkIGdpdCBjaGVja291dCB0YXAxNAo+
ID4gICAkIGxzIHRhcC12ZXJzaW9uLTE0LXNwZWNpZmljYXRpb24ubWQKPiA+Cj4gPiBNeSB1bmRl
cnN0YW5kaW5nIGlzIHRoZSB0aGUgdmVyc2lvbiAxNCBzcGVjaWZpY2F0aW9uIGlzIG5vdCB0cnlp
bmcgdG8KPiA+IGFkZCBuZXcgZmVhdHVyZXMsIGJ1dCBpbnN0ZWFkIGNhcHR1cmUgd2hhdCBpcyBh
bHJlYWR5IGltcGxlbWVudGVkIGluCj4gPiB0aGUgd2lsZC4KPgo+IE9oISBJIGRpZG4ndCBrbm93
IGFib3V0IHRoZSB3b3JrIG9uIFRBUCAxNC4gSSdsbCBnbyByZWFkIHRocm91Z2ggdGhpcy4KPgo+
ID4gPiAjIyBIZXJlIGlzIHdoYXQgSSBwcm9wb3NlIGZvciB0aGlzIHBhdGNoc2V0Ogo+ID4gPgo+
ID4gPiAgLSBQcmludCBvdXQgdGVzdCBudW1iZXIgcmFuZ2UgYXQgdGhlIGJlZ2lubmluZyBvZiBl
YWNoIHRlc3Qgc3VpdGUuCj4gPiA+ICAtIFByaW50IG91dCBsb2cgbGluZXMgYXMgc29vbiBhcyB0
aGV5IGhhcHBlbiBhcyBkaWFnbm9zdGljcy4KPiA+ID4gIC0gUHJpbnQgb3V0IHRoZSBsaW5lcyB0
aGF0IHN0YXRlIHdoZXRoZXIgYSB0ZXN0IHBhc3NlcyBvciBmYWlscyBhcyBhCj4gPiA+IG9rL25v
dCBvayBsaW5lLgo+ID4gPgo+ID4gPiBUaGlzIHdvdWxkIGJlIHRlY2huaWNhbGx5IGNvbmZvcm1p
bmcgd2l0aCBUQVAxMyBhbmQgaXMgY29uc2lzdGVudCB3aXRoCj4gPiA+IHdoYXQgc29tZSBrc2Vs
ZnRlc3RzIGhhdmUgZG9uZS4KPgo+IFRoaXMgaXMgd2hhdCBJIGZpeGVkIGtzZWxmdGVzdCB0byBh
Y3R1YWxseSBkbyAoaXQgd2Fzbid0IGRvaW5nIGNvcnJlY3QKPiBUQVAxMyksIGFuZCBTaHVhaCBp
cyB0ZXN0aW5nIHRoZSBzZXJpZXMgbm93Ogo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3NodWFoL2xpbnV4LWtzZWxmdGVzdC5naXQvbG9nLz9oPWtzZnQt
dGFwLXJlZmFjdG9yCgpPaCwgY29vbCEgSSBndWVzcyB0aGlzIGlzIGFuIG9rYXkgYXBwcm9hY2gg
dGhlbi4KClRoYW5rcyEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Au
b3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRl
dmVs
