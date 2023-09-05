Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1438379
	for <nvdimm@lists.linux.dev>; Tue,  5 Sep 2023 06:35:08 +0000 (UTC)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230905062611epoutp027a42b0f3468096a1097cfa9c679dc75f~B7K8CLYav0888608886epoutp024
	for <nvdimm@lists.linux.dev>; Tue,  5 Sep 2023 06:26:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230905062611epoutp027a42b0f3468096a1097cfa9c679dc75f~B7K8CLYav0888608886epoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1693895171;
	bh=/5hrUhRUYLkyoSW8pcoFH8awEue7NyaLlUycgFX8lMo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AloKsvutEwRwB4ozkJC4qIqvHlPsycRptq0IMd+0/VHRmckR2XZlRGg0nS74nreWs
	 fWQdWw0ok4VgmHhP0wgI+tairxKX4F02xZ6AK+11U2ZYulWnAbFPVCmh0YNB9Ux3YM
	 chstjnylyT+fXWkU4hFq7z1Q030hv0prL/q+APno=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230905062610epcas2p2b212f5bf1e3bc14627a52345ec3372bd~B7K7j2bkD0286202862epcas2p2b;
	Tue,  5 Sep 2023 06:26:10 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.90]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4RfwW61Hskz4x9Pp; Tue,  5 Sep
	2023 06:26:10 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	D9.89.09765.10AC6F46; Tue,  5 Sep 2023 15:26:09 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230905062609epcas2p44455a5a18e77d1ee0b8f46c8f6b3af96~B7K6gUDMs1381413814epcas2p4c;
	Tue,  5 Sep 2023 06:26:09 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230905062609epsmtrp1f7472c87e7680ede5256d89d15dc3c4e~B7K6cSIaq0778807788epsmtrp19;
	Tue,  5 Sep 2023 06:26:09 +0000 (GMT)
X-AuditID: b6c32a48-40fff70000002625-f3-64f6ca01216c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C4.7A.08788.10AC6F46; Tue,  5 Sep 2023 15:26:09 +0900 (KST)
Received: from jehoon-Precision-7920-Tower (unknown [10.229.83.133]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230905062609epsmtip18e1d31466abf18cba0818a1170f8ebce~B7K6LxyKE1637116371epsmtip1P;
	Tue,  5 Sep 2023 06:26:09 +0000 (GMT)
Date: Tue, 5 Sep 2023 15:29:18 +0900
From: Jehoon Park <jehoon.park@samsung.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Ira
	Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
	Jiang <dave.jiang@intel.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v2 2/2] cxl: add 'set-alert-config' command to cxl
 tool
