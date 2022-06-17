Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80C7F
	for <nvdimm@lists.linux.dev>; Fri, 17 Jun 2022 02:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461E1C3411A;
	Fri, 17 Jun 2022 02:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1655433118;
	bh=yr183iOvk+HdFa3z7/JDTOiLDCCurogTDkzDeVddOSE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Az2aWTtaqCX0BGv63R8jEMtiSVAvAmWp4MtuC4x9IwlDA0o7Ckeb702oMsgk2xTJ2
	 Wx9CGMKxOYja1upuOBnWPsp2lpevfUNZw1b/Xe1/ZeXKTGkqki+IqvTQ848Ue61/DC
	 98QJMZqkU5cxQ+Z5NEdFYoxB5I2q7VM+GDq+wk2A=
Date: Thu, 16 Jun 2022 19:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <djwong@kernel.org>,
 <dan.j.williams@intel.com>, <david@fromorbit.com>, <hch@infradead.org>,
 <jane.chu@oracle.com>, <rgoldwyn@suse.de>, <viro@zeniv.linux.org.uk>,
 <willy@infradead.org>, <naoya.horiguchi@nec.com>, <linmiaohe@huawei.com>
Subject: Re: [PATCHSETS v2]  v14 fsdax-rmap + v11 fsdax-reflink
Message-Id: <20220616193157.2c2e963f3e7e38dfac554a28@linux-foundation.org>
In-Reply-To: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
References: <20220603053738.1218681-1-ruansy.fnst@fujitsu.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Unless there be last-minute objections, I plan to move this series into
the non-rebasing mm-stable branch a few days from now.
