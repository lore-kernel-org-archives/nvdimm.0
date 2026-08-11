Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F3041A77C;
	Tue, 11 Aug 2026 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786440308; cv=none; b=R9Op5ZDGHzKhJzZEHDmUiF1tzkf9dIXe12BKs0LFY20JAfGYyrhw/o18QcfQvABBH7lI5cGXOc9khkhMGGK/LcNNE7D6keIweryIJB67awFh9NiaGkOPKcKeVmB5Kv5Jo9MIW0G9tkYWIfWbGsp6nvg3FI13gESSpGFqAgs7S4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786440308; c=relaxed/simple;
	bh=rW4Gn8nuPAChuOaOAphRZUDkedE+y6quD4t7euLTO2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcLUX1yJsre2nCVsWZ+Am4x6jp554bxejjk0nGxJdPPNx1Gn+rr2k3nQgXF3qHtbrCZwaTxrS++vz2sUVyvSrJjjmJDEzCA+Kqwwrcoh11rTNlcoGD0P353EHP7KdRqrnDYRYRHZmaDRyis5zLP1L1iO/wwhpwMw/YJdwf6V8QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0Aq5Cvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0Aq5Cvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D71F000E9;
	Tue, 11 Aug 2026 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786440303;
	bh=1d60DmOiyf9vsbdMyOWLJ3UiUYY8mb2XIfOf8L0jGDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j0Aq5Cvyz+T1Uud910iFya0piC9xc+brcKgCD1Db6hjJr3STNtbaXxFVUwpuXwqBz
	 TQQJ+uvbdjhto04m+YOzULdfS3vs+J+3utCDaw+WRfEFYvk7xkEkY2+TSqQfFlukjZ
	 Q/Jao7LxvvZfOINF15S0zz5HaO2AbStAErUS6/mP8FTWHCRV69piYvapF6a6RGyr3F
	 4mVy/kXkRALUb7iVBbAe5jRVfXuBIALgZiTA2Wf0QZK3x9HjrLQxGhZGuA2KpOqZOl
	 6uZnLkcBX86LvDtxdh6nmS26Vl4JyZC4nAlKmoQEfTzTxZ2rqeTy83L1BWpayRjojT
	 LceiMr3EkrCNA==
Date: Tue, 11 Aug 2026 11:24:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	John Groves <john@jagalactic.com>, John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <jic23@kernel.org>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
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
Message-ID: <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner>
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com>
 <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
 <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>

On Tue, Aug 11, 2026 at 10:59:50AM +0200, Miklos Szeredi wrote:
> On Thu, 6 Aug 2026 at 06:37, Darrick J. Wong <djwong@kernel.org> wrote:
> 
> > IOWs, let's fix the remaining wobbles (if any) and just merge this
> > already.  No more side quests through gigantic refactorings of fusex,
> > that's too much to ask after you already redesigned and reimplemented
> > the whole thing already.
> 
> Without any intention to change the direction, let me just state some facts:
> 
>  - it was never suggested that famfs depend on the fusex work in any way
> 
>  - the plan to add famfs mappings to fuse was laid out two and a half
> years ago in reply to the very first rfc posting and has basically
> remained unchanged since then:
> 
> https://lore.kernel.org/all/CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com/
> 
> I understand how that seemingly simple API addition was overwhelming
> for John, and I should have been more proactive in helping with the
> implementation.  That's entirely my fault.
> 
> On the other hand John could have been more trusting that the plan will work.
> 
> But that's behind us now, let's move on...

with fuse, please...
