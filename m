Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A67383
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:41:31 +0000 (UTC)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230807063149epoutp04ae2c60682c12a4bad6a194fbcd29243e~5BiloXIAY3161631616epoutp04g
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 06:31:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230807063149epoutp04ae2c60682c12a4bad6a194fbcd29243e~5BiloXIAY3161631616epoutp04g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1691389910;
	bh=JTHPhuIu6eT5cLDRTvpmwVqKdwaUdLKMZeQAgPzUMmI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=jfYJJ1JMPW61aZKUwo7YXKQ90DOEh53f9pk2bSeVZFjWRPTV7yVZMaFasUIcVkJch
	 o1FhlAKkM+Ax7iIrn1oHAalmkbf8jyXQYK2QUxqxnAzRk4qah5hWT/MrW8/2LEPVwO
	 yohOWMd5X7ZZwTzntYhED8vKH7qDvl7ethFALlnA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20230807063149epcas2p2887a108aadbcd1a47ac790f93ebd7f4d~5BilIcCc61820818208epcas2p2V;
	Mon,  7 Aug 2023 06:31:49 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4RK61066Xbz4x9Ps; Mon,  7 Aug
	2023 06:31:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	3B.FE.49913.4DF80D46; Mon,  7 Aug 2023 15:31:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20230807063148epcas2p44093513a86545a3d1b0c3e0900f7ff4b~5BikAKTHy2998429984epcas2p46;
	Mon,  7 Aug 2023 06:31:48 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20230807063148epsmtrp23737d2be457fd741162f100b26561cff~5Bij-SDFP1927519275epsmtrp2x;
	Mon,  7 Aug 2023 06:31:48 +0000 (GMT)
