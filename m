Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DC721CFFA
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 01:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763689504; cv=none; b=TUMpeKG2s4A1sjIZ1e0mCirqFghchf6VGE+PkABtpjRQv/ZJ3poHk8QVuMVgpYhCJzNy1TKH9q2P36z6/K8ndpLyaLS4emNGh1QbT1kXB8Ymmgbvhp9VqpUvI/Y9cA6kPkD7AFrTHJkY7kWAPt4HsiIyreY1JBV43XtAFhWdqmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763689504; c=relaxed/simple;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=X3q+qXxIdOc1iwFTXO0I6ruW9Z9eWAsxATH3zt3dP1SEFGv9crydM+4eUwOEKwLR8y7CDRA9iorR1CcihI+2GBNZmwpJmIf2z9ht0I4wr0RiNWo5oMxSd8Tk3Wybo2v2Q7g/qgTbaL0L89+11wTezKzsz24PG6so+YEd/5Opl1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yOFGw2vp; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yOFGw2vp"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763689493; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ydOvMSYGLBPG/Sw3HqmtS98YZtsA/FvEeL+izFPO4Ak=;
	b=yOFGw2vpw/5XZjYzs6kDlcFj1TXl7wsFNAYMW49yUbAMhXQkaqOyRmPc+aIfdLg3+1FFPDh+2+/QvFkmP2frH49xfdiwtlN0D7Xl02EFzv+ksW0ng+8IEGeur6ozTkOqQMcanK92vp0OxTweMkY3CwtSxcWzrPjRTjdevx7krwU=
Received: from 30.221.131.79(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WsyfYXS_1763689492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Nov 2025 09:44:52 +0800
Message-ID: <1939a99d-c1d2-4b98-93c3-1951db367b3f@linux.alibaba.com>
Date: Fri, 21 Nov 2025 09:44:51 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [erofs?] WARNING in get_next_unlocked_entry
To: syzbot <syzbot+31b8fb02cb8a25bd5e78@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com
References: <691af9f6.a70a0220.3124cb.0097.GAE@google.com>
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, nvdimm@lists.linux.dev,
 Gao Xiang <xiang@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <691af9f6.a70a0220.3124cb.0097.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs.git dev-test
