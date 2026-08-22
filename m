Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDAD19C54E;
	Sat, 22 Aug 2026 00:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787358073; cv=none; b=snoY6zzsdid/Vntdq0B1qazEsErZ0+ZM/NXjwetWiA6pejyx77L2rOWL7rnJKWvG/Fhy+XpkybTxYkMTq7xVs5IhLtJ2zeNbfiYX2rp6lJ9/zQXAJYQlvT8BlZuJ2YxTGiGgWqRnUwck+u6e/wOrK1ag44kge6MTUYTHaECYERM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787358073; c=relaxed/simple;
	bh=04PGfN321LwPxDHkvZJH9jNKMJ5U8N2Xg8WIG2yNewI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QB2tb8Uf8t+f5wGuHHDhIksnSRN/PPnhNFh7NpHaqMcD8Pkc3VzVNdcUUnmIfzvGtOVOgOMAF1OYYX9vJ89PwZ0lec0CMUrkAF3F/LVNzut01cmi4YB36uuxO4shg+7sl+gP858speiXxYJ29LkVHxxPUdJ+HWvHkNZ3ZAA40Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRVk+b5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRVk+b5S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 90A741F00A3A;
	Sat, 22 Aug 2026 00:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787358071;
	bh=VnvrSWBU7Chzu0SZv3q18yghO955t8NOUwvVgQ/xaaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kRVk+b5Sop0HwCx+SSMbe4rjsYgAs8JF2NrwyMJI9YyB5z17JKbkaAOzCgryr1EK9
	 yrUGr676QyvZELzBIs9M57Hl1Xo7+3niOlPyFQNVJW7ymPwfQZpGU2FzluXUqU15/P
	 8VQT2+wydynZN9LuA2zIhZbNwWk1oTEbdBS/qJJNUX2VQU4asP+5fjmy4Zx9rMpBlK
	 L2RbugVc525uF9y0yVkJ6gVNgS5NhMF+9qmldM8sTtalNDlbz1HjJpuEXYnPMc9scK
	 Sv9w1bv9aMpcvHe5Eu6Du8acU5HIZQrhCvDL28EOufzi/2P3tqFxdA1LarpMyoPh5H
	 VB0dOtE+te6PQ==
Date: Fri, 21 Aug 2026 17:21:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
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
Message-ID: <20260822002111.GA6110@frogsfrogsfrogs>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>

On Fri, Aug 21, 2026 at 09:39:26PM +0200, Miklos Szeredi wrote:
> On Fri, 21 Aug 2026 at 13:40, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> > (a) Whether a fuse-based approach is feasible.
> >
> >     Are there any major blockers remaining?
> 
> No.
> 
> > (b) Whether a fuse-based approach is inefficient.
> >
> >     Are there scenarios remaining where performance or metadata overhead would
> >     be bad without an easy way to improve the situation?
> 
> Lookups can be cached, extent mappings can also be cached.   After the
> inode is in cache and the mapping is set up zero requests are needed
> for open/mmap/read/write/close.
> 
> > (c) Whether a fuse-based approach is a bad conceptual fit.
> >
> >     Will fuse have to carry a lot of famfs special sauce that cannot
> >     really be used elsewhere / generalized?
> 
> None.
> 
> But "can" and "will" are not the same.  The striping code might not be
> very useful outside of famfs.
> 
> > (d) Whether a fuse-based approach is too invasive.
> >
> >     Will fuse extensions to support famfs actually make it harder to maintain or
> >     slower on some paths?
> 
> No.
> 
> > (e) Whether a fuse-based approach will make famfs harder to extend.
> >
> >     Is there known follow-up work that will be hard/impossible to model in fuse?
> 
> It would actually make famfs much easier to extend, since the
> directory structure, metadata, etc. is now controllable within the
> userspace server.
> 
> > (f) Whether a fuse-based approach will reduce maintenance effor
> >
> >     Will maintaining fuse extensions possibly be harder than maintaining
> >     standalone famfs?
> 
> Testing is a key point.  Famfs needs special hardware or emulation, so
> it's not straightforward to test.  This could be solved by adding a
> "dummy" mode to famfs server that exercises the same fuse API, but
> instead of special hardware would just use plain memory.
> 
> > (g) Whether a fuse-based approach would make famfs more complex.
> >
> >     Will the shift to user space result in a significantly more complicated
> >     overall solution that must be maintained?
> 
> The server would be somewhat more complex, since it's now implementing
> things like pathname lookup, etc.  But the other stuff (managing file
> maps) should be very similar.
> 
> > (h) Who would help drive the fuse approach?
> >
> >     Fuse people seem to be willing to help, but I expect that there must be a
> >     close cooperation with John to make this fly. I don't expect that John
> >     himself can easily (or understandably wants to :) ) do the heavy fuse
> >     lifting.
> 
> Yes, this is where previous efforts seem to have gone off the rails.
> So I agree to take responsibility for implementing the kernel side and
> help with the server side on the condition that John has trust in
> this.   I'm not promising -7.4, but can at least try.
> 
> Without John's trust I'm not taking this on.

Whatever path you and John decide on, I would very much like to see the
question of Which famfs driver do we merge? to be resolved for 7.4.

--D

> > (i) Who would maintain any famfs fuse extensions and own any bugs?
> >
> >     famfs will possibly depend on fuse extensions that might initially only be
> >     used by famfs. Would the fuse maintainers just naturally deal with that?
> 
> I can take responsibility for the fuse kernel bits.
> 
> > (j) Whether a fuse-based approach has an end in sight.
> >
> >     famfs goes back .... quite a long time. It would be nice to close that
> >     chapter :)
> >
> >     Is there an end in sight, or could we end up in the same situation in 6m/1y/
> >     ...
> >
> >     IOW, is there a way to agree on an MVP that won't require a lot of further
> >     re-planning and changes to a fuse-based design?
> 
> I already sent patches to implement the dax dev mapping, and the
> striping.  We've discussed adding support for fixed backing ID, which
> was something that John asked for.  The only missing piece was adding
> a protocol extension to set up  simple extent mappings, which already
> existed in the famfs_fuse patch, just needed to be renamed and unused
> fields changed to "spare".
> 
> We (Amir, Joanne, me) explained to John how this is exactly what's
> needed to make famfs work.  We've not seen an acceptance of that yet.
> 
> From my PoV this would be extra work, but in the longer term would
> expect to be less overall maintenance work and fuse would gain some
> useful features in the process.
> 
> Thanks,
> Miklos
