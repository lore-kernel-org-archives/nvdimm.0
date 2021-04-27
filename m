Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC702F80
	for <nvdimm@lists.linux.dev>; Tue, 27 Apr 2021 16:05:57 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C04752C1;
	Tue, 27 Apr 2021 15:58:16 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C04752C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1619539096; bh=32JbU+gLnbX1jmUuwmVFyNRAMmXw0M5RxNBqOE6G4gI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cbEDjBbx83QSba420HmqA8g1o8Yf6+Hl4Mh356YlEZ/8faa7oQAWMgY5Yw4hKD/Uy
	 azkSJDrWXiOmf7vPrsL6mvlRGrg/q8of8JFYupTlHepCkEQugj/bB1QzHjXcx0j00D
	 68dpNLl3EbYQQ1MpyzwSRbYylFa5RO9ynS8jYq1AwRqXzrt/FxI8Pvcqmga7loDVEw
	 FiLxQVnrhHiRV2zuQ2Bg1UEtwJnRkcEyr9am1oTbsoTWxVLdPoTJt9ArAhSmsePG8Y
	 9FwcNGmkKPutIys6cbYBuFwPY2QnnUyy+8xrcTtLLOFP+gFChqgCE4Tjvjm+Kr0r+2
	 4WD3ajG2dyB6Q==
From: Jonathan Corbet <corbet@lwn.net>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Ira Weiny <ira.weiny@intel.com>, Oliver O'Halloran <oohall@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Dave Jiang
 <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Move nvdimm mailing list
In-Reply-To: <161898872871.3406469.4054282559340528393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <161898872871.3406469.4054282559340528393.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Tue, 27 Apr 2021 09:58:16 -0600
Message-ID: <87sg3bd8iv.fsf@meer.lwn.net>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> After seeing some users have subscription management trouble, more spam
> than other Linux development lists, and considering some of the benefits
> of kernel.org hosted lists, nvdimm and persistent memory development is
> moving to nvdimm@lists.linux.dev.
>
> The old list will remain up until v5.14-rc1 and shutdown thereafter.
>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Oliver O'Halloran <oohall@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/ABI/obsolete/sysfs-class-dax    |    2 +
>  Documentation/ABI/removed/sysfs-bus-nfit      |    2 +
>  Documentation/ABI/testing/sysfs-bus-nfit      |   40 +++++++++++++------------
>  Documentation/ABI/testing/sysfs-bus-papr-pmem |    4 +--
>  Documentation/driver-api/nvdimm/nvdimm.rst    |    2 +
>  MAINTAINERS                                   |   14 ++++-----
>  6 files changed, 32 insertions(+), 32 deletions(-)

Would you like me to take this through docs-next, or did you have
another path in mind?

Thanks,

jon
