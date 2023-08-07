Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580CC383
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:22 +0000 (UTC)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230807063515epoutp01a7f03e2abd4dbcef16d3796e30a4508b~5BlkmAKM70498304983epoutp01V
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:35:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230807063515epoutp01a7f03e2abd4dbcef16d3796e30a4508b~5BlkmAKM70498304983epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691390115;
	bh=QokBe0YWBLHCE8x+t+T6/vXvJI207slSIX7n/oLpv4M=;
	h=From:To:Cc:Subject:Date:References:From;
	b=qoqR62lkwsjIuc2S3xGqvqeqCELXUJ4BN8W5BUjzqgOAZTubBmAcV6kVWWoJK+Tx3
	 N3e13+mfxa9HePfFUa4QhOqI/kfgHvIGxp7kU2rLYuIlCSDzYVeIGmVPS/XpJ+YvID
	 5CFYF5aq72hIkH3KFGc6+iqWBqizEwmpjHXmygVw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20230807063514epcas2p1a70929c329aa46726b3e4e944de632d9~5Blj_mjWb0402304023epcas2p1H;
	Mon,  7 Aug 2023 06:35:14 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4RK64x4MtDz4x9QB; Mon,  7 Aug
	2023 06:35:13 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	0F.0B.40133.1A090D46; Mon,  7 Aug 2023 15:35:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20230807063513epcas2p261ba4dfbfff34e99077596128eb6fc48~5BlizJp2B2320723207epcas2p2S;
	Mon,  7 Aug 2023 06:35:13 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230807063513epsmtrp23387fbe3ff4a5c534b01dbdbc6bf5bf5~5BliyWgMq2086220862epsmtrp2u;
	Mon,  7 Aug 2023 06:35:13 +0000 (GMT)
X-AuditID: b6c32a46-4edb870000009cc5-4c-64d090a12f3c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.F5.64355.0A090D46; Mon,  7 Aug 2023 15:35:12 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230807063512epsmtip23faa12478ecfce10934b816238b0809a~5Blim-xPz2208822088epsmtip2m;
	Mon,  7 Aug 2023 06:35:12 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 0/3] Fix accessors for temperature field when it is
 negative
