Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69D3121A02937
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 01:19:00 -0800 (PST)
Subject: Re: [PATCH 1/2] dax: Check page->mapping isn't NULL
References: <20181127211634.4995-1-willy@infradead.org>
 <20181127211634.4995-2-willy@infradead.org>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <d1392a9a-bdb1-e17c-f943-ba435bc1d876@suse.de>
Date: Wed, 28 Nov 2018 10:18:58 +0100
MIME-Version: 1.0
In-Reply-To: <20181127211634.4995-2-willy@infradead.org>
Content-Language: en-US
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
To: Matthew Wilcox <willy@infradead.org>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

TG9va3MgZ29vZCwKUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8anRodW1zaGlybkBz
dXNlLmRlPgoKLS0gCkpvaGFubmVzIFRodW1zaGlybiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBTVVNFIExhYnMKanRodW1zaGlybkBzdXNlLmRlICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OQpTVVNFIExJTlVYIEdtYkgsIE1heGZl
bGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNt
aXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQpLZXkgZmluZ2Vy
cHJpbnQgPSBFQzM4IDlDQUIgQzJDNCBGMjVEIDg2MDAgRDBEMCAwMzkzIDk2OUQgMkQ3NiAwODUw
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
