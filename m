Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504FB481647;
	Tue, 25 Aug 2026 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664859; cv=none; b=HVbUxe7IHOaUcCnKwxlZoXbWR2eZEpDEOTX0oPB/YZWivfpPhTD5eI/S7hX0QNTZLuk7oMGQrx0DQQaFUXK+aAWRVuvRgdxAE7a35uZnPOF6e49UuuHMKmmUFlIr1XofREiPNBBoO8aIDrZSAetK0S0pJpP+w0S4GIeI5GxerhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664859; c=relaxed/simple;
	bh=Ur494N8tncOiuUSFJwAM1NGjeVD1akKThWH07XBptkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ypd1LyzBJFF3+F/c1ep5XzaLqoaToLn1sPxBLiiq661mEWtfamgV5OPiQdBodOaKzBLJxPTm04G8afp4X/QkloQec8HyQTgy6IPx4DZ2xT56XqdxqcLIWoDuXQlKPvGGkVwI0N7iNfHKeN5y0x3hSwUwoHZL7LQPx07uOaOc3y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANonr/2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANonr/2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430A01F000E9;
	Tue, 25 Aug 2026 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787664858;
	bh=8sEDHtJiuV3WEA+sVpfliu1h4A/h9boCX0oYBZXCbMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ANonr/2CovldT/yYJtMwtmKZ/t8+e7ApMmSuLw+MiM7p7KYE6RnPF5lqgfWbp43if
	 sq1+DoT3HbJ4WzE/8bjmiwHymsIeVYwA6KcX+p3OrOUpqcB+VwZkm2UG+gwTfBnLGF
	 urLG8AvUxKvAGYdNTQvRBdCi4mDIqQBi3uC/Z+LeD+4RioLvH5lYtzaqfXwPDIwoJ6
	 xHspLTBK6UG8TwPf2u7sMwV6FDe41CVmTbC9o33sAA58sONMHRntAnPBY5Gwz5+SZR
	 qYxO4jEqeXm0jcQCHO8LolSc7R0KiT+oSOXfZ1v0n82Gy/AsAIBUG6xqI33EZG9i/Y
	 SwDQ3HyyBerNg==
Date: Tue, 25 Aug 2026 15:34:04 +0200
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
Message-ID: <20260825-hinab-kanarienvogel-mitschnitt-04a662533a24@brauner>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
 <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <20260822002111.GA6110@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260822002111.GA6110@frogsfrogsfrogs>

> > Without John's trust I'm not taking this on.
> 
> Whatever path you and John decide on, I would very much like to see the
> question of Which famfs driver do we merge? to be resolved for 7.4.

While it is reasonable to place limits on how long a series is pushed
out (I like to move with some speed myself.) we have two competing
implementations and that will have to play out. We should not merge an
fs just to finally merge _something_. The fact that this was more
contentious than usual doesn't imply we need to merge a version, doesn't
matter which one it is. That's a bad reason.
