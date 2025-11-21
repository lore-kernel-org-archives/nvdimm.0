Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477D1FF1C7
	for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 01:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763690085; cv=none; b=hl4sjzEPNpKgs80V6ueCTC/XmLag0kGtPy3z3UoP3E9IKM4BvRjzzR5CYjP2lJe6XJAaHRU2Ch4z3FjxQjHamTaG7U1gf40Cn07Gotbq8XAA3OC4guKDfP2kTgD+tiCWDSgJHutu1hVVtx6QPb3AOyXy0MWRD57bTdSJLqY5WI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763690085; c=relaxed/simple;
	bh=mjXzwlPQuMvwfuoI6fyn1UE0PXw5yR0XdOPwuz9JfZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=O4AFXi+WPANCc3Z8XOILE3HE6mf1U51umuZ7rXP5eTkmFY19zVpm5aj02SBl/53wBOdrJ/1FicfL9jKAU2YMa+q53qIc7Z/5Uzt5fOO2tvoixtItEyVbMlv+efGSUFhQWvFRatPj9eguzHFgotm/r35bp/ppBfqpEP9jt8CcQDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WrnK8NHt; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WrnK8NHt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763690081; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mjXzwlPQuMvwfuoI6fyn1UE0PXw5yR0XdOPwuz9JfZU=;
	b=WrnK8NHtTPmJe25VDPWP0ip2jESxlMSmZzH1WlpJ3TWOll4TL17SoeVvVKgrBxdN7lV6V8oAwLkXNEjLXmp7DZF4d47DDyY86OBvSBAs/eXIB++kDEMnXCU5YGQtnoxjbfAhlkIIdEoq8PPrU5Dpvgl/CtGDLb65tgbbix8wPwE=
Received: from 30.221.131.79(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WsyeYvn_1763690079 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Nov 2025 09:54:40 +0800
Message-ID: <eec31850-c012-4200-8a0a-4dff5a901720@linux.alibaba.com>
Date: Fri, 21 Nov 2025 09:54:39 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [erofs?] WARNING in dax_iomap_rw
To: syzbot <syzbot+47680984f2d4969027ea@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com
References: <68ddc2f9.a00a0220.102ee.006e.GAE@google.com>
Cc: linux-erofs mailing list <linux-erofs@lists.ozlabs.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, nvdimm@lists.linux.dev,
 Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <68ddc2f9.a00a0220.102ee.006e.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz set subsystems: fs
#syz fix: dax: skip read lock assertion for read-only filesystems
