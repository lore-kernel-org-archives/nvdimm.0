From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH v3 3/4] dm: add infrastructure for DAX support
Date: Thu, 23 Jun 2016 23:36:25 +0000
Message-ID: <1466724984.3504.380.camel@hpe.com>
References: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
 <1466715953-40692-4-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466715953-40692-4-git-send-email-snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <BD7440CD95B45B4696404A994BE2037B-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gVGh1LCAyMDE2LTA2LTIzIGF0IDE3OjA1IC0wNDAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6DQrC
oDoNCj4gK3N0YXRpYyBpbnQgZGV2aWNlX3N1cHBvcnRzX2RheChzdHJ1Y3QgZG1fdGFyZ2V0ICp0
aSwgc3RydWN0IGRtX2RldiAqZGV2LA0KPiArCQkJwqDCoMKgwqDCoMKgwqBzZWN0b3JfdCBzdGFy
dCwgc2VjdG9yX3QgbGVuLCB2b2lkICpkYXRhKQ0KPiArew0KPiArCXN0cnVjdCByZXF1ZXN0X3F1
ZXVlICpxID0gYmRldl9nZXRfcXVldWUoZGV2LT5iZGV2KTsNCj4gKw0KPiArCXJldHVybiBxICYm
IGJsa19xdWV1ZV9kYXgocSk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBib29sIGRtX3RhYmxlX3N1
cHBvcnRzX2RheChzdHJ1Y3QgZG1fdGFibGUgKnQpDQo+ICt7DQo+ICsJc3RydWN0IGRtX3Rhcmdl
dCAqdGk7DQo+ICsJdW5zaWduZWQgaSA9IDA7DQo+ICsNCj4gKwkvKiBFbnN1cmUgdGhhdCBhbGwg
dGFyZ2V0cyBzdXBwb3J0IERBWC4gKi8NCj4gKwl3aGlsZSAoaSA8IGRtX3RhYmxlX2dldF9udW1f
dGFyZ2V0cyh0KSkgew0KPiArCQl0aSA9IGRtX3RhYmxlX2dldF90YXJnZXQodCwgaSsrKTsNCj4g
Kw0KPiArCQlpZiAoIXRpLT50eXBlLT5kaXJlY3RfYWNjZXNzKQ0KPiArCQkJcmV0dXJuIGZhbHNl
Ow0KPiArDQo+ICsJCWlmICghdGktPnR5cGUtPml0ZXJhdGVfZGV2aWNlcyB8fA0KPiArCQnCoMKg
wqDCoCF0aS0+dHlwZS0+aXRlcmF0ZV9kZXZpY2VzKHRpLCBkZXZpY2Vfc3VwcG9ydHNfZGF4LA0K
PiBOVUxMKSkNCj4gKwkJCXJldHVybiBmYWxzZTsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gdHJ1
ZTsNCj4gK30NCj4gKw0KDQpIaSBNaWtlLA0KDQpUaGFua3MgZm9yIHRoZSB1cGRhdGUuIMKgSSBo
YXZlIGEgcXVlc3Rpb24gYWJvdXQgdGhlIGFib3ZlIGNoYW5nZS4gwqBUYXJnZXRzIG1heQ0KaGF2
ZSB0aGVpciBvd24gcGFyYW1ldGVycy4gwqBGb3IgaW5zdGFuY2UsIGRtLXN0cmlwZSBoYXMgJ2No
dW5rX3NpemUnLCB3aGljaCBpcw0KY2hlY2tlZCBpbiBzdHJpcGVfY3RyKCkuIMKgREFYIGFkZHMg
YWRkaXRpb25hbCByZXN0cmljdGlvbiB0aGF0IGNodW5rX3NpemUNCm5lZWRzIHRvIGJlIGFsaWdu
ZWQgYnkgcGFnZSBzaXplLiDCoFNvLCBJIHRoaW5rIHdlIG5lZWQgdG8ga2VlcCB0YXJnZXQNCnJl
c3BvbnNpYmxlIHRvIHZlcmlmeSBpZiBEQVggY2FuIGJlIHN1cHBvcnRlZC4gwqBXaGF0IGRvIHlv
dSB0aGluaz8NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4
LW52ZGltbQo=
