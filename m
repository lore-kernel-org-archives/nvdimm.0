Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B9C35F191;
	Sat, 22 Aug 2026 21:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787435760; cv=none; b=kxhQhASh8cVpk0QZA1d9gV07bR6PlQ+e0SZtFvud1AgFjT4w7v7i95Ny7Fr71HaoNuKFeGiEJu7q/RksNA+YR4h/6XQuquxjjLmAfwrEZtCFDw/7P8azc4DQ3dQxHQVA/J47Q2wRk7B+nG2JmjmMuceYCGO2tGrkR+0qFOJetfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787435760; c=relaxed/simple;
	bh=ydPE5wNVkHjkOcVFlSC9awoRXv6Z/AdDZGJpHIyo2cE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=kzy3K+fEy6y+cCVEcaM9+ZA2YhoEsRALneOAB7yVC9ibIpazmwL0j+kE2AUJ5MLXLjJIzMAvHsAyZwNpd0cAbgVbRZRP2ySRc851R5dqtVjBy/ITAFdTGTt4HcNdSP0xh9TPcbEg/4IgsGomamLz3aCn37qxXx3iY1wtrHB6AV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 678FF160211;
	Sat, 22 Aug 2026 21:55:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf05.hostedemail.com (Postfix) with ESMTPA id C14902000E;
	Sat, 22 Aug 2026 21:55:33 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3962EF40067;
	Sat, 22 Aug 2026 17:55:33 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Sat, 22 Aug 2026 17:55:33 -0400
X-ME-Sender: <xms:1RqKatMyIIi2EzLpM0KihAkAyDe0mhF4DMBBme-A0W4SRVKUI2x9lQ>
    <xme:1RqKaqwJcpM5Cassc4gyXnFazoAV6GJ2-koYFQE6F8uCfm5JG0u_l44T7OGZz-30t
    tOrb79KY-Dk2LsX00-slds_o8Nvafx_OvcnaBuN1QQqwlRw64VgdE8>
X-ME-Proxy-Cause: dmFkZTGCA6OH9wcjmhStKEmfjW0Tz7H7Z9zrjNt3d9qTBcfFYFwDDJEkh9OFgr+NuioEQS
    QZBYX3eWFyiPfkiuMlERyps1M542vWQPbrJJP/A/lNxB1C3dBoEp5Bm2mxgg/Zlik+Equg
    6hNe2KXSbIO/sauBMu3iC5lKwHhRVgvibk59WiqzunhddE8SC+fKFVmksyUiq/8pdu2fS7
    vNmEWII6WwS4+wtWW7MSv8corHn50om5j6m5U71PXaqN/7arYQ3cqvonlC7Kvv68zFEDPy
    xCIHoO7Vkm3N7BW3SQH5D7OFGQNh2I/V/UD3NUR+c70LTFb6BZIOmpTZJnPfEF59To3Sdn
    FEQkIKJVXTIU6hKqW1RwOi4YgpVgKRQ2Tj3S1kDrAyNvwb+C+5Hp8uXHY//0s7WvNTgjvt
    8gOVO+LqQIUPmjoC0tcqfflPEsBT0QkWtpPy4opr0zx2dB4cNk50wym/aYsjNiwsdpBCgo
    C6A7S2HZtyw2YvPjzrPDb4ryMtzk/NaMy6UPMdXJrHR+EadwMYTYyN/nO8Mml2weIVKAEU
    Ob5MZJ0IIwQhuriBgOv0uu0J3nXt3RUa92PqLRCAsBBd71mfCAonanhWeH/mPZKeb98NZz
    C7fBXNQsLAza/jv/LAhOTj9guJpsbHMn3Wb1k212ktGCCqmMTZ8kJU/SO8Ag
X-ME-Proxy: <xmx:1RqKaqBEjbtEl7S2izHBhGtCOi1v7zRdC3scgoyd3gvnyOda2okpNQ>
    <xmx:1RqKaiPYqXOjyCTfsiKZZYGaY_0A8Z8gaIAbj4s6iru_mlU2Gpovkw>
    <xmx:1RqKalpgU-DvmnGB4yvrQx6blUoOttKd0OyzVFeXv28NCHANdUlmsA>
    <xmx:1RqKahLFeYb7sAYRjmOuo84S4f8OumiPWavfhDoGzORY3ZaSeQJuPQ>
    <xmx:1RqKamdBMiSKRUxwnJcjEIuQXoB6U7v9YGgCiZbS1oi8R8G0ruJGf2PE>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E6606700065; Sat, 22 Aug 2026 17:55:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 16:55:12 -0500
