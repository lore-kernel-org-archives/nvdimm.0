Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A6B2DAFD7;
	Wed, 15 Apr 2026 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776265827; cv=none; b=qivl11WjJyI81CAnMseYlduQMdbkvW6iFQyoDOopm+FBsZAMDxYMW68MMl71UxSCk/oGSkKm0GSh0MNauwcBXCGCVhE0hCwZXSIxje1+fdol0z9xT/BMugLTjBTcmfivDBc4SElPsz/sy/VvVM373FwZamENrZf19X5U2yiPTBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776265827; c=relaxed/simple;
	bh=yHb1dWk2Vi/3kjBAIirLK/D5eHjwHRIFDKNF39m3SFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCR+Y5rEzie0Nv2bPjnsWATX1rHCuyzoOBIKyPsyACv6eVc9rYGp3oGxSprcO1y36fy6xvz62uT7dnQYcSXCpG4RfrtwTL5mLjBxc3vRD/K3I9ufFgf9v2gFeeDAibb1w6xUwXIN852GrfI+lpOQkWjfGXGgj0hznh1LZTSJ7Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JeAdh/jK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JeAdh/jK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FjdkDuZrAakO4bZaNk4hPtCRJU5ObDFajb298D8gE2M=; b=JeAdh/jK6zrXFm9bYtdN/AToKA
	68WvS5kirxw2K5MZP5F9tckhJXpOzgBvOm1tLdFkjkx1Mu8h6qZTSDtAFjIV5NMIB2HQyHul6HPcm
	qXwU5iCSHEaohnJ3eBeKuci2dHZW/Afi6QbyJAtJe793cKYt+PqMGdj+ejxj93e67QfkpJCl+pBNJ
	4uQQOkTeHp5rC61R7y9dy1exZl9TQDrb1JIj1SWYEhjQac8oPkolls6UeQXtgzisQCO3LdwPrlDD1
	t5imBUekyKRvTsSTIylhFjmo6yI0Kko9fkNa0vDZSZ0SH8sUqcskdrAIMXb4VL7fsmwdKYfTOZUk5
	CqPYMltA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD1sO-000000002lg-3I9m;
	Wed, 15 Apr 2026 15:10:00 +0000
Date: Wed, 15 Apr 2026 16:10:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
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
Message-ID: <ad-qSB4oL5D3S-ht@casper.infradead.org>
References: <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F>
 <CAJfpegsUVv0ziMSQiq9pKeXf6G-+LROPTW077hHMSmAirVCLQw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsUVv0ziMSQiq9pKeXf6G-+LROPTW077hHMSmAirVCLQw@mail.gmail.com>

On Wed, Apr 15, 2026 at 04:04:50PM +0200, Miklos Szeredi wrote:
> On Wed, 15 Apr 2026 at 15:35, Gregory Price <gourry@gourry.net> wrote:
> 
> > This was my first reaction when I realized the BPF program would be
> > controlling iomap return value in the fault path.  Big ol' (!)  popped
> > up over my head.
> 
> I'm wondering which part of this triggers the big (!).
> 
> BPF program being run in the fault path?
> 
> Or that the return value from the BPF function is used as iomap?
> 
> Or something else?

If a BPF program controls what memory address a fault now allows access
to, who validates that this is a memory address within the purview of
the BPF program, and not, say, the address of the kernel page tables?

(I have done no looking to determine if this is already considered)
