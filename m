Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10912B74
	for <nvdimm@lists.linux.dev>; Wed, 14 Feb 2024 08:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707897640; cv=none; b=Ul5VtQJw3ZQJeMs8c+PeV3TsfLZIZ6jsgmmo9VCQ8fnpeDieht7KaJ5l8cPG06tsbdoWxb6a9rX/y5RMG5iDj9Tw2AsFUwk6NO69GhUUGljLQr5IxDQu3CJMG1QUaVOFJtF1RfnTwHBslUEUeXW/5eGUdxnBAIhi0l88C7k6HC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707897640; c=relaxed/simple;
	bh=oDINAaE0smm3+LvLcMaqJ/wSf8GoT3BzCX+Mfp4O+9o=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=CyJ6VrhpTdFd+LH/jlJ/O/rX/iycNI4KbgdVuIeCIpUXpf28ul10MMXLjJhMy6x4iCVBdZO1tXUd1SD/Vi6Gl4bbRqh7CL77MkK2rWZR2pgFT2DPyXcGHWF5SwyVYIDI2yM2aMWeLrPV6odBtt7aJNfYcK47ydBnI00j7mqLdvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=toI5JJ3i; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="toI5JJ3i"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240214080035epoutp03b4ec089245267b7c3ea4936baa5b98cc~zq9m5XElb0722307223epoutp03X
	for <nvdimm@lists.linux.dev>; Wed, 14 Feb 2024 08:00:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240214080035epoutp03b4ec089245267b7c3ea4936baa5b98cc~zq9m5XElb0722307223epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707897635;
	bh=rdLZ7mkl5Cr+euyFfCz4SZVzCXNsGzrRpXdzTtEgpY0=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=toI5JJ3i2pAwnjl+W5w+jn7mHlWs5r3dTRyB7txpWMwluF1ihAB+HM2xVUr9dyf+t
	 2SHCMY1gxdYxOyxWakj89pjnu0DwAPxqoumYeWrSA7HUrpMt7BF5M7ylSAnCYPcYRE
	 Ax1UqnhtGcYNDn3u+e6QmeW4L1+xBZ8t9SbiiszQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240214080034epcas2p35df687aa2e0458cdc8941caf65feca09~zq9mh2tws0219902199epcas2p3-;
	Wed, 14 Feb 2024 08:00:34 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.88]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TZVxG2hrTz4x9Q7; Wed, 14 Feb
	2024 08:00:34 +0000 (GMT)