Message-ID: <20230905062918.GA8186@jehoon-Precision-7920-Tower>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <v76symilqy5onz6n3y7e47r5xqpaf53nunbb5kz2pcesvjocw7@42o6dotjncu5>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmmS7TqW8pBtdPMVrcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBarFl5js1h8dAazxdE9HBbnZ51isVj54w+rxa0Jx5gcuD1ajrxl
	9Vi85yWTx4vNMxk9+rasYvSYOrve4/MmuQC2qGybjNTElNQihdS85PyUzLx0WyXv4HjneFMz
	A0NdQ0sLcyWFvMTcVFslF58AXbfMHKDrlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkF
	KTkF5gV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGcdbrrAVnJGvmHi0nbGB8YNEFyMnh4SAiUTv
	+0ssXYxcHEICOxglzsydzgbhfGKU6PmynwnC+cYocWnHFWaYloWXHjFDJPYySqxa0APl/GSU
	+DVjIhtIFYuAisSDWcfBbDYBbYn72zeA2SIC6hLz1t5mBGlgFmhilpj55jE7SEJYIFji1M6v
	TCA2r4C9xPzW92wQtqDEyZlPgC7k4OAU8JOYOacKJCwqoCxxYNtxsPMkBBZySNyct5YV4jwX
	iStfe5kgbGGJV8e3sEPYUhIv+9ug7HyJnydvQdUXSHz68oEFwjaWeHfzOVicWSBD4s6Xw+wg
	eyWAlh25xQIR5pPoOPwXKswr0dEmBNGpKtF1/AMjhC0tcfjKUWhgeUgcX9/KCAmfViaJg5Nn
	s09glJ+F5LNZSLZB2DoSC3Z/YpsFtIIZaNbyfxwQpqbE+l36CxhZVzGKpRYU56anFhsVmMBj
	Ozk/dxMjOOVqeexgnP32g94hRiYOxkOMEhzMSiK87+S/pQjxpiRWVqUW5ccXleakFh9iNAXG
	00RmKdHkfGDSzyuJNzSxNDAxMzM0NzI1MFcS573XOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgUlG
	ZVL4wd4d6VpXM0WPOi1ne194fv88DfHAz/GXp37yurQn1fmpQVPG9MOC6ody2RhbXuW9r1l/
	6sGcCm9jweCip9uuPNII9uQX/vZ4LrOj+E6lVQXLZdc9W8RdvFP23uu6V5ris4vLAxgLU7ZU
	mihNeqb4wVjTdJcwt6Qf75+vFdGGt7vmOb3mi5m3qPK/vVfDJ6Ebc6bxiMaf1ltR+P7wPIf+
	hwI/ey1UDxsJuJp/Vs6Oc51zwtH60dcpHR/6I34kPmT+cPob//Hr0UfOVv3NfxTcnyebbnvl
	u+QDKycZi9jZR/4bubOuX2PMU30ya2vqipNOLAH6DZPEy1OfaL7JeLB6//ppon0fa/fLBSix
	FGckGmoxFxUnAgB/j5uSQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWy7bCSnC7jqW8pBq8mS1jcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBarFl5js1h8dAazxdE9HBbnZ51isVj54w+rxa0Jx5gcuD1ajrxl
	9Vi85yWTx4vNMxk9+rasYvSYOrve4/MmuQC2KC6blNSczLLUIn27BK6MvXvfsBb0yFacmvSO
	pYHxpFgXIyeHhICJxMJLj5i7GLk4hAR2M0r8nHqbCSIhLXGv+Qo7hC0scb/lCCtE0XdGiZMf
	D7OBJFgEVCQezDoOZrMJaEvc374BzBYRUJeYt/Y2I0gDs0AHs8TZL9dYQRLCAsESp3Z+BdvA
	K2AvMb/1PRvE1FYmidYnG9khEoISJ2c+YQGxmQW0JG78ewnUwAFkS0ss/8cBYnIK+EnMnFMF
	UiEqoCxxYNtxpgmMgrOQNM9C0jwLoXkBI/MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95Pzc
	TYzgmNHS2sG4Z9UHvUOMTByMhxglOJiVRHjfyX9LEeJNSaysSi3Kjy8qzUktPsQozcGiJM77
	7XVvipBAemJJanZqakFqEUyWiYNTqoEpsfrk5Y8v57iuW2TMndN9/aZH/Vft4CiZcsHtkc3S
	dgcdPu7uvnbwyNJpv5VruwIun9/wteWr8m0p5kv7N4ReWOsoz12Z7z5vo3OW+L1nz31KPgss
	97JkPpV8Z5Wx4f7mZ4s3llhOLn7ZNCGorGMvy02log+M2WUT3z3JZDD817BHJG7+X49m026h
	ovSf19+3bJsxzdbq3uHNnwWCT2+ZtmPfh42F9bUzrRlkOQ/PC2FlV7t23M7NlNv0fQqv7pZj
	03Uehhydz82fPblk5/EZFzfOUL+4MGr9+v8C9++8zDHfsHzlSc3C6wm7Z2SJWHcL/dSbUihQ
	4iSr8WHij/6rM85LXeRp2TvXXKp7UiFvhBJLcUaioRZzUXEiAFSs3zoIAwAA
X-CMS-MailID: 20230905062609epcas2p44455a5a18e77d1ee0b8f46c8f6b3af96
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----8xN_tBFh1JRIvXNae0V60hp8Nl4-igzsNlrgW3zXOpEhlrtA=_5c3e2_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a
References: <20230807063335.5891-1-jehoon.park@samsung.com>
	<CGME20230807063200epcas2p2c573a655c3b35de5aeb7e188430cca9a@epcas2p2.samsung.com>
	<20230807063335.5891-3-jehoon.park@samsung.com>
	<v76symilqy5onz6n3y7e47r5xqpaf53nunbb5kz2pcesvjocw7@42o6dotjncu5>

