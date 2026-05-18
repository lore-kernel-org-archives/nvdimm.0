Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4B03C9ECF
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 10:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779101006; cv=none; b=pf8K6jgaKtlldTvHtcklPPhy5qyMZ9KDnjM05RPu3Bxz44fdlRJpzsPLG5Sxjn6LrnP152OqlPTStrKzo8nfiPb9HqvzzFVCsyK3O6UhXrb/aVon8FwxzAWfSqZCfnux6oMXxznsKzBBKyCquHvV3QIXwOL+9YM4hdVJSy2vUu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779101006; c=relaxed/simple;
	bh=3tkmBXe921tXdJfepykgMhwlK5xBKsfmw3IiMm15+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bs80rO+OFQnLK4bb9Hm0T0hlIPsSg9EQyYUE6xkACJxA2wUe1SlG/FdurkW4CcuiAjKhhM+Y3c3jFDF4b7GZdW3SZwQn0smL/ttboDCpyOy828wEjQvn9HmOBYxMWBtxrJoVcRSSdCsjSHGaEjnLOnh3Q0Ccyldn7t3ze9ssdko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XwEynNgv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WtwTOxEF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XwEynNgv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WtwTOxEF"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I7Z11t1931006
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 10:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=tdVpl5M3mVeKMA/o8Lfxi/HC9IDNqbp9p1o
	WtiNOOxM=; b=XwEynNgvkUX6UNfm08kluP++oZgyecqPxPF0wuNzeuvP6mKEcUj
	3YZBOjoOO+keLfZOcXvXwXT065d01TieiC2yZLR2lkcddjA0saPNWTJt0STriJQM
	woE5yqFDTv+EFD6Ui5mIi0A6Epot+6yCnhvUxUDEhmR35z98mLWxcqxszLsPeFhx
	legRuFggUekQPwrcIpjc/qfDa6uC219UgY7Pquth5znaecSaGdS2XViPdG1eA08L
	DJKqluaM8El/C8Umgbz73gQEBbvJ7OoJjxjf/5QMsNOMDW+D0awdRnD68LB2mJar
	hLFpliyj23NM33xWyZ3eYYwVaRZeTmmWeFQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e6gx6x1xw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 10:43:15 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50edf01172bso67795441cf.2
        for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 03:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779100995; x=1779705795; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tdVpl5M3mVeKMA/o8Lfxi/HC9IDNqbp9p1oWtiNOOxM=;
        b=WtwTOxEFAT+buyBuaka+cEQ/HfUFBcWuCtB1NvTV+KHBMNc2bc6dWL5U8PWJyNQuxm
         V6gd5X5IqMd9Xc77s1nJ8efstc2SmU+1P51SmpQIvHPCIdreiXHWhMHgAioQSgilDbVN
         36LZv72gewYIlGFYCjaKvSpIZbaCZI5HlD4GXqzOp1kjof+xW5Aaa8y+LeT4XfiQ1elr
         FpvHQtN9BUy/mMh4mm2zr5r8OAfUDT/vcOQIlPrEeR0ByfgCN1bHpdtXmOEAKHKqdd1Y
         9r+/+l3dQCMupZ1E2VrGGzhTIfiw+vb0LBhy6D4s7K4qdN/VR/BEug2FWG35syimzWGQ
         CLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779100995; x=1779705795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdVpl5M3mVeKMA/o8Lfxi/HC9IDNqbp9p1oWtiNOOxM=;
        b=GsycaWMOFG99TcPUxbUJxiepGnq+l6PCZ/sLDDlW0Ns7kShLpqR8lPwHwBYjoRP3Qe
         /SrJCDyp1QqbVasiIu0zvSERSzpY2X9EJNDHWFMbEAWCaD89+vjpeY+xZPwOvrV6CdmZ
         V0ruxpb0Q3yBa6qXd28lcfrGD5aIqWigkoLo8uWs49eACEgYYV8KOU4Qa1K9cPtgVicU
         Mv/pb7paHi1fLzhFb/3ISFzNCut1V+tBB1fzwYBl5jJkc4jv+WySK3DAUSIchSl/0VIT
         3i1Rltn20JR/QwvspktpCjl63RzgVW2MF2NtwyF8V+g3nM7/eNK3cLKul3ES4HiqqT/9
         Ap/g==
X-Forwarded-Encrypted: i=1; AFNElJ/giDCIt2eqSABeF7eaoc0oq+vi0LUHKfzXRAs7grvvAQjzoFC60HaYS5l5N4JM87v8WymnQ6M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3rXbvUW4IseIigSQtomyZd7QqfN7wJqYeKEsvSqUlOyS05nwz
	7+9Zbzg4nqSL/GZ2Xyx65ST+E/ir0x2zx3XLt5cvJNhoZ2tJomkMYDwYCEsSSC4TsJm539QuvjB
	T+Y2Jpd5jhXU24OLIvdhEmyLKZc4AlGsxnZs56TQkQBXLv0VzmMcwe6k/OJ8=
X-Gm-Gg: Acq92OF6Z+yodE1iSTfp9i+hhBuAFNbzhzLFe3L16K6HjQnRQRwpbZeJQgYpwB4IQLR
	UyZW4+XOIjExIUOjC12hbx8ZhahhSTvSyv+HW3pTMrx2ukd3e6AU5Uyy5qgJSmrGkzef3E/38n9
	cisUirjwIVxDg/P0AAY93LN0EBB6+jJBKzuAnJF8qnU/XYtQMANfPb8agZIbouxMvm9IG8rexD2
	BE+Xoqwasxly8hTYxAK4XU9oLt//a3LHagPyB0tnF7WGOxLYcgzM/SFi0ZIIy2p49C3bCAXcXYt
	j0fsDRXmiXYOpDiNBEBSAp4B06q+RyXTvfx8R2pTmbQQOUgVH3Du0Nd1mKDBE3rx3yAXA1IMFS3
	K23rqs9nnk1xEZ1ugqDtS4FctBpQttftQfWVPk4jDqBi7ZTg=