X-AuditID: b6c32a43-721fd700000021c8-14-65cc7322379e
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D3.97.08648.2237CC56; Wed, 14 Feb 2024 17:00:34 +0900 (KST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Subject: RE: [NDCTL PATCH] ndctl: cxl: Remove dependency for attributes
 derived from IDENTIFY command
Reply-To: wj28.lee@samsung.com
Sender: Wonjae Lee <wj28.lee@samsung.com>
From: Wonjae Lee <wj28.lee@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>, Hojin Nam
	<hj96.nam@samsung.com>, KyungSan Kim <ks0204.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240209213917.2288994-1-dave.jiang@intel.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240214080033epcms2p49e131a0012d95c99591b60f36d4cda35@epcms2p4>
Date: Wed, 14 Feb 2024 17:00:33 +0900
X-CMS-MailID: 20240214080033epcms2p49e131a0012d95c99591b60f36d4cda35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTXFep+Eyqwbv/QhbTp15gtDhxs5HN
	4sObfywWR/dwWJyfdYrFYuWPP6wWtyYcY3Jg91i85yWTx4vNMxk9+rasYvT4vEkugCUq2yYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvp1NUX5pSapCRn5xia1SakFKToF5gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGxS2L
	mAse81f0TN3C1MA4j6eLkZNDQsBEYtfef2xdjFwcQgI7GCXm7LjB2sXIwcErICjxd4cwSI2w
	QLrE0cOzWUBsIQE5ibu3TzFBxDUl3kxbBRZnE1CX+NF5EiwuIqAqcX/9Y7CZzAJrmSQ6Lhxm
	gVjGKzGj/SmULS2xfflWRhCbU8BGovPaDjaIuIbEj2W9zBC2qMTN1W/ZYez3x+YzQtgiEq33
	zkLVCEo8+LkbKi4l8fXEX3aQxRICzYwSq4/1s0I4DYwSHTNhrtCXaLz+Hmwbr4CvxItbm8Am
	sQCdvehPP9RUF4np7/6CbWYWkJfY/nYOMyhUmIFeXr9LH8SUEFCWOHKLBaKCT6Lj8F92mB93
	zHvCBGErSUxpOwJ1m4REQ+NWqB89JFa9uck+gVFxFiKoZyHZNQth1wJG5lWMYqkFxbnpqclG
	BYbw2E3Oz93ECE6MWs47GK/M/6d3iJGJg/EQowQHs5II76UZJ1KFeFMSK6tSi/Lji0pzUosP
	MZoCfTmRWUo0OR+YmvNK4g1NLA1MzMwMzY1MDcyVxHnvtc5NERJITyxJzU5NLUgtgulj4uCU
	amC6+CbTP7e1Oryz6Xq32JqN25Z9fsq74n/yfJOGZykhXGffPV78TuFsIuParq9+XNM++z3v
	3yqfpMqi2C7pVsBuk8bvOIuzcLN0+Tl9h+AJa58lCBpVKdkGLhOeonTjo8ICXnfN8l+CU03f
	VSQrRT3Z8PsSe+cvFpO0LpbPHr/9TV1eWBWtUlF8ft7LWXBKv8yFsHk3Lnn0d8yVyPv2coK6
	EdMFBv2qmI3JRu+kDWzWpRxk3PGj9+PXw12e4U3FPT21YpGPrv4VvLdMJ0m1fMbZt+l3ha3+
	RKo/8omerbdV3O1U/v0jBtYNFx6V11Vb3Gq4NSfrgd50pTe6fuUNGxQX/2m//v7y02CxVZqh
	7UosxRmJhlrMRcWJADmyVJ4VBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240209213933epcas2p389a0083635fb54160d62a3405a19fd73
References: <20240209213917.2288994-1-dave.jiang@intel.com>
	<CGME20240209213933epcas2p389a0083635fb54160d62a3405a19fd73@epcms2p4>

On Fri, Feb 09, 2024 at 02:39:17PM -0700, Dave Jiang wrote:
> A memdev may optionally not host a mailbox and therefore not able to execute
> the IDENTIFY command. Currently the kernel emits empty strings for some of
> the attributes instead of making them invisible in order to keep backward
> compatibility for CXL CLI. Remove dependency of CXL CLI on the existance of
> these attributes and only expose them if they exist. Without the dependency
> the kernel will be able to make the non-existant attributes invisible.
>
> Link: https://lore.kernel.org/all/20230606121534.00003870@Huawei.com/
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/lib/libcxl.c | 48 ++++++++++++++++++++++++++----------------------
>  cxl/memdev.c     | 15 ++++++++++-----
>  2 files changed, 36 insertions(+), 27 deletions(-)
>

[snip]

> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 81f07991da06..feab7ea76e78 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -473,10 +473,13 @@ static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
>   size_t size;
>   int rc;
>
> - if (param.len)
> + if (param.len) {
>       size = param.len;
> - else
> + } else {
>       size = cxl_memdev_get_label_size(memdev);
> +     if (size == ULLONG_MAX)
> +         return -EINVAL;
> + }

Hello,

Doesn't action_write() also need to check the return value of
cxl_memdev_get_label_size() like below?

diff --git a/cxl/memdev.c b/cxl/memdev.c
index feab7ea..de46edc 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -511,6 +511,8 @@ static int action_write(struct cxl_memdev *memdev, struct action_context *actx)

        if (!size) {
                size_t label_size = cxl_memdev_get_label_size(memdev);
+               if (label_size == ULLONG_MAX)
+                       return -EINVAL;

                fseek(actx->f_in, 0L, SEEK_END);
                size = ftell(actx->f_in);

Thanks,
Wonjae