From: "John Groves" <john@groves.net>
To: "Miklos Szeredi" <miklos@szeredi.hu>,
 "David Hildenbrand" <david@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>,
 "John Groves" <john@jagalactic.com>, "Dan Williams" <djbw@kernel.org>,
 "Bernd Schubert" <bschubert@ddn.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "John Groves (jgroves)" <jgroves@micron.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Jake Edge" <jake@lwn.net>,
 "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Randy Dunlap" <rdunlap@infradead.org>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jonathan Cameron" <jic23@kernel.org>,
 "Stefan Hajnoczi" <shajnocz@redhat.com>,
 "Joanne Koong" <joannelkoong@gmail.com>,
 "Josef Bacik" <josef@toxicpanda.com>,
 "Bagas Sanjaya" <bagasdotme@gmail.com>,
 "Chen Linxuan" <chenlinxuan@uniontech.com>,
 "James Morse" <james.morse@arm.com>, "Fuad Tabba" <tabba@google.com>,
 "Sean Christopherson" <seanjc@google.com>,
 "Shivank Garg" <shivankg@amd.com>,
 "Ackerley Tng" <ackerleytng@google.com>,
 "Gregory Price" <gourry@gourry.net>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Ira Weiny" <iweiny@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Haren Myneni" <haren@linux.ibm.com>,
 "Pratyush Yadav" <pratyush@kernel.org>,
 "Giovanni Cabiddu" <giovanni.cabiddu@intel.com>,
 "Jiri Slaby" <jirislaby@kernel.org>,
 "Ethan Nelson-Moore" <enelsonmoore@gmail.com>,
 "Gabriel Whigham" <gabewhigham@gmail.com>,
 "Aravind Ramesh" <arramesh@micron.com>,
 "Ajay Joshi" <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Message-Id: <ea56c85b-d564-4451-b704-58448a07bfa6@app.fastmail.com>
In-Reply-To: 
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
References: 
 <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: npbwmyrsypy9qfqbnarnhd3r6b8fomfa
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: C14902000E
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX1/eFa7gBwi+pCaM20Lnpv7AmduIYDxx1/M=
X-HE-Tag: 1787435733-255652
X-HE-Meta: U2FsdGVkX1/2IqEDh5jv55LWZkoKZ5XfhZh6L1ZBK7T6L0GsAfxjTCmXASd7cvzKb+2MRPBiINDU5CB5fzgP7Z3C/bi0ZhrH+t8aGGrbv6Wv+LGmLSZJM69TgGElFHslby+h+iUyHsCu7b5YTlWufYEptEBw7Vce+6U19JfRTBojHC0dIJPAEz9vI9MjerkpyNK8RgFoIASOSqmeKH2kpjJzUsCUrowAQbOEt1L/hQe4fPNE1w0+00VF04FQz6FpqkIzSqLWPKXaglYxdD94LWf6MzsajiyUcnoaUyOocxhdNW7YSg2OuWMPjbMo1vNXWCtjqlOKvqPDs8t64EFQsmQ5aaiq+MIS



On Fri, Aug 21, 2026, at 2:39 PM, Miklos Szeredi wrote:
> On Fri, 21 Aug 2026 at 13:40, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> > (a) Whether a fuse-based approach is feasible.
> >
> >     Are there any major blockers remaining?
> 
> No.

Famfs does work in fuse, but some of the asks are things that I don't see
how I can agree to. I think Miklos and I should discuss those 1:1, to figure
out if there is a way forward.

I think the virtual backing-dev thing is a non-starter, and I think that the famfs
portion of the fuse ABI basically can't live without extents that are
(daxdev, offset, length). 

And taking out the interleaved fmap structure, which I did in v11 because
it's my perception that certain fuse people *hated* it, is a bad idea IMO - it 
explodes famfs fmaps from a few hundred bytes to potentially many 
megabytes with no benefit to famfs. And famfs still needs compact 
interleaved maps in the metadata log, because that memory is expensive.

I have little doubt that 1) I don't fully understand Miklos' concerns and
priorities, and 2) Miklos and others don't fully understand mine. If you 
think I'm bad at explaining famfs now, you should have seen me trying 
3.5 years ago! ;)

