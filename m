Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432742A7B0;
	Fri,  4 Sep 2026 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513887; cv=none; b=fzYa/DEPB3Nj9wRgs3Tx4V2lLM0Ghne/fTq9cI8ObejvBYTmy/00GIERCXdYFyNxRaRxw23gKZQn0YtbPQhQ6r6P2dffq0bszDqzpI6aAVdfgFRS5yISbp1T5qilji2fovFwfAzQ0oCbyqUBi3Zgf/IYuwakVddU+zHiNvRen1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513887; c=relaxed/simple;
	bh=QyjjX9vepjKY0+1P6pQcURbciyBv+KznBhcCK+iDyNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auJVf0flKKup+qd8V5kBNhil3eMDhHQpbRkGZG71IhOL62N4UgqbxbtBsmXBovfdqlA8JpWHJR2SoiQTc72TFuZGXlgbtB1Ha2W5uTjvnGqE9GFFbq30HlewCQWYxOBG1CKFsBUm673QM4gYNxNsR7mXOAr3F/jgHGJxJOzfTqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnLj8z7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnLj8z7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8A91F00A3E;
	Fri,  4 Sep 2026 09:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788513886;
	bh=0Q2gQdnMXkmuqEEwuGsBz1mnUTcRs/5sddlALsXUx7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnLj8z7QBXMz0EneereeNaPUYnOYkZgECZFNwdofMxsmtHPFjpw3czhT5tSuV94ME
	 jwkcPLsjE8du1CQHXa8o09LipebTxC8M/yGRHoWzpIzHnJcE4aaRrwcFzXS7LYrOn6
	 PpOrd8YDvQxPitGhPmNmxsqj+hnQUkOhwmjISQhux0zaPiTBEfkEoI5taAxjQfj+HE
	 34UIKgUemB09CE8nHiMS4TCPM9Eop5AcdpRu8IpP7TAFcxDO3GZBPHZqj1OiUADLhv
	 5vmLv0AKViWZMXjsCHFWk2SODOipR08rqkauWM6ZZi3CIzbrf2yHdX8ctVzshpY0mk
	 NRhJtlej7V70w==
Date: Fri, 4 Sep 2026 11:24:33 +0200
From: Christian Brauner <brauner@kernel.org>
To: John Groves <john@groves.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	David Hildenbrand <david@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	"John Groves (jgroves)" <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
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
Message-ID: <20260904-faken-wogen-hausieren-5dc9b094bd26@brauner>
References: <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <ea56c85b-d564-4451-b704-58448a07bfa6@app.fastmail.com>
 <CAJfpeguuL8He4dKC0+CQU3c=Ss9nDEH=9VckB5mqxOr01X2q4Q@mail.gmail.com>
 <apHCzGheqgqjgILT@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apHCzGheqgqjgILT@groves.net>

On Fri, Aug 28, 2026 at 12:39:56PM -0500, John Groves wrote:
> On 26/08/24 09:41AM, Miklos Szeredi wrote:
> > On Sat, 22 Aug 2026 at 23:55, John Groves <john@groves.net> wrote:
> > 
> > > Famfs does work in fuse, but some of the asks are things that I don't see
> > > how I can agree to. I think Miklos and I should discuss those 1:1, to figure
> > > out if there is a way forward.
> > >
> > > I think the virtual backing-dev thing is a non-starter,
> > 
> > The virtual backing-dev is an abstraction.
> > 
> > Is it sufficient for you if I promise that this is going to do the
> > same thing as the standalone famfs at the same performance level?
> > 
> > >  and I think that the famfs
> > > portion of the fuse ABI basically can't live without extents that are
> > > (daxdev, offset, length).
> > 
> > Sigh.  My proposal was (backing-id, offset, length).  Again this is an
> > abstraction.  A backing ID can be a daxdev, a striped logical device
> > or it can be a block dev or even a plain file.
> > 
> > > Also, I'm curious: if you don't know of a use case for the striping code outside
> > > of famfs, why ask famfs to completely rewrite that?  (and I agree, other
> > > than the eventual remote possibility of competing 'famfs-ng' fuse servers,
> > > I don't see much likelihood that this piece will be shared.)
> > 
> > Because the striping feature fits much better into a virtual device
> > API than the extent mapping API.  This is how striping has worked in
> > linux for the last 30 years.
> > 
> > > Miklos, I trust that you are a good faith actor, although you seem to be
> > > spread pretty thin. Can you commit to a series of 1:1 conversations with
> > > me to try to work through the disconnects?
> > 
> > Fine, let's find a time.
> > 
> > Thanks,
> > Miklos
> 
> Miklos and I met yesterday and I think we found workable path forward.
> We will be collaborating on some changes to the famfs metadata transport,
> likely mostly via me trying to make it easy for Miklos to bring up a
> famfs testbed VM, and Miklos doing some re-work on famfs to make it
> more consonant with fuse (fuse-onic? ;).

Excellent news and thanks for your patience and working with Miklos on
this.
