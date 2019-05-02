From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 04/17] kunit: test: add kunit_stream a std::stream like
 logger
Date: Thu, 2 May 2019 13:25:54 -0700
Message-ID: <CAFd5g47ssM7RQZxQsUJ86UigcF-Uz+Kwv2yvKN_gZK-TtW89bA@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-5-brendanhiggins@google.com>
 <20190502110008.GC12416@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190502110008.GC12416@kroah.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-kselftest@vger.kernel.org, shuah@kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild@vger.kernel.org, "Bird,
 Timothy" <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Dan Williams <dan.j.williams@intel.com>, kunit-dev@googlegroups.
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCBNYXkgMiwgMjAxOSBhdCA0OjAwIEFNIEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPiB3cm90ZToKPgo+IE9uIFdlZCwgTWF5IDAxLCAyMDE5IGF0IDA0OjAxOjEzUE0g
LTA3MDAsIEJyZW5kYW4gSGlnZ2lucyB3cm90ZToKPiA+IEEgbG90IG9mIHRoZSBleHBlY3RhdGlv
biBhbmQgYXNzZXJ0aW9uIGluZnJhc3RydWN0dXJlIHByaW50cyBvdXQgZmFpcmx5Cj4gPiBjb21w
bGljYXRlZCB0ZXN0IGZhaWx1cmUgbWVzc2FnZXMsIHNvIGFkZCBhIEMrKyBzdHlsZSBsb2cgbGli
cmFyeSBmb3IKPiA+IGZvciBsb2dnaW5nIHRlc3QgcmVzdWx0cy4KPgo+IElkZWFsbHkgd2Ugd291
bGQgYWx3YXlzIHVzZSBhIHN0YW5kYXJkIGxvZ2dpbmcgZm9ybWF0LCBsaWtlIHRoZQo+IGtzZWxm
dGVzdCB0ZXN0cyBhbGwgYXJlIGFpbWluZyB0byBkby4gIFRoYXQgd2F5IHRoZSBvdXRwdXQgY2Fu
IGJlIGVhc2lseQo+IHBhcnNlZCBieSB0b29scyB0byBzZWUgaWYgdGhlIHRlc3RzIHN1Y2NlZWQv
ZmFpbCBlYXNpbHkuCj4KPiBBbnkgY2hhbmNlIG9mIGhhdmluZyB0aGlzIGxvZ2dpbmcgZnJhbWV3
b3JrIGVuZm9yY2luZyB0aGF0IGZvcm1hdCBhcwo+IHdlbGw/CgpJIGFncmVlIHdpdGggeW91ciBj
b21tZW50IG9uIHRoZSBsYXRlciBwYXRjaCB0aGF0IHdlIHNob3VsZCBoYW5kbGUKdGhpcyBhdCB0
aGUgd3JhcHBlciBzY3JpcHQgbGF5ZXIgKEtVbml0IHRvb2wpLgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1k
ZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcv
bWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
