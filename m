Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0362749E6;
	Sat, 22 Aug 2026 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787420431; cv=none; b=iBKhANkymQ3H/8MwsGEiLu5JFITxlOgLQGFFB/BGkWTuDkaOSbMUOLdBkf8TZpjRIiwsfPC6V/ksjhIgIJNu4FU7if7coEyw4ax4C94CvFx+oY97eddz538HA6XXrPyLEhR+So6nhwICqBLqi0isaTEv3eTgn52B430wZvx4waY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787420431; c=relaxed/simple;
	bh=ZeaG3d8C/dRlsdbnek4+Mt7ZXOo+f+HVPe+1S2rLlyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CclazupiLt1m813+JKYjvz7z5+/4RbcyKp4BmbAhFWKOKImOJLI9R31IBu9SK4btzUTgnWiruDHPqlfvf3M1+SNDTjGwzfLShYeuRRDJp/PjMRbhy+lR0d5SNEYT0Dr6EIkeGx8Du73KvnRNIaVrU1adwba4wz8zBIGx2+iMwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pm7zCPmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pm7zCPmZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 32DFE1F000E9;
	Sat, 22 Aug 2026 17:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787420430;
	bh=2fVmAFwgP/RzGE9tCrs/WJ4ZQQ7r5DhZEh60n3vG5sU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pm7zCPmZ3EpXPLgeuc0Ze5FazXehjopXqHFcFtsPWNfNS3tTzLCY38WNVsmanbyW1
	 t/L/9u/79loC0LqRDkPJTA/X/cAJIEqgcaK1o3dXT9ESU19sU5/sUShPurFSAFrUnT
	 gQMxBYCbwWTyuYlsjnJ8Dmgs9jLMeIUJR7WV/KXmqVCT/QwzqZZ8c8a8AE8Yfsx6FG
	 rkOVez6sd0GDw3bvFaD4yEqTF+edRuJgPBEC9KKfjTd8Lt4zdGloVEocTHQGPaPLUn
	 1NxjzycuIpBgOepicbLQnhGkeORygTGzLs8neXZTKo1UXXs4Zbq23M4UDG+Q6ILsnT
	 SNPl3IPwd2vQg==
Date: Sat, 22 Aug 2026 10:40:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <djbw@kernel.org>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
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
Subject: Re: [PATCH v13 10/12] famfs: Add runtime operation-permission (opts)
 framework
Message-ID: <20260822174029.GC6110@frogsfrogsfrogs>
References: <0100019fed5850ec-2bdfb17a-3086-44ea-8fdd-777d3ce12a33-000000@email.amazonses.com>
 <20260810202539.96378-1-john@jagalactic.com>
 <0100019fed5a5210-a09f1bdb-c705-44fc-8108-a7e7995a7af0-000000@email.amazonses.com>
 <20260822000728.GB6047@frogsfrogsfrogs>
 <aokdSo9li0RtEt35@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aokdSo9li0RtEt35@gourry-fedora-PF4VCD3F>

On Sat, Aug 22, 2026 at 12:18:58AM -0400, Gregory Price wrote:
> On Fri, Aug 21, 2026 at 05:07:28PM -0700, Darrick J. Wong wrote:
> > 
> > But what prevents a malicious program that is /not/ the famfs client
> > software but has CAP_SYS_ADMIN from doing that?
> > 
> 
> Such a program can already unmount famfs, rebind the device to
> device_dax, and mmap the whole range directly. MAP_CREATE isn't
> handing it reach it didn't have.

Thinking about this a little more -- some random root process that
accidentally tries to create/modify a directory tree on a famfs mount
will just end up with fmap-less files that won't work for IO or
mmapping.  That's dorky, but I think you're right that it's no big deal.

A bigger question I just thought of is sharing cxlmem between files (aka
reflink).  Is that allowed?  I could see a theoretical usecase for
programs A and B wanting to share some cxlmem for communication or
heartbeats whilst having their own /a and /b files for their private
memory.  Probably you'd just create a /common file to do that and not
map the same cxlmem page into /a and /b, right?

But having said that, the fsdax code /can/ support sharing between
files, so I wonder if famfs is prepared either (a) to enable that
sharing or (b) reject a mapping that would overlap with an existing
mapping?  Things will go very badly in the kernel if famfs doesn't set
up the dax_folio state correctly.

--D
