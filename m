Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E231AABF
	for <nvdimm@lists.linux.dev>; Sat,  5 Sep 2026 02:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788573827; cv=none; b=uiXhBNaUpD/Z7xjMtgqPhuH3RyjSzaN4/jLGPN4CHjSfGhve1ZMrG7rYQJdf29AAjQV+ypcfN3JP7ftZ4yLwmEVmLhLcuF65U6qDVcAC9RVwRcBZGeus70ov0eWF36cIKqj+F/zQDco7hHWHkExKJ9Uwq8oypaHx82ruCtx0fbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788573827; c=relaxed/simple;
	bh=ZBK/0t8opfWZKfoJreYeylUY5WVwQ2GQT6tM5ZGQ1JE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=U6jylHJOIFCBaFd+J/+NNccbfwmuDS2S48FTj+JYbSeLXeGoTGHQp+EgBuzxfUJYztV2h4fVKym7FfilTnHHJ5ZAsoA5eHpxaU6qgO45v+WhYZE5a92p4IROK+drCasxwM1fboZuFCirl6nFTnM/USqcIG/JuMXbwYBax1z5s8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UgTl3zJn; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UgTl3zJn"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZBK/0t8opfWZKfoJreYeylUY5WVwQ2GQT6tM5ZGQ1JE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788573823; v=1; x=1789178623;
 b=UgTl3zJnDe6asg6tFsyErT5vPjiFq2+QUxUP/yC4DZHn4S3++PUasWZwQvUWi/lzLkHZph5o
 LaZT6yQqZJhCLyu+rRuqNsL4iLD/JPchyrTeN6eZYZU+qjd2FW+qcbO4luwBXksQnYzbzhIlctN
 dOSWd+NW6ta1j9KPtpPP6oxw=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 66b1e777844760ee;
	Sat, 05 Sep 2026 02:03:32 +0000
X-Mizu-Trace-ID: 66b1e777844760ee
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] fs/dax: Remove unused dax_layout_busy_page()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260904152749.84493-2-kaitao.cheng@linux.dev>
Date: Sat, 5 Sep 2026 10:03:14 +0800
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <E6D028C0-7A67-4578-A320-8434CE468599@linux.dev>
References: <20260904152749.84493-1-kaitao.cheng@linux.dev>
 <20260904152749.84493-2-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 4, 2026, at 23:27, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> dax_layout_busy_page() used to let filesystems scan an entire DAX
> mapping for pinned pages. All callers now use dax_break_layout(),
> which also handles waiting for busy pages and deleting DAX mapping
> entries once the range becomes idle.
> 
> The remaining function is only a wrapper around
> dax_layout_busy_page_range() and has no in-tree users. Remove it
> together with its declaration, !CONFIG_FS_DAX stub, and exported
> symbol.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

