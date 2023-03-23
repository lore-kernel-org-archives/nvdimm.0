Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE1B23A4
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 14:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AABBC433D2;
	Thu, 23 Mar 2023 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679583598;
	bh=X96U9cRa+WxlSwB3/wjzX6jxPtSOyXv5Ipj7ayZ3RAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bc+RPLy4dNSj/CE1trwGqvcjNNRpfzsFCzT3hGEjSBe5dNL4F/0w9RV3/l6JWEz4p
	 R4S1PxgEIuqfWau3l/D5zjwOTpBXIRMgBrmYtTzDHOhnNC+SMMVss64ztz8XKA6UJB
	 Izuv6ZRMAvWVYBWeY5qbfyACMS6xvv/tymQX6/iY9NYr0bWHOWGxfLjemJM7/hHlpZ
	 WHHwWEcYzWMpintgX10SUA1xAcAZUg4NtM1WgmYr7tkBg0Xy0/+OS0JFpO5hPhTHlx
	 FuI1g8fWdDrcl1ftfnSKlrLpsQBs9lDcSyZ/RR17L/fmyxQ5pN5/nFf/xwIadE/swS
	 ogYLELjWa1CiA==
Date: Thu, 23 Mar 2023 07:59:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz
Subject: Re: [PATCH] fsdax: unshare: zero destination if srcmap is HOLE or
 UNWRITTEN
Message-ID: <20230323145957.GA466461@frogsfrogsfrogs>
References: <1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com>
 <20230322160311.89efea3493db4c4ccad40a25@linux-foundation.org>
 <a41f0ea1-c704-7a2e-db6d-93e8bd4fcdea@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a41f0ea1-c704-7a2e-db6d-93e8bd4fcdea@fujitsu.com>

On Thu, Mar 23, 2023 at 02:50:38PM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2023/3/23 7:03, Andrew Morton 写道:
> > On Wed, 22 Mar 2023 11:11:09 +0000 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> > 
> > > unshare copies data from source to destination. But if the source is
> > > HOLE or UNWRITTEN extents, we should zero the destination, otherwise the
> > > result will be unexpectable.
> > 
> > Please provide much more detail on the user-visible effects of the bug.
> > For example, are we leaking kernel memory contents to userspace?
> 
> This fixes fail of generic/649.

Please make a note of easy(ish) reproducers when you know about them,
e.g.

"Found by running generic/649 while mounting with -o dax=always on
pmem."

So that anyone scanning around for fix backports has an easier time
doing an A/B comparison to assess whether or not they need the fix.
Especially if there's any chance that person is you circa 2024. ;)

--D

> 
> --
> Thanks,
> Ruan.
> 
> > 
> > Thanks.
> > 
> > 
