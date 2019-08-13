From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v12 14/18] kunit: defconfig: add defconfigs for building
 KUnit tests
Date: Tue, 13 Aug 2019 00:59:18 -0700
Message-ID: <CAFd5g44wUOhmxr3r+-LR_igePMjtaRrtT5jGdqPJgb0xPdf+Ag@mail.gmail.com>
References: <20190812182421.141150-1-brendanhiggins@google.com>
 <20190812182421.141150-15-brendanhiggins@google.com>
 <20190813043859.661F82054F@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190813043859.661F82054F@mail.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird,
 Timothy" <Tim.Bird>
List-Id: linux-nvdimm@lists.01.org

T24gTW9uLCBBdWcgMTIsIDIwMTkgYXQgOTozOSBQTSBTdGVwaGVuIEJveWQgPHNib3lkQGtlcm5l
bC5vcmc+IHdyb3RlOgo+Cj4gUXVvdGluZyBCcmVuZGFuIEhpZ2dpbnMgKDIwMTktMDgtMTIgMTE6
MjQ6MTcpCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC91bS9jb25maWdzL2t1bml0X2RlZmNvbmZpZyBi
L2FyY2gvdW0vY29uZmlncy9rdW5pdF9kZWZjb25maWcKPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0
Cj4gPiBpbmRleCAwMDAwMDAwMDAwMDAwLi5iZmU0OTY4OTAzOGYxCj4gPiAtLS0gL2Rldi9udWxs
Cj4gPiArKysgYi9hcmNoL3VtL2NvbmZpZ3Mva3VuaXRfZGVmY29uZmlnCj4gPiBAQCAtMCwwICsx
LDggQEAKPiA+ICtDT05GSUdfT0Y9eQo+ID4gK0NPTkZJR19PRl9VTklUVEVTVD15Cj4gPiArQ09O
RklHX09GX09WRVJMQVk9eQo+ID4gK0NPTkZJR19JMkM9eQo+ID4gK0NPTkZJR19JMkNfTVVYPXkK
PiA+ICtDT05GSUdfS1VOSVQ9eQo+ID4gK0NPTkZJR19LVU5JVF9URVNUPXkKPiA+ICtDT05GSUdf
S1VOSVRfRVhBTVBMRV9URVNUPXkKPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL2t1bml0
L2NvbmZpZ3MvYWxsX3Rlc3RzLmNvbmZpZyBiL3Rvb2xzL3Rlc3Rpbmcva3VuaXQvY29uZmlncy9h
bGxfdGVzdHMuY29uZmlnCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NAo+ID4gaW5kZXggMDAwMDAw
MDAwMDAwMC4uYmZlNDk2ODkwMzhmMQo+ID4gLS0tIC9kZXYvbnVsbAo+ID4gKysrIGIvdG9vbHMv
dGVzdGluZy9rdW5pdC9jb25maWdzL2FsbF90ZXN0cy5jb25maWcKPiA+IEBAIC0wLDAgKzEsOCBA
QAo+ID4gK0NPTkZJR19PRj15Cj4gPiArQ09ORklHX09GX1VOSVRURVNUPXkKPiA+ICtDT05GSUdf
T0ZfT1ZFUkxBWT15Cj4gPiArQ09ORklHX0kyQz15Cj4gPiArQ09ORklHX0kyQ19NVVg9eQo+Cj4g
QXJlIHRoZXNlIGFib3ZlIGNvbmZpZyBvcHRpb25zIG5lY2Vzc2FyeT8gSSBkb24ndCB0aGluayB0
aGV5J3JlIHBhcnQgb2YKPiB0aGUgcGF0Y2ggc2VyaWVzIGFueW1vcmUgc28gaXQgbG9va3Mgb2Rk
IHRvIGVuYWJsZSB0aGUgT0YgdW5pdHRlc3RzIGFuZAo+IGkyYyBjb25maWdzLgoKT2ggd2hvb3Bz
LCBJIGZvcmdvdCB0aGF0IHdlIGRyb3BwZWQgdGhlIE9GX1VOSVRURVNUIGZyb20gdGhpcwpwYXRj
aHNldC4gV2lsbCBmaXguCgo+ID4gK0NPTkZJR19LVU5JVD15Cj4gPiArQ09ORklHX0tVTklUX1RF
U1Q9eQo+ID4gK0NPTkZJR19LVU5JVF9FWEFNUExFX1RFU1Q9eQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1k
ZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcv
bWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
