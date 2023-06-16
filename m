Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2BF626
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:12:15 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230616010600epoutp043114f78e07e65d0fbe9e79453240c53e~o-jQkPnch1701317013epoutp049
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 01:06:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230616010600epoutp043114f78e07e65d0fbe9e79453240c53e~o-jQkPnch1701317013epoutp049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1686877560;
	bh=Vluc5O31z9uEg/cSfcO53ySdSDB70aPsypobdq8/KUg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=HXyE1EcpKoHdFPBfKAqvIc4lyUQl6Yl2Vxa5+j9o3lQKCmwpAhDlybiJpEViAcZYM
	 8uhji4ogaLy8Gjykd1jm9nX3ildmHNQDcybFsgLlzSk1lPRfvLB+WLnhcGq7tVVA0/
	 8zw53wb0Zv6wynYNLWDYW3m5mQXBbtsWzddYFsBE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20230616010559epcas2p4268e5be53846d6bacac9b715108da6ad~o-jP-_wpq1021910219epcas2p4k;
	Fri, 16 Jun 2023 01:05:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.90]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Qj1F31gWWz4x9Q0; Fri, 16 Jun
	2023 01:05:59 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.7E.07392.775BB846; Fri, 16 Jun 2023 10:05:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20230616010558epcas2p3db2367f3eef4f2e959175276b6f891b6~o-jPQs95j0389903899epcas2p3k;
	Fri, 16 Jun 2023 01:05:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230616010558epsmtrp18d3b1909c12746a57c96221a06691674~o-jPQAD8Q2899128991epsmtrp1A;
	Fri, 16 Jun 2023 01:05:58 +0000 (GMT)
X-AuditID: b6c32a47-157fd70000001ce0-6b-648bb577ae9a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	55.23.27706.675BB846; Fri, 16 Jun 2023 10:05:58 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230616010558epsmtip159786a560383b6a49631513d6aced2bc~o-jPCiSRu1888618886epsmtip1d;
	Fri, 16 Jun 2023 01:05:58 +0000 (GMT)
From: Jehoon PARK <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH 0/2] Fix accessors for temperature field when it is
 negative
