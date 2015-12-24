Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: A blocksize problem about dax and ext4
Date: Thu, 24 Dec 2015 02:47:07 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC9CDD@G9W0745.americas.hpqcorp.net>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
	<CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
 <CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
In-Reply-To: <CAM=YXF-wZEhodxVRN8nqyH9Vg7t85ut2-0PnEn9OvhpG_jX3mA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Cholerae Hu <choleraehyq@gmail.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDaG9sZXJhZSBIdSBbbWFpbHRv
OmNob2xlcmFlaHlxQGdtYWlsLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAyMywg
MjAxNSA4OjM2IFBNDQo+IFN1YmplY3Q6IFJlOiBBIGJsb2Nrc2l6ZSBwcm9ibGVtIGFib3V0IGRh
eCBhbmQgZXh0NA0KLi4uDQo+IHhmcyB3aWxsIHNpbGVudGx5IGRpc2FibGUgZGF4IHdoZW4gdGhl
IGZzIGJsb2NrIHNpemUgaXMgdG9vIHNtYWxsLA0KPiBpLmUuIHlvdXIgbW1hcCgpIG9wZXJhdGlv
bnMgYXJlIGJhY2tlZCBieSBwYWdlIGNhY2hlIGluIHRoaXMgY2FzZS4NCj4gQ3VycmVudGx5IHRo
ZSBvbmx5IGluZGljYXRpb24gb2Ygd2hldGhlciBhIG1hcHBpbmcgaXMgREFYIGJhY2tlZCBvcg0K
PiBub3QgaXMgdGhlIHByZXNlbmNlIG9mIHRoZSBWTV9NSVhFRE1BUCBmbGFnICgibW0iIGluIHRo
ZSBWbUZsYWdzIGZpZWxkDQo+IG9mIC9wcm9jLzxwaWQ+L3NtYXBzKQ0KPiANCj4gRGlkIHlvdSBt
ZWFuIHRoYXQgSSBzaG91bGQgbWFrZSB0aGUgYmxvY2tzaXplIGJpZ2dlciB1bnRpbCB0aGUgbW91
bnQNCj4gY29tbWFuZCB0ZWxsIG1lIHRoYXQgZGF4IGlzIGVuYWJsZWQ/DQoNClRvIHJlYWxseSB1
c2UgREFYLCB0aGUgZmlsZXN5c3RlbSBibG9jayBzaXplIG11c3QgbWF0Y2ggdGhlDQpzeXN0ZW0g
Q1BVJ3MgcGFnZSBzaXplLCB3aGljaCBpcyBwcm9iYWJseSA0MDk2IGJ5dGVzLg0KDQotLS0NClJv
YmVydCBFbGxpb3R0LCBIUEUgUGVyc2lzdGVudCBNZW1vcnkNCg0K
