Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E825228C;
	Sun, 23 Aug 2026 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787492912; cv=none; b=edEbZHl8//VIwEYrcqQGQ919jWnEY7UMsv/lPB/ctear3rbehN8C8ouM/HNx7GgysbbDaDAZ38qLeJ17SGYlw1HNdzMkbXqu474HsYbP6Aj493AGWIvFoGkBMfd1JIE2eRCMEVLfgTZR8wHXeob/2ljP9cx/Zwtemmstw3nH9fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787492912; c=relaxed/simple;
	bh=9ru4Rv2kov9P62kZ/7ysWJt78Y4b9QKk4O0YK/oV4/U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YXbz6BkMJFQWsS3t5nLLMna1cvtCqx0P4CfT0EKjhjX/SpwYZsDsjdu0e26PlP/ShrjUGdySSrGYgUrhQ9ehn00/l5omnvWuiK2c0IKLysjD31Jv2FkFE3SAJOgx1mPRVMuYYKwyObwKRTf9kq/te4wOvbXt9Ly5cZRWbbyU6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+rXEwaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+rXEwaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7D41F000E9;
	Sun, 23 Aug 2026 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787492911;
	bh=3JeIdopILG7DTn8uxHRNJFoP0IqDAq0P8ZuIURtx1Ss=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=L+rXEwaAvrEdOuDK5MJMA8OdE1FlZCAQ38ckVcgZ7N/oK10q5vnR1OXkQJ1AWQexi
	 j8ZEOEt4+1RD70c1XY89BlkmkrmP2xLafzilR1D0xTM7IQVIg2lBIL8zOPNq70bqIE
	 OublJ+DJG0+N2/fasHfbfoQYXMX/rPI5yQ52pBsDWkTh+Sof+SeGNCHMZPPeQbvQkV
	 2URRyY2I7ygphGHaibJJKtR9gD42gbvJVVSPc+oWN9+5kQ4dbfghF2SMgO0tXPSiZI
	 3OvodDHFKNmQ+dGMKC5xT4F1CdONR2kTyQ9bOB9v9emYnkxryQApXT6ZMBnYpxaT34
	 VJwpz9KeqOnpg==
Message-ID: <e16e6e3d612923d4f25b811d9667068c48acb7b3.camel@kernel.org>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and
 mount
From: Jeff Layton <jlayton@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Christian Brauner	
 <brauner@kernel.org>, John Groves <john@jagalactic.com>, John Groves	
 <John@groves.net>, Dan Williams <djbw@kernel.org>, Bernd Schubert	
 <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, John
 Groves	 <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge
 <jake@lwn.net>,  Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang	 <dave.jiang@intel.com>, Matthew
 Wilcox <willy@infradead.org>, Jan Kara	 <jack@suse.cz>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Randy Dunlap	 <rdunlap@infradead.org>, Amir
 Goldstein <amir73il@gmail.com>, Jonathan Cameron	 <jic23@kernel.org>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong	
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya
	 <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, James
 Morse	 <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, Sean
 Christopherson	 <seanjc@google.com>, Shivank Garg <shivankg@amd.com>,
 Ackerley Tng	 <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>,
 Andrew Morton	 <akpm@linux-foundation.org>, Namjae Jeon
 <linkinjeon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Ira Weiny	 <iweiny@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Haren Myneni	
 <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, Giovanni
 Cabiddu	 <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>,
 Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham
 <gabewhigham@gmail.com>, Aravind Ramesh	 <arramesh@micron.com>, Ajay Joshi
 <ajayjoshi@micron.com>,  "venkataravis@micron.com"	
 <venkataravis@micron.com>, "linux-doc@vger.kernel.org"	
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev"	
 <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org"	
 <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"	
 <linux-fsdevel@vger.kernel.org>, "fuse-devel@lists.linux.dev"	
 <fuse-devel@lists.linux.dev>
