Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4551C2AB
	for <nvdimm@lists.linux.dev>; Wed,  4 Oct 2023 17:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24510C433CB;
	Wed,  4 Oct 2023 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696441841;
	bh=pLQpBXeVK2ircCWRtxyQOyLjvhj8dNRHvI2AEQ54oHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dVMb0EXY1lY1rvyXbHorrs7h6+u8kuaBToRh64qqPXDX5sffx3v83NACHlWF3tmxz
	 Kh5QI+qthzoo9DQRBp+rk1CjAnltK25MeBohIX/zVn21pAXAxy5K4Dic5G7NMsX57i
	 mLbCpcwxUQhI+nELQ6fkVrovFWTq3wyURq146NBh9DIwKdnmGpd87LlJcDSL5T7FQO
	 Y8QWVN793qlTH4UBSg6WczKe3PpZt+PCV1OGzLiGNPPrlixHWg95FGDZNa5cwMeuA/
	 TNldZrhmkiO75Kvx+0pqArpg6WzzyF3KhqKoj8nawEBxCrM71JkuqB3iRNDomm7AcF
	 5eiwlYYl0AlxQ==
Date: Wed, 4 Oct 2023 10:50:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20231004175040.GJ21298@frogsfrogsfrogs>
References: <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
 <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
 <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <87msx5f4a8.fsf@debian-BULLSEYE-live-builder-AMD64>
 <4c985608-39f6-1a6e-ec95-42d7c3581d8d@sandeen.net>
 <65171732329c4_c558e2946a@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65171732329c4_c558e2946a@dwillia2-xfh.jf.intel.com.notmuch>

On Fri, Sep 29, 2023 at 11:28:02AM -0700, Dan Williams wrote:
> Eric Sandeen wrote:
> > On 9/29/23 9:17 AM, Chandan Babu R wrote:
> > > On Thu, Sep 28, 2023 at 09:20:52 AM -0700, Andrew Morton wrote:
> > >> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> > >>
> > >>> But please pick the following patch[1] as well, which fixes failures of 
> > >>> xfs55[0-2] cases.
> > >>>
> > >>> [1] 
> > >>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
> > >>
> > >> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
> > >> are watching.
> > >>
> > >> But
> > >>
> > >> a) I'm not subscribed to linux-xfs and
> > >>
> > >> b) the changelog fails to describe the userspace-visible effects of
> > >>    the bug, so I (and others) are unable to determine which kernel
> > >>    versions should be patched.
> > >>
> > >> Please update that changelog and resend?
> > > 
> > > I will apply "xfs: correct calculation for agend and blockcount" patch to
> > > xfs-linux Git tree and include it for the next v6.6 pull request to Linus.
> > > 
> > > At the outset, It looks like I can pick "mm, pmem, xfs: Introduce
> > > MF_MEM_PRE_REMOVE for unbind"
> > > (i.e. https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u)
> > > patch for v6.7 as well. But that will require your Ack. Please let me know
> > > your opinion.
> > > 
> > > Also, I will pick "xfs: drop experimental warning for FSDAX" patch for v6.7.
> > 
> > While I hate to drag it out even longer, it seems slightly optimistic to
> > drop experimental at the same time as the "last" fix, in case it's not
> > really the last fix.
> > 
> > But I don't have super strong feelings about it, and I would be happy to
> > finally see experimental go away. So if those who are more tuned into
> > the details are comfortable with that 6.7 plan, I'll defer to them on
> > the question.
> 
> The main blockage of "experimental" was the inability to specify
> dax+reflink, and the concern that resolving that conflict would end up
> breaking MAP_SYNC semantics or some other regression.
> 
> The dax_notify_failure() work has resolved that conflict without
> regressing semantics.
> 
> Ultimately this is an XFS filesystem maintainer decision, but my
> perspective is that v6.7-rc1 starts the clock on experimental going away
> and if the bug reports stay quiet that state can persist into
> v6.7-final.  If new reports crop up, revert the experimental removal and
> try again for v6.8.

I'm ok with this.  Let's merge the PRE_REMOVE patch (and the arithematic
fix) for 6.7-rc1.  If nobody screams during 6.7, send a patch to Linus
removing EXPERIMENTAL after (say) 6.7-rc8.  DAX will no longer be
experimental for the 2024 LTS.

--D