------8xN_tBFh1JRIvXNae0V60hp8Nl4-igzsNlrgW3zXOpEhlrtA=_5c3e2_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Sat, Sep 02, 2023 at 08:49:58PM -0700, Davidlohr Bueso wrote:
> On Mon, 07 Aug 2023, Jehoon Park wrote:
> 
> > Add a new command: 'set-alert-config', which configures device's warning alert.
> 
> The example in the cover-letter should be here and also mention explicitly that
> the get counterpart is via cxl-list -A, like you have in the manpage.
> 

Thank you for comments.

I will reorganize and update cover letter and commit message for clear
explanation about the patchset.

> > 
> > Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> > ---
> > Documentation/cxl/cxl-set-alert-config.txt |  96 +++++++++
> > Documentation/cxl/meson.build              |   1 +
> > cxl/builtin.h                              |   1 +
> > cxl/cxl.c                                  |   1 +
> > cxl/memdev.c                               | 220 ++++++++++++++++++++-
> > 5 files changed, 318 insertions(+), 1 deletion(-)
> > create mode 100644 Documentation/cxl/cxl-set-alert-config.txt
> > 
> > diff --git a/Documentation/cxl/cxl-set-alert-config.txt b/Documentation/cxl/cxl-set-alert-config.txt
> > new file mode 100644
> > index 0000000..c905f7c
> > --- /dev/null
> > +++ b/Documentation/cxl/cxl-set-alert-config.txt
> > @@ -0,0 +1,96 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +cxl-set-alert-config(1)
> > +=======================
> > +
> > +NAME
> > +----
> > +cxl-set-alert-config - set the warning alert threshold on a CXL memdev
> > +
> > +SYNOPSIS
> > +--------
> > +[verse]
> > +'cxl set-alert-config <mem0> [<mem1>..<memN>] [<options>]'
> > +
> > +DESCRIPTION
> > +-----------
> > +CXL device raises an alert when its health status is changed. Critical alert
> > +shall automatically be configured by the device after a device reset.
> > +If supported, programmable warning thresholds also be initialized to vendor
> > +recommended defaults, then could be configured by the user.
> > +
> > +Use this command to configure warning alert thresholds of a device.
> > +Having issued this command, the newly requested warning thresholds would
> > +override the previously programmed warning thresholds.
> > +
> > +To enable warning alert, set both 'threshold=value' and 'alert=on'. To disable
> > +warning alert, set only 'alert=off'. Other cases would cause errors.
> 
> So what's the point of having to use double parameter to enable the warning?
> Just do alert=threshold if you've established that threshold=N and alert=off is
> not valid.
> 

IMHO, using two separate parameters would be better because it would be safer
by protecting a misuse out of an user. I think it is important to clearly
interpret user's intention.
Also, CXL spec (8.2.9.8.3.3) defines two payload fields, threshold and
enablement, separetely.
Please also remind that the 'ndctl-inject-smart' command already uses two
parameters, threshold and alarm, to set smart threshold.

> > +
> > +Use "cxl list -m <memdev> -A" to examine the programming warning threshold
> > +capabilities of a device.
> > +
> > +EXAMPLES
> > +--------
> > +Set warning threshold to 30 and enable alert for life used.
> > +[verse]
> > +cxl set-alert-config mem0 -L 30 --life-used-alert=on
> > +
> > +Disable warning alert for device over temperature.
> > +[verse]
> > +cxl set-alert-config mem0 --over-temperature-alert=off
> > +
> > +OPTIONS
> > +-------
> > +<memory device(s)>::
> > +include::memdev-option.txt[]
> > +
> > +-v::
> > +--verbose=::
> > +        Turn on verbose debug messages in the library (if libcxl was built with
> > +        logging and debug enabled).
> 
> Should be at the end.
> 

Agree

> 
> Thanks,
> Davidlohr

Sincerely,
Jehoon

------8xN_tBFh1JRIvXNae0V60hp8Nl4-igzsNlrgW3zXOpEhlrtA=_5c3e2_
Content-Type: text/plain; charset="utf-8"


------8xN_tBFh1JRIvXNae0V60hp8Nl4-igzsNlrgW3zXOpEhlrtA=_5c3e2_--
