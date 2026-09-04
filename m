Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457BB43B4BF;
	Fri,  4 Sep 2026 09:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513795; cv=none; b=saFznzWg6Mdy3dZLmsXGKsrxPkYIh/cHfXyX/yuzeDD0M2wHIHNqp0fYjDT/xW78VfyhooC5jbe2yeIEzE0gYO/JM2ek4APL7bNXLM5lGcEeoULm1J1gY5P1HLVXbbuVFbgh6zxarGrHYCXLqiJ+/WhtaS+KunrhrazuVmMtQ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513795; c=relaxed/simple;
	bh=rbA0IxGL9+CCK5IcDfeuDGKA6vWktoLjWEqcmj3yd9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoXwCU9vj/4vtRFGyKoLO/deUuxRPgzlPoTaerraCTSCR6jQxE+3bor2Zi+/zyfSiRCaSNJBBeKpfpV6nsR9QaYKk8c74QUiiWjWNBwqHG/HINSJBQjkm5KRXU9L7tlTokj65r+Jf8DjW5roD2p4a2EwJNB/fL+fBCv32VsALhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5xu53uk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5xu53uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0D31F00A3D;
	Fri,  4 Sep 2026 09:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788513784;
	bh=/jvEiaT7kbOgGwVFp9TPF2lK770qlH0GwnFvo9Bezj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K5xu53uk7G+tubKGwLDb9lZdE2ceK6zjImyuddWOWb8LRuEf27J63YxuJ2P2gSVpw
	 0+CJ/D43WznOhNWzqHP03h6zL0QqyFeMIIrCib2CB7cftutliZisXFmsVL0pZMmyza
	 Z2TCoIhTj54JdSCnuewUzm1AzxdHsfBIfatxf79tZ8F+uhJLBA7gEdCe97VQWL9K3c
	 6Tl90LARxwAXcIb4YBX/0LPqC6RkX0x6y8xJcyrBVT0L/WM2TgJS5abNzoAzP7xAFq
	 MfIX+5+kjD/B+bGWRMxc6rrWtjnftFpUmm4kn9DSpvm+NqNSlB5ffftZGLRknIWqSi
	 lkPPJorI0tATA==
Date: Fri, 4 Sep 2026 11:22:51 +0200
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, John Groves <john@jagalactic.com>, John Groves <John@groves.net>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Message-ID: <20260904-chloren-unansehnlich-meiden-564d824fbb71@brauner>
References: <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <20260822002111.GA6110@frogsfrogsfrogs>
 <20260825-hinab-kanarienvogel-mitschnitt-04a662533a24@brauner>
 <20260828175945.GF6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260828175945.GF6047@frogsfrogsfrogs>

On Fri, Aug 28, 2026 at 10:59:45AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 25, 2026 at 03:34:04PM +0200, Christian Brauner wrote:
> > > > Without John's trust I'm not taking this on.
> > > 
> > > Whatever path you and John decide on, I would very much like to see the
> > > question of Which famfs driver do we merge? to be resolved for 7.4.
> > 
> > While it is reasonable to place limits on how long a series is pushed
> > out (I like to move with some speed myself.) we have two competing
> > implementations and that will have to play out. We should not merge an
> > fs just to finally merge _something_. The fact that this was more
> > contentious than usual doesn't imply we need to merge a version, doesn't
> > matter which one it is. That's a bad reason.
> 
> It's possible that you misunderstood me -- I'm not asking for one of the
> famfses to be merged for 7.4, I'm asking for you as the vfs maintainer
> to work with John (and Miklos) to choose which implementation survives,
> and which one dies, before 7.4 goes out.

Yes, we were doing that for quite a while though and have tried to setup
meetings. David acting as mediator didn't just magically happen...
