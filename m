Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104933;
	b=uz1zhpB2rqIsmC7eYHVpLhSnfSi1I5k0hIAUe2DuOwA/fiIxe2e1NZj53NWKqtcqoWYC
	 S8oWMcV8a5iQ7nt3ud9Rnld/vKc65GvxV9EkXoxRwdFpfzXlQ9hDXo3iG92F7vR5NkcWN
	 4xJcfzUH8mlzp709bvDyYBBm5aLJsW9SrAIZc1v2T+IoIcRfHsg0QdFe2ctVNsfKDCMPZ
	 nh/YHWcFvDFtdE/urhW5CCMS/w0ZmyIUlgztDNSLxSp/3tEm4Z6zF/a744lWhi4gY5D6v
	 qtV9l37qGNL9mxTgJhz1r175+fRYdsyeTohZAGWyPeIMRpL5ONX9ljzEbVlDCcD6gxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104933;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Api87VJey7oWKieKO98GheiBgnFUNxJMI4zCYFh/lfA=;
	b=a3qFBv/fpPsAO/LiYUxOD6wuQA3R2Fi12lBRnJcbFE0qsGN03JgTVD/vPaS/MGSpGYfp
	 L/KtKtVZPBdjoUVbb8kRmm5lNGlBBk3A9EqWmv1ORtt2dVYnbC8H+RuhpOUvahbLPScjd
	 PDckZcvRCuDnNYicCW8b0KKSydA08nSSsi77zhwp9N+DzuKi6f6Y6kt5yjN3PMSWZV5Bf
	 SRZYNZtm8/M/P57tEdTshh5oZc97DRtgAPvoZam1i/PBii+EXatJtANaUhcWn7ehAr0U3
	 NYJRFDoXEc5wgwPAjoB6nZpZptuPxabMJr191ykkJlsHV5enggsbQu1lsKk9RCNyTdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=WuJO59p8;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF4A606A31A
	for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 12:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CF4A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=WuJO59p8
Received: from thinkpad-p16sg1.. (unknown [154.20.139.108])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7661520B7166;
	Tue, 27 Oct 2026 05:41:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7661520B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793104916;
	bh=Api87VJey7oWKieKO98GheiBgnFUNxJMI4zCYFh/lfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuJO59p8T91gRvQSvFU5cQ7W1TtgUKxI7PUrSrJY5kKqucankM4VfmcHchJITlOLM
	 pzVEG29HACvLL9cIVi1KwHAv9EAy1gb2IXyAc7dXMWV4ed0jBNZs8y1wZtCBqsWNT1
	 qsRWH9sia2fc0qzR857fYAV90HjDoM51+RKddXWY=
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: shyamsaini@linux.microsoft.com
Cc: alison.schofield@intel.com,
	bboscaccy@linux.microsoft.com,
	dave.jiang@intel.com,
	iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	srivatsa@csail.mit.edu,
	tgopinath@linux.microsoft.com,
	vishal.l.verma@intel.com
Subject: [RFC PATCH] drivers: nvdimm: validate dataoffset
Date: Tue, 27 Oct 2026 05:41:21 -0700
Message-ID: <20261027124121.794856-1-shyamsaini@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014020430.295282-1-shyamsaini@linux.microsoft.com>
References: <20261014020430.295282-1-shyamsaini@linux.microsoft.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Any comments/feedback on this patch?

Would it be better to discard all PMEM regions if a size mismatch is
detected for any PMEM partition, rather than validating the data
offset as proposed in this patch?

Thanks,
Shyam
