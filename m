Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D7E33D7
	for <nvdimm@lists.linux.dev>; Mon, 18 Sep 2023 05:00:11 +0000 (UTC)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230918045210epoutp02a168b58a25b5554f2814ea8dd8aaf103~F5Rj0r7jN2105121051epoutp024
	for <nvdimm@lists.linux.dev>; Mon, 18 Sep 2023 04:52:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230918045210epoutp02a168b58a25b5554f2814ea8dd8aaf103~F5Rj0r7jN2105121051epoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1695012730;
	bh=wGIuuZgcO3xdRGPnPT99yIjCZBh1PNDhl+AJLqSthEU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=CHzGos9AknthRQhiDSezn+j+dKzZlU+OuVRGye9MMbRzs/zxagLyTX0TE1fb9yQlF
	 OM0G+jPgzyh0rlm4cpCA4SLaAnVXlLcJgkaA9pDL+F+Vyh9KtnI3fGX3D6DhySxkmA
	 i/OquNV8G0z61GshSQb41T4JYFUQwo3FqZXG8kKI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230918045209epcas2p2e7f82d0486d5b770bc8e3e392f8cb6ca~F5RjE08Wo0240802408epcas2p2u;
	Mon, 18 Sep 2023 04:52:09 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.99]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Rpspc4xGtz4x9Py; Mon, 18 Sep
	2023 04:52:08 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9D.2F.19471.877D7056; Mon, 18 Sep 2023 13:52:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20230918045208epcas2p36f0c80940e86e5165a3036414a32d7f6~F5Rh8P1wr2951129511epcas2p3c;
	Mon, 18 Sep 2023 04:52:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230918045208epsmtrp257851a6db9b04c56c61d93739518197d~F5Rh7Vwxn2547925479epsmtrp2s;
	Mon, 18 Sep 2023 04:52:08 +0000 (GMT)
X-AuditID: b6c32a4d-dc5ff70000004c0f-a7-6507d778ddbc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9E.A4.08742.777D7056; Mon, 18 Sep 2023 13:52:08 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230918045207epsmtip1102bde8ffc92d4dfb71235b9781ecb58~F5Rhv3Icn1750417504epsmtip1G;
	Mon, 18 Sep 2023 04:52:07 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 0/2] add support for Set Alert Configuration
 mailbox command