Date: Sun, 23 Aug 2026 09:48:25 -0400
In-Reply-To: <20260822002111.GA6110@frogsfrogsfrogs>
References: 
	<0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
	 <20260803022828.75776-1-john@jagalactic.com>
	 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
	 <20260806043712.GB3560084@frogsfrogsfrogs>
	 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
	 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
	 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
	 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
	 <20260822002111.GA6110@frogsfrogsfrogs>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2026-08-21 at 17:21 -0700, Darrick J. Wong wrote:
> On Fri, Aug 21, 2026 at 09:39:26PM +0200, Miklos Szeredi wrote:
> > On Fri, 21 Aug 2026 at 13:40, David Hildenbrand (Arm) <david@kernel.org=
> wrote:
> >=20
> > > (a) Whether a fuse-based approach is feasible.
> > >=20
> > >     Are there any major blockers remaining?
> >=20
> > No.
> >=20
> > > (b) Whether a fuse-based approach is inefficient.
> > >=20
> > >     Are there scenarios remaining where performance or metadata overh=
ead would
> > >     be bad without an easy way to improve the situation?
> >=20
> > Lookups can be cached, extent mappings can also be cached.   After the
> > inode is in cache and the mapping is set up zero requests are needed
> > for open/mmap/read/write/close.
> >=20
> > > (c) Whether a fuse-based approach is a bad conceptual fit.
> > >=20
> > >     Will fuse have to carry a lot of famfs special sauce that cannot
> > >     really be used elsewhere / generalized?
> >=20
> > None.
> >=20
> > But "can" and "will" are not the same.  The striping code might not be
> > very useful outside of famfs.
> >=20
> > > (d) Whether a fuse-based approach is too invasive.
> > >=20
> > >     Will fuse extensions to support famfs actually make it harder to =
maintain or
> > >     slower on some paths?
> >=20
> > No.
> >=20
> > > (e) Whether a fuse-based approach will make famfs harder to extend.
> > >=20
> > >     Is there known follow-up work that will be hard/impossible to mod=
el in fuse?
> >=20
> > It would actually make famfs much easier to extend, since the
> > directory structure, metadata, etc. is now controllable within the
> > userspace server.
> >=20
> > > (f) Whether a fuse-based approach will reduce maintenance effor
> > >=20
> > >     Will maintaining fuse extensions possibly be harder than maintain=
ing
> > >     standalone famfs?
> >=20
> > Testing is a key point.  Famfs needs special hardware or emulation, so
> > it's not straightforward to test.  This could be solved by adding a
> > "dummy" mode to famfs server that exercises the same fuse API, but
> > instead of special hardware would just use plain memory.
> >=20
> > > (g) Whether a fuse-based approach would make famfs more complex.
> > >=20
> > >     Will the shift to user space result in a significantly more compl=
icated
> > >     overall solution that must be maintained?
> >=20
> > The server would be somewhat more complex, since it's now implementing
> > things like pathname lookup, etc.  But the other stuff (managing file
> > maps) should be very similar.
> >=20
> > > (h) Who would help drive the fuse approach?
> > >=20
> > >     Fuse people seem to be willing to help, but I expect that there m=
ust be a
> > >     close cooperation with John to make this fly. I don't expect that=
 John
> > >     himself can easily (or understandably wants to :) ) do the heavy =
fuse
> > >     lifting.
> >=20
> > Yes, this is where previous efforts seem to have gone off the rails.
> > So I agree to take responsibility for implementing the kernel side and
> > help with the server side on the condition that John has trust in
> > this.   I'm not promising -7.4, but can at least try.
> >=20
> > Without John's trust I'm not taking this on.
>=20
> Whatever path you and John decide on, I would very much like to see the
> question of Which famfs driver do we merge? to be resolved for 7.4.
>=20

Agreed -- this is exactly my take as well. While I sent a R-b for
John's standalone work, I've no issue if the better path forward is
deemed to be FUSE. I'd just like to see this come to some sort of
resolution.

Cheers,
--=20
Jeff Layton <jlayton@kernel.org>