X-Received: by 2002:ac8:5a04:0:b0:50f:e0c0:9d92 with SMTP id d75a77b69052e-5165a26bab0mr194255391cf.54.1779100995030;
        Mon, 18 May 2026 03:43:15 -0700 (PDT)
X-Received: by 2002:ac8:5a04:0:b0:50f:e0c0:9d92 with SMTP id d75a77b69052e-5165a26bab0mr194255081cf.54.1779100994549;
        Mon, 18 May 2026 03:43:14 -0700 (PDT)
Received: from quoll ([178.197.219.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767ee0sm34139603f8f.1.2026.05.18.03.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 03:43:13 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH] MAINTAINERS: nvdimm: Include maintainer profile
Date: Mon, 18 May 2026 12:43:07 +0200
Message-ID: <20260518104306.39289-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=805; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=3tkmBXe921tXdJfepykgMhwlK5xBKsfmw3IiMm15+VM=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBqCu06tCL9Esz7Um0aGrx2FMrT3K35zYcB8OA2y
 0RdOLvxUFSJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCagrtOgAKCRDBN2bmhouD
 1w2lD/0UT6Ne6vRVXdyMTlqIwrMuxT7upTi7nN7NZSHMz4SgicEJY9oELanMRH9hJwrt+BhHCc7
 M7zkp0siu7MxWrG4Alub1Gg0zIU3hK+vlkn1R/7N7zKKVYEGxcH28nWHwjl6YQq05mmzPPZrz/m
 rQgEF2WvG3CUiJQIWZp/LPTKsz3Ev0KHh5sOgrIsC+u3y0td8UdwfFPYS0UjA7169pKSoaFbRAX
 1+nKZGq5uYIXbJlyVK4V5NeibKV/tyZKV0D8jqDx3dPZXB6Jkj5Prnyuhq2w6HEPjj8mqyzUqfH
 NH826yMlycrxKnpNseXstt84qBct41miSmM5BckxhJXcX4EC6cS94sobn/heJjPTtKNPvZ6616o
 dbrtVjTUdn/90kDXfEBLzRUc21fDZCjUD1V1TBbqYCMiKMKka57aNoc7DOmy/hvnPp/cey5tDPf
 eAw+99pNnKCQoMBpRvb6p/kLaTGeMzjKhrsv9eHV9hQpw57cH6vSWieB9q2uJJ7mG2z0iNH+8nq
 qQ51Pap60ZdDwSHpl7YviUoDEZOqukhh9tux5PO+luKaNtw8Ej/LUEGI9H0ZNKRbrkX0LRGAPx3
 sUmYiYz9q65kced6c9Q7PklNjJr20Ungw5tQwGueEj93d2zsQfRGnvGpUTmVWzpGv4qtvL6mTqe /qb4Yee8fPqhRkA==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: tGzTqlgJ09o0PfjKRFSQD2PN-IQIWX4U
X-Authority-Analysis: v=2.4 cv=f614wuyM c=1 sm=1 tr=0 ts=6a0aed44 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=gOEeR9iKwsj33Yj5oN/cWg==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XFwzJdQMGZzsQ3vWwL8A:9 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: tGzTqlgJ09o0PfjKRFSQD2PN-IQIWX4U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDEwMyBTYWx0ZWRfX4G71/oggmNma
 7l4Jd5QI/B5WWMc6lFpqqtS60ZuDFCEvueLME5cnAzT0gzPW0Nyy8B4ryWpkhM1Aa3uVA7ZOW2z
 VEVKSForaQJn30HXKL9q24zmyzcsmPyLM9EKxyILxDiygknbRDufPopeuBrjjPKewwYhj15Io3q
 FqYroPk/gdXeqRhsf1J21MuBaKkuUbmfnBq8CSG/eYdXpO2TxCRQkIDLhrTsyWM7HOeCW+ZlRoK
 fOOeLXg5o9JP3Pm2eQbw30gp5HJo2kGVCC0WYPAs1w36gPCZ0DjSn/e3fXfYGoamPFopcg4eMLV
 zg9RCjVyJAzLhNDyoB9S2z67CzcLuh0IbmlT97usDJ2dJKlArJbvA5sZeUswVzxN841w6PtnFPC
 dRQ+zQwX/rsrodc/JlUmmSQmtFzmmH89L6A7Q7K7IiE0uUphXfFJQ41Sg5EXuir5DeWqnBCQ2W0
 RYAJr4em2cA1c1Bz9ZQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_02,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1011 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605180103

No dedicated NVDIMM maintainers are returned by get_maintainers.pl for
the subsystem maintainer profile, thus patches changing that file miss
the actual owners of the file.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a65b220d93f..294909f6d488 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14751,6 +14751,7 @@ S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 P:	Documentation/nvdimm/maintainer-entry-profile.rst
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
+F:	Documentation/nvdimm/maintainer-entry-profile.rst
 F:	drivers/acpi/nfit/*
 F:	drivers/nvdimm/*
 F:	include/linux/libnvdimm.h
-- 
2.51.0

