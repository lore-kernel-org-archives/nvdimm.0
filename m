Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE3D2472AE
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 23:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783638198; cv=none; b=VL95DDL8HkL/b59SVRPXU+7SzMjiFTXxBuxHROQnjw4VC3Z6/o/Us4cqYeY48Gqy0VUDaKUDy9mbkPqXaH/VeEfoG7iEZ3uq9J5/QcEKNkTkupUWfS9+XWxbNOcQSeypAnf3GUEYHQs3p0QLlwWRETt8iF+I0IaUXWR7MjFcwXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783638198; c=relaxed/simple;
	bh=melRTksghF/8erkwu8aA44NkTQUG9wGQoKKZ0OKUX3U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IyUMa5LanAD5TAe5XehQ13lBy3Q0lOD9OyMUcNxnFvkm3p2U3N+nT6qvkjBiqvfXzzr0HNo+ubqOq3JUG8QlBbzOHI1prVOnH9NCOCKG33kCTpxyHP1rOe8Ksv9Kihahq7ULzdw6YukMJWJaQgrtNfXRVobh8yI+TgtG/kuLk6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ltKsbNyQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UwJf3Qbd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ltKsbNyQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UwJf3Qbd"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 669HXJ1i2421539
	for <nvdimm@lists.linux.dev>; Thu, 9 Jul 2026 23:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8eMfGOVP+cMvuKNjFhD4tj0PMF3X3yfxdgpmYgvAa2M=; b=ltKsbNyQOCAARRgy
	KIHpqBIbr/tAoMrCDnUeRgsb9dOZ/1Vj9K6Lelj1CL5ykmPBZrm3PaSCNuCakj6D
	GH1EO7I7U7n924RtkDKPSE7QUL/n4BQA/U7dmaNDceNC+AFcAVgN5EvC1jHhpWtb
	RkMkWRlJGtpeasWNLwWdSjKjp6ust6loj10uyP7Fm4D0jkeMKkpur2Dhfs2fJqbY
	t+drpnmSTFtTN4Zj2Pqe60622lc4N2ehkP76zk7q7lCKrFsZNCErk9CwPunBdP90
	Me7v6ZKm+1ZOku85vSre04FPBxexJmGb4DuC+mJ7ZrKqekvbKC76fOzBFgOthbzQ
	NFE+OA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fadvja03c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 23:03:15 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84870e7f498so265986b3a.3
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 16:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783638194; x=1784242994; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8eMfGOVP+cMvuKNjFhD4tj0PMF3X3yfxdgpmYgvAa2M=;
        b=UwJf3QbdUatbSM7nLkv0CtWNSo1cUWIYRn7BAz+XUjCjmITPCeKmQlPQ4GXF8KMP/w
         /RZMx/Hr4rp5gvEFp8D+kJjQtu58HiuFdCYcIo12lzXvmFpB2Vpv4zWd175/9Vjqb5j7
         XiNH4mPwP55zgVIA7KfRqynsUCGWLdmpGgxgP0ryF/EtHqMgx0T81UfxuZEXtzPTwMNS
         dR0PGP2VrkB/ijvncSVFS1PwdN6UpEbVmTDMv2nSvu1hjlHrdNbtTJkEvecZIPd53WSC
         9xdn4Vd/P24RyXw7OqaVoJNmfs1s7eXu0clgFYxJNKG05K0uh7XkBkEBRC9uplKU8bL7
         KcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783638194; x=1784242994;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8eMfGOVP+cMvuKNjFhD4tj0PMF3X3yfxdgpmYgvAa2M=;
        b=XmTr5HTOEhDmrH5QgLYVDEdwYR+d5Zd8NFY/vurGyVPkVTZmF2AsF6ZBOS8AUTZN27
         gjgQ1pYfSgtbfu3Ug4J+eSEBnxWSsPT/BA9kWBG3PMTDAUyG8WDcoF7hLbVtKpHXKNhq
         6L7CxP7KAIDwYJVm/1KJXtlO/dqhFxsNGHwDitVj+gqQLpZOyESFb1rvsOMGBbw4pylo
         FBRk6FUpjWEvH4LApeHY6UEo/Pdp6JJyqQ0yCTQ855AK2nn3H02GCUdeJKFat3qYUC6M
         Tvxsu+0ol2lXEYVBff84VNJYFqZ2zlSlmRCjYllnK5BfyOg/30ZnN3/0ufHZ5PbB/pxF
         mL6A==
X-Forwarded-Encrypted: i=1; AHgh+Rob6owQmdRPZV7qZB5bf1rLQSDvejuDwjQkwJSXMe3jeQP4Dz/Rr31ErpPCbc/XNKGLRzUWryA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4lqWAiC3rBKBxn1efxyOor4fQ94PI4Vb+hMB0X/ehXFeyDTAi
	VtyNz7C9L2GftIAN2cUe+ejAR5+9UcLeAVuWSaZu2GWVdMYwNBCkUg8AchJfio0r6vGiMuQm+q9
	8wdoU4HnhJUOGx+dW6IO2mVtf4cfQNHxXb4lzYkaFNic63F0qnb0aObB1SCc=
