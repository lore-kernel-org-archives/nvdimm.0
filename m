Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3540F366
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:21:06 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230810082058epoutp030e28229c0e7066ee5013a883ccf4c6ad~599vkwZgH2705227052epoutp030
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 08:20:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230810082058epoutp030e28229c0e7066ee5013a883ccf4c6ad~599vkwZgH2705227052epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691655658;
	bh=xp2ctU3LATvEECGm3E99V2MxIbsowTR2mDAPpnOdeMI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=gqdQH+FqHeG/EG1H8+FIPR2vNh7AjRszJ4ZmHV/wYswOOKs3ST+P6ofb9Mk6QCfxJ
	 d25RVyJi/FeVEOBPfAVa69yLFwvH/lHM2X98twXYHci4B3upSrWopcoUKMoA1ZaInA
	 c+6XIq0gGvCAbExH3SCf4uZnibmBXu5RT/1RxPEQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20230810082058epcas2p4100c51a4314f0d23f3e59a73d0429e53~599u0i9h_3168031680epcas2p4L;
	Thu, 10 Aug 2023 08:20:58 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4RM0HY529jz4x9Px; Thu, 10 Aug
	2023 08:20:57 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	CA.1D.32606.9ED94D46; Thu, 10 Aug 2023 17:20:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20230810082057epcas2p2978eb4ca2b1665b99fa5f84518d1b5c7~599uA0hvM1370213702epcas2p2U;
	Thu, 10 Aug 2023 08:20:57 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230810082057epsmtrp2918da32ede2bc5e9cf8557cc3aee3ec4~599t-_zxH3011630116epsmtrp2R;
	Thu, 10 Aug 2023 08:20:57 +0000 (GMT)
X-AuditID: b6c32a47-c2bfa70000007f5e-98-64d49de95197
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	25.90.30535.9ED94D46; Thu, 10 Aug 2023 17:20:57 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230810082056epsmtip10b591ae9a6c0884a0f35f0bb7a345cf9~599typVoO1945319453epsmtip1F;
	Thu, 10 Aug 2023 08:20:56 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v3 0/3] Fix accessors for negative fields and error
 checking for health info
Date: Thu, 10 Aug 2023 17:23:51 +0900
Message-Id: <20230810082354.5992-1-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmme7LuVdSDE7eVrK4+/gCm8X0qRcY
	LU7cbGSzWH1zDaPF/qfPWSwOvG5gt1i18BqbxeKjM5gtju7hsDg/6xSLxcoff1gtbk04xuTA
	49Fy5C2rx+I9L5k8XmyeyejRt2UVo8fU2fUenzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2opFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOeLYhoeAOf8XE+deYGxg/8nQxcnJI
	CJhIzNk/h6mLkYtDSGAHo8Sc87dZIJxPjBLrV9xhg3C+MUpM/vycEabl6IcmVojEXkaJzw8W
	M0M4vUwSv5bfYwapYhPQlri/fQMbiC0iICvRvO4B2BJmgc3MEst2ngNLCAukSPTvuQo2lkVA
	VeLt/ztgNq+AtcTbx3tYINbJS6zecABsg4TANXaJh7fXMUEkXCRWXvjPBmELS7w6voUdwpaS
	+PxuL1Q8X+LnyVusEHaBxKcvH6CGGku8u/kcKM4BdJGmxPpd+iCmhICyxJFbYBXMAnwSHYf/
	skOEeSU62oQgGlUluo5/gAaEtMThK0eZIWwPiQmTNoHFhQRiJZbPPcY6gVF2FsL8BYyMqxjF
	UguKc9NTi40KjOGRlJyfu4kRnOq03Hcwznj7Qe8QIxMH4yFGCQ5mJRFe2+BLKUK8KYmVValF
	+fFFpTmpxYcYTYHBNZFZSjQ5H5hs80riDU0sDUzMzAzNjUwNzJXEee+1zk0REkhPLEnNTk0t
	SC2C6WPi4JRqYAot37+5Re3wLY558+ZNyd6xdMr+BUk8b/N/5Lcs6fq1prXfd27xgggFQ1Xe
	1cufaUTacazc9+Fn9j3zh/5nPawzDbbVP34ld+sO4y+hlZ+/x/E6lk94mrlDeffPvM0bXM77
	6N4T21H0Z/sj/ow0/hYtgQN+5TzbHavbHivvm88yy2bL+2D2rh8Je0/NVVluU8YuGqfE2CcT
	NfdoT0F9TOaP835fmSewfuK1e/uw+uF3N8XWlQsXnQzUX+R3esHCI8u9/xUv4M/bpC3Q3Duj
	QOI7o+4VuS0BX5OOn89kmn7/rf3h8p5JHiG27ypi71b/czad9v1djZ1ITe0ZzyaeFftmbHmr
	eIl7mk3ge+PtPLVKLMUZiYZazEXFiQD4La02/gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsWy7bCSnO7LuVdSDDobWSzuPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxRXDYpqTmZZalF+nYJXBnPNiQU3OGv
	mDj/GnMD40eeLkZODgkBE4mjH5pYuxi5OIQEdjNKfNw9iR0iIS1xr/kKlC0scb/lCFRRN5PE
	7u2XWUASbALaEve3b2ADsUUEZCWa1z1gAiliFtjLLNEx8zwrSEJYIEliwulnYA0sAqoSb//f
	YQSxeQWsJd4+3sMCsUFeYvWGA8wTGHkWMDKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P
	3cQIDj8trR2Me1Z90DvEyMTBeIhRgoNZSYTXNvhSihBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
	b697U4QE0hNLUrNTUwtSi2CyTBycUg1MUw8UPdZOlHm1ct7t3+qWm/nMv7zgbIncdLxNk/f7
	R2MN/2Kr8zt9eJcX7Thze86W9O9CDee3fF/GNmF/zTHTj33zj0nEn1i54cbc1ti6nY51Rh0i
	xyNfemyuT0jsSpJ+ddpkyguna9NXO2hFrTy+6OVM3YD79WdsniZf/7CDz0d4i63lj7sOB/03
	VIT6GU8Vlv13y7R/gvrl6TV3zAInWh664ryo0OdWlU/GrWWb5z36Y/XBbn0tj3FRsZ9tv46W
	fVvKu6q/BZIH1cpX3s0WWtJRpuCkLT1BKXZLdE7Ivl3VHnyT0871HnGtKZ2Ye2Jm6d7AyCfJ
	h18Y/2CzbxN6ZL7wS/GR3m9dC9ssJbY6KrEUZyQaajEXFScCAA55R/uuAgAA
