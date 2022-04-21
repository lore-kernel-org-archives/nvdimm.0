Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF271FA1
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 06:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DxYVFPqhw7EnfsZEYTXHcUR3ApSQdJ6o31Q8vRA3VKw=; b=SfuV6EQAHeinwPkf3hcym0/Xob
	SQ1klssE18KyBbQZ5Nh/e95MAq1KO/mLU7YLXQX8BGIDq/YyAeM8YClulitOVYqttaAkORvVmLsDZ
	0SJzoBoUYgIYUVU+Dmh0XlO0T+blI+Zk7evK9t6fMpt03MzZwzCJ95njWKqHPmdEi1UEiMeuNNX8m
	ec3u1DQJZ+FqkjMMu/1Pr143NQW46bCDQu7RuOHjxi0kIiuPctNXC1f4CL3p0NIdzc2fQMIPoTgcW
	BIpm9oJl7+WOqQi6ydsJZYpB8wPDwhqRIlcSpxxW+bDog9j93yNtOjVU6vtR7P0cJsfW/Y41vZ58i
	U+LYdR+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nhQkd-00BuPJ-S6; Thu, 21 Apr 2022 06:57:15 +0000
Date: Wed, 20 Apr 2022 23:57:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, bp@alien8.de, hch@infradead.org,
	dave.hansen@intel.com, peterz@infradead.org, luto@kernel.org,
	david@fromorbit.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
	willy@infradead.org, vgoyal@redhat.com
Subject: Re: [PATCH v8 4/7] dax: introduce DAX_RECOVERY_WRITE dax access mode
Message-ID: <YmEAS5hi7Os9Lgcq@infradead.org>
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-5-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420020435.90326-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (bb->count &&
> +		badblocks_check(bb, sector, num, &first_bad, &num_bad)) {

Weird alignment here, continuing lines for conditionals are aligned
either after the opening brace:

	if (bb->count &&
	    badblocks_check(bb, sector, num, &first_bad, &num_bad)) {

or with double tabs.  I tend to prefer the version I posted above.

The being said, shouldn't this change even be in this patch and not just
added once we add actual recovery support?
