Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33A036196E;
	Fri, 28 Aug 2026 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787939987; cv=none; b=IuT9IHUzrEdUnWO4/ZXoPe21O0Y2vQ1oFU/XB2zudTHex6nuenk4yOnXkI2BxdbRjVNumd3HzL7D2eBvGw6b60h/6YOaIU9OjcZdoaumFdb7uCr5TutDMi5BH3duvzMD6Zq0Wr2XgUfzWWqaJOaNpLAhcsLDVEJwIo0MIFe0LqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787939987; c=relaxed/simple;
	bh=XJFJLlw910QayAkpEB8HcBYCWX8GldrLx1VPp6Aq5ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cHgEZDTy9bOPyzfgdVjaCcMUm5cijIPKqUckray6kVMJP7nEP4T7LJHT3SU4qpNaI5N/IDMW4GWDJE5ELabTMCBOwhy13eIMM7HwSjCCi8pTUcOnpWpT4nmgXj1I9h7L0zxf9NY0IjBfnQeGMRXA6oWyZJujePDWq0wgx/VGgTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFvxKp4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFvxKp4z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 58D6C1F000E9;
	Fri, 28 Aug 2026 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787939986;
	bh=1dwCMNpi6ARDgaTbq0m4Zv5ew8SmBdIFd/Sg3kAbU6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mFvxKp4z6wz9nfiygWo3ouPRHic0dRHP9gC8VVOzp73y7Wn2FLUJRgoTJgvU3fUsD
	 gGoAuT7Szr+Vjc135ixTP8Wjsf1gfIx43yfEy7Z30UgiAbP429iWKpY4rDILSx1SJX
	 60nTpUkDf59nHJ4U739h9ClRuLlymxP52ED3Sj/+I6mbQTD3Agv7IfNUGAkZBwsx4W
	 W71RdYGe249DiAaEe6ekHLZgJn7JNbN6LnivfYJNWyCfJ//bwSbtGvWxd6c5sS1Cu/
	 W6FOo/jkvfLtARZsTR41ix8u+skWrb8G41RFjijsVIHFnqw9XFCN4VqR6oZ0Pkx928
	 feZklM7835BgQ==
Date: Fri, 28 Aug 2026 10:59:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	John Groves <john@jagalactic.com>, John Groves <John@groves.net>,
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ira Weiny <iweiny@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Message-ID: <20260828175945.GF6047@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <20260822002111.GA6110@frogsfrogsfrogs>
 <20260825-hinab-kanarienvogel-mitschnitt-04a662533a24@brauner>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825-hinab-kanarienvogel-mitschnitt-04a662533a24@brauner>

On Tue, Aug 25, 2026 at 03:34:04PM +0200, Christian Brauner wrote:
> > > Without John's trust I'm not taking this on.
> > 
> > Whatever path you and John decide on, I would very much like to see the
> > question of Which famfs driver do we merge? to be resolved for 7.4.
> 
> While it is reasonable to place limits on how long a series is pushed
> out (I like to move with some speed myself.) we have two competing
> implementations and that will have to play out. We should not merge an
> fs just to finally merge _something_. The fact that this was more
> contentious than usual doesn't imply we need to merge a version, doesn't
> matter which one it is. That's a bad reason.

It's possible that you misunderstood me -- I'm not asking for one of the
famfses to be merged for 7.4, I'm asking for you as the vfs maintainer
to work with John (and Miklos) to choose which implementation survives,
and which one dies, before 7.4 goes out.

I'm encouraged by John and Miklos having a call yesterday that John
reported to be productive.

--D