Date: Fri, 16 Jun 2023 10:08:39 +0900
Message-Id: <20230616010841.3632-1-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsWy7bCmhW751u4Ug/YWLou7jy+wWTRPXsxo
	MX3qBUaLEzcb2Sz2P33OYnHgdQO7xflZp1gsVv74w2pxa8IxJgdOj8V7XjJ5bFrVyebxYvNM
	Ro++LasYPT5vkgtgjcq2yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVV
	cvEJ0HXLzAE6SEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYF6gV5yYW1yal66X
	l1piZWhgYGQKVJiQnTHvwi+Wgh7OisNfe1gbGLewdzFycEgImEgc+5nWxcjFISSwg1Fi15yL
	7BDOJ0aJ9XeWMEE43xglFj1fxtLFyAnW8XnXVWaIxF5GiWcrX0K19DJJ/PjwiBWkik1AW6K9
	7y0jiC0iICvRvO4B2ChmgQ1MEisWHmMGSQgLhEhsbesAa2ARUJVY17WWDcTmFbCW6P36jhli
	nbzE6g0HwNZJCOxjl9h47A4bRMJF4tqjGVC2sMSr4yAfgdhSEi/726DsfImfJ2+xQtgFEp++
	fID6wVji3c3nrKAQYBbQlFi/Sx8SGMoSR26BVTAL8El0HP4LDSNeiY42IYhGVYmu4x8YIWxp
	icNXjkJd6SFxZmUHWFxIIFbiSF8T0wRG2VkI8xcwMq5iFEstKM5NTy02KjCGR1Jyfu4mRnAa
	03LfwTjj7Qe9Q4xMHIyHGCU4mJVEeJed6EoR4k1JrKxKLcqPLyrNSS0+xGgKDK6JzFKiyfnA
	RJpXEm9oYmlgYmZmaG5kamCuJM4rbXsyWUggPbEkNTs1tSC1CKaPiYNTqoFJi81MZf0qbu5X
	LfyvHXaZyyydovPnS1ttqouU+Bw/g1lfF5pZp+X07F/rxJtVPFvkpROHguz3JMsnMt+7FrYm
	X1Vct5Sj59YzhX/Cy7yuMm9iU2fMflX52F6Bt+Xmz49fKiLWJ18y+iSxZvPBM+VvM7N+8Jq8
	PS8RJsvpWfImWCPHK43RLe1aypV1ujz1cjebspnzTb6V8nFNvMBVL5Erb7o+pS7niz+z9+LE
	9RXGHEXzug87eB9KPDjtgaShTdyzDSeffWYQXWStl3WrKqRMby7DVOM7R3eqcH9KdZtd/GeR
	xfQr6h/7tv2ffWM/yyW+a+ULw9Yos0Xu7BUsn1HX/HmdR/oa18Au87cfliqxFGckGmoxFxUn
	AgCszhsb7AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42LZdlhJTrdsa3eKwZa1JhZ3H19gs2ievJjR
	YvrUC4wWJ242slnsf/qcxeLA6wZ2i/OzTrFYrPzxh9Xi1oRjTA6cHov3vGTy2LSqk83jxeaZ
	jB59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVMe/CL5aCHs6Kw197WBsYt7B3MXJySAiYSHze
	dZW5i5GLQ0hgN6PEu79/mSES0hL3mq9AFQlL3G85wgpiCwl0M0lM/qIGYrMJaEu0971lBLFF
	BGQlmtc9YAIZxCywg0ni4JZeJpCEsECQxM85+8CGsgioSqzrWssGYvMKWEv0fn0HtUxeYvWG
	A8wTGHkWMDKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDi0tzR2M21d90DvEyMTB
	eIhRgoNZSYR32YmuFCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFk
	mTg4pRqY2mc9jXn64M7sSyd0Dk+eveU4/zcZTS/+yHPtB/aoHrz1assTgYslpmdlN7UaXJ6+
	z2mjfzj7CrUWk97ZGpOtV3R+c9Nz/WT28caaKFWvQ+7caypr9B7zyrotY/9udlxmm5rc4fNc
	wtaH5iiqvmN98sJw5dZvAcYKGWwi69JLi6b/5ZLl53Z/s/DnQpXUreXvjq7kfnXe5Tzbuelt
	j38fr7QoLJ+6zWCeMf/18q4+T+OOa+IdSseTboTt1/bzXpW/rfSfUUfvj0PtTHEZXeZlR/nW
	vdOvndnBIbImVnvCYh73+XNjLyx0Vd2mzuqwYuE799Tg28sPfpZ0VzFnnOwXYNQrvGNCzoro
	rV06IlkTlFiKMxINtZiLihMB8+s93pwCAAA=
X-CMS-MailID: 20230616010558epcas2p3db2367f3eef4f2e959175276b6f891b6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230616010558epcas2p3db2367f3eef4f2e959175276b6f891b6
References: <CGME20230616010558epcas2p3db2367f3eef4f2e959175276b6f891b6@epcas2p3.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

From: Jehoon Park <jehoon.park@samsung.com>

In CXL 3.0 SPEC, 8.2.9.8.3.1 and 8.2.9.8.3.2 define temperature fields
as a 2's complement value. However, they are retrieved by the same accessor
for unsigned value. This causes inaccuracy when the value is negative.

The first patch updates the pre-defined value for temperature field of
the Get Health Info command when it is not implemented by complying
CXL 3.0 specification. (CXL 3.0 8.2.9.8.3.1)

The second patch fixes accessors for temperature fields.
Add a new payload accessor for a signed value, then use it for retrieving
temperature properly. Remove negative error numbers since they are not
distinguishable from the retrieved value because it could be negative.
They are replaced by debug message.

Jehoon Park (2):
  cxl: Update a revision by CXL 3.0 specification
  libcxl: Fix accessors for temperature field to support negative value

 cxl/json.c        |  2 +-
 cxl/lib/libcxl.c  | 36 ++++++++++++++++++++++++++----------
 cxl/lib/private.h |  2 +-
 3 files changed, 28 insertions(+), 12 deletions(-)


base-commit: 7f75ce36ce3a0d41ed74d4e2dfcfd41a6fd7fe40
-- 
2.17.1

