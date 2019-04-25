From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
Date: Thu, 25 Apr 2019 17:32:05 +0200
Message-ID: <CAK8P3a1qCQJEkne3uAw-Ep-taNU9t5Y2ZmgoiCGmOz1BSwmzEw@mail.gmail.com>
References: <20190416202013.4034148-1-arnd@arndb.de>
 <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190425122153.450fc094@coco.lan>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-nvme@lists.infradead.org, Sean Young <sean@mess.org>, linux-iio@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>, linux-pci <linux-pci@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, sparclinux <sparclinux@vger.kernel.org>, driverdevel <devel@driverdev.osuosl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-rdma <linux-rdma@vger.kernel.org>, qat-linux@intel.com, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@mellanox.com>, "open list:HID CORE LAYER" <linux-input@vger.kernel.org>, Darren Hart <dvhart@infradead.org>, Linux Media Mailing List <linux-media@vger.kernel.org>, linux-remoteproc@vger.kernel.org, linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, David Sterba <dsterba@suse.com>, ceph
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCBBcHIgMjUsIDIwMTkgYXQgNToyMiBQTSBNYXVybyBDYXJ2YWxobyBDaGVoYWIKPG1j
aGVoYWIrc2Ftc3VuZ0BrZXJuZWwub3JnPiB3cm90ZToKPiBFbSBUdWUsIDE2IEFwciAyMDE5IDIy
OjI1OjMzICswMjAwIEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+IGVzY3JldmV1Ogo+Cj4g
SWYgSSB1bmRlcnN0YW5kIHlvdXIgcGF0Y2ggZGVzY3JpcHRpb24gd2VsbCwgdXNpbmcgY29tcGF0
X3B0cl9pb2N0bAo+IG9ubHkgd29ya3MgaWYgdGhlIGRyaXZlciBpcyBub3QgZm9yIHMzOTAsIHJp
Z2h0PwoKTm8sIHRoZSBwdXJwb3NlIG9mIGNvbXBhdF9wdHJfaW9jdGwoKSBpcyB0byBtYWtlIHN1
cmUgaXQgd29ya3MKZXZlcnl3aGVyZSBpbmNsdWRpbmcgczM5MC4KCkV2ZW4gb24gczM5MCBpdCB0
ZW5kcyB0byB3b3JrIG1vc3Qgb2YgdGhlIHRpbWUsIGJ1dCBmb3IgY29ycmVjdG5lc3MKdGhlIHVw
cGVyIGJpdCBvZiBhIDMyLWJpdCBwb2ludGVyIG5lZWRzIHRvIGJlIGNsZWFyZWQsIGFzCmNvbXBh
dF9wdHJfaW9jdGwgZG9lcywgaW4gY2FzZSBzb21lIGFwcGxpY2F0aW9uIHBhc3NlcyBhIHBvaW50
ZXIKd2l0aCB0aGF0IGJpdCBzZXQuIFtJSVJDLCBpbiB0aGUgaW5zdHJ1Y3Rpb24gcG9pbnRlciwg
dGhlIGhpZ2ggYml0IGlzIHNldCwgaW4KZGF0YSByZWZlcmVuY2VzIGl0IGlzIGlnbm9yZWQgYnV0
IHVzdWFsbHkgY2xlYXJlZCwgYnV0IGl0IG1heSBiZSBsZWZ0Cm9uIGZvciBJUC1yZWxhdGl2ZSBh
ZGRyZXNzIGdlbmVyYXRpb25dCgogICAgICAgQXJuZApfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBs
aXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1h
bi9saXN0aW5mby9kcmktZGV2ZWw=
