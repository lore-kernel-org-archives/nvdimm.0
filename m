Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27BD17E
	for <nvdimm@lists.linux.dev>; Wed,  9 Nov 2022 00:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27806C433D6;
	Wed,  9 Nov 2022 00:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1667953260;
	bh=TDA4WxwUFU57YOSu3V++4OACrFzF8uYXIyr4RuL5p4M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Scs23L0zLyvZMrgaDFaVKPWOPBfhd29r/iHMB/WaJx7VSdzDaYM9apJZG+Sr4RkBM
	 eGgz89oJA+xN2otF484vD9cQXmiXeC4qEfmGQgLUjyblcVSp50iHhetDECyizusOpM
	 UmjAit1QOpjrVFgJrW1mrGQQauG48s0qX6brF0Y0=
Date: Tue, 8 Nov 2022 16:20:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jan Kara <jack@suse.cz>, Christoph
 Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 00/18] Fix the DAX-gup mistake
Message-Id: <20221108162059.2ee440d5244657c4f16bdca0@linux-foundation.org>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

All seems to be quiet on this front, so I plan to move this series into
mm-stable a few days from now.

We do have this report of dax_holder_notify_failure being unavailable
with CONFIG_DAX=n:
https://lkml.kernel.org/r/202210230716.tNv8A5mN-lkp@intel.com but that
appears to predate this series.