X-CMS-MailID: 20230810082057epcas2p2978eb4ca2b1665b99fa5f84518d1b5c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230810082057epcas2p2978eb4ca2b1665b99fa5f84518d1b5c7
References: <CGME20230810082057epcas2p2978eb4ca2b1665b99fa5f84518d1b5c7@epcas2p2.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

In CXL 3.0 SPEC, 8.2.9.8.3.1 and 8.2.9.8.3.2 define temperature fields
as a 2's complement value. However, they are retrieved by the same accessor
for unsigned value. This causes inaccuracy when the value is negative.

The first patch updates the pre-defined value for device temperature field of
the Get Health Info command when it is not implemented. (CXL 2.0 Errata F38)

The second patch fixes accessors for temperature fields.
Add a new payload accessor for a signed value, then use it for retrieving
temperature properly. INT_MAX is used to indicate errors because negative
errno codes are not distinguishable from the retrieved values when they are
negative. Caller should check errno to know what kind of error occurs.

The third patch fixes the error checking logic when listing device's health
info.

Changes in v3:
- Correct the revision history in the patch description (Jonathan)
- Add review tag (Jonathan)
- Revert unrelated change (Jonathan)
- Move caller side change to proper patch (Jonathan)
- Link to v2: https://lore.kernel.org/r/20230807063549.5942-1-jehoon.park@samsung.com/

Changes in v2:
- Rebase on the latest pending branch
- Remove dbg() messages in libcxl accessors (Vishal)
- Make signed value accessors to return INT_MAX when error occurs and set
  errno as proper errno codes (Vishal)
- Use proper value for checking "life_used" and "device_temperature" fields
  are implemented
- Link to v1: https://lore.kernel.org/r/20230717062908.8292-1-jehoon.park@samsung.com/

Jehoon Park (3):
  libcxl: Update a outdated value to the latest revision
  libcxl: Fix accessors for temperature field to support negative value
  cxl/json.c: Fix the error checking logic when listing device's health
    info

 cxl/json.c        |  9 +++++----
 cxl/lib/libcxl.c  | 30 +++++++++++++++++++++---------
 cxl/lib/private.h |  2 +-
 3 files changed, 27 insertions(+), 14 deletions(-)


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.17.1

