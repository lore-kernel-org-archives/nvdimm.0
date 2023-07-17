Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC9A7468
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 06:26:28 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230717062621epoutp03ee985381eb652e8c0a588f6e2f49c5f7~yk6zyXGcA0705207052epoutp03w
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 06:26:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230717062621epoutp03ee985381eb652e8c0a588f6e2f49c5f7~yk6zyXGcA0705207052epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1689575181;
	bh=343GDxI0wcEZOH17UW8PWp8JHqa5QWX542+Vz5JNrXU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=g3UOpjBYxD6ouDJyIvTX7CxsbBRNCeTfO/hLoZzBEjAbNjgZ+VLS/wsv9E+S06ll9
	 smQepWHX7Ilwm3yWAeqePGMb3AayH1zd914wVTfo0xkNIdAepkZno4V3lcbDcr86+7
	 xh/cCnPQFYzaVyXKU0i+fYRFxqxRH6ZiX/ksg018=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20230717062618epcas2p434a1ec31dff746e9bfa28f45269f457f~yk6w3kLs33214932149epcas2p43;
	Mon, 17 Jul 2023 06:26:18 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.91]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4R4BtK3HwSz4x9Q2; Mon, 17 Jul
	2023 06:26:17 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	54.DF.32393.90FD4B46; Mon, 17 Jul 2023 15:26:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230717062617epcas2p46229ab9feac5a094afd44761e2b9a403~yk6v6wDzJ3214932149epcas2p40;
	Mon, 17 Jul 2023 06:26:17 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230717062617epsmtrp267759406cd3c9b63ad904cbca367f171~yk6v5ujVX0833708337epsmtrp2Z;
	Mon, 17 Jul 2023 06:26:17 +0000 (GMT)
X-AuditID: b6c32a48-adffa70000007e89-9c-64b4df0976a5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.85.64355.80FD4B46; Mon, 17 Jul 2023 15:26:16 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230717062616epsmtip293c57187f77f7e828c0e792911165408~yk6vtBs9X1407514075epsmtip2e;
	Mon, 17 Jul 2023 06:26:16 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH RESEND 0/2] Fix accessors for temperature field when
 it is negative
Date: Mon, 17 Jul 2023 15:29:06 +0900
Message-Id: <20230717062908.8292-1-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsWy7bCmuS7n/S0pBrvuSljcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiism0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgE5UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
	l9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnfN76iL3gLkfFrVU1DYw97F2MHBwS
	AiYSn15KdzFycQgJ7GCUeDLzPyuE84lR4tOMTWxwzob+k8xdjJxgHVPPf4eq2skocevhBCin
	l0li0qOrLCBVbALaEve3b2ADsUUEZCWa1z1gAiliFtjMLLFs5zmwhLBAtET35mZGEJtFQFWi
	b+9HsGZeAWuJQwefM0Ksk5dYveEAM0izhMA5domFB+ewQCRcJBZ/OM0OYQtLvDq+BcqWkvj8
	bi8bhJ0v8fPkLVYIu0Di05cPUL3GEu9uPmcFhQCzgKbE+l36kMBQljhyC6yCWYBPouPwX2gY
	8Up0tAlBNKpKdB3/AHWZtMThK0ehgeIh8ftkM9hSIYFYidbnW1kmMMrOQpi/gJFxFaNYakFx
	bnpqsVGBCTyOkvNzNzGCE52Wxw7G2W8/6B1iZOJgPMQowcGsJML7fdWmFCHelMTKqtSi/Pii
	0pzU4kOMpsDgmsgsJZqcD0y1eSXxhiaWBiZmZobmRqYG5krivPda56YICaQnlqRmp6YWpBbB
	9DFxcEo1MLX+Vtxx72PgdpGyNSVir5bplrrJvwivN7Jcu6dkP8/kyauPcB9aKNbUJWiXv6tk
	+lf1hM26lqwKj07IO3x/dTP/UeP88DixbNcszqjQlR22fTnMUivf+x6/npSerRZ45PQJkS0y
	GyuzN1f6bJh9O2pz9w8uR4mAivBFh1IP1xamVaQdWXp7g/Sf7Ss1LqaHyK3Nst3pXBn1PuvA
	+vA/mXpTmHR04qwjtPJfRDSyN2nuulLqf/zzh+g/2Y0Ly4QCJyhtC6zqsj34x+vnm22Z/0XZ
	GXsaPJoC75+oOGX7+kp4zenzGXs3577SXT277uy5prbQl8VuXB9eNvmZnsmSm8v5pr/1SJKl
	lmzdqw4GJZbijERDLeai4kQAVVpGF/0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsWy7bCSvC7n/S0pBu/5Le4+vsBmMX3qBUaL
	Ezcb2SxW31zDaLH/6XMWiwOvG9gtVi28xmax+OgMZoujezgszs86xWKx8scfVotbE44xOfB4
	tBx5y+qxeM9LJo8Xm2cyevRtWcXoMXV2vcfnTXIBbFFcNimpOZllqUX6dglcGZ+3PmIvuMtR
	cWtVTQNjD3sXIyeHhICJxNTz31m7GLk4hAS2M0qs3bKDDSIhLXGv+QpUkbDE/ZYjUEXdTBJv
	LnwAK2IT0Ja4v30DmC0iICvRvO4BE0gRs8BeZomOmedZQRLCApESl7ZcAbNZBFQl+vZ+ZAGx
	eQWsJQ4dfM4IsUFeYvWGA8wTGHkWMDKsYhRNLSjOTc9NLjDUK07MLS7NS9dLzs/dxAgOOq2g
	HYzL1v/VO8TIxMF4iFGCg1lJhPf7qk0pQrwpiZVVqUX58UWlOanFhxilOViUxHmVczpThATS
	E0tSs1NTC1KLYLJMHJxSDUxKbVMz01+e/L9pzYU/2letH2Xyh119XpHOtVCkTCB1yUbNKbzp
	YSvk5A317EVL8xV28txP7fjrFx0X/uqqiNKi4u3XUj4xRHM19Iu+vPAph21xrrQU6yzD2oCF
	56Xuhj6SOBLlpjafpT383INki857tyf+3mv4JOaVqdMhOVbthm2LFfw+MqTV/JzdWFbXcPel
	SPv+H7dSJj1W9jh+JSlSZRKj5Iz4/XXnNY+yvNmn76Hn9jxWLi096b51T10al9W2Fdtvu90U
	eXzeTrhOzurHo+p520/WXp5jb3cvmmfvlKysmrcb//+YlftvTojJNoP/tqI/J5UU/ynNbyjS
	vKFQE7JkkYvv9IM2ER9eOyqxFGckGmoxFxUnAgB1HFPhqQIAAA==
X-CMS-MailID: 20230717062617epcas2p46229ab9feac5a094afd44761e2b9a403
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230717062617epcas2p46229ab9feac5a094afd44761e2b9a403
References: <CGME20230717062617epcas2p46229ab9feac5a094afd44761e2b9a403@epcas2p4.samsung.com>
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