IMO the on-list discussions have failed, and if people want famfs in fuse,
Miklos and I should try to work out a plan 1:1. I've thought this since the first 
time we discussed in f2f at LPC in Vienna, when you had questions about 
the interleaved layouts.

> 
> > (b) Whether a fuse-based approach is inefficient.
> >
> >     Are there scenarios remaining where performance or metadata overhead would
> >     be bad without an easy way to improve the situation?
> 
> Lookups can be cached, extent mappings can also be cached.   After the
> inode is in cache and the mapping is set up zero requests are needed
> for open/mmap/read/write/close.

True as far as it goes. The initial statement I made at LSFMM '24 was that
famfs would have to cache up complete file maps in-kernel, and that's what
I implemented.

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

Right. Famfs is a file system that uses dax instead of the page cache,
and that dax is character not block, and there is no backing store. Famfs
is not even storage, since the memory is volatile. So it's pretty different 
from mainline file system use cases.

In the thread from hell prior to LSFMM, somebody asked if I'm willing
to have the famfs code be shared. I don't even understand the question:
it's open source, of course it can be shared. Whether it will make much 
sense to do that is an open question IMO.

Also, I'm curious: if you don't know of a use case for the striping code outside
of famfs, why ask famfs to completely rewrite that?  (and I agree, other
than the eventual remote possibility of competing 'famfs-ng' fuse servers, 
I don't see much likelihood that this piece will be shared.)

> 
> > (d) Whether a fuse-based approach is too invasive.
> >
> >     Will fuse extensions to support famfs actually make it harder to maintain or
> >     slower on some paths?
> 
> No.

This does depend on what architectural changes are demanded of
famfs.

> 
> > (e) Whether a fuse-based approach will make famfs harder to extend.
> >
> >     Is there known follow-up work that will be hard/impossible to model in fuse?
> 
> It would actually make famfs much easier to extend, since the
> directory structure, metadata, etc. is now controllable within the
> userspace server.

That is also true of the standalone famfs implementation, although the
fuse approach is nicer for this.

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

Famfs has extensive CI that runs against both the standalone and fuse
implementations, including legacy versions that are still in use.

We copied some of the dax CI; some of the tests build a kernel, boot it
in qemu with NFIT virtual daxdevs, build the famfs user space in the VM, run
CI tests on famfs in the vm, etc.

We also run test automation on real shared memory hardware, but those
are still unicorn setups currently.

My team is quite serious about the testing (regardless of which version
goes upstream), and will be running automated testing against famfs 
on every kernel release, with multiple versions of the user space - and 
we'll be happy to share the recipes with others.

> 
> > (g) Whether a fuse-based approach would make famfs more complex.
> >
> >     Will the shift to user space result in a significantly more complicated
> >     overall solution that must be maintained?
> 
> The server would be somewhat more complex, since it's now implementing
> things like pathname lookup, etc.  But the other stuff (managing file
> maps) should be very similar.

The famfs fuse server exists, and it did add quite a bit of statefulness and
complexity to famfs relative to standalone. But that's sunk work, and it's 
pretty well tested. 

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

I think I already did the heavy fuse lifting. There are a handful of things
that need to be reconciled / negotiated.

Miklos, I trust that you are a good faith actor, although you seem to be
spread pretty thin. Can you commit to a series of 1:1 conversations with
me to try to work through the disconnects? 

> 
> > (i) Who would maintain any famfs fuse extensions and own any bugs?
> >
> >     famfs will possibly depend on fuse extensions that might initially only be
> >     used by famfs. Would the fuse maintainers just naturally deal with that?
> 
> I can take responsibility for the fuse kernel bits.

I can share responsibility for the famfs-specific stuff.

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

I think the virtual backing dev idea is wrong and bad. Let's discuss that.

> 
> We (Amir, Joanne, me) explained to John how this is exactly what's
> needed to make famfs work.  We've not seen an acceptance of that yet.

I am not feeling that my technical concerns have been heard and 
understood, and I have not thought that the suggested changes to famfs 
would preserve its fitness for purpose. 

Whether I'm right or wrong can be figured out if we discuss it 1:1. The 
on-list conversations have been something that my cardiologist asked
me to stop reading. (only semi-joking)

> 
> From my PoV this would be extra work, but in the longer term would
> expect to be less overall maintenance work and fuse would gain some
> useful features in the process.
> 
> Thanks,
> Miklos
> 

Wherever we are, we've gotten here without any 1:1 collaboration. Let's
try some.

Thank you,
John



