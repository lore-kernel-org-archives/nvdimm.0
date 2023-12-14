Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01887125C7
	for <nvdimm@lists.linux.dev>; Thu, 14 Dec 2023 07:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from dinghao.liu$zju.edu.cn ( [10.190.71.46] ) by
 ajax-webmail-mail-app2 (Coremail) ; Thu, 14 Dec 2023 15:33:30 +0800
 (GMT+08:00)
Date: Thu, 14 Dec 2023 15:33:30 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: dinghao.liu@zju.edu.cn
To: "Dave Jiang" <dave.jiang@intel.com>
Cc: "Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dan Williams" <dan.j.williams@intel.com>, 
	"Ira Weiny" <ira.weiny@intel.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nvdimm-btt: simplify code with the scope based resource
 management
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.2-cmXT5 build
 20230825(e13b6a3b) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4df6dc2c-e274-4d1c-b502-72c5c3dfa9ce-zj.edu.cn
In-Reply-To: <0473a930-9b80-4b81-81a1-c9adb0dc3919@intel.com>
References: <20231210102747.13545-1-dinghao.liu@zju.edu.cn>
 <8716bf72-e4ca-4f83-8a30-327baf459dbb@intel.com>
 <369f7d97.32dac.18c6129229a.Coremail.dinghao.liu@zju.edu.cn>
 <0473a930-9b80-4b81-81a1-c9adb0dc3919@intel.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5c62b668.34d1b.18c673eaeb5.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:by_KCgAXjdTKr3plMUyQAA--.27858W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgIIBmV4LpY5mAAIsC
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

PiA+IEl0J3MgYSBsaXR0bGUgc3RyYW5nZSB0aGF0IHdlIGRvIG5vdCBjaGVjayBzdXBlciBpbW1l
ZGlhdGVseSBhZnRlciBhbGxvY2F0aW9uLgo+ID4gSG93IGFib3V0IHRoaXM6Cj4gPiAKPiA+ICBz
dGF0aWMgaW50IGRpc2NvdmVyX2FyZW5hcyhzdHJ1Y3QgYnR0ICpidHQpCj4gPiAgewo+ID4gICAg
ICAgICBpbnQgcmV0ID0gMDsKPiA+ICAgICAgICAgc3RydWN0IGFyZW5hX2luZm8gKmFyZW5hOwo+
ID4gLSAgICAgICBzdHJ1Y3QgYnR0X3NiICpzdXBlcjsKPiA+ICAgICAgICAgc2l6ZV90IHJlbWFp
bmluZyA9IGJ0dC0+cmF3c2l6ZTsKPiA+ICAgICAgICAgdTY0IGN1cl9ubGJhID0gMDsKPiA+ICAg
ICAgICAgc2l6ZV90IGN1cl9vZmYgPSAwOwo+ID4gICAgICAgICBpbnQgbnVtX2FyZW5hcyA9IDA7
Cj4gPiAgCj4gPiAtICAgICAgIHN1cGVyID0ga3phbGxvYyhzaXplb2YoKnN1cGVyKSwgR0ZQX0tF
Uk5FTCk7Cj4gPiArICAgICAgIHN0cnVjdCBidHRfc2IgKnN1cGVyIF9fZnJlZShrZnJlZSkgPSAK
PiA+ICsgICAgICAgICAgICAgICBremFsbG9jKHNpemVvZigqc3VwZXIpLCBHRlBfS0VSTkVMKTsK
PiA+ICAgICAgICAgaWYgKCFzdXBlcikKPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01F
TTsKPiA+ICAKPiA+ICAgICAgICAgd2hpbGUgKHJlbWFpbmluZykgewo+ID4gIAo+IAo+IFRoYXQn
cyBmaW5lIGJ5IG1lCgpJIHdpbGwgcmVzZW5kIGEgbmV3IHBhdGNoIHNvb24sIHRoYW5rcyEKClJl
Z2FyZHMsCkRpbmdoYW8=
