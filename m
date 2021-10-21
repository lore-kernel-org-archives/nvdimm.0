Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34302C8F
	for <nvdimm@lists.linux.dev>; Thu, 21 Oct 2021 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6z9iwoyDbMTCjGFW73yfcNKAqTQILctqsZjjZI0Dwcs=; b=BdKkN+FRK6bMlY4rj14koEYCOD
	FVkxPgZWZtZwtMbXM8rqbEj3ViPo1UKzkbuv9b3I9SndM+ZA42a9QaHBM4KjjhRJVQCtxEyfe9FLc
	2555orMj3GSv4hT9BTemQWoxHS0c/jgoahX78E+WEgKDPYgagLMruCv9OCaPfYIOpDmAT7KTMCfP5
	qHiFDZPrf2PRUPpMLQI0fW57qA8ms5T5XsRpR77WNOSL7up1nsBMhjJe5KuH9/cQ8JL1Biv4u4uRs
	FyRPqf80Nod7xRy7jqAfoir+78uKN2OHph3R/2Z4VcoIuxPNsq0eWsA5YhEqdXs6oErxUHD2yHr+l
	j6Lw2S5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mdWHs-007MQC-E3; Thu, 21 Oct 2021 11:31:08 +0000
Date: Thu, 21 Oct 2021 04:31:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with
 RWF_RECOVERY_DATA flag
Message-ID: <YXFPfEGjoUaajjL4@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021001059.438843-1-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looking over the series I have serious doubts that overloading the
slow path clear poison operation over the fast path read/write
path is such a great idea.