Date: Mon,  7 Aug 2023 15:35:46 +0900
Message-Id: <20230807063549.5942-1-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmhe7CCRdSDC49ULC4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO+PPkIlPBDt6Ks7/+MTYw/ufqYuTk
	kBAwkdg06RJTFyMXh5DADkaJV3N+MIEkhAQ+MUpM3lAHkQCyl2xsYobpWHvzMCtEYiejxPU9
	p9kgnF4miVV/O8Gq2AS0Je5v38AGYosIyEo0r3sAtoNZYDOzxLKd58ASwgLhEv37JrGC2CwC
	qhIXvn1iB7F5BawlZv04BrVOXmL1hgPMIM0SAufYJS5ObWSCSLhIPPzfyQhhC0u8Or6FHcKW
	kvj8bi8bhJ0v8fPkLVYIu0Di05cPLBC2scS7m8+B4hxAF2lKrN+lD2JKCChLHLkFVsEswCfR
	cfgvO0SYV6KjTQiiUVWi6/gHqKXSEoevHIW60kNiy+9GNkjIxUo0NyxmmcAoOwth/gJGxlWM
	YqkFxbnpqcVGBUbwSErOz93ECE51Wm47GKe8/aB3iJGJg/EQowQHs5II77wn51OEeFMSK6tS
	i/Lji0pzUosPMZoCg2sis5Rocj4w2eaVxBuaWBqYmJkZmhuZGpgrifPea52bIiSQnliSmp2a
	WpBaBNPHxMEp1cBUwW9T2fY/oypiNlPIfq1agbmJhgZvJFYxiGfzzjziuTIpTv7u8i+Xn8gl
	ZTIezym0lGowXerh1WG6+Ch3bIXzmaMT7NtNpiRPPu9469m7dTpvGP6//B7VeTdht3FqAUf9
	jv9+5bHf7rruOa4RatPy4bDp0oia+71ec3/EN2jqT/V7Ebbb45Gkze2dP8ot3rMc5ntu+qNo
	3kI5ow+ibOFLfohPWXDHJ6UosNRbJnDzXRO9q8wdIevYfaRnVD3MO7XQPEDRZXmwvMPFDZl7
	7DXN//JEPX38cPEb+6tnuFc92NbwVi7w5plqjZgDpzVz7xsd2LdmeYPyfYtNPO7cfV2zShdy
	X+j+ouaoffgtl50SS3FGoqEWc1FxIgB7RnAT/gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsWy7bCSvO7CCRdSDE57W9x9fIHNYvrUC4wW
	J242slmsvrmG0WL/0+csFgdeN7BbrFp4jc1i8dEZzBZH93BYnJ91isVi5Y8/rBa3JhxjcuDx
	aDnyltVj8Z6XTB4vNs9k9OjbsorRY+rseo/Pm+QC2KK4bFJSczLLUov07RK4Mv48uchUsIO3
	4uyvf4wNjP+5uhg5OSQETCTW3jzM2sXIxSEksJ1RYsGFWcwQCWmJe81X2CFsYYn7LUegirqZ
	JBbt2swCkmAT0Ja4v30DG4gtIiAr0bzuARNIEbPAXmaJjpnnWUESwgKhEnfnbQIrYhFQlbjw
	7RPYVF4Ba4lZP45BbZOXWL3hAPMERp4FjAyrGEVTC4pz03OTCwz1ihNzi0vz0vWS83M3MYLD
	TitoB+Oy9X/1DjEycTAeYpTgYFYS4Z335HyKEG9KYmVValF+fFFpTmrxIUZpDhYlcV7lnM4U
	IYH0xJLU7NTUgtQimCwTB6dUA1OBvqxp/Lkp7qY62134z+vVXUmr6LNXWyd5MvnG84OCgf5r
	Y2QMg4v89gpk3Sm4t1HF1VnkarPpDIWSyJdcSbz2sdrrFk8+8MKl9f3v96GfVX5eUClm3Out
	qD0hNrRftJw37MGD0ynbld/NYWrVqLoSccuj9s+kwwct3k5fN5n3fv6kO1cv/tjdZGnh8tM/
	0//F0eqkuFqp9dcmsleHaUQm9J19U6l7UTBse7CPT0TMrrOv56o93ft4362jXnoKCbtdi9Rm
	Rbkt0hNu0/nU0RySofFv7nw1Me61nSt/W2yZwDfbrzZM7nN+gHUns1xIl4qMk0y+yaquC5U7
	Q4wrr06bMV3yrUSrTG2yj7eGEktxRqKhFnNRcSIAS/zTKKoCAAA=
X-CMS-MailID: 20230807063513epcas2p261ba4dfbfff34e99077596128eb6fc48
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063513epcas2p261ba4dfbfff34e99077596128eb6fc48
References: <CGME20230807063513epcas2p261ba4dfbfff34e99077596128eb6fc48@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

In CXL 3.0 SPEC, 8.2.9.8.3.1 and 8.2.9.8.3.2 define temperature fields
as a 2's complement value. However, they are retrieved by the same accessor
for unsigned value. This causes inaccuracy when the value is negative.

The first patch updates the pre-defined value for temperature field of
the Get Health Info command when it is not implemented by complying
CXL 3.0 specification. (CXL 3.0 8.2.9.8.3.1)

The second patch fixes accessors for temperature fields.
Add a new payload accessor for a signed value, then use it for retrieving
temperature properly. INT_MAX is used to indicate errors because negative
errno codes are not distinguishable from the retrieved values when they are
negative. Caller should check errno to know what kind of error occurs.

The third patch fixes the checking value when listing device's health info.

Changes in v2:
- Rebase on the latest pending branch
- Remove dbg() messages in libcxl accessors (Vishal)
- Make signed value accessors to return INT_MAX when error occurs and set
  errno as proper errno codes (Vishal)
- Use proper value for checking "life_used" and "device_temperature" fields
  are implemented
- Link to v1: https://lore.kernel.org/r/20230717062908.8292-1-jehoon.park@samsung.com/

Jehoon Park (3):
  libcxl: Update a revision by CXL 3.0 specification
  libcxl: Fix accessors for temperature field to support negative value
  cxl: Fix the checking value when listing device's health info

 cxl/json.c        |  9 +++++----
 cxl/lib/libcxl.c  | 32 +++++++++++++++++++++-----------
 cxl/lib/private.h |  2 +-
 3 files changed, 27 insertions(+), 16 deletions(-)


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.17.1

