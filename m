Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D63822AA;
	Fri, 28 Aug 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787938821; cv=none; b=HSUKOJKVX4576HPwinTXDgXUeobrxak4Fpm8umw3n8V4a2oUhSWZ4b/EkB+3ZcWeYX4AcRoCI6fHAFjLccC1/6TBMfLiEzEIWOB2FrUYOid5BvsaiSeQ+YErClCl3G+xMC83fjaaA9D/A4jIB0P2zQKL86feFEn0LqXMvPipV4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787938821; c=relaxed/simple;
	bh=a6XZSYNaxo8FvCxsKJebyhBvC+GqhRrIxNJ4JBsbVbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8WN+V3GKKspLRWyTAz6CETjrKF5ZI0H2fbHrzlGtffAc45JtRya5qquckTiSxAQ2UGw7k0FegRTbQBj7Eba5SlaqGSXQDgptJH9thKvfjMvZOmcPAjzKvGAH0EpVK9J83aJzUUhkT1WBBRuhIurpRCal9QpAApCgh6cTMStXFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38354A04C3;
	Fri, 28 Aug 2026 17:40:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf11.hostedemail.com (Postfix) with ESMTPA id 8C67B2002A;
	Fri, 28 Aug 2026 17:39:57 +0000 (UTC)
Date: Fri, 28 Aug 2026 12:39:56 -0500
From: John Groves <john@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
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
Message-ID: <apHCzGheqgqjgILT@groves.net>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <ea56c85b-d564-4451-b704-58448a07bfa6@app.fastmail.com>
 <CAJfpeguuL8He4dKC0+CQU3c=Ss9nDEH=9VckB5mqxOr01X2q4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguuL8He4dKC0+CQU3c=Ss9nDEH=9VckB5mqxOr01X2q4Q@mail.gmail.com>
X-Rspamd-Queue-Id: 8C67B2002A
X-Stat-Signature: to9ea9gectc5dcsz8unohh9rdicjnar6
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/yikPLksdokF4Uqf19N14BEsQ4Pk/vaGI=
X-HE-Tag: 1787938797-959519
X-HE-Meta: U2FsdGVkX1/thqv1X8QxTl8kJ3H1mNoX7R1l9oU4DnHS95JpgBLHEUur4QgjaQ9W2gxZ0jE/GhGGDX126ps0cD2eFNmAnw+yw0IJBwaffQc36yTNPhuBA/f/fwdW3/aSKNr9H2b80K6ta0zaWh2p2Tsj0mD2qM2bWVXcHuinFwSmNA3Tqr0Z61K1XfNZnJ6zHxqgEVraj5Zte9Ert8l6y48kB0FGX53iRlUoY+V0M4JSHJdhKqW64/5FsN2m1LNrUQwm3yCC1n8KfMAKG8/eYD60zjLRYDpvLG/+M3IuhcGiZq9Gj8ciCf1plIl+HjbxcxWO4z6R86PS3PJGjFsqUHd4yoYDiiOwhNDsbP2sHpqwVQNMZh4WorQoTzSi9Gny

On 26/08/24 09:41AM, Miklos Szeredi wrote:
> On Sat, 22 Aug 2026 at 23:55, John Groves <john@groves.net> wrote:
> 
> > Famfs does work in fuse, but some of the asks are things that I don't see
> > how I can agree to. I think Miklos and I should discuss those 1:1, to figure
> > out if there is a way forward.
> >
> > I think the virtual backing-dev thing is a non-starter,
> 
> The virtual backing-dev is an abstraction.
> 
> Is it sufficient for you if I promise that this is going to do the
> same thing as the standalone famfs at the same performance level?
> 
> >  and I think that the famfs
> > portion of the fuse ABI basically can't live without extents that are
> > (daxdev, offset, length).
> 
> Sigh.  My proposal was (backing-id, offset, length).  Again this is an
> abstraction.  A backing ID can be a daxdev, a striped logical device
> or it can be a block dev or even a plain file.
> 
> > Also, I'm curious: if you don't know of a use case for the striping code outside
> > of famfs, why ask famfs to completely rewrite that?  (and I agree, other
> > than the eventual remote possibility of competing 'famfs-ng' fuse servers,
> > I don't see much likelihood that this piece will be shared.)
> 
> Because the striping feature fits much better into a virtual device
> API than the extent mapping API.  This is how striping has worked in
> linux for the last 30 years.
> 
> > Miklos, I trust that you are a good faith actor, although you seem to be
> > spread pretty thin. Can you commit to a series of 1:1 conversations with
> > me to try to work through the disconnects?
> 
> Fine, let's find a time.
> 
> Thanks,
> Miklos

Miklos and I met yesterday and I think we found workable path forward.
We will be collaborating on some changes to the famfs metadata transport,
likely mostly via me trying to make it easy for Miklos to bring up a
famfs testbed VM, and Miklos doing some re-work on famfs to make it
more consonant with fuse (fuse-onic? ;).

Meanwhile, the most recent standalone famfs series (v13) had some very 
helpful review comments - many of which apply to both the fuse and
standalone implementations. I plan to publish a v14 standalone branch
with those improvements, and also cross-port the appropriate portions
to the fuse series, which will probably be called v15.

That updated fuse series should be the foundation for Miklos' rework - 
and I'll get it ready as fast as I can.

Miklos, thank you for working with me on this. I think this was one of
those cases where there is no good substitute for face-to-face
collaboration.

Regards,
John
 