Date: Mon, 18 Sep 2023 13:55:12 +0900
Message-Id: <20230918045514.6709-1-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmqW7FdfZUg/WflSzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCcqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
	S2yVUgtScgrMC/SKE3OLS/PS9fJSS6wMDQyMTIEKE7Iztt2Zx1owi6/i9J+5LA2My7i6GDk5
	JARMJD78uscCYgsJ7GGUOPuuvouRC8j+xCjx+OMkdgjnG6PE1a2LWGA6Oq5/ZYVI7GWUmL5g
	ORuE08sk0fSukw2kik1AW+L+9g1gtoiArETzugdMIEXMApuZJZbtPAeWEBYIl5hwpQUowcHB
	IqAqsXGKAUiYV8Ba4vb/jewQ2+QlVm84wAzSKyFwjV3iRGMzI0TCReL0n59QRcISr45vgbKl
	JD6/28sGYedL/Dx5ixXCLpD49OUD1AvGEu9uPmcF2cssoCmxfpc+iCkhoCxx5BZYBbMAn0TH
	4b/sEGFeiY42IYhGVYmu4x+gDpCWOHzlKDNEiYdE54sySCDGStx8sYdxAqPsLITxCxgZVzFK
	pRYU56anJhsVGOrmpZbDoyk5P3cTIzjdafnuYHy9/q/eIUYmDsZDjBIczEoivDMN2VKFeFMS
	K6tSi/Lji0pzUosPMZoCA2wis5Rocj4w4eaVxBuaWBqYmJkZmhuZGpgrifPea52bIiSQnliS
	mp2aWpBaBNPHxMEp1cBkOc+Lc0a6UPBz9UVLVWVK/ROEAtoqbFv0TqadrXtlrF+X8PL6vX22
	VRYzRPN063c5N3bFx/W+eSn4kkV6ils8m7OYxPRVG2e/Kfhdc009Usp4U9POBzzcj6R/aH3m
	FLbi0iypTOKJcW284bVXrSvvZIusWFq+Qkzr/imyLqplS/xEt4e76L8u038wfXnIRe8OL+M1
	5ZPCs60uVrm+a/etUVq+PLHWSXBX3hx7sb6pcwVMlx/cfYJTQCT3uHruURmdVd7nSv1dGfye
	K286ssaj/KzvqYdPZ7d+5lxju8jFUUfm9JNqizl8ZytlXpt/n2yQu13tr+rpjA2tLju3X73h
	EjDh6t4i7g8Cc3Y9VGIpzkg01GIuKk4EAE3iBtQABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsWy7bCSnG7FdfZUg9kZFncfX2CzmD71AqPF
	iZuNbBarb65htNj/9DmLxYHXDewWqxZeY7NYfHQGs8XRPRwW52edYrFY+eMPq8WtCceYHHg8
	Wo68ZfVYvOclk8eLzTMZPfq2rGL0mDq73uPzJrkAtigum5TUnMyy1CJ9uwSujG135rEWzOKr
	OP1nLksD4zKuLkZODgkBE4mO619Zuxi5OIQEdjNKXNnzgBUiIS1xr/kKO4QtLHG/5QhUUTeT
	xLdTs5lAEmwC2hL3t29gA7FFBGQlmtc9YAIpYhbYyyzRMfM82CRhgVCJHXOmAdkcHCwCqhIb
	pxiAhHkFrCVu/98ItUBeYvWGA8wTGHkWMDKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P
	3cQIDj4tzR2M21d90DvEyMTBeIhRgoNZSYR3piFbqhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe
	8Re9KUIC6YklqdmpqQWpRTBZJg5OqQamLk7pknVXUh8ZVdxlczmm+kxrcf5EzenzfZcr7/q0
	oizx1Ivmpf3bjq2+PfOylRRLyun1URHL4pbNyPu3TmPWDZvDmq5no8y06h1Xfg5U3ljymlN0
	fuOqJYmFt5IC5OU0RHLVXzH9/BmrVpmf6imozi+ZIeC17IDWhar5Dtsmn9wrJ5srZP9Egp1D
	pT5pU/U/v/WNur4TGAu2++0wWncmbF5JrWe85n6H+kPxAtW3neMa6lTFHryrjF5qtqw9K/UA
	2+qnXqZly/3Co9sO3j039/jEOEP+EhUWrzq3P8dqxIt6TvxgUlLcOk1s2kOzzUydZ9qvpy+K
	vHPx0bHuVfeOzLhQefOppVxOz4/K4nwlluKMREMt5qLiRACLUBJUrQIAAA==
X-CMS-MailID: 20230918045208epcas2p36f0c80940e86e5165a3036414a32d7f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230918045208epcas2p36f0c80940e86e5165a3036414a32d7f6
References: <CGME20230918045208epcas2p36f0c80940e86e5165a3036414a32d7f6@epcas2p3.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

CXL 3.0 Spec 8.2.9.8.3.3 defines Set Alert Configuration mailbox command,
which configures device's warning alerts.
This patchset adds support for the command.

The implementation is based on the 'ndctl-inject-smart'. Variable and function
names are aligned with the implementation of 'Get Alert Configuration'.

Changes in v3
- Reorganize cover letter and commit message (Davidlohr)
- Update details of the example in man page
- Move 'verbose' option to the end in man page (Davidlohr)
- Link to v2: https://lore.kernel.org/r/20230807063335.5891-1-jehoon.park@samsung.com

Changes in v2
- Rebase on the latest pending branch
- Remove full usage text in the commit message (Vishal)
- Correct texts in document and log_info() (Vishal)
- Change strncmp() to strcmp() for parsing params (Vishal)
- Link to v1: https://lore.kernel.org/r/20230711071019.7151-1-jehoon.park@samsung.com

*** BLURB HERE ***

Jehoon Park (2):
  libcxl: add support for Set Alert Configuration mailbox command
  cxl: add 'set-alert-config' command to cxl tool

 Documentation/cxl/cxl-set-alert-config.txt | 152 ++++++++++++++
 Documentation/cxl/lib/libcxl.txt           |   1 +
 Documentation/cxl/meson.build              |   1 +
 cxl/builtin.h                              |   1 +
 cxl/cxl.c                                  |   1 +
 cxl/lib/libcxl.c                           |  21 ++
 cxl/lib/libcxl.sym                         |  12 ++
 cxl/lib/private.h                          |  12 ++
 cxl/libcxl.h                               |  16 ++
 cxl/memdev.c                               | 220 ++++++++++++++++++++-
 10 files changed, 436 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-set-alert-config.txt


base-commit: 1db7dfb0bd1b14baffc7c6ac44ace9046d98a00d
-- 
2.17.1