X-Gm-Gg: AfdE7cmEKesjlNQzctFNygQJkWtmF3F4Wp2lrWsGxXF6gKZvgxaWH2TqmLGgrMreFAT
	mYO/h52ODfkgp/HHUuMMLtdPQ50KdArVTBq4cg8kdlwpf7f5LGK+XRQ0EG+2ezydD8fwHCcbEGR
	5xQ8hufztR/QNXjqu4N5PHrJPEcLyR+nGVTW1WvjX4ytyGWYdEiadUQHnXRObu+wit8hTyfIuwm
	TXcvj80VCo3UOtqb0oRYGn63V8A2xn4br2zE3IE7CMvdOfUHNAOMOnr0E8UEECPMIspKXqz8r44
	Lnn2r+/nOg4iQn8jdfrKpnmyv0sLFW1/iIa5JPEBkAltIikxCVrNjtuHA/0dNqW+CjKjU4ocLHj
	mwjxaFK04uaa/b1eWeQWVlQ==
X-Received: by 2002:a05:6a20:7288:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3c0bd0fa250mr10349735637.46.1783638194407;
        Thu, 09 Jul 2026 16:03:14 -0700 (PDT)
X-Received: by 2002:a05:6a20:7288:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3c0bd0fa250mr10349694637.46.1783638193944;
        Thu, 09 Jul 2026 16:03:13 -0700 (PDT)
Received: from localhost ([50.35.46.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174892711sm35958607eec.13.2026.07.09.16.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 16:03:13 -0700 (PDT)
Date: Thu, 9 Jul 2026 16:03:03 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: alison.schofield@intel.com, dave.jiang@intel.com, jic23@kernel.org,
        nvdimm@lists.linux.dev, guoren@kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 2/2] daxctl, util/sysfs: skip module
 probe-insert when driver is builtin or live
Message-ID: <20260709160303.000031bc@oss.qualcomm.com>
In-Reply-To: <20260618090653.8983-3-cp0613@linux.alibaba.com>
References: <20260618090653.8983-1-cp0613@linux.alibaba.com>
	<20260618090653.8983-3-cp0613@linux.alibaba.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDIzMCBTYWx0ZWRfX8HFXmAdWN+RG
 bkTdT+TsrOuzL/uu7nOMb81Ffm1nzamf2Jib84ifcIdoIc48aAI/Ap2Mx5Ud/DJJ0U5gNns9BAE
 69sPp0v8nl/nLLhWL3uc/SkntP/tEQJZvkRZPOgfq/qB6izVdGZV9w8OjdDsvPfS4KNUCz2f3U/
 Cn0V42IZKYwllb8suL4kDQJ418BQb9G6s1XSHSlurGGEvw4r8wfT0sYCJID+ULqWW5e0NYHETOE
 fEYFrngtZ/VFB0MsBfUaUm1BchyBOQuuqmKMWSg6iklLG43Fpz4QmmHKl8wE1L1UBjBpzaBKqqk
 KFPMPvSMJcOmRkrrBP6J6Or4Nwijf8x7GAQve5M4Xbdf3RWXambY+5n0QVHgYL0dQ1bp7o69evU
 8wXHMn1iNsig+VNSuhE1oqw+IBkkS44bmz+WnpcvAy66i66irY/l1gyfj033/TtmGL29xSpdrTA
 a7zwpSC17jKRNAYP5ig==
X-Authority-Analysis: v=2.4 cv=WpIb99fv c=1 sm=1 tr=0 ts=6a5028b3 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=qC1CW/w66vtJz1P9yTJxNA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=SRrdq9N9AAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8
 a=C3rexAz7Qlc2DGwNamgA:9 a=CjuIK1q_8ugA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: VSUpA_FuePV1t_zLibAc0Je934G532Cr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDIzMCBTYWx0ZWRfX0TnC+VaaKraR
 7Vg7Gja8bfLUOU0ClB+rsJExZmd19vlfPyO3xhwXeN7J62y0zH/aOs/CTlgH5mw5fpVjZ96T3iP
 UKrQ5rgUcRKupWfcsfM9JJJW1saqdHw=
X-Proofpoint-ORIG-GUID: VSUpA_FuePV1t_zLibAc0Je934G532Cr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_04,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1011 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607090230

On Thu, 18 Jun 2026 17:06:53 +0800
Chen Pei <cp0613@linux.alibaba.com> wrote:

> kmod_module_probe_insert_module() is supposed to return 0 for builtin
> modules, but only when libkmod can locate the modules.builtin index. If
> the index is missing (e.g. a kernel built with the driver as builtin
> but installed without running modules_install), libkmod falls through
> to the real init_module() syscall and returns an error such as -ENOENT,
> producing a spurious "insert failure" even though the driver is already
> part of the running kernel.
> 
> Add a helper util_kmod_skip_probe_insert() that returns true when the
> module state is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE. As an
> additional heuristic, treat KMOD_MODULE_COMING as builtin when
> /sys/module/<name>/ exists but the initstate file does not - this is
> the exact pattern libkmod's sysfs fallback emits for builtin drivers
> when the modules.builtin index is unavailable. The pattern mirrors the
> KMOD_MODULE_LIVE / KMOD_MODULE_BUILTIN check already used by ndctl's
> own test/core.c (see test/core.c:218-236).
> 
> The helper also returns the observed libkmod state via an out parameter
> so daxctl_insert_kmod_for_mode() can distinguish LIVE (retain the kmod
> reference in dev->module) from BUILTIN (drop it, since builtin drivers
> cannot be unloaded) without re-reading /sys/module/<name>/initstate.
> __util_bind() passes NULL since it does not need the state.
> 
> Reported-by: Jonathan Cameron <jic23@kernel.org>
> Suggested-by: Alison Schofield <alison.schofield@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

I'm not set up to test this right now but fix looks good to me.
So a tentative
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
