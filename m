Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629263DD50C;
	Wed, 15 Apr 2026 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776266924; cv=none; b=I75et184mqQwVyWGAeokG7PnTgAAaQciIyAMKFL2cb59906ORolir0Xl1qOQAHPAWYBpXPDRFw5FfrNmxJ7FZB/BNLdqRGR7xZgQ5CsPJmoAOZ7oKGwe3NvAi5xIrtyY8MpZD26c8EKqPbJxwZ8AaTVWG5UZA/bxFRWoHuXBTy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776266924; c=relaxed/simple;
	bh=ufsmAtOD0yHw+RsgJJ4sXSOPoeLwmzYUhCQwaCzodcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X648Ttip2OuZEEYMUccAHjMU/yc/LnhGRStjv01zlqt0DUrlCfPl8DpjQEeI9G+ZUf2CLSOYGWsRlo39vGDc54WXs+7GJOJmZAcS3uKSMm6c9Ec1C/ktqCpsV81Z/FJ2vTAX6SA8CeEDshN17djKjKcdLspzUvwBOfcKbFP5rGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npV2ST4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npV2ST4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59C8C19424;
	Wed, 15 Apr 2026 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266924;
	bh=ufsmAtOD0yHw+RsgJJ4sXSOPoeLwmzYUhCQwaCzodcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=npV2ST4DkuRvF76smD+WhL358pUDN+1WaEf6e2MqTIyik0S5HsHen588IZ+wqVe2P
	 mMtIfCmHNBEX4LzOuprBT5H36CXtGSp52Acgbj+W3Rpg5xspJCtOWotn8k6RTRh8ht
	 4CtTK8ULkLg9KSACPGhICaleBVYa/p7xiGuZ0GYFctspAbrHINsvwwYV/ilXKDb5jO
	 4VZl9Qr2bL8aL0ve/8RP00YUJDGT6iKQzuakc22cTPQgIRDsoFp63XU3Cpm73MUia5
	 CLIJQoGLYYc1JgzpbAUHafgTDRWbLXg4vIoKtEPW1If+x9a0ZUsaToluhAcVm8uYbF
	 DLlmHM0etiPxA==
Date: Wed, 15 Apr 2026 08:28:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	John Groves <John@groves.net>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <20260415152842.GB114184@frogsfrogsfrogs>
References: <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F>
 <CAJfpegsUVv0ziMSQiq9pKeXf6G-+LROPTW077hHMSmAirVCLQw@mail.gmail.com>
 <ad-qSB4oL5D3S-ht@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad-qSB4oL5D3S-ht@casper.infradead.org>

On Wed, Apr 15, 2026 at 04:10:00PM +0100, Matthew Wilcox wrote:
> On Wed, Apr 15, 2026 at 04:04:50PM +0200, Miklos Szeredi wrote:
> > On Wed, 15 Apr 2026 at 15:35, Gregory Price <gourry@gourry.net> wrote:
> > 
> > > This was my first reaction when I realized the BPF program would be
> > > controlling iomap return value in the fault path.  Big ol' (!)  popped
> > > up over my head.
> > 
> > I'm wondering which part of this triggers the big (!).
> > 
> > BPF program being run in the fault path?
> > 
> > Or that the return value from the BPF function is used as iomap?
> > 
> > Or something else?
> 
> If a BPF program controls what memory address a fault now allows access
> to, who validates that this is a memory address within the purview of
> the BPF program, and not, say, the address of the kernel page tables?
> 
> (I have done no looking to determine if this is already considered)

We're not using bpf to implement ->filemap_fault directly.  fuse would
implement that as a call to dax_iomap_fault, iomap would then call
fuse's ->iomap_begin, and that's where the bpf program would take over.
The mapping provided would return a (struct dax_device, u64 addr, u64
length), and (presumably) the dax device access function would
rangecheck that.

Unless someone foolishly puts kernel page tables on the dax device...

--D