X-AuditID: b6c32a45-5cfff7000000c2f9-92-64d08fd4a569
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	39.82.30535.4DF80D46; Mon,  7 Aug 2023 15:31:48 +0900 (KST)
Received: from jehoon-Precision-7920-Tower.dsn.sec.samsung.com (unknown
	[10.229.83.133]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20230807063148epsmtip1943860c79de0715750b8897e6724b56c~5Bij0Qp1R1458314583epsmtip1C;
	Mon,  7 Aug 2023 06:31:48 +0000 (GMT)
From: Jehoon Park <jehoon.park@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Kyungsan Kim <ks0204.kim@samsung.com>,
	Junhyeok Im <junhyeok.im@samsung.com>, Jehoon Park <jehoon.park@samsung.com>
Subject: [ndctl PATCH v2 0/2] Add support for Set Alert Configuration
 mailbox command
Date: Mon,  7 Aug 2023 15:33:33 +0900
Message-Id: <20230807063335.5891-1-jehoon.park@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7bCmme6V/gspBm13dS3uPr7AZjF96gVG
	ixM3G9ksVt9cw2ix/+lzFosDrxvYLVYtvMZmsfjoDGaLo3s4LM7POsVisfLHH1aLWxOOMTnw
	eLQcecvqsXjPSyaPF5tnMnr0bVnF6DF1dr3H501yAWxR2TYZqYkpqUUKqXnJ+SmZeem2St7B
	8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QCcqKZQl5pQChQISi4uV9O1sivJLS1IVMvKL
	S2yVUgtScgrMC/SKE3OLS/PS9fJSS6wMDQyMTIEKE7IzLj95xlhwT7Ti/PHzzA2MfwW6GDk4
	JARMJO5sDexi5OIQEtjBKLF47n4mCOcTo8T/RcfZIJxvjBI3720DcjjBOl48fgtVtZdR4uCs
	NawQTi+TxLyLZ5hAqtgEtCXub98A1iEiICvRvO4BWAezwGZmiWU7z4ElhAXCJf58ussMcgiL
	gKrE6wNuIGFeAWuJOzs/MkFsk5dYveEAM4R9i13i9CNXCNtF4l/DG0YIW1ji1fEt7BC2lMTn
	d3uhLs2X+HnyFiuEXSDx6csHFgjbWOLdzeesIGuZBTQl1u/ShwSFssSRW2AVzAJ8Eh2H/7JD
	hHklOtqEIBpVJbqOf4BaKi1x+MpRqMM8JL4fOQJmCwnESnTu+M84gVF2FsL8BYyMqxjFUguK
	c9NTi40KDOFRlJyfu4kRnOa0XHcwTn77Qe8QIxMH4yFGCQ5mJRHeeU/OpwjxpiRWVqUW5ccX
	leakFh9iNAUG1kRmKdHkfGCizSuJNzSxNDAxMzM0NzI1MFcS573XOjdFSCA9sSQ1OzW1ILUI
	po+Jg1OqgWma9+btW2J+Pz59tzunXW1u35tZc9KVD+9P/HNBRHy23OX0Xz5cHRsXWZx/s+Zn
	Wm3j7UMLPdn1Q44mz4m1Tt91vGzRUoOli/RKkqy05QJXqRbXcacWli1buvaW26YqN+ljrXqu
	cw5x/zh2TljbzmjNomyJdRvfTOTqWZiqWlewIII1rqxVjV3w7KG5QktZc8XKL63doxLE7G/9
	xODzm5aEvccXFF57OuMEj1zwz/hfE5eeFXi493evvd4f+akvVnJtrWf3/Ol2Yuq6H8nrAh9M
	4liQ7/mccfWUF1M/ba3tumBx6a6xM3tWinxN98+/zzrbdabOfNbccMb7uj2j5uo1BdEisW0C
	gduW7bL4NGuPEktxRqKhFnNRcSIAXqHdsvwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsWy7bCSnO6V/gspBr82c1rcfXyBzWL61AuM
	FiduNrJZrL65htFi/9PnLBYHXjewW6xaeI3NYvHRGcwWR/dwWJyfdYrFYuWPP6wWtyYcY3Lg
	8Wg58pbVY/Gel0weLzbPZPTo27KK0WPq7HqPz5vkAtiiuGxSUnMyy1KL9O0SuDIuP3nGWHBP
	tOL88fPMDYx/BboYOTkkBEwkXjx+y9TFyMUhJLCbUeLV/g0sEAlpiXvNV9ghbGGJ+y1HWCGK
	upkkjt7cCJZgE9CWuL99AxuILSIgK9G87gHYJGaBvcwSHTPPs4IkhAVCJS68Wg00lYODRUBV
	4vUBN5Awr4C1xJ2dH5kgFshLrN5wgHkCI88CRoZVjJKpBcW56bnFhgVGeanlesWJucWleel6
	yfm5mxjB4aeltYNxz6oPeocYmTgYDzFKcDArifDOe3I+RYg3JbGyKrUoP76oNCe1+BCjNAeL
	kjjvt9e9KUIC6YklqdmpqQWpRTBZJg5OqQam46LNEYtOyJv84yrqSQ332HtvO5OGgU5yysY/
	ByKLj117UPuZ5XlS0rXMZ/+rQjYkfWYV/iZperJkyrGCzjDzP5yh6S6XzLlLbu+o97T5v/7U
	kYb/CVtmRL9beVBw66RyrQVr9bobZE45vjzrw6WVdMal40L5Y8bp/AembDSacEvNtXaS0sqC
	j+IOz8wWnA82/Lt45b6cDiOGuz/Vsw5PeNGZsn/jRfa0O9HaNbeu9p3d9bQ+k9G8//Ozb/Vd
	hZIVlYkPTUw25p57ONP4u1zx9Kij8j2hm6SCer1adDUjJpia5J/R4q3eGXE6VqBxqmgJc664
	a9U69+WTf54KkziXl2+iUGjJ9/RsreWvO91KLMUZiYZazEXFiQBRDKskrgIAAA==
X-CMS-MailID: 20230807063148epcas2p44093513a86545a3d1b0c3e0900f7ff4b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807063148epcas2p44093513a86545a3d1b0c3e0900f7ff4b
References: <CGME20230807063148epcas2p44093513a86545a3d1b0c3e0900f7ff4b@epcas2p4.samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

CXL 3.0 Spec 8.2.9.8.3.3 defines Set Alert Configuration mailbox command.
This patchset adds support for the command to configure warning alert.

Example:
# ./cxl set-alert-config mem0 -L 30 --life-used-alert=on
{
  "memdev":"mem0",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "alert_config":{
    "life_used_prog_warn_threshold_valid":true,
    "dev_over_temperature_prog_warn_threshold_valid":false,
    "dev_under_temperature_prog_warn_threshold_valid":false,
    "corrected_volatile_mem_err_prog_warn_threshold_valid":false,
    "corrected_pmem_err_prog_warn_threshold_valid":false,
    "life_used_prog_warn_threshold_writable":true,
    "dev_over_temperature_prog_warn_threshold_writable":true,
    "dev_under_temperature_prog_warn_threshold_writable":true,
    "corrected_volatile_mem_err_prog_warn_threshold_writable":true,
    "corrected_pmem_err_prog_warn_threshold_writable":true,
    "life_used_crit_alert_threshold":75,
    "life_used_prog_warn_threshold":30,
    "dev_over_temperature_crit_alert_threshold":0,
    "dev_under_temperature_crit_alert_threshold":0,
    "dev_over_temperature_prog_warn_threshold":0,
    "dev_under_temperature_prog_warn_threshold":0,
    "corrected_volatile_mem_err_prog_warn_threshold":0,
    "corrected_pmem_err_prog_warn_threshold":0
  },
  "serial":"0",
  "host":"0000:0d:00.0"
}
cxl memdev: cmd_set_alert_config: set alert configuration 1 mem

The implementation is based on the 'ndctl-inject-smart'. Variable and function
names are aligned with the implementation of 'Get Alert Configuration'.

Changes in v2
- Rebase on the latest pending branch
- Remove full usage text in the commit message (Vishal)
- Correct texts in document and log_info() (Vishal)
- Change strncmp() to strcmp() for parsing params (Vishal)
- Link to v1: https://lore.kernel.org/r/20230711071019.7151-1-jehoon.park@samsung.com

Jehoon Park (2):
  libcxl: add support for Set Alert Configuration mailbox command
  cxl: add 'set-alert-config' command to cxl tool

 Documentation/cxl/cxl-set-alert-config.txt |  96 +++++++++
 Documentation/cxl/lib/libcxl.txt           |   1 +
 Documentation/cxl/meson.build              |   1 +
 cxl/builtin.h                              |   1 +
 cxl/cxl.c                                  |   1 +
 cxl/lib/libcxl.c                           |  21 ++
 cxl/lib/libcxl.sym                         |  12 ++
 cxl/lib/private.h                          |  12 ++
 cxl/libcxl.h                               |  16 ++
 cxl/memdev.c                               | 220 ++++++++++++++++++++-
 10 files changed, 380 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-set-alert-config.txt


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.17.1

